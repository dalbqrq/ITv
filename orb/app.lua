#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "App"
require "Auth"
require "View"
require "Resume"
require "Glpi"
require "util"
require "monitor_util"
require "messages"

module(Model.name, package.seeall,orbit.new)

local apps        = Model.itvision:model "apps"
local app_trees   = Model.itvision:model "app_trees"
local app_objects = Model.itvision:model "app_objects"
local app_relats  = Model.itvision:model "app_relats"
local objects     = Model.nagios:model   "objects"
local services    = Model.nagios:model   "services"
local events      = Model.glpi:model     "events"

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
   return content
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


function app_trees:select(id, clause_)
   local clause = nil

   if id and clause_ then
      clause = "id = "..id.." and "..clause_
   elseif id then
      clause = "id = "..id
   elseif clause_ then
      clause = clause_
   end

   local content = Model.query("itvision_app_trees", clause)
   return content
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
   local A = App.select_app()
   local AS = App.select_app_state(clause)
   local root = App.select_root_app()
   return render_list(web, A, AS,  root, msg)
end
ITvision:dispatch_get(list, "/", "/list", "/list/(.+)")
ITvision:dispatch_post(list, "/list")


function show(web, app_id)
   if app_id then Auth.check_entity_permission(web, app_id) end
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local clause = "a.id = "..app_id.." and a.entities_id in "..Auth.make_entity_clause(auth)
   local A = App.select_app(clause)
   local AS = App.select_app_state(clause)
   local root = App.select_root_app()
   local no_header = true
   return render_list(web, A, AS, root, nil, no_header)
end 
ITvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id, nm, tp, vz, et)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local edt = { id = id, name = nm, type = tp, visibility = vz, entity_id = et }
   return render_add(web, edt)
end
ITvision:dispatch_get(edit, "/edit/(%d+):(.+):(%a+):(%d):(%d+)")


function update(web, id)
   local auth = Auth.check(web)
   local A = {}

   if id then
      local tables = "itvision_apps"
      local clause = "id = "..id
      A.name = web.input.name
      A.type = web.input.type
      --A.is_active = web.input.is_active
      A.visibility = web.input.visibility
      A.service_object_id = web.input.service_object_id
      A.entities_id = web.input.entity
      Model.update (tables, A, clause) 
   end

   Glpi.log_event(id, "application", auth.user_name, 2, A.name)

   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..id..":"..tab_id))
end
ITvision:dispatch_post(update, "/update/(%d+)")


function add(web, msg)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   return render_add(web, nil, msg)
end
ITvision:dispatch_get(add, "/add", "/add/(.+)")


function insert(web)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end
   local clause = "name = '"..web.input.name.."' and entities_id in "..Auth.make_entity_clause(auth)
   local app = apps:select(nil, clause)

   if app[1] then
      web.prefix = "/orb/app"
      return web:redirect(web:link("/add/Uma aplicação com o nome "..web.input.name.." já existe!"))
   end

   apps:new()
   apps.name = web.input.name
   apps.type = web.input.type
   apps.is_active = web.input.is_active
   apps.service_object_id = nil
   apps.instance_id = Model.db.instance_id
   apps.is_entity_root = 0
   apps.entities_id = web.input.entity
   apps.app_type_id = 2 -- leva em conta que a inicializacao da tabela itvision_app_type colocou o tipo aplicacao com id=1
   apps.visibility = web.input.visibility
   apps:save()

   local app = apps:select(nil, clause)

   App.remake_apps_config_file()
   Glpi.log_event(id, "application", auth.user_name, 1, apps.name)

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
   local auth = Auth.check(web)
   local A = apps:select(id)
   Glpi.log_event(id, "application", auth.user_name, 3, A[1].name)

   if id then
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
   local auth = Auth.check(web)
   if tonumber(flag) == 0 then flag = 1 else flag = 0 end
   local msg, counter = "", 0

   if id then
      local clause = "id = "..id
      local tables = "itvision_apps"
      local A = apps:select(id)

      if flag == 1 then
         App.activate_app(id) 
         Glpi.log_event(id, "application", auth.user_name, 4, A[1].name)
      else
         App.deactivate_app(id) 
         Glpi.log_event(id, "application", auth.user_name, 5, A[1].name)
      end
   end

   os.sleep(1)
   return web:redirect(web:link("/list"..msg))
