require "Model"
require "App"


local c = select_full_path_app_tree(3)

for i,v in pairs(c) do
   print (v.id, v.app_id, v.lft, v.rgt, v.name)
end

print("\n=========================================\n")
local root_id, root = select_root_app_tree()
print (root_id, root.app_id)

print("\n=========================================\n")
local s = select_subordinates_app_tree(nil, 48)
for i,v in pairs(s) do
   print (v.id, v.app_id, v.lft, v.rgt )
end
