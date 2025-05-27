module("luci.controller.llxh", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/llxh") then
        return
    end

    entry({"admin", "services", "llxh"}, cbi("llxh"), _("流量消耗器"), 60).dependent = true
    entry({"admin", "services", "llxh", "status"}, call("action_status")).leaf = true
    entry({"admin", "services", "llxh", "speed"}, call("action_speed")).leaf = true
end

function action_status()
    local sys  = require "luci.sys"
    local util = require "luci.util"
    local uci  = require "luci.model.uci".cursor()

    local status = {
        running = (sys.process.list()["llxh"] ~= nil)
    }

    luci.http.prepare_content("application/json")
    luci.http.write_json(status)
end

function action_speed()
    local sys  = require "luci.sys"
    local util = require "luci.util"
    local uci  = require "luci.model.uci".cursor()
    
    -- 从/var/run/llxh.speed读取当前速度
    local speed = "0"
    local f = io.open("/var/run/llxh.speed", "r")
    if f then
        speed = f:read("*all")
        f:close()
    end
    
    local data = {
        speed = speed
    }
    
    luci.http.prepare_content("application/json")
    luci.http.write_json(data)
end 