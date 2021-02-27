cmake_minimum_required(VERSION 3.14...3.20)

project(
  example
  VERSION 0.1.0
  LANGUAGES CXX
)

option(BUILD_SHARED_LIBS "default" YES)

# ---- Warning guard ----

# Protect dependents from this project's warnings if the guard isn't disabled
## XXX why? CK
## set(example_warning_guard SYSTEM)
## if(example_INCLUDE_WITHOUT_SYSTEM)
##   set(example_warning_guard "")
## endif()

# ---- Declare library ----

include(GenerateExportHeader)

include(GNUInstallDirs)
set(EXAMPLE_INCLUDE_DIRECTORY "${CMAKE_INSTALL_INCLUDEDIR}")

set(EXAMPLE_headers include/example/main.h)

set(EXAMPLE_sources source/main.cpp)

add_library(example_example ${EXAMPLE_sources} ${EXAMPLE_headers})
add_library(example::example ALIAS example_example)

generate_export_header(
  example_example BASE_NAME example EXPORT_FILE_NAME
  "include/example/example_export.h"
)

set_target_properties(
  example_example
  PROPERTIES CXX_VISIBILITY_PRESET hidden
             VISIBILITY_INLINES_HIDDEN YES
             VERSION "${PROJECT_VERSION}"
             SOVERSION "${PROJECT_VERSION_MAJOR}"
             EXPORT_NAME example
             OUTPUT_NAME example
)

target_include_directories(
  example_example # XXX ${example_warning_guard}
  PUBLIC "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
         "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>"
         "$<INSTALL_INTERFACE:${EXAMPLE_INCLUDE_DIRECTORY}>"
)

target_compile_features(example_example PUBLIC cxx_std_17)

# ---- Install ----

include(CMakePackageConfigHelpers)

install(
  DIRECTORY "${PROJECT_SOURCE_DIR}/include/" "${PROJECT_BINARY_DIR}/include/"
  DESTINATION "${EXAMPLE_INCLUDE_DIRECTORY}"
  COMPONENT example_Development
)

install(
  TARGETS example_example
  EXPORT exampleTargets
  RUNTIME COMPONENT example_Runtime
  LIBRARY COMPONENT example_Runtime NAMELINK_COMPONENT example_Development
  ARCHIVE COMPONENT example_Development
  INCLUDES
  DESTINATION "${EXAMPLE_INCLUDE_DIRECTORY}"
)

write_basic_package_version_file(
  exampleConfigVersion.cmake COMPATIBILITY SameMajorVersion
)

set(EXAMPLE_INSTALL_CMAKEDIR
    "${CMAKE_INSTALL_LIBDIR}/cmake/example"
    CACHE STRING "CMake package config location relative to the install prefix"
)
mark_as_advanced(EXAMPLE_INSTALL_CMAKEDIR)

install(
  FILES "${PROJECT_SOURCE_DIR}/cmake/exampleConfig.cmake"
        "${PROJECT_BINARY_DIR}/exampleConfigVersion.cmake"
  DESTINATION "${EXAMPLE_INSTALL_CMAKEDIR}"
  COMPONENT example_Development
)

install(
  EXPORT exampleTargets
  NAMESPACE example::
  DESTINATION "${EXAMPLE_INSTALL_CMAKEDIR}"
  COMPONENT example_Development
)

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR}")
  include(CPack)
endif()
