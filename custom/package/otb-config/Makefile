include $(TOPDIR)/rules.mk

PKG_NAME:=otb-config
PKG_VERSION:=0.1
PKG_RELEASE:=0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
SECTION:=OVH
CATEGORY:=OverTheBox
DEPENDS:=+glorytun +graph +overthebox
TITLE:=OverTheBox config
PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
OverTheBox config
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) otb-* $(1)/bin
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
