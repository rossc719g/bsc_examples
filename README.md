# bsc_examples

Some examples for https://github.com/B-Lang-org/bsc/discussions/575

# The source files:
  - `beef/Beef.bsv`
    - Contains a `BDPI` import called `beef_c` for the C function `beef`.
  - `beef/beef.c`
    - Contains the implementation of `beef`.
      Just fills a variable-sized buffer with repeated 0xdeadbeef words.
  - `beef/test/BeefTest.bs`
      - Contains a test for the imported `BDPI` function.
  - `cafe/*`
      - Virtually identical to the beef/* files, except for:
        - `s/deadbeef/cafef00d/g`
        - `s/beef/cafe/g`
        - `s/Beef/Cafe/g`
  - `test/BeefCafeTest.bs`
    - Contains a test that uses both `Beef` and `Cafe` in one test.

# My goal

The nut I am trying to crack is how to do separate compilation, and compile all
of these things correctly using a tool like `bazel`, but there is no need to
actually bring `bazel` into the picture.  The important aspect of `bazel` that
is relevant here is that it needs to know exactly what files are consumed and
produced at each step.

At a high level in this example, I am trying to compile each package once
(`Beef`, `Cafe`, `BeefTest`, `CafeTest`, and `BeefCafeTest`), and then link the
compiled packages together to produce executables (`BeefTest.exe`,
`CafeTest.exe`, and `BeefCafeTest.exe`).

In my real project, I am also trying to compile in `-sim` and `-verilog` modes,
but I don't think that comes up here, so I am only doing  `-verilog` mode here.

# The framework

The stuff in `functions.sh` is a framework for running bsc in a way that
approximates what happens in `bazel`.

It has a few variables that need to be set (or left empty) before compiling:
  - `source_files`
    - List of explicitly named files that bsc will compile.  These are the
      filenames that are passed to bsc on the command line.
  - `implicit_files`
    - List of files that bsc is implicitly expecting to find.  These are the
      files that are not passed to bsc on the command line, but are needed for
      compilation.  E.g., .bo files from previous compilations, etc..
  - `expected_outputs`
    - List of files that bsc will produce, and which are needed later.  For
      compilation, this includes .bo files, .ba files, etc.  For linking, this
      includes the executable, and the things needed at runtime.
  - `extra_outputs`
    - List of files that bsc will produce, but are not needed.  This includes
      things like .o files, and other intermediate files.

These vars are all reset back to empty after each call.

The `BSC` function mimics the way `bazel` runs `bsc` by creating a temporary
directory, copying all of the `source_files` and `implicit_files` into it, and
running `bsc` there. This way, `bsc` cannot access anything but those files. It
then verifies that only the `expected_outputs` and `extra_outputs` were created.
Then the `expected_outputs` are copied back to the original dir, and the
temporary dir is deleted.

The `path_dir_flags` function is used to generate the `-p` flag and the various
`-*dir` flags.  It takes one directory as an argument, which will be used for
the `-bdir`, `-simdir`, `-vdir`, and `-info-dir` flags.  It then combines all of
the directories referenced in the `source_files` and `implicit_files` for the
`-p` flag.  (It also includes `%/Libraries`).

I then have several `example_*.sh` scripts that show how I am using this
framework.  Each script is a self-contained example that can be run from the top
level directory.  Each will execute `clean.sh` before running.

# The `-vdir` and `vpi_wrapper_*.{c,h}` compilation issue (A)

The first problem I ran into is that the `vpi_wrapper_*.{c,h}` files are
generated in the `cwd`, unless I specify `-vdir`.  The `-vdir` defaults to the
location of the source file being compiled, but I need to specify it explicitly
to get the `vpi_wrapper_*.{c,h}` files to go there.

See `example_A_bad_no_vdir.sh` for an example of this.  It fails because it is
expecting the `vpi_wrapper_*.{c,h}` files to be in the `beef` directory, but
they are in the `cwd` instead.

And the `example_A_good_with_vdir.sh` shows how I handle this.  (By just passing
the `-vdir` flag).

# The `vpi_wrapper_*.{c,h}` linking issue (B)

The `example_B_bad_*.sh` scripts fail, because when linking they are expecting
to find `vpi_wrapper_*.{c,h}` files in the same directory where the executable
is being created.  But they are in the `beef` and `cafe` directories instead.

The `example_B_good_*.sh` scripts show how I handle this by copying all the
`vpi_wrapper_*.{c,h}` files into the directory where the executable is being
created before linking.

# The `directc_*.so` runtime issue (C)

When linking with `BDPI`, bsc will generate a `directc_*.so` file that is needed
at runtime.  This file is generated in the `cwd`, regardless of any `-*dir`
flags.

When the executable is run, it will look for the `directc_*.so` file in the cwd
as well.  So, if the executable is being created in a different directory (using
the -o flag), then the `directc_*.so` file will not be with the executable.

Interestingly, when linking a bluesim executable (e.g., `foo_exe`) with -sim, it
also generates a `foo_exe.so` file, but it is generated in the same directory as
the executable, and at runtime that is where it looks for it.  So it seems like
the `directc_*.so` is just a special case.  None of these examples use `-sim`
though, so I can't show that here.  Let me know if you want me to add that.

The `example_C_bad_*.sh` scripts illustrate this problem.