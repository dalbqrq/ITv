module (..., package.seeall);

require "messages"
require "util"

local m = require "model_access"


----------------------------- HOSTS ----------------------------------

function select_host (cond_, extra_, columns_) 
   local content = m.select ("nagios_hosts", cond_, extra_, columns_)
   return content
end


function select_host_object (cond_, extra_, columns_)
   if cond_ then cond_ = " and "..cond_ else cond_ = "" end
   cond_ = cond_ .. " and o.name1 NOT LIKE 'business_processes%' " -- retira "dummy hosts" criados pelo BP
   local content = m.select ("nagios_hosts h, nagios_objects o ", "h.host_object_id = o.object_id"..cond_,
      extra_, columns_)
   return content
end


----------------------------- SERVICES ----------------------------------

function get_bp_id () -- usado para selecionar os 'services' que sao aplicacoes
   local content = m.select ("nagios_objects", "name1 = 'check_bp_status'", extra_, columns_)
   return content[1].object_id
end


function select_service (cond_, extra_, columns_, app)
   if app ~= nil then app = " = " else app = " <> " end
   if cond_ ~= nil then cond_ = " and "..cond_ else cond_ = "" end
   local bp_id = get_bp_id()
   local content = m.select ("nagios_services", "check_command_object_id"..app..bp_id..cond_, 
      extra_, columns_)
   return content
end


