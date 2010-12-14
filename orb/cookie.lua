#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "auth"

module(Model.name, package.seeall,orbit.new)


-- controllers ------------------------------------------------------------

function list(web)
   local expiration_date = os.time() + 3600 * 48
   web:set_cookie("itvision", { value="foo", expires = expiration_date })
   web:set_cookie("SID", {value = "blah", path = "/"})
   return render_list(web)
end
ITvision:dispatch_get(list, "/")

ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web)
   local res = {}

   local expiration_date = os.time() + 3600 * 48
   web:set_cookie("itvision", { value="foo", expires = expiration_date })
   --web:delete_cookie("itvision")

   res[#res+1] = "Olah<br>"
   res[#res+1] = table.getn(web.cookies)

   if web.cookies then 
      for i, v in pairs(web.cookies) do
         res[#res+1] = { i, v, br() }
      end
   end

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


