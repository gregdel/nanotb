#!/bin/sh

set -e

OTB_VERSION=0.8
OTB_BRANCH=lede-17.01
OTB_REPO=http://$(curl -sS ipaddr.ovh):8000

[ -d build ] || \
	git clone --depth=1 https://git.lede-project.org/source.git --branch ${OTB_BRANCH} build

rsync -avh files/ build/files/
rsync -avh package/ build/package/otb/

cat > build/.config <<EOF
$(cat config)
CONFIG_DEVEL=y
CONFIG_DOWNLOAD_FOLDER="$(pwd)/dl"
CONFIG_IMAGEOPT=y
CONFIG_VERSIONOPT=y
CONFIG_VERSION_DIST="nanOTB"
CONFIG_VERSION_REPO="${OTB_REPO}"
CONFIG_PACKAGE_otb-remote=y
CONFIG_PACKAGE_ca-bundle=y
CONFIG_PACKAGE_ca-certificates=y
CONFIG_PACKAGE_overthebox=y
EOF

echo "${OTB_VERSION}" > build/version
touch build/feeds.conf

[ -f key-build ] && cp -f key-build* build

(
	cd build
	make defconfig
	make clean
	make V=w -j"$(nproc)"
)
