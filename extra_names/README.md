# extra names

This example demonstrates something that should be an error but isn't.
Specifically, the `arg_names` pragma for interface methods does not check that
the number of names matches the number of arguments.

I am using the `bsc-2023.01-macos-12` version of the compiler downloaded from
https://github.com/B-Lang-org/bsc/releases/tag/2023.01

I am able to generate Verilog for `mkThingWithExtraNames` without error, but it
really should not compile.

Interestingly, `mkThingWithTooFewNames` does generate an error, as expected, but
the error message is just `Prelude.!!: index too large%` which is not very
helpful, and contains no line numbers or even filenames.

To replicate, just execute `./compile.sh` in this dir.
