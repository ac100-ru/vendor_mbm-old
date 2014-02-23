# Copyright (C) ST-Ericsson AB 2008-2014
# Copyright 2006 The Android Open Source Project
#
# Based on reference-ril
# Modified for ST-Ericsson U300 modems.
# Author: Christian Bejram <christian.bejram@stericsson.com>
#
# XXX using libutils for simulator build only...
#
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
  $(warning MBM RIL: Ice Cream Sandwich is set: $(MBM_ICS))
endif

LOCAL_SRC_FILES:= \
    u300-ril.c \
    u300-ril-config.h \
    u300-ril-messaging.c \
    u300-ril-messaging.h \
    u300-ril-network.c \
    u300-ril-network.h \
    u300-ril-pdp.c \
    u300-ril-pdp.h \
    u300-ril-requestdatahandler.c \
    u300-ril-requestdatahandler.h \
    u300-ril-device.c \
    u300-ril-device.h \
    u300-ril-sim.c \
    u300-ril-sim.h \
    u300-ril-oem.c \
    u300-ril-oem.h \
    u300-ril-error.c \
    u300-ril-error.h \
    u300-ril-stk.c \
    u300-ril-stk.h \
    atchannel.c \
    atchannel.h \
    misc.c \
    misc.h \
    fcp_parser.c \
    fcp_parser.h \
    at_tok.c \
    at_tok.h \
    net-utils.c \
    net-utils.h

LOCAL_SHARED_LIBRARIES := \
    libcutils libutils libril
# libnetutils

# For asprinf
LOCAL_CFLAGS := -D_GNU_SOURCE

LOCAL_C_INCLUDES := $(KERNEL_HEADERS) $(TOP)/hardware/ril/libril/

# Disable prelink, or add to build/core/prelink-linux-arm.map
LOCAL_PRELINK_MODULE := false

LOCAL_MODULE_TAGS := optional

# Build shared library
LOCAL_SHARED_LIBRARIES += \
    libcutils libutils
LOCAL_LDLIBS += -lpthread
LOCAL_LDLIBS += -lrt
LOCAL_CFLAGS += -DRIL_SHLIB
LOCAL_CFLAGS += -Wall
ifdef MBM_ICS
LOCAL_CFLAGS += -DMBM_ICS
endif
LOCAL_MODULE:= libmbm-ril
include $(BUILD_SHARED_LIBRARY)
