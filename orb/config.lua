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

