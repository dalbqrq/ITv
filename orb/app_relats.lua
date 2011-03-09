#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "App"
require "Auth"
require "Monitor"
require "View"
require "util"
require "monitor_util"
require "app"

module(Model.name, package.seeall,orbit.new)

local app_relats = Model.itvision:model "app_relats"
local app_relat_types = Model.itvision:model "app_relat_types"

local tab_id = 3

-- models ------------------------------------------------------------


function app_relats:delete_app_relat(id, from, to)
   local clause = ""
   if id and from and to then
      clause = " app_id = "..id.." and from_object_id = "..from.." and to_object_id = "..to
   elseif id and from and to == nil then
      clause = " app_id = "..id.." and from_object_id = "..from
   elseif id and from == nil and to then
      clause = " app_id = "..id.." and to_object_id = "..to
   end

   Model.delete("itvision_app_relats", clause)
end


function app_relat_types:select_app_relat_types(id)
   local clause = ""
   if id then
      clause = "app_relat_type_id = "..id
   end
   return self:find_all(clause)
end



-- controllers ------------------------------------------------------------


function add(web, id, msg)
   local APPOBJ = App.select_app_app_objects(id)
   local AR = App.select_app_relat_object(id)
   local RT = app_relat_types:select_app_relat_types()

   return render_add(web, APPOBJ, AR, RT, id, msg)

end
ITvision:dispatch_get(add, "/add/", "/add/(%d+)", "/add/(%d+):(.+)")



function insert_relat(web)
   local msg = ""
   local from, to

   app_relats:new()
   app_relats.app_id = web.input.app_id
   app_relats.from_object_id = web.input.from
   app_relats.to_object_id = web.input.to
   app_relats.instance_id = Model.db.instance_id
   app_relats.app_relat_type_id = web.input.relat

   if not ( web.input.from and web.input.to and web.input.relat ) then
      msg = ":"..error_message(7)
      return web:redirect(web:link("/add/"..app_relats.app_id)..msg)
   end

   local AR = App.select_app_relat_object(web.input.app_id, web.input.from, web.input.to)
   if AR[1] then
      local v = AR[1]
      from = make_obj_name(v.from_name1, v.from_name2)
      to   = make_obj_name(v.to_name1,   v.to_name2)
      msg = ":"..error_message(8)
   else
      app_relats:save()
   end

   --return web:redirect(web:link("/add/"..app_relats.app_id)..msg)
   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..app_relats.app_id..":"..tab_id))
end
ITvision:dispatch_post(insert_relat, "/insert_relat")



function delete_relat(web, app_id, from, to)
   app_relats:delete_app_relat(app_id, from, to)
   --return web:redirect(web:link("/add/"..app_id))
   web.prefix = "/orb/app_tabs"
   return web:redirect(web:link("/list/"..app_id..":"..tab_id))
