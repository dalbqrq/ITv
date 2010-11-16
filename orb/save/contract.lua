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

local contract = itvision:model "contract"

function contract:select_contract(id)
   local clause = ""
   if id then
      clause = "contract_id = "..id
   end
   return self:find_all(clause)
end

-- controllers ------------------------------------------------------------

function list(web)
   local A = contract:select_contract()
   return render_list(web, A)
end
itvision:dispatch_get(list, "/", "/list")


function show(web, id)
   local A = contract:select_contract(id)
   return render_show(web, A)
end itvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id)
   local A = contract:select_contract(id)
   return render_add(web, A)
end
itvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, id)
   local contract = {}
   if id then
      local tables = "itvision_contract"
      local clause = "contract_id = "..id
      --contract:new()
      contract.company = web.input.company
      contract.begins = web.input.begins
      contract.ends = web.input.ends
      contract.description = web.input.description

      ma.update (tables, contract, clause) 
   end

   return web:redirect(web:link("/list"))
end
itvision:dispatch_post(update, "/update/(%d+)")


function add(web)
   return render_add(web)
end
itvision:dispatch_get(add, "/add")


function insert(web)
   --contract:new()
   contract.company = web.input.company
   contract.begins = tonumber(web.input.begins)
   contract.begins = contract.begins or 0
   contract.ends = tonumber(web.input.ends)
   contract.ends = contract.ends or 0
   contract.description = web.input.description
   contract:save()
   return web:redirect(web:link("/list"))
end
itvision:dispatch_post(insert, "/insert")


function remove(web, id)
   local A = contract:select_contract(id)
   return render_remove(web, A)
end
itvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   if id then
      local clause = "contract_id = "..id
      local tables = "itvision_contract"
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
         td{ a{ href= web:link("/show/"..v.contract_id), v.company} },
         td{ v.begins },
         td{ v.ends },
         td{ v.description },
         td{ button_link(strings.remove, web:link("/remove/"..v.contract_id), "negative") },
         td{ button_link(strings.edit, web:link("/edit/"..v.contract_id)) },
      }
   end

   res[#res + 1]  = H("table") { border=1, cellpadding=1,
      thead{ 
         tr{ 
             th{ strings.company }, 
             th{ strings.begins }, 
             th{ strings.ends }, 
             th{ strings.description }, 
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
   res[#res + 1] = p{ button_link(strings.remove, web:link("/remove/"..A.contract_id)) }
   res[#res + 1] = p{ button_link(strings.edit, web:link("/edit/"..A.contract_id)) }
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   if A then
      res[#res + 1] = { H("table") { border=1, cellpadding=1,
         tbody{
            tr{ th{ strings.company }, td{ A.company } },
            tr{ th{ strings.begins }, td{ A.begins } },
            tr{ th{ strings.ends }, td{ A.ends } },
            tr{ th{ strings.description }, td{ A.description } },
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
      val1 = edit.company
      val2 = edit.begins
      val3 = edit.ends
      val4 = edit.description
      url = "/update/"..edit.contract_id
   else
      url = "/insert"
   end

   -- LISTA DE OPERACOES 
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   res[#res + 1] = form{
      name = "input", method = "post",
      action = web:link(url),

      strings.company..": ", input{ type="text", name="company", value = val1 },br(),
      strings.begins..": ", input{ type="date", name="begins", value = val2 },br(),
      strings.ends..": ", input{ type="date", name="ends", value = val3 },br(),
      strings.description..": ", textarea{ name="description", cols="50", rows="5", size="500", val4},br(),

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
      url_ok = web:link("/delete/"..A.contract_id)
      url_cancel = web:link("/list")
   end

   res[#res + 1] = p{
      strings.exclude_quest.." "..strings.contract.." "..A.company.."?",
      p{ button_link(strings.yes, web:link(url_ok)) },
      p{ button_link(strings.cancel, web:link(url_cancel)) },
   }

   return render_layout(res)
end


orbit.htmlify(itvision, "render_.+")

return _M


