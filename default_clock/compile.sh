#!/bin/bash -e

../clean.sh
. ../functions.sh

path_flags="$(path_dir_flags ./code)"

# This compiles, though I feel it really shouldn't.
source_files=(./code/DefaultClock.bs)
expected_outputs=(./code/DefaultClock.bo)
expected_outputs+=(./code/mkDefaultClock.v)
BSC $path_flags -verilog -g mkDefaultClock ./code/DefaultClock.bs
