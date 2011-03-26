#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "App"
require "Auth"
require "View"
require "util"
require "monitor_util"

module(Model.name, package.seeall,orbit.new)

local apps        = Model.itvision:model "apps"
local app_objects = Model.itvision:model "app_objects"
local app_relats  = Model.itvision:model "app_relats"
local objects     = Model.nagios:model "objects"
local services    = Model.nagios:model "services"

local tab_id = 1

-- models ------------------------------------------------------------

function apps:select(id, clause_)
   local clause = nil

   if id and clause_ then
      clause = "id = "..id.." and "..clause_
   elseif id then
      clause = "id = "..id
   elseif clause_ then
      clause = clause_
   end

   extra  = " order by name "

   local content = Model.query("itvision_apps", clause, extra)
   --UNUSED: local root = App.select_root_app()

   return content, root, count
end


function apps:update(app)
   local A = {}
   if app.id then
      local tables = "itvision_apps"
      local clause = "id = "..app.id
      A.id = app.id
      A.service_object_id = app.service_object_id

      Model.update (tables, A, clause) 
   end
end


function app_objects:select(id)
   local clause = ""
   if id then
      clause = "app_id = "..id
   end
   return self:find_all(clause)
end


function app_relats:select(id)
   local clause = ""
   if id then
      clause = "app_id = "..id
   end
   return self:find_all(clause)
end


function objects:select_app(name2)
   if name2 then
      clause = "name2 = '"..name2.."' and name1 = '"..config.monitor.check_app.."' "
   else
      clause = nil
   end

   return Model.query("nagios_objects", clause)
end


function services:select(id, clause_)
   local clause
   if id and clause_ then
      clause = "service_object_id = "..id.." and "..clause_
   elseif id then
      clause = "service_object_id = "..id
   elseif clause_ then
      clause = clause_
   else 
      clause = nil
   end
   return Model.query("nagios_services", clause)
end


-- controllers ------------------------------------------------------------

function list(web, msg)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local clause = " entities_id in "..Auth.make_entity_clause(auth)
   if web.input.app_name then clause = clause.." and name like '%"..web.input.app_name.."%' " end
   --OLD: local A, root = apps:select(nil, clause)
   local A = App.select_app(clause)
   local root = App.select_root_app()
   return render_list(web, A, root, msg)
end
ITvision:dispatch_get(list, "/", "/list", "/list/(.+)")
ITvision:dispatch_post(list, "/list")


function show(web, app_id)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   if app_id then Auth.check_entity_permission(web, app_id) end
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local clause = "id = "..app_id.." and entities_id in "..Auth.make_entity_clause(auth)
   --OLD: local A, root = apps:select(nil, clause)
   local A = App.select_app(clause)
   local root = App.select_root_app()
   local no_header = true
   return render_list(web, A, root, nil, no_header)
end 
ITvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id, nm, tp, vz)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local edt = { id = id, name = nm, type = tp, visibility = vz }
   return render_add(web, edt)
end
ITvision:dispatch_get(edit, "/edit/(%d+):(.+):(%a+):(%d)")


function update(web, id)
   local A = {}
   if id then
      local tables = "itvision_apps"
      local clause = "id = "..id
      A.name = web.input.name
      A.type = web.input.type
      --A.is_active = web.input.is_active
      A.visibility = web.input.visibility
      A.service_object_id = web.input.service_object_id
      Model.update (tables, A, clause) 
   end

   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..id..":"..tab_id))
end
ITvision:dispatch_post(update, "/update/(%d+)")


function add(web)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   return render_add(web)
end
ITvision:dispatch_get(add, "/add")


function insert(web)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   apps:new()
   apps.name = web.input.name
   apps.type = web.input.type
   apps.is_active = web.input.is_active
   apps.service_object_id = nil
   apps.instance_id = Model.db.instance_id
   apps.is_entity_root = 0
   apps.entities_id = auth.session.glpiactive_entity
   apps.app_type_id = 2 -- leva em conta que a inicializacao da tabela itvision_app_type colocou o tipo aplicacao com id=1
   apps.visibility = web.input.visibility
   apps:save()

   local app = apps:select(nil, "name = '"..web.input.name.."'")
   App.insert_node_app_tree(app[1].id, auth.entity_id, nil, 1)
   App.remake_apps_config_file()

   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..app[1].id..":2"))
end
ITvision:dispatch_post(insert, "/insert")


function remove(web, id)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local A = apps:select(id)
   return render_remove(web, A)
end
ITvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   if id then
      local tree_id = App.find_node_id(id)
      for _,v in ipairs(tree_id) do
         App.delete_node_app_tree(v.id)
      end

      local o = objects:select_app(id)
      if o[1] then
         Model.delete ("itvision_app_objects", "service_object_id = "..o[1].object_id)
      end
      Model.delete ("itvision_app_objects", "app_id = "..id) 
      Model.delete ("itvision_app_relats", "app_id = "..id) 
      Model.delete ("itvision_app_contacts", "app_id = "..id) 
      Model.delete ("itvision_apps", "id = "..id) 
   end

   App.remake_apps_config_file()

   web.prefix = "/orb/app"
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_get(delete, "/delete/(%d+)")


-- TODO: deve ser modificado. Todos os nomes devem ser compostos por ids das tabelas.
function app_to_id(str)
   -- esta e a mesma substituicao que tem em function activate_app mo modulo inc/monitor_util.lua
   return string.gsub(string.gsub(str,"(%p+)","_")," ","_")
end


