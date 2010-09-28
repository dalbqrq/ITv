module("config", package.seeall)

app_name = "ITvision"

database = {
        instance_id = 1,
        dbname = "ndoutils", 
        dbuser = "ndoutils", 
        dbpass = "itv", 
        driver = "mysql",
}

language = "pt_BR"

monitor_dir       = "/usr/local/monitor"
monitor_bp_dir    = "/usr/local/monitorbp"
monitor_script    = "/etc/init.d/nagios"
monitor_bp_script = "/etc/init.d/ndoutils"


