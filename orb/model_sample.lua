require "model_config"

local dado = require "dado"


----------------------------- HOSTS ----------------------------------

function select_hosts () -- this function return a table
	local db = model_conn()
	local t = db:selectall ("host_id, alias", "nagios_hosts", "host_id >= 0")
	db:close()
	return t
end


function select_hosts_func () -- this function return another function
	local db = model_conn()
	local t = db:select ("host_id, alias", "nagios_hosts", "host_id >= 0")
	--[[
	for field1, field2 in t do
    		print(field1, field2)
	end
	print(type(t))
	]]
	db:close()
	return t
end


function select_all_hosts () -- this function only executes a query
	local db = model_conn()
	assert ( pcall( db.assertexec, db, "select * from nagios_hosts"))
	db:close()
end


function select_all_host_object () -- this function return a table
	local db = model_conn()
	local t = db:selectall ("h.host_id, h.alias, o.object_id ", " nagios_hosts h, nagios_objects o ",
			"h.host_object_id = o.object_id")
	--[[
	for i, v in ipairs(t) do
		print(v.host_id, v.alias, v.object_id )
	end
	]]--
	db:close()
	return t
end


