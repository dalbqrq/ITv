
ALTER TABLE itvision.itvision_apps ADD COLUMN is_entity_root BOOLEAN NOT NULL DEFAULT false AFTER entities_id;
ALTER TABLE itvision.itvision_app_type ADD COLUMN is_app_entity BOOLEAN NOT NULL DEFAULT false AFTER name;
INSERT into itvision_app_type set name='Entidade', is_app_entity=true;

--UPDATE itvision.itvision_apps set is_entity_root = true where name = 'ROOT';

DROP table itvision_app_viewers;


