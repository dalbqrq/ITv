require "model_config"

local dado = require "dado"


----------------------------- APPS ----------------------------------

function select_apps ()
	local db = model_conn()
	local t = db:selectall ("app_id, name", "itvision_apps")
	db:close()
	return t
end


function insert_app (content)
	local db = model_conn()
	--local inst = model_config.instance_id

	assert ( db:insert ( "itvision_apps", content ))
	db:close()
end


function update_app (content, cond)
	local db = model_conn()
	--local inst = model_config.instance_id

	assert ( db:update ( "itvision_apps", content, cond ))
	db:close()
end


function delete_app (cond)
	local db = model_conn()
	--local inst = model_config.instance_id

	assert ( db:update ( "itvision_apps", cond ))
	db:close()
end


