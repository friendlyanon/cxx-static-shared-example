cmake_minimum_required(VERSION 3.8)

project(exampleAll NONE)

set(example_INCLUDE_WITHOUT_SYSTEM YES)
set(CMAKE_INSTALL_INCLUDEDIR include/example)

add_subdirectory(.. sub/root)

# The above add_subdirectory call creates the necessary target(s), add a stub
file(WRITE "${PROJECT_BINARY_DIR}/configs/exampleConfig.cmake" "")
set(example_DIR "${PROJECT_BINARY_DIR}/configs" CACHE INTERNAL "")

add_subdirectory(../test sub/test)
