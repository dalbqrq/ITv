
alter table itvision.itvision_monitors ADD COLUMN cmd_object_id int(11)  NULL DEFAULT NULL  AFTER service_object_id;
--alter table itvision_monitors change column checkcmds_id cmd_object_id int(11);
alter table itvision_checkcmd_params change column checkcmds_id cmd_object_id int(11);

delete from itvision_checkcmd_params where service_object_id = 0;

-- fazer update do itvision_monitors.checkcmds_id a partir desta query
-- select c.id, c.command, c.label, m.name2, m.name from itvision_checkcmds c, itvision_monitors m  where substring_index(m.name2,"_1", 1) = c.label;

-- isso resolve quase tudo!
update itvision_checkcmds c, itvision_monitors m set m.cmd_object_id = c.cmd_object_id where  substring_index(m.name2,"_1", 1) = c.label;
update itvision_checkcmds c, itvision_monitors m set m.cmd_object_id = c.cmd_object_id where  substring_index(m.name2,"_2", 1) = c.label;
-- fazer o resto na mao!
update itvision_monitors set cmd_object_id = . where service_object_id = .;

