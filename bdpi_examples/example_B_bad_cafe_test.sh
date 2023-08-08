#!/bin/bash -e

../clean.sh
. ../functions.sh

# First, compile Cafe.bsv
source_files=(./cafe/Cafe.bsv)
expected_outputs=(./cafe/Cafe.bo ./cafe/cafe.ba ./cafe/vpi_wrapper_cafe.{c,h})
BSC -verilog $(path_dir_flags ./cafe) ${source_files[@]}

# Next compile the test.
source_files=(./cafe/test/CafeTest.bs)
implicit_files=(./cafe/Cafe.bo ./cafe/cafe.ba)
expected_outputs=(./cafe/test/CafeTest.bo ./cafe/test/mkCafeTest.v)
BSC -verilog $(path_dir_flags ./cafe/test) -g mkCafeTest ${source_files[@]}

# Link the test into an executable.
source_files=(./cafe/cafe.c ./cafe/cafe.ba)
implicit_files=(./cafe/test/CafeTest.bo ./cafe/test/mkCafeTest.v
  ./cafe/vpi_wrapper_cafe.{c,h})
expected_outputs=(./cafe/test/CafeTest.exe ./directc_mkCafeTest.so)
extra_outputs=(./cafe/cafe.o ./cafe/test/vpi_wrapper_cafe.o
  ./cafe/test/vpi_startup_array.{c,o})
BSC -verilog $(path_dir_flags ./cafe/test) \
  -o ./cafe/test/CafeTest.exe -e mkCafeTest ${source_files[@]}
# ^ fails because it can't find ./cafe/test/vpi_wrapper_cafe.{c,h}
