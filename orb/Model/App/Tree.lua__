
require "util"
require "messages"


----------------------------- APP TREE ----------------------------------
--[[
   Nested Set Model
   see: http://dev.mysql.com/tech-resources/articles/hierarchical-data.html

----------------------------------------------------------------------------------------------------------------------
function new_app_tree() -- Create table structure
function show_app_tree()
function find_node_id(app_id, conected_to_root)

----------------------------------------------------------------------------------------------------------------------
function select_root_app_tree () 		-- Seleciona o noh raiz da arvore
function select_root_name_app_tree ()		-- Seleciona o nome do noh raiz da arvore
function select_full_path_app_tree (origin) 	-- Seleciona toda sub-arvore a patir de um noh de origem
function select_leaf_nodes_app_tree () 		-- Seleciona todas as folhas da arvore
function select_simple_path_app_tree (origin) 	-- Seleciona um unico caminho partindo de um noh 
function select_depth_app_tree (origin) 	-- Seleciona a profundidade de cada noh
function select_depth_subtree_app_tree (origin) -- Seleciona a profundidade de cada noh a partir de um noh especifico
function select_subordinates_app_tree (origin, app_id) 	-- Encontra o noh subordinado imediato
function select_parent (app_id)                 -- Encontra noh pai 
function select_tree_relat_to_graph() 		-- Lista apps e seus filhos
function select_uniq_app_in_tree()  		-- seleciona app unico na árvore (usado p/ config do nagiosbp)
function select_child_from_parent(app_child, app_parent) -- seleciona noh dado por pai e filho na arvore

----------------------------------------------------------------------------------------------------------------------
function insert_node_app_tree(app_id, origin_, position_) -- Inclui novo noh
function insert_subnode_app_tree(app_child, app_parent)   -- Adiciona nós filhos abaixo de todos os nos que possuiem app_id = app_parent

----------------------------------------------------------------------------------------------------------------------
function delete_node_app_tree(origin_)		-- remove toda sub-arvore abaixo de origin_
function delete_node_app(origin_)		-- remove um noh dado por 'origin_' trazendo toda a sub-arvore para o pai de 'origin_'
function delete_node_app_conected_to_root(app_id)

----------------------------------------------------------------------------------------------------------------------
function move_app_tree(origin, destiny)		-- move um ramo de arvore para outro noh


]]


----------------------------------------------------------------------------------------------------------------------
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


----------------------------------------------------------------------------------------------------------------------
function show_app_tree()
--select name, lft, rgt, t.id, app_id from itvision_app_trees t, itvision_apps a where t.app_id = a.id;
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
   

----------------------------------------------------------------------------------------------------------------------
function find_node_id(app_id, conected_to_root)
   local cond = ""

   if conected_to_root then 
      local node = select_subordinates_app_tree (nil, app_id)
      if node[1] then
         cond = " id = "..node[1].id.." and "
      end
   end

   local content = query ("itvision_app_trees", cond.." app_id = "..app_id)
   return content
end


----------------------------------------------------------------------------------------------------------------------
function is_last_subapp (app_id, conected_to_root) -- verifica se app é unica na arvore
   -- caso flag 'conected_to_root' ligada então verifica também se app está ligada diretamente a root
   local is_connected = select_subordinates_app_tree (nil, app_id)
   local root = query ("itvision_app_trees", "app_id = "..app_id, nil, "count(app_id) as count, id")

   if tonumber(root[1].count) == 1 and ((conected_to_root and is_connected[1]) or (not conected_to_root)) then
      return true, root[1].id
   else
      return false, nil
   end
end


----------------------------------------------------------------------------------------------------------------------
function select_root_app_tree () -- Seleciona o noh raiz da arvore
   local root = query ("itvision_app_trees", "lft = 1")
   if root[1] then
      return root[1].id, root[1]
   else
      return nil, nil
   end
end



