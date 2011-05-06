module("config", package.seeall)

app_name = "ITvision"

database = {
        instance_id = 1,
        instance_name = "DEVEL",
        dbname = "proderj",
        dbuser = "root",
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
        check_app  = "BUSPROC_HOST",
        cmd_app    = "BUSPROC_STATUS",
}

view = {
        -- GERAR NOVA CHAVE EM: http://code.google.com/apis/maps/signup.html        google_maps_key = "ABQIAAAAsqOIUfpoX_G_Pw0Ar48BRhRtyMmS1TXEK_DXFnd23B1n8zvUnRT_9hDq4-PHCmE33vrSdHVrdUyjgw" 
--itv.impa.br
}

path = {
        itvision = "/usr/local/itvision",
        log = "/var/log/itvision",
}

language = "pt_BR"
