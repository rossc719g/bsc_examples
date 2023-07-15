#!/bin/bash -e

./clean.sh
. ./functions.sh

# This example shows that the linking step fails if the vpi_wrapper files are
# not in the directory where the executable is being generated.

# First, compile Beef.bsv
source_files=(./beef/Beef.bsv)
expected_outputs=(./beef/Beef.bo ./beef/beef.ba ./beef/vpi_wrapper_beef.{c,h})
BSC -verilog $(path_dir_flags ./beef) ${source_files[@]}

# Next, compile Cafe.bsv
source_files=(./cafe/Cafe.bsv)
expected_outputs=(./cafe/Cafe.bo ./cafe/cafe.ba ./cafe/vpi_wrapper_cafe.{c,h})
BSC -verilog $(path_dir_flags ./cafe) ${source_files[@]}

# Next compile the test.
source_files=(./test/BeefCafeTest.bs)
implicit_files=(./beef/Beef.bo ./beef/beef.ba ./cafe/Cafe.bo ./cafe/cafe.ba)
expected_outputs=(./test/BeefCafeTest.bo ./test/mkBeefCafeTest.v)
BSC -verilog $(path_dir_flags ./test) -g mkBeefCafeTest ${source_files[@]}

# Link the test into an executable.
source_files=(./test/mkBeefCafeTest.v
  ./beef/beef.c ./beef/beef.ba ./cafe/cafe.c ./cafe/cafe.ba)
implicit_files=(./test/BeefCafeTest.bo
  ./beef/vpi_wrapper_beef.{c,h} ./cafe/vpi_wrapper_cafe.{c,h})
expected_outputs=(./test/BeefCafeTest.exe)
BSC -verilog $(path_dir_flags ./test) \
  -o ./test/BeefCafeTest.exe -e mkBeefCafeTest ${source_files[@]}
# ^ fails because it can't find ./test/vpi_wrapper_{beef,cafe}.{c,h}
