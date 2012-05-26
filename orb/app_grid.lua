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


function show(web, app_id, recursive)
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

   return render_show(web, all_apps, all_entities, app_name, app_id, obj, rel, obj_id, appobj, recursive)
end
ITvision:dispatch_get(show,"/show", "/show/(%d+)", "/show/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")




-- views ------------------------------------------------------------

function get_subobjects(O)

   local res = {}

   -- A lista de objetos "O" será percorrida 4 vezes, uma para cada tipo de objeto.
   for i,v in ipairs(O) do
      if v.ao_type == "app" and v.ax_is_entity_root and v.ax_is_entity_root == "1" then
         obj = Monitor.select_monitors_app_objs(v.ax_id)
         sub = get_subobjects(obj)
         for _, o in ipairs(sub) do
            -- faz recursao somente nas aplicacoes de entidades
            if o.ao_type == "app" and o.ax_is_entity_root and o.ax_is_entity_root == "1" then
            -- faz recursao somente da aplicacoes e aplicacoes de entidades
            --if o.ao_type == "app" then 
               table.insert(res, o)
            end
         end
      end
      table.insert(res, v)
   end

   return res

end


function make_grid(web, O, recursive)
   local res, row, col = {}, {}, {}
   local permission = Auth.check_permission(web, "application")
   local auth = Auth.check(web)
   local col_count = 1
   local max_cols = 5

   if recursive then O = get_subobjects(O) end

   local rec, notrec, sel = "", ":1", "checked"
   if not recursive then rec = ":1"; notrec=""; sel = "" end

   web.prefix = "/orb/app_objects"

   -- A lista de objetos "O" será percorrida 4 vezes, uma para cada tipo de objeto.
   for _, t in ipairs({ "hst", "svc", "app", "ent" }) do
      for i,v in ipairs(O) do
         if v.ao_type == "app" and v.ax_is_entity_root and v.ax_is_entity_root == "1" then v.ao_type = "ent" end
         
            if v.ao_type == t then
               if v.ao_type == "hst" then
                  obj = find_hostname(v.c_alias, v.c_name, v.c_itv_key)
                  web.prefix = "/orb/obj_info"
                  url = web:link("/hst/"..v.o_object_id)
                  obj = button_link(obj, url, "negative")
               elseif v.ao_type == "svc" then
                  web.prefix = "/orb/obj_info"
                  url = web:link("/svc/"..v.o_object_id)
                  obj = button_link(make_obj_name(find_hostname(v.c_alias, v.c_name, v.c_itv_key), v.m_name), url, "negative")
               else
                  obj = v.ax_name
                  -- Navega para a apresentacao do detalhe da aplicacao/entidade 
                  --web.prefix = "/orb/app_tabs"
                  --obj = button_link(obj, web:link("/list/"..v.ax_id..":"..tab_id), "negative")
                  -- Navega para a apresentacao em grid da aplicacao/entidade 
                  web.prefix = "/orb/app_grid"
                  obj = button_link(obj, web:link("/show/"..v.ax_id..notrec), "negative")
               end
      
               col[#col+1] = { value=obj, state=v.ss_current_state }
            end


         if #col == max_cols then
            row[#row+1] = col
            col = {}
         end
      end

      -- Completa as columas com brancos (state=-1)
      if #col >= 1 and #col < max_cols then
         for i = #col+1, max_cols do  
            col[#col+1] = { value="", state=-1 }
         end
         row[#row+1] = col
      end

      if #row > 0 then
         res[#res+1] = render_title(name_hst_svc_subapp_subent(t).."(s)")
         res[#res+1] = render_table(row, nil, "tab_cadre_appgrid")
      end
      row = {}
      col = {}
   end

   return res
end


function render_show(web, app, entities, app_name, app_id, obj, rel, obj_id, appobj, recursive)
   local auth = Auth.check(web)
   local permission = Auth.check_permission(web, "application")
   local res = {}
   local lnkgeo, lnkedt  = nil, nil
   local refresh_time = 20
   local rec, notrec, sel = "", ":1", "checked"
   local rec_checkbox = ""

   if not recursive then rec = ":1"; notrec=""; sel = "" end

   if obj_id then 
      web.prefix = "/orb/obj_info"
      lnkgeo = web:link("/geotag/app:"..obj_id) 
      web.prefix = "/orb/app_tabs"
      lnkapp = web:link("/list/"..app_id..":6") 
      lnkedt = web:link("/list/"..app_id..":2") 
      web.prefix = "/orb/app_monitor"
      lnklst = web:link("/all:all:"..app_id..":-1") 
      web.prefix = "/orb/app_grid"
      lnkrec = web:link("/show/"..app_id..rec) 
   end
   web.prefix = "/orb"


   res[#res+1] = render_resume(web)
   web.prefix = "/orb"
   res[#res+1] = render_content_header(auth, "Grade", nil, web:link("/app_grid/show/1:1"))
   --rec_checkbox = [[<p><input type="checkbox" onchange="location=']]..lnkrec..[[';" ]]..sel..[[> Visualização recursiva</p>]]
   res[#res+1] = render_bar( { render_selector_bar(web, app, app_id, "/app_grid/show", notrec), rec_checkbox,
           a{ href=lnkapp,  strings.status } ,
           a{ href=lnkgeo,  "Mapa" } ,
           a{ href=lnkedt,  strings.edit } ,
           a{ href=lnklst,  strings.list } ,
         } )

   res[#res+1] = make_grid(web, obj, recursive)
   res[#res+1] = { br(), br(), br(), br() }


   return render_layout(res, refresh_time)

end


function render_blank(web)
   local res = {}
   res[#res+1]  = { b{ "Não há aplicações configuradas" } }

   return render_layout(res)
end



orbit.htmlify(ITvision, "render_.+")

return _M


