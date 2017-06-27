include $(TOPDIR)/rules.mk

PKG_NAME:=otb-swconfig
PKG_VERSION:=0.1
PKG_RELEASE:=0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
SECTION:=OVH
CATEGORY:=OverTheBox
TITLE:=OverTheBox swconfig
PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
The OverTheBox swconfig tool
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) bin $(1)/bin/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/lib/network
	$(INSTALL_DATA) otb-switch.sh $(1)/lib/network
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
