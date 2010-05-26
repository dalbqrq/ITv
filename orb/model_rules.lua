module (..., package.seeall);

local m = require "model_access"

----------------------------- SERVICES ----------------------------------

function select_services (app)
	if app ~= nil then app = " = " else app = " <> " end
	local db = m.connect()
	local bp_id = m.get_bp_id()
	local content = m.select ("nagios_services", "check_command_object_id"..app..bp_id)
	db:close()
	return content
end


function select_all_service_objects (app)
	if app ~= nil then app = " = " else app = " <> " end
	local db = m.connect()
	local bp_id = m.get_bp_id()
	local content = m.select ("nagios_services s, nagios_objects o ", 
		"s.service_object_id = o.object_id and s.check_command_object_id"..app..bp_id)
	db:close()
	return content
end

----------------------------- APP ----------------------------------

function select_apps ()
	return select_services ("app")
end


function select_all_app_objects ()
	return select_all_service_objects ("app")
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


function init_app_tree() -- Init tree -- Inicia a arvore
	local content = {}
	local db = m.connect()

	--content = db:selectall ("lft", "itvision_app_tree", "lft = 1")
	--content = db:selectall ("lft", "itvision_app_tree", "lft > 0", "order by lft desc limit 1")
	content = m.select ("itvision_app_tree", nil, "order by lft desc limit 1")

	if content[1] == nil then
		content ={}
		content.lft = 1
		content.lft = 2
--		assert ( db:assertexec ( [[
--			INSERT INTO itvision_app_tree(instance_id, service_id, lft, rgt, app_list_id, 
--				app_tree_type, is_active) VALUES ( 0, NULL, 1, 2, NULL, NULL, 0 )
--		]] ))
		m.insert ("itvision_app_tree", content)
		db:close()
		return true
	else
		db:close()
		return false
	end

end


function insert_node_app_tree(content_, origin_, position_) -- Adding New Nodes -- Incluindo novos noh
	origin_ = origin_ or 0
	position_ = position_ or 1 -- 0 : anter; 1 : abaixo; 2 : depois
	local db = m.connect()
	local newLft, newRgt

	local content = m.select ("itvision_app_tree", "app_tree_id = ".. origin_)

	if origin_ == 0 then
		newLft = 1
		newRgt = 2

	elseif content[1] == nil then
		print("origin not found")
		res = false

	else
		res = true
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

		content_.lft   = newLft
		content_.rgt   = newRgt
		updateLft_.lft = "lft + 2"
		updateRgt_.rgt = "rgt + 2"

	end

	--assert ( m.execute ( "LOCK TABLE itvision_app_tree WRITE" ))
	if origin_ ~= 0 then
		--assert ( m.update  ( "itvision_app_tree", update_, condLft ))
		--assert ( m.update  ( "itvision_app_tree", update_, condRgt ))
		print("update itvision_app_tree set lft = "..updateLft_.lft.." where "..condLft)
		print("update itvision_app_tree set rgt = "..updateRgt_.rgt.." where "..condRgt)
	end
	--assert ( m.insert  ( "itvision_app_tree", content_ ))
	print  ( "insert into ".. table.concat(content_," ") )
	--assert ( m.execute ( "UNLOCK TABLES" ))

	db:close()
	return res
end


-- Retrieving a Full Tree
-- Seleciona toda sub-arvore a patir de um noh de origem
function select_full_path_app_tree (origin)
	origin = origin or "1"
	local db = m.connect()
	local content = {}

	columns   = [[ node.app_tree_id, node.instance_id, node.service_id, node.lft,
			node.rgt, node.app_list_id, node.app_tree_type, node.is_active ]]
	tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
	cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND parent.app_tree_id = " .. origin
	extra     = "ORDER BY node.lft"

	content = db:selectall (columns, tablename, cond, extra)

	db:close()
	return content
end


-- Finding all the Leaf Nodes
-- Seleciona todas as folhas da arvore
function select_leaf_nodes_app_tree ()
	local db = m.connect()
	local content = {}

	columns   = [[ app_tree_id, instance_id, service_id, lft,
			rgt, app_list_id, app_tree_type, is_active ]]
	tablename = "itvision_app_tree"
	cond      = "rgt = lft + 1"
	extra     = "ORDER BY lft"

	content = db:selectall (columns, tablename, cond, extra)

	db:close()
	return content
end


-- Retrieving a Single Path
-- Seleciona um unico caminho partindo de um noh ateh o topo da arvore
function select_simple_path_app_tree (origin)
	origin = origin or "1"
	local db = m.connect()
	local content = {}

	columns   = [[ parent.app_tree_id, parent.instance_id, parent.service_id, parent.lft,
			parent.rgt, parent.app_list_id, parent.app_tree_type, parent.is_active ]]
	tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
	cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.app_tree_id = " .. origin
	extra     = "ORDER BY parent.lft"

	content = db:selectall (columns, tablename, cond, extra)

	db:close()
	return content
end


-- Finding the Depth of the Nodes
-- Seleciona a profundidade de cada noh
function select_depth_app_tree (origin)
	origin = origin or "1"
	local db = m.connect()
	local content = {}

	columns   = [[ node.app_tree_id, node.instance_id, node.service_id, node.lft,
			node.rgt, node.app_list_id, node.app_tree_type, node.is_active, 
			(COUNT(parent.app_tree_id) - 1) AS depth ]]
	tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
	cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.app_tree_id = " .. origin
	extra     = "GROUP BY node.app_tree_id ORDER BY parent.lft"

	content = db:selectall (columns, tablename, cond, extra)

	db:close()
	return content
end


-- Finding the Depth of a Sub-Tree
-- Seleciona a profundidade de cada noh a partir de um noh especifico
function select_depth_subtree_app_tree (origin)
	origin = origin or "1"
	local db = m.connect()
	local content = {}

	columns   = [[ node.app_tree_id, node.instance_id, node.service_id, node.lft,
			node.rgt, node.app_list_id, node.app_tree_type, node.is_active, 
			(COUNT(parent.app_tree_id) - (sub_tree.depth + 1)) AS depth ]]
	tablename = [[ itvision_app_tree AS node, itvision_app_tree AS parent, itvision_app_tree AS sub_parent
			(	SELECT node.app_tree_id, (COUNT(parent.app_tree_id) - 1) AS depth
				FROM itvision_ap_tree AS node, itvision_ap_tree AS parent
				WHERE node.lft BETWEEN parent.lft AND parent.rgt
				AND node.app_tree_id = ]] .. origin .. [[
				GROUP BY node.app_tree_id
				ORDER BY node.lft
			) AS sub_tree ]]
	cond      = [[ node.lft BETWEEN parent.lft AND parent.rgt
			AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
			AND sub_parent.app_tree_id = sub_tree.app_tree_id ]]
	extra     = "GROUP BY node.app_tree_id ORDER BY node.lft"

	content = db:selectall (columns, tablename, cond, extra)

	db:close()
	return content
end


-- Find the Immediate Subordinates of a Node
-- Encontra o noh subordinado imediato
function select_subrdinates_app_tree (origin)
	origin = origin or "1"
	local db = m.connect()
	local content = {}

	columns   = [[ node.app_tree_id, node.instance_id, node.service_id, node.lft,
			node.rgt, node.app_list_id, node.app_tree_type, node.is_active, 
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


	content = db:selectall (columns, tablename, cond, extra)

	db:close()
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
select_all_hosts()

t = select_full_path_app_tree("0")

for i, v in ipairs(t) do
	print (v)
end

print("---------------------------------")
]]





