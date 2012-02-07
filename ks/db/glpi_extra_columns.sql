
ALTER TABLE itvision.glpi_computers ADD COLUMN alias VARCHAR(30) NULL DEFAULT NULL AFTER ticket_tco ;
ALTER TABLE itvision.glpi_computers ADD COLUMN itv_key VARCHAR(30) NULL DEFAULT NULL AFTER ticket_tco ;
ALTER TABLE itvision.glpi_computers ADD COLUMN geotag VARCHAR(40) NULL DEFAULT NULL AFTER ticket_tco ;

ALTER TABLE itvision.glpi_networkequipments ADD COLUMN alias VARCHAR(30) NULL DEFAULT NULL AFTER ticket_tco ;
ALTER TABLE itvision.glpi_networkequipments ADD COLUMN itv_key VARCHAR(30) NULL DEFAULT NULL AFTER ticket_tco ;
ALTER TABLE itvision.glpi_networkequipments ADD COLUMN geotag VARCHAR(40) NULL DEFAULT NULL AFTER ticket_tco ;

ALTER TABLE itvision.glpi_profiles ADD COLUMN app_relat_type CHAR(1) NULL DEFAULT NULL AFTER create_validation ;
ALTER TABLE itvision.glpi_profiles ADD COLUMN checkcmds      CHAR(1) NULL DEFAULT NULL AFTER create_validation ;
ALTER TABLE itvision.glpi_profiles ADD COLUMN application    CHAR(1) NULL DEFAULT NULL AFTER create_validation ;

