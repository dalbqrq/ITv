#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "view_utils"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local app = Model.itvision:model "app"
local app_object = Model.itvision:model "app_object"
local objects = Model.nagios:model "objects"


-- models ------------------------------------------------------------

function app:select_apps(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
end


function app_object:select_app_object(id)
   local clause = ""
   if id then
      clause = "id = "..id
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
   local B = app:select_apps()
   --if (id == "/") and (B[1] ~= nil)  then id = B[1].id else id = nil end
   if type(tonumber(id)) ~= "number" then
      if id == "/" and B[1] ~= nil then id = B[1].id else id = nil end
   end

   local A = Model.select_app_app_objects(id)
   return render_list(web, A, B, id)
end
ITvision:dispatch_get(list, "/", "/list/(%d+)")


function show(web, id)
   local A = app:select_apps(id)
   return render_show(web, A, id)
end 
ITvision:dispatch_get(show, "/show/(%d+)")


function add(web, id)
   local H = Model.select_host_object()
   local S = Model.select_service_object()
   local A = Model.select_service_object(nil, nil, nil, true)
   local APPL = Model.select_app_app_objects(id)
   return render_add(web, H, S, A, APPL, id)
end
ITvision:dispatch_get(add, "/add/(%d+)")


-- TODO: problema na inclusão de multiplos itens
function insert(web)
   app_object:new()
--local r = ""
   if type(web.input.item) == "table" then
      for i, v in ipairs(web.input.item) do
         app_object.app_id = web.input.app_id
         app_object.type = web.input.type
         app_object.instance_id = Model.db.instance_id
         app_object.object_id = v
         app_object:save()
--r = r.."|"..v
      end
   else
      app_object.app_id = web.input.app_id
      app_object.type = web.input.type
      app_object.instance_id = Model.db.instance_id
      app_object.object_id = web.input.item
      app_object:save()
   end

   return web:redirect(web:link("/add/"..app_object.app_id))
end
ITvision:dispatch_post(insert, "/insert")


function remove(web, app_id, obj_id)
   local A = app:select_apps(app_id)
   local O = objects:select_objects(obj_id)
   return render_remove(web, A, O)
end
ITvision:dispatch_get(remove, "/remove/(%d+):(%d+)")


function delete(web, app_id, obj_id)
   if app_id and obj_id then
      local clause = "app_id = "..app_id.." and object_id = "..obj_id
      local tables = "itvision_app_object"
      Model.delete (tables, clause) 
   end

   web.prefix = "/orb/app_object"
   return web:redirect(web:link("/list/"..app_id))
end
ITvision:dispatch_get(delete, "/delete/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function render_list(web, A, B, app_id)
   local rows = {}
   local res = {}
   local svc = {}
   local str = ""
   local selected = ""
   local curr_app = 0
   local sel_app = app_id


   str = [[<FORM> <SELECT ONCHANGE="location = this.options[this.selectedIndex].value;">]]
   for i, v in ipairs(B) do
      url = web:link("/list/"..v.id)
      if tonumber(v.id) == tonumber(app_id) then 
         selected = " selected " 
         curr_app = i
         sel_app = v.id
      else 
         selected = " "
      end
      str = str .. [[<OPTION]]..selected..[[ VALUE="]]..url..[[">]]..v.name
   end
   str = str .. [[</SELECT> </FORM>]]


   res[#res + 1] = p{ strings.application..": ", str };
   if sel_app ~= nil then 
      web.prefix = "/orb/app_object"

      res[#res + 1] = p{ render_show(web, B[curr_app], sel_app) }

      res[#res + 1] = p{ button_link(strings.add, web:link("/add/"..app_id)) }
      res[#res + 1] = p{ br(), br() }
      res[#res + 1] = p{ render_table(web, A) }
    end

   return render_layout(res)
end


function render_table(web, A)
   local res = {}

   for i, v in ipairs(A) do
      local obj = v.name1
      if v.name2 then obj = v.name2.."@"..obj end
      web.prefix = "/orb/app_object"

      rows[#rows + 1] = tr{ 
         td{ a{ href= web:link("/show/"..v.app_id), v.app_name} },
         td{ align="center", v.obj_type },
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


function render_show(web, A, app_id)
   --A = A[1]
   local res = {}
   local svc = {}
   local lst = {}

   web.prefix = "/orb/app" 

   --res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ button_link(strings.remove, web:link("/remove/"..app_id)) }
   res[#res + 1] = p{ button_link(strings.edit, web:link("/edit/"..app_id)) }
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   if A then
      if A.service_object_id then
         --lst = Model.select_host_object(...
         svc = "-to change-"
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
      res = { error_message(6),
         p(),
         a{ href= web:link("/list"), strings.list}, " ",
         a{ href= web:link("/add"), strings.add}, " ",
      }
   end

   return res
end


function render_add(web, H, S, A, APPL, app_id)
   local res = {}
   local hst = {}
   local svc = {}
   local app = {}
   local url = "/insert"
   local list_size = 7
   local s = ""

   --local app_id = 0
   --if APPL[1] then app_id = APPL[1].app_id end

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
      url_ok = "/delete/"..A.id..":"..O.object_id
      url_cancel = "/list"
   end

   res[#res + 1] = p{
      strings.exclude_quest.." o "..strings.host.."/"..strings.service.." "..obj.." da "..strings.application.." "..A.name.."?",
      p{ button_link(strings.yes, web:link("/delete/"..A.id..":"..O.object_id)) },
      p{ button_link(strings.cancel, web:link("/list/"..A.id)) },
   }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


