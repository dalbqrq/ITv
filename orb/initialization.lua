#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "view_utils"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------

function remove_all_apps()

   Model.delete("itvision_app_object")
   Model.delete("itvision_app_relat")
   Model.delete("itvision_app")
   Model.delete("itvision_app_tree")
   Model.delete("itvision_app_relat_type")
   Model.delete("itvision_sysconfig")
   return true
end




-- controllers ------------------------------------------------------------

function list(web)
   return render_list(web)
end
ITvision:dispatch_get(list, "/", "/list")


function remove(web)
   return render_remove(web)
end 
ITvision:dispatch_get(remove, "/remove")


function delete(web)
   remove_all_apps()
   init_config ()
   init_app_relat_type ()
   init_app_tree()
   return web:redirect(web:link("/list"))
end 
ITvision:dispatch_get(delete, "/delete")

ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- INICIALIZACOES ---------------

function init_config () --  inicia tabela itvision_config
   local content = Model.query ("itvision_sysconfig", nil, nil, "sysconfig_id")

   if content[1] == nil then
      content = {}
      content.instance_id = Model.db.instance_id 
      content.created = "now()"
      content.updated = "now()"
      content.version = "0.9"
      content.home_dir  = "/usr/local/itvision"
      content.monitor_dir  = "/usr/local/monitor"
      content.monitor_bp_dir  = "/usr/local/monitorbp"

      Model.insert("itvision_sysconfig", content)
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
      t.type = "physical"
      Model.insert ("itvision_app_relat_type", t)
      t.name = "conectado a"
      t.type = "physical"
      Model.insert ("itvision_app_relat_type", t)
      t.name = "usa"
      t.type = "logical"
      Model.insert ("itvision_app_relat_type", t)
      t.name = "faz backup em"
      t.type = "logical"
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
   t.instance_id = Model.db.instance_id
   t.type = "and"
   app1 = Model.insert_app(t)


   -- IM (itens de monitoracao) da app ITvisiono   
   -- localhost
   hst = Model.select_host_object("alias = 'localhost'")
   t = {}
   t.app_id = app1[1].id
   t.object_id = hst[1].host_object_id
   t.type = 'hst'
   t.instance_id = Model.db.instance_id
   app_lst = Model.insert_app_object(t)


   -- servicos SSH, PING e HTTP
   svc = Model.select_service_object("display_name in ( 'SSH', 'PING', 'HTTP') and host_object_id = "..
         hst[1].host_object_id)
   for i, v in ipairs(svc) do
      t = {}
      t.app_id = app1[1].id
      t.object_id = svc[i].service_object_id
      t.type = 'svc'
      t.instance_id = Model.db.instance_id
      app_lst = Model.insert_app_object(t)
   
      -- relacionamentos
      rt = {}
      rt = Model.query ("itvision_app_relat_type", "name = 'roda em'")
      if rt[1] then
         t = {}
         t.app_id = app1[1].id
         t.instance_id = Model.db.instance_id
         t.app_relat_type_id = rt[1].id
         t.from_object_id = svc[i].service_object_id
         t.to_object_id = hst[1].host_object_id
         app_rel = Model.insert_app_relat(t)
      end
   end



   -- Deve-se criar a config do servico "bp" da aplicacao "ITvision" e recuperar 
   -- o object_id desta para a inclusao da mesma na tabela itvision_app_object da
   -- aplicacao da INSTSTANCIA que serah criada abaixo

   -- aplicacao raiz do instancia
   t = {}
   ins = Model.query("nagios_instances", "instance_id = "..Model.db.instance_id)
   t.name = ins[1].instance_name
   t.instance_id = Model.db.instance_id
   t.type = "and"
   app2 = Model.insert_app(t)


   -- o primeiro IM da aplicacao raiz eh a aplicacao ITvision
   app = Model.select_service_app_object("display_name = 'basic_app'")-- TODO: deve ser bp criado acima!
   t = {}
   t.app_id = app2[1].id
   t.instance_id = Model.db.instance_id
   t.object_id = app[1].service_object_id 
   t.type = 'app'
   app_lst = Model.insert_app_object(t)

   -- inclui aplicacao raiz na arvore que ainda deve estar vazia
   tree = {}
   tree.app_id = app2[1].id
   tree.instance_id = Model.db.instance_id
   res, msg = Model.insert_node_app_tree(tree)

   -- agora, inclui a app ITvision abaixo da raiz
   root_id = Model.select_root_app_tree()
   tree = {}
   tree.app_id = app1[1].id
   tree.instance_id = Model.db.instance_id
   res, msg = Model.insert_node_app_tree(tree, root_id, 1)

   return true

end


-- views ------------------------------------------------------------

function render_list(web)
   res = {}

   res[#res + 1] = p{ button_link(strings.remove, web:link("/remove")) }
   res[#res + 1] = p{ br(), br() }

   return render_layout(res)
end

function render_remove(web)

   local res = {}
   local url = ""

   if A then
      A = A[1]
      url_ok = web:link("/delete")
      url_cancel = web:link("/list")
   end

   res[#res + 1] = p{
      "Remove todas as entradas das tabelas app, app_tree, app_relat,  app_object e app_relat_type?",
      p{ button_link(strings.yes, web:link(url_ok)) }
   }
   res[#res + 1] = p{ button_link(strings.cancel, web:link(url_cancel)) }

   return render_layout(res)

end


orbit.htmlify(ITvision, "render_.+")

return _M

