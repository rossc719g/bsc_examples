#!/bin/bash -e

./clean.sh
. ./functions.sh

# Compile Beef.bsv
source_files=(./beef/Beef.bsv)
expected_outputs=(./beef/Beef.bo ./beef/beef.ba ./beef/vpi_wrapper_beef.{c,h})
BSC -verilog ./beef/Beef.bsv # Without -vdir
# ^ fails because vpi_wrapper files are not generated in ./beef/