-- Exemplo de uso: t = r.select_service_object (nil, nil, nil, true)
function select_service_object (cond_, extra_, columns_, app)
   if app ~= nil then app = " = " else app = " <> " end
   if cond_ then cond_ = " and "..cond_ else cond_ = "" end
   extra_ = "order by o.name1, o.name2" -- ignorando outros "extras" para ordenar pelo host. Pode ser melhorado!
   local bp_id = get_bp_id()
   local content = m.select ("nagios_services s, nagios_objects o ", 
      "s.service_object_id = o.object_id and s.check_command_object_id"..app..bp_id..cond_, 
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


----------------------------- APP ----------------------------------

function select_app (cond_, extra_, columns_)
   local content = m.select ("itvision_apps", cond_, extra_, columns_)
   return content
end


function insert_app (content_)
   local table_ = "itvision_apps"
   m.insert (table_, content_)
   
   local content = m.select(table_, "name = '"..content_.name.."'")
   
   return content
end


----------------------------- APP LIST ----------------------------------

function select_app_list (cond_, extra_, columns_)
   local content = m.select ("itvision_app_list", cond_, extra_, columns_)
   return content
end


function select_objects_app_list (cond_, extra_, columns_)
   local content = m.select ("itvision_app_list", cond_, extra_, columns_)
   return content
end

function select_app_app_list_objects (id)
   local cond_ = "no.object_id = al.object_id and al.app_id = ap.app_id"
   if id then
      cond_ = cond_ .. " and ap.app_id = "..id
   end
   local tables_ = "nagios_objects no, itvision_app_list al, itvision_apps ap"
   local columns_ = [[
      no.object_id, no.objecttype_id, no.name1, no.name2,
      al.type as list_type,
      ap.app_id, ap.name as app_name, ap.type as app_type, ap.is_active, ap.service_object_id as service_id ]]
   local extra_ = "order by ap.app_id, no.name1, no.name2"
   local content = m.select (tables_, cond_, extra_, columns_)
   return content
end

function insert_app_list (content_)
   local table_ = "itvision_app_list"
   m.insert (table_, content_)
   
   local content = m.select(table_, "app_id = '"..content_.app_id.."'")
   
   return content
end


----------------------------- APP RELAT ----------------------------------

function select_app_relat (cond_, extra_, columns_)
   local content = m.select ("itvision_app_relat", cond_, extra_, columns_)
   return content
end


function insert_app_relat (content_)
   local table_ = "itvision_app_relat"
   m.insert (table_, content_)
   
   local content = m.select(table_, "app_id = "..content_.app_id.." and "..
      "from_object_id = "..content_.from_object_id..
      " and to_object_id = "..content_.to_object_id)
   
   return content
end


----------------------------- APP TREE ----------------------------------
--[[
   Nested Set Model
   see: http://dev.mysql.com/tech-resources/articles/hierarchical-data.html
]]


function table_app_tree() -- Create table structure
   local content = {
      app_tree_id = 0,
      lft = 0,
      rgt = 0,
      app_list_id = "NULL",
      app_tree_type = "NULL",
      is_active = 0,
      instance_id = 0,
      service_id = "NULL",
      name = ""
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
      content = m.select ("itvision_app_tree", "app_tree_id = ".. origin_)
   else
      -- usuario disse que é a primeira entrada. Isto eh verdade ou a arvore jah existe?
      root_id, content = select_root_app_tree()
   end

   if not origin_ and root_id == nil then
      newLft = 1
      newRgt = 2

   elseif content[1] == nil then
      return false, message(1)

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

   m.execute ( "LOCK TABLE itvision_app_tree WRITE" )
   if origin_ then
      -- devido a set do tipo "lft = lft + 2" tive que usar m.execute() e nao m.update()
      m.execute("update itvision_app_tree set lft = lft + 2 where lft = "..condLft)
      m.execute("update itvision_app_tree set rgt = rgt + 2 where rgt = "..condRgt)
   end
   m.insert  ( "itvision_app_tree", content_)
   m.execute ( "UNLOCK TABLES" )

   return true, message(2) 
end


function select_root_app_tree () -- Seleciona o noh raiz da arvore
   local root = m.select ("itvision_app_tree", "lft = 1")
   if root[1] then
      return root[1].app_tree_id, root
   else
      return nil, nil
   end
end


function select_full_path_app_tree (origin) -- Seleciona toda sub-arvore a patir de um noh de origem
   local root_id, root = {}
   root_id, root = select_root_app_tree()
   origin = origin or root_id
   local content = {}

   columns   = "node.app_tree_id, node.instance_id, node.lft, node.rgt, node.app_id"
   tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
   cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND parent.app_tree_id = " .. origin
   extra     = "ORDER BY node.lft"

   content = m.select (tablename, cond, extra, columns)

   return content
end


function select_leaf_nodes_app_tree () -- Seleciona todas as folhas da arvore
   local content = {}

   columns   = "*"
   tablename = "itvision_app_tree"
   cond      = "rgt = lft + 1"
   extra     = "ORDER BY lft"

   content = m.select (tablename, cond, extra, columns)

   return content
end


function select_simple_path_app_tree (origin) -- Seleciona um unico caminho partindo de um noh 
                     -- ateh o topo da arvore
   local root_id, root = {}
   root_id, root = select_root_app_tree()
   origin = origin or root_id
   local content = {}

   columns   = "parent.app_tree_id, parent.instance_id, parent.lft, parent.rgt, parent.app_id"
   tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
   cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.app_tree_id = " .. origin
   extra     = "ORDER BY parent.lft"

   content = m.select (tablename, cond, extra, columns)

   return content
end


function select_depth_app_tree (origin) -- Seleciona a profundidade de cada noh
   local root_id, root = {}
   root_id, root = select_root_app_tree()
   origin = origin or root_id
   local content = {}

   columns   = [[ node.app_tree_id, node.instance_id, node.lft, node.rgt, node.app_id, 
            (COUNT(parent.app_tree_id) - 1) AS depth ]]
   tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
   cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.app_tree_id = " .. origin
   extra     = "GROUP BY node.app_tree_id ORDER BY parent.lft"

   content = m.select (tablename, cond, extra, columns)

   return content
end


function select_depth_subtree_app_tree (origin) -- Seleciona a profundidade de cada noh a partir de 
                  -- um noh especifico
   local root_id, root = {}
   root_id, root = select_root_app_tree()
   origin = origin or root_id
   local content = {}

   columns   = [[ node.app_tree_id, node.instance_id, node.lft, node.rgt, node.app_id,
            (COUNT(parent.app_tree_id) - (sub_tree.depth + 1)) AS depth ]]
   tablename = [[ itvision_app_tree AS node, itvision_app_tree AS parent, itvision_app_tree AS sub_parent
            (   SELECT node.app_tree_id, (COUNT(parent.app_tree_id) - 1) AS depth
            FROM itvision_app_tree AS node, itvision_app_tree AS parent
            WHERE node.lft BETWEEN parent.lft AND parent.rgt
            AND node.app_tree_id = ]] .. origin .. [[
            GROUP BY node.app_tree_id
            ORDER BY node.lft
            ) AS sub_tree ]]
   cond      = [[ node.lft BETWEEN parent.lft AND parent.rgt
            AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
            AND sub_parent.app_tree_id = sub_tree.app_tree_id ]]
   extra     = "GROUP BY node.app_tree_id ORDER BY node.lft"

   content = m.select (tablename, cond, extra, columns)

   return content
end


function select_subrdinates_app_tree (origin) -- Encontra o noh subordinado imediato
   local root_id, root = {}
   root_id, root = select_root_app_tree()
   origin = origin or root_id
   local content = {}

   columns   = [[ node.app_tree_id, node.instance_id, node.lft, node.rgt, node.app_id,
            (COUNT(parent.app_tree_id) - (sub_tree.depth + 1)) AS depth ]]
   tablename = [[ itvision_app_tree AS node, itvision_app_tree AS parent, itvision_app_tree AS sub_parent
            (   SELECT node.app_tree_id, (COUNT(parent.app_tree_id) - 1) AS depth
            FROM itvision_app_tree AS node,
            itvision_app_tree AS parent
            WHERE node.lft BETWEEN parent.lft AND parent.rgt
            AND node.app_tree_id = ]] .. origin .. [[
            GROUP BY node.app_tree_id
            ORDER BY node.lft
            ) AS sub_tree ]]
   cond      = [[ node.lft BETWEEN parent.lft AND parent.rgt
            AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
            AND sub_parent.app_tree_id = sub_tree.app_tree_id ]]
   extra     = [[ GROUP BY node.app_tree_id HAVING depth <= 1 ORDER BY node.lft ]]


   content = m.select (tablename, cond, extra, columns)

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


