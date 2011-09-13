#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "Monitor"
require "Auth"
require "View"
require "util"
require "state"

module(Model.name, package.seeall,orbit.new)

local apps = Model.itvision:model "apps"


-- models ------------------------------------------------------------

-- Esta funcao recebe um ou outro parametro, nunca os dois
function apps:select(id, obj_id)
   local clause = ""
   if id then clause = "id = "..id end
   if obj_id then clause = "service_object_id = "..obj_id end
   return Model.query("itvision_apps", clause)
end


-- controllers ------------------------------------------------------------

function show_hst(web, obj_id, active_tab)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end
   active_tab = active_tab or 1

   local A = Monitor.make_query_3(nil, nil, nil, "m.service_object_id = "..obj_id)

--[[ TODO; coloca aba com o CMDB. Devo fazer isso?
   local url
   web.prefix = "/servdesk"
   if itemtype == "Computer" then
      url = web:link("/front/computer.form.php?id="..c_id)
   else --if itemtype == "NetworkEquipment" then
      url = web:link("/front/computer.form.php?id=78")
      --url = web:link("/front/networkequipment.form.php?id="..c_id)
   end
]]

   local t = { 
      { title="Host", html="", href="/orb/hst_info/1:"..obj_id },
      { title="Histórico", html="", href="/orb/hst_info/2:"..obj_id },
      -- Sera? { title="CMDB", html="", href="/orb/hst_info/3:"..obj_id },
      -- Sera? { title="CMDB2", html="", href=url },
      { title="Raw Data", html="", href="/orb/hst_info/4:"..obj_id },
   }

   local res = {}
   res[#res+1] = render_content_header(auth.session.glpiactive_entity_shortname, A[1].c_name, nil, nil)
   res[#res+1] = render_tabs(t, active_tab)

   return render_layout(res)

end
ITvision:dispatch_get(show_hst, "/hst/(%d+)")


function show_svc(web, obj_id)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end
   active_tab = active_tab or 1

   local A = Monitor.make_query_4(nil, nil, nil, "m.service_object_id = "..obj_id)

   local t = { 
      { title="Host", html="", href="/orb/hst_info/1:"..obj_id },
      { title="Serviço", html="", href="/orb/svc_info/1:"..obj_id },
      { title="Histórico", html="", href="/orb/svc_info/2:"..obj_id },
      { title="Raw Data", html="", href="/orb/svc_info/3:"..obj_id },
   }

   local res = {}
   res[#res+1] = render_content_header(auth.session.glpiactive_entity_shortname, A[1].c_name.."::"..A[1].m_name, nil, nil)
   res[#res+1] = render_tabs(t, active_tab)

   return render_layout(res)

end
ITvision:dispatch_get(show_svc, "/svc/(%d+)")


function show_app(web, obj_id)
   local auth = Auth.check(web)
   local permission = Auth.check_permission(web, "application")

   if not auth then return Auth.redirect(web) end

   local A = apps:select(nil, obj_id)

   web.prefix = "/orb/gviz"
   return web:redirect(web:link("/show/"..A[1].id))
end
ITvision:dispatch_get(show_app, "/app/(%d+)")


-- esta funcao deverah servir para colocar o mapa em um ou mais iframes para 
--  que ele nao ocupe toda a tela
function map_frame(web, objtype, obj_id)
   return render_map_frame(web, objtype, obj_id)
end
ITvision:dispatch_get(map_frame, "/map_frame/(%a+):(%d+)")


function geotag(web, objtype, obj_id)
   local q, A, B, app = {}, {}, {}, {}
   if objtype == "app" then
      app = apps:select(nil, obj_id) 
      A = Monitor.tree(app[1].id)
   elseif objtype == "hst" then
      A = Monitor.make_query_3(nil, nil, nil, "m.service_object_id = "..obj_id)
   end

   return render_geotag(web, objtype, obj_id, A)
end
ITvision:dispatch_get(geotag, "/geotag/(%a+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------



function render_geotag(web, objtype, obj_id, A)
   -- Este render deverá ficar aberto para o funcionamento do google map sem licenca
   --local permission = Auth.check_permission(web, "application")
   local res = {obj_id, objtype}
   local geotag, latlon = "", ""
   local marker_maker, position = "", ""
   local minlat, maxlat, minlon, maxlon  = 1000, -1000, 1000, -1000

   for i, v in ipairs(A) do
      if v.c_geotag then
         local lat, lon = string.extract_latlon(v.c_geotag)
         lat, lon = tonumber(lat), tonumber(lon)

         position = position .. "<!-- "..v.c_geotag.." -->\n"
         if type(lat) == "number" and type(lon) == "number" then
            if lat < minlat then minlat = lat end
            if lon < minlon then minlon = lon end
            if lat > maxlat then maxlat = lat end
            if lon > maxlon then maxlon = lon end
         end
      end
   end

   position = position .. "var southWest = new google.maps.LatLng("..tostring(minlat)..","..tostring(minlon)..");\n"
   position = position .. "var northEast = new google.maps.LatLng("..tostring(maxlat)..","..tostring(maxlon)..");\n"
   position = position .. "var bounds = new google.maps.LatLngBounds(southWest,northEast);\n"
   position = position .. "map.fitBounds(bounds);\n\n"

   marker_maker = marker_maker .. position

   for i, v in ipairs(A) do
      if v.ss_current_state then
         if v.c_geotag == nil then geotag = v.n_geotag else geotag = v.c_geotag end
         geotag = geotag or ""

         -- tratar corretamente (converter) geotab no formato:  22°51'33.20"S,43°23'17.42"O
         -- agora simplesmente eliminaremos estas entradas.
         -- procurar expressao como esta em util.lua:string.extract_latlon()
         if string.find(geotag, "°") then geotag = "" end
         if string.find(geotag, "'") then geotag = "" end


         res[#res+1] = " | "..geotag.." | "
         local icon = service_alert[tonumber(v.ss_current_state)].color_name

         marker_maker = marker_maker .. "var location"..i.." = new google.maps.LatLng("..geotag..");\n"
         marker_maker = marker_maker .. "var marker"..i.." = new google.maps.Marker({ position: location"..i..", map: map, icon: "..icon.." });\n"
         marker_maker = marker_maker .. "//marker"..i..".setTitle(\"VERTO\");\n"
         marker_maker = marker_maker .. "var infowindow"..i.." = new google.maps.InfoWindow( \n"
         --marker_maker = marker_maker .. "{ content: \""..v.c_name.."<br>"..v.p_ip.."<br>Funcionmaneto: "..service_alert[tonumber(v.ss_current_state)].name.."<br><a href='/servdesk/front/"..string.lower(v.p_itemtype)..".form.php?id="..v.c_id.."'>CMDB</a>\", size: new google.maps.Size(50,50) });\n" 
         marker_maker = marker_maker .. "{ content: \""..v.c_name.."<br>"..v.p_ip.."<br>Funcionmaneto: "..service_alert[tonumber(v.ss_current_state)].name.."<br>\", size: new google.maps.Size(50,50) });\n" 
         marker_maker = marker_maker .. "google.maps.event.addListener(marker"..i..", 'click', function() { infowindow"..i..".open(map,marker"..i.."); });\n"
      end
   end

   marker_maker = "function marker_maker() { \n"..marker_maker.."\n}"
   res[#res+1] = " | "..marker_maker.." | "

   --text_file_writer("/tmp/mark", marker_maker )

   return render_map(marker_maker)
end


-- Ver codigo fonte da pagina http://code.google.com/apis/maps/documentation/javascript/basics.html
-- que possui dois mapas lado a lado.
function render_map_frame(web, objtype, obj_id)
   web.prefix = "/orb/obj_info/geotag"
   --render_layout( iframe{ style="width:400px;height:400px", src=web:link("/"..objtype..":"..obj_id) }  )
   return render_layout( iframe{ width="400px", height="400px", src=web:link("/"..objtype..":"..obj_id) }  )
end


orbit.htmlify(ITvision, "render_.+")

return _M


