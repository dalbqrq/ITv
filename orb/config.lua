module("config", package.seeall)


instance_name = "default"
app_name = "ITvision"


database = {
        instance_id = 1,
        dbname = "itvision", 
        dbuser = "itv", 
        dbpass = "itv", 
        driver = "mysql",
}


monitor = {
	dir        = "/etc/nagios3",
	bp_dir     = "/etc/nagios3/nagiosbp",
	script     = "/etc/init.d/nagios3",
	bp_script  = "/etc/init.d/ndoutils",
	check_ping = "PING",
}


language = "pt_BR"



