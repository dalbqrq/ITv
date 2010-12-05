module("Graph", package.seeall)

require "config"
require "state"

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
   local use_relat_label = true
   local show_ip = false

   if obj[1] then
   for _,v in ipairs(obj) do
         local name, shape  = "", ""
         if v.ao_type == 'hst' then
            name = v.name1
            if not show_ip then name = string.gsub(name,"-(.+)", "") end
            label = v.name1  
-- DEBUG ..":"..v.curr_state
            url   = "/orb/obj_info/"..v.ao_type.."/"..v.obj_id
            shape = "box"
         elseif v.ao_type == 'svc' then
            name = v.name1.."-"..v.name2
            label = v.name2  
-- DEBUG ..":"..v.curr_state
            url   = "/orb/obj_info/"..v.ao_type.."/"..v.obj_id
            shape = "ellipse"
         elseif v.ao_type == 'app' then
            name = v.name2
            label = v.name2  
--DEBUG ..":"..v.curr_state
            url   = "/orb/obj_info/"..v.ao_type.."/"..v.obj_id
            shape = "hexagon"
            shape = "invhouse"
            shape = "octagon"
            shape = "triangle"
            shape = "diamond"
         end

--[[ TODO: 5

select app_id, a.name as a_name, ao.type as ao_type, o.name1, o.name2, ss.current_state as curr_state
from itvision_apps a, itvision_app_objects ao, nagios_services s, nagios_objects o, nagios_servicestatus ss,
     itvision_monitors m, glpi_networkports n, glpi_computers c
where a.id = ao.app_id and ao.object_id = s.service_object_id and 
s.service_object_id = o.object_id and s.service_object_id = ss.service_object_id and
a.id = 1 and
m.networkports_id = n.id and
c.id = n.items_id and

]]
         color = set_color(v.curr_state, v.ao_type)

         name = string.gsub(name, "%p", "")

         table.insert(content, node{name, shape=shape, height=0.8, width=1, fontsize=12.,
                      fontname="Helvetica", label=label, color="black", fillcolor=color ,URL=url ,target="_self",
                      nodesep=0.05, style="bold,filled,solid", penwidth=2})
      end
   end

   if rel[1] then
      for _,v in ipairs(rel) do
         local from_name, to_name = "", ""
         if string.find(v.o1_name1, config.monitor.check_app) then
            from_name = v.o1_name2
         elseif v.o1_name2 == config.monitor.check_host then
            from_name = v.o1_name1
            if not show_ip then from_name = string.gsub(from_name,"-(.+)", "") end
         else
            from_name = v.o1_name1.."-"..v.o1_name2
         end

         if string.find(v.o2_name1, config.monitor.check_app) then
            to_name = v.o2_name2
         elseif v.o2_name2 == config.monitor.check_host then
            to_name = v.o2_name1
            if not show_ip then to_name = string.gsub(to_name,"-(.+)", "") end
         else
            to_name = v.o2_name1.."-"..v.o2_name2
         end

         from_name = string.gsub(from_name, "%p", "")
         to_name = string.gsub(to_name, "%p", "")

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
      size="7.0,7.0",
      node = { nodesep=.5, style="rounded" },
      unpack(content)
   }

   g:layout(engene) -- if engene == nil, then use the default 'dot'
   g:render(file_type, imgfile) -- Render the graph into postscript format
   g:render("cmapx", lnkfile) -- Render the graph into image map format
   g:write(dotfile) -- Write the graph in dot 'text' format
   g:close() -- Close the graph
   
end

