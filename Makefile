ARCHS = arm64 armv7 armv7s

include /opt/theos/makefiles/common.mk

TWEAK_NAME = messagefilter
messagefilter_FILES = Tweak.xm
messagefilter_FRAMEWORKS = UIKit AudioToolbox CoreGraphics
messagefilter_PRIVATEFRAMEWORKS = ChatKit

include $(THEOS_MAKE_PATH)/tweak.mk
