#ifndef EXAMPLE_MAIN_H_
#define EXAMPLE_MAIN_H_

#include <example/example_export.h>

class EXAMPLE_EXPORT example {
public:
  explicit example(int x);

  ~example();

  example(example&&);
  example& operator=(example&&);

  example(const example&) = delete;
  example& operator=(const example&) = delete;

  int getX();

private:
  struct example_impl;

  example_impl *pimpl = nullptr;
};

#endif // EXAMPLE_MAIN_H_
