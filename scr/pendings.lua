require "sync_apps"
require "sync_services"
require "sync_ip"
require "sync_entities"


-- Pendings from Nagios
sync_services()
sync_apps()

-- Externals from GLPI
--sync_ip()
--sync_entities()
