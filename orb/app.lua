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

function app:select(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
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


function services:select(id)
   local clause = ""
   if id then
      clause = "service_object_id = "..id
   end
   return self:find_all(clause)
end

-- controllers ------------------------------------------------------------

function list(web)
   local A = app:select()
   return render_list(web, A)
end
ITvision:dispatch_get(list, "/", "/list")
ITvision:dispatch_post(list, "/list")


function show(web, id)
   local A = app:select(id)
   local O = app_object:select(id)
   local R = app_relat:select(id)
   return render_show(web, A, O, R)
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
   local A = app:select_apps(id)
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
   if id then
      local clause = "id = "..id
      local tables = "itvision_app"
      cols.is_active = flag

      local A = app:select_apps(id)
      local O = select_app_app_objects(id)
      activate_app(A, O, flag)

      Model.update (tables, cols, clause) 
   end
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_get(activate, "/activate/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, A)
   local row = {}
   local res = {}
   local svc = {}
   local stract

   local header =  { strings.name, strings.type, strings.is_active, ".", ".", "." }

   for i, v in ipairs(A) do
      if v.service_object_id then
         svc = services:select_services(v.service_object_id)[1].display_name
      else
         svc = "-"
      end

      if v.is_active == "0" then
         stract = strings.activate
      else
         stract = strings.deactivate
      end

      web.prefix = "/orb/app_object"
      local lnk = web:link("/list/"..v.id)
      web.prefix = "/orb/app"

         --a{ href= web:link("/show/"..v.id), v.name },
      row[#row+1] = {
         a{ href=lnk, v.name },
         strings["logical_"..v.type],
         NoOrYes[v.is_active+1].name,
         button_link(strings.remove, web:link("/remove/"..v.id), "negative"),
         button_link(strings.edit, web:link("/edit/"..v.id..":"..v.name..":"..v.type)),
         button_link(stract, web:link("/activate/"..v.id..":"..v.is_active)) }
   end

   res[#res+1] = render_content_header(strings.application, web:link("/add"), web:link("/list"))
   res[#res+1] = render_form_bar( render_filter(web), strings.search, web:link("/list"), web:link("/list") )
   res[#res+1] = render_table(row, header)

   return render_layout(res)
end


--[[  
   MUDEI DE IDEIA, VOU CONTINUAR USANDO cwapp_object.lua e app_relat.lua PARA ENTRAR
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
      strbar = strings.edit 
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


