
ALTER TABLE itvision.itvision_monitors ADD COLUMN checkcmds_id int(11)  NULL DEFAULT NULL  AFTER service_object_id;

delete from itvision_checkcmd_params where service_object_id = 0;

-- fazer update do itvision_monitors.checkcmds_id a partir desta query
-- select c.id, c.command, c.label, m.name2, m.name from itvision_checkcmds c, itvision_monitors m  where substring_index(m.name2,"_", 1) = c.label;

-- isso resolve quase tudo! fazer o resto na mao!
update itvision_checkcmds c, itvision_monitors m set m.checkcmds_id = c.id where  substring_index(m.name2,"_1", 1) = c.label;

