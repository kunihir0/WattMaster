TARGET := iphone:clang:latest:15.4
INSTALL_TARGET_PROCESSES = Wattpad
THEOS_DEVICE_IP = 192.168.1.119

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WattMaster

WattMaster_FILES = Tweak.x WattMasterSettingsViewController.m
WattMaster_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
