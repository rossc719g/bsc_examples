# runtime_flake

This example demonstrates a flaky runtime error when running bluesim executables
on a M2 mac.

I am using the `bsc-2023.01-macos-12` version of the compiler downloaded from
https://github.com/B-Lang-org/bsc/releases/tag/2023.01

It seems to be a rare error, but I can reproduce it consistently on my machine
using this example.

To replicate, just execute `./run.sh` in this dir.

When I run it on my mac, I get about a 0.015% failure rate, and see
errors like this:
```
============================================================
Job 107 Failed with exit code 1.  Output in ./runtime_flake_000107.log:
sem_open: File exists
sem_open: File exists
Error: Unable to load model ./code/mkTrivial.exe.so
    invoked from within
"sim load $model_name $top_module"
    (file "/opt/tools/bsc/latest/lib/tcllib/bluespec/bluesim.tcl" line 188)
============================================================
...
============================================================
Ran 50000 jobs.
Failed 8 times out of 50000.  (.016%) failure rate.
```