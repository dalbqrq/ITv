module("Itvision", package.seeall)

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
   local content = query ("nagios_objects", "name1 = '"..config.monitor.cmd_app.."'", extra_, columns_)
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

   cond_ = cond_.." and o.object_id not in ( select service_object_id from itvision_app_objects where app_id = "..app_id..") "
   cond_ = cond_.." and o.object_id not in ( select service_object_id from itvision_apps where id = "..app_id..") "
   cond_ = cond_.." and o.object_id not in ( select distinct(a.service_object_id) from itvision_app_trees AS node, itvision_app_trees AS parent, itvision_apps a where node.lft BETWEEN parent.lft AND parent.rgt AND node.id in (select id from itvision_app_trees where app_id = "..app_id..") and parent.app_id <> "..app_id.." and a.id = parent.app_id and a.is_active = 1)"
   cond_ = cond_.." and o.is_active = 1 "

   local bp_id = get_bp_id()
   local content = query ("nagios_services s, nagios_objects o ", 
      "s.service_object_id = o.object_id and s.check_command_object_id = "..bp_id..cond_, 
      extra_, columns_)
   return content

end


----------------------------- SERVICE APP ----------------------------------

function select_service_app (cond_, extra_, columns_)
   return select_service (cond_, extra_, columns_, "app")
end


function select_service_app_object (cond_, extra_, columns_)
   return select_service_object (cond_, extra_, columns_, "app")
end


----------------------------- NAGIOS X ITVISION X GLPI ----------------------------------

function select_ci_monitor (w_wo, itemtype)
    --[[
      select c.id, n.id as nid, c.name, n.ip, n.itemtype 
      from glpi_networkports n, glpi_computers c 
      where c.id = n.items_id and itemtype="Computer"
         and not exists (select 1 from itvision_monitors m where m.networkport_id = n.id);
   ]]

end

function select_ci_with_monitor ()

end


function select_ci_without_monitor ()
end


function select_version_monitor(w_wo)
end


function select_version_with_monitor ()
end


function select_version_without_monitor ()
end


----------------------------- APP ----------------------------------

function select_app (cond_, extra_, columns_)
   local content = query ("itvision_apps", cond_, extra_, columns_)
   return content
end


function insert_app (content_)
   local table_ = "itvision_apps"
   insert (table_, content_)
   
   local content = query (table_, "name = '"..content_.name.."'")
   
   return content
end


----------------------------- APP LIST ----------------------------------

function select_app_object (cond_, extra_, columns_)
   local content = query ("itvision_app_objects", cond_, extra_, columns_)
   return content
end


function select_app_app_objects (id)
   local cond_ = "o.object_id = ao.service_object_id and ao.app_id = a.id and o.object_id = m.service_object_id and m.networkports_id = p.id "
   if id then
      cond_ = cond_ .. " and a.id = "..id
   end
   local tables_ = "nagios_objects o, itvision_app_objects ao, itvision_apps a, glpi_networkports p, itvision_monitors m"
   local columns_ = [[ o.object_id, o.objecttype_id, o.name1, o.name2, ao.type as obj_type, a.id as 
	app_id, a.name as a_name, a.type as a_type, a.is_active, a.service_object_id as service_id, 
        p.itemtype as itemtype, p.items_id as items_id,
        m.name as name ]]
   local content = query (tables_, cond_, extra_, columns_)

   local cond_ = "o.object_id = ao.service_object_id and ao.app_id = a.id and ao.type = 'app' "
   if id then
      cond_ = cond_ .. " and a.id = "..id
   end
   local tables_ = "nagios_objects o, itvision_app_objects ao, itvision_apps a "
   local columns_ = [[ o.object_id, o.objecttype_id, o.name1, o.name2, ao.type as obj_type, a.id as 
	app_id, a.name as a_name, a.type as a_type, a.is_active, a.service_object_id as service_id, 
        NULL as itemtype, NULL as items_id,
        o.name2 as name ]]
   local content2 = query (tables_, cond_, extra_, columns_)
   for _,v in ipairs(content2) do
      table.insert(content,v)
   end
   return content
end


