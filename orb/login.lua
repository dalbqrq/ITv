#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "View"
require "Auth"
require "util"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------


-- controllers ------------------------------------------------------------

function login(web)
   return render_login(web)
end
ITvision:dispatch_get(login, "/")


function logout(web)
   web.prefix = "/servdesk"
   return web:redirect(web:link("/logout.php"))
end
ITvision:dispatch_get(logout, "/logout")


function cookie(web, user_name)
   return render_cookie(web, user_name)
end
ITvision:dispatch_get(cookie, "/cookie/(.+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function render_login(web, login_error)
   local res = {}

   if Auth.is_logged_at_glpi(web) then
      web.prefix = "/orb"
      return web:redirect(web:link("/gviz/show"))
   end

   web.prefix = "/servdesk"
   local url = web:link("/login.php")

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = url,

      strings.login..": ", input{ type="text", name="login_name", value = nil },br(),
      strings.password..": ", input{ type="password", name="login_password", value = nil },br(),

      p{ button_form(strings.send, "submit", "positive") },
      p{ button_form(strings.reset, "reset", "negative") },
   }

   if login_error then res[#res + 1] = p{ font{ color="red", error_message[13] }, br()  } end

   return render_layout(res)
end


-- user_name vem do glpi::login.php e nao estah sendo usado!
function render_cookie(web, user_name)
   local res = {}
   local is_logged, name, id = Auth.is_logged_at_glpi(web)

   if is_logged then
      web.prefix = "/orb"
      return web:redirect(web:link("/gviz/show"))
   else
      return render_login(web, true)
   end
end



orbit.htmlify(ITvision, "render_.+")

return _M