----------------------------------------------------------------------------------------------------------------------
function select_root_entity_tree (entity_id) -- Seleciona o noh raiz de uma entidade
   local root = query ("itvision_apps a, itvision_app_trees t", 
             "a.id = t.app_id and is_entity_root = 1 and entities_id = "..entity_id, 
              nil, "t.id, t.entity_id, t.lft, t.rgt" )
   if root[1] then
      return root[1].id, root[1]
   else
      return nil, nil
   end
end



----------------------------------------------------------------------------------------------------------------------
function select_root_name_app_tree () -- Seleciona o nome do noh raiz da arvore
   local root = query ("itvision_app_trees t, itvision_apps a", "a.id = t.app_id and t.lft = 1", nil, "a.name, a.id, a.entities_id")
   if root[1] then
      return root[1].id, root[1]
   else
      return nil, nil
   end
end

----------------------------------------------------------------------------------------------------------------------
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
   cond      = [[node.lft BETWEEN parent.lft AND parent.rgt AND parent.id = ]]..origin..[[
               AND node.app_id = app.id AND parent.app_id = papp.id]]
   extra     = [[ORDER BY node.lft]]

   content = query (tablename, cond, extra, columns)

   return content
end


----------------------------------------------------------------------------------------------------------------------
function select_leaf_nodes_app_tree () -- Seleciona todas as folhas da arvore
   local content = {}

   columns   = "*"
   tablename = "itvision_app_trees"
   cond      = "rgt = lft + 1"
   extra     = "ORDER BY lft"

   content = query (tablename, cond, extra, columns)

   return content
end


----------------------------------------------------------------------------------------------------------------------
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


----------------------------------------------------------------------------------------------------------------------
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


----------------------------------------------------------------------------------------------------------------------
function select_depth_subtree_app_tree (origin) -- Seleciona a profundidade de cada noh a partir de um noh especifico
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


----------------------------------------------------------------------------------------------------------------------
function select_subordinates_app_tree (origin, app_id) -- Encontra o noh subordinado imediato
   local root_id, root = {}
   root_id, root = select_root_app_tree()
   origin = origin or root_id
   local content = {}

   columns   = [[ node.id as id, node.instance_id as instante_id, node.lft as lft, node.rgt as rgt, 
            node.app_id as app_id, (COUNT(parent.id) - (sub_tree.depth + 1)) AS depth ]]
   tablename = [[ itvision_app_trees AS node, itvision_app_trees AS parent, itvision_app_trees AS sub_parent, 
                  itvision_apps AS a,
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
            AND sub_parent.id = sub_tree.id
            AND node.app_id = a.id AND a.is_active = 1 ]]
   extra     = [[ GROUP BY node.id HAVING depth = 1 ORDER BY node.lft ]]
   --extra     = [[ GROUP BY node.id HAVING depth <= 1 ORDER BY node.lft ]]

   if app_id then cond = cond.." and a.id = "..app_id end

   content = query (tablename, cond, extra, columns)
   return content
end



----------------------------------------------------------------------------------------------------------------------
function select_parent (app_id) -- Encontra noh pai - usado tipicamente para a inclusao de apps 
                  -- que representam entidades atraves de processo executado pelos scripts cron

   -- retorna as entradas em order inversa sendo as primeiras tupla os ascendentes mais proximos
   local content = {}

   columns   = "parent.id, parent.instance_id, parent.lft, parent.rgt, parent.app_id, parent.instance_id"
   tablename = "itvision_app_trees AS node, itvision_app_trees AS parent"
   cond      = "parent.lft < node.lft AND parent.rgt > node.rgt AND node.app_id = " .. app_id
   extra     = "order by parent.lft desc"

   content = query (tablename, cond, extra, columns)

   return content
end


