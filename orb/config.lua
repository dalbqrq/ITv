app_name = "ITvision"

database = {
        instance_id = 1,
        instance_name = "IMPA",
        dbname = "itvision",
        dbuser = "itv",
        dbpass = "itv",
        driver = "mysql",
}

monitor = {
        dir        = "/etc/nagios3",
        bp_dir     = "/usr/local/nagiosbp",
        script     = "/etc/init.d/nagios3",
        bp_script  = "/etc/init.d/ndoutils",
        bp2cfg     = "bp2cfg",
        check_host = "HOST_ALIVE",
        check_app  = "BUSPROC_SERVICE",
        cmd_app    = "BUSPROC_STATUS",
}

path = {
        itvision = "/usr/local/itvision",
}

language = "pt_BR"