function select_app_to_graph (id)
   local columns_ = "app_id, a.name as a_name, ao.type as ao_type, o.object_id as obj_id, o.name1, o.name2, ss.current_state as curr_state"
   local tables_  = "itvision_apps a, itvision_app_objects ao, nagios_services s, nagios_objects o, nagios_servicestatus ss"
   local cond_    = "a.id = ao.app_id and ao.service_object_id = s.service_object_id and \
                     s.service_object_id = o.object_id and s.service_object_id = ss.service_object_id and \
                     a.id = "..id

   local content = query (tables_, cond_, extra_, columns_)
   return content
end


function insert_app_object (content_)
   local table_ = "itvision_app_objects"
   insert (table_, content_)
   
   local content = query (table_, "app_id = '"..content_.app_id.."'")
   
   return content
end


----------------------------- APP RELAT ----------------------------------

function select_app_relat (cond_, extra_, columns_)
   local content = query ("itvision_app_relats", cond_, extra_, columns_)
   return content
end



function select_app_relat_object (id, from, to)

   -- PRIMEIRO SELECIONA RELACIONAMENTOS ENTRE HOSTS e SERVICES
   local tables_  = [[itvision_app_relats ar, nagios_objects o1, nagios_objects o2, 
                      itvision_app_relat_types art, itvision_apps ap,
                      glpi_networkports n1, glpi_networkports n2, 
                      itvision_monitors m1, itvision_monitors m2 ]]
   local cond_    = [[ar.from_object_id = o1.object_id and 
                      ar.to_object_id = o2.object_id and
                      ar.app_relat_type_id = art.id and
                      ar.app_id = ap.id and
                      o1.object_id = m1.service_object_id and 
                      o2.object_id = m2.service_object_id and
                      m1.networkports_id = n1.id and
                      m2.networkports_id = n2.id ]]
   local columns_ = [[o1.name1 as from_name1, o1.name2 as from_name2, 
                      o2.name1 as to_name1, o2.name2 as to_name2,
                      ar.from_object_id, ar.to_object_id,
                      ar.app_id as app_id, ap.name as app_name, 
                      ar.app_relat_type_id, 
                      art.name as art_name, art.type as art_type,
                      ar.from_object_id, ar.to_object_id,
                      n1.itemtype as from_itemtype,
                      n1.items_id as from_items_id,
                      n2.itemtype as to_itemtype,
                      n2.items_id as to_items_id,
                      m1.name as from_name,
                      m2.name as to_name,
                      m1.type as from_type,
                      m2.type as to_type ]]

   if id then cond_ = cond_ .. " and ar.app_id = "..id end
   if from and to then cond_ = cond_  .. " and from_object_id = "..from.." and to_object_id = "..to end
   local content = query (tables_, cond_, extra_, columns_)

   -- AGORA SELECIONA RELACIONAMENTOS ENTRE HOSTS e SERVICES NA ORIGEM E APLICACOES NO DESTINO
   local tables_  = [[itvision_app_relats ar, nagios_objects o1, nagios_objects o2, 
                      itvision_app_relat_types art, itvision_apps ap,
                      glpi_networkports n1,
                      itvision_monitors m1 ]]
   local cond_    = [[ar.from_object_id = o1.object_id and 
                      ar.to_object_id = o2.object_id and
                      ar.app_relat_type_id = art.id and
                      ar.app_id = ap.id and
                      o1.object_id = m1.service_object_id and 
                      m1.networkports_id = n1.id and
                      o2.name1 = ']]..config.monitor.check_app..[[']]
   local columns_ = [[o1.name1 as from_name1, o1.name2 as from_name2, 
                      o2.name1 as to_name1, o2.name2 as to_name2,

                      ar.from_object_id, ar.to_object_id,
                      ar.app_id as app_id, ap.name as app_name, 
                      ar.app_relat_type_id, 
                      ar.from_object_id, ar.to_object_id,
                      art.name as art_name, art.type as art_type,

                      n1.itemtype as from_itemtype,
                      n1.items_id as from_items_id,
                      NULL as to_itemtype,
                      NULL as to_items_id,

                      m1.name as from_name,
                      m1.type as from_type,
                      o2.name2 as to_name,
                      'app' as to_type 
                    ]]

   if id then cond_ = cond_ .. " and ar.app_id = "..id end
   if from and to then cond_ = cond_  .. " and from_object_id = "..from.." and to_object_id = "..to end
   local content2 = query (tables_, cond_, extra_, columns_)

   -- AINDA, SELECIONA RELACIONAMENTOS ENTRE APLICACOES NA ORIGEM e HOSTS e SERVICES NO DESTINO
   local tables_  = [[itvision_app_relats ar, nagios_objects o1, nagios_objects o2, 
                      itvision_app_relat_types art, itvision_apps ap,
                      glpi_networkports n2,
                      itvision_monitors m2 ]]
   local cond_    = [[ar.from_object_id = o1.object_id and 
                      ar.to_object_id = o2.object_id and
                      ar.app_relat_type_id = art.id and
                      ar.app_id = ap.id and
                      o2.object_id = m2.service_object_id and 
                      m2.networkports_id = n2.id and
                      o1.name1 = ']]..config.monitor.check_app..[[']]
   local columns_ = [[o1.name1 as from_name1, o1.name2 as from_name2, 
                      o2.name1 as to_name1, o2.name2 as to_name2,

                      ar.from_object_id, ar.to_object_id,
                      ar.app_id as app_id, ap.name as app_name, 
                      ar.app_relat_type_id, 
                      ar.from_object_id, ar.to_object_id,
                      art.name as art_name, art.type as art_type,

                      n2.itemtype as from_itemtype,
                      n2.items_id as from_items_id,
                      NULL as to_itemtype,
                      NULL as to_items_id,

                      o1.name2 as from_name,
                      'app' as from_type,
                      m2.name as to_name,
                      m2.type as to_type
                    ]]

   if id then cond_ = cond_ .. " and ar.app_id = "..id end
   if from and to then cond_ = cond_  .. " and from_object_id = "..from.." and to_object_id = "..to end
   local content3 = query (tables_, cond_, extra_, columns_)

   -- POR FIM, SELECIONA RELACIONAMENTOS ENTRE APLICACOES NA ORIGEM e HOSTS e SERVICES NO DESTINO
   local tables_  = [[itvision_app_relats ar, nagios_objects o1, nagios_objects o2, 
                      itvision_app_relat_types art, itvision_apps ap ]]
   local cond_    = [[ar.from_object_id = o1.object_id and 
                      ar.to_object_id = o2.object_id and
                      ar.app_relat_type_id = art.id and
                      ar.app_id = ap.id and
                      o1.name1 = ']]..config.monitor.check_app..[[' and 
                      o2.name1 = ']]..config.monitor.check_app..[[']]
   local columns_ = [[o1.name1 as from_name1, o1.name2 as from_name2, 
                      o2.name1 as to_name1,   o2.name2 as to_name2,

                      ar.from_object_id, ar.to_object_id,
                      ar.app_id as app_id, ap.name as app_name, 
                      ar.app_relat_type_id, 
                      ar.from_object_id, ar.to_object_id,
                      art.name as art_name, art.type as art_type,

                      NULL as from_itemtype,
                      NULL as from_items_id,
                      NULL as to_itemtype,
                      NULL as to_items_id,

                      o1.name2 as from_name,
                      'app' as from_type,
                      o2.name2 as to_name,
                      'app' as to_type
                    ]]

   if id then cond_ = cond_ .. " and ar.app_id = "..id end
   if from and to then cond_ = cond_  .. " and from_object_id = "..from.." and to_object_id = "..to end
   local content4 = query (tables_, cond_, extra_, columns_)

   -- JUNTA TODOS OS RESULTADOS
   for _,v in ipairs(content2) do
      table.insert(content,v)
   end

   for _,v in ipairs(content3) do
      table.insert(content,v)
   end

   for _,v in ipairs(content4) do
      table.insert(content,v)
   end

   return content
