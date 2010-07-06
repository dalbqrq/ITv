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


function say(web, name, n1, n2)
   return render_say(web, name, n1, n2)
end

itvision:dispatch_get(say, "/say/(%a+):(%d+):(%d+)")


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


function add(web, post_id)
   local input = web.imput
   --return web:redirect(web:link("/post/" .. post_id))
   return render_add(web, post_id, web.input.user)
end

itvision:dispatch_post(add, "/add/(%d+)")


function form_input(web)
   return render_input(web)
end

itvision:dispatch_get(form_input, "/input")

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

function render_add(web, post_id, user)
   return render_layout(p.itvision((web.input.greeting or "Hello ") .. post_id .." & ".. user))
end

function render_input(web)
   local res = {}

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link("/add/30"),

      p{ "NAME:", input{ type="text", name="user", value = "Daniel" },
         br(),

         "form_email:", br(), input{ type="text", name="email",
         --value = web.input.email },
         value = web.prefix },
         br(),
         "form_url:", br(), input{ type="text", name="url",
         --value = web.input.url },
         value = web.real_path },
         br(),
         "Comentarion:", br(), err_msg,
         textarea{ name="comment", rows="10", cols="60", web.input.comment },
         br(),
         em(" *italics* "),
         strong(" **bold** "),
         " [" .. a{ href="/url", "link" } .. "](http://url) ",
         br(),

         input.button{ type="submit", value="Enviar" }
      }
   }
   res[#res + 1] = p.itvision "INPUT"
   return render_layout(res)
end


orbit.htmlify(itvision, "render_.+")

return _M
