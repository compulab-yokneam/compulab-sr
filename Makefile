CROSS_COMPILE64 ?= /opt/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
CROSS_COMPILE ?= /opt/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-

OUT_D = $(shell pwd)/out.d
IMAGE_D = $(shell pwd)/image.d
SOURCES = $(shell pwd)/sources

U_BOOT_CONFIG = $(IMAGE_D)/.config

all:	$(IMAGE_D) imx-boot.bin capsule1.bin $(OUT_D)
	cp $(IMAGE_D)/imx-boot.bin $(OUT_D)/imx-boot.bin
	cp $(IMAGE_D)/capsule1.bin $(OUT_D)/capsule1.bin

config:	$(U_BOOT_CONFIG)
	ls -al $(U_BOOT_CONFIG)

$(U_BOOT_CONFIG):
	CROSS_COMPILE=$(CROSS_COMPILE64) ARCH=arm64 make -C $(SOURCES)/u-boot O=$(IMAGE_D) -j 8 imx8mm-cl-iot-gate_defconfig

u-boot:	$(U_BOOT_CONFIG)
	CROSS_COMPILE=$(CROSS_COMPILE64) ARCH=arm64 make -C $(SOURCES)/u-boot O=$(IMAGE_D) -j 8 u-boot.bin SPL tools

optee:
	CROSS_COMPILE64=$(CROSS_COMPILE64) CROSS_COMPILE=$(CROSS_COMPILE64) ARCH=arm make -C $(SOURCES)/optee_os -f Makefile.iot O=$(IMAGE_D) INSTALL_DIR=$(IMAGE_D) -j 8 install

atf:	optee u-boot
	CROSS_COMPILE=$(CROSS_COMPILE64) ARCH=arm64 make -C $(SOURCES)/trusted-firmware-a -f Makefile.iot O=$(IMAGE_D) INSTALL_DIR=$(IMAGE_D) -j 8 install

firmware:
	make -C $(SOURCES)/firmware INSTALL_DIR=$(IMAGE_D) install

flash.bin: u-boot
	CROSS_COMPILE=$(CROSS_COMPILE64) ARCH=arm64 make -C $(SOURCES)/u-boot O=$(IMAGE_D) -j 8 $@

imx-boot.bin: atf firmware flash.bin
	CROSS_COMPILE=$(CROSS_COMPILE64) ARCH=arm64 make -C $(SOURCES)/u-boot O=$(IMAGE_D) -j 8 $@

capsule1.bin: imx-boot.bin
	CROSS_COMPILE=$(CROSS_COMPILE64) ARCH=arm64 make -C $(SOURCES)/u-boot O=$(IMAGE_D) -j 8 $@

$(IMAGE_D) $(OUT_D):
	mkdir -p $@

clean:
	rm -rf $(IMAGE_D) $(OUT_D)
