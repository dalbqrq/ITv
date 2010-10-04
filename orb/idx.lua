#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "subsys_util"
require "view_utils"
require "html_page"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------

-- controllers ------------------------------------------------------------

function list(web, item)
   return render_list(web, tonumber(item))
end
ITvision:dispatch_get(list, "/(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, item)
   local res = {}
   
--[[
   res[#res + 1] = p{ "daniel" } 

   return render_layout(res)
]]
   menu = make_menu()
   iframe = make_iframe(item)

   res[#res + 1] = head
   res[#res + 1] = menu
   res[#res + 1] = body
   res[#res + 1] = iframe
   res[#res + 1] = foot

   return render_index(res)
--[[
]]
end


orbit.htmlify(ITvision, "render_.+")

return _M

