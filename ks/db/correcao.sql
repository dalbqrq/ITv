

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


select n.name , o.object_id





select n.name, o.object_id, p.id, n.id from glpi_networkequipments n,    glpi_networkports p,    nagios_objects o,    nagios_services s,    itvision_monitors m,    nagios_servicestatus ss where    n.id = p.items_id and    p.id = m.networkports_id and    o.object_id = s.service_object_id and    o.object_id = m.service_object_id and    o.object_id = ss.service_object_id and    s.service_object_id = o.object_id and    s.service_object_id = m.service_object_id and    s.service_object_id = ss.service_object_id and    m.networkports_id = p.id and    m.service_object_id = o.object_id and    m.service_object_id = s.service_object_id and    m.service_object_id = ss.service_object_id           and p.itemtype = 'NetworkEquipment'         and m.softwareversions_id is null


select n.name, o.object_id, p.id, n.id 
from glpi_networkequipments n,    glpi_networkports p,    nagios_objects o,    nagios_services s,    itvision_monitors m,    nagios_servicestatus ss 
where    n.id = p.items_id 
and    p.id = m.networkports_id 
and    o.object_id = s.service_object_id 
and    o.object_id = m.service_object_id 
and    o.object_id = ss.service_object_id 
and    s.service_object_id = o.object_id 
and    s.service_object_id = m.service_object_id 
and    s.service_object_id = ss.service_object_id 
and    m.networkports_id = p.id 
and    m.service_object_id = o.object_id 
and    m.service_object_id = s.service_object_id 
and    m.service_object_id = ss.service_object_id           
and p.itemtype = 'NetworkEquipment'         
and m.softwareversions_id is null
and n.name = 'MAP008';

