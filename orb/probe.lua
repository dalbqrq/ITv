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
local hosts      = Model.nagios:model "hosts"
local services   = Model.nagios:model "services"
local computers  = Model.glpi:model "computers"

-- models ------------------------------------------------------------

function computers:select_computers(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
end


function computers:select_ci_ports(itemtype)
   return Model.select_ci_ports(itemtype)
end


function computers:select_computers_ports(id)
   local clause = ""
   if id then
      clause = "ic.id = "..id
   end
   return Model.select_ci_ports("Computer", clause)
end


-- controllers ------------------------------------------------------------

function list(web)
   local cmp = Model.select_monitors()
   local chk = Model.select_checkcmds()
   return render_list(web, cmp, chk)
end
ITvision:dispatch_get(list, "/", "/list")


function show(web, query, c_id, n_id, sv_id)
   local chk = Model.select_checkcmds()
   local cmp

   query = tonumber(query)

   if query == 1 then
      cmp = Model.query_1(c_id, n_id)
   elseif query == 2 then
      cmp = Model.query_2(c_id, n_id, sv_id)
   elseif query == 3 then
      cmp = Model.query_3(c_id, n_id)
   elseif query == 4 then
      cmp = Model.query_4(c_id, n_id, sv_id)
   elseif query == 5 then
      cmp = Model.query_5(c_id, n_id)
   elseif query == 6 then
      cmp = Model.query_6(c_id, n_id)
   end

   return render_show(web, cmp, chk)
end 
ITvision:dispatch_get(show, "/show/(%d+):(%d+):(%d+):(%d+)")


function edit(web, id)
   return render_add(web, C)
end
ITvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, id)
   local C = {}
   if id then
      local tables = "itvision_app"
      local clause = "id = "..id
      C.name = web.input.name
      C.type = web.input.type
      C.is_active = web.input.is_active
      C.service_object_id = web.input.service_object_id

      Model.update (tables, C, clause) 
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
   local C = app:select_apps(id)
   return render_remove(web, C)
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

      local C = app:select_apps(id)
      local O = select_app_app_objects(id)
      activate_app(C, O, flag)

      Model.update (tables, cols, clause) 
   end
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_get(activate, "/activate/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, cmp, chk)
   local row = {}
   local res = {}
   
   local header =  { "query", strings.name, "IP", "SW / Versão", strings.type, strings.command, "." }

   for i, v in ipairs(cmp) do
      local serv = ""
      if v.s_name ~= "" then serv = v.s_name.." / "..v.sv_name end
      if v.sv_id == "" then v.sv_id = 0 end
      row[#row + 1] = { 
         v[1],
         a{ href= web:link("/show/"..v.c_id), v.c_name}, 
         v.n_ip, 
         serv,
         v.n_itemtype,
         v.svc_check_command_object_id,
         a{ href= web:link("/show/"..v[1]..":"..v.c_id..":"..v.n_id..":"..v.sv_id), strings.add} }
   end

   res[#res+1] = render_content_header("Checagem", web:link("/add"), web:link("/list"))
   res[#res+1] = render_table(row, header)

   return render_layout(res)
end


function render_show(web, cmp, chk)
   --cmp = cmp[1]
   local header =  { "query", strings.name, "IP", "SW / Versão", strings.type, strings.command, "." }

   for i, v in ipairs(cmp) do
res[#res+1] = p{ table.cat(v) }

      local serv = ""
      if v.s_name ~= "" then serv = v.s_name.." / "..v.sv_name end
      if v.sv_id == "" then v.sv_id = 0 end
      row[#row + 1] = { 
         v[1],
         a{ href= web:link("/show/"..v.c_id), v.c_name}, 
         v.n_ip, 
         serv,
         v.n_itemtype,
         v.svc_check_command_object_id,
         "---" }
   end


         --a{ href= web:link("/show/"..v[1]..":"..v.c_id..":"..v.n_id..":"..v.sv_id), strings.add} }
   res[#res+1] = render_content_header("Checagem", web:link("/add"), web:link("/list"))
   res[#res+1] = render_table(row, header)


   return render_layout(res)
end


function render_add(web, edit)
   local res = {}
   local s = ""
   local val1 = ""
   local val2 = ""
   local val3 = ""
   local url = ""
   local default_value = ""

   if edit then
      edit = edit[1]
      val1 = edit.name
      val2 = edit.type
      val3 = edit.is_active
      val4 = edit.service_object_id
      url = "/update/"..edit.id
      default_val2 = val2
      default_val3 = val3
   else
      url = "/insert"
      default_val2 = "and"
      default_val3 = 0
   end

   -- LISTA DE OPERACOES 
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link(url),

      strings.name..": ", input{ type="text", name="name", value = val1 },br(),
      strings.type..": ", select_and_or("type", default_val2), br(),
--[[
      strings.service..": ", select_option("service_object_id", services:find_all(""), "service_object_id", 
         "display_name", val4 ), br(),
      strings.is_active..": ", select_yes_no("is_active", default_val3), br(),
]]
      "<INPUT TYPE=HIDDEN NAME=\"is_active\" value=\"0\">",

      p{ button_form(strings.send, "submit", "positive") },
      p{ button_form(strings.reset, "reset", "negative") },
   }

   return render_layout(res)
end


function render_remove(web, C)
   local res = {}
   local url = ""

   if C then
      C = C[1]
      url_ok = web:link("/delete/"..C.id)
      url_cancel = web:link("/list")
   end

   res[#res + 1] = p{
      strings.exclude_quest.." "..strings.application.." "..C.name.."?",
      p{ button_link(strings.yes, web:link(url_ok)) },
      p{ button_link(strings.cancel, web:link(url_cancel)) },
   }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


