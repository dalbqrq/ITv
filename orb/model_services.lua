require "model_config"

local dado = require "dado"


----------------------------- SERVICES ----------------------------------

function select_services (app)
	if app ~= nil then app = " = " else app = " <> " end
	local db = model_conn()
	local bp_id = model_bp_id()
	local t = db:selectall ("service_id, display_name", "nagios_services", 
		"service_id >= 0 and check_command_object_id"..app..bp_id)
	db:close()
	return t
end


function select_all_service_objects (app)
	if app ~= nil then app = " = " else app = " <> " end
	local db = model_conn()
	local bp_id = model_bp_id()
	local t = db:selectall ("h.service_id, h.display_name, o.object_id ", 
		"nagios_services h, nagios_objects o ", "h.service_object_id = o.object_id "..
		"and check_command_object_id"..app..bp_id)
	db:close()
	return t
end

----------------------------- APP ----------------------------------

function select_apps ()
	return select_service_apps ("app")
end


function select_all_service_app_objects ()
	return select_service_objects ("app")
end


