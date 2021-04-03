cmake_minimum_required(VERSION 3.8)

find_program(GZIP gzip)
if(NOT GZIP)
  message(FATAL_ERROR "Could not find gzip")
endif()

file(STRINGS "${CPACK_RESOURCE_FILE_LICENSE}" copyright_line LIMIT_COUNT 1)
string(TIMESTAMP timestamp "%a, %d %b %Y %H:%M:%S" UTC)

foreach(comp IN LISTS CPACK_COMPONENTS_ALL)
  string(TOUPPER "CPACK_DEBIAN_${comp}_PACKAGE_NAME" package_name_var)
  string(TOLOWER "${${package_name_var}}" name)
  set(doc "${CPACK_TEMPORARY_DIRECTORY}/${comp}/usr/share/doc")

  configure_file(
      "${CMAKE_CURRENT_LIST_DIR}/copyright"
      "${doc}/${name}/copyright"
      @ONLY NO_SOURCE_PERMISSIONS
  )

  set(changelog "${doc}/${name}/changelog")
  configure_file(
      "${CMAKE_CURRENT_LIST_DIR}/changelog" "${changelog}"
      @ONLY NO_SOURCE_PERMISSIONS
  )

  execute_process(COMMAND "${GZIP}" -n9 "${changelog}" RESULT_VARIABLE result)
  if(NOT result EQUAL "0")
    message(FATAL_ERROR "Failed to gzip changelog")
  endif()
endforeach()
