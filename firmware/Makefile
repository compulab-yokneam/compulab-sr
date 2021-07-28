NXP_MIRROR = www.freescale.com/lgfiles/NMG/MAD/YOCTO
FIRMWARE = firmware-imx-8.11.bin
FIRMWARE_D = $(shell basename $(FIRMWARE) .bin)
LPDDRFW = $(FIRMWARE_D)/firmware/ddr/synopsys/lpddr4_pmu_train_1d_imem.bin
LPDDRFW_D = $(shell dirname $(LPDDRFW))
INSTALL_DIR ?= ../image.d

$(LPDDRFW): $(FIRMWARE_D)

$(FIRMWARE_D): $(FIRMWARE)
	@bash $(FIRMWARE) --auto-accept
	@touch $(FIRMWARE_D)

$(FIRMWARE):
	@wget $(NXP_MIRROR)/$@

install: $(LPDDRFW)
	@cp -v $(LPDDRFW_D)/lpddr4* $(INSTALL_DIR)

clean:
	@rm -rf $(FIRMWARE_D)* $(INSTALL_DIR)/lpddr4*
