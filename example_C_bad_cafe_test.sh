#!/bin/bash -e

./clean.sh
. ./functions.sh

# A working example to compile the CafeTest.

# First, compile Cafe.bsv
source_files=(./cafe/Cafe.bsv)
expected_outputs=(./cafe/Cafe.bo ./cafe/cafe.ba ./cafe/vpi_wrapper_cafe.{c,h})
BSC -verilog $(path_dir_flags ./cafe) ${source_files[@]}

# Next compile the test.
source_files=(./cafe/test/CafeTest.bs)
implicit_files=(./cafe/Cafe.bo ./cafe/cafe.ba)
expected_outputs=(./cafe/test/CafeTest.bo ./cafe/test/mkCafeTest.v)
BSC -verilog $(path_dir_flags ./cafe/test) -g mkCafeTest ${source_files[@]}

# Copy the vpi_wrapper files to the directory where the executable is being
# generated.
cp -v ./cafe/vpi_wrapper_cafe.{c,h} ./cafe/test

# Link the test into an executable.
source_files=(./cafe/cafe.c ./cafe/cafe.ba)
implicit_files=(./cafe/test/CafeTest.bo ./cafe/test/mkCafeTest.v
  ./cafe/test/vpi_wrapper_cafe.{c,h})
expected_outputs=(./cafe/test/CafeTest.exe
  ./directc_mkCafeTest.so) # !! In the cwd, not with the exe.
extra_outputs=(./cafe/cafe.o ./cafe/test/vpi_wrapper_cafe.o
  ./cafe/test/vpi_startup_array.{c,o})
BSC -verilog $(path_dir_flags ./cafe/test) \
  -o ./cafe/test/CafeTest.exe -e mkCafeTest ${source_files[@]}

# Run the test.
echo -e "\nFrom the top level directory:"
./cafe/test/CafeTest.exe
# ^ succeeds

(
  echo -e "\nFrom the cafe/test directory:"
  cd ./cafe/test
  ./CafeTest.exe
)
# ^ fails because it can't find directc_mkCafeTest.so
