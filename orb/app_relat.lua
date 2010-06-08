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
local app_relat = itvision:model "app_relat"
local app_list = itvision:model "app_list"


-- config NAGIOS mvc app
nagios = orbit.new()
nagios.mapper.conn, nagios.mapper.driver = config.setup_orbdb()
nagios.mapper.table_prefix = 'nagios_'
local objects = nagios:model "objects"


-- models ------------------------------------------------------------

function apps:select_apps(id)
   local clause = ""
   if id then
      clause = "app_id = "..id
   end
   return self:find_all(clause)
end


function app_relat:select_app_relat(id)
   local clause = ""
   if id then
      clause = "app_id = "..id
   end
   return self:find_all(clause)
end


function app_list:select_app_list(id)
   local clause = ""
   if id then
      clause = "app_id = "..id
   end
   return self:find_all(clause)
end


function objects:select_objects(id)
   local clause = ""
   if id then
      clause = "object_id = "..id
   else
      clause = "objecttype_id < 3"
   end
   return self:find_all(clause)
end


-- controllers ------------------------------------------------------------

function list(web, id)
   local B = app_relat:select_app_relat()
   if id == "/" then 
      if B[1] then id = B[1].app_id else id = nil end
   end
   local A = mr.select_app_app_list_objects(id)
   return render_list(web, A, B)
end
itvision:dispatch_get(list, "/", "/list/(%d+)")


function show(web, id)
   local A = app_relat:select_app_relat(id)
   return render_show(web, A)
end itvision:dispatch_get(show, "/show/(%d+)")


function add(web, id)
   local H = mr.select_host_object()
   local S = mr.select_service_object()
   local A = mr.select_service_object(nil, nil, nil, true)
   local APPL = mr.select_app_app_list_objects(id)
   return render_add(web, H, S, A, APPL, id)
end
itvision:dispatch_get(add, "/add/(%d+)")


function insert(web)
   app_list:new()
   app_list.app_id = web.input.app_id
   app_list.type = web.input.type
   app_list.instance_id = config.db.instance_id
   app_list.object_id = web.input.item
   app_list:save()

   return web:redirect(web:link("/add/"..app_list.app_id))
end
itvision:dispatch_post(insert, "/insert")


function remove(web, app_id, obj_id)
   local A = app_relat:select_app_relat(app_id)
   local O = objects:select_objects(obj_id)
   return render_remove(web, A, O)
end
itvision:dispatch_get(remove, "/remove/(%d+):(%d+)")


function delete(web, app_id, obj_id)
   if app_id and obj_id then
      local clause = "app_id = "..app_id.." and object_id = "..obj_id
      local tables = "itvision_app_list"
      ma.delete (tables, clause) 
   end

   return web:redirect(web:link("/list/"..app_id))
end
itvision:dispatch_get(delete, "/delete/(%d+):(%d+)")


itvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function render_list(web, A, B)
   local rows = {}
   local res = {}
   local svc = {}
   local str = ""
   local selected = ""
   local curr_app = 0

   str = [[<FORM> <SELECT ONCHANGE="location = this.options[this.selectedIndex].value;">]]
   for i, v in ipairs(B) do
      url = web:link("/list/"..v.app_id)
      if tonumber(v.app_id) == tonumber(A[1].app_id) then 
         selected = " selected " 
         curr_app = i
      else 
         selected = " "
      end
      str = str .. [[<OPTION]]..selected..[[ VALUE="]]..url..[[">]]..v.name
   end
   str = str .. [[</SELECT> </FORM>]]


   res[#res + 1] = p{ strings.application..": ", str };
--[[
   res[#res + 1] = p{ render_table(web, A) }

   res[#res + 1] = p{ button_link(strings.add, web:link("/add/"..A[1].app_id)) }
   res[#res + 1] = p{ br(), br() }
]]

   return render_layout(res)
end


function render_table(web, A)
   local res = {}

   for i, v in ipairs(A) do
      local obj = v.name1
      if v.name2 then obj = v.name2.."@"..obj end

      rows[#rows + 1] = tr{ 
         td{ a{ href= web:link("/show/"..v.app_id), v.app_name} },
         td{ align="center", v.list_type },
         td{ align="right", obj },
         td{ button_link(strings.remove, web:link("/remove/"..v.app_id..":"..v.object_id), "negative") },
      }
   end

   res[#res + 1]  = H("table") { border=1, cellpadding=1,
      thead{ 
         tr{ 
             th{ strings.application }, 
             th{ strings.type },
             th{ strings.service.."@"..strings.host },
             th{ "." },
         }
      },
      tbody{
         rows
      }
   }

   return res
end


function render_show(web, A)
   --A = A[1]
   local res = {}
   local svc = {}
   local lst = {}

   web.prefix = "/orb/app_relat" 

   --res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ button_link(strings.remove, web:link("/remove/"..A.app_id)) }
   res[#res + 1] = p{ button_link(strings.edit, web:link("/edit/"..A.app_id)) }
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   if A then
      if A.service_object_id then
         svc = services:select_services(A.service_object_id)[1].display_name
         --lst = mr.select_host_object(...
      else
         svc = "-nonono-"
      end

      -- app
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

   return res
end


function render_add(web, H, S, A, APPL)
   local res = {}
   local hst = {}
   local svc = {}
   local app = {}
   local url = "/insert"
   local list_size = 7
   local s = ""
   local app_id = APPL[1].app_id

   local make_form = function(selopt)
      return form{
         name = "input",
         method = "post",
         action = web:link(url),
         p{ selopt },
         p{ button_form(strings.send, "submit", "positive") },
         p{ button_form(strings.reset, "reset", "negative") },
      }
   end


   -- LISTA DE OPERACOES 
   res[#res + 1] = p{ button_link(strings.list, web:link("/list/"..app_id)) }
   res[#res + 1] = p{ br(), br() }
   res[#res + 1] = p{ render_table(web, APPL) }
   res[#res + 1] = p{ br() }

   -- LISTA DE HOSTS PARA SEREM INCLUIDOS ---------------------------------
   s = [[<SELECT multiple size=]]..list_size..[[ NAME="item">]]
   for i,v in ipairs(H) do
     s = s..[[<OPTION VALUE="]]..v.object_id..[[">]]..v.name1
   end
   s = s..[[ </SELECT>
      <INPUT TYPE=HIDDEN NAME="app_id" value="]]..app_id..[[">
      <INPUT TYPE=HIDDEN NAME="type" value="hst"> ]]
   hst = make_form(s)

   -- LISTA DE SERVICES PARA SEREM INCLUIDOS ---------------------------------
   s = [[<SELECT multiple size=]]..list_size..[[ NAME="item">]]
   for i,v in ipairs(S) do
     s = s..[[<OPTION VALUE="]]..v.object_id..[[">]]..v.name2.."@"..v.name1
   end
   s = s..[[ </SELECT>
      <INPUT TYPE=HIDDEN NAME="app_id" value="]]..app_id..[[">
      <INPUT TYPE=HIDDEN NAME="type" value="svc"> ]]
   svc = make_form(s)

   -- LISTA DE APPLIC PARA SEREM INCLUIDOS ---------------------------------
   s = [[<SELECT multiple size=]]..list_size..[[ NAME="item">]]
   for i,v in ipairs(A) do
     s = s..[[<OPTION VALUE="]]..v.object_id..[[">]]..v.name2
   end
   s = s..[[ </SELECT>
      <INPUT TYPE=HIDDEN NAME="app_id" value="]]..app_id..[[">
      <INPUT TYPE=HIDDEN NAME="type" value="app"> ]]
   app = make_form(s)


   res[#res + 1] = [[<table border=1, cellpadding=1>]]
   res[#res + 1] = {
      thead{ tr{ 
         th{ strings.host }, 
         th{ strings.service }, 
         th{ strings.application }, 
      } },
      tbody{ tr{
         td{ hst },
         td{ svc },
         td{ app },
      } },
   }

   return render_layout(res)
end


function render_remove(web, A, O)
   local res = {}
   local url = ""

   if A then
      A = A[1]
      if O then
         O = O[1]
         if O.objecttype_id == 1 then
            obj = O.name1
         else 
            obj = O.name2.."@"..O.name1
         end
      end
      url_ok = "/delete/"..A.app_id..":"..O.object_id
      url_cancel = "/list"
   end

   res[#res + 1] = p{
      strings.exclude_quest.." o "..strings.host.."/"..strings.service.." "..obj.." da "..strings.application.." "..A.name.."?",
      p{ button_link(strings.yes, web:link("/delete/"..A.app_id..":"..O.object_id)) },
      p{ button_link(strings.cancel, web:link("/list/"..A.app_id)) },
   }

   return render_layout(res)
end


orbit.htmlify(itvision, "render_.+")

return _M


