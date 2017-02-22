#!/bin/sh

set -e

OTB_TAG=$(git describe --tags --match='v[0-9].*' 2>/dev/null)
OTB_VERSION=${OTB_TAG#v}
OTB_BRANCH=master

[ -d openwrt ] || \
	git clone --depth=1 https://github.com/openwrt/openwrt --branch ${OTB_BRANCH}

rsync -avh files/ openwrt/files/
rsync -avh package/ openwrt/package/otb/

cat > openwrt/.config <<EOF
$(cat config)
CONFIG_DOWNLOAD_FOLDER="$(pwd)/dl"
EOF

echo "${OTB_VERSION}" > openwrt/version
touch openwrt/feeds.conf

[ -f setup.sh ] && sh setup.sh

make -C openwrt defconfig
make -C openwrt V=w -j"$(nproc)"
