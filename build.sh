#!/bin/sh

set -e

git fetch --all || true

OTB_NUMBER=$(git describe --tag --always)

OTB_SRC=${OTB_SRC:-17.06.18}
OTB_REPO=${OTB_REPO:-http://$(curl -sS ipaddr.ovh):8000}
OTB_DIST=nanotb

git clone https://github.com/ovh/overthebox-lede source || true
git -C source fetch --all
git -C source checkout "origin/otb-$OTB_SRC" -B "otb-$OTB_SRC"

echo "$OTB_SRC" > source/version

rsync -avh custom/ source/

cat > source/feeds.conf <<EOF
src-git packages https://git.lede-project.org/feed/packages.git;lede-17.01
src-git luci https://github.com/openwrt/luci.git;for-15.05
src-link feed $(readlink -f feed)
EOF

cat >> source/.config <<EOF
CONFIG_IMAGEOPT=y
CONFIG_VERSIONOPT=y
CONFIG_VERSION_DIST="$OTB_DIST"
CONFIG_VERSION_REPO="$OTB_REPO"
CONFIG_VERSION_NUMBER="$OTB_NUMBER"
CONFIG_PACKAGE_$OTB_DIST=y
EOF

cd source

echo "Building $(cat version)"

cp .config .config.keep
scripts/feeds update -a
scripts/feeds install -a -d y -f -p feed
cp .config.keep .config

make defconfig
make "$@"
