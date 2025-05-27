#!/usr/bin/lua

local socket = require("socket")
local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("json")

-- 解析命令行参数
local args = {}
for i = 1, #arg do
    if arg[i] == "-t" then
        args.threads = tonumber(arg[i + 1])
    elseif arg[i] == "-u" then
        args.url = arg[i + 1]
    elseif arg[i] == "-i" then
        args.interval = tonumber(arg[i + 1])
    end
end

-- 默认值
args.threads = args.threads or 3
args.url = args.url or "https://speed.cloudflare.com/__down?bytes=25000000"
args.interval = args.interval or 5

-- 下载函数
local function download(url)
    local response = {}
    local result, code = http.request{
        url = url,
        sink = ltn12.sink.table(response)
    }
    return result, code, response
end

-- 写入速度到文件
local function write_speed(speed)
    local f = io.open("/var/run/llxh.speed", "w")
    if f then
        f:write(string.format("%.2f", speed))
        f:close()
    end
end

-- 创建下载线程
local function create_download_thread(url)
    return function()
        local total_bytes = 0
        local start_time = socket.gettime()
        
        while true do
            local result, code, response = download(url)
            if result then
                total_bytes = total_bytes + #table.concat(response)
            end
            
            local current_time = socket.gettime()
            local duration = current_time - start_time
            if duration >= 1 then
                local speed = total_bytes / duration / 1024 / 1024 -- 转换为MB/s
                total_bytes = 0
                start_time = current_time
                return speed
            end
        end
    end
end

-- 主循环
while true do
    local total_speed = 0
    local threads = {}
    
    -- 创建所有下载线程
    for i = 1, args.threads do
        threads[i] = create_download_thread(args.url)
    end
    
    -- 运行所有线程并汇总速度
    for i = 1, args.threads do
        local speed = threads[i]()
        total_speed = total_speed + speed
    end
    
    -- 写入总速度到文件
    write_speed(total_speed)
    
    print(string.format("总下载速度: %.2f MB/s", total_speed))
    
    socket.sleep(1) -- 每秒更新一次
end 