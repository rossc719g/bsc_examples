#!/bin/bash -e

../clean.sh
rm -fv code/*.bsv # bsc2bsv will create these.
. ../functions.sh

path_flags="$(path_dir_flags ./code)"

# This compiles, though I feel it really shouldn't.
source_files=(./code/ThingWithExtraNames.bs)
expected_outputs=(./code/ThingWithExtraNames.bo)
expected_outputs+=(./code/mkThingWithExtraNames.v)
BSC $path_flags -verilog -g mkThingWithExtraNames ./code/ThingWithExtraNames.bs

set +e # The rest will all fail to compile, but we want to keep going.

# This doesn't compile, but the error it generates is poor.
source_files=(./code/ThingWithTooFewNames.bs)
expected_outputs=(./code/ThingWithTooFewNames.bo)
expected_outputs+=(./code/mkThingWithTooFewNames.v)
BSC $path_flags -verilog -g mkThingWithTooFewNames ./code/ThingWithTooFewNames.bs

# Ideally both would not compile, and give good error messages.

# Just for fun, do the same with bsv:
bsc2bsv code/ThingWithExtraNames.bs >code/ThingWithExtraNames.bsv
bsc2bsv code/ThingWithTooFewNames.bs >code/ThingWithTooFewNames.bsv

# This fails to compile with some unrelated (I think?) error.
source_files=(./code/ThingWithExtraNames.bsv)
expected_outputs=(./code/ThingWithExtraNames.bo)
expected_outputs+=(./code/mkThingWithExtraNames.v)
BSC $path_flags -verilog -g mkThingWithExtraNames ./code/ThingWithExtraNames.bsv

# This doesn't compile, because the interface declaration has a method with one
# argument, but the implementation is for a method with two arguments.  (If you
# fix that manually, you end up with the same error as the previous case.)
source_files=(./code/ThingWithTooFewNames.bsv)
expected_outputs=(./code/ThingWithTooFewNames.bo)
expected_outputs+=(./code/mkThingWithTooFewNames.v)
BSC $path_flags -verilog -g mkThingWithTooFewNames ./code/ThingWithTooFewNames.bsv