end



function select_app_relat_to_graph (id)
   -- PRIMEIRO SELECIONA RELACIONAMENTOS ENTRE HOSTS e SERVICES
   local tables_  = "itvision_apps a, itvision_app_relats ar, itvision_app_relat_types art, "..
                    "nagios_objects o1, nagios_objects o2, "..
                    "glpi_networkports n1, glpi_networkports n2, "..
                    "itvision_monitors m1, itvision_monitors m2"
   local columns_ = "a.name as a_name, art.name as art_name, o1.name1 as o1_name1, o1.name2 as o1_name2, "..
                    "o2.name1 as o2_name1, o2.name2 as o2_name2, "..
                    "n1.itemtype as from_itemtype, n1.items_id as from_items_id, "..
                    "n2.itemtype as to_itemtype, n2.items_id as to_items_id, "..
                    "m1.name as m1_name, m2.name as m2_name "
   local cond_    = "a.id = ar.app_id and \
                     ar.from_object_id = o1.object_id and \
                     ar.to_object_id = o2.object_id and \
                     ar.app_relat_type_id = art.id and \
                     o1.object_id = m1.service_object_id and \
                     o2.object_id = m2.service_object_id and \
                     m1.networkports_id = n1.id and \
                     m2.networkports_id = n2.id and \
                     a.id = "..id 

   local content = query (tables_, cond_, extra_, columns_)

   -- AGORA SELECIONA RELACIONAMENTOS ENTRE HOSTS e SERVICES NA ORIGEM E APLICACOES NO DESTINO
   local tables_  = "itvision_apps a, itvision_app_relats ar, itvision_app_relat_types art, "..
                    "nagios_objects o1, nagios_objects o2, "..
                    "glpi_networkports n1, "..
                    "itvision_monitors m1 "
   local columns_ = "a.name as a_name, art.name as art_name, "..
                    "o1.name1 as o1_name1, o1.name2 as o1_name2, "..
                    "o2.name1 as o2_name1, o2.name2 as o2_name2, "..
                    "n1.itemtype as from_itemtype, n1.items_id as from_items_id, "..
                    "'app' as to_itemtype, NULL as to_items_id, "..
                    "m1.name as m1_name, "..
                    "o2.name2 as m2_name "
   local cond_    = "a.id = ar.app_id and \
                     ar.from_object_id = o1.object_id and \
                     ar.to_object_id = o2.object_id and \
                     ar.app_relat_type_id = art.id and \
                     o1.object_id = m1.service_object_id and \
                     m1.networkports_id = n1.id and \
                     a.id = "..id.." and \
                     o2.name1 = '"..config.monitor.check_app.."'"

   local content2 = query (tables_, cond_, extra_, columns_)

   -- AINDA, SELECIONA RELACIONAMENTOS ENTRE APLICACOES NA ORIGEM e HOSTS e SERVICES NO DESTINO
   local tables_  = "itvision_apps a, itvision_app_relats ar, itvision_app_relat_types art, "..
                    "nagios_objects o1, nagios_objects o2, "..
                    "glpi_networkports n2, "..
                    "itvision_monitors m2 "
   local columns_ = "a.name as a_name, art.name as art_name, "..
                    "o1.name1 as o1_name1, o1.name2 as o1_name2, "..
                    "o2.name1 as o2_name1, o2.name2 as o2_name2, "..
                    "'app' as from_itemtype, NULL as from_items_id, "..
                    "n2.itemtype as to_itemtype, n2.items_id as to_items_id, "..
                    "m2.name as m2_name, "..
                    "o1.name2 as m1_name "
   local cond_    = "a.id = ar.app_id and \
                     ar.from_object_id = o1.object_id and \
                     ar.to_object_id = o2.object_id and \
                     ar.app_relat_type_id = art.id and \
                     o2.object_id = m2.service_object_id and \
                     m2.networkports_id = n2.id and \
                     a.id = "..id.." and \
                     o1.name1 = '"..config.monitor.check_app.."'"


   local content3 = query (tables_, cond_, extra_, columns_)

   -- POR FIM, SELECIONA RELACIONAMENTOS ENTRE APLICACOES NA ORIGEM e HOSTS e SERVICES NO DESTINO
   local tables_  = "itvision_apps a, itvision_app_relats ar, itvision_app_relat_types art, "..
                    "nagios_objects o1, nagios_objects o2 "
   local columns_ = "a.name as a_name, art.name as art_name, "..
                    "o1.name1 as o1_name1, o1.name2 as o1_name2, "..
                    "o2.name1 as o2_name1, o2.name2 as o2_name2, "..
                    "'app' as from_itemtype, NULL as from_items_id, "..
                    "'app' as to_itemtype, NULL as to_items_id, "..
                    "o2.name2 as m2_name, "..
                    "o1.name2 as m1_name "
   local cond_    = "a.id = ar.app_id and \
                     ar.from_object_id = o1.object_id and \
                     ar.to_object_id = o2.object_id and \
                     ar.app_relat_type_id = art.id and \
                     a.id = "..id.." and \
                     o1.name1 = '"..config.monitor.check_app.."' and  \
                     o2.name1 = '"..config.monitor.check_app.."'"


   local content4 = query (tables_, cond_, extra_, columns_)


   -- JUNTA TODOS OS RESULTADOS
   for _,v in ipairs(content2) do
      table.insert(content,v)
   end

   for _,v in ipairs(content3) do
      table.insert(content,v)
   end

   for _,v in ipairs(content4) do
      table.insert(content,v)
   end

   return content
