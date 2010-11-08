
require "Model"
require "util"
require "messages"
require "model_access"


----------------------------- HOSTS ----------------------------------

function select_host (cond_, extra_, columns_) 
   local content = query ("nagios_hosts", cond_, extra_, columns_)
   return content
end


function select_host_object (cond_, extra_, columns_, app_id)
   local exclude = ""
   if app_id then exclude=" and o.object_id not in ( select object_id from itvision_app_object where app_id = "..app_id..") " end
   exclude = exclude.." and o.is_active = 1 "

   if cond_ then cond_ = exclude.." and "..cond_ else cond_ = exclude end

   cond_ = cond_ .. " and o.name1 NOT LIKE 'business_processes%' " -- retira "dummy hosts" criados pelo BP
   cond_ = cond_ .. " and o.name1 <> 'dummy' " -- retira "dummy hosts" criados pela inicializacao
   local content = query ("nagios_hosts h, nagios_objects o ", "h.host_object_id = o.object_id"..cond_,
      extra_, columns_)
   return content
end


----------------------------- SERVICES ----------------------------------

function get_bp_id () -- usado para selecionar os 'services' que sao aplicacoes
   local content = query ("nagios_objects", "name1 = 'check_bp_status'", extra_, columns_)
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

   if app_id then exclude=" and o.object_id not in ( select object_id from itvision_app_object where app_id = "..app_id..") " end
   exclude = exclude.." and o.is_active = 1 "

   if cond_ then cond_ = exclude.." and "..cond_ else cond_ = exclude end
   cond_ = cond_ .. " and o.name1 <> 'dummy' " -- retira "dummy hosts" criados pela inicializacao
   if ping == nil then 
      cond_ = cond_ .. " and o.name2 <> '"..config.monitor.host_ping.."' "
   else
      cond_ = cond_ .. " and o.name2 = '"..config.monitor.host_ping.."' "
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
-- TODO: 1 
function select_app_service_object (cond_, extra_, columns_, app_id)
   local bp_id = get_bp_id()

   if cond_ ~= nil then cond_ = " and "..cond_ else cond_ = "" end

   cond_ = cond_ .. " and  service_object_id not in (select service_object_id from itvision_app)"

   local content = query ("nagios_services", "check_command_object_id = "..bp_id..cond_,
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
         and not exists (select 1 from itvision_monitor m where m.networkport_id = n.id);
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
   local content = query ("itvision_app", cond_, extra_, columns_)
   return content
end


function insert_app (content_)
   local table_ = "itvision_app"
   insert (table_, content_)
   
   local content = query (table_, "name = '"..content_.name.."'")
   
   return content
end


----------------------------- APP LIST ----------------------------------

function select_app_object (cond_, extra_, columns_)
   local content = query ("itvision_app_object", cond_, extra_, columns_)
   return content
end


function select_objects_app_object (cond_, extra_, columns_)
   local content = query ("itvision_app_object", cond_, extra_, columns_)
   return content
end


function select_app_app_objects (id)
   local cond_ = "no.object_id = al.object_id and al.app_id = ap.id"
   if id then
      cond_ = cond_ .. " and ap.id = "..id
   end
   local tables_ = "nagios_objects no, itvision_app_object al, itvision_app ap"
   local columns_ = [[ no.object_id, no.objecttype_id, no.name1, no.name2, al.type as obj_type, ap.id as 
	app_id, ap.name as app_name, ap.type as app_type, ap.is_active, ap.service_object_id as service_id ]]
   --local extra_ = "order by ap.app_id, no.name1, no.name2"
   local content = query (tables_, cond_, extra_, columns_)
   return content
end


function select_app_to_graph (id)
   local columns_ = "app_id, a.name as a_name, ao.type as ao_type, o.name1, o.name2, ss.current_state"
   local tables_  = "itvision_app a, itvision_app_object ao, nagios_services s, nagios_objects o, nagios_servicestatus ss"
   local cond_    = "a.id = ao.app_id and ao.object_id = s.service_object_id and \
                     s.service_object_id = o.object_id and s.service_object_id = ss.service_object_id and \
                     a.id = "..id

   local content = query (tables_, cond_, extra_, columns_)
   return content
end


function insert_app_object (content_)
   local table_ = "itvision_app_object"
   insert (table_, content_)
   
   local content = query (table_, "app_id = '"..content_.app_id.."'")
   
   return content
end


----------------------------- APP RELAT ----------------------------------

function select_app_relat (cond_, extra_, columns_)
   local content = query ("itvision_app_relat", cond_, extra_, columns_)
   return content
end


function select_app_relat_object (id, from, to)
   local tables_  = [[itvision_app_relat ar, nagios_objects o1, nagios_objects o2, 
                      itvision_app_relat_type rt, itvision_app ap]]
   local cond_    = [[ar.from_object_id = o1.object_id and 
                      ar.to_object_id = o2.object_id and
                      ar.app_relat_type_id = rt.id and
                      ar.app_id = ap.id ]]
   local columns_ = [[o1.name1 as from_name1, o1.name2 as from_name2, 
                      o2.name1 as to_name1, o2.name2 as to_name2,
                      ar.from_object_id, ar.to_object_id,
                      ar.app_id as app_id, ap.name as app_name, 
                      ar.app_relat_type_id, 
                      rt.name as rtype_name, rt.type as rtype_type,
                      ar.from_object_id, ar.to_object_id ]]

   if id then cond_ = cond_ .. " and ar.app_id = "..id end
   if from and to then cond_ = cond_  .. " and from_object_id = "..from.." and to_object_id = "..to end
   local content = query (tables_, cond_, extra_, columns_)

   return content
end

--[[
select  a.name as a_name, art.name as art_name, o1.name1 as o1_name1, o1.name2 as o1_name2, o2.name1 as o2_name1, o2.name2 as o2_name2
from itvision_app a, itvision_app_relat ar, nagios_objects o1, nagios_objects o2, itvision_app_relat_type art
where a.id = ar.app_id and
ar.from_object_id = o1.object_id and
ar.to_object_id = o2.object_id and
ar.app_relat_type_id = art.id
]]
function select_app_relat_to_graph (id)
   local columns_ = "a.name as a_name, art.name as art_name, o1.name1 as o1_name1, o1.name2 as o1_name2, o2.name1 as o2_name1, o2.name2 as o2_name2"
   local tables_  = "itvision_app a, itvision_app_relat ar, nagios_objects o1, nagios_objects o2, itvision_app_relat_type art"
   local cond_    = "a.id = ar.app_id and \
                     ar.from_object_id = o1.object_id and \
                     ar.to_object_id = o2.object_id and \
                     ar.app_relat_type_id = art.id and \
                     a.id = "..id

   local content = query (tables_, cond_, extra_, columns_)
   return content
end


function insert_app_relat (content_)
   local table_ = "itvision_app_relat"
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
]]


