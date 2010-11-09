#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "View"
require "Graph"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local app = Model.itvision:model "app"


-- models ------------------------------------------------------------

function app:select_apps(id)
   local clause = nil
   if id then
      clause = "id = "..id
   end
   --return self:find_all(clause)
   return Model.query("itvision_app", clause, "order by id")
end


-- controllers ---------------------------------------------------------

function list(web)
   local A = app:select_apps()
   return render_list(web, A)
end
ITvision:dispatch_get(list, "/", "/list")


function show(web, id)
   local app_name
   local apps = app:select_apps()
   if id == "/show" and apps[1] then id = apps[1].id end
   local app = app:select_apps(id)
   local obj = Model.select_app_to_graph(id)
   local rel = Model.select_app_relat_to_graph(id)
   if app[1] then app_name = app[1].name else app_name = "none" end
   return render_show(web, apps, app_name, id, obj, rel)
end
ITvision:dispatch_get(show,"/show", "/show/(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, A)
   local res = {}
   res[#res + 1] = p{ br(), br() }
   return render_layout(res)
end


function render_show(web, apps, app_name, app_id, obj, rel)
   local res = {}
   local engene = "dot"
   local file_type = "png"
   local imgfile, imglink, mapfile, maplink, dotfile = Graph.make_gv_filename(app_name, file_type)

   local content = Graph.make_content(obj, rel)
   Graph.render(app_name, file_type, engene, content)
   local map = text_file_reader(mapfile)


   res[#res+1] = render_bar( render_selector_bar(web, apps, app_id, "/show") )

   res[#res+1] = { map }

   res[#res+1] = img{ 
      src=imglink,
      alt="Realistic ITvision",
      border=0,
      class="figs",
      USEMAP="#G",
   }
 
   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


