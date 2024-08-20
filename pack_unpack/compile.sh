#!/bin/bash -e

../clean.sh
. ../functions.sh

path_flags="$(path_dir_flags ./code)"

source_files=(./code/PackUnpack.bs)
expected_outputs=(./code/PackUnpack.bo)
expected_outputs+=(./code/mkPackUnpack.v)
BSC $path_flags -verilog -g mkPackUnpack ./code/PackUnpack.bs
