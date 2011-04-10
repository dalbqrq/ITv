#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "App"
require "Auth"
require "Monitor"
require "View"
require "util"
require "monitor_util"
require "app"

module(Model.name, package.seeall,orbit.new)

local apps = Model.itvision:model "apps"
local app_objects = Model.itvision:model "app_objects"
local app_relats = Model.itvision:model "app_relats"
local objects = Model.nagios:model "objects"

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


function objects:select_app(obj_id)
   return Model.query("nagios_objects", "object_id = "..obj_id.." and name1 = '"..config.monitor.check_app.."'")
end

-- controllers ------------------------------------------------------------

function update_apps()
   local APPS = App.select_uniq_app_in_tree()
   make_all_apps_config(APPS)
   os.sleep(1) -- CLUDGE Espera um pouco pois as queries das caixas de insercao estao retornando vazias!
end


function add(web, app_id, msg)
   local clause = nil
   if app_id then Auth.check_entity_permission(web, app_id) end
   local entity_auth = Auth.make_entity_clause(Auth.check(web))

   clause = " and p.entities_id in "..entity_auth
   local exclude = [[ o.object_id not in ( select service_object_id from itvision_app_objects where app_id = ]]..app_id..[[) 
                      and o.is_active = 1 ]]
   local extra   = [[ order by o.name1, o.name2 ]]
   local HST = Monitor.make_query_3(nil, nil, nil, exclude .. clause .. extra)
   clause = clause..[[ and o.name2 <> ']]..config.monitor.check_host..[[' ]]
   local SVC = Monitor.make_query_4(nil, nil, nil, nil, exclude .. clause .. extra)

   clause = " ( a.entities_id in "..entity_auth.." or a.visibility = 1 )"
   local APP = App.select_app_service_object(clause, nil, nil, app_id)
   local APPOBJ = App.select_app_app_objects(app_id)

   return render_add(web, HST, SVC, APP, APPOBJ, app_id, msg)
end
ITvision:dispatch_get(add, "/add/(%d+)", "/add/(%d+):(.+)")



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
--[[ nao apaga mais noh ligado a root
      App.delete_node_app_conected_to_root(app_child[1].id)
      _, root = App.select_root_app_tree()
      Model.delete("itvision_app_objects", "app_id = "..root.app_id.." and service_object_id = "..web.input.item)
]]
      update_apps()
   end


   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..app_objects.app_id..":"..tab_id))
end
ITvision:dispatch_post(insert_obj, "/insert_obj")



function delete_obj(web, app_id, obj_id)
   local msg = ""

   if app_id and obj_id then
      local is_last = false
      local subapp = objects:select_app(obj_id)
      if subapp[1] then
         is_last = App.is_last_subapp(subapp[1].name2, true)
      end

      if is_last == false then
         local clause = "app_id = "..app_id.." and service_object_id = "..obj_id
         local tables = "itvision_app_objects"
         Model.delete (tables, clause) 
 
         -- apaga tambem todos os relacionamentos 
         app_relats:delete_app_relat(app_id, obj_id, nil)
         app_relats:delete_app_relat(app_id, nil, obj_id)
     else
        msg = ":Aplicação não pode ser removida da RAIZ."
     end

      if subapp[1] then
         App.delete_child_from_parent(subapp[1].name2, app_id)
      end
   end

   update_apps()

   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..app_id..":"..tab_id..msg))
