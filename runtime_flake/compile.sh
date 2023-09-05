#!/bin/bash -e

../clean.sh
. ../functions.sh

path_flags="$(path_dir_flags ./code)"

source_files=(./code/Trivial.bs)
expected_outputs=(./code/Trivial.bo ./code/mkTrivial.ba)
BSC $path_flags --sim -g mkTrivial ./code/Trivial.bs

source_files=(./code/mkTrivial.ba)
expected_outputs=(./code/mkTrivial.exe ./code/mkTrivial.exe.so)
extra_outputs=(
  ./code/mkTrivial.cxx
  ./code/mkTrivial.h
  ./code/mkTrivial.o
  ./code/model_mkTrivial.cxx
  ./code/model_mkTrivial.h
  ./code/model_mkTrivial.o
)
BSC $path_flags --sim -e mkTrivial -o ./code/mkTrivial.exe ./code/mkTrivial.ba
