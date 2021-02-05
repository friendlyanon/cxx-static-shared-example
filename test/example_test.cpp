#include <example/main.h>

int main() {
  example e{5};

  return e.getX() == 5 ? 0 : 1;
}
