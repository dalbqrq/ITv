-- includes & defs ------------------------------------------------------
require "util"
require "Auth"
require "View"
require "Graph"
require "Model"
require "Monitor"
require "App"
require "orbit"

module(Model.name, package.seeall,orbit.new)

local apps = Model.itvision:model "apps"


-- models ------------------------------------------------------------

function apps:select_apps(id)
   local clause = " is_active = 1 "
   if id then
      clause = " id = "..id
   end
   return Model.query("itvision_apps", clause, "order by id")
end



-- controllers ---------------------------------------------------------


function show(web, sep)
   local auth = Auth.check(web)
   if sep then sep = tonumber(sep) else sep = 1 end
   local all_apps = apps:select_apps()

   if not all_apps[1] then 
      return render_blank(web)
   end

   local obj = Monitor.select_monitors_app_objs_to_tree()
   local rel = App.select_tree_relat_to_graph()

   return render_show(web, obj, rel, sep)
end
ITvision:dispatch_get(show,"/show", "/show/(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------



function render_show(web, obj, rel, sep)
   local res = {}
   local engene = "dot"
   local file_type = "png"
   local refresh_time = 15
   local gv_name = "TREE"
   local imgfile, imglink, mapfile, maplink, dotfile = Graph.make_gv_filename(gv_name, file_type)

   engene = "dot"
   engene = "neato"
   engene = "twopi"
   engene = "fdp"
   engene = "circo"
   engene = "dot"

   local content = Graph.make_tree_content(obj, rel, sep)
   Graph.render(gv_name, file_type, engene, content)
   local imgmap = text_file_reader(mapfile)

   res[#res+1] = render_bar( {
         a{ href=web:link("/treeviz/show/0"),  "Unificada" } ,
         a{ href=web:link("/treeviz/show/1"),  "Separada" } ,
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