end
ITvision:dispatch_get(delete_obj, "/delete_obj/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function make_app_objects_table(web, A)
   local row, ic = {}, {}
   local remove_button = {}
   local obj = ""
   local permission = Auth.check_permission(web, "application")

   web.prefix = "/orb/app_objects"

   for i, v in ipairs(A) do
      if v.itemtype == "Computer" then
         --ic = Model.query("glpi_computers c, glpi_networkports p", "id = "..v.items_id.." and networkequipments_id = p.id")
         ic = Model.query("glpi_computers", "id = "..v.items_id)
         ic = ic[1]
      elseif v.itemtype == "NetworkEquipment" then
         ic = Model.query("glpi_networkequipments", "id = "..v.items_id)
         ic = ic[1]
      end

      if v.obj_type == "hst" then
         obj = find_hostname(ic.alias, ic.name, ic.itv_key).." ("..v.ip..")"
      elseif v.obj_type == "svc" then
         obj = make_obj_name(find_hostname(ic.alias, ic.name, ic.itv_key).." ("..v.ip..")", v.name)
      else
         local tag = ""
         if v.app_type_id == "1" then
            tag = " +"
         elseif v.app_type_id == "2" then
            tag = " #"
         else
            tag = " -"
         end

         obj = v.name..tag
         web.prefix = "/orb/app_tabs"
         obj = button_link(obj, web:link("/list/"..v.id..":"..tab_id), "negative")
         web.prefix = "/orb/app_objects"
      end

      if permission == "w" then
         remove_button = button_link(strings.remove, web:link("/delete_obj/"..v.app_id..":"..v.object_id), "negative")
      else
         remove_button = { "-" }
      end
--[[
         remove_button = button_link(strings.remove, web:link("/delete_obj/"..v.app_id..":"..v.object_id), "negative")
]]


      row[#row + 1] = { 
         obj,
         name_hst_svc_app(v.obj_type, v.is_entity_root),
         remove_button
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
   local permission = Auth.check_permission(web, "application")

   -----------------------------------------------------------------------
   -- Objetos da Aplicacao
   -----------------------------------------------------------------------
   res[#res+1] = show(web, app_id)
   res[#res+1] = br()
   if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ font{ color="red", msg } } end
   --res[#res+1] = render_content_header(strings.app_object)
   header = { strings.object.." ("..strings.service.."@"..strings.host..")", strings.type, "." }
   res[#res+1] = render_table(make_app_objects_table(web, APPOBJ), header)
   res[#res+1] = br()


   if permission == "w" then

      -- LISTA DE HOSTS PARA SEREM INCLUIDOS ---------------------------------
      local opt_hst = {}
      for i,v in ipairs(HST) do
         local hst_name = find_hostname(v.c_alias, v.c_name, v.c_itv_key)
         opt_hst[#opt_hst+1] = option{ value=v.o_object_id, hst_name.." ("..v.p_ip..")" }
      end
      local hst = { render_form(web:link(url_app), web:link("/add/"..app_id),
                  { H("select") { size=list_size, style="width: 100%;", name="item", opt_hst }, br(),
                    input{ type="hidden", name="app_id", value=app_id },
                    input{ type="hidden", name="type", value="hst" } }, true, strings.add ) }
   

      -- LISTA DE SERVICES PARA SEREM INCLUIDOS ---------------------------------
      local opt_svc = {}
      for i,v in ipairs(SVC) do
         local hst_name = find_hostname(v.c_alias, v.c_name, v.c_itv_key)
         opt_svc[#opt_svc+1] = option{ value=v.o_object_id, make_obj_name(hst_name.." ("..v.p_ip..")", v.m_name)}
      end  
         local svc = { render_form(web:link(url_app), web:link("/add/"..app_id),
               { H("select") { size=list_size, style="width: 100%;", name="item", opt_svc }, br(),
                    input{ type="hidden", name="app_id", value=app_id },
                    input{ type="hidden", name="type", value="svc" } }, true, strings.add ) }


      -- LISTA DE APPLIC PARA SEREM INCLUIDAS ---------------------------------
      local opt_app = {}
      for i,v in ipairs(APP) do
         opt_app[#opt_app+1] = option{ value=v.object_id, v.name.." #" }
      end
      local app = { render_form(web:link(url_app), web:link("/add/"..app_id),
                  { H("select") { size=list_size, style="width: 100%;", name="item", opt_app }, br(),
                    input{ type="hidden", name="app_id", value=app_id },
                    input{ type="hidden", name="type", value="app" } }, true, strings.add ) }


      header = { strings.host, strings.service, strings.application }
      res[#res+1] = render_table({ {hst, svc, app} }, header)

      res[#res+1] = br()
   end

   return render_layout(res)
end



orbit.htmlify(ITvision, "render_.+")

return _M


