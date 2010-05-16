

local dado = require "dado"
local db = dado.connect ("ndoutils", "ndoutils", "itv", "mysql")


----------------------------- CONFIG ----------------------------------

instance_id = 1

function init_config()
	local t = {}

	t = db:selectall ("config_id", "itvision_config", "config_id >= 1")

	if t[1] == nil then
		assert ( db:assertexec ( [[
			INSERT INTO itvision_config (instance_id, created, updated, version, home_dir) 
				VALUES ( ]]..instance_id..[[, now(), now(), '0.9', '/usr/local/itvision');
		]] ))
		return true
	else
		return false
	end

end

init_config()
