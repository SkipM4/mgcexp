ui_print "---------------------------"
ui_print "Magical Experience 1.3 Full"
ui_print "---------------------------"
ui_print "正在清理缓存..."
rm -rf /data/overlay
rm -rf /data/adb/mgcexp/*
ui_print "正在准备资源文件..."
mkdir -p /data/adb/mgcexp
cp -r $MODPATH/files/* /data/adb/mgcexp/
ui_print "安装完毕,重启来开始你的魔法之旅吧"