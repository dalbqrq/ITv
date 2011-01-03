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
   local _, _, _, id = string.find(sess_, 'glpiID|s:(%d+):"(%d+)"')
   local _, _, _, name = string.find(sess_, 'glpiname|s:(%d+):"(%a+)"')

   if name ~= nil then
      return true, name, id
   else
      return false
   end
end


function check(web)
   local is_logged, name, id = is_logged_at_glpi(web)
   web.prefix = "/orb"

   if is_logged then
      return is_logged, name, id
   else
      return web:redirect(web:link("/login"))
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
