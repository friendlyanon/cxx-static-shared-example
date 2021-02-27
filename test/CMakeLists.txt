cmake_minimum_required(VERSION 3.14...3.20)

project(example_tests LANGUAGES CXX)

find_package(example CONFIG REQUIRED)

enable_testing()

add_executable(example_test example_test.cpp)
target_link_libraries(example_test PRIVATE example::example)
target_compile_features(example_test PRIVATE cxx_std_17)

add_test(NAME example_test COMMAND example_test)

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
  get_target_property(type example::example TYPE)
  if(NOT type STREQUAL "SHARED_LIBRARY")
    return()
  endif()

  set_property(
    TEST example_test PROPERTY ENVIRONMENT
                               "PATH=$<TARGET_FILE_DIR:example::example>"
  )
endif()
