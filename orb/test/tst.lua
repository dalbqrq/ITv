#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "View"
require "Model"
module(Model.name, package.seeall,orbit.new)

local comp = Model.glpi:model "computers"

-- models ------------------------------------------------------------


--[[
function comp:select_comps()
   local q = {}
   local q1 = query_1()
   local q2 = query_2()
   local q3 = query_3()
   local q4 = query_4()

   for _,v in ipairs(q1) do table.insert(q, v) end
   for _,v in ipairs(q2) do table.insert(q, v) end
   for _,v in ipairs(q3) do table.insert(q, v) end
   for _,v in ipairs(q4) do table.insert(q, v) end

   return q
end
]]

-- controllers ------------------------------------------------------------

function list(web)
   local comps = Model.select_monitors()
   return render_list(web, comps)
end
ITvision:dispatch_get(list, "/")


-- views ------------------------------------------------------------

function render_list(web, c)
   html = {}
   html[#html +1]  = { p{ "TST" } } 

   html[#html +1]  = { p{ "c_name | ", "n_ip | ", "s_name | ", "sv_name | ", "o_name1 | ", "o_name2 | ", "hst_display_name | ", "svc_display_name" } }
   for i, v in ipairs(c) do
      html[#html +1]  = { p{ v.c_name, v.n_ip, v.s_name, v.sv_name, v.o_name1, v.o_name2, v.hst_display_name, v.svc_display_name } }
   end
   
   html[#html +1]  = { br(), br() } 

   local t = {
      { "Q", "B", "C" },
      { "g", "i", "z" },
      { "e", "p", "a" },
      { "j", "b", "q<br>t<br>g" },
   }

   html[#html +1]  = render_table(t, {"COL", "COL 2", "CAMPO"})

   return render_layout(html)
end


orbit.htmlify(ITvision, "render_.+")

return _M

