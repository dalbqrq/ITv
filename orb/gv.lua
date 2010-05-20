
-- VER: http://code.google.com/apis/chart/docs/gallery/graphviz.html
-- e:   http://code.google.com/apis/charttools/docs/choosing.html

gr = require "graph"

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


local content = {}

table.insert(content, node{"A", shape="box",style="filled",height=.1,width=.1,fontsize=20.,
		fontname="Helvetica", label="A", color="green",URL="ics.lp?ickey=01",target="_self"})
table.insert(content, node{"B", shape="ellipse",style="filled",height=.1,width=.1,fontsize=20.,
		fontname="Helvetica", label="B", color="red",URL="ics.lp?ickey=01",target="_self"})
table.insert(content, edge{"A", "B", label=""})



local g = digraph{"G",
--  comment = "LuaGraph: exam2.lua",
--  compound = "1",
--  rankdir = "LR",
  size="6.5,6.5",

  unpack(content)
}



-- Make the layout using 'dot' (default) engine
print("Layout ...")
g:layout()

-- write graph to stdout
print("Write ...")
g:write()

-- Render the graph into postscript format
print("Render ...")
g:render("png", "../html/gv.png")

-- Close the graph
print("Close ...")
g:close()


