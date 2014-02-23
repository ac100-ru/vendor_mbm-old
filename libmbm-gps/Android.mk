# Use hardware GPS implementation if available.
#
ifeq ($(strip $(BOARD_USES_MBM_GPS)),true)

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

# Android version based on API (PLATFORM_SDK_VERSION)
#
# API Level 14 Android 4.0 to 4.0.2 Ice Cream Sandwich
# API Level 15 Android 4.0.3 to 4.0.4 Ice Cream Sandwich
# API Level 16 Android 4.1 Jelly Bean
# API Level 17 Android 4.2 Jelly Bean
# API Level 18 Android 4.3 Jelly Bean
# API Level 19 Android 4.4 KitKat
# 
# API 14, 15, and 16 supported
# API 17, 18, and 19 not verified
#
API_ICS:= 14 15
API_JB:= 16
API_SUPPORTED:= $(API_ICS) $(API_JB)

# Check if supported
ifeq "$(findstring $(PLATFORM_SDK_VERSION),$(API_SUPPORTED))" ""
  $(error -- Unsupported Android version; $(PLATFORM_SDK_VERSION))
endif

# If supported Ice Cream Sandwich API
ifneq "$(findstring $(PLATFORM_SDK_VERSION), $(API_ICS))" ""
  MBM_ICS := true
  $(warning MBM GPS: Ice Cream Sandwich is set: $(MBM_ICS))
endif

LOCAL_MODULE := gps.$(TARGET_DEVICE)
LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := \
	src/mbm_gps.c \
	src/nmea_reader.h \
	src/nmea_reader.c \
	src/nmea_tokenizer.h \
	src/nmea_tokenizer.c \
	src/gpsctrl/gps_ctrl.c \
	src/gpsctrl/gps_ctrl.h \
	src/gpsctrl/atchannel.c \
	src/gpsctrl/atchannel.h \
	src/gpsctrl/at_tok.c \
	src/gpsctrl/at_tok.h \
	src/gpsctrl/nmeachannel.c \
	src/gpsctrl/nmeachannel.h \
	src/gpsctrl/supl.c \
	src/gpsctrl/supl.h \
	src/gpsctrl/pgps.c \
	src/gpsctrl/pgps.h \
	src/mbm_service_handler.c \
	src/mbm_service_handler.h \
	src/gpsctrl/misc.c \
	src/gpsctrl/misc.h

LOCAL_SHARED_LIBRARIES := \
	libutils \
	libcutils \
	libdl \
	libc

LOCAL_CFLAGS := -Wall -Wextra
#LOCAL_CFLAGS += -DLOG_NDEBUG=0
#LOCAL_CFLAGS += -DSINGLE_SHOT
ifdef MBM_ICS
LOCAL_CFLAGS += -DMBM_ICS
endif

LOCAL_PRELINK_MODULE := false
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw

include $(BUILD_SHARED_LIBRARY)

endif
