#!/bin/bash
#=================================================
#   Description: DIY script
#   Lisence: MIT
#   Author: P3TERX
#   Blog: https://p3terx.com
#=================================================
#克隆源码
git clone -b dev-19.07 https://github.com/Lienol/openwrt
git clone https://github.com/a736399919/hello-world lede
cd openwrt
#sed -i '/luci/d' feeds.conf.default
#sed -i '$a src-git luci https://github.com/coolsnowwolf/luci' feeds.conf.default
#sed -i '$a src-git extra https://github.com/Andy2244/openwrt-extra.git' feeds.conf.default
./scripts/feeds update -a
#./scripts/feeds install -f -p extra -a
./scripts/feeds install -a
#添加自定义插件
git clone https://github.com/Ameykyl/luci-app-koolproxyR.git package/luci-app-koolproxyR
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
git clone https://github.com/maxlicheng/luci-app-unblockmusic.git package/luci-app-unblockmusic
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone https://github.com/Lienol/openwrt-package.git package/openwrt-package

#删除自带的插件
rm -rf feeds/extra/luci-app-samba4
rm -rf package/lean/luci-app-koolproxyR
rm -rf package/lean/luci-app-serverchan
rm -rf package/lean/luci-app-unblockmusic
rm -rf package/lean/qBittorrent/Makefile
rm -rf package/lean/qBittorrent/patches
cp -f ../qb421 package/lean/qBittorrent/Makefile

#添加自己repo的插件的软连接
cp -rf ../lede/luci-theme-argon1.x package
#ln -s ../../luci-theme-argon1.x ./package/
#ln -s ../../luci-app-flowoffload_ADGHome ./package/

#修改lan口地址
sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

#修改机器名称
sed -i 's/OpenWrt/Newifi-Y1/g' package/base-files/files/bin/config_generate

#修改wifi名称
sed -i 's/OpenWrt/FK20100010/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#修改时区
#sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

#修改zzz-default-settings的配置
#sed -i '46,48d' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i\chmod 755 /etc/init.d/serverchan' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i\chmod 755 /usr/bin/serverchan/serverchan' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i\echo 0xDEADBEEF > /etc/config/google_fu_mode\n' package/lean/default-settings/files/zzz-default-settings

#修改banner
rm -rf package/base-files/files/etc/banner
cp -f ../lede/banner package/base-files/files/etc/
