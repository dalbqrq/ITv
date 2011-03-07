

ALTER TABLE itvision.glpi_profiles ADD COLUMN app_relat_type CHAR(1) NULL DEFAULT NULL  AFTER create_validation ;
ALTER TABLE itvision.glpi_profiles ADD COLUMN checkcmds      CHAR(1) NULL DEFAULT NULL  AFTER create_validation ;
ALTER TABLE itvision.glpi_profiles ADD COLUMN application    CHAR(1) NULL DEFAULT NULL  AFTER create_validation ;


