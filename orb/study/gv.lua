
-- VER: http://code.google.com/apis/chart/docs/gallery/graphviz.html
-- e:    http://code.google.com/apis/charttools/docs/choosing.html

local gr = require "graph"


--
-- Convenience
--
local node, edge, subgraph, cluster, digraph, strictdigraph =
   gr.node, gr.edge, gr.subgraph, gr.cluster, gr.digraph, gr.strictdigraph

--
-- print out and open a graphical view of the graph
--
function graph_show(grph)
   --
   -- Show the graph using dotty
   --
   if true then
      local fn = os.tmpname()..".dot"
      grph:write()
      grph:write(fn)
      os.execute("dotty "..fn)
      os.remove(fn)
   end
end


function create_graph_content()
   local content = {}
   local A = "localhost"
   local B = "HTTP"

   table.insert(content, node{A, shape="box",style="filled",height=.1,width=.1,fontsize=20.,
		fontname="Helvetica", label=A, color="green",URL="ics.lp?ickey=01",target="_self"})
   table.insert(content, node{B, shape="ellipse",style="filled",height=.1,width=.1,fontsize=20.,
		fontname="Helvetica", label=B, color="red",URL="ics.lp?ickey=01",target="_self"})
   table.insert(content, edge{B, A, label=""})

   return content
end



function create_graph_file(content, filename)
   filename = filename or "../../html/gv/gv.png"
   local file_type = "png"

   local g = digraph{"G",
   --   comment = "LuaGraph: exam2.lua",
   --   compound = "1",
   --   rankdir = "LR",
      size="6.5,6.5",
      nodesep=0.05,

      unpack(content)
   }
--[[
g:declare{
  graph = {
    rankdir = "LR",
    size = "6.5 6.5",
    nodesep=0.05
  },
  node = {
    shape = "box",
    width = 0,
    height = 0,
    margin = 0.03,
    fontsize = 8,
    fontname = "helvetica"
  },
  edge = {
    arrowsize = 0.4
  }
}
]]

   -- Make the layout using 'dot' (default) engine
   --print("Layout ...")
   g:layout()
   
   -- write graph to stdout
   --print("Write ...")
   --g:write()

   --g:show()
   
   -- Render the graph into postscript format
   --print("Render ...")
   g:render(file_type, filename)
   
   -- Close the graph
   --print("Close ...")
   g:close()
   
end

