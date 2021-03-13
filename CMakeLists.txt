cmake_minimum_required(VERSION 3.12)

project(
    example
    VERSION 0.1.0
    LANGUAGES CXX
)

# ---- Warning guard ----

# Protect dependents from this project's warnings if the guard isn't disabled
set(example_warning_guard SYSTEM)
if(example_INCLUDE_WITHOUT_SYSTEM)
  set(example_warning_guard "")
endif()

# ---- Declare library ----

include(GenerateExportHeader)

set(headers include/example/main.h)

set(sources source/main.cpp)

add_library(example_example ${sources} ${headers})
add_library(example::example ALIAS example_example)

generate_export_header(
    example_example
    BASE_NAME example
    EXPORT_FILE_NAME "include/example/example_export.h"
)

if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(example_example PUBLIC EXAMPLE_STATIC_DEFINE)
endif()

set_target_properties(
    example_example PROPERTIES
    CXX_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN YES
    VERSION "${PROJECT_VERSION}"
    SOVERSION "${PROJECT_VERSION_MAJOR}"
    EXPORT_NAME example
    OUTPUT_NAME example
)

target_include_directories(
    example_example
    ${example_warning_guard}
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
    "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>"
)

target_compile_features(example_example PUBLIC cxx_std_14)

# ---- Install ----

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  set(CMAKE_INSTALL_INCLUDEDIR "include/example" CACHE PATH "")
endif()

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

install(
    DIRECTORY
    "${PROJECT_SOURCE_DIR}/include/"
    "${PROJECT_BINARY_DIR}/include/"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
    COMPONENT example_Development
)

install(
    TARGETS example_example
    EXPORT exampleTargets
    RUNTIME #
    DESTINATION "${CMAKE_INSTALL_BINDIR}"
    COMPONENT example_Runtime
    LIBRARY #
    DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    COMPONENT example_Runtime
    NAMELINK_COMPONENT example_Development
    ARCHIVE #
    DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    COMPONENT example_Development
    INCLUDES #
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

write_basic_package_version_file(
    exampleConfigVersion.cmake
    COMPATIBILITY SameMajorVersion
)

set(
    example_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/example"
    CACHE STRING "CMake package config location relative to the install prefix"
)
mark_as_advanced(example_INSTALL_CMAKEDIR)

install(
    FILES
    "${PROJECT_SOURCE_DIR}/cmake/exampleConfig.cmake"
    "${PROJECT_BINARY_DIR}/exampleConfigVersion.cmake"
    DESTINATION "${example_INSTALL_CMAKEDIR}"
    COMPONENT example_Development
)

install(
    EXPORT exampleTargets
    NAMESPACE example::
    DESTINATION "${example_INSTALL_CMAKEDIR}"
    COMPONENT example_Development
)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  include(CPack)
endif()