----------------------------------------------------------------------------------------------------------------------
function select_tree_relat_to_graph(clause) -- Lista apps e seus filhos
   local content = {}
      columns   = [[ t.id as id, lft, rgt, app_id ]]
      tablename = [[ itvision_app_trees t, itvision_apps a ]]
      cond      = [[  a.id = t.app_id
         and a.is_active = 1 and a.service_object_id is not null ]]
      if clause then cond = cond.." and "..clause end
   local nodes = query(tablename, cond, nil, columns)

   for i,v in ipairs(nodes) do
      columns   = [[ child.id, child.app_id, child.lft, child.rgt ]]
      tablename = [[ itvision_apps AS a, itvision_app_trees AS child 
         LEFT JOIN itvision_app_trees AS ancestor ON
         ancestor.lft BETWEEN ]]..v.lft..[[+1 AND ]]..v.rgt..[[-1 AND
         child.lft BETWEEN ancestor.lft+1 AND ancestor.rgt-1 ]]
      cond      = [[ child.lft BETWEEN ]]..v.lft..[[+1 AND ]]..v.rgt..[[-1 AND
         ancestor.id IS NULL 
         AND child.app_id = a.id AND a.is_active = 1 ]]

      if clause then cond = cond.." and "..clause end

      local child = query (tablename, cond, nil, columns)
      for j,w in ipairs(child) do
         table.insert(content, { parent_app=v.app_id, parent_id=v.id, child_app=w.app_id, child_id=w.id } )
      end
   end

   return content
end


----------------------------------------------------------------------------------------------------------------------
function select_uniq_app_in_tree()  -- seleciona app unico na árvore (usado p/ config do nagiosbp)

   columns   = [[ distinct(node.app_id) as id, a.name as name, a.type as type, a.is_active as is_active, 
      a.service_object_id as service_object_id, node.lft, node.rgt ]]
   tablename = [[ itvision_app_trees AS node, itvision_app_trees AS parent, itvision_apps AS a ]]
   cond      = [[ node.lft BETWEEN parent.lft AND parent.rgt
      AND parent.id = (select id from itvision_app_trees where lft = 1) 
      AND node.app_id = a.id ]]
   extra     = [[ ORDER BY node.lft desc  ]]

   content = query (tablename, cond, extra, columns)
   content = table.unique_item(content, "id")
   return content
end


----------------------------------------------------------------------------------------------------------------------
function select_child_from_parent(app_child, app_parent) -- seleciona noh dado por pai e filho na arvore

   columns   = [[ node.id as id, node.instance_id as instante_id, node.lft as lft, node.rgt as rgt,
            node.app_id as app_id, (COUNT(parent.id) - (sub_tree.depth + 1)) AS depth ]]
   tablename = [[ itvision_app_trees AS node, itvision_app_trees AS parent, itvision_app_trees AS sub_parent,
                  itvision_apps AS a,
            (   SELECT node.id, (COUNT(parent.id) - 1) AS depth
            FROM itvision_app_trees AS node,
            itvision_app_trees AS parent
            WHERE node.lft BETWEEN parent.lft AND parent.rgt
            AND node.app_id = ]]..app_parent..[[
            GROUP BY node.id
            ORDER BY node.lft
            ) AS sub_tree ]]
   cond     = [[ node.lft BETWEEN parent.lft AND parent.rgt
            AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
            AND sub_parent.id = sub_tree.id
            AND node.app_id = a.id AND a.is_active = 1
            and node.app_id = ]]..app_child
   extra    = [[ GROUP BY node.id HAVING depth = 1 ORDER BY node.lft ]]

   content = query (tablename, cond, extra, columns)
   return content
end

----------------------------------------------------------------------------------------------------------------------
function insert_node_app_tree(app_id, entity, origin_, position_) -- Inclui novo noh
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
      root = content[1]
   else
      -- usuario disse que é a primeira entrada. Isto eh verdade ou a arvore jah existe?
      --root_id, root = select_root_app_tree()
      if not entity then entity = 0 end
      root_id, root = select_root_entity_tree(entity)
   end

   if not origin_ and not root_id then
      newLft = 1
      newRgt = 2

   elseif root == nil then
      return false, error_message(1)

   else
      lft = tonumber(root.lft)
      rgt = tonumber(root.rgt)

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
   node.entity_id = entity
   node.lft = newLft
   node.rgt = newRgt
   node.instance_id = config.database.instance_id

   execute ( "LOCK TABLE itvision_app_trees WRITE" )
   if origin_ or root_id then
      execute("update itvision_app_trees set lft = lft + 2 where "..condLft)
      execute("update itvision_app_trees set rgt = rgt + 2 where "..condRgt)
   end
   insert  ( "itvision_app_trees", node)
   execute ( "UNLOCK TABLES" )

   return true, error_message(2) 
