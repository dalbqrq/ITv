module("Auth", package.seeall)

-- COOKIES ------------------------------------------------------------------------------

function set_cookie(web, name, value, path, expiration)
   local expiration_date
   path = path or "/"
   if expiration then expiration_date = os.time() + expiration end

   -- Nao está funcionando com expiracao!
   --web:set_cookie("itvision", { value="foo", path=path, expires = expiration_date })
   web:set_cookie(name, { value=value, path=path })
end


function delete_cookie(web, name, value)
   web:delete_cookie(name, path)
end


function get_cookie(web, name)
   return web.cookies[name]
end


function show_cookie(web, name)
   local cookie = web.cookies[name]
   return "COOKIE: "..name.." - "..cookie, br()
end


-- GLPI ------------------------------------------------------------------------------
local glpi_cookie_name = "PHPSESSID"
local session_path = "/usr/local/servdesk/files/_sessions"


function is_logged_at_glpi(web)
   local is_logged, user_name, id, sess_, glpi_cookie
   local glpi_cookie = get_cookie(web, glpi_cookie_name) 

   if glpi_cookie == nil then
      return false
   end

   local file_name = session_path.."/sess_"..glpi_cookie

   --[[ 
       buscar em 'file_name' as strings abaixo 
           glpiID|s:1:"2";
           glpiname|s:5:"admin";
   ]]
   local sess_ = text_file_reader(file_name)
   local a, b, c, user_id = string.find(sess_, 'glpiID|s:(%d+):"(%d+)"')
   local d, e, f, user_name = string.find(sess_, 'glpiname|s:(%d+):"(%a+)"')

   if user_name ~= nil then
      return { is_logged=true, user_name=user_name, user_id=user_id, session=sess_, cookie=glpi_cookie } 
   else
      return false
   end
end


function check(web)
   local auth = is_logged_at_glpi(web)

   if auth ~= false then
      return auth
   else
      web.prefix = "/orb"
      web:redirect(web:link("/login"))
      return false
   end
end


-- ITvision ------------------------------------------------------------------------------
local itvision_cookie_name = "ITvision"

function set_itvision_cookie(web, user_name)
    set_cookie(web, itvision_cookie_name, user_name)
end


function login_at_itvision(web, user_name, user_id)
   local value = user_id
   --local value = user_name
   set_cookie(web, itvision_cookie_name, value)
end


function is_logged_at_itvision(web, user_name)
   local cookie = get_cookie(web, itvision_cookie_name)
   local res = string.find(cookie, user_name)
end


function get_itvision_cookie(web)
   return get_cookie(web, itvision_cookie_name)
end
