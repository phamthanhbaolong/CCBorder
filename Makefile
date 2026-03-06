# Thiết lập kiến trúc cho Rootless (iOS 15 - 16+)
# Nếu bro muốn build cho máy đời cũ thì dùng: iphoneos:clang:latest:14.0
TARGET := iphoneos:clang:latest:15.0

# Hỗ trợ cả máy cũ (arm64) và máy mới (arm64e)
ARCHS = arm64 arm64e

# Thiết lập chế độ Rootless cho Dopamine/Palera1n
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CCBorder

# Liệt kê các file source code (ở đây là Tweak.xm)
CCBorder_FILES = Tweak.xm
# Thêm các Framework hệ thống cần thiết để xử lý UI và Layer
CCBorder_FRAMEWORKS = UIKit QuartzCore Foundation
# Thêm thư viện hỗ trợ Hook
CCBorder_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk

# Lệnh sau khi cài đặt xong sẽ tự động Respring
after-install::
	install.exec "killall -9 SpringBoard"
