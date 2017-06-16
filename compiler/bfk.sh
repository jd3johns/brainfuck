#!/bin/bash
#
# Compile brainfuck programs by transpiling to C then to
# executable program; however an intermediary source disk write
# is avoided via process substitution. This script requires a
# functioning brainfuck compiler.
#
# Author: Jonathan Johnston
# Date:   2017/6/15
#

BFK=$(basename $0)
BF_SRC=$1
BF_DEST=$2

: "${BF_COMPILER:?Please set BF_COMPILER env var}"

usage() {
    echo "Usage: ${BFK} source.b [destination]"
    echo "Compile brainfuck source into an executable program."
    exit 1
}

if [ -z ${BF_SRC} ]
then
    echo "${BFK}: No file given"
    usage
fi

if [ ! -f ${BF_SRC} ]
then
    echo "${BFK}: ${BF_SRC} does not exist"
    usage
fi

SRC_EXT=${BF_SRC##*.}
if [ ${SRC_EXT} != "b" ]
then
    echo "${BFK}: ${BF_SRC} is not a brainfuck file"
    usage
fi

if [ -z ${BF_DEST} ]
then
    # Trim off the leading path and extension.
    BF_DEST=$(basename ${BF_SRC%.*})
fi

# Give a hint to GCC about the input language to avoid a seek
# on a process substitution (like the read end of a named pipe).
gcc -x c -o ${BF_DEST} <(${BF_COMPILER} ${BF_SRC})
