#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "App"
require "Auth"
require "Glpi"
require "Monitor"
require "View"
require "util"
require "monitor_util"
require "app"

module(Model.name, package.seeall,orbit.new)

local apps = Model.itvision:model "apps"
local app_contacts = Model.itvision:model "app_contacts"
local users = Model.glpi:model "users"

local tab_id = 4

-- models ------------------------------------------------------------



function app_contacts:delete_app_contact(id, user_id)
   local clause = ""
   if id and user_id then
      clause = " app_id = "..id.." and user_id = "..user_id
   end

   Model.delete("itvision_app_contacts", clause)
end


function users:select_user(user_id)
   local clause = ""
   if user_id then
      clause = "id = "..user_id
   end

   return self:find_all(clause)
end


-- controllers ------------------------------------------------------------


function add(web, id, msg)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local clause = " "
   local extra   = [[ order by o.name1, o.name2 ]]

   local APP = App.select_service_object(nil, nil, nil, true, id)
   local CONTACTS = Glpi.select_contacts_in_app(id)
   local USERS = Glpi.select_contacts_not_in_app(id)

   return render_add(web, APP, CONTACTS, USERS, id, msg)

end
ITvision:dispatch_get(add, "/add", "/add/(%d+)", "/add/(%d+):(.+)")


function update_contact(web, user_id)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local apps = Glpi.select_app_by_contact(user_id)
   local a = apps[1]

   if a == nil then
      local user = users:select_user(user_id)
      remove_contact_cfg_file(user_id)
   else
      a.firstname = a.firstname or ""
      a.realname  = a.realname or ""
      insert_contact_cfg_file (user_id, a.firstname.." "..a.realname, a.email, apps)
   end
end


function insert(web, app_id, user_id)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   app_contacts:new()
   app_contacts.instance_id = Model.db.instance_id
   app_contacts.app_id = app_id
   app_contacts.user_id = user_id
   app_contacts:save()

   update_contact(web, user_id)

   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..app_id..":"..tab_id))
end
ITvision:dispatch_get(insert, "/insert/(%d+):(%d+)")


function delete(web, app_id, user_id)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   if app_id and user_id then
      local clause = "app_id = "..app_id.." and user_id = "..user_id
      local tables = "itvision_app_contacts"
      Model.delete (tables, clause) 
   end

   update_contact(web, user_id)

   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..app_id..":"..tab_id))
end
ITvision:dispatch_get(delete, "/delete/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function make_app_contacts_table(web, CONTACTS)
   local row = {}
   local url_remove
   web.prefix = "/orb/app_contacts"
   local permission = Auth.check_permission(web, "application")


   for i, v in ipairs(CONTACTS) do
      v.firstname = v.firstname or " "
      v.realname  = v.realname  or " "
      v.email     = v.email     or " "
      if permission == "w" then
         url_remove = web:link("/delete/"..v.app_id..":"..v.user_id)
      else
         url_remove = nil
      end
      row[#row + 1] = { 
         v.name,
         v.firstname.." "..v.realname,
         v.email,
         url_remove
      }
   end

   return row
end


function make_app_users_table(web, USERS, app_id)
   local row = {}
   web.prefix = "/orb/app_contacts"
   local permission = Auth.check_permission(web, "application")

   for i, v in ipairs(USERS) do
      local url_add, url_edit = nil, nil
      if permission == "w" then
         if v.email and string.find(v.email,"@") then 
            web.prefix = "/orb/app_contacts"
            url_add = web:link("/insert/"..app_id..":"..v.id)
         else
            web.prefix = "/servdesk"
            url_edit = web:link("/front/user.form.php?id="..v.id)
         end
      end
      v.firstname = v.firstname or " "
      v.realname  = v.realname  or " "
      v.email     = v.email     or " "
      row[#row + 1] = { 
         v.name,
         v.firstname.." "..v.realname,
         v.email,
         url_add,
         url_edit,
      }
   end

   return row
end



function render_add(web, APP, CONTACTS, USERS, app_id, msg)
   local res = {}
   local row
   local url_contact = "/insert"
   local list_size = 2
   local header = ""

   -----------------------------------------------------------------------
   -- Objetos da Aplicacao
   -----------------------------------------------------------------------
   res[#res+1] = show(web, app_id)
   res[#res+1] = br()
   local contacts = make_app_contacts_table(web, CONTACTS)
   local users = make_app_users_table(web, USERS, app_id)

   for _, v in ipairs(contacts) do
      v[4] = a{ href=v[4], title=strings.remove, img{src="/pics/trash.png",  height="20px"}}
   end
   for _, v in ipairs(users) do
      if v[5] then
         v[4] = a{ href=v[5], title=strings.edit, img{src="/pics/pencil.png",  height="20px"}}
         table.remove(v,5)
      else
         v[4] = a{ href=v[4], title=strings.add, img{src="/pics/plus.png",  height="20px"}}
      end
   end

   res[#res+1] = render_title(strings.contact.."s")
   header = { "Login", strings.name, "E-mail", "" }
   res[#res+1] = render_table(contacts, header)
   res[#res+1] = br()
   res[#res+1] = render_table(users, header)
   res[#res+1] = br()

   if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ msg } end

   return render_layout(res)
end



orbit.htmlify(ITvision, "render_.+")

return _M


