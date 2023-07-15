# This script is meant to be sourced, not run directly. It defines BSC()

# All files should be relative to the current directory (begin with "./")

# Flags that are passed to every bsc command.
global_flags=(
  # -no-show-timestamps
  # -Xc++ -Wno-deprecated-declarations
  # -Xc++ -Wno-dangling-else
)

# Before calling these functions, set these lists:
source_files=()     # List of explicitly named files that bsc will compile.
implicit_files=()   # List of files that bsc is implicitly expecting to find.
expected_outputs=() # List of files that bsc will produce.
extra_outputs=()    # List of files that bsc will produce, but are not needed.

path_dir_flags() {
  # Construct *dir and the path flags for bsc.
  # All the *dir flags are set to the same directory, which is in $1. The path
  # will contain the directories of all the implicit files, except for the one
  # used fot the *dir flags. (since bsc includes bdir in the path) ":" is the
  # path separator, and "%"" is the bluespspec dir.

  # Build the path, excluding $1.
  path="%/Libraries"
  # Get a unique list of all the directories that contain implicit files.

  while read d; do
    if [ "$d" != "$1" ]; then
      path="$path:$d"
    fi
  done < <(for f in "${implicit_files[@]}"; do dirname $f; done | sort -u)

  path_flags="-p $path"
  for f in "-bdir" "-simdir" "-vdir" "-info-dir"; do
    path_flags="$path_flags $f $1"
  done
  echo $path_flags
}

BSC() {
  # To mimic the way bazel works, make a temp directory and cd into it, and
  # recreate the structure of the files and directories.
  orig_dir=$(pwd)
  dirs="$(find . -type d | sort)"
  tmpdir=$(mktemp -d)
  pushd $tmpdir >/dev/null
  for d in $dirs; do
    mkdir -p $d
  done
  for i in "${source_files[@]}" "${implicit_files[@]}"; do
    cp $orig_dir/$i $i
  done

  # After we run bsc, we expect to find everything that we copied, plus the
  # expected outputs, and nothing extra.
  expected_after=(
    "${source_files[@]}"
    "${implicit_files[@]}"
    "${expected_outputs[@]}"
    "${extra_outputs[@]}"
  )

  # Run bsc.
  command="bsc ${global_flags[@]} $@"
  echo ""
  echo $command
  eval $command
  echo ""

  # Get a list of all the files that exist after running bsc.
  after=($(find . -type f | sort))

  # Move the outputs back to the original directory if they exist.
  for o in "${expected_outputs[@]}"; do
    if [ -f $o ]; then
      cp $o $orig_dir/$o
    fi
  done
  popd >/dev/null
  rm -rf $tmpdir

  # Make sure we got only what we expected.
  if ! diff --color \
    <(echo "${expected_after[@]}" | tr ' ' '\n' | sort) \
    <(echo "${after[@]}" | tr ' ' '\n' | sort); then
    echo "Resulting files do not match expected files."
    return 1
  fi
  return 0
  # Reset the lists.
  source_files=()
  implicit_files=()
  expected_outputs=()
  extra_outputs=()
}
