#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "monitor_util"
require "View"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local app        = Model.itvision:model "app"
local app_object = Model.itvision:model "app_object"
local app_relat  = Model.itvision:model "app_relat"
local services   = Model.nagios:model "services"

-- models ------------------------------------------------------------

function app:select(id, clause_)
   local clause = nil

   if id and clause_ then
      clause = "id = "..id.." and "..clause_
   elseif id then
      clause = "id = "..id
   elseif clause_ then
      clause = clause_
   end

   extra  = " order by id "
   return Model.query("itvision_app", clause, extra)
end


function app:update(app)
   local A = {}
   if app.id then
      local tables = "itvision_app"
      local clause = "id = "..app.id
      A.id = app.id
      A.service_object_id = app.service_object_id

      Model.update (tables, A, clause) 
   end
end


function app_object:select(id)
   local clause = ""
   if id then
      clause = "app_id = "..id
   end
   return self:find_all(clause)
end


function app_relat:select(id)
   local clause = ""
   if id then
      clause = "app_id = "..id
   end
   return self:find_all(clause)
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
   local clause
   if web.input.app_name then clause = " name like '%"..web.input.app_name.."%' " end

   local A = app:select(nil, clause)
   return render_list(web, A, msg)
end
ITvision:dispatch_get(list, "/", "/list", "/list/(.+)")
ITvision:dispatch_post(list, "/list")


function show(web, id)
   local A = app:select(id)
   local O = app_object:select(id)
   local R = app_relat:select(id)
   return render_show(web, A, O, R)
end 
ITvision:dispatch_get(show, "/show", "/show/(%d+)")


function edit(web, id, nm, tp)
   local edt = { id = id, name = nm, type = tp }
   return render_add(web, edt)
end
ITvision:dispatch_get(edit, "/edit/(%d+):(.+):(%a+)")


function update(web, id)
   local A = {}
   if id then
      local tables = "itvision_app"
      local clause = "id = "..id
      A.name = web.input.name
      A.type = web.input.type
      A.is_active = web.input.is_active
      A.service_object_id = web.input.service_object_id

      Model.update (tables, A, clause) 
   end

   return web:redirect(web:link("/list"))
end
ITvision:dispatch_post(update, "/update/(%d+)")


function add(web)
   return render_add(web)
end
ITvision:dispatch_get(add, "/add")


function insert(web)
   app:new()
   app.name = web.input.name
   app.type = web.input.type
   app.is_active = web.input.is_active
   --app.service_object_id = web.input.service_object_id
   app.instance_id = Model.db.instance_id
   app:save()
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_post(insert, "/insert")


function remove(web, id)
   local A = app:select(id)
   return render_remove(web, A)
end
ITvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   if id then
      local clause = "id = "..id
      local tables = "itvision_app"
      Model.delete (tables, clause) 
   end

   return web:redirect(web:link("/list"))
end
ITvision:dispatch_get(delete, "/delete/(%d+)")


function activate(web, id, flag)
   if flag == "0" then flag = 1 else flag = 0 end
   local cols = {}
   local msg, counter

   if id then
      local clause = "id = "..id
      local tables = "itvision_app"
      cols.is_active = flag

      local A = app:select(id)
      local O = Model.select_app_app_objects(id)
      if A[1] then
         -- Sinaliza a app como ativa
         Model.update (tables, cols, clause) 
         -- Recria arquivo de config do business process e 
         -- servicos do nagios para as aplicacoes
         local APPS = app:select()
         activate_all_apps(APPS)

         local s = services:select(nil, "display_name = '"..A[1].name.."'")
         -- caso host ainda nao tenha sido incluido aguarde e tente novamente
         counter = 0
         while s[1] == nil do
            counter = counter + 1
            for i = 1,loop do x = i/2 end -- aguarde...
            s = services:select(nil, "display_name = '"..A[1].name.."'")
         end
         local svc = { id = A[1].id, service_object_id = s[1].service_object_id }
         app:update(svc)

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


function render_list(web, A, msg)
   local res = {}
   local row = {}
   local svc, stract

   for i, v in ipairs(A) do
      if v.is_active == "0" then
         stract = strings.activate
      else
         stract = strings.deactivate
      end

      web.prefix = "/orb/app_object"
      local lnk = web:link("/list/"..v.id)
      web.prefix = "/orb/app"

      row[#row+1] = {
         a{ href=lnk, v.name },
         strings["logical_"..v.type],
         NoOrYes[v.is_active+1].name,
         button_link(strings.remove, web:link("/remove/"..v.id), "negative"),
         button_link(strings.edit, web:link("/edit/"..v.id..":"..v.name..":"..v.type)),
         button_link(stract, web:link("/activate/"..v.id..":"..v.is_active)) }
   end

   local header =  { strings.name, strings.type, strings.is_active, ".", ".", "." }
   res[#res+1] = render_content_header(strings.application, web:link("/add"), web:link("/list"))
   res[#res+1] = render_form_bar( render_filter(web), strings.search, web:link("/list"), web:link("/list") )
   if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ msg } end
   res[#res+1] = render_table(row, header)

   return render_layout(res)
end


--[[  
   MUDEI DE IDEIA, VOU CONTINUAR USANDO app_object.lua e app_relat.lua PARA ENTRAR
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
      url_ok = web:link("/delete/"..A.id)
      url_cancel = web:link("/list")
   end

   res[#res+1] = p{
      strings.exclude_quest.." "..strings.application.." "..A.name.."?",
      p{ button_link(strings.yes, web:link(url_ok)) },
      p{ button_link(strings.cancel, web:link(url_cancel)) },
   }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


