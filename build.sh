#!/bin/sh

set -e

OTB_VERSION=0.8
OTB_BRANCH=master

[ -d openwrt ] || \
	git clone --depth=1 https://github.com/openwrt/openwrt --branch ${OTB_BRANCH}

rsync -avh files/ openwrt/files/
rsync -avh package/ openwrt/package/otb/

cat > openwrt/.config <<EOF
$(cat config)
CONFIG_DEVEL=y
CONFIG_DOWNLOAD_FOLDER="$(pwd)/dl"
CONFIG_PACKAGE_remote=y
CONFIG_PACKAGE_ca-certificates=y
CONFIG_PACKAGE_overthebox=y
EOF

echo "${OTB_VERSION}" > openwrt/version
touch openwrt/feeds.conf

[ -f setup.sh ] && sh setup.sh

make -C openwrt defconfig
make -C openwrt V=w -j"$(nproc)"
