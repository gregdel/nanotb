#!/bin/sh

set -e

OTB_DIST=${OTB_DIST:-nanotb}
OTB_REPO=${OTB_REPO:-http://$(curl -sS ipaddr.ovh):8000}
OTB_SOURCE=https://github.com/ovh/overthebox-lede
OTB_NUMBER=17.06.18
OTB_VERSION=$(git rev-parse --short HEAD)

[ -d source ] || \
	git clone --depth 1 "${OTB_SOURCE}" --branch "otb-${OTB_NUMBER}" source

rsync -avh custom/ source/

cat > source/feeds.conf <<EOF
src-git packages https://git.lede-project.org/feed/packages.git;lede-17.01
src-link feed $(pwd)/feed
EOF

cd source

echo "${OTB_VERSION}" > version

cp .config .config.keep
./scripts/feeds update -a
./scripts/feeds install -a -d y -f -p feed
cp .config.keep .config

cat >> .config <<EOF
CONFIG_IMAGEOPT=y
CONFIG_VERSIONOPT=y
CONFIG_VERSION_DIST="${OTB_DIST}"
CONFIG_VERSION_REPO="${OTB_REPO}"
CONFIG_VERSION_NUMBER="${OTB_NUMBER}"
CONFIG_PACKAGE_${OTB_DIST}=y
EOF

make defconfig
make clean
make "$@" || exit

find bin -name '*.img*' -exec ./staging_dir/host/bin/usign -S -m {} -s key-build \;
