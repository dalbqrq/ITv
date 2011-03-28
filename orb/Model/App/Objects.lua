
require "util"
require "messages"

----------------------------- HOSTS ----------------------------------

function select_host (cond_, extra_, columns_) 
   local content = query ("nagios_hosts", cond_, extra_, columns_)
   return content
end


--TODO: 16 o objeto tipo host de uma aplicacao é na verdade um objeto tipo servico para o nagios.
function select_host_object (cond_, extra_, columns_, app_id)
   local exclude = ""
   if app_id then exclude=" and o.object_id not in ( select service_object_id from itvision_app_objects where app_id = "..app_id..") " end
   exclude = exclude.." and o.is_active = 1 "

   if cond_ then cond_ = exclude.." and "..cond_ else cond_ = exclude end

   cond_ = cond_ .. " and o.name1 NOT LIKE '"..config.monitor.check_app.."%' " -- retira "dummy hosts" criados pelo BP
   cond_ = cond_ .. " and o.name1 <> 'dummy' " -- retira "dummy hosts" criados pela inicializacao
   local content = query ("nagios_hosts h, nagios_objects o ", "h.host_object_id = o.object_id"..cond_,
      extra_, columns_)
   return content
end


----------------------------- SERVICES ----------------------------------

function get_bp_id () -- usado para selecionar os 'services' que sao aplicacoes
   local content = query ("nagios_objects", "name1 = '"..config.monitor.cmd_app.."' and is_active = 1", extra_, columns_)
   return content[1].object_id
end


function select_service (cond_, extra_, columns_, app)
   if app ~= nil then app = " = " else app = " <> " end
   if cond_ ~= nil then cond_ = " and "..cond_ else cond_ = "" end
   local bp_id = get_bp_id()
   local content = query ("nagios_services", "check_command_object_id"..app..bp_id..cond_, 
      extra_, columns_)
   return content
end


-- Exemplo de uso: t = select_service_object (nil, nil, nil, true, nil)
-- app_obj eh a lista de objetos de uma aplicacao
function select_service_object (cond_, extra_, columns_, app, app_id, ping)
   if app ~= nil then app = " = " else app = " <> " end
   local exclude = ""

   if app_id then exclude=" and o.object_id not in ( select service_object_id from itvision_app_objects where app_id = "..app_id..") " end
   exclude = exclude.." and o.is_active = 1 "

   if cond_ then cond_ = exclude.." and "..cond_ else cond_ = exclude end
   cond_ = cond_ .. " and o.name1 <> 'dummy' " -- retira "dummy hosts" criados pela inicializacao
   if ping == nil then 
      cond_ = cond_ .. " and o.name2 <> '"..config.monitor.check_host.."' "
   else
      cond_ = cond_ .. " and o.name2 = '"..config.monitor.check_host.."' "
   end

   extra_ = "order by o.name1, o.name2" -- ignorando outros "extras" para ordenar pelo host. Pode ser melhorado!

   local bp_id = get_bp_id()
   local content = query ("nagios_services s, nagios_objects o ", 
      "s.service_object_id = o.object_id and s.check_command_object_id"..app..bp_id..cond_, 
      extra_, columns_)

   return content
end

-- seleciona applicacoes para serem incluidas como uma subaplicacao de outra aplicacao em app_obj.lua
-- na lista retornada nao pode haver aplicacoes que já possuam como pai uma app_id em nem ela propria
function select_app_service_object (cond_, extra_, columns_, app_id)
   if cond_ ~= nil then cond_ = " and "..cond_ else cond_ = "" end

   -- Aplicacoes que já sao sub-aplicacoes (filhos) da aplicacao app_id
   cond_ = cond_.." and o.object_id not in ( select service_object_id from itvision_app_objects where app_id = "..app_id..") "
   -- A propria aplicacao app_id
   cond_ = cond_.." and o.object_id not in ( select IFNULL ((select service_object_id from itvision_apps where id = "..app_id.."), -1) )"
   -- Algum ancestral da aplicacao em toda a árvore
   --cond_ = cond_.." and o.object_id not in ( select distinct(a.service_object_id) from itvision_app_trees AS node, itvision_app_trees AS parent, itvision_apps a where node.lft BETWEEN parent.lft AND parent.rgt AND node.id in (select id from itvision_app_trees where app_id = "..app_id..") and parent.app_id <> "..app_id.." and a.id = parent.app_id and a.is_active = 1)"
   -- Aplicacoes ativas
   cond_ = cond_.." and o.is_active = 1"
   --cond_ = cond_.." and a.app_type_id <> 1"

   local bp_id = get_bp_id()
   local content = query ("nagios_services s, nagios_objects o, itvision_apps a ", 
      "s.service_object_id = o.object_id and a.service_object_id = o.object_id and s.check_command_object_id = "..bp_id..cond_, 
      extra_, columns_)

   return content
end

