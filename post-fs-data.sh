#!/system/bin/sh

# 定义变量
MODEL=$(getprop ro.product.name)
OVERLAY_DIR="/data/overlay"

PRELOAD_DIR="/preload"
PRELOAD_OVERLAY_DIR="$OVERLAY_DIR/preload"
PRELOAD_WORK_DIR="$PRELOAD_OVERLAY_DIR/work"
PRELOAD_MERGED_DIR="$PRELOAD_OVERLAY_DIR/merged"

PRODUCT_H_DIR="/product_h"
PRODUCT_H_OVERLAY_DIR="$OVERLAY_DIR/product_h"
PRODUCT_H_WORK_DIR="$PRODUCT_H_OVERLAY_DIR/work"
PRODUCT_H_MERGED_DIR="$PRODUCT_H_OVERLAY_DIR/merged"

# 创建 overlayfs 所需的目录
mkdir -p "$PRELOAD_WORK_DIR" "$PRELOAD_MERGED_DIR"
mkdir -p "$PRODUCT_H_WORK_DIR" "$PRODUCT_H_MERGED_DIR"

# 创建 preload 的 overlayfs
mount -t overlay overlay -o lowerdir="$PRELOAD_DIR",upperdir="$PRELOAD_MERGED_DIR",workdir="$PRELOAD_WORK_DIR" "$PRELOAD_MERGED_DIR"

# 操作 preload
for dir in "$PRELOAD_MERGED_DIR"/*; do
    if [ -d "$dir" ] && [ "$(basename "$dir")" != "etc" ]; then
        rm -rf "$dir"
    fi
done

# 同步更改到 /preload
mount --bind "$PRELOAD_MERGED_DIR" "$PRELOAD_DIR"

# 创建 product_h 的 overlayfs
mount -t overlay overlay -o lowerdir="$PRODUCT_H_DIR",upperdir="$PRODUCT_H_MERGED_DIR",workdir="$PRODUCT_H_WORK_DIR" "$PRODUCT_H_MERGED_DIR"

# 操作 product_h
rm -rf $PRODUCT_H_MERGED_DIR/region_comm/china/app/DailyVideo
mkdir -p $PRODUCT_H_MERGED_DIR/hn_oem/$MODEL/media/
rm -rf $PRODUCT_H_MERGED_DIR/hn_oem/$MODEL/media/*bootanim*
rm -rf $PRODUCT_H_MERGED_DIR/etc/media/*bootanim*
cp /data/adb/mgcexp/bootanimation.zip $PRODUCT_H_MERGED_DIR/hn_oem/$MODEL/media/
cp /data/adb/mgcexp/bootanimation.zip $PRODUCT_H_MERGED_DIR/etc/media/
cp /data/adb/mgcexp/themes/* $PRODUCT_H_MERGED_DIR/region_comm/china/themes/
cp -r /data/adb/mgcexp/product_fonts $PRODUCT_H_MERGED_DIR/hn_oem/$MODEL/
cp -r /data/adb/mgcexp/aodThemes $PRODUCT_H_MERGED_DIR/etc/
cp -r /data/adb/mgcexp/honorcarconnect $PRODUCT_H_MERGED_DIR/region_comm/china/
cp /data/adb/mgcexp/privapp-permissions-product_h-addon.xml $PRODUCT_H_MERGED_DIR/etc/permissions/
cp -r /data/adb/mgcexp/app/* $PRODUCT_H_MERGED_DIR/app/
cat $PRODUCT_H_MERGED_DIR/etc/xml/APKInstallListRelease.txt /data/adb/mgcexp/APKInstallListRelease.txt > $PRODUCT_H_MERGED_DIR/etc/xml/APKInstallListRelease.txt
cat $PRODUCT_H_MERGED_DIR/etc/xml/DelAPKInstallListRelease.txt /data/adb/mgcexp/DelAPKInstallListRelease.txt > $PRODUCT_H_MERGED_DIR/etc/xml/DelAPKInstallListRelease.txt

# 同步更改到 /product_h
mount --bind "$PRODUCT_H_MERGED_DIR" "$PRODUCT_H_DIR"

# 清理
umount "$PRELOAD_MERGED_DIR"
umount "$PRODUCT_H_MERGED_DIR"
