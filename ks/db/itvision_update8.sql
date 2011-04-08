
ALTER TABLE itvision.itvision_apps ADD COLUMN is_entity_root BOOLEAN NOT NULL DEFAULT false AFTER entities_id;

--UPDATE itvision.itvision_apps set is_entity_root = true where name = 'ROOT';


