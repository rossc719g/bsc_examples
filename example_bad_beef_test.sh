#!/bin/bash -e

./clean.sh
. ./functions.sh

# First, compile Beef.bsv
source_files=(./beef/Beef.bsv)
expected_outputs=(
  ./beef/Beef.bo
  ./beef/beef.ba
  ./beef/vpi_wrapper_beef.{c,h}
)
BSC \
  -verilog \
  $(path_dir_flags ./beef) \
  ${source_files[@]}

# Next compile the test.
source_files=(./beef/test/BeefTest.bs)
implicit_files=(
  ./beef/Beef.bo
  ./beef/beef.ba
)
expected_outputs=(
  ./beef/test/BeefTest.bo
  ./beef/test/mkBeefTest.v
)
BSC \
  -verilog \
  $(path_dir_flags ./beef/test) \
  -g mkBeefTest \
  ${source_files[@]}

# Link the test into an executable.
source_files=(
  ./beef/test/mkBeefTest.v
  ./beef/beef.c
  ./beef/beef.ba
)
implicit_files=(
  ./beef/test/BeefTest.bo
  ./beef/vpi_wrapper_beef.{c,h}
)
expected_outputs=(
  ./beef/test/BeefTest.exe
  ./directc_mkBeefTest.so
)
extra_outputs=(
  ./beef/beef.o
  ./beef/test/vpi_startup_array.{c,o}
  ./beef/test/vpi_wrapper_beef.o
)
BSC \
  -verilog \
  $(path_dir_flags ./beef/test) \
  -o ./beef/test/BeefTest.exe \
  -e mkBeefTest \
  ${source_files[@]}
# ^ fails because it can't find ./test/vpi_wrapper_beef.{c,h}
