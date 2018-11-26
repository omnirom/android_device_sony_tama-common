LOCAL_PATH := $(call my-dir)

# TWRP fstab
include $(CLEAR_VARS)
LOCAL_MODULE := twrp.fstab
LOCAL_SRC_FILES := twrp.fstab
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_STEM := twrp.fstab
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/etc
include $(BUILD_PREBUILT)

# Common USB setup
include $(CLEAR_VARS)
LOCAL_MODULE := init.recovery.usb
LOCAL_SRC_FILES := init.recovery.usb.rc
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_STEM := init.recovery.usb
LOCAL_MODULE_SUFFIX := .rc
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)
include $(BUILD_PREBUILT)

# TWRP specific setup
include $(CLEAR_VARS)
LOCAL_MODULE := init.recovery.twrp
LOCAL_SRC_FILES := init.recovery.twrp.rc
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_STEM := init.recovery.twrp
LOCAL_MODULE_SUFFIX := .rc
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)
include $(BUILD_PREBUILT)

# prepdecrypt
include $(CLEAR_VARS)
LOCAL_MODULE := prepdecrypt.sh
LOCAL_SRC_FILES := prepdecrypt.sh
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_STEM := prepdecrypt
LOCAL_MODULE_SUFFIX := .sh
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/sbin
include $(BUILD_PREBUILT)
