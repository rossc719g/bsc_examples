#!/bin/bash -e

./clean.sh
. ./functions.sh

# Compile Beef.bsv
source_files=(./beef/Beef.bsv)
expected_outputs=(
  ./beef/Beef.bo
  ./beef/beef.ba
  ./beef/vpi_wrapper_beef.{c,h}
)
BSC \
  -verilog \
  -vdir ./beef \
  ./beef/Beef.bsv
# ^ succeeds
