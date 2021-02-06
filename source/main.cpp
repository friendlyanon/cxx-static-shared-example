#include <utility>

#include <example/main.h>

struct example::example_impl {
  explicit example_impl(int x) : x(x)
  {}

  int x{};
};

example::example(int x) : pimpl(new example_impl(x))
{}

example::~example() {
  delete std::exchange(pimpl, nullptr);
}

example::example(example&& other) : pimpl(std::exchange(other.pimpl, nullptr))
{}

example& example::operator=(example&& other) {
  delete pimpl;
  pimpl = std::exchange(other.pimpl, nullptr);
  return *this;
}

int example::getX() {
  return pimpl->x;
}
