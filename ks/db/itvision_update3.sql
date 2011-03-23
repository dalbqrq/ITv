
ALTER TABLE itvision.itvision_checkcmds ADD COLUMN label VARCHAR(40) NULL DEFAULT NULL  AFTER command ;
ALTER TABLE itvision.itvision_checkcmd_params ADD COLUMN name2 VARCHAR(40) NULL DEFAULT NULL  AFTER service_object_id ;
ALTER TABLE itvision.itvision_checkcmd_params ADD COLUMN name1 VARCHAR(40) NULL DEFAULT NULL  AFTER service_object_id ;
ALTER TABLE itvision.itvision_checkcmd_params ADD COLUMN value VARCHAR(40) NULL DEFAULT NULL  AFTER sequence ;
ALTER TABLE itvision.itvision_checkcmd_params DROP COLUMN flag;
ALTER TABLE itvision.itvision_checkcmd_params DROP COLUMN variable;


