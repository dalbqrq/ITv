#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "view_utils"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local app = Model.itvision:model "app"
local services = Model.nagios:model "services"
local app_relat_type = Model.itvision:model "app_relat_type"


-- models ------------------------------------------------------------


function app_relat_type:select_app_relat_type(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
end

-- controllers ------------------------------------------------------------

function list(web)
   local A = app_relat_type:select_app_relat_type()
   return render_list(web, A)
end
ITvision:dispatch_get(list, "/", "/list")


function show(web, id)
   local A = app_relat_type:select_app_relat_type(id)
   return render_show(web, A)
end ITvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id)
   local A = app_relat_type:select_app_relat_type(id)
   return render_add(web, A)
end
ITvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, id)
   local A = {}
   if id then
      local tables = "itvision_app_relat_type"
      local clause = "id = "..id
      --A:new()
      A.name = web.input.name
      A.type = web.input.type

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
   app_relat_type:new()
   app_relat_type.name = web.input.name
   app_relat_type.type = web.input.type
   app_relat_type:save()
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_post(insert, "/insert")


function remove(web, id)
   local A = app_relat_type:select_app_relat_type(id)
   return render_remove(web, A)
end
ITvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   if id then
      local clause = "id = "..id
      local tables = "itvision_app_relat_type"
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
         td{ a{ href= web:link("/show/"..v.id), v.name} },
         td{ strings[v.type] },
         td{ button_link(strings.remove, web:link("/remove/"..v.id), "negative") },
         td{ button_link(strings.edit, web:link("/edit/"..v.id)) },
      }
   end

   res[#res + 1]  = H("table") { border=1, cellpadding=1,
      thead{ 
         tr{ 
             th{ strings.name }, 
             th{ strings.type }, 
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
            tr{ th{ strings.name }, td{ A.name } },
            tr{ th{ strings.type }, td{ A.type } },
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

   if edit then
      edit = edit[1]
      val1 = edit.name
      val2 = edit.type
      url = "/update/"..edit.id
   else
      val2 = "logical"
      url = "/insert"
   end

   -- LISTA DE OPERACOES 
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link(url),

      strings.name..": ", input{ type="text", name="name", value = val1 },br(), 
      strings.type..": ", select_physical_logical("type", val2), br(),

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
      url_ok = web:link("/delete/"..A.id)
      url_cancel = web:link("/list")
   end

   res[#res + 1] = p{
      --"Voce tem certeza que deseja excluir o usuario "..A.name.."?",
      strings.exclude_quest.." "..strings.app_relat_type.." "..A.name.."?",
      p{ button_link(strings.yes, web:link(url_ok)) },
      p{ button_link(strings.cancel, web:link(url_cancel)) },
   }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


