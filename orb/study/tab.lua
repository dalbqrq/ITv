--[[

   +-----------+    +-------------------------+    +-----------------+      +----------+
   |  glpi_    |----| glpi_                   |----|  glpi_          |------|  glpi_   |
   | COMPUTER  |    |COMPUTER_SOFTWAREVERSION |    | SOFTWAREVERSION |      | SOFTWARE |
   +-----------+    +-------------------------+    +-----------------+      +----------+
         |                                                 |
         |                                                 |
   +-------------+                                    +-----------+
   |  glpi_      |------------------------------------| itvision_ |
   | NETWORKPORT |                                    | MONITOR   |
   +-------------+                                    +-----------+
                                                           |
                                                           |
                                                      +---------------+
   +-------------+         +-------------+            | nagios_       |
   | itvision_   |---------| itvision_   |----------- | OBJECTS  .or. |
   | apps        |         | app_objects |            | SERVICES .or. |
   +-------------+         +-------------+            | SERVICESTATUS |
                                                      +---------------+

]]


require "Model"

local all_tables = { 
	"itvision_apps",
	"itvision_app_objects",
	"itvision_app_monitor",
	"nagios_objects",
	"nagios_services",
	"nagios_servicestatus",
	"glpi_computers",
	"glpi_networkequipments",
	"glpi_networkports",
	"glpi_software",
	"glpi_software_version",
	
}

local t = show_columns("itvision_app")

for i,v in pairs(t) do
	print(i, v.Field, v.Key)
end

