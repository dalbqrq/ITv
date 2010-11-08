module("Graph", package.seeall)

require "config"

-- VER: http://code.google.com/apis/chart/docs/gallery/graphviz.html
-- e:    http://code.google.com/apis/charttools/docs/choosing.html

local gr = require "graph"

--
-- Convenience
--
local node, edge, subgraph, cluster, digraph, strictdigraph =
   gr.node, gr.edge, gr.subgraph, gr.cluster, gr.digraph, gr.strictdigraph


function make_content(obj, rel)
   local content = {}

   if obj[1] then
   for _,v in ipairs(obj) do
         local name, shape  = "", ""
         if v.ao_type == 'hst' then
            name = v.name1
            shape = "box"
         elseif v.ao_type == 'svc' then
            name = v.name2
            shape = "ellipse"
         elseif v.ao_type == 'app' then
            name = v.name2
            shape = "hexagon"
         end

         --color = set_color(v.current_state)
         color = "#FF0000"
         url   = "ics.lp"

         table.insert(content, node{name, shape=shape ,style="filled",height=.1,width=.1,fontsize=20.,
                      fontname="Helvetica", label=name, color=color ,URL=url ,target="_self"})
      end
   end

   if rel[1] then
      for _,v in ipairs(rel) do
         local from_name, to_name = "", ""
         if string.find(v.o1_name1, config.monitor.check_app) then
            from_name = v.o1_name2
         elseif v.o1_name2 == config.monitor.check_ping then
            from_name = v.o1_name1
         else
            from_name = v.o1_name1.."-"..v.o1_name2
         end

         if string.find(v.o2_name1, config.monitor.check_app) then
            to_name = v.o2_name2
         elseif v.o2_name2 == config.monitor.check_ping then
            to_name = v.o2_name1
         else
            to_name = v.o2_name1.."-"..v.o2_name2
         end

         table.insert(content, edge{from_name, to_name, label=v.art_name})
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
function render(filename, file_type, engene, content)
   filename =  filename or config.path.gv.."/gv."..file_type
   filename = config.path.itvision.."/"..config.path.html.."/"..filename

   local g = digraph{"G",
      size="6.5,6.5",
      --nodesep=0.05,
      unpack(content)
   }


   g:layout(engene) -- if engene == nil, then use the default 'dot'
   --g:write() -- write graph to stdout
   local fn = os.tmpname()..".dot"
   g:write(fn)
   g:render(file_type, filename) -- Render the graph into postscript format
   g:close() -- Close the graph
   
end

