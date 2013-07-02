#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
  setuid(0);
  system("/path/to/sendsig.sh");

  return 0;
}

