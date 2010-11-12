#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "monitor_util"
require "orbit"
require "Model"
require "View"
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
   if id == "/list" or id == "/" then 
      if A[1] then id = A[1].id else id = nil end
   end
   local AR = Model.select_app_relat_object(id)
   id = id or ""
   return render_list(web, id, A, AR)
end
ITvision:dispatch_get(list, "/", "/list", "/list/(%d+)")


function show(web, id)
   local A = app_relat:select_app_relat(id)
   return render_show(web, A)
end 
ITvision:dispatch_get(show, "/show/(%d+)")


function add(web, id, msg)
   local A = app:select_apps()
   if id == "/" then 
      if A[1] then id = A[1].app_id else id = nil end
   end
   local AR = Model.select_app_relat_object(id)
   local AL = Model.select_app_app_objects(id)
   local RT = app_relat_type:select_app_relat_type()
   return render_add(web, id, A, AR, AL, RT, msg)
end
ITvision:dispatch_get(add, "/add/(%d+)")
ITvision:dispatch_get(add, "/add/(%d+):(.+)")


function insert(web)
   local msg = ""
   local from, to

   app_relat:new()
   app_relat.app_id = web.input.app_id
   app_relat.from_object_id = web.input.from
   app_relat.to_object_id = web.input.to
   app_relat.instance_id = Model.db.instance_id
   app_relat.app_relat_type_id = web.input.relat

   if not ( web.input.from and web.input.to and web.input.relat ) then
      msg = ":"..error_message(7)
      return web:redirect(web:link("/add/"..app_relat.app_id)..msg)
   end

   local AR = Model.select_app_relat_object(web.input.app_id, web.input.from, web.input.to)
   if AR[1] then
      local v = AR[1]
      from = v.from_name1
      to = v.to_name1
      if v.from_name2 then from = v.from_name2.."@"..from end
      if v.to_name2 then to = v.to_name2.."@"..to end
      msg = ":"..error_message(8).." "..from.." -> "..to
   else
      app_relat:save()
   end

   return web:redirect(web:link("/add/"..app_relat.app_id)..msg)
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

function make_app_relat_table(web, AR)
   local row = {}

   for i, v in ipairs(AR) do
      local from = make_obj_name(v.from_name1, v.from_name2)
      local to   = make_obj_name(v.to_name1, v.to_name2)

      if v.connection_type == "physical" then contype = strings.physical else contype = strings.logical end

      row[#row+1] = { 
         from,
         v.rtype_name,
         to,
         button_link(strings.remove, web:link("/remove/"..v.app_id..":"..v.from_object_id
             ..":"..v.to_object_id), "negative"),
      }
   end

   return row
end

function render_list(web, id, A, AR)
   local res = {}
   local header =  { strings.origin, strings.type, strings.destiny, "." }

   res[#res+1] = render_content_header(strings.app_relat, web:link("/add/"..id), web:link("/list"))
   res[#res+1] = render_bar( render_selector_bar(web, A, id, "/list") )
   res[#res+1] = render_table(make_app_relat_table(web, AR), header)

   return render_layout(res)
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



function render_add(web, id, A, AR, AL, RT, msg)
   local res = {}
   local url = "/insert"
   local list_size = 8
   local header = {}

   header =  { strings.origin, strings.type, strings.destiny, "." }
   res[#res+1] = render_content_header(strings.app_relat, web:link("/add/"..id), web:link("/list"))
   res[#res+1] = render_bar( render_selector_bar(web, A, id, "/add") )
   res[#res+1] = render_table(make_app_relat_table(web, AR), header)

   -- LISTA APP ORIGEM DOS RELACIONAMENTO ---------------------------------
   local opt_from = {}
   if AL[1] then
      for i,v in ipairs(AL) do
         --if v.name2 then ic = v.name2.."@"..v.name1 else ic = v.name1 end
         ic = make_obj_name(v.name1, v.name2)
         opt_from[#opt_from+1] = option{ value=v.object_id, ic }
      end
   end
   --local from = H("select") { multiple="multiple", size=list_size, name="from", opt_from, }
   local from = H("select") { size=list_size, name="from", opt_from }

   -- LISTA TIPOS DE RELACIONAMENTO  ---------------------------------
   local opt_rel = {}
   for i,v in ipairs(RT) do
     opt_rel[#opt_rel+1] = option{ value=v.id, v.name }
   end
   local rel = H("select") { size=list_size, name="relat", opt_rel }

   -- LISTA APP DESTINO DOS RELACIONAMENTO ---------------------------------
   local opt_to = {}
   if AL[1] then
      for i,v in ipairs(AL) do
         --if v.name2 then ic = v.name2.."@"..v.name1 else ic = v.name1 end
         ic = make_obj_name(v.name1, v.name2)
         opt_to[#opt_to+1] = option{ value=v.object_id, ic }
      end
   end
   local to = H("select") { size=list_size, name="to", opt_to }

   -- INFORMACAO OCULTA PARA A INCLUSAO DO RELACIONAMENTO  --------------------
   aid = input{ type="hidden", name="app_id", value=id }

   local t = { { from, rel, {to, aid} } }

   res[#res+1] = br()
   if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ msg } end
   res[#res+1] = render_form_bar( render_table(t, header) , strings.add, web:link("/insert"), web:link("/add/"..id))

   return render_layout(res)
end


function render_remove(web, A, AR)
   local res = {}
   local url = ""
   local obj1, obj2

   if A then
      A = A[1]
      if AR then
         AR = AR[1]
         obj1 = make_obj_name(AR.from_name1, AR.from_name2)
         obj2 = make_obj_name(AR.to_name1,   AR.to_name2)
      end
      url_ok = "/delete/"..A.app_id..":"..AR.from_object_id..":"..AR.to_object_id
      url_cancel = "/list"
   end

   res[#res + 1] = strings.exclude_quest.." "..strings.relation.." \""..obj1.." -> "..obj2.."\" "
         ..strings.ofthe.." "..strings.application.." \""..A.name.."\"?"
   res[#res + 1] = button_link(strings.yes, 
         web:link("/delete/"..A.app_id..":"..AR.from_object_id..":"..AR.to_object_id))
   res[#res + 1] = button_link(strings.cancel, web:link("/list/"..A.app_id))

   return render_layout(render_bar(res))
end


orbit.htmlify(ITvision, "render_.+")

return _M