end


----------------------------------------------------------------------------------------------------------------------
function insert_subnode_app_tree(app_child, app_parent) -- Adiciona nós filhos abaixo de todos os nos que possuiem app_id = app_parent
                                  -- isso é feito tipicamente na inclusão de uma app como objeto de outra (subapp)
   local parents = query ("itvision_app_trees", "app_id = "..app_parent)
   local origin  = query("itvision_app_trees", "app_id = "..app_child, nil, "min(id) as id, app_id, lft, rgt, instance_id"); origin = origin[1]
   local subtree = select_full_path_app_tree(origin.id)
   local width = origin.rgt - origin.lft + 1

   execute ( "LOCK TABLE itvision_app_trees WRITE" )
   for i,p in ipairs(parents) do
      execute ( "update itvision_app_trees set lft = lft + "..width.." where lft > "..p.rgt)
      execute ( "update itvision_app_trees set rgt = rgt + "..width.." where rgt >= "..p.rgt)

      for j,n in ipairs(subtree) do
         local lft = n.lft - origin.lft + p.rgt
         local rgt = n.rgt - origin.lft + p.rgt
         local node = { app_id=n.app_id, lft=lft, rgt=rgt, instance_id=n.instance_id, entity_id=n.entity_id }

         insert  ( "itvision_app_trees", node)
      end

   end
   execute ( "UNLOCK TABLES" )

end


----------------------------------------------------------------------------------------------------------------------
function delete_child_from_parent(child_app, parent_app)  -- remove sub aplicacao com suas regras devidas

   local child = select_child_from_parent(child_app, parent_app)
   local is_last, last_id = is_last_subapp(child_app)
   local root_id, root = select_root_app_tree()

   if is_last and ( tonumber(parent_app) ~= tonumber(root.app_id) ) then
      insert_subnode_app_tree(child_app, root.app_id)
      local o = Model.query("nagios_objects", "name1 = '"..config.monitor.check_app.."' and name2 = "..child_app)
      Model.insert("itvision_app_objects", 
         {app_id=parent_app, instance_id=config.database.instance_id, service_object_id=o[1].object_id, type="app"})
      delete_node_app_tree(child[1].id)
      return true
   elseif not is_last then
      -- TODO: delete_node_app_tree(child[1].id)
      return true
   else
      return false
   end

end

----------------------------------------------------------------------------------------------------------------------
function delete_node_app_tree(origin_)  -- remove toda sub-arvore abaixo de origin_
   local lft, rgt, width, root_id
   local content = {}

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


----------------------------------------------------------------------------------------------------------------------
function delete_node_app(origin_) -- remove um noh dado por 'origin_' trazendo toda a sub-arvore para o pai de 'origin_'
   local lft, rgt, width, root_id
   local content = {}

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
   execute ( "delete from itvision_app_trees where lft = "..lft.." and rgt = "..rgt )
   execute ( "update itvision_app_trees set lft = lft - 1 where lft > "..lft )
   execute ( "update itvision_app_trees set lft = lft - 1 where rgt > "..rgt )
   execute ( "update itvision_app_trees set rgt = rgt - 2 where rgt > "..lft )
   execute ( "UNLOCK TABLES" )

   return true
end


----------------------------------------------------------------------------------------------------------------------
function delete_node_app_conected_to_root(app_id)
   local node = select_subordinates_app_tree (nil, app_id)

   if node[1] then
      delete_node_app_tree(node[1].id)
      return true
   else
      return false
   end
end


----------------------------------------------------------------------------------------------------------------------
function move_app_tree(origin, destiny) -- move um ramo de arvore para outro noh
   -- TODO: !
   return false
end



