#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "monitor_util"
require "View"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local app        = Model.itvision:model "app"
local app_object = Model.itvision:model "app_object"
local hosts      = Model.nagios:model "hosts"
local services   = Model.nagios:model "services"
local computers  = Model.glpi:model "computers"

-- models ------------------------------------------------------------

function computers:select_computers(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
end


function computers:select_ci_ports(itemtype)
   return Model.select_ci_ports(itemtype)
end


function computers:select_computers_ports(id)
   local clause = ""
   if id then
      clause = "ic.id = "..id
   end
   return Model.select_ci_ports("Computer", clause)
end


-- controllers ------------------------------------------------------------

function list(web)
   local C = Model.select_monitors()
   return render_list(web, C)
end
ITvision:dispatch_get(list, "/", "/list")


function show(web, id)
   local C = app:select_apps(id)
   return render_show(web, C)
end 
ITvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id)
   local C = app:select_apps(id)
   return render_add(web, C)
end
ITvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, id)
   local C = {}
   if id then
      local tables = "itvision_app"
      local clause = "id = "..id
      C.name = web.input.name
      C.type = web.input.type
      C.is_active = web.input.is_active
      C.service_object_id = web.input.service_object_id

      Model.update (tables, C, clause) 
   end

   return web:redirect(web:link("/list"))
end
ITvision:dispatch_post(update, "/update/(%d+)")


function add(web)
   return render_add(web)
end
ITvision:dispatch_get(add, "/add")


function insert(web)
   app:new()
   app.name = web.input.name
   app.type = web.input.type
   app.is_active = web.input.is_active
   --app.service_object_id = web.input.service_object_id
   app.instance_id = Model.db.instance_id
   app:save()
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_post(insert, "/insert")


function remove(web, id)
   local C = app:select_apps(id)
   return render_remove(web, C)
end
ITvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   if id then
      local clause = "id = "..id
      local tables = "itvision_app"
      Model.delete (tables, clause) 
   end

   return web:redirect(web:link("/list"))
end
ITvision:dispatch_get(delete, "/delete/(%d+)")


function activate(web, id, flag)
   if flag == "0" then flag = 1 else flag = 0 end
   local cols = {}
   if id then
      local clause = "id = "..id
      local tables = "itvision_app"
      cols.is_active = flag

      local C = app:select_apps(id)
      local O = select_app_app_objects(id)
      activate_app(C, O, flag)

      Model.update (tables, cols, clause) 
   end
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_get(activate, "/activate/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, C)
   local row = {}
   local res = {}
   
   local header =  { strings.name, "IP", strings.service, strings.type, 
      strings.command, "." }

   for i, v in ipairs(C) do
      row[#row + 1] = { 
         a{ href= web:link("/show/"..v.c_id), v.c_name}, 
         v.n_ip, 
         v.svc_display_name,
         v.n_itemtype,
         v.svc_check_command_object_id,
         a{ href= web:link("/show/"..v.c_id..":"), strings.add} }
   end

   res[#res+1] = render_content_header("Checagem", web:link("/add"), web:link("/list"))
   res[#res+1] = render_table(row, header)

   return render_layout(res)
end


function render_show(web, C)
   C = C[1]
   local res = {}

   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ button_link(strings.remove, web:link("/remove/"..C.id)) }
   res[#res + 1] = p{ button_link(strings.edit, web:link("/edit/"..C.id)) }
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   if C then
      if C.service_object_id then
         svc = services:select_services(C.service_object_id)[1].display_name
      else
         svc = "-"
      end

      res[#res + 1] = { H("table") { border=1, cellpadding=1,
         tbody{
            tr{ th{ strings.name }, td{ C.name } },
            tr{ th{ strings.type }, td{ strings["logical_"..C.type] } },
            tr{ th{ strings.is_active }, td{ NoOrYes[C.is_active+1].name } },
            --tr{ th{ strings.service }, td{ svc } },
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
      url = "/update/"..edit.id
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
--[[
      strings.service..": ", select_option("service_object_id", services:find_all(""), "service_object_id", 
         "display_name", val4 ), br(),
      strings.is_active..": ", select_yes_no("is_active", default_val3), br(),
]]
      "<INPUT TYPE=HIDDEN NAME=\"is_active\" value=\"0\">",

      p{ button_form(strings.send, "submit", "positive") },
      p{ button_form(strings.reset, "reset", "negative") },
   }

   return render_layout(res)
end


function render_remove(web, C)
   local res = {}
   local url = ""

   if C then
      C = C[1]
      url_ok = web:link("/delete/"..C.id)
      url_cancel = web:link("/list")
   end

   res[#res + 1] = p{
      strings.exclude_quest.." "..strings.application.." "..C.name.."?",
      p{ button_link(strings.yes, web:link(url_ok)) },
      p{ button_link(strings.cancel, web:link(url_cancel)) },
   }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


