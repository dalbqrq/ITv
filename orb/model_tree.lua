
local dado = require "dado"


local db = dado.connect ("ndoutils", "ndoutils", "itv", "mysql")


function select_hosts ()
	for field1, field2 in db:select ("host_id, alias", "nagios_hosts", "host_id >= 11") do
    		print(field1, field2)
	end
end

function select_all_hosts ()
	-- melhor uso: create table
	assert ( pcall( db.assertexec, db, "select * from nagios_hosts"))
end


-- Retorna tabela com nome dos campos de uma tabela sql
function select_columns (tablename)
	local t = {}

	cur = assert ( db:assertexec ("show columns from "..tablename))
	row = cur:fetch({}, "a")
	while row do
		table.insert(t, row.Field)
		row = cur:fetch(row,"a")
	end

	return t
end


---------------------- NESTED SET MODEL for APP TREE -----------------------------
--
-- see: http://dev.mysql.com/tech-resources/articles/hierarchical-data.html
--
--


-- Init tree
-- Inicia a arvore
function init_app_tree()
	assert ( db:assertexec ( [[
		INSERT INTO itvision_app_tree(instance_id, service_object_id, lft, rgt, app_list_id, 
			app_tree_type, is_active) VALUES ( 0, NULL, 1, 2, NULL, NULL, 0 )
	]] ))
end


-- Retrieving a Full Tree
-- Seleciona toda sub-arvore a patir de um noh de origem
function select_full_path_app_tree (origin)
	origin = origin or "1"
	local t = {}

	columns   = [[ node.app_tree_id, node.instance_id, node.service_object_id, node.lft,
			node.rgt, node.app_list_id, node.app_tree_type, node.is_active ]]
	tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
	cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND parent.app_tree_id = " .. origin
	extra     = "ORDER BY node.lft"

	t = db:selectall (columns, tablename, cond, extra)

	return t
end


-- Finding all the Leaf Nodes
-- Seleciona todas as folhas da arvore
function select_leaf_nodes_app_tree ()
	local t = {}

	columns   = [[ app_tree_id, instance_id, service_object_id, lft,
			rgt, app_list_id, app_tree_type, is_active ]]
	tablename = "itvision_app_tree"
	cond      = "rgt = lft + 1"
	extra     = "ORDER BY lft"

	t = db:selectall (columns, tablename, cond, extra)

	return t
end


-- Retrieving a Single Path
-- Seleciona um unico caminho partindo de um noh ateh o topo da arvore
function select_simple_path_app_tree (origin)
	origin = origin or "1"
	local t = {}

	columns   = [[ parent.app_tree_id, parent.instance_id, parent.service_object_id, parent.lft,
			parent.rgt, parent.app_list_id, parent.app_tree_type, parent.is_active ]]
	tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
	cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.app_tree_id = " .. origin
	extra     = "ORDER BY parent.lft"

	t = db:selectall (columns, tablename, cond, extra)

	return t
end


-- Finding the Depth of the Nodes
-- Seleciona a profundidade de cada noh
function select_depth_app_tree (origin)
	origin = origin or "1"
	local t = {}

	columns   = [[ node.app_tree_id, node.instance_id, node.service_object_id, node.lft,
			node.rgt, node.app_list_id, node.app_tree_type, node.is_active, 
			(COUNT(parent.app_tree_id) - 1) AS depth ]]
	tablename = "itvision_app_tree AS node, itvision_app_tree AS parent"
	cond      = "node.lft BETWEEN parent.lft AND parent.rgt AND node.app_tree_id = " .. origin
	extra     = "GROUP BY node.app_tree_id ORDER BY parent.lft"

	t = db:selectall (columns, tablename, cond, extra)

	return t
end


-- Finding the Depth of a Sub-Tree
-- Seleciona a profundidade de cada noh a partir de um noh especifico
function select_depth_subtree_app_tree (origin)
	origin = origin or "1"
	local t = {}

	columns   = [[ node.app_tree_id, node.instance_id, node.service_object_id, node.lft,
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

	return t
end


-- Find the Immediate Subordinates of a Node
-- Encontra o noh subordinado imediato
function select_subrdinates_app_tree (origin)
	origin = origin or "1"
	local t = {}

	columns   = [[ node.app_tree_id, node.instance_id, node.service_object_id, node.lft,
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

	return t
end


-- Adding New Nodes
-- Incluindo novos noh
function insert_node_app_tree(t, origin)
	origin = origin or "1"

	cur = assert ( db:assertexec ("LOCK TABLE itvision_app_tree WRITE"))
	cur = assert ( db:assertexec ("SELECT rgt FROM itvision_app_tree WHERE app_tree_id = ".. origin))
	row = cur:fetch({}, "a")

	print(row.rgt)

	--UPDATE itvision_app_tree SET rgt = rgt + 2 WHERE rgt > @myRight;
	--UPDATE itvision_app_tree SET lft = lft + 2 WHERE lft > @myRight;

	--INSERT INTO itvision_app_tree(lft, rgt) VALUES('GAME CONSOLES', @myRight + 1, @myRight + 2);

	cur = assert ( db:assertexec ("UNLOCK TABLES"))


end


insert_node_app_tree(nil, '1')

--[[
tab = select_columns("itvision_app_tree")
select_hosts()
select_all_hosts()
print('-TEST----------------------------')
t = select_full_path_app_tree("0")

for i, v in ipairs(t) do
	print (v)
end

print('---------------------------------')


t = db:selectall ("host_id, alias", "nagios_hosts", "host_id >= 11")
for i, v in ipairs(t) do
	print(v.host_id, v.alias )
end


t = db:selectall ("h.host_id, h.alias, o.object_id ", " nagios_hosts h, nagios_objects o "," h.host_object_id = o.object_id")
for i, v in ipairs(t) do
	print(v.host_id, v.alias, v.object_id )
end

]]--


db:close()



