cmake_minimum_required(VERSION 3.14)

project(example_tests CXX)

find_package(example CONFIG REQUIRED)

enable_testing()

add_executable(example_test example_test.cpp)
target_link_libraries(example_test PRIVATE example::example)
target_compile_features(example_test PRIVATE cxx_std_14)

add_test(NAME example_test COMMAND example_test)