end




function insert_app_relat (content_)
   local table_ = "itvision_app_relats"
   insert (table_, content_)
   
   local content = query (table_, "app_id = "..content_.app_id.." and "..
      "from_object_id = "..content_.from_object_id..
      " and to_object_id = "..content_.to_object_id)
   
   return content
end


----------------------------- APP TREE ----------------------------------
--[[
   Nested Set Model
   see: http://dev.mysql.com/tech-resources/articles/hierarchical-data.html


function new_app_tree() -- Create table structure
function insert_node_app_tree(app_id, origin_, position_) -- Inclui novo noh
function select_root_app_tree () -- Seleciona o noh raiz da arvore
function find_node_id(app_id, conected_to_root)
function delete_node_app_tree(orgin_)
function show_app_tree()
function select_full_path_app_tree (origin) -- Seleciona toda sub-arvore a patir de um noh de origem
function select_leaf_nodes_app_tree () -- Seleciona todas as folhas da arvore
function select_simple_path_app_tree (origin) -- Seleciona um unico caminho partindo de um noh 
function select_depth_app_tree (origin) -- Seleciona a profundidade de cada noh
function select_depth_subtree_app_tree (origin) -- Seleciona a profundidade de cada noh a partir de 
function select_subrdinates_app_tree (origin) -- Encontra o noh subordinado imediato
function delete_app_tree (origin) -- remove um noh dado por 'origin'
function move_app_tree(origin, destiny) -- move um ramo de arvore para outro noh



]]


