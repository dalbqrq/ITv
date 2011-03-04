require "Model"
require "App"


local c = select_full_path_app_tree(3)

for i,v in pairs(c) do
   print (v.id, v.app_id, v.lft, v.rgt, v.name)
end
