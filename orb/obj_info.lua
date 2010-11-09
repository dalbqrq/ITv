#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "View"

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

function app:select_apps_and_B(id)
   local clause = "apps.id = B.id"

   if id then
      clause = clause.." and apps.id = "..tostring(id)
   end
   local tables = "itvision_app A, itvision_B B"
   local cols = "A.name as name, A.type as type, B.name as B_name, B.id, A.id as A_id"
   local res = Model.select (tables, clause, "", cols) 

   return res
end

-- controllers ------------------------------------------------------------

function show(web, objtype, id)
   local A = app:select_apps()
   return render_show_app(web, A)
   return render_show_hst(web, A)
   return render_show_svc(web, A)
end
ITvision:dispatch_get(delete, "/(%a+):(%d+)", "/show/(%a+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, A)
   local row = {}
   local res = {}
   

   return render_layout(res)
end



orbit.htmlify(ITvision, "render_.+")

return _M


