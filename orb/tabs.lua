#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "Auth"
require "View"
require "util"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------


-- controllers ------------------------------------------------------------

function list(web)
   return render_list(web)
end
ITvision:dispatch_get(list, "/", "/list")

ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function render_list(web)
   local t = { 
      { title="<", html="", href="" },
      { title="Kaoaoaka", html="www", href="/orb/probe" },
      { title="Kooaaa", html="www", href="/orb/probe" },
      { title="Kaka", html="www", href="/orb/probe" },
      { title="Kaka", html="www", href="/orb/app" },
      { title="Kaka", html="www", href="/orb/app" },
      { title="Tab1", html="www", href="/orb/app_objects/list/13" }, 
      { title="Kaka", html="www", href="/orb/app" },
      { title="Tab1", html="www", href="/orb/app_objects/list/13" }, 
      { title="Kaka", html="www", href="/orb/app" },
      { title="Tab1", html="www", href="/orb/app_objects/list/13" }, 
      { title="Kaka", html="www", href="/orb/app" },
   }

   local res = render_tabs(t)

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


