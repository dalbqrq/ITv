#!/usr/bin/env wsapi.cgi

require "gv"
local filename

if arg.n == 1 then 
   filename = arg.v[1]
--else
--   filename = "../../html/gv/gr.png"
end

local content = create_graph_content()
create_graph_file(content, filename)


