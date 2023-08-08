#!/bin/bash -e

../clean.sh
. ../functions.sh

path_flags="$(path_dir_flags ./code)"

# Libraries ---------------------------------------------------------------
source_files=(./code/Raw.bs)
expected_outputs=(./code/Raw.bo)
BSC $path_flags ./code/Raw.bs

source_files=(./code/Mux.bs)
expected_outputs=(./code/Mux.bo)
implicit_files=(./code/Raw.bo)
BSC $path_flags ./code/Mux.bs

# Working without errors --------------------------------------------------
source_files=(./code/MyMuxThing.bs)
expected_outputs=(./code/MyMuxThing.bo)
implicit_files=(./code/Raw.bo ./code/Mux.bo)
expected_outputs+=(./code/mkMyMuxThing.v)
BSC $path_flags -verilog -g mkMyMuxThing ./code/MyMuxThing.bs

# Causes an internal error ------------------------------------------------
source_files=(./code/MyRawMuxThing.bs)
expected_outputs=(./code/MyRawMuxThing.bo)
implicit_files=(./code/Raw.bo ./code/Mux.bo)
expected_outputs+=(./code/mkMyRawMuxThing.v)
BSC $path_flags -verilog -g mkMyRawMuxThing ./code/MyRawMuxThing.bs
