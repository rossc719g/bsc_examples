#!/bin/bash -e

../clean.sh
. ../functions.sh

path_flags="$(path_dir_flags ./code)"

source_files=(./code/MakeNegative.bs)
expected_outputs=(./code/MakeNegative.bo)
BSC $path_flags ./code/MakeNegative.bs
