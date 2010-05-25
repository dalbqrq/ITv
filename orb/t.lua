require "model_app_tree"
require "model_config"
require "model_app"
require "model_hosts"
require "model_services"

t = table_app_tree()

print(t.service_id)

init_app_tree()

t = select_full_path_app_tree("0")

for i, v in ipairs(t) do
        print (v)
end

print("----- HOSTS -----")

t = select_hosts()
for i, v in ipairs(t) do
	print("->",v.host_id, v.alias )
end

print("----- SERVICES -----")

t = select_services()
for i, v in ipairs(t) do
	print("->",v.service_id, v.display_name )
end

print("----- APPS -----")

t = select_apps()
for i, v in ipairs(t) do
	print("->",v.service_id, v.display_name )
end



