# llama.cpp-bin (AUR)

Pre-built [llama.cpp](https://github.com/ggml-org/llama.cpp) binaries for Arch Linux.

## Variants

| Build Variant | Description |
|---------------|-------------|
| (empty) | CPU only |
| `-vulkan` | GPU via Vulkan |
| `-rocm-7.2` | GPU via ROCm |

## Setup

1. Install prerequisites:
   ```bash
   sudo pacman -S --needed base-devel
   ```

2. Edit `PKGBUILD` and change `build_variant` to your desired variant:
   ```bash
   build_variant="-vulkan"  # CHANGE THIS
   ```

3. Build and install:
   ```bash
   makepkg -si
   ```

## Upgrade

Run `upgrade.sh` to automatically fetch the latest version, rebuild, and install:
```bash
./upgrade.sh
```

## Installed Location

- Binaries: `/opt/llama.cpp-bin*/`
- Wrapper scripts: `/usr/bin/` (auto-configures `LD_LIBRARY_PATH`)