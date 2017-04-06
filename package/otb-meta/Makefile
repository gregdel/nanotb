include $(TOPDIR)/rules.mk

PKG_NAME:=otb-meta
PKG_VERSION:=1.2
PKG_RELEASE:=0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
SECTION:=OVH
CATEGORY:=OverTheBox
DEPENDS:=+otb-remote +overthebox
TITLE:=OverTheBox meta
PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
OverTheBox meta
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc
	echo "$(PKG_VERSION)-$(PKG_RELEASE)+nanotb" > $(1)/etc/otb-version
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