function new_app_tree() -- Create table structure
   local content = {
      id = 0,
      instance_id = 0,
      lft = 0,
      rgt = 0,
      app_id = ""
   }

   return content
end


function insert_node_app_tree(content_, origin_, position_) -- Inclui novo noh
   --[[   content_ deve conter o app_id a ser inserido na inclusao.
      Se origin_ for nulo, entao deve ser a primeira entrada na arvore.
      position pode ter os valores: 0 -> antes; 1 -> abaixo; 2 -> depois.
   ]]
   position_ = position_ or 1 
   local lft, rgt, newLft, newRgt, condLft, confRgt, root_id
   local content = {}

   if origin_ then
      -- usuario deu a origem, entao verifica se ela existe
      content = query ("itvision_app_tree", "id = ".. origin_)
   else
      -- usuario disse que é a primeira entrada. Isto eh verdade ou a arvore jah existe?
      root_id, content = select_root_app_tree()
   end

   if not origin_ and root_id == nil then
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

   content_.lft    = newLft
   content_.rgt    = newRgt

   execute ( "LOCK TABLE itvision_app_tree WRITE" )
   if origin_ then
      -- devido a set do tipo "lft = lft + 2" tive que usar execute() e nao update()
      execute("update itvision_app_tree set lft = lft + 2 where "..condLft)
      execute("update itvision_app_tree set rgt = rgt + 2 where "..condRgt)
   end
   insert  ( "itvision_app_tree", content_)
   execute ( "UNLOCK TABLES" )

   return true, error_message(2) 
end


function select_root_app_tree () -- Seleciona o noh raiz da arvore
   --local root = select ("itvision_app_tree", "lft = 1")
   local root = query ("itvision_app_tree", "lft = 1")
   if root[1] then
      return root[1].id, root
   else
      return nil, nil
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
   tablename = [[itvision_app_tree AS node, itvision_app_tree AS parent, 
                itvision_app as app, itvision_app as papp]]
   cond      = [[node.lft BETWEEN parent.lft AND parent.rgt AND parent.id = ]] .. origin .. 
               [[ AND node.app_id = app.id AND parent.app_id = papp.id]]
   extra     = [[ORDER BY node.lft]]

   content = query (tablename, cond, extra, columns)

   return content
end


