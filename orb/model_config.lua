

local dado = require "dado"


----------------------------- CONFIG ----------------------------------

model_config = {
	instance_id = 1,
 	dbname = "ndoutils", 
	dbuser = "ndoutils", 
	dbpass = "itv", 
	driver = "mysql"
}


function model_conn()
	local m = model_config
	return dado.connect (m.dbname, m.dbuser, m.dbpass, m.driver)
end


function model_bp_id()
	local db = model_conn()
	local t = db:selectall ("object_id", "nagios_objects", "name1 = 'check_bp_status'")
	
	return t[1].object_id
end


function init_config()
	local db = model_conn()
	local t = db:selectall ("config_id", "itvision_config", "config_id >= 1")

	if t[1] == nil then
		assert ( db:assertexec ( [[
			INSERT INTO itvision_config (instance_id, created, updated, version, home_dir) 
				VALUES ( ]]..instance_id..[[, now(), now(), '0.9', '/usr/local/itvision');
		]] ))
		return true
	else
		return false
	end

	db:close()

end

