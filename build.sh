#!/bin/sh

set -e

OTB_DIST=${OTB_DIST:-nanotb}
OTB_REPO=${OTB_REPO:-http://$(curl -sS ipaddr.ovh):8000}

OTB_BRANCH=${OTB_BRANCH:-lede-17.01}
OTB_SOURCE=https://github.com/ovh/overthebox-lede

[ -d source ] || \
	git clone --depth=1 "${OTB_SOURCE}" --branch "${OTB_BRANCH}" source

rsync -avh custom/ source/

cd source

echo "${OTB_BRANCH}" > version

cat >> .config <<EOF
CONFIG_IMAGEOPT=y
CONFIG_VERSIONOPT=y
CONFIG_VERSION_DIST="${OTB_DIST}"
CONFIG_VERSION_REPO="${OTB_REPO}"
CONFIG_PACKAGE_${OTB_DIST}=y
EOF

rm -f files/etc/inittab

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
	v2b)
		cat >> .config <<-EOF
		CONFIG_TARGET_x86=y
		CONFIG_TARGET_x86_64=y
		CONFIG_TARGET_x86_64_Generic=y
		CONFIG_GRUB_SERIAL=""
		CONFIG_GRUB_TIMEOUT="0"
		EOF
		cat > files/etc/inittab <<-EOF
		::sysinit:/etc/init.d/rcS S boot
		::shutdown:/etc/init.d/rcS K shutdown
		tty1::askfirst:/usr/libexec/login.sh
		EOF
		;;
esac

shift

make defconfig
make clean
make "$@"

find bin -name "${OTB_DIST}*${OTB_VERSION}*" -and -not -name "*.sig" \
	-exec ./staging_dir/host/bin/usign -S -m {} -s key-build \;

find bin -name '*combined*.img.gz'     -execdir ln -sf {} latest.img.gz     \;
find bin -name '*combined*.img.gz.sig' -execdir ln -sf {} latest.img.gz.sig \;
