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
local entities = Model.glpi:model "entities"
local servicestatus = Model.nagios:model "servicestatus"

local tab_id = 2



-- models ------------------------------------------------------------

function apps:select_apps(id, clause_)
   --local clause = " is_active = 1 and app_type_id > 1" -- tentativa de colocar selecao por entidades
   local clause = " is_active = 1"
   if id then clause = clause.." and  id = "..id end
   if clause_ then clause = clause.." and "..clause_ end

   return Model.query("itvision_apps", clause, "order by id")
end


function entities:select_entities(id, clause_)
   local clause = "id > 0 " -- dummy
   if id then clause = clause.." and  id = "..id end
   if clause_ then clause = clause.." and "..clause_ end

   return Model.query("itvision_apps", clause, "order by id")
end


function servicestatus:select_servicestatus(id)
   if id then clause = " service_object_id = "..id end

   return Model.query("nagios_servicestatus", clause)
end


-- controllers ---------------------------------------------------------


function show(web, app_id, no_header)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local clause = nil
   if auth then clause = " entities_id in "..Auth.make_entity_clause(auth) end
   local all_apps = apps:select_apps(nil, clause)
   local all_entities = entities:select_entities(nil, clause)

   if app_id == "/show" then
      if all_apps[1] then 
         app_id = all_apps[1].id 
      else
         return render_blank(web)
      end
   end
   if app_id then Auth.check_entity_permission(web, app_id) end

   --local app = apps:select_apps(app_id)
   local app = App.select_app_state("id = "..app_id)
   local obj = Monitor.select_monitors_app_objs(app_id)
   local rel = App.select_app_relat_to_graph(app_id)
   local appobj = App.select_app_app_objects(app_id)
   local obj_id = app[1].service_object_id
   local app_name = app[1].name

   return render_show(web, all_apps, all_entities, app_name, app_id, obj, rel, obj_id, appobj, no_header)
end
ITvision:dispatch_get(show,"/show", "/show/(%d+)", "/show/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")




-- views ------------------------------------------------------------

function make_app_objects_table(web, appobj)
   local row, col, ic = {}, {}, {}
   local remove_button = {}
   local obj = ""
   local permission = Auth.check_permission(web, "application")
   local col_count = 0

   web.prefix = "/orb/app_objects"

   for i, v in ipairs(appobj) do
      local is_ent = 0
      col_count = col_count + 1

      if v.itemtype == "Computer" then
         ic = Model.query("glpi_computers", "id = "..v.items_id)
         ic = ic[1]
      elseif v.itemtype == "NetworkEquipment" then
         ic = Model.query("glpi_networkequipments", "id = "..v.items_id)
         ic = ic[1]
      end

      if v.obj_type == "hst" then
         --obj = find_hostname(ic.alias, ic.name, ic.itv_key).." ("..v.ip..")"
         obj = find_hostname(ic.alias, ic.name, ic.itv_key)
         web.prefix = "/orb/obj_info"
         url = web:link("/hst/"..v.object_id)
         obj = button_link(obj, url, "negative")

      elseif v.obj_type == "svc" then
         web.prefix = "/orb/obj_info"
         url = web:link("/svc/"..v.object_id)
         --obj = button_link(make_obj_name(find_hostname(ic.alias, ic.name, ic.itv_key).." ("..v.ip..")", v.name), url, "negative")
         obj = button_link(make_obj_name(find_hostname(ic.alias, ic.name, ic.itv_key), v.name), url, "negative")
      else
         local tag = ""
         if v.app_type_id == "1" then
            tag = "+ "
            is_ent = 1
         elseif v.app_type_id == "2" then
            tag = "# "
         else
            tag = "- "
         end

         obj = tag..v.name
         web.prefix = "/orb/app_tabs"
         obj = button_link(obj, web:link("/list/"..v.id..":"..tab_id), "negative")
      end
      web.prefix = "/orb/app_objects"

      if permission == "w" and v.app_type_id ~= "1" then
         remove_button = button_link(strings.remove, web:link("/delete_obj/"..v.app_id..":"..v.object_id), "negative")
      else
         remove_button = { "-" }
      end
  
--[[
      row[#row+1] = { 
         obj,
         remove_button
      }
]]

      local ss = servicestatus:select_servicestatus(v.object_id)

      if col_count < 4 then
         --col[#col+1] = { { value=obj.."("..name_hst_svc_app_ent(v.obj_type, is_ent)..")", state=0} }
         --col[#col+1] = { {value=obj, state=0} }
         col[#col+1] = { value=obj, state=ss[1].current_state }
      else
         --row[#row+1] = { appobj[1].name, appobj[2].name, appobj[3].name, "" }
         row[#row+1] = col
         col = {}
         col_count = 0
      end
   end

   return row
end


function render_show(web, app, entities, app_name, app_id, obj, rel, obj_id, appobj, no_header)
   local auth = Auth.check(web)
   local permission = Auth.check_permission(web, "application")
   local res = {}
   local lnkgeo, lnkedt  = nil, nil
   local refresh_time = 15

   if obj_id then 
      web.prefix = "/orb/obj_info"
      lnkgeo = web:link("/geotag/app:"..obj_id) 
      web.prefix = "/orb/app_tabs"
      lnkedt = web:link("/list/"..app_id..":2") 
      lnkapp = web:link("/list/"..app_id..":6") 
   end
   web.prefix = "/orb"


   res[#res+1] = render_resume(web)
   res[#res+1] = render_content_header(auth, "Grid", nil, web:link("/show"))
   web.prefix = "/orb"
   res[#res+1] = render_bar( { render_selector_bar(web, app, app_id, "/app_grid/show"),
           a{ href=lnkapp,  strings.status } ,
           a{ href=lnkgeo,  "Mapa" } ,
           a{ href=lnkedt,  strings.edit } ,
         } )

   res[#res+1] = render_table(make_app_objects_table(web, appobj), nil, "tab_cadre_appgrid")
   res[#res+1] = { br(), br(), br(), br() }


   return render_layout(res, refresh_time)

end



orbit.htmlify(ITvision, "render_.+")

return _M


