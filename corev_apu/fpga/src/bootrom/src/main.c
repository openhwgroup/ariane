// Copyright OpenHW Group contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "uart.h"
#include "spi.h"
#include "sd.h"
#include "gpt.h"

// 1 second at 50MHz
#define SECOND_CYCLES   (50 * 1000 * 1000)
#define WAIT_SECONDS    (5)

static inline uintptr_t get_cycle_count() {
    uintptr_t cycle;
    __asm__ volatile ("csrr %0, cycle" : "=r" (cycle));
    return cycle;
}

int update(uint8_t *dest)
{
    int i;
    uint32_t size = 0;

    print_uart("receiving boot image\r\nsize: ");
    for(i = 0; i < sizeof(uint32_t); i++) {
        while(!read_serial(&((uint8_t *) &size)[i]));
    }

    print_uart_int(size);
    print_uart("\r\nreceiving ");

    for(i = 0; i < size; i++) {
        while(!read_serial(&dest[i]));

        if(i % (size >> 4) == 0) {
            print_uart(".");
        }
    }

    print_uart(" done!\r\n");
    return 0;
}

int main()
{
    int i, ret = 0;
    uint8_t uart_res = 0;
    uintptr_t start;

    #ifndef PLAT_AGILEX
    init_uart(CLOCK_FREQUENCY, UART_BITRATE); //not needed in intel setup as UART IP is already configured via HW
    #endif 
    print_uart("Hello World!\r\n");

    // See if we should enter update mode
    print_uart("Hit any key to enter update mode ");
    for(i = 0; i < WAIT_SECONDS && !ret; i++) {
        print_uart(".");
        start = get_cycle_count();
        while(get_cycle_count() - start < SECOND_CYCLES) {
            ret = read_serial(&uart_res);
            if(ret) {
                break;
            }
        }
    }

    int res;
    if(ret) {
        print_uart(" updating!\r\n");
        res = update((uint8_t *)0x80000000UL);
    } else {
        print_uart(" booting!\r\n");
        #ifndef PLAT_AGILEX
        res = gpt_find_boot_partition((uint8_t *)0x80000000UL, 2 * 16384); // linux boot not yet supported for altera
        #endif 
    }

    #ifndef PLAT_AGILEX // linux boot not yet supported for altera
    if (res == 0)
    {
        // jump to the address
        __asm__ volatile(
            "li s0, 0x80000000;"
            "la a1, _dtb;"
            "jr s0");
    }
    #endif 

    while (1)
    {
        // do nothing
    }
}

void handle_trap(void)
{
    // print_uart("trap\r\n");
}
