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

   if user_group_id then
      clause = clause.." and ug.user_group_id = "..tostring(user_group_id)
   end
   local tables = "itvision_user_group ug, itvision_apps ap"
   local cols = "ap.name as name, ap.type as type, ug.name as ugname, user_group_id, ap.app_id as app_id"
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
   return render_show(web, ug)
end

itvision:dispatch_get(show, "/show/(%d+)")


function edit(web, user_group_id)
   local ap = apps:select_apps()
   local ug = user_group:select_user_group_app(user_group_id)
   return render_add(web, ap, ug)
end

itvision:dispatch_get(edit, "/edit/(%d+)")


function add(web)
   local ap = apps:select_apps()
   return render_add(web, ap)
end

itvision:dispatch_get(add, "/add")


function insert(web)
   user_group:new()
   --user_group.name = web.input.name
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


function render_list(web, ug)
   local rows = {}
   
   for i, v in ipairs(ug) do
      rows[#rows + 1] = tr{ 
         --td{ v.user_group_id },
         td{ a{ href= web:link("/show/"..v.user_group_id), v.ugname} },
         td{ v.name },
         td{ a{ href= web:link("/remove/"..v.user_group_id), strings.remove} },
         td{ a{ href= web:link("/edit/"..v.user_group_id), strings.edit} },
      }
   end

   local res = H("table") { border=1, cellpadding=1,
      thead{ 
         tr{ 
             --th{ "user_group_id" },
             th{ strings.user_group_name }, 
             th{ strings.application },
             th{ "." },
             th{ "." },
         }
      },
      tbody{
         rows
      }
   }
   res = res ..  a{ href= web:link("/add"), strings.add}
   return render_layout(res)
end


function render_show(web, ug)
   ug = ug[1]
   local res = {}
   if ug then
      res = { H("table") { border=1, cellpadding=1,
         tbody{
            --tr{ td{ "id" }, td{ ug.user_group_id } },
            tr{ th{ strings.user_group_name }, td{ ug.ugname } },
            tr{ th{ strings.type }, td{ ug.type } },
            tr{ th{ strings.application }, td{ ug.name } },
         }
      } }
      res[#res+1] =  a{ href= web:link("/add"), strings.add} .." "
      res[#res+1] =  a{ href= web:link("/remove/"..ug.user_group_id), strings.remove} .." "
      res[#res+1] =  a{ href= web:link("/edit/"..ug.user_group_id), strings.edit} .." "
      res[#res+1] =  a{ href= web:link("/list"), strings.list} .." "
   else
      res = { error_message(3),
         p(),
         a{ href= web:link("/list"), strings.list}, " ",
         a{ href= web:link("/add"), strings.add}, " ",
      }
   end

   return render_layout(res)
end


function render_add(web, ap, edit)
   local res = {}
   local ap_list = {} 
   local s = ""
   local sel = ""
   local val = ""
   local url = ""

   if edit then
      edit = edit[1]
      val = edit.ugname
      url = "/insert"
   else
      url = "/insert"
   end


--[[
   if string.find(input.app_id, "^%s*$") then
      return render_nothing(web, id, true)
   else
      local app_list = app_list:new()
      app_list.app_id = tonumber(id)
   end
]]
   for i, v in ipairs(ap) do
      if edit and (tonumber(edit.app_id) == tonumber(v.app_id)) then
         sel = " selected"
      else 
         sel = ""
      end

      ap_list[#ap_list + 1] = H("option"..sel) { value = v.app_id, label = v.name, v.name } 
   end

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link(url),
      strings.user_group_name..": ", input{ type="text", name="name", value = val }, 
      br(),
      strings.application..": ", H("select"){ name="root_app",  ap_list },
      br(),
      input.button{ type="submit", value=strings.send }, " ",
      input.button{ type="reset", value=strings.reset },
   }
   res[#res + 1] = a{ href= web:link("/list"), strings.list}

   return render_layout(res)
end


orbit.htmlify(itvision, "render_.+")

return _M
