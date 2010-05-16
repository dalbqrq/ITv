local m = require "model_access"
local r = require "model_rules"

local t = {}

function test_select1()
	print ("----- HOSTS -----")
	t = m.select ("nagios_hosts")
	for i, v in ipairs (t) do
		print ("->",v.host_id, v.alias )
	end
	
	print ("----- ALL SERVICES -----")
	t = m.select ("nagios_services")
	for i, v in ipairs (t) do
		print ("->",v.service_id, v.display_name )
	end
	
	print ("----- APPS -----")
	t = r.select_apps ()
	for i, v in ipairs (t) do
		print ("->",v.service_id, v.display_name )
	end
	
	print ("----- SERVICES ONLY -----")
	t = r.select_services ()
	for i, v in ipairs (t) do
		print ("->",v.service_id, v.display_name )
	end
	
	print ("----- APPS OBJECTS -----")
	t = r.select_all_app_objects ()
	for i, v in ipairs (t) do
		print ("->",v.service_id, v.display_name, v.object_id )
	end
end

r.init_app_tree ()

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


