#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "Auth"
require "View"
require "util"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------


-- controllers ------------------------------------------------------------

function list(web, app_id, active_tab)
   return render_list(web, app_id, active_tab)
end
ITvision:dispatch_get(list, "/(%d+):(%d+)", "/list/(%d+):(%d+)")

ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function render_list(web, app_id, active_tab)
   local t = { 
      { title="<", html="", href="" },
      { title="Objetos", html="", href="/orb/app_objects/add/"..app_id }, 
      { title="Relacionamentos", html="", href="/orb/app_relats/add/"..app_id }, 
   }

   local res = render_tabs(t, active_tab)

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