function new_app_tree() -- Create table structure
   local content = {
      id = 0,
      instance_id = 0,
      lft = 0,
      rgt = 0,
      app_id = 0
   }

   return content
end


function insert_node_app_tree(app_id, origin_, position_) -- Inclui novo noh
   --[[   content_ deve conter o app_id a ser inserido na inclusao.
      Se origin_ for nulo, entao deve ser a primeira entrada na arvore.
      position pode ter os valores: 0 -> antes; 1 -> abaixo; 2 -> depois.
   ]]
   position_ = position_ or 1 
   local lft, rgt, newLft, newRgt, condLft, confRgt, root_id
   local content = nil
   local node = new_app_tree()

   if origin_ then
      -- usuario deu a origem, entao verifica se ela existe
      content = query ("itvision_app_trees", "id = ".. origin_)
   else
      -- usuario disse que é a primeira entrada. Isto eh verdade ou a arvore jah existe?
      root_id, content = select_root_app_tree()
   end

   if not origin_ and not root_id then
      newLft = 1
      newRgt = 2

   elseif content[1] == nil then
      return false, error_message(1)

   else
      lft = tonumber(content[1].lft)
      rgt = tonumber(content[1].rgt)

      if position_ == 0 then
         newLft = lft
         newRgt = lft + 1
         condLft = "lft >= " .. lft
         condRgt = "rgt >= " .. lft

      elseif position_ == 1 then
         newLft = rgt
         newRgt = rgt + 1
         condLft = "lft >  " .. rgt
         condRgt = "rgt >= " .. rgt

      elseif position_ == 2 then
         newLft = rgt + 1
         newRgt = rgt + 2
         condLft = "lft > " .. lft
         condRgt = "rgt > " .. rgt

      end
   end

   node.app_id = app_id
   node.lft    = newLft
   node.rgt    = newRgt
   node.instance_id = config.database.instance_id

