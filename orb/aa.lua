#!/usr/bin/env wsapi.cgi

-- configs ------------------------------------------------------------

require "orbit"
require "config"
require "util"
require "view_utils"


-- config direct access to db
local ma = require "model_access"
local mr = require "model_rules"


-- config ITVISION mvc app
module("itvision", package.seeall, orbit.new)
mapper.conn, mapper.driver = config.setup_orbdb()
local apps = itvision:model "apps"


-- config NAGIOS mvc app
nagios = orbit.new()
nagios.mapper.conn, nagios.mapper.driver = config.setup_orbdb()
nagios.mapper.table_prefix = 'nagios_'
local services = nagios:model "services"


-- models ------------------------------------------------------------

function apps:select_apps(id)
   local clause = ""
   if id then
      clause = "app_id = "..id
   end
   return self:find_all(clause)
end


function services:select_services(id)
   local clause = ""
   if id then
      clause = "service_object_id = "..id
   end
   return self:find_all(clause)
end

-- controllers ------------------------------------------------------------

function list(web)
   local A = apps:select_apps()
   return render_list(web, A)
end
itvision:dispatch_get(list, "/", "/list")


function show(web, id)
   local A = apps:select_apps(id)
   return render_show(web, A)
end itvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id)
   local A = apps:select_apps(id)
   return render_add(web, A)
end
itvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, id)
   local A = {}
   if id then
      local tables = "itvision_apps"
      local clause = "app_id = "..id
      --A:new()
      A.name = web.input.name
      A.type = web.input.type
      A.is_active = web.input.is_active
      A.service_object_id = web.input.service_object_id

      ma.update (tables, A, clause) 
   end

   return web:redirect(web:link("/list"))
end
itvision:dispatch_post(update, "/update/(%d+)")


function add(web)
   return render_add(web)
end
itvision:dispatch_get(add, "/add")


function insert(web)
   apps:new()
   apps.name = web.input.name
   apps.type = web.input.type
   apps.is_active = web.input.is_active
   app.service_object_id = web.input.service_object_id
   apps.instance_id = config.db.instance_id
   apps:save()
   return web:redirect(web:link("/list"))
end
itvision:dispatch_post(insert, "/insert")


function remove(web, id)
   local A = apps:select_apps(id)
   return render_remove(web, A)
end
itvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   if id then
      local clause = "app_id = "..id
      local tables = "itvision_apps"
      ma.delete (tables, clause) 
   end

   return web:redirect(web:link("/list"))
end
itvision:dispatch_get(delete, "/delete/(%d+)")


itvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, A)
   local rows = {}
   local res = {}
   
   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ br(), br() }

local svc = {}
local so = ""

   for i, v in ipairs(A) do
      if v.service_object_id then
         svc = services:select_services(v.service_object_id)[1].display_name
      else
         svc = " -"
      end

      rows[#rows + 1] = tr{ 
         td{ a{ href= web:link("/show/"..v.app_id), v.name} },
         td{ strings["logical_"..v.type] },
         td{ NoOrYes[v.is_active+1].name },
         td{ svc },
         td{ button_link(strings.remove, web:link("/remove/"..v.app_id), "negative") },
         td{ button_link(strings.edit, web:link("/edit/"..v.app_id)) },
      }
   end

   res[#res + 1]  = H("table") { border=1, cellpadding=1,
      thead{ 
         tr{ 
             th{ strings.name }, 
             th{ strings.type },
             th{ strings.is_active },
             th{ strings.service },
             th{ "." },
             th{ "." },
         }
      },
      tbody{
         rows
      }
   }

   return render_layout(res)
end


function render_show(web, A)
   A = A[1]
   local res = {}

   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ button_link(strings.remove, web:link("/remove/"..A.app_id)) }
   res[#res + 1] = p{ button_link(strings.edit, web:link("/edit/"..A.app_id)) }
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   if A then
      res[#res + 1] = { H("table") { border=1, cellpadding=1,
         tbody{
            tr{ th{ strings.name }, td{ A.name } },
            tr{ th{ strings.type }, td{ A.type } },
            tr{ th{ strings.is_active }, td{ A.is_active } },
            tr{ th{ strings.service }, td{ A.service_object_id } },
         }
      } }
   else
      res = { error_message(3),
         p(),
         a{ href= web:link("/list"), strings.list}, " ",
         a{ href= web:link("/add"), strings.add}, " ",
      }
   end

   return render_layout(res)
end


function render_add(web, edit)
   local res = {}
   local s = ""
   local val1 = ""
   local val2 = ""
   local val3 = ""
   local url = ""
   local default_value = ""

   if edit then
      edit = edit[1]
      val1 = edit.name
      val2 = edit.type
      val3 = edit.is_active
      val4 = edit.service_object_id
      url = "/update/"..edit.app_id
      default_val2 = val2
      default_val3 = val3
   else
      url = "/insert"
      default_val2 = "and"
      default_val3 = 0
   end

   -- LISTA DE OPERACOES 
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link(url),

      strings.name..": ", input{ type="text", name="name", value = val1 },br(),
      strings.type..": ", select_and_or("type", default_val2), br(),
      --strings.service..": ", select_option("service_object_id", services:find_all(), "service_object_id", 
      strings.service..": ", select_option("service_object_id", services:find_all(""), "service_object_id", 
         "display_name", val4 ), br(),
      strings.is_active..": ", select_yes_no("is_active", default_val3), br(),

      p{ button_form(strings.send, "submit", "positive") },
      p{ button_form(strings.reset, "reset", "negative") },
   }

   return render_layout(res)
end


function render_remove(web, A)
   local res = {}
   local url = ""

   if A then
      A = A[1]
      url_ok = web:link("/delete/"..A.app_id)
      url_cancel = web:link("/list")
   end

   res[#res + 1] = p{
      strings.exclude_quest.." "..strings.application.." "..A.name.."?",
      p{ button_link(strings.yes, web:link(url_ok)) },
      p{ button_link(strings.cancel, web:link(url_cancel)) },
   }

   return render_layout(res)
end


orbit.htmlify(itvision, "render_.+")

return _M