function activate(web, id, flag)
   if tonumber(flag) == 0 then flag = 1 else flag = 0 end
   local cols = {}
   local msg, counter

   if id then
      local clause = "id = "..id
      local tables = "itvision_apps"
      cols.is_active = flag

      local A = apps:select(id)
      local count = App.count_app_objects(id)
      if A[1] and count > 0 then
         -- se for uma operacao de ativacao entao atualiza o service_object_id da aplicacao criada
         if flag == 1 then
            App.activate_app(id) 

--[[
            -- app as id local s = objects:select_app(app_to_id(A[1].name))
            s = objects:select_app(A[1].id)
            -- caso host ainda nao tenha sido incluido aguarde e tente novamente
            counter = 0
            while s[1] == nil do
               counter = counter + 1
               os.reset_monitor()
               os.sleep(1)
               s = objects:select_app(A[1].id)
            end
            local svc = { id = A[1].id, service_object_id = s[1].object_id }
            apps:update(svc)
]]
         else
            App.deactivate_app(id) 
         end

         msg = "/"..error_message(9).." "..A[1].name
      else
         msg = "/"..error_message(10).." "..A[1].name
      end
   end

   return web:redirect(web:link("/list"..msg))
end
ITvision:dispatch_get(activate, "/activate/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_filter(web)
   return { strings.name..": ", input{ type="text", name="app_name", value = "" }, " " }
end


function render_list(web, A, root, msg, no_header)
   local res = {}
   local row = {}
   local svc, stract
   local permission, auth = Auth.check_permission(web, "application")
   local tag = ""

   for i, v in ipairs(A) do
      local button_remove, button_edit, button_active = "-", "-", "-"
      local category = strings.entity

      web.prefix = "/orb/app_tabs"
      local lnk = web:link("/list/"..v.id..":1")
      web.prefix = "/orb/app"

      if v.is_entity_root == "0" then
         category = strings.application
         button_remove = button_link(strings.remove, web:link("/remove/"..v.id), "negative")
         button_edit   = button_link(strings.edit, web:link("/edit/"..v.id..":"..v.name..":"..v.type..":"..v.visibility))
      end

      if v.is_active == "0" then
         stract = strings.activate
      else
         stract = strings.deactivate
      end
      button_active = button_link(stract, web:link("/activate/"..v.id..":"..v.is_active)) 

      if permission == "r" then
         button_remove = "-"
         button_edit = "-"
         button_active = "-"
      end

      -- leva em conta a inicializacao padrao da tabela itvision_app_type
      if v.app_type_id == "1" then
         tag = " +"
      elseif v.app_type_id == "2" then
         tag = " #"
      else
         tag = " -"
      end

      row[#row+1] = {
         a{ href=lnk, v.name..tag },
         v.entity_completename,
         category,
         strings["logical_"..v.type],
         NoOrYes[tonumber(v.is_active)+1].name,
         PrivateOrPublic[tonumber(v.visibility)+1].name,
         button_remove,
         button_edit,
         button_active,
      }
   end

   local header =  { strings.name, strings.entity, strings.type, strings.logic, strings.is_active, strings.visibility,".", ".", "." }
   local c_header = {}
   if no_header == nil then
      if permission == "w" then
         res[#res+1] = render_content_header(auth, strings.application, web:link("/add"), web:link("/list"))
      else
         res[#res+1] = render_content_header(auth, strings.application, nil, web:link("/list"))
      end
      res[#res+1] = render_form_bar( render_filter(web), strings.search, web:link("/list"), web:link("/list") )
      if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ font{ color="red", msg } } end
   end
   res[#res+1] = render_table(row, header)

   return render_layout(res)
end


-- TODO: edit deve receber os valores a serem alterados
function render_add(web, edit)
   local val1, val2, strbar, link
   local add_link = web:link("/add")
   local res = {}
   local permission, auth = Auth.check_permission(web, "application", true)
   local auth = Auth.check(web)

   if edit then 
      strbar = strings.update 
      link = web:link("/update/"..edit.id)
   else 
      strbar = strings.add 
      link = web:link("/insert")
      edit = { id = 0, name = "", type = "", visibility = "" }
   end

--dniel
   local entities = {}
   table.insert(entities, { i=1, name="---"..#auth.session.glpiactiveentities.." "..#auth.entities } )
   for i,v in ipairs(auth.entities) do
      table.insert(entities, { i=i+1, name=v })
   end

   local inc = {
      strings.name..": ", input{ type="text", name="name", value = edit.name }, " ",
      strings.logic..": ", select_and_or("type", edit.type ),  " ",
      strings.visibility..": ", select_private_public("visibility", edit.visibility ),  " ",
--daniel
      strings.entity..": ", select_option("entity", entities, "i", "name", 1 ),  " ",
      "<INPUT TYPE=HIDDEN NAME=\"is_active\" value=\"0\">",
   }
   
   res[#res+1] = render_content_header(auth, strings.application, add_link, web:link("/list"))
   res[#res+1] = render_form_bar( inc, strbar, link, add_link )

   return render_layout(res)
end


function render_remove(web, A)
   local res = {}
   local url = ""
   local permission, auth = Auth.check_permission(web, "application", true)

   if A then
      A = A[1]
      web.prefix = "/orb/app"
      url_ok = web:link("/delete/"..A.id)
      web.prefix = "/orb/app_tabs"
      url_cancel = web:link("/list/"..A.id..":"..tab_id)

      res[#res+1] = p{
         strings.exclude_quest.." "..strings.application.." "..A.name.."?",
         p{ button_link(strings.yes, url_ok) },
         p{ button_link(strings.cancel, url_cancel) },
      }
   end

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


