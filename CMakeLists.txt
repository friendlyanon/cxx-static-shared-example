cmake_minimum_required(VERSION 3.14)

project(
    exmaple
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

set(headers include/example/main.h)

set(sources source/main.cpp)

include(GenerateExportHeader)

add_library(example ${sources} ${headers})
add_library(example::example ALIAS example)

set_target_properties(
    example PROPERTIES
    CXX_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN YES
    VERSION "${PROJECT_VERSION}"
    SOVERSION "${PROJECT_VERSION_MAJOR}"
)

generate_export_header(
    example
    EXPORT_FILE_NAME "include/example/example_export.h"
)

target_include_directories(
    example
    ${example_warning_guard}
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
    "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>"
)

target_compile_features(example PUBLIC cxx_std_14)

# ---- Install ----

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

set(example_include_directory "${CMAKE_INSTALL_INCLUDEDIR}/example")

install(
    DIRECTORY
    "${PROJECT_SOURCE_DIR}/include/"
    "${PROJECT_BINARY_DIR}/include/"
    DESTINATION "${example_include_directory}"
    COMPONENT example_Development
)

install(
    TARGETS example
    EXPORT example-targets
    RUNTIME #
    COMPONENT example_Runtime
    LIBRARY #
    COMPONENT example_Runtime
    NAMELINK_COMPONENT example_Development
    ARCHIVE #
    COMPONENT example_Development
    INCLUDES #
    DESTINATION "${example_include_directory}"
)

write_basic_package_version_file(
    example-config-version.cmake
    COMPATIBILITY SameMajorVersion
)

set(example_install_cmakedir "${CMAKE_INSTALL_LIBDIR}/cmake/example")

install(
    FILES "${PROJECT_BINARY_DIR}/example-config-version.cmake"
    DESTINATION "${example_install_cmakedir}"
    COMPONENT example_Development
)

install(
    EXPORT example-targets
    FILE example-config.cmake
    NAMESPACE example::
    DESTINATION "${example_install_cmakedir}"
    COMPONENT example_Development
)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  include(CPack)
endif()
