select * 
from nagios_objects o,
   nagios_services s,
   nagios_servicestatus ss,
   itvision_apps a,
   itvision_app_objects ao,
   itvision_apps ax where    o.object_id = s.service_object_id and
   o.object_id = ss.service_object_id and
   o.object_id = ao.service_object_id and
   o.object_id = ax.service_object_id and
   s.service_object_id = ss.service_object_id and
   ss.service_object_id = s.service_object_id and
   a.id = ao.app_id and
   ao.app_id = a.id 
      and o.name1 = 'BUSPROC_HOST' 
      and o.is_active = 1
    and a.id in (select app_id from itvision_app_objects where service_object_id = 284);




select 'hst';
select count(*), ss.current_state 
from nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_computers c
where ss.service_object_id = o.object_id
    and o.name2 <> 'HOST_ALIVE' and o.name1 <> 'BUSPROC_HOST' and o.objecttype_id = 2
    and m.service_object_id = o.object_id
    and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'Computer'
    and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1
group by ss.current_state;

select count(*), ss.current_state 
from nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_networkequipments c
where ss.service_object_id = o.object_id
    and o.name2 <> 'HOST_ALIVE' and o.name1 <> 'BUSPROC_HOST' and o.objecttype_id = 2
    and m.service_object_id = o.object_id
    and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'NetworkEquipment'
    and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1
group by ss.current_state;


select 'svc';
select count(*), ss.current_state 
from nagios_servicestatus ss, nagios_objects o
where ss.service_object_id = o.object_id
    and o.name2 = 'HOST_ALIVE' and o.objecttype_id = 2
group by ss.current_state;

select 'app';
select count(*), ss.current_state 
from nagios_servicestatus ss, nagios_objects o, itvision_apps a
where ss.service_object_id = o.object_id
    and o.name1 = 'BUSPROC_HOST' and o.objecttype_id = 2
    and a.is_entity_root = 0
group by ss.current_state;


select 'ent';
select count(*), ss.current_state 
from nagios_servicestatus ss, nagios_objects o, itvision_apps a
where ss.service_object_id = o.object_id
    and o.name1 = 'BUSPROC_HOST' and o.objecttype_id = 2
    and o.object_id = a.service_object_id
    and a.is_entity_root = 1
group by ss.current_state;


