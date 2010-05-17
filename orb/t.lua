local m = require "model_access"
local r = require "model_rules"

local t = {}

function test_select1()
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
         "service_id, display_name, , host_object_id")
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

   print ("----- HOSTS OBJECTS-----")
   t = r.select_host_object (nil, "order by object_id")
   for i, v in ipairs (t) do
      print ("->",v.object_id, v.host_id, v.alias)
   end
   

--[[
   print ("----- SERVICES OBJECTS-----")
   t = r.select_service_object ()
   for i, v in ipairs (t) do
      print ("->",v.service_id, v.display_name, v.object_id )
   end
   
   
   print ("----- APPS OBJECTS -----")
   t = r.select_service_app_object ()
   for i, v in ipairs (t) do
      print ("->",v.service_id, v.display_name, v.object_id )
   end
]]
end



----------------------------- INICIALIZACOES ----------------------------------

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


function init_app_relat_type ()
   local t = {}
   local content = m.select ("itvision_app_relat_type")

   if content[1] == nil then
      t.name = "roda em"
      m.insert ("itvision_app_relat_type", t)
      t.name = "conectado a"
      m.insert ("itvision_app_relat_type", t)
      t.name = "faz backup em"
      m.insert ("itvision_app_relat_type", t)
   end

end


function init_app_tree() --  inicia tabela itvision_app_tree com app da propria maquina do itvision
   local app1 = {}
   local app2 = {}
   local app_lst = {}
   local t = {}
   local rt = {}
   

   -- se jah existe arvore, sai
   root_id, root = r.select_root_app_tree()
   if root_id then return false end
   --print('creating new root', root_id)


   -- aplicacao de controle do proprio ITvision local
   t = {}
   t.name = "ITvision"
   t.type = "and"
   app1 = r.insert_app(t)


   -- IM (itens de monitoracao) da app ITvisiono   
   -- localhost
   hst = r.select_host_object("alias = 'localhost'")
   t = {}
   t.app_id = app1[1].app_id
   t.object_id = hst[1].host_object_id
   t.type = 'hst'
   app_lst = r.insert_app_list(t)


   -- servicos SSH, PING e HTTP
   svc = r.select_service_object("display_name in ( 'SSH', 'PING', 'HTTP') and host_object_id = "..
         hst[1].host_object_id)
   for i, v in ipairs(svc) do
      t = {}
      t.app_id = app1[1].app_id
      t.object_id = svc[i].service_object_id
      t.type = 'svc'
      app_lst = r.insert_app_list(t)
   
      -- relacionamentos
      rt = {}
      rt = m.select ("itvision_app_relat_type", "name = 'roda em'")
      if rt[1] then
         t = {}
         t.app_id = app1[1].app_id
         t.from_object_id = svc[i].service_object_id
         t.to_object_id = hst[1].host_object_id
         t.connection_type = 'physical'
         t.app_relat_type_id = rt[1].app_relat_type_id
         app_rel = r.insert_app_relat(t)
      end
   end



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
   app = r.select_service_app_object("display_name = 'basic_app'")-- TODO: deve ser bp criado acima!
   t = {}
   t.app_id = app2[1].app_id
   t.object_id = app[1].service_object_id 
   t.type = 'and'
   app_lst = r.insert_app_list(t)

   -- inclui aplicacao raiz na arvore que ainda deve estar vazia
   tree = {}
   tree.app_id = app2[1].app_id
   res, msg = r.insert_node_app_tree(tree)

   -- agora, inclui a app ITvision abaixo da raiz
   root_id = r.select_root_app_tree()
   tree = {}
   tree.app_id = app1[1].app_id
   res, msg = r.insert_node_app_tree(tree, root_id, 1)

   return true

end


print("\n--------------------------------------------------------\n")

test_select1()
init_config()
init_app_relat_type()
init_app_tree()

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


