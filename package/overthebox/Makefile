include $(TOPDIR)/rules.mk

PKG_NAME:=overthebox
PKG_VERSION:=0.1
PKG_RELEASE:=0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
SECTION:=OVH
CATEGORY:=OverTheBox
DEPENDS:=+glorytun +graph +curl +ca-bundle
TITLE:=OverTheBox
URL:=https://www.ovhtelecom.fr/overthebox/
endef

define Package/$(PKG_NAME)/description
OverTheBox daemon
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/$(PKG_NAME)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) otb-* $(1)/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) init $(1)/etc/init.d/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_BIN) hotplug $(1)/etc/hotplug.d/iface/90-$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/config
	touch $(1)/etc/config/$(PKG_NAME)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
