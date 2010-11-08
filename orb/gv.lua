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
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
end


-- controllers ---------------------------------------------------------

function list(web)
   local A = app:select_apps()
   return render_list(web, A)
end
ITvision:dispatch_get(list, "/", "/list")


function show(web, id)
   local app = app:select_apps(id)
   local obj = Model.select_app_to_graph(id)
   local rel = Model.select_app_relat_to_graph(id)
   return render_show(web, app[1].name, obj, rel)
end
ITvision:dispatch_get(show, "/show/(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, A)
   local res = {}
   res[#res + 1] = p{ br(), br() }
   return render_layout(res)
end


--[[
<map id="[ORLA] SWITCH PUC" name="[ORLA] SWITCH PUC"> 
<area shape="rect" id="node1" href="ics.lp?ickey=HWSWI005" target="_self" title="SWP00001" alt="" coords="225,228,299,252"/> 
</map> 
]]

function render_show(web, app_name, obj, rel)
   local res = {}
   local engene = "dot"
   local file_type = "png"
   local filename = config.path.gv.."/"..app_name.."."..file_type

   local content = Graph.make_content(obj, rel)
   Graph.render(filename, file_type, engene, content)

   res[#res+1] = p{ app_name, br(), br() }

   res[#res+1] = img{ 
      src=filename,
      alt="Realistic ITvision",
      border=0,
      class="figs",
      USEMAP="#[ORLA] SWITCH PUC",
   }

 
   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


