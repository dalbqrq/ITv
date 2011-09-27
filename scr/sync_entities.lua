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
]]
function entity_add(id)
   --DEBUG: print("add: "..id)
   local entity = Model.query("glpi_entities e", "e.id = "..id)

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

   App.remake_apps_config_file()
end


--[[ Remoção de Entidades: (o glpi so permite a remocao de uma entidade quando nao existem mais
     IC associados a ela. Caso contrario, o processo vira uma troca (replace).
]]
function entity_delete(id)
   --DEBUG: print("delete: "..id)
   local entity = Model.query("glpi_entities e", "e.id = "..id)

   if entity[1] then
      replace_entity(id, entity[1].entities_id)
   end
end


--[[ Troca de entidade: (qdo se remove uma entidade que possui ICs associados)
     Obs: o glpi só permite a troca (replace) de uma entidade pela sua entidade pai,
]]
function entity_replace(id, id2)
   --DEBUG: print("replace: "..id.." to "..id2)
--[[
| itvision_apps                             |
| itvision_monitors                         |
| itvision_app_objects                      |
| itvision_app_relats                       |
| itvision_app_contacts                     |
]]

   local child_app = Model.query("itvision_apps ", "entities_id = "..id.." and is_entity_root = 1" ); 
   child_app = child_app[1]
   local parent_app = Model.query("itvision_apps ", "entities_id = "..id2.." and is_entity_root = 1" ); 
   parent_app = parent_app[1]

   Model.update("itvision_apps", { entities_id=id2 }, "entities_id = "..id.." and is_entity_root = 0" )
   Model.update("itvision_monitors", { entities_id=id2 }, "entities_id = "..id )
   Model.update("itvision_app_objects", { app_id=parent_app.id }, "app_id = "..child_app.id )
   Model.update("itvision_app_relats", { app_id=parent_app.id }, "app_id = "..child_app.id )
   Model.update("itvision_app_contacts", { app_id=parent_app.id }, "app_id = "..child_app.id )

   Model.delete("itvision_apps", "entities_id = "..id.." and is_entity_root = 1" )
   App.remake_apps_config_file()
end


--[[ Atualizacao de Entidades: (id -> entidade a ser alterada; id2 -> entidade pai (que pode ser nova!)
]]
function entity_update(id, id2)
   --DEBUG: print("update: "..id.." to "..id2)
   local entity = Model.query("glpi_entities e", "e.id = "..id)
   entity = entity[1]
   local child_app = Model.query("itvision_apps ", "entities_id = "..id.." and is_entity_root = 1" ); 
   child_app = child_app[1]
   local new_parent_app = Model.query("itvision_apps ", "entities_id = "..id2.." and is_entity_root = 1" ); 
   new_parent_app = new_parent_app[1]

   Model.update("itvision_apps", { name=entity.name } , "entities_id = "..id)
   Model.update("itvision_app_objects", { app_id=new_parent_app.id } , "service_object_id = "..child_app.service_object_id)
   App.remake_apps_config_file()
end



if arg[1] and arg[2]  then 
   local cmd = tostring(arg[1])
   local e_id = tonumber(arg[2])
   local e_id2 = tonumber(arg[3])

   print("cmd = "..cmd.." : e_id = "..e_id)
   if e_id2 then print("e_id2 = "..e_id2) end

   if cmd == "ADD" then
      entity_add(e_id)
   elseif cmd == "UPDATE" then
      entity_update(e_id)
   elseif cmd == "DELETE" then
      if not e_id then print("e_id2 can not be nil"); return; end
      entity_delete(e_id)
   elseif cmd == "REPLACE" then
      if not e_id then print("e_id can not be nil"); return; end
      entity_replace(e_id)
   else
      print("Unknown command: "..cmd)
   end
end


