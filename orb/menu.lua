#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "View"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------

-- controllers ------------------------------------------------------------

function list(web)
   return render_list(web)
end
ITvision:dispatch_get(list, "/")


-- views ------------------------------------------------------------

function render_list(web)
   
   return render_menu_frame(render_menu())
end


orbit.htmlify(ITvision, "render_.+")

return _M

