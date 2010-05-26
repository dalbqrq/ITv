module (..., package.seeall);

require "messages"
require "util"

local m = require "model_access"

----------------------------- HOSTS ----------------------------------

function select_hosts ()
	local content = m.select ("nagios_hosts")
	return content
end


function select_hosts_objects ()
	local content = m.select ("nagios_hosts h, nagios_objects o ", "h.host_object_id = o.object_id")
	return content
end

----------------------------- SERVICES ----------------------------------

function select_services (app)
	if app ~= nil then app = " = " else app = " <> " end
	local bp_id = m.get_bp_id()
	local content = m.select ("nagios_services", "check_command_object_id"..app..bp_id)
	return content
end


function select_service_objects (app)
	if app ~= nil then app = " = " else app = " <> " end
	local bp_id = m.get_bp_id()
	local content = m.select ("nagios_services s, nagios_objects o ", 
		"s.service_object_id = o.object_id and s.check_command_object_id"..app..bp_id)
	return content
end

----------------------------- SERVICE APP ----------------------------------

function select_service_apps ()
	return select_services ("app")
end


function select_service_app_objects ()
	return select_service_objects ("app")
end


----------------------------- APP ----------------------------------

function select_apps (cond_, extra_, columns_)
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

function select_app_lists (cond_, extra_, columns_)
	local content = m.select ("itvision_app_list", cond_, extra_, columns_)
	return content
end


function insert_app_list (content_)
	local table_ = "itvision_app_list"
	m.insert (table_, content_)
	
	local content = m.select(table_, "app_id = '"..content_.app_id.."'")
	
	return content
end



---------------------- NESTED SET MODEL for APP TREE -----------------------------
--
-- see: http://dev.mysql.com/tech-resources/articles/hierarchical-data.html
--
--


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
	--[[	content_ deve conter o app_id a ser inserido na inclusao.
		Se origin_ for nulo, entao deve ser a primeira entrada na arvore.
		position pode ter os valores: 0 -> antes; 1 -> abaixo; 2 -> depois.
	]]
	position_ = position_ or 1 
	local newLft, newRgt, content = {}
	local updateLft_ = {}
	local updateRgt_ = {}

	if origin_ then
		-- usuario deu a origem, entao verifica se ela existe
		content = m.select ("itvision_app_tree", "app_tree_id = ".. origin_)
	else
		-- usuario disse que é a primeira entrada. Isto eh verdade ou a arvore jah existe?
		content = select_root_app_tree()
	end

	if not origin_ and content[1] == nil then
		newLft = 1
		newRgt = 2

	elseif content[1] == nil then
		return false, message(1)

	else
		lft = tonumber(content[1].lft)
		rgt = tonumber(content[1].rgt)
		print(lft, rgt)

		if position == 0 then
			newLft = lft
			newRgt = lft + 1
			condLft = "lft >= " .. lft
			condRgt = "rgt >= " .. lft

		elseif position == 1 then
			newLft = rgt
			newRgt = rgt + 1
			condLft = "lft >  " .. rgt
			condRgt = "rgt >= " .. rgt

		elseif position == 2 then
			newLft = rgt + 1
			newRgt = rgt + 2
			condLft = "lft > " .. lft
			condRgt = "rgt > " .. rgt

		end

		updateLft_.lft = "lft + 2"
		updateRgt_.rgt = "rgt + 2"

	end

	content_.lft   = newLft
	content_.rgt   = newRgt

	--local cat = table.cat(content_)

	m.execute ( "LOCK TABLE itvision_app_tree WRITE" )
	if origin_ then
		m.update  ( "itvision_app_tree", updateLft_, condLft )
		m.update  ( "itvision_app_tree", updateRgt_, condRgt )
		--print("update itvision_app_tree set lft = "..updateLft_.lft.." where "..condLft)
		--print("update itvision_app_tree set rgt = "..updateRgt_.rgt.." where "..condRgt)
	end
	m.insert  ( "itvision_app_tree", content_ )
	--print  ( "insert into itvision_app_tree values (".. cat ..")" )
	m.execute ( "UNLOCK TABLES" )

	return true, message(2) 
end


function select_root_app_tree () -- Seleciona o noh raiz da arvore
	local root = m.select ("itvision_app_tree", "lft = 1")
	return root
end


function select_full_path_app_tree (origin) -- Seleciona toda sub-arvore a patir de um noh de origem
	root = select_root_app_tree()
	origin = origin or root.app_tree_id
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
	root = select_root_app_tree()
	origin = origin or root.app_tree_id
	local content = {}

	columns   = "parent.app_tree_id, parent.instance_id, parent.lft, parent.rgt, parent.app_id"
	tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
	cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.app_tree_id = " .. origin
	extra     = "ORDER BY parent.lft"

	content = m.select (tablename, cond, extra, columns)

	return content
end


function select_depth_app_tree (origin) -- Seleciona a profundidade de cada noh
	root = select_root_app_tree()
	origin = origin or root.app_tree_id
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
	root = select_root_app_tree()
	origin = origin or root.app_tree_id
	local content = {}

	columns   = [[ node.app_tree_id, node.instance_id, node.lft, node.rgt, node.app_id,
			(COUNT(parent.app_tree_id) - (sub_tree.depth + 1)) AS depth ]]
	tablename = [[ itvision_app_tree AS node, itvision_app_tree AS parent, itvision_app_tree AS sub_parent
			(	SELECT node.app_tree_id, (COUNT(parent.app_tree_id) - 1) AS depth
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
	root = select_root_app_tree()
	origin = origin or root.app_tree_id
	local content = {}

	columns   = [[ node.app_tree_id, node.instance_id, node.lft, node.rgt, node.app_id,
			(COUNT(parent.app_tree_id) - (sub_tree.depth + 1)) AS depth ]]
	tablename = [[ itvision_app_tree AS node, itvision_app_tree AS parent, itvision_app_tree AS sub_parent
			(	SELECT node.app_tree_id, (COUNT(parent.app_tree_id) - 1) AS depth
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


--init_app_tree()

--[[
if insert_node_app_tree(nil, 14, 1) then
	print("done")
else
	print("not done")
end
]]


--[[

print("---------------------------------")

tab = select_columns("itvision_app_tree")
select_hosts()

t = select_full_path_app_tree("0")

for i, v in ipairs(t) do
	print (v)
end

print("---------------------------------")
]]





