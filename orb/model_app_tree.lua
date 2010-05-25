
local dado = require "dado"


---------------------- NESTED SET MODEL for APP TREE -----------------------------
--
-- see: http://dev.mysql.com/tech-resources/articles/hierarchical-data.html
--
--

-- Create table structure
function table_app_tree()
	local t = {
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

	return t
end

function open_app_tree_db()
	return dado.connect ("ndoutils", "ndoutils", "itv", "mysql")
end


-- Init tree
-- Inicia a arvore
function init_app_tree()
	local t = {}
	local db = open_app_tree_db()

	--t = db:selectall ("lft", "itvision_app_tree", "lft = 1")
	t = db:selectall ("lft", "itvision_app_tree", "lft > 0", "order by lft desc limit 1")

	if t[1] == nil then
		assert ( db:assertexec ( [[
			INSERT INTO itvision_app_tree(instance_id, service_id, lft, rgt, app_list_id, 
				app_tree_type, is_active) VALUES ( 0, NULL, 1, 2, NULL, NULL, 0 )
		]] ))
		db:close()
		return true
	else
		db:close()
		return false
	end

end


-- Adding New Nodes
-- Incluindo novos noh
function insert_node_app_tree(t, origin, position)
	origin = origin or 1
	position = position or 1 -- 0 : anter; 1 : abaixo; 2 : depois
	local t = {}
	local db = open_app_tree_db()

	assert ( db:assertexec ("LOCK TABLE itvision_app_tree WRITE"))
	t = db:selectall ("lft, rgt", "itvision_app_tree", "app_tree_id = ".. origin)

	if t[1] == nil then
		print("origin not found")
		res = false
	else
		res = true
		lft = tonumber(t[1].lft)
		rgt = tonumber(t[1].rgt)
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

		stmt = [[ INSERT INTO itvision_app_tree(instance_id, service_id, lft, rgt, 
			app_list_id, app_tree_type, is_active) 
			VALUES ( 0, NULL, ]]..newLft..[[, ]]..newRgt..[[, NULL, NULL, 0 ) ]]

		--[[
		print(condLft)
		print(cond2)
		print(newLft, newRgt)

		print( "update itvision_app_tree set lft = lft + 2 where "..condLft )
		print( "update itvision_app_tree set rgt = rgt + 2 where "..cond2 )
		print(stmt)
		]]--

		assert ( db:assertexec ( "update itvision_app_tree set lft = lft + 2 where "..condLft ))
		assert ( db:assertexec ( "update itvision_app_tree set rgt = rgt + 2 where "..condRgt ))
		assert ( db:assertexec ( stmt ))
	end

	assert ( db:assertexec ("UNLOCK TABLES"))
	db:close()
	return res
end

-- Retrieving a Full Tree
-- Seleciona toda sub-arvore a patir de um noh de origem
function select_full_path_app_tree (origin)
	origin = origin or "1"
	local db = open_app_tree_db()
	local t = {}

	columns   = [[ node.app_tree_id, node.instance_id, node.service_id, node.lft,
			node.rgt, node.app_list_id, node.app_tree_type, node.is_active ]]
	tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
	cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND parent.app_tree_id = " .. origin
	extra     = "ORDER BY node.lft"

	t = db:selectall (columns, tablename, cond, extra)

	db:close()
	return t
end


-- Finding all the Leaf Nodes
-- Seleciona todas as folhas da arvore
function select_leaf_nodes_app_tree ()
	local db = open_app_tree_db()
	local t = {}

	columns   = [[ app_tree_id, instance_id, service_id, lft,
			rgt, app_list_id, app_tree_type, is_active ]]
	tablename = "itvision_app_tree"
	cond      = "rgt = lft + 1"
	extra     = "ORDER BY lft"

	t = db:selectall (columns, tablename, cond, extra)

	db:close()
	return t
end


-- Retrieving a Single Path
-- Seleciona um unico caminho partindo de um noh ateh o topo da arvore
function select_simple_path_app_tree (origin)
	origin = origin or "1"
	local db = open_app_tree_db()
	local t = {}

	columns   = [[ parent.app_tree_id, parent.instance_id, parent.service_id, parent.lft,
			parent.rgt, parent.app_list_id, parent.app_tree_type, parent.is_active ]]
	tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
	cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.app_tree_id = " .. origin
	extra     = "ORDER BY parent.lft"

	t = db:selectall (columns, tablename, cond, extra)

	db:close()
	return t
end


-- Finding the Depth of the Nodes
-- Seleciona a profundidade de cada noh
function select_depth_app_tree (origin)
	origin = origin or "1"
	local db = open_app_tree_db()
	local t = {}

	columns   = [[ node.app_tree_id, node.instance_id, node.service_id, node.lft,
			node.rgt, node.app_list_id, node.app_tree_type, node.is_active, 
			(COUNT(parent.app_tree_id) - 1) AS depth ]]
	tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
	cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.app_tree_id = " .. origin
	extra     = "GROUP BY node.app_tree_id ORDER BY parent.lft"

	t = db:selectall (columns, tablename, cond, extra)

	db:close()
	return t
end


-- Finding the Depth of a Sub-Tree
-- Seleciona a profundidade de cada noh a partir de um noh especifico
function select_depth_subtree_app_tree (origin)
	origin = origin or "1"
	local db = open_app_tree_db()
	local t = {}

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

	t = db:selectall (columns, tablename, cond, extra)

	db:close()
	return t
end


-- Find the Immediate Subordinates of a Node
-- Encontra o noh subordinado imediato
function select_subrdinates_app_tree (origin)
	origin = origin or "1"
	local db = open_app_tree_db()
	local t = {}

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


	t = db:selectall (columns, tablename, cond, extra)

	db:close()
	return t
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





