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

local ac = require "model_access"
local ru = require "model_rules"

-- models

local apps = itvision:model "apps"
local user = itvision:model "user"
local user_group = itvision:model "user_group"

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

function user_group:select_user_group_app(user_group_id)
   local clause = "ug.root_app = ap.app_id"
   user_group_id = nil

   if user_group_id then
      clause = clause.." and ug.user_group_id = "..tostring(user_group_id)
   end
   local tables = "itvision_user_group ug, itvision_apps ap"
   local cols = "ap.name as name, ap.type as type, ug.name as ugname, user_group_id"
   local res = ac.select (tables, clause, "", cols) 

   return res
end

-- controllers

function list(web)
   local ug = user_group:select_user_group_app()
   return render_list(web, ug)
end

itvision:dispatch_get(list, "/", "/list")


function show(web, user_group_id)
   local ug = user_group:select_user_group_app(user_group_id)
   return render_show(web, ug, user_group_id)
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
         td{ v.ugname },
         td{ v.name },
         --td{ v.user_group_id },
         td{ a{ href= web:link("/remove/"..v.user_group_id), strings.remove} },
         td{ a{ href= web:link("/edit/"..v.user_group_id), strings.edit} },
         td{ a{ href= web:link("/show/"..v.user_group_id), strings.show} },
      }
   end

   local res = H("table") { border=1, cellpadding=1,
      thead{ 
         tr{ 
             th{ strings.user_group_name }, 
             th{ strings.application },
             --th{ "user_group_id" },
             th{ "." },
             th{ "." },
             th{ "." }
         }
      },
      tbody{
         rows
      }
   }
   res = res ..  a{ href= web:link("/add"), strings.add}
   return render_layout(res)
end


function render_show(web, ug, ug_id)
   local res = H("table") { border=1, cellpadding=1,
      tbody{
         tr{ td{ strings.user_group_name }, td{ ug.ugname } },
         tr{ td{ strings.type }, td{ ug.type } },
         tr{ td{ strings.application }, td{ ug.name } },
      }
   }
   res = res ..  a{ href= web:link("/add"), strings.add}
   res = res ..  ug_id .." "..tostring(#ug)
   --res = res ..  a{ href= web:link("/remove/"..ug.user_group_id), strings.remove}
   --res = res ..  a{ href= web:link("/edit/"..ug.user_group_id), strings.edit}
   return render_layout(res)
end


function render_add(web, ap)
   local res = {}
   local ap_list = {} 
   local s = ""

--[[
   if string.find(input.app_id, "^%s*$") then
      return render_nothing(web, id, true)
   else
      local app_list = app_list:new()
      app_list.app_id = tonumber(id)
   end
]]

   for i, v in ipairs(ap) do
         ap_list[#ap_list + 1] = H("option") { value = v.app_id, label = v.name, v.name }
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
