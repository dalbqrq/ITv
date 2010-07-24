local m = require "model_access"
local r = require "model_rules"

require "initialization"
require "messages"


function test_select1()
   local t = {}

   print ("----- APPS OBJECTS -----")
   t = r.select_full_path_location_tree ()
   for i, v in ipairs (t) do
      print ("->",v.location_tree_id, v.lft, v.rgt, v.name)
   end

end


print("\n--------------------------------------------------------\n")

local l = r.new_location_tree()
l.name = "daniel"..arg[2]
r.insert_node_location_tree(l, arg[1], 1)

print("\n--------------------------------------------------------\n")
test_select1()

