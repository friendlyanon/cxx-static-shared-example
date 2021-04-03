#!/bin/sh -e

SOURCE_DIR="$(readlink -f "$1")"
BINARY_DIR="$(readlink -f "$2")"

if [ ! -d "$SOURCE_DIR" -o ! -d "$BINARY_DIR" ]; then
  printf "Usage: %s <source-dir> <binary-dir>\n" "$0"
  exit 1
fi

cd "$BINARY_DIR"

rm -rf ./_CPack_Packages ./*.deb lintian.log
umask 0022

cpack -G DEB --config "$SOURCE_DIR/cmake/packaging/deb/config.cmake"

# Lintian tags to suppress:
#
# no-symbols-control-file:
#   "For C++ libraries it is often better not to ship symbols files."
#   See: https://wiki.debian.org/UsingSymbolsFiles#C.2B-.2B-_libraries
#
# extended-description-is-probably-too-short:
#   This is just an example.
TAGS="no-symbols-control-file,extended-description-is-probably-too-short"

lintian --no-tag-display-limit --suppress-tags "${TAGS}" -Ii ./*.deb
