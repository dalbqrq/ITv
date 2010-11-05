#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "View"

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
   local APPS = app:select_apps()
   if type(tonumber(id)) ~= "number" then
      if ( id == "/" or id == "/list" ) and APPS[1] ~= nil then id = APPS[1].id else id = nil end
   end

   local APPOBJ = Model.select_app_app_objects(id)
   id = id or ""
   return render_list(web, APPOBJ, APPS, id)
end
ITvision:dispatch_get(list, "/", "/list", "/list/(%d+)")


function show(web, id)
   local A = app:select_apps(id)
   return render_show(web, A, id)
end 
ITvision:dispatch_get(show, "/show/(%d+)")


function add(web, id)
   --local HST = Model.select_host_object()
   local HST = Model.select_service_object(nil, nil, nil, nil, id, true)
   local SVC = Model.select_service_object(nil, nil, nil, nil, id, nil)
   local APP = Model.select_service_object(nil, nil, nil, true)
   local APPOBJ = Model.select_app_app_objects(id)
   local APPS = app:select_apps()
   return render_add(web, HST, SVC, APP, APPOBJ, APPS, id)
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

function make_app_object_table(web, A)
   local row = {}

   for i, v in ipairs(A) do
      local obj = v.name1
      --if v.name2 then obj = v.name2.."@"..obj end
      if v.obj_type ~= 'hst' then obj = v.name2.."@"..obj end
      web.prefix = "/orb/app_object"

         --button_link(v.app_name, web:link("/show/"..v.app_id), "negative"),
      row[#row + 1] = { 
         v.app_name,
         v.obj_type,
         obj,
         button_link(strings.remove, web:link("/remove/"..v.app_id..":"..v.object_id), "negative"),
      }
   end

   return row
end


function render_list(web, APPOBJ, APPS, app_id)
   local res = {}

   local header = { strings.application, strings.type, strings.service.."@"..strings.host, "." }
   res[#res+1] = render_content_header(strings.app_object, web:link("/add/"..app_id), web:link("/list"))
   res[#res+1] = render_bar( render_selector_bar(web, APPS, app_id, "/list") )
   res[#res+1] = render_table(make_app_object_table(web, APPOBJ), header)

   return render_layout(res)
end


function render_show(web, A, app_id)
end


function render_add(web, HST, SVC, APP, APPOBJ, APPS, app_id)
   local res = {}
   local url = "/insert"
   local list_size = 8
   local header = ""

   local header = { strings.application, strings.type, strings.service.."@"..strings.host, "." }
   res[#res+1] = render_content_header(strings.app_object, web:link("/add/"..app_id), web:link("/list"))
   res[#res+1] = render_bar( render_selector_bar(web, APPS, app_id, "/add") )
   res[#res+1] = render_table(make_app_object_table(web, APPOBJ), header)
   res[#res+1] = br()


   -- LISTA DE HOSTS PARA SEREM INCLUIDOS ---------------------------------
   local opt_hst = {}
   for i,v in ipairs(HST) do
     opt_hst[#opt_hst+1] = option{ value=v.object_id, v.name1 }
   end
   local hst = { render_form(web:link(url),
               { H("select") { size=list_size, style="width: 100%;", name="item", opt_hst }, br(),
                 input{ type="hidden", name="app_id", value=app_id },
                 input{ type="hidden", name="type", value="hst" } } ) }
   

   -- LISTA DE SERVICES PARA SEREM INCLUIDOS ---------------------------------
   local opt_svc = {}
   for i,v in ipairs(SVC) do
      opt_svc[#opt_svc+1] = option{ value=v.object_id, v.name2.."@"..v.name1 }
   end  
   local svc = { render_form(web:link(url),
               { H("select") { size=list_size, style="width: 100%;", name="item", opt_svc }, br(),
                 input{ type="hidden", name="app_id", value=app_id },
                 input{ type="hidden", name="type", value="svc" } } ) }


   -- LISTA DE APPLIC PARA SEREM INCLUIDOS ---------------------------------
   local opt_app = {}
   for i,v in ipairs(APP) do
      opt_app[#opt_app+1] = option{ value=v.object_id, v.name2 }
   end  
   local app = { render_form(web:link(url),
               { H("select") { size=list_size, style="width: 100%;", name="item", opt_app }, br(),
                 input{ type="hidden", name="app_id", value=app_id },
                 input{ type="hidden", name="type", value="app" } } ) }


   local header = ({ strings.host, strings.service, strings.application })
   res[#res+1] = render_table({ {hst, svc, app} }, header)

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


