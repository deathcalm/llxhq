include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-llxh
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_SOURCE:=none
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=流量消耗器
  PKGARCH:=all
  DEPENDS:=+lua +luci-lib-jsonc +luasocket
endef

define Package/$(PKG_NAME)/description
  一个用于消耗流量的OpenWrt插件
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./luasrc $(PKG_BUILD_DIR)/
	$(CP) ./root $(PKG_BUILD_DIR)/
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(CP) $(PKG_BUILD_DIR)/luasrc/controller $(1)/usr/lib/lua/luci/
	$(CP) $(PKG_BUILD_DIR)/luasrc/model $(1)/usr/lib/lua/luci/
	$(CP) $(PKG_BUILD_DIR)/luasrc/view $(1)/usr/lib/lua/luci/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/root/etc/init.d/llxh $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/root/etc/config/llxh $(1)/etc/config/
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/luasrc/llxh.lua $(1)/usr/bin/llxh.lua
	$(INSTALL_DIR) $(1)/var/run
endef

$(eval $(call BuildPackage,$(PKG_NAME))) 