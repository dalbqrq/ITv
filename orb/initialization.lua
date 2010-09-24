
require "Model"


----------------------------- INICIALIZACOES ----------------------------------

function init_config () --  inicia tabela itvision_config
   local content = Model.query ("itvision_config", nil, nil, "config_id")

   if content[1] == nil then
      content = {}
      content.instance_id = config.db.instance_id 
      content.created = "now()"
      content.updated = "now()"
      content.version = "0.9"
      content.home_dir  = "/usr/local/itvision"

      Model.insert("itvision_config", content)
      return true
   else
      return false
   end
end


function init_app_relat_type ()
   local t = {}
   local content = Model.query ("itvision_app_relat_type")

   if content[1] == nil then
      t.name = "roda em"
      Model.insert ("itvision_app_relat_type", t)
      t.name = "conectado a"
      Model.insert ("itvision_app_relat_type", t)
      t.name = "faz backup em"
      Model.insert ("itvision_app_relat_type", t)
   end

end


function init_app_tree() --  inicia tabela itvision_app_tree com app da propria maquina do itvision
   local app1 = {}
   local app2 = {}
   local app_lst = {}
   local t = {}
   local rt = {}
   

   -- se jah existe arvore, sai
   root_id, root = Model.select_root_app_tree()
   if root_id then return false end
   --print('creating new root', root_id)


   -- aplicacao de controle do proprio ITvision local
   t = {}
   t.name = "ITvision"
   t.type = "and"
   app1 = Model.insert_app(t)


   -- IM (itens de monitoracao) da app ITvisiono   
   -- localhost
   hst = Model.select_host_object("alias = 'localhost'")
   t = {}
   t.app_id = app1[1].app_id
   t.object_id = hst[1].host_object_id
   t.type = 'hst'
   app_lst = Model.insert_app_list(t)


   -- servicos SSH, PING e HTTP
   svc = Model.select_service_object("display_name in ( 'SSH', 'PING', 'HTTP') and host_object_id = "..
         hst[1].host_object_id)
   for i, v in ipairs(svc) do
      t = {}
      t.app_id = app1[1].app_id
      t.object_id = svc[i].service_object_id
      t.type = 'svc'
      app_lst = Model.insert_app_list(t)
   
      -- relacionamentos
      rt = {}
      rt = Model.query ("itvision_app_relat_type", "name = 'roda em'")
      if rt[1] then
         t = {}
         t.app_id = app1[1].app_id
         t.from_object_id = svc[i].service_object_id
         t.to_object_id = hst[1].host_object_id
         t.connection_type = 'physical'
         t.app_relat_type_id = rt[1].app_relat_type_id
         app_rel = Model.insert_app_relat(t)
      end
   end



   -- Deve-se criar a config do servico "bp" da aplicacao "ITvision" e recuperar 
   -- o object_id desta para a inclusao da mesma na tabela itvision_app_list da
   -- aplicacao da INSTSTANCIA que serah criada abaixo

   -- aplicacao raiz do instancia
   t = {}
   ins = Model.query("nagios_instances", "instance_id = "..config.db.instance_id)
   t.name = ins[1].instance_name
   t.type = "and"
   app2 = Model.insert_app(t)


   -- o primeiro IM da aplicacao raiz eh a aplicacao ITvision
   app = Model.select_service_app_object("display_name = 'basic_app'")-- TODO: deve ser bp criado acima!
   t = {}
   t.app_id = app2[1].app_id
   t.object_id = app[1].service_object_id 
   t.type = 'and'
   app_lst = Model.insert_app_list(t)

   -- inclui aplicacao raiz na arvore que ainda deve estar vazia
   tree = {}
   tree.app_id = app2[1].app_id
   res, msg = Model.insert_node_app_tree(tree)

   -- agora, inclui a app ITvision abaixo da raiz
   root_id = Model.select_root_app_tree()
   tree = {}
   tree.app_id = app1[1].app_id
   res, msg = Model.insert_node_app_tree(tree, root_id, 1)

   return true

end


