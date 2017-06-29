#!/bin/sh

set -e

unset GREP_OPTIONS SED

git fetch --all || true

_get_repo() {
	git clone "$2" "$1" 2>/dev/null || true
	git -C "$1" remote set-url origin "$2"
	git -C "$1" fetch --all
	git -C "$1" checkout "origin/$3" -B "$3"
}

OTB_DIST=${OTB_DIST:-nanotb}
OTB_REPO=${OTB_REPO:-http://$OTB_HOST:$OTB_PORT/$OTB_PATH}

_get_repo source https://github.com/ovh/overthebox-lede "otb-17.06.28"
_get_repo feeds/packages https://github.com/openwrt/packages "lede-17.01"

if [ -n "$1" ] && [ -f "feed/$1/Makefile" ]; then
	OTB_DIST=$1
	shift 1
fi

rm -rf source/files
cp -rf root source/files

cat >> source/files/etc/banner <<EOF
-----------------------------------------------------
 PACKAGE:     $OTB_DIST
 VERSION:     $(git describe --tag --always)

 BUILD REPO:  $(git remote get-url origin)
 BUILD DATE:  $(date -u)
-----------------------------------------------------
EOF

cat > source/feeds.conf <<EOF
src-link packages $(readlink -f feeds/packages)
src-link feed $(readlink -f feed)
EOF

cat config -> source/.config <<EOF
CONFIG_IMAGEOPT=y
CONFIG_VERSIONOPT=y
CONFIG_VERSION_DIST="$OTB_DIST"
CONFIG_VERSION_REPO="$OTB_REPO"
CONFIG_VERSION_NUMBER="$(git describe --tag --always)"
CONFIG_VERSION_CODE=""
CONFIG_PACKAGE_$OTB_DIST=y
EOF

echo "Building $OTB_CODE"

cd source

cp .config .config.keep
scripts/feeds clean
scripts/feeds update -a
scripts/feeds install -a -d y -f -p feed
cp .config.keep .config

make defconfig

make "$@" || {
	make clean
	make "$@"
}
