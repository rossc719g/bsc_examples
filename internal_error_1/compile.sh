#!/bin/bash -e

../clean.sh
. ../functions.sh

# Compile Raw.bs
source_files=(./code/Raw.bs)
expected_outputs=(./code/Raw.bo)
BSC ./code/Raw.bs
