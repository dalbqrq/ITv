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


-- models ------------------------------------------------------------

function apps:select_apps(id, clause_)
   local clause = " is_active = 1 "
   if id then
      clause = clause.." and  id = "..id
   end
   if clause_ then clause = clause.." and "..clause_ end

   return Model.query("itvision_apps", clause, "order by id")
end


function apps:select_tree_relat_to_graph(id, clause_)
   local tables_ = "itvision_apps a, itvision_app_objects ao"
   local clause   = "a.id =  ao.app_id and ao.type = 'app' and is_active = 1"

   if id then
      clause = clause.." and  id = "..id
   end

   if clause_ then clause = clause.." and "..clause_ end

   return Model.query(tables_, clause)
end


-- controllers ---------------------------------------------------------


function show(web, sep)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   if sep then sep = tonumber(sep) else sep = 1 end
   local clause = Auth.make_entity_clause(auth)
   local all_apps = apps:select_apps(nil, " entities_id in "..clause)

   if not all_apps[1] then 
      return render_blank(web)
   end

   --[[ para que as aplicacoes (nao entidades) aparecam, comente as condicoes:
           'and a_.is_entity_root = 1'
        nos metodos make_query_10() e make_query_11 de Model/Monitor/Select.lua
        bem como a linha: 
           'and c.is_entity_root = 1 and a.is_entity_root = 1'
        na query de relacionamentos abaixo
   ]]
   -- seleciona objetos
   local obj = Monitor.select_monitors_app_objs_to_tree(nil, " a_.entities_id in "..clause)
   -- seleciona relacionamentos
   local rel = Model.query([[ itvision_apps a, itvision_app_objects ao, itvision_apps c]],
               [[ a.id = ao.app_id and ao.service_object_id = c.service_object_id 
                  and c.is_entity_root = 1 and a.is_entity_root = 1 
                  and a.entities_id in ]]..clause, nil,
               [[ a.id as parent_app, c.id as child_app]] )

   return render_show(web, obj, rel, sep)
end
ITvision:dispatch_get(show,"/show", "/show/(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------



function render_show(web, obj, rel, sep)
   local auth = Auth.check(web)
   local res = {}
   local engene = "dot"
   local file_type = "png"
   local refresh_time = 20
   local gv_name = "TREE"
   local imgfile, imglink, mapfile, maplink, dotfile = Graph.make_gv_filename(gv_name, file_type)

   engene = "neato"
   engene = "circo"
   engene = "fdp"
   engene = "twopi"
   engene = "dot"

   if DEBUG == true then
      local s = ""
      for i,v in ipairs(obj) do
         s = s..v.a_name.." \n"
      end
      text_file_writer("/tmp/apps_to_graph", s)
   end

   local content = Graph.make_tree_content(obj, rel, sep)
   Graph.render(gv_name, file_type, engene, content)
   local imgmap = text_file_reader(mapfile)

   res[#res+1] = render_resume(web)
   res[#res+1] = render_content_header(auth, strings.tree, nil, nil, nil)
   res[#res+1] = render_bar( { 
         --a{ href=web:link("/show/0"),  "Unificada" } ,
         --a{ href=web:link("/show/1"),  "Separada" } ,     -- VISAO EM SAPARADO DESABILITADO. Com ERRO EM GRAPH.LUA
         ". ",
   } )
   res[#res+1] = br()
   res[#res+1] = { imgmap }
   res[#res+1] = img{ 
      src=imglink,
      alt="Realistic ITvision",
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


