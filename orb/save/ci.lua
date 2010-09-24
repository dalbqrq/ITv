#!/usr/bin/env wsapi.cgi

require "orbit"

-- configs ------------------------------------------------------------

require "config"
require "util"
require "view_utils"

local ma = require "model_access"
local mr = require "model_rules"


-- config ITVISION mvc app
module("itvision", package.seeall, orbit.new)
mapper.conn, mapper.driver = config.setup_orbdb()
local ci = itvision:model "ci"
local contract = itvision:model "contract"
local manufacturer = itvision:model "manufacturer"
local location_tree = itvision:model "location_tree"

-- config NAGIOS mvc app
nagios = orbit.new()
nagios.mapper.conn, nagios.mapper.driver = config.setup_orbdb()
nagios.mapper.table_prefix = 'nagios_'
local objects = nagios:model "objects"


-- models ------------------------------------------------------------

function ci:select_ci(id)
   if id then tonumber(id) end

   local A, B = mr:select_ci(id)
   return A, B
end

function contract:select_contract(id)
   local clause = ""
   if id then
      clause = "contract_id = "..id
   end
   return self:find_all(clause)
end

function manufacturer:select_manufacturer(id)
   local clause = ""
   if id then
      clause = "manufacturer_id = "..id
   end
   return self:find_all(clause)
end

function location_tree:select_location_tree(origin)
   return mr.select_full_path_location_tree(origin)
end


-- controllers ------------------------------------------------------------

function list(web)
   local A, B = ci:select_ci()
   return render_list(web, A, B)
end
itvision:dispatch_get(list, "/", "/list")


function show(web, id)
   local A = ci:select_ci(id)
   return render_show(web, A)
end itvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id)
   local A = ci:select_ci(id)
   return render_add(web, A)
end
itvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, id)
   local A = {}
   if id then
      local tables = "itvision_ci"
      local clause = "ci_id = "..id
      --A:new()
      A.name = web.input.name

      ma.update (tables, A, clause) 
   end

   return web:redirect(web:link("/list"))
end
itvision:dispatch_post(update, "/update/(%d+)")


function add(web)
   local ci = ci:select_ci()
   local lo = location_tree:select_location_tree()
   local ma = manufacturer:select_manufacturer()
   local co = contract:select_contract()
   return render_add(web, ci, lo, ma, co)
end
itvision:dispatch_get(add, "/add")


function insert(web)
   ci:new()
   --ci = mr.new_ci()
   if web.input.name then
      ci.name = web.input.name
   else
      return web:redirect(web:link("/add/0"))
   end
   ci.alias = web.input.alias
   ci.is_active = web.input.is_active
   ci.location_tree_id = web.input.locat
   ci.manufacturer = web.input.manufac
   ci.sn = web.input.sn
   ci.obs = web.input.obs
   ci.ci_parent_id = web.input.parent
   ci.instance_id = config.db.instance_id
   ci:save()

   return web:redirect(web:link("/list"))
end
itvision:dispatch_post(insert, "/insert")


function remove(web, id)
   local A = ci:select_ci(id)
   return render_remove(web, A)
end
itvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   if id then
      local clause = "ci_id = "..id
      local tables = "itvision_ci"
      ma.delete (tables, clause) 
   end

   return web:redirect(web:link("/list"))
end
itvision:dispatch_get(delete, "/delete/(%d+)")

function map(web, lat, lon)
   return render_map(web, lat, lon)
end
itvision:dispatch_get(map, "/map/([+-]?%d+\.%d+),([+-]?%d+\.%d+)")



itvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function render_table(web, t)
   local res = {}
   res[#res + 1] = p{ table.dump(t) }
   return render_layout(res)
end


function render_list(web, A, B)
   local rows = {}
   local res = {}
   
   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ br(), br() }

   for i, v in ipairs(A) do
      rows[#rows + 1] = tr{ 
         td{ a{ href= web:link("/show/"..v.ci_id), v.name} },
         td{ v.alias },
         td{ v.location_tree_id },
         td{ v.manufacturer_id },
--[[
         td{ v.name1 },
         td{ v.name2 },
         td{ v.locat },
         td{ v.is_active },
         td{ v.company },
         td{ v.manufac },
         td{ a{ href= web:link("/map/"..v.geotag), v.geotag} },
         td{ v.obs },
]]
         td{ v.sn },
         -- CI nao pode ser removido! td{ button_link(strings.remove, web:link("/remove/"..v.ci_id), "negative") },
         td{ button_link(strings.edit, web:link("/edit/"..v.ci_id)) },
      }
   end

   res[#res + 1]  = H("table") { border=1, cellpadding=1,
      thead{ 
         tr{ 
             th{ strings.name }, 
             th{ "alias" },
             th{ "locat" },
             th{ "fabric" },
--[[
             th{ "name1" },
             th{ "name2" },
             th{ "locat" },
             th{ "is_active" },
             th{ "support" },
             th{ "manufac" },
             th{ "Geotab" },
             th{ "Obs" },
]]
             th{ "SN" },
             -- CI nao pode ser removido!! th{ "." },
             th{ "." },
         }
      },
      tbody{
         rows
      }
   }

   res[#res + 1] = P {B}

   return render_layout(res)
end


function render_show(web, A)
   A = A[1]
   local res = {}

   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ button_link(strings.remove, web:link("/remove/"..A.ci_id)) }
   res[#res + 1] = p{ button_link(strings.edit, web:link("/edit/"..A.ci_id)) }
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


function render_add(web, ci, lo, ma, co, edit, err)
   local res = {}
   local s = ""
   local val1, val2, val3, val4, val5, val6, val7, val8, mess, url

   if err == 0 then mess = error_message(4) else mess = "" end

   if edit then
      edit = edit[1]
      val1 = edit.name
      val2 = edit.alias
      val3 = edit.location
      val4 = edit.is_active
      val5 = edit.manufacturer
      val6 = edit.sn
      val7 = edit.obs
      val8 = edit.ci_id
      url = "/update/"..val4
   else
      url = "/insert"
   end

   --local t = ci:find_all()
   --local r = { name=strings.root, ci_id=0, obs = nil, geotag=nil}
   --table.insert(t, r)
   local t = {}

   -- LISTA DE OPERACOES 
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link(url),

      strings.name..": ", input{ type="text", name="name", value = val1 }, mess, br(),
      strings.alias..": ", input{ type="text", name="alias", value = val2 }, mess, br(),
      strings.is_active..": ", select_yes_no("is_active", val4), br(),
      strings.location..": ", select_option("locat", lo, "location_tree_id", "name", val3), br(),
      strings.manufacturer..": ", select_option("manufac", ma, "manufacturer_id", "name", val5), br(),
      "SN", input{ type="text", name="sn", value = val6 }, br(),
      "Obs: ", textarea{ name="obs", cols="50", rows="5", size="500", val7},br(),
      strings.child_of..": ", select_option("parent", t, "ci_id", "name", val8), br(),

      p{ button_form(strings.send, "submit", "positive") },
      p{ button_form(strings.reset, "reset", "negative") },
   }

   return render_layout(res)
end


function render_remove(web, A)
   local res = {}

   if A then
      A = A[1]
      url_ok = web:link("/delete/"..A.ci_id)
      url_cancel = web:link("/list")
   end

   res[#res + 1] = p{
      --"Voce tem certeza que deseja excluir o usuario "..A.name.."?",
      "PROBLEMA COM REMOCAO DE LOCALIZACAO!",
      strings.exclude_quest.." "..strings.location.." "..A.name.."?",
      p{ button_link(strings.yes, web:link(url_ok)) },
      p{ button_link(strings.cancel, web:link(url_cancel)) },
   }

   return render_layout(res)
end


orbit.htmlify(itvision, "render_.+")

return _M


