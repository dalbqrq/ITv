#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "View"
require "util"
require "version"

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
   local res = {}
   if patch < 10 then patch = "0"..patch end
   
   res = center{ 
      br(), br(),
      img{ src="/servdesk/pics/warning.png", alt="Warning ITVision", border=0 }, 
      br(), br(),
      strong{ "Você não tem permissão para executar esta ação."},
   }
   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


