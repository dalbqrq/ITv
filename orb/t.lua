local m = require "model_access"
local r = require "model_rules"

local t = {}

function test_select1()
--[[
	print ("----- HOSTS -----")
	t = r.select_hosts ()
	for i, v in ipairs (t) do
		print ("->",v.host_id, v.alias )
	end

	print ("----- ALL SERVICES -----")
	t = m.select ("nagios_services", "service_id > 0", "order by service_id DESC", 
			"service_id, display_name, config_type")
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
]]

	print ("\n\n----- HOSTS OBJECTS-----")
	t = r.select_hosts_objects ()
	for i, v in ipairs (t) do
		print ("->",v.host_id, v.alias, v.object_id )
	end
	

	print ("-\n\n---- SERVICES OBJECTS-----")
	t = r.select_service_objects ()
	for i, v in ipairs (t) do
		print ("->",v.service_id, v.display_name, v.object_id )
	end
	
	
	print ("-\n\n---- APPS OBJECTS -----")
	t = r.select_service_app_objects ()
	for i, v in ipairs (t) do
		print ("->",v.service_id, v.display_name, v.object_id )
	end
end


function init_config () --  inicia tabela itvision_config
	local content = m.select ("itvision_config", nil, nil, "config_id")

	if content[1] == nil then
		content = {}
		content.instance_id = config.db.instance_id 
		content.created = "now()"
		content.updated = "now()"
		content.version = "0.9"
		content.home_dir  = "/usr/local/itvision"

		m.insert("itvision_config", content)
		return true
	else
		return false
	end
end


function init_app_tree() --  inicia tabela itvision_app_tree com app da propria maquina do itvision
	app1 = {}
	app2 = {}
	app_lst = {}

	-- aplicacao de controle do proprio ITvision local
	t = {}
	t.name = "ITvision"
	t.type = "and"
	app1 = r.insert_app(t)

	print("app_id = "..app1[1].app_id)

	-- IM (itens de monitoracao) da app ITvision
	t = {}
	t.app_id = app1[1].app_id
	t.object_id = 42
	t.type = 'hst'
	app_lst = r.insert_app_list(t)

	t = {}
	t.app_id = app1[1].app_id
	t.object_id = 46
	t.type = 'svc'
	app_lst = r.insert_app_list(t)

	t = {}
	t.app_id = app1[1].app_id
	t.object_id = 47
	t.type = 'svc'
	app_lst = r.insert_app_list(t)

	t = {}
	t.app_id = app1[1].app_id
	t.object_id = 49
	t.type = 'svc'
	app_lst = r.insert_app_list(t)

	-- Deve-se criar a config do servico "bp" da aplicacao "ITvision" e recuperar 
	-- o object_id desta para a inclusao da mesma na tabela itvision_app_list da
	-- aplicacao da INSTSTANCIA que serah criada abaixo

	-- aplicacao raiz do instancia
	t = {}
	ins = m.select("nagios_instances", "instance_id = "..config.db.instance_id)
	t.name = ins[1].instance_name
	t.type = "and"
	app2 = r.insert_app(t)

	-- o primeiro IM da aplicacao raiz eh a aplicacao ITvision
	t = {}
	t.app_id = app2[1].app_id
	t.object_id = 53 -- TODO: Este numero deve ser o do bp criado acima!!!!!
	t.type = 'and'
	app_lst = r.insert_app_list(t)


	-- inclui aplicacao raiz na arvore que ainda deve estar vazia
	tree = {}
	tree.app_id = app2[1].app_id
	res, msg = r.insert_node_app_tree(tree)

	-- agora, inclui a app ITvision abaixo da raiz
	root = r.select_root_app_tree()
	tree = {}
	tree.app_id = app1[1].app_id
	res, msg = r.insert_node_app_tree(tree, root.app_tree_id, 1)

	

end

print("\n\n--------------------------------------------------------\n\n")

init_app_tree()

print("\n\n--------------------------------------------------------\n\n")

--test_select1()


--[[
t = {}
t.app_id = 13
r.insert_node_app_tree (t) -- TODO: testar quando arvore jah existe!!!
]]



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


