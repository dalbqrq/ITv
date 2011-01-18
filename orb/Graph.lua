module("Graph", package.seeall)

require "config"
require "state"
require "util"

-- VER: http://code.google.com/apis/chart/docs/gallery/graphviz.html
-- e:    http://code.google.com/apis/charttools/docs/choosing.html

local gr = require "graph"

-- Convenience
local node, edge, subgraph, cluster, digraph, strictdigraph =
      gr.node, gr.edge, gr.subgraph, gr.cluster, gr.digraph, gr.strictdigraph


function set_color(state, obj_type)
   local color
   state = tonumber(state)
-- Hoje, todos os tipos de objetos de uma aplicacao sao representado por um service!
--[[
   if obj_type == 'hst' then
      color = host_alert[state+1].color
   elseif obj_type == 'svc' then
]]
      -- state é nil quando aplicacao uma aplicacao é reativada e ainda nao possui servicestatus
      if state == nil then state = 4 end 
      color = service_alert[state].color
--[[
   elseif obj_type == 'app' then
      color = applic_alert[state+1].color
   end
]]

   return color
end


function make_gv_filename(app_name, file_type)
   filename = string.gsub(string.gsub(app_name,"(%p+)"," "),"(%s+)","_")
   local basepath = config.path.itvision.."/html/gv/"
   local urlpath  = "/gv/"

   local imgfile = basepath..filename.."."..file_type
   local imglink =  urlpath..filename.."."..file_type
   local lnkfile = basepath..filename..".cmapx" -- ".imap"
   local maplink =  urlpath..filename..".cmapx" -- ".imap"
   local dotfile = basepath..filename..".dot"

   return imgfile, imglink, lnkfile, maplink, dotfile
end


function make_content(obj, rel)
   local content = {}
   local use_relat_label = false
   local show_ip = false

   if obj[1] then
      for _,v in ipairs(obj) do

         local name, shape = "", ""
         local hst_name = find_hostname(v.c_alias, v.c_name, v.c_itv_key)

         if v.ao_type == 'hst' then
            label = hst_name
            name  = string.gsub(hst_name, "[%s,%p]", "")
            url   = "/orb/obj_info/"..v.ao_type.."/"..v.o_object_id
            shape = "box"
         elseif v.ao_type == 'svc' then
            label = v.m_name
            name  = string.gsub(hst_name..v.m_name, "[%s,%p]", "")
            url   = "/orb/obj_info/"..v.ao_type.."/"..v.o_object_id
            shape = "ellipse"
         elseif v.ao_type == 'app' then
            label = v.o_name2
            name  = string.gsub(v.o_name2, "[%s,%p]", "")
            url   = "/orb/obj_info/"..v.ao_type.."/"..v.o_object_id
            shape = "invhouse"
            shape = "octagon"
            shape = "triangle"
            shape = "diamond"
            shape = "hexagon"
         end

         color = set_color(v.ss_current_state, v.ao_type)
         table.insert(content, node{name, shape=shape, height=1.2, width=1, fontsize=12., fixedsize=true,
                      fontname="Helvetica", label=label, color="black", fillcolor=color ,URL=url ,target="_self",
                      nodesep=0.05, style="bold,filled,solid", penwidth=2})
      end
   end


   if rel[1] then
      for _,v in ipairs(rel) do
         local from_name, to_name, ic = "", "", nil
         hst_name = ""

         -- FROM -------------------------------
         if v.from_itemtype == "Computer" then
            ic = Model.query("glpi_computers", "id = "..v.from_items_id)
            ic = ic[1]
         elseif v.from_itemtype == "NetworkEquipment" then
            ic = Model.query("glpi_networkequipments", "id = "..v.from_items_id)
            ic = ic[1]
         end

         if string.find(v.o1_name1, config.monitor.check_app) then
            from_name = string.gsub(v.m1_name, "[%s,%p]", "")
         elseif v.o1_name2 == config.monitor.check_host then
            from_name = string.gsub(find_hostname(ic.alias, ic.name, ic.itv_key), "[%s,%p]", "")
         else
            from_name = string.gsub(find_hostname(ic.alias, ic.name, ic.itv_key)..v.m1_name, "[%s,%p]", "")
         end


         -- TO -------------------------------
         if v.to_itemtype == "Computer" then
            ic = Model.query("glpi_computers", "id = "..v.to_items_id)
            ic = ic[1]
         elseif v.to_itemtype == "NetworkEquipment" then
            ic = Model.query("glpi_networkequipments", "id = "..v.to_items_id)
            ic = ic[1]
         end

         if string.find(v.o2_name1, config.monitor.check_app) then
            to_name = string.gsub(v.m2_name, "[%s,%p]", "")
         elseif v.o2_name2 == config.monitor.check_host then
            to_name = string.gsub(find_hostname(ic.alias, ic.name, ic.itv_key), "[%s,%p]", "")
         else
            to_name = string.gsub(find_hostname(ic.alias, ic.name, ic.itv_key)..v.m2_name, "[%s,%p]", "")
         end


         -- RELAT -------------------------------
         if use_relat_label then
            relat_label = v.art_name
         else
            relat_label = ""
         end

         table.insert(content, edge{ from_name, to_name, label=relat_label } )
      end
   end

   return content
end


function make_tree_content(obj, rel)
   local content = {}

   if obj[1] then
      for _,v in ipairs(obj) do
         local label, name, url, shape

         label = v.a_name ..":"..v.a_id
         name  = v.a_id
         url   = "/orb/obj_info/app/"..v.a_service_object_id
         shape = "invhouse"
         shape = "octagon"
         shape = "triangle"
         shape = "diamond"
         shape = "hexagon"

         color = set_color(v.ss_current_state, "app")
         table.insert(content, node{name, shape=shape, height=1.2, width=1, fontsize=12., fixedsize=true,
                      fontname="Helvetica", label=label, color="black", fillcolor=color ,URL=url ,target="_self",
                      nodesep=0.05, style="bold,filled,solid", penwidth=2})
      end
   end


   if rel[1] then
      for _,v in ipairs(rel) do
         -- FROM -------------------------------
         local from_name = tostring(v.parent_id)

         -- TO -------------------------------
         local to_name = tostring(v.child_id)

         -- RELAT -------------------------------
         relat_label = ""

         table.insert(content, edge{ from_name, to_name, label=relat_label } )
      end
   end

   return content
end


--[[
   engene - string que define o método de criacao do grafico.
            pode ter os seguinte valores.

   dot   - directed graph layout. This is the default algorithm.
   neato - undirected graph layout using spring models
   fdp   - undirected graph layout using the spring model
   circo - circular graph layout, where nodes are placed in a circle
   twopi - radial graph layout
   nop, nop2 - undirected graph layout like neato, but assumes the graph has position attributes attached.
]]
function render(app_name, file_type, engene, content)
   local imgfile, imglink, lnkfile, maplink, dotfile = make_gv_filename(app_name, file_type)

   local g = digraph{"G",
      size="10.0,10.0",
      node = { label=app_name, nodesep=.5, style="rounded" },
      --label = "\\n"..app_name,
      unpack(content),
   }

   g:layout(engene) -- if engene == nil, then use the default 'dot'
   g:render(file_type, imgfile) -- Render the graph into image format
   g:render("cmapx", lnkfile) -- Render the graph into image map format
   g:write(dotfile) -- Write the graph in dot 'text' format
   g:close() -- Close the graph
   
end

