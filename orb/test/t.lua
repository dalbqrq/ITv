require "Model"


function select_c_n()
   local res
   local table_ = " glpi_computers c, glpi_networkports n"
   local cond_  = [[itemtype="Computer" and
      c.id = n.items_id and
      not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id) and
      not exists (select 1 from itvision_monitor m where m.networkports_id = n.id)
      ]]

   return Model.query(table_, cond_)
end

print("\n--ok\n")

local c = select_c_n()

for i, v in ipairs(c) do
   print(v.id, v.name)
end

print("\n--ok\n")


local t = {
   { "Q", "B", "C" },
   { "g", "i", "z" },
   { "e", "p", "a" },
   { "j", "b", "q" },
}

local i, j, v, w

for i,v in ipairs(t) do
   for j,w in ipairs(v) do
      if i == 1 then print("'") end
      print(w)
   end
end
