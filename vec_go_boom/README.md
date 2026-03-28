# vec_go_boom

This example demonstrates a pathological typechecker failure involving a .bs
implementation of `vec`, a curried, variable-arity constructor for Vectors.

The repro here gives `vec` a `Vector n Float` context, but accidentally passes
the polymorphic `fpNeg` function as the first vector element.

```bsv
fpNeg :: FloatingPoint e m -> FloatingPoint e m
fpNeg fp = fp { sign = not fp.sign }

boom :: Fmt
boom = showVec (vec fpNeg 0.0 1.0 2.0 3.0)
```

Expected behavior:

- An error, and then the compiler terminates promptly.

Observed behavior:

- The compiler prints a `T0033` ambiguity error, and then continues consuming
  CPU and memory instead of terminating promptly. Memory is consumed at about
  1GB every 2 seconds or so.
- With the current `compile.sh` settings, the run times out after 60 seconds and
  uses about 20GB of memory.
- `bsc-2025.07` and `bsc-2026.01` both reproduce.

Files in this directory:

- `code/VecGoBoom.bs` contains the minimized source.
- `compile.sh` runs the repro.

Safety notes:

- `compile.sh` uses `TIMEOUT=60` to prevent the compiler from spinning out.
- `BSC=/path/to/bsc ./compile.sh` selects a compiler while keeping the timeout.
