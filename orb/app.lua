#!/usr/bin/env wsapi.cgi

require "orbit"

module("itvision", package.seeall, orbit.new)

-- configs

require "config"

local database = config.db
require("luasql." .. database.driver)
local env = luasql[database.driver]()
mapper.conn = env:connect(database.dbname, database.dbuser, database.dbpass)
mapper.driver = database.driver

-- models

app_list = itvision:model "app_list"

function app_list:find_app_list()
   return self:find_all("")
end

-- controllers

function index(web)
  return render_index()
end

function say(web, name, n1, n2)
  return render_say(web, name, n1, n2)
end

-- dispatchers

itvision:dispatch_get(index, "/", "/index")
itvision:dispatch_get(say, "/say/(%a+):(%d+):(%d+)")

-- views

function render_layout(inner_html)
   return html{
     head{ title"Hello" },
     body{ inner_html }
   }
end

function render_itvision()
   local s = "<p>"
   local a = app_list:find_app_list()
   for i,v in ipairs(a) do
      s = s.."[ "..v.app_id.." + "..v.object_id.." ] <p>"
   end
--[[
]]
   return p.itvision"Hello World!"..s
end

function render_index()
   return render_layout(render_itvision())
end

function render_say(web, name, n1, n2)
   return render_layout(render_itvision() .. 
     p.itvision((web.input.greeting or "Hello ") .. name .. " : " .. n1 .." : " .. n2 .." !"))
end

orbit.htmlify(itvision, "render_.+")

return _M
