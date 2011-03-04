#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "App"
require "Monitor"
require "View"
require "util"
require "monitor_util"
require "app"

module(Model.name, package.seeall,orbit.new)

local apps = Model.itvision:model "apps"
local app_objects = Model.itvision:model "app_objects"
local app_relats = Model.itvision:model "app_relats"

local tab_id = 2

-- models ------------------------------------------------------------



function app_relats:delete_app_relat(id, from, to)
   local clause = ""
   if id and from and to then
      clause = " app_id = "..id.." and from_object_id = "..from.." and to_object_id = "..to
   elseif id and from and to == nil then
      clause = " app_id = "..id.." and from_object_id = "..from
   elseif id and from == nil and to then
      clause = " app_id = "..id.." and to_object_id = "..to
   end

   Model.delete("itvision_app_relats", clause)
end


function apps:select(id, clause_)
   local clause = nil

   if id and clause_ then
      clause = "id = "..id.." and "..clause_
   elseif id then
      clause = "id = "..id
   elseif clause_ then
      clause = clause_
   end

   extra  = " order by id "
   return Model.query("itvision_apps", clause, extra)
end


-- controllers ------------------------------------------------------------

function update_apps()
   local APPS = App.select_uniq_app_in_tree()
   make_all_apps_config(APPS)
   os.sleep(1) -- CLUDGE Espera um pouco pois as queries das caixas de insercao estao retornando vazias!
end


function add(web, id, msg)
   local clause = " "
   local exclude = [[ o.object_id not in ( select service_object_id from itvision_app_objects where app_id = ]]..id..[[) 
                      and o.is_active = 1 ]]
   local extra   = [[ order by o.name1, o.name2 ]]
   local HST = Monitor.make_query_3(nil, nil, nil, exclude .. clause .. extra)
   clause = [[ and o.name2 <> ']]..config.monitor.check_host..[[' ]]
   local SVC = Monitor.make_query_4(nil, nil, nil, nil, exclude .. clause .. extra)
   local APP = App.select_app_service_object(nil, nil, nil, id)
   local APPOBJ = App.select_app_app_objects(id)

   return render_add(web, HST, SVC, APP, APPOBJ, id, msg)
end
ITvision:dispatch_get(add, "/add/", "/add/(%d+)", "/add/(%d+):(.+)")



function insert_obj(web)

   app_objects:new()
   -- inclusão de multiplos itens. deve-se acionar a selecao de multiplos itens na interface. bug abaixo
   if type(web.input.item) == "table" then
      for i, v in ipairs(web.input.item) do
         app_objects.app_id = web.input.app_id
         app_objects.type = web.input.type
         app_objects.instance_id = Model.db.instance_id
         app_objects.service_object_id = v
         app_objects:save()
      end
   else
      app_objects.app_id = web.input.app_id
      app_objects.type = web.input.type
      app_objects.instance_id = Model.db.instance_id
      app_objects.service_object_id = web.input.item
      app_objects:save()
   end

   if web.input.type == 'app' then 
      local app_child = apps:select(nil,"service_object_id = "..web.input.item)
      App.insert_subnode_app_tree(app_child[1].id, web.input.app_id)
      App.delete_node_app_conected_to_root(app_child[1].id)

      update_apps()
   end


   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..app_objects.app_id..":"..tab_id))
end
ITvision:dispatch_post(insert_obj, "/insert_obj")



function delete_obj(web, app_id, obj_id)

   if app_id and obj_id then
      local clause = "app_id = "..app_id.." and service_object_id = "..obj_id
      local tables = "itvision_app_objects"
      Model.delete (tables, clause) 
 
     -- apaga tambem todos os relacionamentos 
     app_relats:delete_app_relat(app_id, obj_id, nil)
     app_relats:delete_app_relat(app_id, nil, obj_id)
   end

   update_apps()

   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..app_id..":"..tab_id))
