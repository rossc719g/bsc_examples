#!/bin/bash -e

../clean.sh
. ../functions.sh

path_flags="$(path_dir_flags ./code)"

# This compiles, though I feel it really shouldn't.
source_files=(./code/ThingWithExtraNames.bs)
expected_outputs=(./code/ThingWithExtraNames.bo)
expected_outputs+=(./code/mkThingWithExtraNames.v)
BSC $path_flags -verilog -g mkThingWithExtraNames ./code/ThingWithExtraNames.bs

# This doesn't compile, but the error it generates is poor.
source_files=(./code/ThingWithTooFewNames.bs)
expected_outputs=(./code/ThingWithTooFewNames.bo)
expected_outputs+=(./code/mkThingWithTooFewNames.v)
BSC $path_flags -verilog -g mkThingWithTooFewNames ./code/ThingWithTooFewNames.bs

# Ideally both would not compile, and give good error messages.
