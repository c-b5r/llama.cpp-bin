# https://github.com/ggml-org/llama.cpp/releases

# <empty> -> cpu
# -vulkan
# -rocm-7.2
build_variant=""  # CHANGE THIS

pkgname="llama.cpp-bin${build_variant}"
pkgver=b8646
pkgrel=1
pkgdesc="LLM inference in C/C++ (precompiled Linux binaries - ${build_variant^^})"
arch=("x86_64")
url="https://github.com/ggml-org/llama.cpp"
license=('MIT')
provides=("llama.cpp-bin")
conflicts=("llama.cpp" "llama.cpp-bin" "llama.cpp-git" "llama.cpp-vulkan")

[[ ${build_variant} == "-vulkan" ]] && depends+=(vulkan-icd-loader)

source=("llama-${pkgver}-bin-ubuntu${build_variant}-x64.tar.gz::https://github.com/ggml-org/llama.cpp/releases/download/${pkgver}/llama-${pkgver}-bin-ubuntu${build_variant}-x64.tar.gz")
sha256sums=('SKIP')

package() {
  local runtime_installdir="/opt/${pkgname}"
  local staged_installdir="${pkgdir}${runtime_installdir}"
  local bindir="${pkgdir}/usr/bin"
  local licensedir="${pkgdir}/usr/share/licenses/${pkgname}"
  local srcroot

  srcroot="$(find . -maxdepth 1 -mindepth 1 -type d -name 'llama-*' | head -n1)"
  [[ -n ${srcroot} ]] || {
    echo "Could not find extracted llama.cpp directory" >&2
    return 1
  }

  install -dm755 "$staged_installdir" "$bindir" "$licensedir"

  install -Dm644 "${srcroot}/LICENSE" "${licensedir}/LICENSE"
  cp -a "${srcroot}/." "$staged_installdir/"

  while IFS= read -r -d '' exe; do
    local basename runtime_exe
    basename="$(basename "$exe")"
    runtime_exe="${runtime_installdir}/${basename}"

    cat > "${bindir}/${basename}" << EOF
#!/bin/bash
export LD_LIBRARY_PATH="${runtime_installdir}\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
exec "${runtime_exe}" "\$@"
EOF
    chmod 755 "${bindir}/${basename}"
  done < <(find "$staged_installdir" -maxdepth 1 -type f -executable -print0)
}
