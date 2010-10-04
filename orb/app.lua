#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "subsys_util"
require "view_utils"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local app        = Model.itvision:model "app"
local app_object = Model.itvision:model "app_object"
local hosts      = Model.nagios:model "hosts"
local services   = Model.nagios:model "services"

-- models ------------------------------------------------------------

function app:select_apps(id)
   local clause = ""
   if id then
      clause = "id = "..id
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
   local A = app:select_apps()
   return render_list(web, A)
end
ITvision:dispatch_get(list, "/", "/list")


function show(web, id)
   local A = app:select_apps(id)
   return render_show(web, A)
end 
ITvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id)
   local A = app:select_apps(id)
   return render_add(web, A)
end
ITvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, id)
   local A = {}
   if id then
      local tables = "itvision_app"
      local clause = "id = "..id
      A.name = web.input.name
      A.type = web.input.type
      A.is_active = web.input.is_active
      A.service_object_id = web.input.service_object_id

      Model.update (tables, A, clause) 
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
   local A = app:select_apps(id)
   return render_remove(web, A)
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

      local A = app:select_apps(id)
      local O = select_app_app_objects(id)
      activate_app(A, O, flag)

      Model.update (tables, cols, clause) 
   end
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_get(activate, "/activate/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, A)
   local rows = {}
   local res = {}
   local svc = {}
   
--[[
   res[#res + 1] = p{ strings.application..": ", str };
   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ br(), br() }
]]

   for i, v in ipairs(A) do
      if v.service_object_id then
         svc = services:select_services(v.service_object_id)[1].display_name
      else
         svc = "-"
      end

      if v.is_active == "0" then
         stract = strings.activate
      else
         stract = strings.deactivate
      end

      rows[#rows + 1] = tr{ class='tab_bg_1',
         td{ a{ href= web:link("/show/"..v.id), v.name} },
         td{ strings["logical_"..v.type] },
         td{ NoOrYes[v.is_active+1].name },
         --td{ svc },
         td{ button_link(strings.remove, web:link("/remove/"..v.id), "negative") },
         td{ button_link(strings.edit, web:link("/edit/"..v.id)) },
         td{ button_link(stract, web:link("/activate/"..v.id..":"..v.is_active)) },
      }
   end

   res[#res + 1]  = render_content_header("Applicação")
   res[#res + 1] = p{ br() }
   res[#res + 1]  = div{class='center'}
   res[#res + 1]  = H("table") { border="0", class="tab_cadrehov",
      thead{ 
         tr{ class="tab_bg_2", 
             th{ strings.name }, 
             th{ strings.type },
             th{ strings.is_active },
             th{ "." },
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
   res[#res + 1] = p{ button_link(strings.remove, web:link("/remove/"..A.id)) }
   res[#res + 1] = p{ button_link(strings.edit, web:link("/edit/"..A.id)) }
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   if A then
      if A.service_object_id then
         svc = services:select_services(A.service_object_id)[1].display_name
      else
         svc = "-"
      end

      res[#res + 1] = { H("table") { border=1, cellpadding=1,
         tbody{
            tr{ th{ strings.name }, td{ A.name } },
            tr{ th{ strings.type }, td{ strings["logical_"..A.type] } },
            tr{ th{ strings.is_active }, td{ NoOrYes[A.is_active+1].name } },
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


function render_remove(web, A)
   local res = {}
   local url = ""

   if A then
      A = A[1]
      url_ok = web:link("/delete/"..A.id)
      url_cancel = web:link("/list")
   end

   res[#res + 1] = p{
      strings.exclude_quest.." "..strings.application.." "..A.name.."?",
      p{ button_link(strings.yes, web:link(url_ok)) },
      p{ button_link(strings.cancel, web:link(url_cancel)) },
   }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


