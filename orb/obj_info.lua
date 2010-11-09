#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "View"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local app = Model.itvision:model "app"
local app_object = Model.itvision:model "app_object"


-- models ------------------------------------------------------------

-- Esta funcao recebe um ou outro parametro, nunca os dois
function app:select(id, obj_id)
   local clause1, clause2 = "", ""
   if id then clause1 = "id = "..id end
   if obj_id then clause2 = "service_object_id = "..obj_id end
   return self:find_all(clause)
end


-- Esta funcao recebe um ou outro parametro, nunca os dois
function app_object:select_app_object(id, obj_id)
   if obj_id then 
      A = app:select(nil, obj_id)
      id = A[1].id
   end
   clause = "id = "..id

   return self:find_all(clause)
end

-- controllers ------------------------------------------------------------

function show_hst(web, obj_id)
   local A = Model.query_3(nil, nil, " and m.service_object_id = "..obj_id)
   return render_hst(web, obj_id, A)
end
ITvision:dispatch_get(show_hst, "/hst/(%d+)")


function show_svc(web, obj_id)
   local A = Model.query_4(nil, nil, nil, " and m.service_object_id = "..obj_id)
   return render_svc(web, obj_id, A)
end
ITvision:dispatch_get(show_svc, "/svc/(%d+)")


function show_app(web, obj_id)
   local A = app:select(nil, obj_id)
   return render_app(web, obj_id, A)
end
ITvision:dispatch_get(show_app, "/app/(%d+)")


function geotag(web, objtype, obj_id)
   local A
   if objtype == "app" then
      A = Model.query_3(nil, nil, " and m.service_object_id = "..obj_id)
   elseif objtype == "hst" then
      A = app_object:select_app_object(nil, obj_id)
   end

   return render_geotag(web, obj_id, objtype, A)
end
ITvision:dispatch_get(geotag, "/geotag/(%a+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_hst(web, obj_id, A)
   local res = {}
   local row = {}
   local lnkgeo = web:link("/geotag/hst:"..obj_id)
   local lnkedt = web:link("/geotag/hst:"..obj_id)
   
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

   res[#res+1] = render_content_header(A[1].c_name, nil, nil, lnkedt , lnkgeo)
   res[#res+1] = render_table(row, nil)

   return render_layout(res)
end


function render_svc(web, obj_id, A)
   local res = {}
   local row = {}

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

   res[#res+1] = render_content_header(A[1].s_name.." / "..A[1].sv_name, nil, nil)
   res[#res+1] = render_table(row, nil)

   return render_layout(res)
end


function render_app(web, obj_id, A)
   local res = {}
   local row = {}
   local lnkgeo = web:link("/geotag/app:"..obj_id)
   local lnkedt = web:link("/geotag/app:"..obj_id)

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

   res[#res+1] = render_content_header(A[1].name, nil, nil, lnkedt, lnkgeo)
   res[#res+1] = render_table(row, nil)

   return render_layout(res)
end


function render_geotag(web, obj_id, objtype, A)
   local res = {obj_id, objtype}

   return render_layout(res)
end

orbit.htmlify(ITvision, "render_.+")

return _M


