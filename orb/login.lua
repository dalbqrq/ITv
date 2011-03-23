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
    return render_logout(web)
end
ITvision:dispatch_get(logout, "/logout")


function login_err(web)
   return render_login(web, true)
end
ITvision:dispatch_get(login_err, "/err")


function cookie(web)
   return render_cookie(web)
end
ITvision:dispatch_get(cookie, "/cookie")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function render_login(web, login_error)
   local res = {}

   if Auth.is_logged_at_glpi(web) then
      web.prefix = "/"
      return web:redirect(web:link("login.html"))
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

   if login_error then res[#res + 1] = p{ font{ color="red", error_message(13) }, br()  } end

   return render_layout(res)
end


function render_cookie(web)
   local err = nil
   local auth = Auth.is_logged_at_glpi(web)

   if auth == false then
      err = true
   end
   return render_login(web, err)
end


function render_logout(web)
   Auth.logout(web)
   web.prefix = "/servdesk"
   return web:redirect(web:link("/logout.php"))
end


orbit.htmlify(ITvision, "render_.+")

return _M


