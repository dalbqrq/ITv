#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "view_utils"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------

-- controllers ------------------------------------------------------------

function list(web)
   return render_list(web)
end
ITvision:dispatch_get(list, "/")


-- views ------------------------------------------------------------

function render_list(web)
   
   return render_menu_frame(make_menu())
end


orbit.htmlify(ITvision, "render_.+")

return _M

