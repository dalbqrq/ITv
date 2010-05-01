
local dado = require "dado"
local db = dado.connect ("ndoutils", "ndoutils", "itiv", "mysql")


----------------------------- HOSTS ----------------------------------

function select_hosts ()
	t = db:selectall ("host_id, alias", "nagios_hosts", "host_id >= 11")
	for i, v in ipairs(t) do
		print(v.host_id, v.alias )
	end
end


function select_hosts_2 ()
	for field1, field2 in db:select ("host_id, alias", "nagios_hosts", "host_id >= 11") do
    		print(field1, field2)
	end
end


function select_all_hosts ()
	assert ( pcall( db.assertexec, db, "select * from nagios_hosts"))
end


function select_all_host_object ()
	t = db:selectall ("h.host_id, h.alias, o.object_id ", " nagios_hosts h, nagios_objects o ",
			"h.host_object_id = o.object_id")
	for i, v in ipairs(t) do
		print(v.host_id, v.alias, v.object_id )
	end
end


