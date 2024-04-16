#!/bin/bash -e

../clean.sh
. ../functions.sh

path_flags="$(path_dir_flags ./code)"

# This compiles, though I feel it really shouldn't.
source_files=(./code/PhantomAlias.bs)
expected_outputs=(./code/PhantomAlias.bo)
expected_outputs+=(./code/mkPhantomVecRegDut.v)
BSC $path_flags -g mkPhantomVecRegDut -verilog ./code/PhantomAlias.bs
