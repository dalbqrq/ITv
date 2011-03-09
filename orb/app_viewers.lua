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
local app_viewers = Model.itvision:model "app_viewers"

local tab_id = 5

-- models ------------------------------------------------------------



function app_viewers:delete_app_contact(id, user_id)
   local clause = ""
   if id and user_id then
      clause = " app_id = "..id.." and user_id = "..user_id
   end

   Model.delete("itvision_app_viewers", clause)
end



-- controllers ------------------------------------------------------------


function add(web, id, msg)
   local clause = " "
   local extra   = [[ order by o.name1, o.name2 ]]

   local APP = App.select_service_object(nil, nil, nil, true, id)
   local CONTACTS = Glpi.select_viewers_in_app(id)
   local USERS = Glpi.select_viewers_not_in_app(id)

   return render_add(web, APP, CONTACTS, USERS, id, msg)

end
ITvision:dispatch_get(add, "/add", "/add/(%d+)", "/add/(%d+):(.+)")



function insert(web, app_id, user_id)
   app_viewers:new()
   app_viewers.instance_id = Model.db.instance_id
   app_viewers.app_id = app_id
   app_viewers.user_id = user_id
   app_viewers:save()

   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..app_id..":"..tab_id))
end
ITvision:dispatch_get(insert, "/insert/(%d+):(%d+)")



function delete(web, app_id, user_id)
   if app_id and user_id then
      local clause = "app_id = "..app_id.." and user_id = "..user_id
      local tables = "itvision_app_viewers"
      Model.delete (tables, clause) 
   end

   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..app_id..":"..tab_id))
end
ITvision:dispatch_get(delete, "/delete/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function make_app_viewers_table(web, CONTACTS)
   local row = {}
   local remove_link = ""
   web.prefix = "/orb/app_viewers"
   local permission = Auth.check_permission(web, "application")

   for i, v in ipairs(CONTACTS) do
      v.firstname = v.firstname or " "
      v.realname  = v.realname  or " "
      v.email     = v.email     or " "
      if permission == "w" then
         remove_link = button_link(strings.remove, web:link("/delete/"..v.app_id..":"..v.user_id), "negative")
      else
         remove_link =  "-"
      end
      row[#row + 1] = { 
         v.name,
         v.firstname.." "..v.realname,
         v.email,
         remove_link,
      }
   end

   return row
end


function make_app_users_table(web, USERS, app_id)
   local row = {}
   web.prefix = "/orb/app_viewers"
   local permission = Auth.check_permission(web, "application")

   for i, v in ipairs(USERS) do
      local button = "-"
      if permission == "w" then
         if string.find(v.email,"@") then 
            web.prefix = "/orb/app_viewers"
            button = button_link(strings.add, web:link("/insert/"..app_id..":"..v.id), "positive")
         else
            web.prefix = "/servdesk"
            button = button_link(strings.edit, web:link("/front/user.form.php?id="..v.id), "positive")
         end
      end
      v.firstname = v.firstname or " "
      v.realname  = v.realname  or " "
      v.email     = v.email     or " "
      row[#row + 1] = { 
         v.name,
         v.firstname.." "..v.realname,
         v.email,
         button,
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

   header = { "Login", strings.name, "E-mail", "." }
   res[#res+1] = render_table(make_app_viewers_table(web, CONTACTS), header)
   res[#res+1] = br()
   res[#res+1] = render_table(make_app_users_table(web, USERS, app_id), header)
   res[#res+1] = br()

   if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ msg } end

   return render_layout(res)
end



orbit.htmlify(ITvision, "render_.+")

return _M


