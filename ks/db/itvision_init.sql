

INSERT INTO itvision.itvision_apps 
SET    instance_id = 1, entities_id = 0, is_entity_root = 1, name = 'ROOT';

INSERT INTO itvision.itvision_app_trees 
SET    instance_id = 1, app_id = (select id from itvision_apps where name = 'ROOT' and is_active = 0), lft = 1, rgt = 2;

INSERT INTO itvision.itvision_app_relat_types 
VALUES (1,'roda em','logical'),(2,'conectado a','physical'),(3,'usa','logical'),(4,'faz backup em','logical');


