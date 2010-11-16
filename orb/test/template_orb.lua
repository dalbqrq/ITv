#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "View"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local app = Model.itvision:model "app"


-- models ------------------------------------------------------------


function app:select_apps(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
end

function app:select_apps_and_B(id)
   local clause = "apps.id = B.id"

   if id then
      clause = clause.." and apps.id = "..tostring(id)
   end
   local tables = "itvision_app A, itvision_B B"
   local cols = "A.name as name, A.type as type, B.name as B_name, B.id, A.id as A_id"
   local res = Model.select (tables, clause, "", cols) 

   return res
end

-- controllers ------------------------------------------------------------

function list(web)
   local A = app:select_apps()
   return render_list(web, A)
end
ITvision:dispatch_get(list, "/", "/list")


function show(web, id)
   local A = app:select_apps(id)
   return render_show(web, A)
end
ITvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id)
   local A = app:select_apps()
   local B = app:select_apps_and_B(id)
   return render_add(web, A, B)
end
ITvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, id)
   local A = {}
   if id then
      local tables = "itvision_app"
      local clause = "id = "..id
      --A:new()
      A.name = web.input.name
      --...

      Model.update (tables, A, clause) 
   end

   return web:redirect(web:link("/list"))
end
ITvision:dispatch_post(update, "/update/(%d+)")


function add(web)
   local A = app:select_apps()
   return render_add(web, A)
end
ITvision:dispatch_get(add, "/add")


function insert(web)
   A:new()
   A.name = web.input.name
   --A.root_app = web.input.root_app
   A.instance_id = Model.db.instance_id
   A:save()
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


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, A)
   local rows = {}
   local res = {}
   
   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ br(), br() }

   for i, v in ipairs(A) do
      rows[#rows + 1] = tr{ 
         td{ a{ href= web:link("/show/"..v.id), v.Bname} },
         td{ v.name },
         td{ button_link(strings.remove, web:link("/remove/"..v.id), "negative") },
         td{ button_link(strings.edit, web:link("/edit/"..v.id)) },
      }
   end

   res[#res + 1]  = H("table") { border=1, cellpadding=1,
      thead{ 
         tr{ 
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


function render_show(web, A)
   A = A[1]
   local res = {}

   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ button_link(strings.remove, web:link("/remove/"..A.id)) }
   res[#res + 1] = p{ button_link(strings.edit, web:link("/edit/"..A.id)) }
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   if A then
      res[#res + 1] = { H("table") { border=1, cellpadding=1,
         tbody{
            tr{ th{ strings.user_group_name }, td{ A.Aname } },
            tr{ th{ strings.type }, td{ A.type } },
            tr{ th{ strings.application }, td{ A.name } },
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


function render_add(web, A, edit)
   local res = {}
   local A_list = {} 
   local s = ""
   local sel = ""
   local val = ""
   local url = ""

   if edit then
      edit = edit[1]
      val = edit.Aname
      url = "/update/"..edit.id
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
   res[#res + 1] = p { button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

--[[
   for i, v in ipairs(A) do
      if edit and (tonumber(edit.app_id) == tonumber(v.app_id)) then
         sel = " selected"
      else 
         sel = ""
      end

      A_list[#A_list + 1] = H("option"..sel) { value = v.app_id, label = v.name, v.name } 
   end
]]

   value_idx = "app_id"
   label_idx = "names"
   default_value = edit.app_id
   A_list = select_option(A, value_idx, label_idx, default_value)

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link(url),
      strings.user_group_name..": ", input{ type="text", name="name", value = val }, 
      br(),
      strings.application..": ", H("select"){ name="root_app",  A_list },
      p{ button_form(strings.send, "submit", "positive") },
      p{ button_form(strings.reset, "reset", "negative") },
   }

   return render_layout(res)
end


function render_remove(web, A)
   local res = {}
   local url = ""

   if A then
      url_ok = web:link("/delete/"..A.id)
      url_cancel = web:link("/list")
   end

   res[#res + 1] = p{
      "Voce tem certeza que deseja excluir o grupo de usuarios "..A.name.."?",
      p{ button_link(strings.yes, web:link(url_ok)) },
      p{ button_link(strings.cancel, web:link(url_cancel)) },
   }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


