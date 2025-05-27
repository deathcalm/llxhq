include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-llxh
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

LUCI_TITLE:=流量消耗器
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+lua +luci-lib-jsonc +luasocket

define Package/$(PKG_NAME)/conffiles
/etc/config/llxh
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./luasrc/llxh.lua $(1)/usr/bin/llxh.lua
endef

include $(TOPDIR)/feeds/luci/luci.mk