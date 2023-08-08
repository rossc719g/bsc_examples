#!/bin/bash -e

rm -rvf \
  $(find . -type f -name '*.ba') \
  $(find . -type f -name '*.bo') \
  $(find . -type f -name '*.v') \
  $(find . -type f -name 'vpi_*.c') \
  $(find . -type f -name 'vpi_*.h') \
  $(find . -type f -name '*.o') \
  $(find . -type f -name '*.exe') \
  $(find . -type f -name '*.so')
