
select * from nagios_objects where objecttype_id = 2 and name2 = 'HOST_ALIVE';


insert into itvision_checkcmd_params (service_object_id, name1, name2, checkcmds_id, sequence , value ) select object_id, name1, name2, 25, 1, '400.0,20%' from nagios_objects where objecttype_id = 2 and name2 = 'HOST_ALIVE' and is_active = 1;

insert into itvision_checkcmd_params (service_object_id, name1, name2, checkcmds_id, sequence , value ) select object_id, name1, name2, 25, 2, '999.0,70%' from nagios_objects where objecttype_id = 2 and name2 = 'HOST_ALIVE' and is_active = 1;

