#!/bin/sh

set -e

OTB_DIST=${OTB_DIST:-nanotb}
OTB_REPO=${OTB_REPO:-http://$(curl -sS ipaddr.ovh):8000}

OTB_BRANCH=${OTB_BRANCH:-x86_uefi}
OTB_SOURCE=https://github.com/sduponch/source.git

[ -d source ] || \
	git clone --depth=1 "${OTB_SOURCE}" --branch "${OTB_BRANCH}" source

cp -rf files source
cp -rf package source/package/otb

[ -f key-build ] && cp -f key-build* source

rm -rf source/.config
[ -f config ] && cp -f config source/.config

cd source

cat >> .config <<EOF
CONFIG_IMAGEOPT=y
CONFIG_VERSIONOPT=y
CONFIG_VERSION_DIST="${OTB_DIST}"
CONFIG_VERSION_REPO="${OTB_REPO}"
CONFIG_PACKAGE_${OTB_DIST}=y
EOF

case "$1" in
	pi3)
		cat >> .config <<-EOF
		CONFIG_TARGET_brcm2708=y
		CONFIG_TARGET_brcm2708_bcm2710=y
		CONFIG_TARGET_brcm2708_bcm2710_DEVICE_rpi-3=y
		EOF
		;;
	nuc)
		cat >> .config <<-EOF
		CONFIG_TARGET_x86=y
		CONFIG_TARGET_x86_64=y
		CONFIG_TARGET_x86_64_Generic=y
		EOF
		;;
esac

shift

OTB_VERSION=$(git describe --always)
echo "${OTB_VERSION}" > version

make defconfig
make "$@"

find bin -name "${OTB_DIST}*${OTB_VERSION}*" -and -not -name "*.sig" \
	-exec ./staging_dir/host/bin/usign -S -m {} -s key-build \;

find bin -name '*combined*.img.gz'     -execdir ln -sf {} latest.img.gz     \;
find bin -name '*combined*.img.gz.sig' -execdir ln -sf {} latest.img.gz.sig \;
