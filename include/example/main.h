#ifndef EXAMPLE_MAIN_H_
#define EXAMPLE_MAIN_H_

#include <memory>

#include <example/example_export.h>

class EXAMPLE_EXPORT example {
public:
  explicit example(int x);

  int getX();

private:
  class example_impl;

  std::unique_ptr<example_impl> pimpl;
};

#endif // EXAMPLE_MAIN_H_
