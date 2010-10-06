#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------

require "util"
require "view_utils"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local app = Model.itvision:model "app"
local app_tree = Model.itvision:model "app_tree"



-- models ------------------------------------------------------------

function app_tree:select_app_tree(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
end


function app_tree:select_full_path(node)
   return Model.select_full_path_app_tree(node)
end 

function app:select_apps(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
end



-- controllers ------------------------------------------------------------

function list(web)
   local A = app_tree:select_full_path()
   return render_list(web, A)
end
ITvision:dispatch_get(list, "/", "/list")

--[[
function show(web, id)
   local A = app_tree:select_app_tree(id)
   return render_show(web, A)
end ITvision:dispatch_get(show, "/show/(%d+)")
]]--


function edit(web, id)
   local A = app_tree:select_full_path()
   local B = app_tree:select_app_tree(id)
   return render_add(web, A, B, nil)
end
ITvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, id)
   local A = {}
   if id then
      local tables = "itvision_app_tree"
      local clause = "id = "..id
      --A:new()
      A.name = web.input.name

      Model.update (tables, A, clause) 
   end

   return web:redirect(web:link("/list"))
end
ITvision:dispatch_post(update, "/update/(%d+)")


function add(web, err)
   local A = app_tree:select_full_path()
   return render_add(web, A, nil, err)
end
ITvision:dispatch_get(add, "/add", "/add/(%d+)")


function insert(web)
   local origin
   app_tree = Model.new_app_tree()
   if web.input.app then
      app_tree.app_id = web.input.app_id
   else
      return web:redirect(web:link("/add/0"))
   end

   if tonumber(web.input.parent) > 0 then origin = web.input.parent end
   Model.insert_node_app_tree(app_tree, origin, 1)

   return web:redirect(web:link("/list"))
end
ITvision:dispatch_post(insert, "/insert")


function remove(web, id)
   local A = app_tree:select_app_tree(id)
   return render_remove(web, A)
end
ITvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   if id then
      local clause = "id = "..id
      local tables = "itvision_app_tree"
      Model.delete (tables, clause) 
   end

   return web:redirect(web:link("/list"))
end
ITvision:dispatch_get(delete, "/delete/(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")



-- views ------------------------------------------------------------

function render_table(web, t)
   local res = {}
   res[#res + 1] = p{ table.dump(t) }
   return render_layout(res)
end


function render_list(web, A)
   local rows = {}
   local res = {}
   
--[[
   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ br(), br() }
]]

   for i, v in ipairs(A) do
      rows[#rows + 1] = tr{ class='tab_bg_1',
         td{ a{ href= web:link("/show/"..v.app_id), v.name} },
         td{ strings.sonof },
         td{ a{ href= web:link("/show/"..v.papp_id), v.pname} },
         td{ button_link(strings.remove, web:link("/remove/"..v.id), "negative") },
         td{ button_link(strings.edit, web:link("/edit/"..v.id)) },
      }
   end

   res[#res + 1] = render_content_header("Árvore de Applicação", web:link("/add"), web:link("/list"))
   res[#res + 1]  = H("table") { border="0", class="tab_cadrehov",
      thead{ 
         tr{ class="tab_bg_2",
             th{ strings.name }, 
             th{ "." },
             th{ strings.parent }, 
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

--[[
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
]]


function render_add(web, A, edit, err)
   local res = {}
   local B = {}
   local s = ""
   local val1, val2, mess, url

   if err == 0 then mess = error_message(5) else mess = "" end

   if edit then
      edit = edit[1]
      val1 = edit.name
      val2 = edit.id
      url = "/update/"..val2
   else
      url = "/insert"
   end

   local r = { name=strings.root, id=0 }
   for i, v in ipairs(A) do
      table.insert(B, v)
   end
   table.insert(B, r)

   -- LISTA DE OPERACOES 
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link(url),

      strings.name..": ", select_option("app_id", A, "id", "name", val2), mess, br(),
      strings.child_of..": ", select_option("parent", B, "id", "name", val2), br(),

      p{ button_form(strings.send, "submit", "positive") },
      p{ button_form(strings.reset, "reset", "negative") },
   }

   return render_layout(res)
end


function render_remove(web, A)
   local res = {}

   if A then
      A = A[1]
      url_ok = web:link("/delete/"..A.id)
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


orbit.htmlify(ITvision, "render_.+")

return _M


