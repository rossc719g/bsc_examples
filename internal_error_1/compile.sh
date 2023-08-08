#!/bin/bash -e

../clean.sh
. ../functions.sh

path_flags="$(path_dir_flags ./code)"

source_files=("./code/Raw.bs")
expected_outputs=("./code/Raw.bo")
BSC $path_flags ./code/Raw.bs

source_files=("./code/Mux.bs")
expected_outputs=("./code/Mux.bo")
implicit_files=("./code/Raw.bo")
BSC $path_flags ./code/Mux.bs
