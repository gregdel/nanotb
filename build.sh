#!/bin/sh

OTB_TAG=`git describe --tags --match='v[0-9].*' 2>/dev/null`

export OTB_VERSION=${OTB_TAG#v}
export OTB_BRANCH=master

[ -d openwrt ] || \
	git clone --depth=1 https://github.com/openwrt/openwrt --branch ${OTB_BRANCH}

rsync -avh files/ openwrt/files/
rsync -avh package/ openwrt/package/otb/

[ -d ~/dl ] && rsync -avh ~/dl/ openwrt/dl/

cp config openwrt/.config

[ -f setup.sh ] && sh setup.sh

cd openwrt

echo ${OTB_VERSION} > version

cat > feeds.conf <<EOF
src-git packages https://github.com/openwrt/packages.git
EOF

./scripts/feeds update -a
./scripts/feeds install -p packages sqm-scripts sqm-scripts-extra

make defconfig
make clean
make -j$(nproc)

cd ..

[ -d ~/dl ] && rsync -avh openwrt/dl/ ~/dl/
