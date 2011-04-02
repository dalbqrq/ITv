#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "Monitor"
require "Auth"
require "View"
require "util"
require "state"

module(Model.name, package.seeall,orbit.new)

local apps = Model.itvision:model "apps"


-- models ------------------------------------------------------------

-- Esta funcao recebe um ou outro parametro, nunca os dois
function apps:select(id, obj_id)
   local clause = ""
   if id then clause = "id = "..id end
   if obj_id then clause = "service_object_id = "..obj_id end
   return Model.query("itvision_apps", clause)
end


-- controllers ------------------------------------------------------------

function show_hst(web, obj_id)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local A = Monitor.make_query_3(nil, nil, nil, "m.service_object_id = "..obj_id)
   return render_hst(web, obj_id, A)
end
ITvision:dispatch_get(show_hst, "/(%d+)")



ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_hst(web, obj_id, A)
   local permission, auth = Auth.check_permission(web, "application")
   local res = {}
   local row = {}

   web.prefix="/obj_info"
   local lnkgeo = web:link("/geotag/hst:"..obj_id)
   local lnkedt = web:link("/geotag/hst:"..obj_id)
   web.prefix="/hst_info"
   
   for i, v in pairs(A[1]) do
      row[#row+1] = {
         i, v,
--[[
         a{ href=lnk, v.name },
         strings["logical_"..v.type],
         NoOrYes[v.is_active+1].name,
         button_link(strings.edit, web:link("/edit/"..v.id..":"..v.name..":"..v.type)),
]]
      }
   end

   res[#res+1] = render_content_header(auth, A[1].c_name, nil, nil, nil , nil)
   res[#res+1] = render_grid({ {render_table(row, nil, ""), render_map_frame(web, "hst", obj_id)} } )

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


