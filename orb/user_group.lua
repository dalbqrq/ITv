#!/usr/bin/env wsapi.cgi

require "orbit"

module("itvision", package.seeall, orbit.new)

-- configs ------------------------------------------------------------

require "config"
require "util"
require "view_utils"

mapper.conn, mapper.driver = config.setup_orbdb()

local ma = require "model_access"
local mr = require "model_rules"

-- models ------------------------------------------------------------

local apps = itvision:model "apps"
local user = itvision:model "user"
local user_group = itvision:model "user_group"

function apps:select_apps(app_id)
   local clause = ""
   if app_id then
      clause = "app_id = "..app_id
   end
   return self:find_all(clause)
end

function user:select_user(user_id)
   local clause = ""
   if user_id then
      clause = "user_id = "..user_id
   end
   return self:find_all(clause)
end

function user_group:select_user_group(user_group_id)
   local clause = ""
   if user_group_id then
      clause = "id = "..user_group_id
   end
   --return self:find_all(clause)
   return self:find(user_group_id)
end

function user_group:uniq(user_group_id)
   return self:find(user_group_id)
end

function user_group:select_user_group_app(user_group_id)
   local clause = "ug.root_app = ap.app_id"

   if user_group_id then
      clause = clause.." and ug.id = "..tostring(user_group_id)
   end
   local tables = "itvision_user_group ug, itvision_apps ap"
   local cols = "ap.name as name, ap.type as type, ug.name as ugname, ug.id, ap.app_id as app_id"
   local res = ma.select (tables, clause, "", cols) 

   return res
end

-- controllers ------------------------------------------------------------

function list(web)
   local ug = user_group:select_user_group_app()
   return render_list(web, ug)
end
itvision:dispatch_get(list, "/", "/list")


function show(web, user_group_id)
   local ug = user_group:select_user_group_app(user_group_id)
   return render_show(web, ug)
end
itvision:dispatch_get(show, "/show/(%d+)")


function edit(web, user_group_id)
   local ug = user_group:select_user_group_app(user_group_id)
   return render_add(web, ug)
end
itvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, user_group_id)
   local ug = {}
   if user_group_id then
      local tables = "itvision_user_group"
      local clause = "id = "..user_group_id
      --user_group:new()
      ug.name = web.input.name
      ug.root_app = web.input.root_app

      ma.update (tables, ug, clause) 
   end

   return web:redirect(web:link("/list"))
end
itvision:dispatch_post(update, "/update/(%d+)")


function add(web)
   return render_add(web)
end
itvision:dispatch_get(add, "/add")


function insert(web)
   user_group:new()
   user_group.name = web.input.name
   user_group.root_app = web.input.root_app
   user_group.instance_id = config.db.instance_id
   user_group:save()
   return web:redirect(web:link("/list"))
end
itvision:dispatch_post(insert, "/insert")


function remove(web, user_group_id)
   local ug = user_group:select_user_group(user_group_id)
   return render_remove(web, ug)
end
itvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, user_group_id)
   if user_group_id then
      local clause = "id = "..user_group_id
      local tables = "itvision_user_group"
      ma.delete (tables, clause) 
   end

   return web:redirect(web:link("/list"))
end
itvision:dispatch_get(delete, "/delete/(%d+)")


itvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, ug)
   local rows = {}
   local res = {}
   
   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ br(), br() }

   for i, v in ipairs(ug) do
      rows[#rows + 1] = tr{ 
         --td{ v.user_group_id },
         td{ a{ href= web:link("/show/"..v.id), v.ugname} },
         td{ v.name },
         --td{ a{ href= web:link("/remove/"..v.id), strings.remove} },
         --td{ a{ href= web:link("/edit/"..v.id), strings.edit} },
         td{ button_link(strings.remove, web:link("/remove/"..v.id), "negative") },
         td{ button_link(strings.edit, web:link("/edit/"..v.id)) },
      }
   end

   res[#res + 1]  = H("table") { border=1, cellpadding=1,
      thead{ 
         tr{ 
             --th{ "user_group_id" },
             th{ strings.user_group_name }, 
             th{ strings.application },
             th{ "." },
             th{ "." },
         }
      },
      tbody{
         rows
      }
   }

   return render_layout(res)