function select_leaf_nodes_app_tree () -- Seleciona todas as folhas da arvore
   local content = {}

   columns   = "*"
   tablename = "itvision_app_tree"
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
   tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
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
            (COUNT(parent.id) - 1) AS depth ]]
   tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
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
            (COUNT(parent.id) - (sub_tree.depth + 1)) AS depth ]]
   tablename = [[ itvision_app_tree AS node, itvision_app_tree AS parent, itvision_app_tree AS sub_parent
            (   SELECT node.id, (COUNT(parent.id) - 1) AS depth
            FROM itvision_app_tree AS node, itvision_app_tree AS parent
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
   tablename = [[ itvision_app_tree AS node, itvision_app_tree AS parent, itvision_app_tree AS sub_parent
            (   SELECT node.id, (COUNT(parent.id) - 1) AS depth
            FROM itvision_app_tree AS node,
            itvision_app_tree AS parent
            WHERE node.lft BETWEEN parent.lft AND parent.rgt
            AND node.id = ]] .. origin .. [[
            GROUP BY node.id
            ORDER BY node.lft
            ) AS sub_tree ]]
   cond      = [[ node.lft BETWEEN parent.lft AND parent.rgt
            AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
            AND sub_parent.id = sub_tree.id ]]
   extra     = [[ GROUP BY node.id HAVING depth <= 1 ORDER BY node.lft ]]


   content = query (tablename, cond, extra, columns)

   return content
end


function delete_app_tree (origin) -- remove um noh dado por 'origin'
   -- TODO: !
   return false
end


function move_app_tree(origin, destiny) -- move um ramo de arvore para outro noh
   -- TODO: !
   return false
end




----------------------------- LOCATION TREE ----------------------------------
--[[
   Nested Set Model
   see: http://dev.mysql.com/tech-resources/articles/hierarchical-data.html
]]


function new_location_tree() -- Create table structure
   local content = {
      location_tree_id = 0,
      lft = 0,
      rgt = 0,
      instance_id = 0,
      name = "",
      obs = "",
      geotag = "",
   }

   return content
end


function insert_node_location_tree(content_, origin_, position_) -- Inclui novo noh
   --[[   content_ deve conter o app_id a ser inserido na inclusao.
      Se origin_ for nulo, entao deve ser a primeira entrada na arvore.
      position pode ter os valores: 0 -> antes; 1 -> abaixo; 2 -> depois.
   ]]
   position_ = position_ or 1 
   local lft, rgt, newLft, newRgt, condLft, confRgt, root_id
   local content = {}

--print("position = "..position_)
   if origin_ then
      -- usuario deu a origem, entao verifica se ela existe
      content = query ("itvision_location_tree", "location_tree_id = ".. origin_)
--print("origin = "..origin_)
   else
      -- usuario disse que é a primeira entrada. Isto eh verdade ou a arvore jah existe?
      root_id, content = select_root_location_tree()
--print("auto set root_id = "..root_id)
   end

   if not origin_ and root_id == nil then
      newLft = 1
      newRgt = 2
--print("1 - lft, rgt = ", newLft, newRgt)

   elseif content[1] == nil then
      return false, error_message(1)

   else
      lft = tonumber(content[1].lft)
      rgt = tonumber(content[1].rgt)

--print("2 - lft, rgt, newLft, newRgt = ", lft, rgt, newLft, newRgt)
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
--print("position = 2")
--print("newLft, newRgt, condLft, conRgt = ", newLft, newRgt, condLft, condRgt)
   end
--print("3 - lft, rgt = ", newLft, newRgt)

   content_.lft    = newLft
   content_.rgt    = newRgt

   execute ( "LOCK TABLE itvision_location_tree WRITE" )
   if origin_ then
      -- devido a set do tipo "lft = lft + 2" tive que usar execute() e nao update()
      execute("update itvision_location_tree set lft = lft + 2 where "..condLft)
      execute("update itvision_location_tree set rgt = rgt + 2 where "..condRgt)
--print("update itvision_location_tree set lft = lft + 2 where "..condLft)
--print("update itvision_location_tree set rgt = rgt + 2 where "..condRgt)
   end
   insert  ( "itvision_location_tree", content_)
   execute ( "UNLOCK TABLES" )

   return true, error_message(5) 
end


function select_root_location_tree () -- Seleciona o noh raiz da arvore
   local root = query ("itvision_location_tree", "lft = 1")
   if root[1] then
      return root[1].location_tree_id, root
   else
      return nil, nil
   end
end


function select_full_path_location_tree (origin) -- Seleciona toda sub-arvore a patir de um noh de origem
   local root_id, root = {}
   root_id, root = select_root_location_tree()
   origin = origin or root_id
   local content = {}

   columns   = "node.location_tree_id, node.instance_id, node.lft, node.rgt, node.name, node.geotag, node.obs"
   tablename = "itvision_location_tree AS node, itvision_location_tree AS parent"
   cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND parent.location_tree_id = " .. origin
   extra     = "ORDER BY node.lft"

   content = query (tablename, cond, extra, columns)

   return content
end


function select_leaf_nodes_location_tree () -- Seleciona todas as folhas da arvore
   local content = {}

   columns   = "*"
   tablename = "itvision_location_tree"
   cond      = "rgt = lft + 1"
   extra     = "ORDER BY lft"

   content = query (tablename, cond, extra, columns)

   return content
end


function select_simple_path_location_tree (origin) -- Seleciona um unico caminho partindo de um noh 
                     -- ateh o topo da arvore
   local root_id, root = {}
   root_id, root = select_root_location_trelocation_tree
   origin = origin or root_id
   local content = {}

   columns   = "parent.location_tree_id, parent.instance_id, parent.lft, parent.rgt, parent.app_id"
   tablename = "itvision_location_tree AS node, itvision_location_tree AS parent"
   cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.location_tree_id = " .. origin
   extra     = "ORDER BY parent.lft"

   content = query (tablename, cond, extra, columns)

   return content
end


function select_depth_location_tree (origin) -- Seleciona a profundidade de cada noh
   local root_id, root = {}
   root_id, root = select_root_location_tree()
   origin = origin or root_id
   local content = {}

   columns   = [[ node.location_tree_id, node.instance_id, node.lft, node.rgt, node.app_id, 
            (COUNT(parent.location_tree_id) - 1) AS depth ]]
   tablename = "itvision_location_tree AS node, itvision_location_tree AS parent"
   cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.location_tree_id = " .. origin
   extra     = "GROUP BY node.location_tree_id ORDER BY parent.lft"

   content = query (tablename, cond, extra, columns)

   return content
end


function select_depth_subtree_location_tree (origin) -- Seleciona a profundidade de cada noh a partir de 
                  -- um noh especifico
   local root_id, root = {}
   root_id, root = select_root_location_tree()
   origin = origin or root_id
   local content = {}

   columns   = [[ node.location_tree_id, node.instance_id, node.lft, node.rgt, node.app_id,
            (COUNT(parent.location_tree_id) - (sub_tree.depth + 1)) AS depth ]]
   tablename = [[ itvision_location_tree AS node, itvision_location_tree AS parent, itvision_location_tree AS sub_parent
            (   SELECT node.location_tree_id, (COUNT(parent.location_tree_id) - 1) AS depth
            FROM itvision_location_tree AS node, itvision_location_tree AS parent
            WHERE node.lft BETWEEN parent.lft AND parent.rgt
            AND node.location_tree_id = ]] .. origin .. [[
            GROUP BY node.location_tree_id
            ORDER BY node.lft
            ) AS sub_tree ]]
   cond      = [[ node.lft BETWEEN parent.lft AND parent.rgt
            AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
            AND sub_parent.location_tree_id = sub_tree.location_tree_id ]]
   extra     = "GROUP BY node.location_tree_id ORDER BY node.lft"

   content = query (tablename, cond, extra, columns)

   return content
end


function select_subrdinates_location_tree (origin) -- Encontra o noh subordinado imediato
   local root_id, root = {}
   root_id, root = select_root_location_tree()
   origin = origin or root_id
   local content = {}

   columns   = [[ node.location_tree_id, node.instance_id, node.lft, node.rgt, node.app_id,
            (COUNT(parent.location_tree_id) - (sub_tree.depth + 1)) AS depth ]]
   tablename = [[ itvision_location_tree AS node, itvision_location_tree AS parent, itvision_location_tree AS sub_parent
            (   SELECT node.location_tree_id, (COUNT(parent.location_tree_id) - 1) AS depth
            FROM itvision_location_tree AS node,
            itvision_location_tree AS parent
            WHERE node.lft BETWEEN parent.lft AND parent.rgt
            AND node.location_tree_id = ]] .. origin .. [[
            GROUP BY node.location_tree_id
            ORDER BY node.lft
            ) AS sub_tree ]]
   cond      = [[ node.lft BETWEEN parent.lft AND parent.rgt
            AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
            AND sub_parent.location_tree_id = sub_tree.location_tree_id ]]
   extra     = [[ GROUP BY node.location_tree_id HAVING depth <= 1 ORDER BY node.lft ]]


   content = query (tablename, cond, extra, columns)

   return content
end


function delete_location_tree (origin) -- remove um noh dado por 'origin'
   -- TODO: !
   return false
end


function move_location_tree(origin, destiny) -- move um ramo de arvore para outro noh
   -- TODO: !
   return false
end


