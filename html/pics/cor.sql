
select * from itvision_monitors where service_object_id in
(select object_id from nagios_objects where objecttype_id = 2 and name1 like '%HWACP00%' order by object_id);


select id, a.type, o.type, name, is_active,  a.service_object_id, o.service_object_id 
from itvision_apps a, itvision_app_objects o where a.id = o.app_id;

-- OK
select id, a.type, ao.type, name, o.object_id, o.name1, o.name2 
from itvision_apps a, itvision_app_objects ao , nagios_objects o
where a.id = ao.app_id 
and ao.service_object_id = o.object_id;


-- OK
insert into glpi_networkports (items_id, itemtype, name, ip)
select id, "NetworkEquipment", "", ip from glpi_networkequipments where ip like '%200.156%'

