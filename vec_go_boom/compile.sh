#!/bin/bash -e

../clean.sh
. ../functions.sh

TIMEOUT=60
path_flags="$(path_dir_flags ./code)"

source_files=(./code/VecGoBoom.bs)
BSC $path_flags ./code/VecGoBoom.bs