--[[ DEBUG
   text_file_writer ("/tmp/instree", type(node)..":"..node.app_id.." "..node.lft.." "..node.rgt.." "..node.instance_id)
   local s = ""
   for i,v in pairs(node) do
      s = s .. " "..i..":"..type(v)
   end
   text_file_writer ("/tmp/instree2", s)
]]

   execute ( "LOCK TABLE itvision_app_trees WRITE" )
   if origin_ or root_id then
      -- devido a set do tipo "lft = lft + 2" tive que usar execute() e nao update()
   --text_file_writer ("/tmp/instree3", condLft.." : "..condRgt)
      execute("update itvision_app_trees set lft = lft + 2 where "..condLft)
      execute("update itvision_app_trees set rgt = rgt + 2 where "..condRgt)
   end
   insert  ( "itvision_app_trees", node)
   execute ( "UNLOCK TABLES" )

   return true, error_message(2) 
end


function select_root_app_tree () -- Seleciona o noh raiz da arvore
   local root = query ("itvision_app_trees", "lft = 1")
   if root[1] then
      return root[1].id, root
   else
      return nil, nil
   end
end


function find_node_id(app_id, conected_to_root)
   local cond = ""
   if conected_to_root then cond = " and " end
   local content = query ("itvision_app_trees", cond.." app_id = "..app_id)
   return content
end


function delete_node_app_tree(orgin_)
   local lft, rgt, width, root_id
   local content = {}

text_file_writer("/tmp/rmapp"..origin_)
   if origin_ then
      -- usuario deu a origem, entao verifica se ela existe
      content = query ("itvision_app_trees", "id = ".. origin_, nil, "lft, rgt, rgt - lft + 1 as width")
   else
      return false
   end

   lft   = tonumber(content[1].lft)
   rgt   = tonumber(content[1].rgt)
   width = tonumber(content[1].width)


   execute ( "LOCK TABLE itvision_app_trees WRITE" )
   execute ( "delete from itvision_app_trees where lft between "..lft.." and "..rgt )
   execute ( "update itvision_app_trees set lft = lft - "..width.." where lft > "..rgt )
   execute ( "update itvision_app_trees set rgt = rgt - "..width.." where rgt > "..rgt )
   execute ( "UNLOCK TABLES" )

   return true
end


function show_app_tree()
   local stmt_ = [[
      SELECT CONCAT( REPEAT( ' ', (COUNT(parent.app_id) - 1) ), node.app_id) AS app_id
      FROM itvision_app_trees AS node,
           itvision_app_trees AS parent
      WHERE node.lft BETWEEN parent.lft AND parent.rgt
      GROUP BY node.app_id
      ORDER BY node.lft;
   ]]

   content = execute( stmt_ )

   for i, v in ipairs(content) do
      print(v.app_id)
   end 
end
   


function select_full_path_app_tree (origin) -- Seleciona toda sub-arvore a patir de um noh de origem
   local root_id, root = {}
   root_id, root = select_root_app_tree()
   origin = origin or root_id
   origin = origin or 0 -- se mesmo assim origin eh nulo, entao seta o valor como 0 (zero)
   local content = {}

   columns   = [[node.id, node.instance_id, node.lft, node.rgt, node.app_id, 
                app.name, papp.id as papp_id, papp.name as pname]]
   tablename = [[itvision_app_trees AS node, itvision_app_trees AS parent, 
                itvision_apps as app, itvision_apps as papp]]
   cond      = [[node.lft BETWEEN parent.lft AND parent.rgt AND parent.id = ]] .. origin .. 
               [[ AND node.app_id = app.id AND parent.app_id = papp.id]]
   extra     = [[ORDER BY node.lft]]

   content = query (tablename, cond, extra, columns)

   return content
end


function select_leaf_nodes_app_tree () -- Seleciona todas as folhas da arvore
   local content = {}

   columns   = "*"
   tablename = "itvision_app_trees"
   cond      = "rgt = lft + 1"
   extra     = "ORDER BY lft"

   content = query (tablename, cond, extra, columns)

   return content
end


