#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------

require "util"
require "View"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)



-- models ------------------------------------------------------------


-- controllers ------------------------------------------------------------

function list(web)
   return render_login(web)
end
ITvision:dispatch_get(list, "/", "/list")


function login(web)
   users.login = web.input.login
   if web.input.password ~= "?-^&" then
      user.password = web.input.password
   end
   web.prefix = "/servdesk"
   return web:redirect(web:link("/login.php"))
end
ITvision:dispatch_post(insert, "/login")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function render_login(web)
   local res = {}

   web.prefix = "/servdesk"
   local url = web:link("/login.php")

   -- LISTA DE OPERACOES 

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = url,

      strings.login..": ", input{ type="text", name="login_name", value = nil },br(),
      strings.password..": ", input{ type="password", name="login_password", value = nil },br(),

      p{ button_form(strings.send, "submit", "positive") },
      p{ button_form(strings.reset, "reset", "negative") },
   }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


