#
# Copyright (C) 2014-2018 OpenWrt-dist
# Copyright (C) 2014-2018 eSirPlayground
#
# Copyright (C) 2015-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
#

## Under contruction, useless.

include $(TOPDIR)/rules.mk

PKG_NAME:=ChinaDNS-NG
PKG_VERSION:=0.1
PKG_SOURCE_VERSION:=56c4fbe8347fa656a400c4ebf2600ff3da070047
PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=zfl9

PKG_SOURCE_PROTO:=git
PKG_SOURCE:=chinadns-ng-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/zfl9/chinadns-ng/releases/$(PKG_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/chinadns-ng-$(PKG_VERSION)
PKG_HASH:=skip

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=ChinaDNS-NG
	DEPENDS:=
	URL:=https://github.com/zfl9/chinadns-ng
endef

define Package/$(PKG_NAME)/description
Openwrt port of New Generation Anti-DNS poisoning in China.
endef


ifeq ($(ARCH),x86_64)
	PKG_ARCH_ChinaDNS-NG:=linux_amd64
endif
ifeq ($(ARCH),i386)
	PKG_ARCH_ChinaDNS-NG:=linux_386
endif
ifeq ($(ARCH),mipsel)
	PKG_ARCH_ChinaDNS-NG:=linux_mipsle
endif
ifeq ($(ARCH),mips)
	PKG_ARCH_ChinaDNS-NG:=linux_mips
endif

ifeq ($(ARCH),arm)
PKG_ARCH_ChinaDNS-NG:=linux_armv6
	ifeq ($(BOARD),kirkwood)
		PKG_ARCH_ChinaDNS-NG:=linux_armv5
	endif
	ifneq ($(BOARD),bcm53xx)
		PKG_ARCH_ChinaDNS-NG:=linux_armv7
	endif
endif

ifeq ($(ARCH),aarch64)
	PKG_ARCH_ChinaDNS-NG:=linux_armv8
endif


define Build/Prepare
	[ ! -f $(PKG_BUILD_DIR)/ChinaDNS-NG_$(PKG_ARCH_ChinaDNS-NG).tar.gz ] && wget  https://github.com/zfl9/ChinaDNS-NG/releases/download/$(PKG_VERSION)/ChinaDNS-NG_$(PKG_ARCH_ChinaDNS-NG).tar.gz -O $(PKG_BUILD_DIR)/ChinaDNS-NG_$(PKG_ARCH_ChinaDNS-NG).tar.gz
	tar -xzvf $(PKG_BUILD_DIR)/ChinaDNS-NG_$(PKG_ARCH_ChinaDNS-NG).tar.gz -C $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	chmod +x $(PKG_BUILD_DIR)/ChinaDNS-NG/ChinaDNS-NG
endef


define Package/ChinaDNS-NG/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/iplist.txt $(1)/etc/chinadns_iplist.txt
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/chnroute.txt $(1)/etc/chinadns_chnroute.txt
	$(INSTALL_BIN) ./files/ChinaDNS-NG.init $(1)/etc/init.d/ChinaDNS-NG
	$(INSTALL_DIR) $(1)/usr/share
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ChinaDNS-NG $(1)/usr/share
endef

$(eval $(call BuildPackage,ChinaDNS-NG))