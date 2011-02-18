#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "View"
require "auth"

module(Model.name, package.seeall,orbit.new)


-- controllers ------------------------------------------------------------

function list(web)
   return render_list(web)
end
ITvision:dispatch_get(list, "/")

ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web)
   local res = {}

   -- Nao está funcionando com expiracao!
   --local expiration_date = os.time() + 3600 * 48
   --web:set_cookie("itvision", { value="foo", expires = expiration_date })

   web:set_cookie("itvision", {value="fool", path = "/"})
   --web:delete_cookie("itvision", "/")

   res[#res+1] = "========================================="
   res[#res+1] = br()

   cookie_value = web.cookies["itvision"]

   if web.cookies then 
      for i, v in pairs(web.cookies) do
         res[#res+1] = { "COOKIE: ", i, " - ", v, br() }
      end
   end

   res[#res+1] = br(), "|"
   res[#res+1] = "alksjhdfalks "
   res[#res+1] = cookie_value
   res[#res+1] = br()

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


