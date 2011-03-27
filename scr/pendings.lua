require "sync_apps"
require "sync_services"

--------------------------------------------------------------------------------
-- Pendings from Nagios
sync_services()
sync_apps()



--require "sync_ip"
--require "sync_entities"

--------------------------------------------------------------------------------
-- Externals from GLPI
-- Agora estas sincronizacoes (abaixo) são chamadas diretamente do codigo php

--sync_ip()
--sync_entities()
