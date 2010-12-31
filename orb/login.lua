#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "View"
require "util"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------


-- controllers ------------------------------------------------------------

function list(web)
   return render_login(web)
end
ITvision:dispatch_get(list, "/")


function login(web)
   users.login = web.input.login
   if web.input.password ~= "?-^&" then
      user.password = web.input.password
   end
   web.prefix = "/servdesk"
   return web:redirect(web:link("/login.php"))
end
ITvision:dispatch_post(login, "/login")


function cookie(web, user_name)
   return render_cookie(web, user_name)
end
ITvision:dispatch_get(cookie, "/cookie/(.+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function render_login(web, login_error)
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

   if login_error then res[#res + 1] = p{ font{ color="red", msg }, br()  } end

   return render_layout(res)
end


function render_cookie(web, user_name)
   -- Nao está funcionando com expiracao!
   --local expiration_date = os.time() + 3600 * 48
   --web:set_cookie("itvision", { value="foo", expires = expiration_date })

   --web:delete_cookie("itvision", "/")

--[[
   local res = {}
   web:set_cookie("itvision", {value=user_name, path = "/"})
   cookie_value = web.cookies["itvision"]

   if web.cookies then
      for i, v in pairs(web.cookies) do
         res[#res+1] = { "COOKIE: ", i, " - ", v, br() }
      end
   end

]]
   local cookie = web.cookies["PHPSESSID"]
   res[#res+1] = br(), "|"
   res[#res+1] = "++++++++++ "
   res[#res+1] = cookie_value
   res[#res+1] = br()
   cookie_value = web.cookies["PHPSESSID"]
   res[#res+1] = cookie_value
   res[#res+1] = br()
   cookie_value = web.cookies["itvision"]
   res[#res+1] = br()
   res[#res+1] = br()
   res[#res+1] = 

   return render_layout(res)

--[[ 
   local file_name = "/usr/local/servdesk/files/_session/sess_"..cookie.value

    buscar em 'file_name'  as strings 

	glpiID|s:1:"2";
	glpiname|s:5:"admin";

    e comparar o valor do glpiname  com o user_name.


   if cookie then
      web:set_cookie("itvision", {value=user_name, path = "/"})
      web.prefix = "/orb"
      return web:redirect(web:link("/gviz/show"))
   else
      return render_login(web, true)
   end
]]

end




orbit.htmlify(ITvision, "render_.+")

return _M


