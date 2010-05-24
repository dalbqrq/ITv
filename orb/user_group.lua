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

local ru = require "model_rules"
local ac = require "model_rules"

-- models

apps = itvision:model "apps"
user = itvision:model "user"
user_group = itvision:model "user_group"

function apps:select_apps(app_id)
   local clause = ""
   if app_id then
      clause = "app_id = "..app_id
   end
   return self:find_all(clause)
end

function user:select_user(user_id)
   local clause = ""
   if user_id then
      clause = "user_id = "..user_id
   end
   return self:find_all(clause)
end

function user_group:select_user_group(user_group_id)
   local clause = ""
   if user_group_id then
      clause = "user_group_id = "..user_group_id
   end
   return self:find_all(clause)
end

-- controllers

function list(web)
   local ug = user_group:select_user_group()
   return render_list(web, ug)
end

itvision:dispatch_get(list, "/", "/list")


function show(web, user_group_id)
   local ug = user_group:select_user_group(user_group_id)
   return render_show(web, ug)
end

itvision:dispatch_get(show, "/show/(%d+)")


function add(web)
   local ap = apps:select_apps()
   return render_add(web, ap)
end

itvision:dispatch_get(add, "/add")


function insert(web)
   user_group.name = web.input.name
   user_group.root_app = web.input.root_app
   user_group:save()
   return web:redirect(web:link("/list"))
end

itvision:dispatch_post(insert, "/insert")


--[[
function add(web, id)
   local input = web.input
   id=3

   if string.find(input.app_id, "^%s*$") then
      return render_nothing(web, id, true)
   else
      local app_list = app_list:new()
      app_list.app_id = tonumber(id)
      --app_list.body = input.comment
   end


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
]]--

-- views

function render_layout(inner_html)
   return html{
     head{ title"ITvision" },
     body{ inner_html }
   }
end


function render_insert(web)
   local res = p{web.input.ap_list.." + "..web.input.user_group_name}
   return render_layout(res)
end


function render_list(web, ug)
   local rows = {}
   
   for i, v in ipairs(ug) do
      rows[#rows + 1] = tr{ 
         td{ v.name },
         td{ v.root_app }
      }
   end

   local res = H("table") { border=1, frame="border",
      thead{ 
         tr{ 
             th{ strings.user_group_name }, 
             th{ strings.application }
         }
      },
      tbody{
         rows
      }
   }
   return render_layout(res)
end


function render_show(web, ug)
   local res = p{"SHOW"}
   return render_layout(res)
end


function render_add(web, ap)
   local res = {}
   local ap_list = {} 
   local s = ""

   for i, v in ipairs(ap) do
         ap_list[#ap_list + 1] = H("option") { value = v.app_id, label = v.name }
   end

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link("/insert"),
      p { 
         strings.user_group_name..": ", input{ type="text", name="name", value = "" }, 
         br(),
         strings.application..": ", H("select"){ name="root_app",  ap_list },
         br(),
         input.button{ type="submit", value="Enviar" }, " ",
         input.button{ type="reset", value="Reset" }
      }
   }

   return render_layout(res)
end


orbit.htmlify(itvision, "render_.+")

return _M