end
ITvision:dispatch_get(delete_obj, "/delete_obj/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function make_app_objects_table(web, A)
   local row, ic = {}, {}
   local obj = ""

   web.prefix = "/orb/app_objects"

   for i, v in ipairs(A) do
      if v.itemtype == "Computer" then
         ic = Model.query("glpi_computers", "id = "..v.items_id)
         ic = ic[1]
      elseif v.itemtype == "NetworkEquipment" then
         ic = Model.query("glpi_networkequipments", "id = "..v.items_id)
         ic = ic[1]
      end

      if v.obj_type == "hst" then
         obj = find_hostname(ic.alias, ic.name, ic.itv_key)
      elseif v.obj_type == "svc" then
         obj = make_obj_name(find_hostname(ic.alias, ic.name, ic.itv_key), v.name)
      else
         obj = v.name
      end

      row[#row + 1] = { 
         obj,
         name_hst_svc_app(v.obj_type),
         button_link(strings.remove, web:link("/delete_obj/"..v.app_id..":"..v.object_id), "negative"),
      }
   end

   return row
end



function render_add(web, HST, SVC, APP, APPOBJ, app_id, msg)
   local res = {}
   local url_app = "/insert_obj"
   local url_relat = "/insert_relat"
   local list_size = 10
   local header = ""

   -----------------------------------------------------------------------
   -- Objetos da Aplicacao
   -----------------------------------------------------------------------
   res[#res+1] = show(web, app_id)
   res[#res+1] = br()
   --res[#res+1] = render_content_header(strings.app_object)
   header = { strings.object.." ("..strings.service.."@"..strings.host..")", strings.type, "." }
   res[#res+1] = render_table(make_app_objects_table(web, APPOBJ), header)
   res[#res+1] = br()


   -- LISTA DE HOSTS PARA SEREM INCLUIDOS ---------------------------------
   local opt_hst = {}
   for i,v in ipairs(HST) do
      local hst_name = find_hostname(v.c_alias, v.c_name, v.c_itv_key)
      opt_hst[#opt_hst+1] = option{ value=v.o_object_id, hst_name }
   end
   local hst = { render_form(web:link(url_app), web:link("/add/"..app_id),
               { H("select") { size=list_size, style="width: 100%;", name="item", opt_hst }, br(),
                 input{ type="hidden", name="app_id", value=app_id },
                 input{ type="hidden", name="type", value="hst" } }, true, strings.add ) }
   

   -- LISTA DE SERVICES PARA SEREM INCLUIDOS ---------------------------------
   local opt_svc = {}
   for i,v in ipairs(SVC) do
      local hst_name = find_hostname(v.c_alias, v.c_name, v.c_itv_key)
      opt_svc[#opt_svc+1] = option{ value=v.o_object_id, make_obj_name(hst_name, v.m_name) }
   end  
   local svc = { render_form(web:link(url_app), web:link("/add/"..app_id),
               { H("select") { size=list_size, style="width: 100%;", name="item", opt_svc }, br(),
                 input{ type="hidden", name="app_id", value=app_id },
                 input{ type="hidden", name="type", value="svc" } }, true, strings.add ) }


   -- LISTA DE APPLIC PARA SEREM INCLUIDAS ---------------------------------
   local opt_app = {}
   for i,v in ipairs(APP) do
      opt_app[#opt_app+1] = option{ value=v.object_id, v.name }
   end
   local app = { render_form(web:link(url_app), web:link("/add/"..app_id),
               { H("select") { size=list_size, style="width: 100%;", name="item", opt_app }, br(),
                 input{ type="hidden", name="app_id", value=app_id },
                 input{ type="hidden", name="type", value="app" } }, true, strings.add ) }


   header = { strings.host, strings.service, strings.application }
   res[#res+1] = render_table({ {hst, svc, app} }, header)

   res[#res+1] = br()
   if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ msg } end

   return render_layout(res)
end



orbit.htmlify(ITvision, "render_.+")

return _M


