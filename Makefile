CROSS_COMPILE64 ?= /opt/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
CROSS_COMPILE ?= /opt/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
IMAGE_D = $(shell pwd)/image.d
SOURCES = $(shell pwd)/sources

all:	$(IMAGE_D)
	CROSS_COMPILE=$(CROSS_COMPILE64) ARCH=arm64 make -C $(SOURCES)/u-boot O=$(IMAGE_D) -j 8 imx8mm-cl-iot-gate_defconfig
	CROSS_COMPILE=$(CROSS_COMPILE64) ARCH=arm64 make -C $(SOURCES)/u-boot O=$(IMAGE_D) -j 8 all tools
	CROSS_COMPILE64=$(CROSS_COMPILE64) CROSS_COMPILE=$(CROSS_COMPILE64) ARCH=arm make -C $(SOURCES)/optee_os -f Makefile.iot O=$(IMAGE_D) INSTALL_DIR=$(IMAGE_D) -j 8 install
	CROSS_COMPILE=$(CROSS_COMPILE64) ARCH=arm64 make -C $(SOURCES)/trusted-firmware-a -f Makefile.iot O=$(IMAGE_D) INSTALL_DIR=$(IMAGE_D) -j 8 install
	make -C $(SOURCES)/firmware INSTALL_DIR=$(IMAGE_D) install
	CROSS_COMPILE=$(CROSS_COMPILE64) ARCH=arm64 make -C $(SOURCES)/u-boot O=$(IMAGE_D) -j 8 imx-boot.bin

$(IMAGE_D):
	mkdir -p $@

clean:
	rm -rf $(IMAGE_D)
