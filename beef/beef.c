#include <stdio.h>
#include <stdlib.h>

void beef(unsigned int* res, unsigned int n) {
  const unsigned int words = n / 32;
  const unsigned int rem = n % 32;

  for (int i = 0; i < words; i++) {
    res[i] = 0xdeadbeef;
  }
  if (rem) {
    res[words] = 0xdeadbeef & ((1 << rem) - 1);
  }
}
