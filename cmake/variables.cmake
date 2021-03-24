string(
    COMPARE EQUAL
    "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}"
    PROJECT_IS_TOP_LEVEL
)

# ---- Developer mode ----

if(PROJECT_IS_TOP_LEVEL)
  option(example_DEVELOPER_MODE "Enable developer mode" OFF)
  option(BUILD_SHARED_LIBS "Build shared libs" OFF)
  if("$ENV{CI}")
    set(example_DEVELOPER_MODE ON CACHE INTERNAL "")
  endif()
endif()

# ---- Warning guard ----

# Protect dependents from this project's warnings if the guard isn't disabled
set(example_warning_guard SYSTEM)
if(PROJECT_IS_TOP_LEVEL OR example_INCLUDE_WITHOUT_SYSTEM)
  set(example_warning_guard "")
endif()
