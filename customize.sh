ui_print "---------------------------"
ui_print "Magical Experience 1.5 Full"
ui_print "---------------------------"
ui_print "正在清理缓存..."
rm -rf /data/overlay
rm -rf /data/adb/mgcexp/*
ui_print "正在准备资源文件..."
mkdir -p /data/adb/mgcexp
cd $MODPATH
chmod +x 7za
./7za x files.7z -o/data/adb/mgcexp/
rm -rf files.7z
ui_print "安装完毕,重启来开始你的魔法之旅吧"