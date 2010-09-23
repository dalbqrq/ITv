/* computer X networkports */
select c.id, n.id as nid, c.name, n.ip, n.itemtype from glpi_networkports n, glpi_computers c where c.id = n.items_id and itemtype="Computer";


/* hosts X networkports */
select host_id, config_type, alias, display_name, id, itemtype from nagios_hosts, glpi_networkports where networkport_id = id;


/* update hosts.networkport_id */
update nagios_hosts set networkport_id=3 where alias='Metzler';


/* objects X hosts */
select host_id, config_type, alias, display_name, host_object_id from nagios_hosts, nagios_objects where host_object_id = object_id;

/* networkport with nagios_object using monitor - if "without" remove "not" from query */
select * from glpi_networkports n where itemtype="Computer" and not exists (select 1 from itvision_monitor m where m.networkport_id = n.id);


/* networkport X computer with nagios_object using monitor - if "without" remove "not" from query */
select c.id, n.id as nid, c.name, n.ip, n.itemtype from glpi_networkports n, glpi_computers c where c.id = n.items_id and itemtype="Computer"
       and not exists (select 1 from itvision_monitor m where m.networkport_id = n.id);


/* networkport X computer with nagios_object using monitor - if "without" remove "not" from query */
select c.id, n.id as nid, c.name, n.ip, n.itemtype from glpi_networkports n, glpi_computers c where c.id = n.items_id and itemtype="Computer"
       and not exists (select 1 from itvision_monitor m where m.networkport_id = n.id);





/*
   computador com porta sem software e sem monitor
*/
select * 
from glpi_computers c, glpi_networkports n
where 
     c.id = n.items_id and 
     itemtype="Computer" and
     not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id) and
     not exists (select 1 from itvision_monitor m where m.networkport_id = n.id);

     
/*
   computador com porta com software e sem monitor
*/
select * 
from glpi_computers c, glpi_networkports n
where 
     c.id = n.items_id and 
     itemtype="Computer" and
     exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id) and
     not exists (select 1 from itvision_monitor m where m.networkport_id = n.id);


/*
   computador com porta sem software e com monitor
*/
select *
from glpi_computers c, glpi_networkports n, glpi_computers_softwareversions csv, glpi_softwareversion sv, glpi_software s,
     nagios_objects o, nagios_hosts hst, nagios_services svc, itvision_monitor m
where
     c.id = n.itens_id and
     c.id = csv.computers_id and
     csv.softwareversion_id = sv.id and
     sv.id = s.softwareversion_id and
     n.id = m.networkport_id and
     m.host_object_id = o.object_id and

/*
   computador com porta com software e com monitor
*/






