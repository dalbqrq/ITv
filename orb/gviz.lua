#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "View"
require "Graph"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local apps = Model.itvision:model "apps"


-- models ------------------------------------------------------------

function apps:select_apps(id)
   local clause = " is_active = 1 "
   if id then
      clause = " id = "..id
   end
   --return self:find_all(clause)
   return Model.query("itvision_apps", clause, "order by id")
end


-- controllers ---------------------------------------------------------

function list(web)
   local A = apps:select_apps()
   return render_list(web, A)
end
ITvision:dispatch_get(list, "/", "/list")

--[[
   id -> é uma id de aplicacao
]]
function show(web, id)
   local app, app_name, obj_id
   local all_apps = apps:select_apps()

   if id == "/show" then
      if all_apps[1] then 
         id = all_apps[1].id 
      else
         return render_blank(web)
      end
   end

   app = apps:select_apps(id)

   -- para presentacao Verto
   --if id == "/show" and app[1] then id = 31 end
   --local app = apps:select_apps(id)
   --local obj = Model.select_app_to_graph(id)
   local obj = Model.select_monitors_app_objs(id)
   local rel = Model.select_app_relat_to_graph(id)
   app_name = app[1].name
   obj_id = app[1].service_object_id

   return render_show(web, all_apps, app_name, id, obj, rel, obj_id)
end
ITvision:dispatch_get(show,"/show", "/show/(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, A)
   local res = {}
   res[#res + 1] = p{ br(), br() }
   return render_layout(res)
end


function render_show(web, app, app_name, app_id, obj, rel, obj_id)
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
text_file_writer("/tmp/gr", app_name)
   Graph.render(app_name, file_type, engene, content)
   local imgmap = text_file_reader(mapfile)

   local lnkgeo = nil
   if obj_id then 
      web.prefix = "/orb/obj_info"
      lnkgeo = web:link("/geotag/app:"..obj_id) 
      web.prefix = "/orb/gviz"
   end
   res[#res+1] = render_bar( render_selector_bar(web, app, app_id, "/show") )
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


function render_blank(web)
   local res = {}
   res[#res+1]  = { b{ "Não há aplicações configuradas" } } 

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


