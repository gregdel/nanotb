include $(TOPDIR)/rules.mk

PKG_NAME:=glorytun
PKG_VERSION:=0.0.90-mud
PKG_RELEASE:=5
PKG_SOURCE:=glorytun-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/angt/glorytun/releases/download/v$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
SECTION:=OVH
CATEGORY:=OverTheBox
DEPENDS:=+kmod-tun +libsodium +librt
TITLE:=Glorytun
URL:=https://github.com/angt/glorytun
endef

TARGET_CFLAGS += -std=c99 -D_GNU_SOURCE

define Package/$(PKG_NAME)/conffiles
/etc/config/$(PKG_NAME)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/bin
	$(INSTALL_BIN) start $(1)/usr/bin/$(PKG_NAME)-start
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) init $(1)/etc/init.d/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/config
	touch $(1)/etc/config/$(PKG_NAME)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
