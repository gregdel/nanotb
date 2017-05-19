#!/bin/sh

set -e

OTB_DIST=${OTB_DIST:-nanotb}
OTB_REPO=${OTB_REPO:-http://$(curl -sS ipaddr.ovh):8000}

OTB_BRANCH=${OTB_BRANCH:-lede-17.01}
OTB_SOURCE=https://github.com/ovh/overthebox-lede

OTB_VERSION=$(git rev-parse --short HEAD)

[ -d source ] || \
	git clone --depth=1 "${OTB_SOURCE}" --branch "${OTB_BRANCH}" source

rsync -avh custom/ source/

cd source

echo "${OTB_VERSION}" > version

cat >> .config <<EOF
CONFIG_IMAGEOPT=y
CONFIG_VERSIONOPT=y
CONFIG_VERSION_DIST="${OTB_DIST}"
CONFIG_VERSION_REPO="${OTB_REPO}"
CONFIG_PACKAGE_${OTB_DIST}=y
EOF

make defconfig
make clean
make "$@"

find bin -name "${OTB_DIST}*${OTB_VERSION}*" -and -not -name "*.sig" \
	-exec ./staging_dir/host/bin/usign -S -m {} -s key-build \;

find bin -name '*combined*.img.gz'     -execdir ln -sf {} latest.img.gz     \;
find bin -name '*combined*.img.gz.sig' -execdir ln -sf {} latest.img.gz.sig \;
