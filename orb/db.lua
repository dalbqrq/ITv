
local dado = require "dado"
local db = dado.connect ("ndoutils", "ndoutils", "itv", "mysql")

--db.conn:execute ("select * from nagios_hosts") -- direct use of LuaSQL

select_hosts = function()
	for field1, field2 in db:select ("host_id, alias", "nagios_hosts", "host_id >= 11") do
    		print(field1, field2)
	end
end

select_all_hosts = function()
	-- melhor uso: create table
	cur = assert ( pcall( db.assertexec, db, "select * from nagios_hosts"))

	row = cur:fetch({}, "a")
	while row do
		print( row.Field  )
		row = cur:fetch(row,"a")
	end
end

select_full_path_tree = function()
	select = [[ 
		SELECT node.name
		FROM nested_category AS node,
		nested_category AS parent
		WHERE node.lft BETWEEN parent.lft AND parent.rgt
		AND parent.name = 'ELECTRONICS'
		ORDER BY node.lft;
	]]
end

select_hosts()
select_all_hosts()


t = db:selectall ("host_id, alias", "nagios_hosts", "host_id >= 11")
for i, v in ipairs(t) do
	print(v.host_id, v.alias )
end


t = db:selectall ("h.host_id, h.alias, o.object_id ", " nagios_hosts h, nagios_objects o "," h.host_object_id = o.object_id")
for i, v in ipairs(t) do
	print(v.host_id, v.alias, v.object_id )
end



db:close()