end


function render_show(web, ug)
   ug = ug[1]
   local res = {}

   -- LISTA DE OPERACOES
   --[[ Duas opcoes nao utilizadas: a primeira com form e a segunda com link sem estilo css.
   res[#res + 1] = form { action = web:link("/add"), input { value = strings.add, type = "submit" } }
   res[#res + 1] = form { action = web:link("/remove/"..ug.id),input { value = strings.remove, type = "submit" } }
   res[#res + 1] = form { action = web:link("/edit/"..ug.id),  input { value = strings.edit, type = "submit" } }
   res[#res + 1] = form { action = web:link("/list"),  input { value = strings.list, type = "submit" } }

   res[#res+1] =  a{ href= web:link("/add"), strings.add} .." "
   res[#res+1] =  a{ href= web:link("/remove/"..ug.id), strings.remove} .." "
   res[#res+1] =  a{ href= web:link("/edit/"..ug.id), strings.edit} .." "
   res[#res+1] =  a{ href= web:link("/list"), strings.list} .." "
   ]]

   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ button_link(strings.remove, web:link("/remove/"..ug.id)) }
   res[#res + 1] = p{ button_link(strings.edit, web:link("/edit/"..ug.id)) }
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   if ug then
      res[#res + 1] = { H("table") { border=1, cellpadding=1,
         tbody{
            --tr{ td{ "id" }, td{ ug.user_group_id } },
            tr{ th{ strings.user_group_name }, td{ ug.ugname } },
            tr{ th{ strings.type }, td{ ug.type } },
            tr{ th{ strings.application }, td{ ug.name } },
         }
      } }
   else
      res = { error_message(3),
         p(),
         a{ href= web:link("/list"), strings.list}, " ",
         a{ href= web:link("/add"), strings.add}, " ",
      }
   end

   return render_layout(res)
end


function render_add(web, edit)
   local res = {}
   local s = ""
   local val = ""
   local url = ""

   if edit then
      edit = edit[1]
      val = edit.ugname
      url = "/update/"..edit.id
      default_value = edit.app_id
   else
      url = "/insert"
   end

   --[[
   if string.find(input.app_id, "^%s*$") then
      return render_nothing(web, id, true)
   else
      local app_list = app_list:new()
      app_list.app_id = tonumber(id)
   end
   ]]

   -- LISTA DE OPERACOES 
   --res[#res + 1] = form { action = web:link("/list"),  input { value = strings.list, type = "submit" } }
   res[#res + 1] = p { button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   --[[
   local sel = ""
   local ap_list = {} 
   local ap = apps:find_all()

   for i, v in ipairs(ap) do
      if edit and (tonumber(edit.app_id) == tonumber(v.app_id)) then
         sel = " selected"
      else 
         sel = ""
      end

      ap_list[#ap_list + 1] = H("option"..sel) { value = v.app_id, label = v.name, v.name } 
   end
   ]]--

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link(url),

      strings.user_group_name..": ", input{ type="text", name="name", value = val }, br(),
      strings.application..": ", select_option("root_app", apps:find_all(), "app_id", "name", default_value),br(),

      --[[
      strings.application..": ", H("select"){ name="root_app",  ap_list }, br(),
      input.button{ type="submit", value=strings.send }, " ",
      input.button{ type="reset", value=strings.reset },
      ]]
      p{ button_form(strings.send, "submit", "positive") },
      p{ button_form(strings.reset, "reset", "negative") },
   }

   return render_layout(res)
end


function render_remove(web, ug)
   local res = {}
   local url = ""

   if ug then
      url_ok = web:link("/delete/"..ug.id)
      url_cancel = web:link("/list")
   end

   res[#res + 1] = p{
      "Voce tem certeza que deseja excluir o grupo de usuarios "..ug.name.."?",
      p{ button_link(strings.yes, web:link(url_ok)) },
      p{ button_link(strings.cancel, web:link(url_cancel)) },
   }

   return render_layout(res)
end


orbit.htmlify(itvision, "render_.+")

return _M


