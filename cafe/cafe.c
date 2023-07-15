#include <stdio.h>
#include <stdlib.h>

void cafe(unsigned int* res, unsigned int n) {
  const unsigned int words = n / 32;
  const unsigned int rem = n % 32;

  for (int i = 0; i < words; i++) {
    res[i] = 0xcafef00d;
  }
  if (rem) {
    res[words] = 0xcafef00d & ((1 << rem) - 1);
  }
}
