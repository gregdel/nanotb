include $(TOPDIR)/rules.mk

PKG_NAME:=otb-tracker
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_MAINTAINER:=Kevin Lanvin <kevin.lanvin@corp.ovh.com>

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=OVH
  CATEGORY:=OverTheBox
  TITLE:=otb-tracker
  DEPENDS:=+bind-dig +curl
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	A module to track OTB connections
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) bin $(1)/bin/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/lib
	$(INSTALL_DATA) lib $(1)/lib/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) init $(1)/etc/init.d/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) conf $(1)/etc/config/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/usr/share/otb/tracking.d
	$(INSTALL_BIN) scripts/* $(1)/usr/share/otb/tracking.d
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
