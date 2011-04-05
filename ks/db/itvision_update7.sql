
ALTER TABLE itvision.itvision_apps DROP COLUMN public;

ALTER TABLE itvision.itvision_apps ADD COLUMN visibility INT(1) NOT NULL DEFAULT 0 AFTER is_active;


