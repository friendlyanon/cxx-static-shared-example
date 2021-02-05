#include <example/main.h>

struct example::example_impl {
  explicit example_impl(int x) : x(x)
  {}

  int x{};
};

example::example(int x) : pimpl(new example_impl(x))
{}

example::~example() = default;

int example::getX() {
  return pimpl->x;
}
