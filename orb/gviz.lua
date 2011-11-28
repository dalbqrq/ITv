-- includes & defs ------------------------------------------------------
require "util"
require "Auth"
require "View"
require "Resume"
require "Graph"
require "Model"
require "Monitor"
require "App"
require "orbit"

module(Model.name, package.seeall,orbit.new)

local apps = Model.itvision:model "apps"
local entities = Model.glpi:model "entities"


-- models ------------------------------------------------------------

function apps:select_apps(id, clause_)
   --local clause = " is_active = 1 and app_type_id > 1" -- tentativa de colocar selecao por entidades
   --local clause = " is_active = 1"
   local clause = " is_active in (0,1) "
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


-- controllers ---------------------------------------------------------

function list(web)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local A = apps:select_apps()
   return render_list(web, A)
end
ITvision:dispatch_get(list, "/", "/list")


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

   local app = apps:select_apps(app_id)
   local obj = Monitor.select_monitors_app_objs(app_id)
   local rel = App.select_app_relat_to_graph(app_id)
   local obj_id = app[1].service_object_id
   local app_name = app[1].name

   return render_show(web, all_apps, all_entities, app_name, app_id, obj, rel, obj_id, no_header)
end
ITvision:dispatch_get(show,"/show", "/show/(%d+)", "/show/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, A)
   local res = {}
   res[#res + 1] = p{ br(), br() }
   return render_layout(res)
end


function render_show(web, app, entities, app_name, app_id, obj, rel, obj_id, no_header)
   local auth = Auth.check(web)
   local res = {}
   local engene = "dot"
   local file_type = "png"
   local refresh_time = 20
   local imgfile, imglink, mapfile, maplink, dotfile = Graph.make_gv_filename(app_name, file_type)

   engene = "dot"
   engene = "neato"
   engene = "twopi"
   engene = "fdp"
   engene = "circo"

   local content = Graph.make_content(obj, rel)
   Graph.render(app_name, file_type, engene, content)
   local imgmap = text_file_reader(mapfile)

   local lnkgeo, lnkedt  = nil, nil
   if obj_id then 
      web.prefix = "/orb/obj_info"
      lnkgeo = web:link("/geotag/app:"..obj_id) 
      web.prefix = "/orb/app_tabs"
      lnkedt = web:link("/list/"..app_id..":2") 
      lnkapp = web:link("/list/"..app_id..":6") 
      web.prefix = "/orb/app_monitor"
      lnklst = web:link("/all:all:"..app_id..":-1") 
   end
   web.prefix = "/orb"

   if no_header == nil then
      if auth then -- se nao estiver logado, valor de auth é "false" e não a arvore de autenticacao (mod Auth)
         res[#res+1] = render_resume(web)
         res[#res+1] = render_content_header(auth, "Grafo", nil, nil, nil)
      end
      web.prefix = "/orb"
      res[#res+1] = render_bar( 
         { render_selector_bar(web, app, app_id, "/gviz/show"), 
           --render_selector_bar(web, entities, app_id, "/gviz/show"),  -- tentativa de colocar selecao por entidades
           a{ href=lnkapp,  strings.status } ,
           a{ href=lnkgeo,  "Mapa" } ,
           a{ href=lnkedt,  strings.edit } ,
           a{ href=lnklst,  strings.list } ,
         } )
   else
      refresh_time = nil
   end
   res[#res+1] = br()
   res[#res+1] = { imgmap }
   res[#res+1] = img{ 
      src=imglink,
      alt="ITvision",
      border=0,
      class="figs",
      USEMAP="#G",
   }
 
   return render_layout(res, refresh_time)
end


function render_blank(web)
   local res = {}
   res[#res+1]  = { b{ "Não há aplicações configuradas" } } 

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


