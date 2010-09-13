module("config", package.seeall)

db = {
	instance_id = 1,
 	dbname = "ndoutils", 
	dbuser = "ndoutils", 
	dbpass = "itv", 
	driver = "mysql",
	--conn_data = { dbname, dbuser, dbpass }
}


language = "pt_BR"
monitor_dir = "/usr/local/monitor"
monitor_script = "/etc/init.d/nagios"
monitor_bp_script = "/etc/init.d/ndoutils"

-- ORB DATABASE CONFIG --

function setup_orbdb() 
	local database = config.db
	require("luasql." .. database.driver)
	local env = luasql[database.driver]()

	return env:connect(database.dbname, database.dbuser, database.dbpass), database.driver
end


function make_model( app, model )
	module("ap", package.seeall,orbit.new)

	m = orbit.new()
	m.mapper.conn, m.mapper.driver = config.setup_orbdb()
	m.mapper.table_prefix = model..'_'

	return m
end

itvision = nil
nagios = nil
glpi = nil

function set_models(applic)
	itvision = make_model ( applic, 'itvision' )
	nagios = make_model ( applic, 'nagios' )
	glpi = make_model ( applic, 'nagios' )
end


-- config ITVISION mvc app
--[[
module("ap", package.seeall,orbit.new)

itvision = orbit.new()
itvision.mapper.conn, itvision.mapper.driver = config.setup_orbdb()
itvision.mapper.table_prefix = 'itvision_'
apps = itvision:model "app"

nagios = orbit.new()
nagios.mapper.conn, nagios.mapper.driver = config.setup_orbdb()
nagios.mapper.table_prefix = 'nagios_'
services = nagios:model "services"
]]