end
ITvision:dispatch_get(activate, "/activate/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_filter(web)
   return { strings.name..": ", input{ type="text", name="app_name", value = "" }, " " }
end


function render_list(web, A, AS, root, msg, no_header)
   local res, row = {}, {}
   local permission, auth = Auth.check_permission(web, "application")
   local svc, stract, tag = "", "", ""
   local header = { 
      strings.object, strings.entity, strings.status, strings.type, strings.logic, strings.is_active, 
      strings.visibility, "", "" , ""
   }

   for i, v in ipairs(AS) do
      local category = strings.entity
      -- esta imagem em branco é usada somente para formatacao, aumentando o espaço entre as linhas.
      -- isso poderia ser feito no css!
      local img_blk = img{src="/pics/blank.png",  height="20px"}
      local img_edit, img_remove = img_blk, img_blk

      web.prefix = "/orb/app"
      -- prepara botoes (icones) com as possiveis operacoes sobre o objeto
      if v.is_active == "0" then
         stract = strings.activate
         alarm_icon = "/pics/alarm_check.png"
      else
         stract = strings.deactivate
         alarm_icon = "/pics/alarm_off.png"
      end
      url_disable = web:link("/activate/"..v.id..":"..v.is_active)
      img_disable = a{ href=url_disable, title=stract, img{src=alarm_icon,  height="20px"}}

      if v.is_entity_root == "0" then
         category = strings.application
         url_edit = web:link("/edit/"..v.id..":"..v.name..":"..v.type..":"..v.visibility..":"..v.entity_id)
         url_remove = web:link("/remove/"..v.id)
         img_edit = a{ href=url_edit, title=strings.edit, img{src="/pics/pencil.png", height="20px"}}
         img_remove = a{ href=url_remove, title=strings.remove, img{src="/pics/trash.png",  height="20px"}}
      end

      if permission == "r" then
         img_edit, img_remove, img_disable = img_blk, img_blk, img_blk
      end

      -- selecioma o tag com a indicação do tipo de objeto
      if v.app_type_id == "1" then
         tag = "+ "
      elseif v.app_type_id == "2" then
         tag = "# "
      end

      -- Inclui estado e cor na coluna status
      local state, statename, status
      if tonumber(v.has_been_checked) == 1 then
         if tonumber(v.state) == 0 then
            state = tonumber(APPLIC_DISABLE)
         else
            state = tonumber(v.current_state)
         end
         statename = applic_alert[state].name
         status={ state=state, colnumber=3, nolightcolor=true }
      elseif v.is_active == "0"  then
         state = APPLIC_DISABLE
         statename = applic_alert[state].name
         status={ state=state, colnumber=3, nolightcolor=true }
      else
         state = APPLIC_PENDING
         statename = applic_alert[state].name
         status={ state=state, colnumber=3, nolightcolor=true }
      end

      web.prefix = "/orb/app_tabs"

      row[#row+1] = { 
         status=status,
         a{ href=web:link("/list/"..v.id..":2"), tag..v.name },
         v.entity_completename,
         statename,
         category,
         strings["logical_"..v.type],
         NoOrYes[tonumber(v.is_active)+1].name,
         PrivateOrPublic[tonumber(v.visibility)+1].name,
         img_edit,
         img_remove,
         img_disable,
      }
   end

   if no_header == nil then
      res[#res+1] = render_resume(web)
      web.prefix = "/orb/app"
      if permission == "w" then
         res[#res+1] = render_content_header(auth, strings.application, web:link("/add"), web:link("/list"))
      else
         res[#res+1] = render_content_header(auth, strings.application, nil, web:link("/list"))
      end
      res[#res+1] = render_form_bar( render_filter(web), strings.search, web:link("/list"), web:link("/list") )
      if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ font{ color="red", msg } } end
   end

   res[#res+1] = render_table(row, header)
   if not no_header then res[#res+1] = { br(), br(), br(), br() } end

   return render_layout(res)
end


-- TODO: edit deve receber os valores a serem alterados
function render_add(web, edit, msg)
   local val1, val2, strbar, link
   local add_link = web:link("/add")
   local res = {}
   local permission, auth = Auth.check_permission(web, "application", true)

   if edit then 
      strbar = strings.update 
      link = web:link("/update/"..edit.id)
   else 
      strbar = strings.add 
      link = web:link("/insert")
      edit = { id = 0, name = "", type = "", visibility = "" }
   end

   clause = " entities_id in "..Auth.make_entity_clause(auth).." and app_type_id = 1"
   local entities = apps:select(nil, clause)

   -- cria conteudo do formulario em barra
   local inc = {
      strings.name..": ", input{ type="text", name="name", value = edit.name }, " ",
      strings.logic..": ", select_and_or("type", edit.type ),  " ",
      strings.visibility..": ", select_private_public("visibility", edit.visibility ),  " ",
      strings.entity..": ", select_option("entity", entities, "entities_id", "name", edit.entity_id ),  " ",
      "<INPUT TYPE=HIDDEN NAME=\"is_active\" value=\"0\">",
   }
   
   res[#res+1] = render_content_header(auth, strings.application, add_link, web:link("/list"))
   if msg ~= "/" and msg ~= "/add" and msg ~= "/add/" then res[#res+1] = p{ font{ color="red", msg } } end
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


