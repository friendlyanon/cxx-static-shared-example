function(set_var name value)
  set(type STRING)
  if(ARGC EQUAL 3)
    set(type "${ARGV2}")
  endif()

  set("${name}" "${value}" CACHE "${type}" "")
  mark_as_advanced("${name}")
endfunction()

set(packaging_dir "${PROJECT_SOURCE_DIR}/cmake/packaging")

set_var(CPACK_VERBATIM_VARIABLES YES BOOL)

set_var(
    CPACK_PACKAGE_DESCRIPTION_SUMMARY
    "How to build static and shared libraries with CMake easily"
)
set_var(
    CPACK_PACKAGE_HOMEPAGE_URL
    "https://github.com/friendlyanon/cxx-static-shared-example"
)
set_var(CPACK_PACKAGE_VENDOR example)
set_var(CPACK_PACKAGE_INSTALL_DIRECTORY example)
set_var(
    CPACK_PACKAGE_DESCRIPTION_FILE
    "${packaging_dir}/common/Description.txt"
    FILEPATH
)
set_var(
    CPACK_RESOURCE_FILE_WELCOME
    "${packaging_dir}/common/Welcome.txt"
    FILEPATH
)
set_var(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/LICENSE" FILEPATH)
set_var(CPACK_RESOURCE_FILE_README "${PROJECT_SOURCE_DIR}/README.md" FILEPATH)

set_var(CPACK_COMPONENT_EXAMPLE_RUNTIME_DISPLAY_NAME example)
set_var(
    CPACK_COMPONENT_EXAMPLE_RUNTIME_DESCRIPTION
    "Runtime files for libexample"
)

set_var(
    CPACK_COMPONENT_EXAMPLE_DEVELOPMENT_DISPLAY_NAME
    "example development"
)
set_var(
    CPACK_COMPONENT_EXAMPLE_DEVELOPMENT_DESCRIPTION
    "Development and CMake package files for libexample"
)
set_var(CPACK_COMPONENT_EXAMPLE_DEVELOPMENT_DEPENDS example_Runtime)

include(CPack)

if(CMAKE_HOST_UNIX)
  add_custom_target(
      package_deb
      COMMAND "${PROJECT_SOURCE_DIR}/cmake/packaging/deb/package.sh"
      "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}"
      VERBATIM
  )
  add_dependencies(package_deb example_example)
endif()
