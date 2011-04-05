--[[ 

Este código deve ser executado por um serviço cron para sincronizaçao entre o glpi e o itvision.

Processa arquivo update_entity.queue criado através do "[glpi/servdesk]/front/dropdown.common.form.php
que cria entradas a cada operacao executada com as entidades (através da tela de manipulacao de entidades
do glpi). 

As operacoes são:

add - ao adicionar uma entidade, cria-se uma aplicacoes para ela e a insere na arvore de aplicacoes.
delete - ao se remover uma entidade, remove-se a aplicacoes e a retira da árvore de aplicacoes.
update - altera-se o nome da respectiva aplicacao e, caso necessário, a reposiciona na arvore.
replace - reposiciona a aplicacao na árvore de aplicacoes.


]]
require "Model"
require "App"
require "monitor_util"
require "util"


local entityfile = "/usr/local/itvision/scr/update_entity.queue"

function add_entity(id)
   --print("add: "..id)
   local entity = Model.query("glpi_entities e", "e.id = "..id)
   local parent_app = Model.query("itvision_apps a, glpi_entities e", 
               "e.id = "..id.." and e.entities_id = a.entities_id and is_entity_root = true", nil, "a.id as app_id")

   new_app = {
      instance_id  = config.database.instance_id,
      entities_id  = id,
      is_entity_root = 1,
      name         = entity[1].name,
      type         = "and",
      is_active    = 0,
      visibility   = 0,
      app_type_id  = 1,   -- leva em conta que a inicializacao da tabela itvision_app_type colocou o tipo entidade com id=1
   }
   Model.insert("itvision_apps", new_app)

   local child_app = Model.query("itvision_apps a", "entities_id = "..id.." and a.is_entity_root = true")
   local parent_node = Model.query("itvision_apps a, itvision_app_trees t", 
            "a.id = t.app_id and a.is_entity_root = true and a.id = "..parent_app[1].app_id, nil, "t.id as origin")

   App.insert_node_app_tree(child_app[1].id, id, parent_node[1].origin, 1)
end


function delete_entity(id)
   --print("delete: "..id)
   local node = Model.query("itvision_app_trees t, itvision_apps a" , 
            "a.id = t.app_id and a.is_entity_root = true and a.entities_id = ".. id,
            nil, "t.id as origin")

   if node[1] then
     --print(node[1].origin)
     App.delete_node_app(node[1].origin)
   end
   Model.delete("itvision_apps", "entities_id = ".. id)

   local APPS = App.select_uniq_app_in_tree()
   make_all_apps_config(APPS)
end


function replace_entity(id, id2)
   print("replace: "..id.." to "..id2)
-- CONTINUAR AQUI

-- VERIFICAR O CAMPO entity_id DE itvision_app_trees que parece nao estar sento atualizado coretamente

-- FAZER A MIGRACAO DOS OBJETOS DA ENTIDADE PARA A ENTIDADE SUPERIOR

   --App.delete_node_app(..)

end


function update_entity(id, id2)
   --print("update: "..id.." to "..id2)
   local entity = Model.query("glpi_entities e", "e.id = "..id)
   local child_app = Model.query("itvision_apps a, itvision_app_trees t", 
         "a.id = t.app_id and is_entity_root = true and a.entities_id = "..id, nil, 
         "a.id as app_id, t.id as node_id, a.service_object_id as object_id")
   local parent_app = Model.query("itvision_apps a, itvision_app_trees t", 
         "a.id = t.app_id and is_entity_root = true and a.entities_id = "..id2, nil, 
         "a.id as app_id, t.id as node_id, a.service_object_id as object_id")

   local parent_node = App.select_parent(child_app[1].app_id)
   --print(entity[1].name, child_app[1].app_id, parent_app[1].app_id)

   Model.update("itvision_apps", {name = entity[1].name}, "entities_id = "..id)

   if parent_node[1] and parent_app[1].node_id ~= parent_node[1].id then
     --print(parent_app[1].node_id, parent_node[1].id, child_app[1].app_id, parent_app[1].app_id)
     Model.update("itvision_app_objects", {app_id = parent_app[1].app_id}, 
         "service_object_id = "..child_app[1].object_id.." and app_id = "..parent_node[1].app_id)
     App.insert_subnode_app_tree(child_app[1].app_id, parent_app[1].app_id)
     App.delete_node_app_tree(child_app[1].node_id)
   end
end


function processe_entity_queue()

   local lines = line_reader(entityfile)
   for _,l in ipairs(lines) do
      local _, _, id, op, s, id2 = string.find(l, '(%d+) (%a+)( *)(%d*)')

      if id2 then id2 = string.gsub(id2," ","") end

      if op == "add" then
         add_entity(id)
      elseif op == "delete" then
         delete_entity(id)
      elseif op == "replace" then
         replace_entity(id, id2)
      elseif op == "update" then
         update_entity(id, id2)
      else
         print("Unknown operation")
      end

      id, op, s, id2 = nil, nil, nil, nil
   end

   --text_file_writer(entityfile, "") 
end


processe_entity_queue()
