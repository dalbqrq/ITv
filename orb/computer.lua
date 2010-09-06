#!/usr/bin/env wsapi.cgi

-- configs ------------------------------------------------------------

require "orbit"
require "config"
require "util"
require "view_utils"


-- config direct access to db
local ma = require "model_access"
local mr = require "model_rules"


-- config ITVISION mvc app
module("itvision", package.seeall, orbit.new)
mapper.conn, mapper.driver = config.setup_db(config.db)
local ci = itvision:model "ci"


-- config GLPI mvc app
glpi = orbit.new()
--glpi.mapper.conn, glpi.mapper.driver = config.setup_db(config.servdesk_db)
glpi.mapper.conn, glpi.mapper.driver = config.setup_sddb()
glpi.mapper.table_prefix = 'glpi_'
local computer = glpi:model "computers"



-- models ------------------------------------------------------------

function computer:select_computer(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   --return self:find_all(clause)
   return ma.select( "glpi_computers" )
end

-- controllers ------------------------------------------------------------

function list(web)
   local A = computer:select_computer()
   return render_list(web, A)
end
itvision:dispatch_get(list, "/", "/list")


function show(web, id)
   local A = computer:select_computer(id)
   return render_show(web, A)
end itvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id)
   local A = computer:select_computer(id)
   return render_add(web, A)
end
itvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, id)
   local A = {}
   if id then
      local tables = "itvision_computer"
      local clause = "computer_id = "..id
      --A:new()
      A.name = web.input.name

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
   computer:new()
   computer.name = web.input.name
   computer:save()
   return web:redirect(web:link("/list"))
end
itvision:dispatch_post(insert, "/insert")


function remove(web, id)
   local A = computer:select_computer(id)
   return render_remove(web, A)
end
itvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   if id then
      local clause = "computer_id = "..id
      local tables = "itvision_computer"
      ma.delete (tables, clause) 
   end

   return web:redirect(web:link("/list"))
end
itvision:dispatch_get(delete, "/delete/(%d+)")


itvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function  render_list(web, A)
   local rows = {}
   local res = {}
   
   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ br(), br() }

   for i, v in ipairs(A) do
      rows[#rows + 1] = tr{ 
         td{ a{ href= web:link("/show/"..v.id), v.name} },
         td{ button_link(strings.remove, web:link("/remove/"..v.id), "negative") },
         td{ button_link(strings.edit, web:link("/edit/"..v.id)) },
      }
   end

   res[#res + 1]  = H("table") { border=1, cellpadding=1,
      thead{ 
         tr{ 
             th{ strings.name }, 
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
   res[#res + 1] = p{ button_link(strings.remove, web:link("/remove/"..A.computer_id)) }
   res[#res + 1] = p{ button_link(strings.edit, web:link("/edit/"..A.computer_id)) }
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   if A then
      res[#res + 1] = { H("table") { border=1, cellpadding=1,
         tbody{
            tr{ th{ strings.name }, td{ A.name } },
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
      url = "/update/"..edit.computer_id
   else
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
      url_ok = web:link("/delete/"..A.computer_id)
      url_cancel = web:link("/list")
   end

   res[#res + 1] = p{
      --"Voce tem certeza que deseja excluir o usuario "..A.name.."?",
      strings.exclude_quest.." "..strings.computer.." "..A.name.."?",
      p{ button_link(strings.yes, web:link(url_ok)) },
      p{ button_link(strings.cancel, web:link(url_cancel)) },
   }

   return render_layout(res)
end


orbit.htmlify(itvision, "render_.+")

return _M


