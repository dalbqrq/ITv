#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "View"
require "util"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------

-- controllers ------------------------------------------------------------

function list(web)

   return render_list(web)
end
ITvision:dispatch_get(list, "/")

ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web)
   local res = {}
   
   web.prefix = "/"
   if Auth.is_logged_at_glpi(web) then
      return web:redirect(web:link("frame.html"))
   else
      return web:redirect(web:link("orb/login"))
   end
   res = p{ "init" }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


