require "Model"
require "App"

--show_app_tree()
local c = find_node_id(25)

for i,v in pairs(c) do
   print(i,v.id)
end


