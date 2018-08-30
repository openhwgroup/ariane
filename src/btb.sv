
// ------------------------------
// Branch Prediction
// ------------------------------

// branch target buffer
module btb #(
    parameter int NR_ENTRIES = 8
)(
    input  logic               clk_i,           // Clock
    input  logic               rst_ni,          // Asynchronous reset active low
    input  logic               flush_i,         // flush the btb

    input  logic [63:0]        vpc_i,           // virtual PC from IF stage
    input  btb_update_t        btb_update_i,    // update btb with this information
    output btb_prediction_t    btb_prediction_o // prediction from btb
);
    // number of bits which are not used for indexing
    localparam OFFSET = 1; // we are using compressed instructions so do use the lower 2 bits for prediction
    localparam ANTIALIAS_BITS = 8;
    // number of bits we should use for prediction
    localparam PREDICTION_BITS = $clog2(NR_ENTRIES) + OFFSET;
    // typedef for all branch target entries
    // we may want to try to put a tag field that fills the rest of the PC in-order to mitigate aliasing effects
    btb_prediction_t btb_d [NR_ENTRIES-1:0], btb_q [NR_ENTRIES-1:0];
    logic [$clog2(NR_ENTRIES)-1:0]          index, update_pc;

    assign index     = vpc_i[PREDICTION_BITS - 1:OFFSET];
    assign update_pc = btb_update_i.pc[PREDICTION_BITS - 1:OFFSET];

    // output matching prediction
    assign btb_prediction_o = btb_q[index];

    // -------------------------
    // Update Branch Prediction
    // -------------------------
    // update on a mis-predict
    always_comb begin : update_branch_predict
        btb_d = btb_q;

        if (btb_update_i.valid) begin
            btb_d[update_pc].valid = 1'b1;
            // the target address is simply updated
            btb_d[update_pc].target_address = btb_update_i.target_address;
            // as is the information whether this was a compressed branch
            btb_d[update_pc].is_lower_16    = btb_update_i.is_lower_16;
            // check if we should invalidate this entry, this happens in case we predicted a branch
            // where actually none-is (aliasing)
            if (btb_update_i.clear) begin
                btb_d[update_pc].valid = 1'b0;
            end
        end
    end

    // sequential process
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (~rst_ni) begin
            // Bias the branches to be taken upon first arrival
            for (int i = 0; i < NR_ENTRIES; i++)
                btb_q[i] <= '{default: 0};
        end else begin
            // evict all entries
            if (flush_i) begin
                for (int i = 0; i < NR_ENTRIES; i++) begin
                    btb_q[i].valid <=  1'b0;
                end
            end else begin
                btb_q <=  btb_d;
            end
        end
    end
endmodule