end
ITvision:dispatch_get(delete_relat, "/delete_relat/(%d+):(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function make_app_relat_table(web, AR)
   local row, ic = {}, {}
   local remove_button = ""
   local permission = Auth.check_permission(web, "application")

   web.prefix = "/orb/app_relats"

   for i, v in ipairs(AR) do
      if v.from_itemtype == "Computer" then
         ic = Model.query("glpi_computers", "id = "..v.from_items_id)
         ic = ic[1]
      elseif v.from_itemtype == "NetworkEquipment" then
         ic = Model.query("glpi_networkequipments", "id = "..v.from_items_id)
         ic = ic[1]
      end

      local from
      if v.from_type == "hst" then
         from = find_hostname(ic.alias, ic.name, ic.itv_key).." ("..v.from_ip..")"
      elseif v.from_type == "svc" then
         from = make_obj_name(find_hostname(ic.alias, ic.name, ic.itv_key).." ("..v.from_ip..")", v.from_name)
      else
         from = v.from_name.." #"
      end

      if v.to_itemtype == "Computer" then
         ic = Model.query("glpi_computers", "id = "..v.to_items_id)
         ic = ic[1]
      elseif v.to_itemtype == "NetworkEquipment" then
         ic = Model.query("glpi_networkequipments", "id = "..v.to_items_id)
         ic = ic[1]
      end

      local to
      if v.to_type == "hst" then
         to = find_hostname(ic.alias, ic.name, ic.itv_key).." ("..v.to_ip..")"
      elseif v.to_type == "svc" then
         to = make_obj_name(find_hostname(ic.alias, ic.name, ic.itv_key).." ("..v.to_ip..")", v.to_name)
      else
         to = v.to_name.." #"
      end

      if permission == "w" then
         remove_button = button_link(strings.remove, web:link("/delete_relat/"..v.app_id..":"..v.from_object_id
             ..":"..v.to_object_id), "negative")
      else
         remove_button = "-"
      end

      if v.connection_type == "physical" then contype = strings.physical else contype = strings.logical end

      row[#row+1] = {
         from,
         v.art_name,
         to,
         remove_button
      }
   end

   return row
end




function render_add(web, APPOBJ, AR, RT, app_id, msg)
   local res = {}
   local url_app = "/insert_obj"
   local url_relat = "/insert_relat"
   local list_size = 10
   local header = ""
   local permission = Auth.check_permission(web, "application")

   -----------------------------------------------------------------------
   -- Relacionamentos da aplicacao
   -----------------------------------------------------------------------
   res[#res+1] = show(web, app_id)
   res[#res+1] = br()
   --res[#res+1] = render_content_header(strings.relation)
   header =  { strings.origin, strings.type, strings.destiny, "." }
   res[#res+1] = render_table(make_app_relat_table(web, AR), header)
   res[#res+1] = br()

   if permission == "w" then

      -- LISTA APP ORIGEM DOS RELACIONAMENTO ---------------------------------
      local opt_from = {}
      local obj
      if APPOBJ[1] then
         for i,v in ipairs(APPOBJ) do
            if v.itemtype == "Computer" then
               ic = Model.query("glpi_computers", "id = "..v.items_id)
               ic = ic[1]
            elseif v.itemtype == "NetworkEquipment" then
               ic = Model.query("glpi_networkequipments", "id = "..v.items_id)
               ic = ic[1]
            end

            if v.obj_type == "hst" then
               obj = find_hostname(ic.alias, ic.name, ic.itv_key).." ("..v.ip..")"
            elseif v.obj_type == "svc" then
               obj = make_obj_name(find_hostname(ic.alias, ic.name, ic.itv_key).." ("..v.ip..")", v.name)
            else
               obj = v.name.." #"
            end
            opt_from[#opt_from+1] = option{ value=v.object_id, obj }
         end
      end
      --local from = H("select") { multiple="multiple", size=list_size, name="from", opt_from, }
      local from = H("select") { size=list_size, name="from", opt_from }

      -- LISTA TIPOS DE RELACIONAMENTO  ---------------------------------
      local opt_rel = {}
      for i,v in ipairs(RT) do
        opt_rel[#opt_rel+1] = option{ value=v.id, v.name }
      end
      local rel = H("select") { size=list_size, name="relat", opt_rel }

      -- LISTA APP DESTINO DOS RELACIONAMENTO ---------------------------------
      local opt_to = {}
      if APPOBJ[1] then
         for i,v in ipairs(APPOBJ) do
            if v.itemtype == "Computer" then
               ic = Model.query("glpi_computers", "id = "..v.items_id)
               ic = ic[1]
            elseif v.itemtype == "NetworkEquipment" then
               ic = Model.query("glpi_networkequipments", "id = "..v.items_id)
               ic = ic[1]
            end

            if v.obj_type == "hst" then
               obj = find_hostname(ic.alias, ic.name, ic.itv_key).." ("..v.ip..")"
            elseif v.obj_type == "svc" then
               obj = make_obj_name(find_hostname(ic.alias, ic.name, ic.itv_key).." ("..v.ip..")", v.name)
            else
               obj = v.name.." #"
            end
            opt_to[#opt_to+1] = option{ value=v.object_id, obj }
         end
      end
      local to = H("select") { size=list_size, name="to", opt_to }

      -- INFORMACAO OCULTA PARA A INCLUSAO DO RELACIONAMENTO  --------------------
      aid = input{ type="hidden", name="app_id", value=app_id }

      local t = { { from, rel, {to, aid} } }

      if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ font{ color="red", msg } }  end

      header =  { strings.origin, strings.type, strings.destiny }
      --res[#res+1] = render_form_bar( render_table(t, header) , strings.add, web:link(url_relat), web:link("/add/"..app_id))
      res[#res+1] = render_form( web:link(url_relat), web:link("/add/"..app_id), render_table(t, header), true, strings.add )
   end

   return render_layout(res)
end





orbit.htmlify(ITvision, "render_.+")

return _M


