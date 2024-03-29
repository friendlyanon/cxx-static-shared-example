cmake_minimum_required(VERSION 3.8)

project(example_tests CXX)

include(../cmake/project-is-top-level.cmake)

if(PROJECT_IS_TOP_LEVEL)
  find_package(example REQUIRED)
endif()

add_executable(example_test example_test.cpp)
target_link_libraries(example_test PRIVATE example::example)
target_compile_features(example_test PRIVATE cxx_std_14)

add_test(NAME example_test COMMAND example_test)

if(NOT CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
  return()
endif()

get_target_property(type example::example TYPE)
if(NOT type STREQUAL "SHARED_LIBRARY")
  return()
endif()

set_property(
    TEST example_test PROPERTY
    ENVIRONMENT "PATH=$<TARGET_FILE_DIR:example::example>"
)
