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

local ci = itvision:model "ci"

function ci:select_ci(id)
   local clause = ""
   if id then
      clause = "ci_id = "..id
   end
   return self:find_all(clause)
end

-- controllers ------------------------------------------------------------

function list(web)
   local A = ci:select_ci()
   return render_list(web, A)
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


function add(web, err)
   return render_add(web, nil, err)
end
itvision:dispatch_get(add, "/add", "/add/(%d+)")


function insert(web)
   local origin
   --ci:new()
   ci = mr.new_ci()
   if web.input.name then
      ci.name = web.input.name
   else
      return web:redirect(web:link("/add/0"))
   end
   ci.geotag = web.input.geotag
   ci.obs = web.input.obs

   if tonumber(web.input.parent) > 0 then origin = web.input.parent end
   mr.insert_node_ci(ci, origin, 1)

   return web:redirect(web:link("/list"))
   --return render_table(web, ci)
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


function render_list(web, A)
   local rows = {}
   local res = {}
   
   res[#res + 1] = p{ button_link(strings.add, web:link("/add")) }
   res[#res + 1] = p{ br(), br() }

   for i, v in ipairs(A) do
      rows[#rows + 1] = tr{ 
         td{ a{ href= web:link("/show/"..v.ci_id), v.name} },
         td{ a{ href= web:link("/map/"..v.geotag), v.geotag} },
         td{ v.obs },
         td{ button_link(strings.remove, web:link("/remove/"..v.ci_id), "negative") },
         td{ button_link(strings.edit, web:link("/edit/"..v.ci_id)) },
      }
   end

   res[#res + 1]  = H("table") { border=1, cellpadding=1,
      thead{ 
         tr{ 
             th{ strings.name }, 
             th{ "Geotab" },
             th{ "Obs" },
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

function render_map(web, lat, lon)

    s = [[
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=ISO-8859-1">
<title>Exemplo de Google Maps API</title>
<script src="http://maps.google.com/maps?file=api&v=2&key=#SUA CHAVE GOOGLE MAPS#" type="text/javascript"></script>
<script type="text/javascript">
   //<![CDATA[
   
   //função para carregar um mapa de Google. 
   //Esta função é chamada quando a página termina de carregar. Evento onload
   function load() {
      //comprovamos se o navegador é compatível com os mapas de google
      if (GBrowserIsCompatible()) {
         //instanciamos um mapa com GMap, passando-lhe uma referência à camada ou <div> onde quisermos mostrar o mapa
         var map = new GMap2(document.getElementById("map"));   
         //centralizamos o mapa em uma latitude e longitude desejadas
         map.setCenter(new GLatLng(]]..lat..[[,]]..lon..[[), 18);   
         //adicionamos controles ao mapa, para interação com o usuário
         map.setMapType(G_SATELLITE_MAP)
         map.addControl(new GLargeMapControl());
         map.addControl(new GMapTypeControl()); 
         //daniel  map.addControl(new GOverviewMapControl()); ;
      }
   }
   
   //] ]>
   </script>
</head>
<body onload="load()" onunload="GUnload()">
<div id="map" style="width: 615px; height: 400px"></div>
</body>
</html>
]]

    return s
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


function render_add(web, edit, err)
   local res = {}
   local s = ""
   local val1, val2, val3, val4, mess, url

   if err == 0 then mess = error_message(4) else mess = "" end

   if edit then
      edit = edit[1]
      val1 = edit.name
      val2 = edit.geotag
      val3 = edit.obs
      val4 = edit.ci_id
      url = "/update/"..val4
   else
      url = "/insert"
   end

   local t = ci:find_all()
   local r = { name=strings.root, ci_id=0, obs = nil, geotag=nil}
   table.insert(t, r)

   -- LISTA DE OPERACOES 
   res[#res + 1] = p{ button_link(strings.list, web:link("/list")) }
   res[#res + 1] = p{ br(), br() }

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link(url),

      strings.name..": ", input{ type="text", name="name", value = val1 }, mess, br(),
      "Geotag: ", input{ type="text", name="geotag", value = val2 }, br(),
      "Obs: ", input{ type="text", name="obs", value = val3 }, br(),
      strings.child_of..": ", select_option("parent", t, "ci_id", "name", val4), br(),

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


