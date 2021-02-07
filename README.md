# CMake Example: support building as either shared or static

![Continuous Integration](https://github.com/friendlyanon/cxx-static-shared-example/workflows/Continuous%20Integration/badge.svg)

This example project shows you how to build a C++ project that can be built as
static or shared, by using the corresponding CMake functionality.

The [`master`](https://github.com/friendlyanon/cxx-static-shared-example)
branch uses CMake 3.14 as minimum. For older minimum requirements, see the
[`cmake-3.12`](https://github.com/friendlyanon/cxx-static-shared-example/tree/cmake-3.12)
and
[`cmake-3.8`](https://github.com/friendlyanon/cxx-static-shared-example/tree/cmake-3.8)
branches. Only the `install(TARGETS)` command is different in older versions of
CMake, but for the purpose of being a proper educational example they are also
included.

Anything older than CMake 3.8 is not practical to use.

# How?

Below are what a developer has to take into account to successfully aid users
of the library in making the decision on how to build the library. Users in
this case can be other developers depending on the library or package
maintainers who distribute your library.

## `BUILD_SHARED_LIBS`

CMake provides a way to let the user choose the type of libraries to build if
those do not specify their type explicitly.
[`add_library`](https://cmake.org/cmake/help/latest/command/add_library.html#normal-libraries)
will check for the value of `BUILD_SHARED_LIBS` when called without an type and
honor its value.

This variable should never be set anywhere in your `CMakeLists.txt` files and
there should be no "special" ways to achieve the same thing CMake provides by
default.  
Making package maintainers' life more difficult for no reason benefits noone.

```cmake
add_library(your_target ${headers} ${sources})
```

## SONAME and REAL LIBRARY

On Linux platforms, a shared library consists of a single REAL LIBRARY and
symlinks to it, one of which is the SONAME. The REAL LIBRARY has a filename
similar to `libyour_target.so.1.2.3`, where the full version number is embedded
as a suffix. This does not affect runtime loading, the REAL LIBRARY is for
humans.

The SONAME on the other hand is what the runtime loader will go looking for.
The corresponding SONAME of the above shared library would be
`libyour_target.so.1`, where `1` is the library's SOVERSION. Different
libraries may choose different versioning strategies and it doesn't necessarily
have to be related to the suffix in the REAL LIBRARY name.  
In this example, the major version of the project will be assumed to mean
SOVERSION as well.

```cmake
set_target_properties(
    your_target PROPERTIES
    VERSION "${PROJECT_VERSION}"
    SOVERSION "${PROJECT_VERSION_MAJOR}"
)
```

## Visibility

On the Windows platform, symbols must be explicitly exported from a DLL and
must be marked as DLL imports in the header files in the consuming end.  
This is the desired behavior on all platforms, however the defaults are wrong
on other platforms like Linux.

To hide symbols on platforms, where the default is not hiding symbols, you must
add some properties to your (possibly) shared targets:

```cmake
set_target_properties(
    your_target PROPERTIES
    CXX_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN YES
)
```

## Export macros

CMake supports generating cross-platform export macros via the
[`GenerateExportHeader`](https://cmake.org/cmake/help/latest/module/GenerateExportHeader.html)
module. A library must annotate every symbol that the user is intended to or
might be able to observe.

```cmake
include(GenerateExportHeader)

generate_export_header(
    your_target
    EXPORT_FILE_NAME "include/your_project/your_target_export.h"
)

target_include_directories(
    your_target
    ${your_project_warning_guard}
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>"
)
```

```cpp
#include <your_project/your_target_export.h>

class YOUR_TARGET_EXPORT your_class {};
```

## NAME LINK

On Linux, besides the SONAME, there is another symlink pointing to the REAL
LIBRARY, which is the NAME LINK. While the SONAME and REAL LIBRARY are part of
the runtime component, this symlink is part of the development component of a
library, as it is used at build time for linking by dependent projects.

Depending on your CMake version, this is installed in different ways. Here it
is for CMake 3.12+ using the default install locations from
[`GNUInstallDirs`](https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html):

```cmake
include(GNUInstallDirs)

install(
    TARGETS your_target
    RUNTIME #
    DESTINATION "${CMAKE_INSTALL_BINDIR}"
    COMPONENT your_project_Runtime
    LIBRARY #
    DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    COMPONENT your_project_Runtime
    NAMELINK_COMPONENT your_project_Development
    ARCHIVE #
    DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    COMPONENT your_project_Development
)
```

# The big picture

The above points were focusing on single aspects that must be taken into
account.  
To see the big picture and how the pieces fit together, please take a look at
the [`CMakeLists.txt`](CMakeLists.txt) file.

# References

* [Deep CMake for Library Authors](https://www.youtube.com/watch?v=m0DwB4OvDXk)
  by Craig Scott - CppCon 2019
