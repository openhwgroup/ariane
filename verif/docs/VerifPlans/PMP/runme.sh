#############################################################################
# Copyright (C) 2022 Thales DIS France SAS
#
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0.
#
# Original Author: Zbigniew Chamski (zbigniew.chamski@thalesgroup.com)
#############################################################################
#!/bin/sh

# Location of project-specific directories
ROOTDIR=`readlink -f $(dirname "${BASH_SOURCE[0]}")`

# Set up platform location.  It can be anywhere but should contain
# a valid `vp_config.py` file in `vptool` directory.
# Here we use the verification tree from the example directory.
export PLATFORM_TOP_DIR="$ROOTDIR"

# Set the printable name for the project that will be used
# in the human-readable documentation.
export PROJECT_NAME="PMP"

# Set the alphanumerical identifier of the project that
# will be used to construct file names etc.
export PROJECT_IDENT="PMP"

# Set the destination directory of Markdown files for this project.
# Since it will be used by VPTOOL, it shall NOT be a relative path.
export MARKDOWN_OUTPUT_DIR=`readlink -f "$ROOTDIR/../source"`

# Run VPTOOL overriding the default theme from Yaml config with 'winxpblue'.
# FIXME: Introduce a suitably named shell variable that points to the root
# directory of the tool set (TOOL_TOP etc.)
# FORNOW use a hardcoded relative path.
sh $ROOTDIR/../../../core-v-verif/tools/vptool/vptool.sh $*
