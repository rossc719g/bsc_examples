#!/bin/bash -e

../clean.sh
. ../functions.sh

path_flags="$(path_dir_flags ./code)"

source_files=(./code/MissingCaseArm.bs)
expected_outputs=(./code/MissingCaseArm.bo)

num_modules=3

for n in $(seq 1 $num_modules); do
  modules+=(mkMissingCaseArm${n} mkMissingCaseArm${n}Warn)
done

g_args=""
for module in ${modules[@]}; do
  expected_outputs+=(./code/${module}.v)
  g_args+="-g ${module} "
done

BSC $path_flags -verilog $g_args ./code/MissingCaseArm.bs
