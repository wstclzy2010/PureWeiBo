DEBUG = 0

ARCHS = arm64
# TARGET = iphone:10.3

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WeiBoJumpAd

WeiBoJumpAd_FILES = Tweak.xm
# WeiBoJumpAd_CFLAGS = -fobjc-arc
TARGET_CC = /Users/paigu/Hikari.xctoolchain/usr/bin/clang-8
TARGET_CXX = /Users/paigu/Hikari.xctoolchain/usr/bin/clang-8
TARGET_LD = /Users/paigu/Hikari.xctoolchain/usr/bin/clang-8
_THEOS_TARGET_CFLAGS += -fobjc-arc -mllvm -enable-allobf
_THEOS_TARGET_CXXFLAGS += -mllvm -enable-allobf

include $(THEOS_MAKE_PATH)/tweak.mk
