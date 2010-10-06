#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "view_utils"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local app = Model.itvision:model "app"
local app_object = Model.itvision:model "app_object"
local app_relat = Model.itvision:model "app_relat"
local app_relat_type = Model.itvision:model "app_relat_type"
local objects = Model.nagios:model "objects"


-- models ------------------------------------------------------------

function app:select_apps(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
end


function app_relat:select_app_relat(id, from, to)
   local clause = ""
   if id then
      clause = "app_id = "..id
   end
   if from and to then
      if clause ~= "" then clause = clause.." and " end
      clause = clause.." from_object_id = "..from.." and to_object_id = "..to 
   end
   return self:find_all(clause)
end


function app_relat:delete_app_relat(id, from, to)
   local clause = ""
   if id and from and to then
      clause = " app_id = "..id.." and from_object_id = "..from.." and to_object_id = "..to 
   end
   --self:find_all(clause)
   --self:delete()
   Model.delete("itvision_app_relat", clause)
end


function app_object:select_app_objects(id)
   local clause = ""
   if id then
      clause = "app_id = "..id
   end
   return self:find_all(clause)
end


function app_relat_type:select_app_relat_type(id)
   local clause = ""
   if id then
      clause = "app_relat_type_id = "..id
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
   local A = app:select_apps()
   if id == "/" then 
      if A[1] then id = A[1].id else id = nil end
   end
   local AR = Model.select_app_relat_object(id)
   return render_list(web, id, A, AR)
end
ITvision:dispatch_get(list, "/", "/list/(%d+)")


function show(web, id)
   local A = app_relat:select_app_relat(id)
   return render_show(web, A)
end 
ITvision:dispatch_get(show, "/show/(%d+)")


function add(web, id)
   local A = app:select_apps()
   if id == "/" then 
      if A[1] then id = A[1].app_id else id = nil end
   end
   local AR = Model.select_app_relat_object(id)
   local AL = Model.select_app_app_objects(id)
   local RT = app_relat_type:select_app_relat_type()
   return render_add(web, id, A, AR, AL, RT)
end
ITvision:dispatch_get(add, "/add/(%d+)")


function insert(web)
   app_relat:new()

   app_relat.app_id = web.input.app_id
   app_relat.from_object_id = web.input.from
   app_relat.to_object_id = web.input.to
   app_relat.instance_id = Model.db.instance_id
   app_relat.app_relat_type_id = web.input.relat

   app_relat:save()

   return web:redirect(web:link("/add/"..app_relat.app_id))
end
ITvision:dispatch_post(insert, "/insert")


function remove(web, app_id, from, to)
   local A = app_relat:select_app_relat(app_id, from, to)
   local AR = Model.select_app_relat_object(id, from, to)
   return render_remove(web, A, AR)
end
ITvision:dispatch_get(remove, "/remove/(%d+):(%d+):(%d+)")


function delete(web, app_id, from, to)
   app_relat:delete_app_relat(app_id, from, to)
   return web:redirect(web:link("/list/"..app_id))
end
ITvision:dispatch_get(delete, "/delete/(%d+):(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_selector(web, A, id, path)
   local url = ""
   local str = ""
   local selected = ""
   local curr_app = 0
   id = id or -1

   str = [[<FORM> <SELECT ONCHANGE="location = this.options[this.selectedIndex].value;">]]
   for i, v in ipairs(A) do
      url = web:link(path..v.id)
      if tonumber(v.id) == tonumber(id) then 
         selected = " selected " 
         curr_app = i
      else 
         selected = " "
      end
      str = str .. [[<OPTION]]..selected..[[ VALUE="]]..url..[[">]]..v.name
   end
   str = str .. [[</SELECT> </FORM>]]

   return str
end


function render_list(web, id, A, AR)
   local res = {}

   --res[#res + 1] = p{ strings.application..": ", str };
   res[#res + 1] = p{ render_selector(web, A, id, "/list/") }
   res[#res + 1] = p{ render_table(web, AR) }
   --if id then res[#res + 1] = p{ button_link(strings.add, web:link("/add/"..id)) } end

   return render_layout(res)
end


function render_table(web, AR)
   local res = {}

   for i, v in ipairs(AR) do
      local from = v.from_name1
      local to = v.to_name1
      if v.from_name2 then from = v.from_name2.."@"..from end
      if v.to_name2 then to = v.to_name2.."@"..to end

      if v.connection_type == "physical" then contype = strings.physical else contype = strings.logical end

      rows[#rows + 1] = tr{ class='tab_bg_1',
         --td{ a{ href= web:link("/show/"..v.app_id), v.app_name} },
         td{ align="center", from },
         td{ align="center", v.rtype_name },
         td{ align="center", to },
         td{ button_link(strings.remove, web:link("/remove/"..v.app_id..":"..v.from_object_id
             ..":"..v.to_object_id), "negative") },
      }
   end

   res[#res + 1] = render_content_header("Relacionamentos de um Applicação", web:link("/add"), web:link("/list"))
   res[#res + 1] = H("table") { border="0", class="tab_cadrehov",
      thead{ 
         tr{ class="tab_bg_2",
             --th{ strings.application }, 
             th{ strings.origin },
             th{ strings.type },
             th{ strings.destiny },
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
         --lst = Model.select_host_object(...
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


function render_add(web, id, A, AR, AL, RT)
   local res = {}
   local tab = {}
   local from, to, relat
   local url = "/insert"
   local list_size = 7

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

   -- LISTA APP ORIGEM DOS RELACIONAMENTO ---------------------------------
   if AL[1].object_id then
      s = [[<SELECT multiple size=]]..list_size..[[ NAME="from">]]
      for i,v in ipairs(AL) do
        if v.name2 then ic = v.name2.."@"..v.name1 else ic = v.name1 end
        s = s..[[<OPTION VALUE="]]..v.object_id..[[">]]..ic
      end
      s = s..[[ </SELECT> ]]
   else 
      s = ""
   end
   from = s

   -- LISTA APP DESTINO DOS RELACIONAMENTO ---------------------------------
   if AL[1].object_id then
      s = [[<SELECT multiple size=]]..list_size..[[ NAME="to">]]
      for i,v in ipairs(AL) do
        if v.name2 then ic = v.name2.."@"..v.name1 else ic = v.name1 end
        s = s..[[<OPTION VALUE="]]..v.object_id..[[">]]..ic
      end
      s = s..[[ </SELECT> ]]
   else 
      s = ""
   end
   to = s

   -- LISTA TIPOS DE RELACIONAMENTO  ---------------------------------
   s = [[<SELECT multiple size=]]..list_size..[[ NAME="relat">]]
   for i,v in ipairs(RT) do
     s = s..[[<OPTION VALUE="]]..v.id..[[">]]..v.name
   end
   s = s..[[ </SELECT> ]]
   relat = s

   aid = [[ <INPUT TYPE=HIDDEN NAME="app_id" value="]]..id..[["> ]]

   tab[#tab + 1] = [[<table border=1, cellpadding=1>]]
   tab[#tab + 1] = {
      thead{ tr{ 
         th{ strings.origin }, 
         th{ strings.type }, 
         th{ strings.destiny }, 
      } },
      tbody{ tr{
         td{ from },
         td{ relat },
         td{ to },
      } },
   }
   tab[#tab + 1] = [[</table>]]..aid


   -- LISTA DE OPERACOES 
   res[#res + 1] = p{ strings.application..": ", str };
   res[#res + 1] = p{ render_selector(web, A, id, "/add/") }
   res[#res + 1] = p{ button_link(strings.list, web:link("/list/"..id)) }
   res[#res + 1] = p{ br(), br() }
   res[#res + 1] = p{ render_table(web, AR) }
   res[#res + 1] = p{ br() }
   res[#res + 1] = make_form(tab) 

   return render_layout(res)
end


function render_remove(web, A, AR)
   local res = {}
   local url = ""

   if A then
      A = A[1]
      if AR then
         AR = AR[1]
         obj1 = AR.from_name1
         if AR.from_name2 then obj1 = AR.from_name2.."@"..obj1 end
         obj2 = AR.to_name1
         if AR.to_name2 then obj2 = AR.to_name2.."@"..obj2 end
      end
      url_ok = "/delete/"..A.app_id..":"..AR.from_object_id..":"..AR.to_object_id
      url_cancel = "/list"
   end

   res[#res + 1] = p{
      strings.exclude_quest.." "..strings.relation.." \""..obj1.."->"..obj2.."\" "..strings.ofthe.." "
         ..strings.application.." \""..A.name.."\"?",
      p{ button_link(strings.yes, web:link("/delete/"..A.app_id..":"..AR.from_object_id..":"..AR.to_object_id)) },
      p{ button_link(strings.cancel, web:link("/list/"..A.app_id)) },
   }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


