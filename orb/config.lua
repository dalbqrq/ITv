module("config", package.seeall)


instance_name = "itv_proto"
app_name = "ITvision"


database = {
        instance_id = 1,
        dbname = "ndoutils", 
        dbuser = "ndoutils", 
        dbpass = "itv", 
        driver = "mysql",
}


monitor = {
	dir        = "/usr/local/monitor",
	bp_dir     = "/usr/local/monitorbp",
	script     = "/etc/init.d/nagios",
	bp_script  = "/etc/init.d/ndoutils",
	check_ping = "check_ping",
}


language = "pt_BR"



