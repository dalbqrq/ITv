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

local r = require "model_rules"

-- models

app_list = itvision:model "app_list"
--app_relat = itvision:model "app_relat"
--app_relat_type = itvision:model "app_relat_type"
--app_tree = itvision:model "app_tree"
--apps = itvision:model "apps"
--config = itvision:model "config"
--contract = itvision:model "contract"
--device = itvision:model "device"
--device_host = itvision:model "device_host"
--location_tree = itvision:model "location_tree"
--manufacturer = itvision:model "manufacturer"
--site_tree = itvision:model "site_tree"
--user = itvision:model "user"
--user_group = itvision:model "user_group"

function app_list:select_app_list()
   return self:find_all("")
end

-- controllers

function index(web)
  return render_index()
end

itvision:dispatch_get(index, "/", "/index")
--itvision:dispatch_get(add_nothing, "/", "/index")


function say(web, name, n1, n2)
  return render_say(web, name, n1, n2)
end

itvision:dispatch_get(say, "/say/(%a+):(%d+):(%d+)")


function add_comment(web, post_id)
   local input = web.input
   if string.find(input.comment, "^%s*$") then
      return view_post(web, post_id, true)
   else
      local comment = comments:new()
      comment.post_id = tonumber(post_id)
      comment.body = input.comment
      if not string.find(input.author, "^%s*$") then
         comment.author = input.author
      end
      if not string.find(input.email, "^%s*$") then
         comment.email = input.email
      end
      if not string.find(input.url, "^%s*$") then
         comment.url = input.url
      end
      comment:save()
      local post = posts:find(tonumber(post_id))
      post.n_comments = (post.n_comments or 0) + 1
      post:save()
      cache:invalidate("/")
      cache:invalidate("/post/" .. post_id)
      cache:invalidate("/archive/" .. os.date("%Y/%m", post.published_at))
      return web:redirect(web:link("/post/" .. post_id))
   end
end

itvision:dispatch_get(add_comment, "/post/(%d+)/addcomment")


function add_nothing(web, id)
   local input = web.input
   id=3
--[[
   if string.find(input.app_id, "^%s*$") then
      return render_nothing(web, id, true)
   else
      local app_list = app_list:new()
      app_list.app_id = tonumber(id)
      --app_list.body = input.comment
   end
]]--
   --return web:redirect(web:link("/nothing/" .. id))
   local app_list = app_list:new()
   app_list.app_id = tonumber(id)
   app_list.type = "srv"
   return render_nothing(web, id, app_list)
end

--itvision:dispatch_get(add_nothing, "/nothing/(%d+)/addnothing")
itvision:dispatch_get(add_nothing, "/nothing/(%d+)")


-- views

function render_layout(inner_html)
   return html{
     head{ title"Hello" },
     body{ inner_html }
   }
end

function render_itvision()
   local s = "<p>"
   local a = app_list:select_app_list()
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

function render_nothing(web, id, app)
   return render_layout(p.itvision"Hello Nothing!"..id.." :: "..app.app_id.." :: "..app.type)
end

orbit.htmlify(itvision, "render_.+")

return _M
