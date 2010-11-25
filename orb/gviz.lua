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
   return Model.query("itvision_apps", clause, "order by id")
end


-- controllers ---------------------------------------------------------

function list(web)
   local A = app:select_apps()
   return render_list(web, A)
end
ITvision:dispatch_get(list, "/", "/list")

--[[
   id -> é uma id de aplicacao
]]
function show(web, id)
   local app_name, obj_id
   local apps = app:select_apps()
   if id == "/show" and apps[1] then id = apps[1].id end
   -- para presentacao Verto
   --if id == "/show" and apps[1] then id = 31 end
   local app = app:select_apps(id)
   local obj = Model.select_app_to_graph(id)
   local rel = Model.select_app_relat_to_graph(id)
   if app[1] then 
      app_name = app[1].name
      obj_id = app[1].service_object_id
   else 
      app_name = "none"
      obj_id = nil
   end
   return render_show(web, apps, app_name, id, obj, rel, obj_id)
end
ITvision:dispatch_get(show,"/show", "/show/(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, A)
   local res = {}
   res[#res + 1] = p{ br(), br() }
   return render_layout(res)
end


function render_show(web, apps, app_name, app_id, obj, rel, obj_id)
   local res = {}
   local engene = "dot"
   local file_type = "png"
   local refresh_time = 15
   local imgfile, imglink, mapfile, maplink, dotfile = Graph.make_gv_filename(app_name, file_type)

--[[
   if string.find(app_name, "AvBrasil") then
      engene = "dot"
   else
      engene = "dot"
   end
]]

   local content = Graph.make_content(obj, rel)
   Graph.render(app_name, file_type, engene, content)
   local imgmap = text_file_reader(mapfile)

   local lnkgeo = nil
   if obj_id then 
      web.prefix = "/orb/obj_info"
      lnkgeo = web:link("/geotag/app:"..obj_id) 
      web.prefix = "/orb/gviz"
   end
   res[#res+1] = render_bar( render_selector_bar(web, apps, app_id, "/show") )
   res[#res+1] = render_content_header("", nil, nil, nil, lnkgeo)
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


orbit.htmlify(ITvision, "render_.+")

return _M


