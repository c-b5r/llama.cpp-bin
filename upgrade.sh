#!/bin/bash
set -e # Exit on any error

# Clean up
echo "Removing old packages"
rm -f llama.cpp-*.pkg.tar.zst

#  Fetch latest tag
LATEST_TAG=$(curl -s "https://api.github.com/repos/ggml-org/llama.cpp/releases/latest" |
	grep -oP '"tag_name":\s*"\K[^"]+')

if [[ -z "$LATEST_TAG" ]]; then
	echo "Error: Failed to fetch latest tag" >&2
	exit 1
fi

echo "Latest llama.cpp release: $LATEST_TAG"

#  Check PKGBUILD exists
if [[ ! -f "PKGBUILD" ]]; then
	echo "Error: PKGBUILD not found in current directory" >&2
	exit 1
fi

#  Update pkgver
sed -i "s/^pkgver=.*/pkgver=${LATEST_TAG}/" PKGBUILD
echo "Updated PKGBUILD to pkgver=${LATEST_TAG}"

# 4. Build the package
makepkg -si --noconfirm

#  Install the built package (exclude debug packages)
PKG_FILE=$(ls ./*.pkg.tar.zst 2>/dev/null | grep -v '\-debug-' | head -1)

if [[ -z "$PKG_FILE" ]]; then
	echo "Error: No package file found after build" >&2
	exit 1
fi

echo "Installing: $PKG_FILE"
sudo pacman -U "$PKG_FILE" --noconfirm

# Clean up
echo "Cleaning up build files"
rm -rf pkg src
rm -f llama-*.tar.gz

# Done
echo "Done!"
