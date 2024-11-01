# missing_case_arm

This example demonstrates a lack of a warning when a case statement is missing
an arm, and the inability to create a warning by adding a default arm with a
warning.

There are three examples of both:

1) With no case statement
2) With a case statement in a value context
3) With a case statement in a action context

To replicate, just execute `./compile.sh` in this dir.
