#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "subsys_util"
require "view_utils"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------

-- controllers ------------------------------------------------------------

function list(web, item)
   return render_list(web, tonumber(item))
end
ITvision:dispatch_get(list, "/(%d+)")


-- views ------------------------------------------------------------

function render_list(web, item)
   local res = {}
   
   return render_html_menu(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M

