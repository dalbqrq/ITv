#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "Itvision"
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

  if clause == nil then clause = "name <> '_ROOT'" end

   extra  = " order by name "
   return Model.query("itvision_apps", clause, extra)
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
      --clause = "name2 = '"..name2.."' and name1 = '"..config.monitor.check_app.."' and is_active = 1"
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
   local clause = nil
   if web.input.app_name then clause = " name like '%"..web.input.app_name.."%' " end

   local A = apps:select(nil, clause)
   return render_list(web, A, msg)
end
ITvision:dispatch_get(list, "/", "/list", "/list/(.+)")
ITvision:dispatch_post(list, "/list")


function show(web, id)
--[[
   local A = apps:select(id)
   local O = app_objects:select(id)
   local R = app_relats:select(id)
   return render_show(web, A, O, R)
]]
   local clause = "id = "..id

   local A = apps:select(nil, clause)
   local no_header = true
   return render_list(web, A, nil, no_header)
end 
ITvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id, nm, tp)
   local edt = { id = id, name = nm, type = tp }
   return render_add(web, edt)
end
ITvision:dispatch_get(edit, "/edit/(%d+):(.+):(%a+)")


function update(web, id)
   local A = {}
   if id then
      local tables = "itvision_apps"
      local clause = "id = "..id
      A.name = web.input.name
      A.type = web.input.type
      A.is_active = web.input.is_active
      A.service_object_id = web.input.service_object_id

      Model.update (tables, A, clause) 
   end

   --return web:redirect(web:link("/list"))
   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..id..":"..tab_id))
end
ITvision:dispatch_post(update, "/update/(%d+)")


function add(web)
   return render_add(web)
end
ITvision:dispatch_get(add, "/add")


function insert(web)
   apps:new()
   apps.name = web.input.name
   apps.type = web.input.type
   apps.is_active = web.input.is_active
   --app.service_object_id = web.input.service_object_id
   apps.instance_id = Model.db.instance_id
   apps.entities_id = 0
   apps:save()

   local app = apps:select(nil, "name = '"..web.input.name.."'")
   Itvision.insert_node_app_tree(app[1].id, nil, 1)

   return web:redirect(web:link("/list"))
end
ITvision:dispatch_post(insert, "/insert")


function remove(web, id)
   local A = apps:select(id)
   return render_remove(web, A)
end
ITvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   if id then
      Model.delete ("itvision_app_relats", "app_id = "..id) 
      Model.delete ("itvision_app_objects", "app_id = "..id) 
      Model.delete ("itvision_app_contacts", "app_id = "..id) 
      Model.delete ("itvision_app_viewers", "app_id = "..id) 
      Model.delete ("itvision_apps", "id = "..id) 
   end

   --return web:redirect(web:link("/list"))
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
      -- DEBUG: text_file_writer("/tmp/1", id.." : "..flag)

      local A = apps:select(id)
      local O = Itvision.select_app_app_objects(id)
      if A[1] and O[1] then
         -- Sinaliza a app como ativa
         Model.update (tables, cols, clause) 
         -- Recria arquivo de config do business process e 
         -- servicos do nagios para as aplicacoes
         local APPS = apps:select()
         activate_all_apps(APPS)

         -- se for uma operacao de ativacao entao atualiza o service_object_id da aplicacao criada
         if flag == 1 then
            local s = objects:select_app(app_to_id(A[1].name))
            -- caso host ainda nao tenha sido incluido aguarde e tente novamente
            counter = 0
            while s[1] == nil do
               counter = counter + 1
               os.reset_monitor()
               os.sleep(1)
               s = objects:select_app(app_to_id(A[1].name))
               -- DEBUG: text_file_writer("/tmp/act_"..app_to_id(A[1].name), app_to_id(A[1].name).." : "..counter.."\n")
            end
            local svc = { id = A[1].id, service_object_id = s[1].object_id }
            apps:update(svc)
         else
            os.reset_monitor()
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


function render_list(web, A, msg, no_header)
   local res = {}
   local row = {}
   local svc, stract

   for i, v in ipairs(A) do
      if v.is_active == "0" then
         stract = strings.activate
      else
         stract = strings.deactivate
      end

      --web.prefix = "/orb/app_objects"
      --local lnk = web:link("/list/"..v.id)
      web.prefix = "/orb/app_tabs"
      local lnk = web:link("/list/"..v.id..":1")
      web.prefix = "/orb/app"

      row[#row+1] = {
         a{ href=lnk, v.name },
         strings["logical_"..v.type],
         NoOrYes[tonumber(v.is_active)+1].name,
         button_link(strings.remove, web:link("/remove/"..v.id), "negative"),
         button_link(strings.edit, web:link("/edit/"..v.id..":"..v.name..":"..v.type)),
         button_link(stract, web:link("/activate/"..v.id..":"..v.is_active)) }
   end

   local header =  { strings.name, strings.type, strings.is_active, ".", ".", "." }
   if no_header == nil then
      res[#res+1] = render_content_header(strings.application, web:link("/add"), web:link("/list"))
      res[#res+1] = render_form_bar( render_filter(web), strings.search, web:link("/list"), web:link("/list") )
      if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ msg } end
   end
   res[#res+1] = render_table(row, header)

   return render_layout(res)
end


--[[  
   MUDEI DE IDEIA, VOU CONTINUAR USANDO app_object.lua e app_relats.lua PARA ENTRAR
   COM OS COMPONENTES DA APLICACAO!!!

   Diferente dos demais metodos "show", este serve para incluir e excluir os componentes
   e os relacionamentos de uma aplicacao.
]]
function render_show(web, app, obj, rel )
   app = app[1]
   local res = {}
   local row = {}

   return render_layout(res)
end


-- TODO: edit deve receber os valores a serem alterados
function render_add(web, edit)
   local val1, val2, strbar, link
   local res = {}

   if edit then 
      strbar = strings.update 
      link = web:link("/update/"..edit.id)
   else 
      strbar = strings.add 
      link = web:link("/insert")
      edit = { id = 0, name = "", type = "" }
   end

   local inc = {
      strings.name..": ", input{ type="text", name="name", value = edit.name }, " ",
      strings.type..": ", select_and_or("type", edit.type ),  " ",
      "<INPUT TYPE=HIDDEN NAME=\"is_active\" value=\"0\">",
   }
   
   res[#res+1] = render_content_header(strings.application, web:link("/add"), web:link("/list"))
   res[#res+1] = render_form_bar( inc, strbar, link, web:link("/add") )

   return render_layout(res)
end


function render_remove(web, A)
   local res = {}
   local url = ""

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


