local m = require "model_access"
local r = require "model_rules"

require "initialization"
require "messages"


function test_select1()
   local t = {}

--[[
   print ("----- HOSTS -----")
   t = r.select_host ()
   for i, v in ipairs (t) do
      print ("->",v.host_id, v.alias )
   end

   print ("----- ALL SERVICES -----")
   t = m.select ("nagios_services", "service_id > 0", "order by service_id DESC", 
         "service_id, display_name, config_type")
   for i, v in ipairs (t) do
      print ("->",v.service_id, v.display_name )
   end
   
   print ("----- ALL SERVICES 2 -----")
   t = r.select_service ("service_id > 0", "order by service_id DESC", 
         "service_id, display_name, host_object_id")
   for i, v in ipairs (t) do
      print ("->",v.service_id, v.display_name, v.host_object_id )
   end
   
   print ("----- APPS -----")
   t = r.select_app ()
   for i, v in ipairs (t) do
      print ("->",v.app_id, v.name )
   end

   print ("----- SERVICES ONLY -----")
   t = r.select_service ()
   for i, v in ipairs (t) do
      print ("->",v.service_id, v.display_name )
   end
]]
--[[

   print ("----- HOSTS OBJECTS-----")
   t = r.select_host_object (nil, "order by object_id")
   for i, v in ipairs (t) do
      print ("->",v.object_id, v.host_id, v.alias)
   end
   

   print ("----- SERVICES OBJECTS-----")
   t = r.select_service_object ()
   for i, v in ipairs (t) do
      print ("->",v.object_id, v.service_id, v.display_name)
   end
   
   
   print ("----- APPS OBJECTS -----")
   t = r.select_service_app_object ()
   for i, v in ipairs (t) do
      print ("->",v.object_id, v.service_id, v.display_name)
   end
]]
   print ("----- USER_GROUP X APP-----")
   t = m.select ("itvision_user_group ug, itvision_apps ap", "ug.root_app = ap.app_id and ug.user_group_id = 4", "", 
      "ap.name, ap.type, ug.name as ugname" )
   for i, v in ipairs (t) do
      print ("->",v.name, v.type, v.ugname )
   end
   
end

--[[
print("\n--------------------------------------------------------\n")

init_config()
init_app_relat_type()
init_app_tree()
]]
print("\n--------------------------------------------------------\n")

test_select1()

--[[
rt = {}
rt = m.select ("itvision_app_relat_type", "name = 'roda em'")
if rt[1] then
   print("hi", rt[1].app_relat_type_id, rt[1].name)
end
]]


--  imprime toda arvore de apps 
--[[ 
root_id = r.select_root_app_tree()
t = r.select_full_path_app_tree(root_id)
print("FULL APP TREE")
for i, v in ipairs(t) do
        print (v.app_tree_id, v.app_id)
end
]]


print("\n--------------------------------------------------------\n")

print(strings.user_group_name)


--[[
local cont = {}
cont.name = "quatro"
cont.type = "or"
cont.service_id = 33
--m.insert ("itvision_apps", cont)

m.set_instance ()
local t = m.select ("itvision_apps", "type = 'or'")
for i, v in ipairs (t) do
   v.service_id = v.service_id or ""
   print (v.name, v.type, v.service_id)
end

cont = {}
cont.service_id = 30
cont.type = "and"
cont.is_active = "1"
--m.update ("itvision_apps", cont, "name like '%app'")
]]


