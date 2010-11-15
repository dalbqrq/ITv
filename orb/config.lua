

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
	script     = "/etc/init.d/nagios3",
	bp_dir     = "/usr/local/nagiosbp",
	bp2cfg     = "bp2cfg",
	bp_script  = "/etc/init.d/ndoutils",
	--check_host = "HOST_ALIVE",
	check_host = "HOST_PING", -- depricated
	--check_app  = "BUSPROC_SERVICE",
	check_app  = "business_processes", -- depricated
        cmd_app    = "BUSPROC_STATUS",
}

language = "pt_BR"

path = {
	itvision = "/usr/local/itvision",
	gv = "gv",
	html = "html",
}

