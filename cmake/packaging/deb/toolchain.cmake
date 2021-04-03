# Preferred build type on Debian
set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE INTERNAL "")

# Preferred install location on Debian for libraries
set(CMAKE_INSTALL_LIBDIR lib/x86_64-linux-gnu)

# Lintian requires some extra sections to be stripped
set(CMAKE_STRIP "${CMAKE_CURRENT_LIST_DIR}/extra-strip.sh")

# Lintian recommends fortifying artifacts
set(
    CMAKE_CXX_FLAGS_INIT
    "-Wdate-time -D_FORTIFY_SOURCE=2 -fdebug-prefix-map=${CMAKE_BINARY_DIR}=. \
-fstack-protector-strong"
)

foreach(type IN ITEMS EXE SHARED MODULE)
  set(
      "CMAKE_${type}_LINKER_FLAGS_INIT"
      "-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now"
  )
endforeach()
unset(type)
