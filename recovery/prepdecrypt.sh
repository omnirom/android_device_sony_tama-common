#!/sbin/sh

relink()
{
	fname=$(basename "$1")
	target="/sbin/$fname"
	sed 's|/system/bin/linker64|///////sbin/linker64|' "$1" > "$target"
	chmod 755 $target
}

finish()
{
	umount /o
	umount /s
	rmdir /o
	rmdir /s
	setprop crypto.ready 1
	exit 0
}

# suffix is expected to remain empty for non-AB devices
suffix=$(getprop ro.boot.slot_suffix)
if [ -z "$suffix" ]; then
	suf=$(getprop ro.boot.slot)
	suffix="_$suf"
fi
oempath="/dev/block/bootdevice/by-name/oem$suffix"
mkdir /o
mount -t ext4 -o ro "$oempath" /o
syspath="/dev/block/bootdevice/by-name/system$suffix"
mkdir /s
mount -t ext4 -o ro "$syspath" /s

cp /o/lib64/libdiag.so /sbin/
cp /o/lib64/libdrmfs.so /sbin/
cp /o/lib64/libdrmtime.so /sbin/
cp /o/lib64/libqisl.so /sbin/
cp /o/lib64/libQSEEComAPI.so /sbin/
cp /o/lib64/librpmb.so /sbin/
cp /o/lib64/libssd.so /sbin/
cp /o/lib64/libtime_genoff.so /sbin/
cp /o/lib64/libkeymasterdeviceutils.so /sbin/
cp /o/lib64/libkeymasterprovision.so /sbin/

rm /odm/lib64
mkdir -p /odm/lib64/hw
cp /o/lib64/hw/android.hardware.gatekeeper@1.0-impl-qti.so /odm/lib64/hw/
cp /o/lib64/hw/android.hardware.keymaster@3.0-impl-qti.so /odm/lib64/hw/

relink /o/bin/qseecomd
relink /o/bin/hw/android.hardware.gatekeeper@1.0-service-qti
relink /o/bin/hw/android.hardware.keymaster@3.0-service-qti

is_fastboot_twrp=$(getprop ro.boot.fastboot)
if [ ! -z "$is_fastboot_twrp" ]; then
	osver=$(getprop ro.build.version.release_orig)
	patchlevel=$(getprop ro.build.version.security_patch_orig)
	setprop ro.build.version.release "$osver"
	setprop ro.build.version.security_patch "$patchlevel"
	finish
fi

build_prop_path="/s/build.prop"
if [ -f /s/system/build.prop ]; then
	build_prop_path="/s/system/build.prop"
fi
if [ -f "$build_prop_path" ]; then
	# TODO: It may be better to try to read these from the boot image than from /system
	osver=$(grep -i 'ro.build.version.release' "$build_prop_path"  | cut -f2 -d'=')
	patchlevel=$(grep -i 'ro.build.version.security_patch' "$build_prop_path"  | cut -f2 -d'=')
	setprop ro.build.version.release "$osver"
	setprop ro.build.version.security_patch "$patchlevel"
	finish
else
	# Be sure to increase the PLATFORM_VERSION in build/core/version_defaults.mk to override Google's anti-rollback features to something rather insane
	osver=$(getprop ro.build.version.release_orig)
	patchlevel=$(getprop ro.build.version.security_patch_orig)
	setprop ro.build.version.release "$osver"
	setprop ro.build.version.security_patch "$patchlevel"
	finish
fi
