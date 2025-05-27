local m, s, o

m = Map("llxh", translate("流量消耗器"), translate("一个用于消耗流量的OpenWrt插件"))

s = m:section(TypedSection, "llxh", translate("基本设置"))
s.anonymous = true

o = s:option(Flag, "enabled", translate("启用"))
o.default = 0
o.rmempty = false

o = s:option(Value, "threads", translate("线程数"))
o.datatype = "uinteger"
o.default = 3
o.rmempty = false

o = s:option(Value, "speed", translate("目标速度(MB/s)"))
o.datatype = "uinteger"
o.default = 10
o.rmempty = false

o = s:option(Value, "url", translate("下载地址"))
o.default = "https://speed.cloudflare.com/__down?bytes=25000000"
o.rmempty = false

o = s:option(Value, "interval", translate("检查间隔(秒)"))
o.datatype = "uinteger"
o.default = 5
o.rmempty = false

-- 添加速度显示
s = m:section(SimpleSection)
s.template = "llxh/speed"
s.anonymous = true

return m 