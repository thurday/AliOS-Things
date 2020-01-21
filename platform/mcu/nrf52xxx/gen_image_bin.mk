EXTRA_POST_BUILD_TARGETS += gen_standard_images

ifeq ($(CONFIG_SYSINFO_DEVICE_NAME),pca10056)
BOOT_BIN_FILE :=$(SOURCE_ROOT)/platform/board/board_legacy/pca10056/pca10056_boot.bin
else
BOOT_BIN_FILE :=$(SOURCE_ROOT)/platform/board/board_legacy/pca10040/pca10040_boot.bin
endif

ALL_BIN_OUTPUT_FILE := $(LINK_OUTPUT_FILE:$(LINK_OUTPUT_SUFFIX)=_all$(BIN_OUTPUT_SUFFIX))
OTA_BIN_INFO_FILE := $(LINK_OUTPUT_FILE:$(LINK_OUTPUT_SUFFIX)=_info$(BIN_OUTPUT_SUFFIX))

CUSTOM_OTA := 1
OTA_IMAGE_OFFSET := 0x1c
BOOT_OFFSET := 0x00
APP_OFFSET  := 0x10000

GEN_BIN_OUTPUT_FILE:= $(SCRIPTS_PATH)/gen_common_bin_output_file.py
GEN_BIN_HEADER_FILE:= $(SOURCE_ROOT)/platform/mcu/nrf52xxx/ota_gen_image_info.py

gen_standard_images:
	$(QUIET)$(ECHO) Generate ALL Standard Images:
	$(QUIET)$(RM) $(ALL_BIN_OUTPUT_FILE)
	$(QUIET)$(CP) $(BIN_OUTPUT_FILE) $(OTA_BIN_OUTPUT_FILE)
	$(PYTHON) $(SCRIPTS_PATH)/gen_common_bin_output_file.py -o $(ALL_BIN_OUTPUT_FILE) -f $(BOOT_OFFSET) $(BOOT_BIN_FILE)
	$(PYTHON) $(SCRIPTS_PATH)/gen_common_bin_output_file.py -o $(ALL_BIN_OUTPUT_FILE) -f $(APP_OFFSET) $(BIN_OUTPUT_FILE)
	$(PYTHON) $(SCRIPTS_PATH)/ota_gen_md5_bin.py $(OTA_BIN_OUTPUT_FILE) -m $(IMAGE_MAGIC)
	$(PYTHON) $(GEN_BIN_HEADER_FILE) -o $(OTA_BIN_INFO_FILE) -m $(IMAGE_MAGIC) $(OTA_BIN_OUTPUT_FILE)
	$(PYTHON) $(SCRIPTS_PATH)/gen_common_bin_output_file.py -o $(OTA_BIN_INFO_FILE) -f $(OTA_IMAGE_OFFSET) $(OTA_BIN_OUTPUT_FILE)
	$(QUIET) $(CP) $(OTA_BIN_INFO_FILE) $(OTA_BIN_OUTPUT_FILE)
	$(QUIET) $(RM) $(OTA_BIN_INFO_FILE)