function select_simple_path_app_tree (origin) -- Seleciona um unico caminho partindo de um noh 
                     -- ateh o topo da arvore
   local root_id, root = {}
   root_id, root = select_root_app_tree()
   origin = origin or root_id
   local content = {}

   columns   = "parent.id, parent.instance_id, parent.lft, parent.rgt, parent.app_id"
   tablename = "itvision_app_trees AS node, itvision_app_trees AS parent"
   cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.id = " .. origin
   extra     = "ORDER BY parent.lft"

   content = query (tablename, cond, extra, columns)

   return content
end


function select_depth_app_tree (origin) -- Seleciona a profundidade de cada noh
   local root_id, root = {}
   root_id, root = select_root_app_tree()
   origin = origin or root_id
   local content = {}

   columns   = [[ node.id, node.instance_id, node.lft, node.rgt, node.app_id, 
            (COUNT(parent.id) - 1) AS depth, parent.id as parent ]]
   tablename = "itvision_app_trees AS node, itvision_app_trees AS parent"
   cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.id = " .. origin
   extra     = "GROUP BY node.id ORDER BY parent.lft"

   content = query (tablename, cond, extra, columns)

   return content
end


function select_depth_subtree_app_tree (origin) -- Seleciona a profundidade de cada noh a partir de 
                  -- um noh especifico
   local root_id, root = {}
   root_id, root = select_root_app_tree()
   origin = origin or root_id
   local content = {}

   columns   = [[ node.id, node.instance_id, node.lft, node.rgt, node.app_id,
            (COUNT(parent.id) - (sub_tree.depth + 1)) AS depth, parent.id as parent ]]
   tablename = [[ itvision_app_trees AS node, itvision_app_trees AS parent, itvision_app_trees AS sub_parent,
            (   SELECT node.id, (COUNT(parent.id) - 1) AS depth
            FROM itvision_app_trees AS node, itvision_app_trees AS parent
            WHERE node.lft BETWEEN parent.lft AND parent.rgt
            AND node.id = ]] .. origin .. [[
            GROUP BY node.id
            ORDER BY node.lft
            ) AS sub_tree ]]
   cond      = [[ node.lft BETWEEN parent.lft AND parent.rgt
            AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
            AND sub_parent.id = sub_tree.id ]]
   extra     = "GROUP BY node.id ORDER BY node.lft"

   content = query (tablename, cond, extra, columns)

   return content
end


function select_subrdinates_app_tree (origin) -- Encontra o noh subordinado imediato
   local root_id, root = {}
   root_id, root = select_root_app_tree()
   origin = origin or root_id
   local content = {}

   columns   = [[ node.id, node.instance_id, node.lft, node.rgt, node.app_id,
            (COUNT(parent.id) - (sub_tree.depth + 1)) AS depth ]]
   tablename = [[ itvision_app_trees AS node, itvision_app_trees AS parent, itvision_app_trees AS sub_parent, 
            (   SELECT node.id, (COUNT(parent.id) - 1) AS depth
            FROM itvision_app_trees AS node,
            itvision_app_trees AS parent
            WHERE node.lft BETWEEN parent.lft AND parent.rgt
            AND node.id = ]] .. origin .. [[
            GROUP BY node.id
            ORDER BY node.lft
            ) AS sub_tree ]]
   cond      = [[ node.lft BETWEEN parent.lft AND parent.rgt
            AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
            AND sub_parent.id = sub_tree.id ]]
   extra     = [[ GROUP BY node.id HAVING depth = 1 ORDER BY node.lft ]]
   --extra     = [[ GROUP BY node.id HAVING depth <= 1 ORDER BY node.lft ]]


   content = query (tablename, cond, extra, columns)

   return content
end


function insert_subnode_app_tree(app_child, app_parent) -- Adiciona nós filhos abaixo de todos os nos que possuiem app_id = app_parent
                                    -- isso é feito tipicamente na inclusão de uma app como objeto de outra (subapp)
      local nodes = query ("itvision_app_trees", "app_id = "..app_parent)

text_file_writer("/tmp/nodes", app_child.. " x "..app_parent)

      for i,v in ipairs(nodes) do
         insert_node_app_tree(app_child, v.id, 1)
      end
end



function delete_app_tree (origin) -- remove um noh dado por 'origin'
   -- TODO: !
   return false
end


function move_app_tree(origin, destiny) -- move um ramo de arvore para outro noh
   -- TODO: !
   return false
end



