
ALTER TABLE itvision.itvision_apps ADD COLUMN root_of_entity_id INT(11) NULL DEFAULT NULL AFTER entities_id;

UPDATE itvision.itvision_apps set root_of_entity_id = 0 where name = 'ROOT';


