cmake_minimum_required(VERSION 3.14...3.20)

project(exampleAll NONE)

#XXX set(example_INCLUDE_WITHOUT_SYSTEM YES CACHE INTERNAL "")

add_subdirectory(.. sub/root)

# The above add_subdirectory call creates the necessary target(s), add a stub
file(WRITE "${PROJECT_BINARY_DIR}/configs/exampleConfig.cmake" "")
set(example_DIR "${PROJECT_BINARY_DIR}/configs" CACHE INTERNAL "")

enable_testing()
add_subdirectory(../test sub/test)
