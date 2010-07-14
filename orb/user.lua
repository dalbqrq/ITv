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

local user = itvision:model "user"
local group = itvision:model "user_group"

function user:select_user(id)
   local clause = ""
   if id then
      clause = "user_id = "..id
   end
   return self:find_all(clause)
end

function group:select_group(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
end

function user:select_user_and_group(id)
   local clause = "A.user_group_id = B.id"

   if id then
      clause = clause.." and A.user_id = "..tostring(id)
   end
   local tables = "itvision_user A, itvision_user_group B"
   --local cols = "B.name as name, B.type as type, A.login as login, B.id, A.id as A_id"
   --local res = ma.select (tables, clause, "", cols) 
   local res = ma.select (tables, clause) 

   return res
end

-- controllers ------------------------------------------------------------

function list(web)
   local A = user:select_user_and_group()
   return render_list(web, A)
end
itvision:dispatch_get(list, "/", "/list")


function show(web, id)
   local A = user:select_user_and_group(id)
   return render_show(web, A)
end itvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id)
   local A = user:select_user(id)
   return render_add(web, A)
end
itvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, id)
   local A = {}
   if id then
      local tables = "itvision_user"
      local clause = "user_id = "..id
      --A:new()
      A.login = web.input.login
      if web.input.password ~= "?-^&" then
         A.password = web.input.password
      end
      A.user_group_id = web.input.user_group_id
      --A.user_prefs_id = web.input.user_prefs_id
      A.user_prefs_id = 0

      ma.update (tables, A, clause) 
   end

   return web:redirect(web:link("/list"))
end
itvision:dispatch_post(update, "/update/(%d+)")


function add(web)
   return render_add(web)
end
itvision:dispatch_get(add, "/add")


function insert(web)
   user:new()
   user.login = web.input.login
   if web.input.password ~= "?-^&" then
      user.password = web.input.password
   end
   user.user_group_id = web.input.user_group_id
   --user.user_prefs_id = web.input.user_prefs_id
   user.user_prefs_id = 0
   user.instance_id = config.db.instance_id
   user:save()
   return web:redirect(web:link("/list"))
end
itvision:dispatch_post(insert, "/insert")


function remove(web, id)
   local A = user:select_user(id)
   return render_remove(web, A)
end
itvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   if id then
      local clause = "user_id = "..id
      local tables = "itvision_user"
      ma.delete (tables, clause) 
   end

   return web:redirect(web:link("/list"))
end
itvision:dispatch_get(delete, "/delete/(%d+)")


itvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, A)
   local rows = {}
   local res = {}
   
   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ br(), br() }

   for i, v in ipairs(A) do
      rows[#rows + 1] = tr{ 
         td{ a{ href= web:link("/show/"..v.user_id), v.login} },
         td{ v.name },
         td{ button_link(strings.remove, web:link("/remove/"..v.user_id), "negative") },
         td{ button_link(strings.edit, web:link("/edit/"..v.user_id)) },
      }
   end

   res[#res + 1]  = H("table") { border=1, cellpadding=1,
      thead{ 
         tr{ 
             th{ strings.login }, 
             th{ strings.user_group_name },
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


function render_show(web, A)
   A = A[1]
   local res = {}

   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ button_link(strings.remove, web:link("/remove/"..A.user_id)) }
   res[#res + 1] = p{ button_link(strings.edit, web:link("/edit/"..A.user_id)) }
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   if A then
      res[#res + 1] = { H("table") { border=1, cellpadding=1,
         tbody{
            tr{ th{ strings.login }, td{ A.login } },
            --tr{ th{ strings.password }, td{ A.password } },
            tr{ th{ strings.group }, td{ A.name } },
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
   local val1 = ""
   local val2 = ""
   local url = ""
   local default_value = ""

   if edit then
      edit = edit[1]
      val1 = edit.login
      val2 = "?-^&"
      pwd = edit.password
      url = "/update/"..edit.user_id
      default_value = edit.user_group_id
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
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link(url),

      strings.login..": ", input{ type="text", name="login", value = val1 },br(),
      strings.password..": ", input{ type="password", name="password", value = val2 },br(),
      strings.group..": ", select_option("user_group_id", group:find_all(), "id", "name", default_value), br(),

      p{ button_form(strings.send, "submit", "positive") },
      p{ button_form(strings.reset, "reset", "negative") },
   }

   return render_layout(res)
end


function render_remove(web, A)
   local res = {}
   local url = ""

   if A then
      A = A[1]
      url_ok = web:link("/delete/"..A.user_id)
      url_cancel = web:link("/list")
   end

   res[#res + 1] = p{
      --"Voce tem certeza que deseja excluir o usuario "..A.name.."?",
      strings.exclude_quest.." "..strings.user.." "..A.login.."?",
      p{ button_link(strings.yes, web:link(url_ok)) },
      p{ button_link(strings.cancel, web:link(url_cancel)) },
   }

   return render_layout(res)
end


orbit.htmlify(itvision, "render_.+")

return _M


