--[[ 

   Este código deve ser executado diretamente do código php em "/servdesk/front/dropdown.common.form.php"
   como uma chamada externa incluida no referido arquivo php.

   Ele pode tambem ser executado por um serviço cron para sincronizaçao entre o glpi e o itvision.

   Desta forma, processa arquivo entity.queue criado através do "/servdesk/front/dropdown.common.form.php"
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
require "util"
require "monitor_util"


--[[ Adição de Entidade: 

   - cria nova aplicacao a partir do nome da entidade;
   - seleciona aplicacao pai (parent_app) a partir do campo entities_id da tabela glpi_entities;
   - recupera id da aplicacao criada e a coloca em child_app;
   - recupera nó da arvore de aplicacoes onde a nova aplicacao-entidade sera inserida e a coloca em parent_node
   - insere o novo nó na arvore atraves de metodo do pacote App

]]
function entity_add(id)
   --DEBUG: print("add: "..id)
   local entity = Model.query("glpi_entities e", "e.id = "..id)
   local parent_app = Model.query("itvision_apps a, glpi_entities e", 
               "e.id = "..id.." and e.entities_id = a.entities_id and is_entity_root = true", nil, "a.id as app_id")

   new_app = {
      instance_id  = config.database.instance_id,
      entities_id  = id,
      is_entity_root = 1,
      name         = entity[1].name,
      type         = "and",
      is_active    = 1,
      visibility   = 0,
      app_type_id  = 1,   -- leva em conta que a inicializacao da tabela itvision_app_type colocou o tipo entidade com id=1
   }
   Model.insert("itvision_apps", new_app)

--[[ Comentado para remover a criacao da arvore e inserir (abaixo) entrada em app_objects 
   local child_app = Model.query("itvision_apps a", "entities_id = "..id.." and a.is_entity_root = 1")
   local parent_node = Model.query("itvision_apps a, itvision_app_trees t", 
            "a.id = t.app_id and a.is_entity_root = true and a.id = "..parent_app[1].app_id, nil, "t.id as origin")

   App.insert_node_app_tree(child_app[1].id, id, parent_node[1].origin, 1)
]]

   App.remake_apps_config_file()
end


--[[ Remoção de Entidades: (o glpi so permite a remocao de uma entidade quando nao existem mais
     IC associados a ela. Caso contrario, o processo vira uma troca (replace).

   TODO: Caso o usuário mova um IC de uma entidade para outra e esta pertence a uma aplicacao,
         pade ocorrer uma dessincronia entre IC e Apps de uma entidade.

   - recupera nó a que a aplicacao-etidade pertence e a coloca em node;
   - remove o nó da arvore
   - remove qq aplicacao (incluindo objects e relats) que possa ainda haver dentro da entidade;
   - recria configuracao de nagios apps;

]]
function entity_delete(id)
   --DEBUG: print("delete: "..id)
   local entity = Model.query("glpi_entities e", "e.id = "..id)

--[[
   local node = Model.query("itvision_app_trees t, itvision_apps a" , 
            "a.id = t.app_id and a.is_entity_root = true and a.entities_id = ".. id,
            nil, "t.id as origin")

   if node[1] then
     --print(node[1].origin)
     App.delete_node_app(node[1].origin)
   end
   Model.delete("itvision_app_relats", "app_id in (select id from itvision_apps where entities_id = ".. id ..")")
   Model.delete("itvision_app_objects", "app_id in (select id from itvision_apps where entities_id = ".. id ..")")
   Model.delete("itvision_apps", "entities_id = ".. id)

   local APPS = App.select_uniq_app_in_tree()
   make_all_apps_config(APPS)
]]
   if entity[1] then
      replace_entity(id, entity[1].entities_id)
   end
end

--[[ Troca de entidade: (qdo se remove uma entidade que possui ICs associados)
     Obs: o glpi só permite a troca (replace) de uma entidade pela sua entidade pai,

   - recupera nó a que a aplicacao-etidade pertence e a coloca em node;
   - recupera aplicacao pai e a coloca em parent_app
   - remove o nó da arvore
   - move todos os objetos que pertenciam a antiga aplicacao para a sua aplicacao pai
   - remove a aplicacao-entidade em questão
   - recria configuracao de nagios apps;

]]
function entity_replace(id, id2)
   --DEBUG: print("replace: "..id.." to "..id2)
   -- VERIFICAR O CAMPO entity_id DE itvision_app_trees que parece nao estar sento atualizado coretamente
   local node = Model.query("itvision_app_trees t, itvision_apps a" , 
            "a.id = t.app_id and a.is_entity_root = true and a.entities_id = ".. id,
            nil, "t.id as origin")
   local parent_app = Model.query("itvision_apps a, itvision_app_trees t", 
         "a.id = t.app_id and is_entity_root = true and a.entities_id = "..id2, nil, 
         "a.id as app_id, t.id as node_id, a.service_object_id as object_id")

   if node[1] then
     --DEBUG: print(node[1].origin) App.delete_node_app(node[1].origin)
   end
   Model.update("itvision_app_relats", {app_id = parent_app[1].id}, "app_id in (select id from itvision_apps where entities_id = ".. id ..")")
   Model.update("itvision_app_objects", {app_id = parent_app[1].id}, "app_id in (select id from itvision_apps where entities_id = ".. id ..")")
   Model.delete("itvision_apps", "entities_id = ".. id)

   local APPS = App.select_uniq_app_in_tree()
   make_all_apps_config(APPS)
end


--[[ Atualizacao de Entidades: (id -> entidade a ser alterada; id2 -> entidade pai (que pode ser nova!)

   - recupera entidade e a coloca em entity;
   - recupera aplicacao que deve ser alterada e a coloca em child_app;
   - recupera aplicacao pai que deve que pode ou nao ter sido alterada e a coloca em parent_app;
   - recupera a aplicacao pai de child_app a partir da arvore de aplicacoes e a coloca em parent_node;
   - atualiza nome da aplicacao-entidade;
   - caso tenha havido alteracao no pai da entidade,
     - atualiza app_objects pois, qdo o objeto é uma aplicacao, o campo app_id é na também a aplicacao 
       pai da aplicacao em questao;
     - cria nova entrada na arvore de aplicacoes;
     - remove a entrada agora velha;
   
]]
function entity_update(id, id2)
   --DEBUG: print("update: "..id.." to "..id2)
   local entity = Model.query("glpi_entities e", "e.id = "..id)
   local child_app = Model.query("itvision_apps a, itvision_app_trees t", 
         "a.id = t.app_id and is_entity_root = true and a.entities_id = "..id, nil, 
         "a.id as app_id, t.id as node_id, a.service_object_id as object_id")
   local parent_app = Model.query("itvision_apps a, itvision_app_trees t", 
         "a.id = t.app_id and is_entity_root = true and a.entities_id = "..id2, nil, 
         "a.id as app_id, t.id as node_id, a.service_object_id as object_id")

   local parent_node = App.select_parent(child_app[1].app_id)
   --DEBUG: print(entity[1].name, child_app[1].app_id, parent_app[1].app_id)

   Model.update("itvision_apps", {name = entity[1].name}, "entities_id = "..id)

   --DEBUG: print(parent_app[1].node_id, parent_node[1].id, child_app[1].app_id, parent_app[1].app_id)
   if parent_node[1] and parent_app[1].node_id ~= parent_node[1].id then
     Model.update("itvision_app_objects", {app_id = parent_app[1].app_id}, 
         "service_object_id = "..child_app[1].object_id.." and app_id = "..parent_node[1].app_id)
     App.insert_subnode_app_tree(child_app[1].app_id, parent_app[1].app_id)
     App.delete_node_app_tree(child_app[1].node_id)
   end
end


--[[ Esta funcao está caduca pois os comandos são repassados direamente do php para o external.sh 
     que chama o código acima

function sync_entities()
   local entityfile = "/usr/local/itvision/scr/entity.queue"
   local lines = line_reader(entityfile)
   if not lines then return false end

   for _,l in ipairs(lines) do
      local _, _, op, arg1, s, arg2 = string.find(l, '(%a+) (%d+)( *)(%d*)')
      if arg2 then arg2 = string.gsub(arg2," ","") end
      execute_external_command(op, arg1, arg2)
      op, arg1, s, arg2 = nil, nil, nil, nil
   end

   text_file_writer(entityfile, "") 
end

entity_add(1)
entity_add(2)
entity_add(3)
entity_add(4)
entity_add(5)

]]

if arg[1] and arg[2]  then 
   local cmd = tostring(arg[1])
   local e_id = tonumber(arg[2])
   local e_id2 = tonumber(arg[3])

   print("cmd = "..cmd.." : e_id = "..e_id)
   if e_id2 then print("e_id2 = "..e_id2) end

   if cmd == "ADD" then
      entity_add(e_id)
   elseif cmd == "UPDATE" then
--      entity_update(e_id)
   elseif cmd == "DELETE" then
      if not e_id then print("e_id2 must not be nil"); return; end
--      entity_delete(e_id)
   elseif cmd == "REPLACE" then
      if not e_id then print("e_id must not be nil"); return; end
--      entity_replace(e_id)
   else
      print("Unknown command: "..cmd)
   end
end


