# Quick Start Guide

## Setup Environment

* WorkDir
```bash
mkdir compulab-sr-build && cd compulab-sr-build
```

* Initialize and sync repo manifest
```bash
repo init -u https://github.com/compulab-yokneam/compulab-sr-manifest -m compulab.xml
repo sync
```

* Apply the CompuLab patches
```bash
bash setup.sh
```

##  Setup ARM64 GNU Toolchain

* Download ARM64 GNU Toolchain
```bash
mkdir -p downloads tools
wget --directory-prefix downloads/ wget --directory-prefix downloads/ https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz
tar -C tools -xf downloads/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz
```

* Set `CROSS_COMPILE` environment variable
```bash
export CROSS_COMPILE64=$(pwd)/tools/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
export CROSS_COMPILE=$(pwd)/tools/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
```
## Install Python Cryptodome ##
```bash
pip3 install pycryptodome
```

## Build

* Issue `make` command
```
make
```
* Verify the result
```
stat image.d/imx-boot.bin
```

## Deployment
* Create a bootable SD-card
```bash
sudo sudo dd if=image.d/imx-boot.bin of=/dev/sdX bs=1K seek=33
```
