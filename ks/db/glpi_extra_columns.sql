
ALTER TABLE itvision.glpi_computers ADD COLUMN alias VARCHAR(255) NULL DEFAULT NULL  AFTER ticket_tco ;
ALTER TABLE itvision.glpi_computers ADD COLUMN itv_key VARCHAR(30) NULL DEFAULT NULL  AFTER ticket_tco ;
ALTER TABLE itvision.glpi_computers ADD COLUMN geotag VARCHAR(20) NULL DEFAULT NULL  AFTER ticket_tco ;

ALTER TABLE itvision.glpi_networkequipments ADD COLUMN itv_key VARCHAR(30) NULL DEFAULT NULL  AFTER ticket_tco ;
ALTER TABLE itvision.glpi_networkequipments ADD COLUMN alias VARCHAR(255) NULL DEFAULT NULL  AFTER ticket_tco ;
ALTER TABLE itvision.glpi_networkequipments ADD COLUMN geotag VARCHAR(20) NULL DEFAULT NULL  AFTER ticket_tco ;
