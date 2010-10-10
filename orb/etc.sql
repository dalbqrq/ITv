/*

PRIMEIRO VAMOS FAZER ALGUMAS QUERIES DE TESTE, COMBINANDO AS TABELAS MAIS IMPORTANTS DESTES RELACIONAMENTOS 
ENTRE A BASE DO NAGIOS, GLPI E DO ITVISION. DE FATO, A TABELA itvision_monitor FOI CONCEBIDA JUTAMENTE PARA
RELACIONAR O CMDB DO GLPI AS TABELAS QUE DEFINEM UMA MONITORACAO. ELAS TEM O SEGUINTE DIAGRAMA:


   +-----------+        +-------------------------+      +-----------------+      +----------+
   |  glpi_    |--------| glpi_                   |------|  glpi_          |------|  glpi_   |
   | COMPUTER  |        |COMPUTER_SOFTWAREVERSION |      | SOFTWAREVERSION |      | SOFTWARE |
   +-----------+        +-------------------------+      +-----------------+      +----------+
         |                                                       |
         |                                                       |
   +-------------+                                          +-----------+
   |  glpi_      |------------------------------------------| itvision_ |
   | NETWORKPORT |                                          | MONITOR   |
   +-------------+                                          +-----------+
                                                                 |
                                                                 |
                                                            +-----------+
                                                            | nagios_   |
                                                            | OBJECTS   |
                                                            +-----------+
                                                             |         |
                                                             |         |
                                                   +-----------+      +------------+
                                                   | nagios_   |      | nagios_    |
                                                   | HOSTS     |      | SERVICES   |
                                                   +-----------+      +------------+

*/


/* computer X networkports */
select c.id, n.id as nid, c.name, n.ip, n.itemtype from glpi_networkports n, glpi_computers c where c.id = n.items_id and n.itemtype = "Computer";


/* hosts X networkports */
select host_id, config_type, alias, display_name, id, itemtype from nagios_hosts, glpi_networkports where networkports_id = id;


/* update hosts.networkports_id */
update nagios_hosts set networkports_id=3 where alias='Metzler';


/* objects X hosts */
select host_id, config_type, alias, display_name, host_object_id from nagios_hosts, nagios_objects where host_object_id = object_id;

/* networkport with nagios_object using monitor - if "without" remove "not" from query */
select * from glpi_networkports n where n.itemtype = "Computer" and not exists (select 1 from itvision_monitor m where m.networkports_id = n.id);


/* networkport X computer with nagios_object using monitor - if "without" remove "not" from query */
select c.id, n.id as nid, c.name, n.ip, n.itemtype from glpi_networkports n, glpi_computers c where c.id = n.items_id and n.itemtype = "Computer"
       and not exists (select 1 from itvision_monitor m where m.networkports_id = n.id);


/* networkport X computer with nagios_object using monitor - if "without" remove "not" from query */
select c.id, n.id as nid, c.name, n.ip, n.itemtype from glpi_networkports n, glpi_computers c where c.id = n.items_id and n.itemtype = "Computer"
       and not exists (select 1 from itvision_monitor m where m.networkports_id = n.id);


/* 

AGORA COMECAREMOS A FAZER TESTE DE VERDADE, JUNTANDO AS TABELAS QUE COMPOES A REPRESENTACAO APRESENTADA NO DIAGRAMA ACIMA.
SERAO QUATRO QUERIES QUE DEVEM LISTAR OS COMPUTADORES (OU EQUIPAMENTOS DE REDE) QUE DEVEM POSSUIR PORTAS DE REDE MAS
PODE OU NÃO POSSUIR SOFTWARE E MONITORACAO.  

ASSIM PRIMEIRO VAMOS FAZER AS QUERIES PARA VERIFICAR SE AS CLAUSULAS CONDICIONAIS ESTÃO CERTAS. 

*/


/*
   QUERY 1 - computador com porta sem software e sem monitor
*/
select * 
from glpi_computers c, glpi_networkports n
where 
     n.itemtype in ("Computer", "NetworkEquipment")  and
     c.id = n.items_id and 
     not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id) and
     not exists (select 1 from itvision_monitor m where m.networkports_id = n.id);

     
/*
   QUERY 2 - computador com porta com software e sem monitor
*/
select * 
from glpi_computers c, glpi_networkports n, glpi_computers_softwareversions csv, glpi_softwareversions sv, glpi_softwares s
where 
     n.itemtype in ("Computer", "NetworkEquipment")  and
     c.id = n.items_id and 
     c.id = csv.computers_id and
     csv.softwareversions_id = sv.id and
     sv.softwares_id = s.id and
     not exists (select 1 from itvision_monitor m where m.networkports_id = n.id);


/*
   QUERY 3 - computador com porta sem software e com monitor - monitoracao de host onde o service eh ping

select *
from glpi_computers c, glpi_networkports n,
     nagios_objects o, nagios_hosts hst, nagios_services svc, itvision_monitor m
where
     c.id = n.items_id and 
     n.id = m.networkports_id and
     m.host_object_id = o.object_id and
     m.service_object_id = o.object_id and
     not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id);
*/
select *
from glpi_computers c, glpi_networkports n,
     itvision_monitor m, nagios_hosts hst, nagios_services svc
where
     n.itemtype in ("Computer", "NetworkEquipment")  and
     c.id = n.items_id and 
     n.id = m.networkports_id and
     m.host_object_id = hst.host_object_id and
     m.host_object_id = svc.host_object_id and
     m.service_object_id = svc.service_object_id and
     m.softwareversions_id is null

/*
     not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id);
*/

/*
   QUERY 4 - computador com porta com software e com monitor - monitoracao de service por isso tem software associado
*/
select *
from glpi_computers c, glpi_networkports n, glpi_computers_softwareversions csv, 
     glpi_softwareversions sv, glpi_softwares s,
     nagios_objects o, nagios_hosts hst, nagios_services svc, itvision_monitor m
where
     n.itemtype in ("Computer", "NetworkEquipment") and
     c.id = n.items_id and  
     n.id = m.networkports_id and
     c.id = csv.computers_id and
     csv.softwareversions_id = sv.id and
     sv.softwares_id = s.id and
     m.host_object_id = o.object_id and
     m.softwareversions_id = csv.softwareversions_id and
     m.host_object_id = hst.host_object_id and
     m.host_object_id = svc.host_object_id and
     m.service_object_id = svc.service_object_id

/*
     n.itemtype in ("Computer", "NetworkEquipment")  and
     c.id = n.items_id and 
     c.id = csv.computers_id and
     csv.softwareversions_id = sv.id and
     sv.softwares_id = s.id and
     n.id = m.networkports_id and
     m.host_object_id = o.object_id and
     m.service_object_id = o.object_id and
     m.softwareversions_id = sv.id;
*/


/* 

COMO OS RESULTADOS DESSAS QUERIES DEVEM SER JUNTADOS EM UMA ÚNICA LISTA, A LISTA DE CAMPOS DEVE SER EXATAMENTE A MESMA
ONDE O CONTEUDO DAS COLUNAS QUE NAO EXISTIREM SERÃO DE VALOR 'null'.

ESTAS DEVERÃO SER AS QUERIES DEFINITIVAS QUE VIRARÃO FUNCÕES EM UM MÓDULO LUA DO PROJETO ITvision

*/

/*
   QUERY 1 - computador com porta sem software e sem monitor
*/
select

c.id			as c_id,
c.entities_id		as c_entities_id,
c.name			as c_name,
c.serial		as c_serial,
c.otherserial		as c_otherserial,
c.locations_id		as c_locations_id,
c.is_template		as c_is_template,
c.is_deleted		as c_is_deleted,
c.states_id		as c_states_id,

n.id			as n_id,
n.items_id		as n_items_id,
n.itemtype		as n_itemtype,
n.entities_id		as n_entities_id,
n.logical_number	as n_logical_number,
n.name			as n_name,
n.ip			as n_ip,

null	as csv_id,
null	as csv_computers_id,
null	as csv_softwareversions_id,

null	as sv_id,
null	as sv_entities_id,
null	as sv_softwares_id,
null	as sv_states_id,
null	as sv_name,
null	as sv_comment,

null	as s_id,
null	as s_entities_id,
null	as s_is_recursive,
null	as s_name,
null	as s_locations_id,
null	as s_is_deleted,
null	as s_is_template,

null	as o_object_id,
null	as o_instance_id,
null	as o_objecttype_id,
null	as o_name1,
null	as o_name2,
null	as o_is_active,

null	as hst_host_id,
null	as hst_instance_id,
null	as hst_host_object_id,
null	as hst_alias,
null	as hst_display_name,
null	as hst_address,
null	as hst_check_command_object_id,
null	as hst_check_command_args,

null	as svc_service_id,
null	as svc_instance_id,
null	as svc_host_object_id,
null	as svc_service_object_id,
null	as svc_display_name,
null	as svc_check_command_object_id,
null	as svc_check_command_args,

null	as m_networkports_id,
null	as m_softwareversions_id,
null	as m_host_object_id,
null	as m_service_object_id,
null	as m_is_active,
null	as m_type

from glpi_computers c, glpi_networkports n
where 
     n.itemtype = "Computer" and
     c.id = n.items_id and 
     not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id) and
     not exists (select 1 from itvision_monitor m where m.networkports_id = n.id);

     
/*
   QUERY 2 - computador com porta com software e sem monitor
*/
select

c.id			as c_id,
c.entities_id		as c_entities_id,
c.name			as c_name,
c.serial		as c_serial,
c.otherserial		as c_otherserial,
c.locations_id		as c_locations_id,
c.is_template		as c_is_template,
c.is_deleted		as c_is_deleted,
c.states_id		as c_states_id,

n.id			as n_id,
n.items_id		as n_items_id,
n.itemtype		as n_itemtype,
n.entities_id		as n_entities_id,
n.logical_number	as n_logical_number,
n.name			as n_name,
n.ip			as n_ip,

csv.id			as csv_id,
csv.computers_id	as csv_computers_id,
csv.softwareversions_id	as csv_softwareversions_id,

sv.id			as sv_id,
sv.entities_id		as sv_entities_id,
sv.softwares_id		as sv_softwares_id,
sv.states_id		as sv_states_id,
sv.name			as sv_name,
sv.comment		as sv_comment,

s.id			as s_id,
s.entities_id		as s_entities_id,
s.is_recursive		as s_is_recursive,
s.name			as s_name,
s.locations_id		as s_locations_id,
s.is_deleted		as s_is_deleted,
s.is_template		as s_is_template,

null	as o_object_id,
null	as o_instance_id,
null	as o_objecttype_id,
null	as o_name1,
null	as o_name2,
null	as o_is_active,

null	as hst_host_id,
null	as hst_instance_id,
null	as hst_host_object_id,
null	as hst_alias,
null	as hst_display_name,
null	as hst_address,
null	as hst_check_command_object_id,
null	as hst_check_command_args,

null	as svc_service_id,
null	as svc_instance_id,
null	as svc_host_object_id,
null	as svc_service_object_id,
null	as svc_display_name,
null	as svc_check_command_object_id,
null	as svc_check_command_args,

null	as m_networkports_id,
null	as m_softwareversions_id,
null	as m_host_object_id,
null	as m_service_object_id,
null	as m_is_active,
null	as m_type

from glpi_computers c, glpi_networkports n, glpi_computers_softwareversions csv, glpi_softwareversions sv, glpi_softwares s
where 
     n.itemtype = "Computer" and
     c.id = n.items_id and 
     c.id = csv.computers_id and
     csv.softwareversions_id = sv.id and
     sv.softwares_id = s.id and
     not exists (select 1 from itvision_monitor m where m.networkports_id = n.id);


/*
   QUERY 3 - computador com porta sem software e com monitor - monitoracao de host onde o service eh ping

select

c.id			as c_id,
c.entities_id		as c_entities_id,
c.name			as c_name,
c.serial		as c_serial,
c.otherserial		as c_otherserial,
c.locations_id		as c_locations_id,
c.is_template		as c_is_template,
c.is_deleted		as c_is_deleted,
c.states_id		as c_states_id,

n.id			as n_id,
n.items_id		as n_items_id,
n.itemtype		as n_itemtype,
n.entities_id		as n_entities_id,
n.logical_number	as n_logical_number,
n.name			as n_name,
n.ip			as n_ip,

null	as csv_id,
null	as csv_computers_id,
null	as csv_softwareversions_id,

null	as sv_id,
null	as sv_entities_id,
null	as sv_softwares_id,
null	as sv_states_id,
null	as sv_name,
null	as sv_comment,

null	as s_id,
null	as s_entities_id,
null	as s_is_recursive,
null	as s_name,
null	as s_locations_id,
null	as s_is_deleted,
null	as s_is_template,

o.object_id		as o_object_id,
o.instance_id		as o_instance_id,
o.objecttype_id		as o_objecttype_id,
o.name1			as o_name1,
o.name2			as o_name2,
o.is_active		as o_is_active,

hst.host_id		as hst_host_id,
hst.instance_id		as hst_instance_id,
hst.host_object_id	as hst_host_object_id,
hst.alias		as hst_alias,
hst.display_name	as hst_display_name,
hst.address		as hst_address,
hst.check_command_object_id	as hst_check_command_object_id,
hst.check_command_args	as hst_check_command_args,

svc.service_id		as svc_service_id,
svc.instance_id		as svc_instance_id,
svc.host_object_id	as svc_host_object_id,
svc.service_object_id	as svc_service_object_id,
svc.display_name	as svc_display_name,
svc.check_command_object_id	as svc_check_command_object_id,
svc.check_command_args	as svc_check_command_args,

m.networkports_id	as m_networkports_id,
m.softwareversions_id	as m_softwareversions_id,
m.host_object_id	as m_host_object_id,
m.service_object_id	as m_service_object_id,
m.is_active		as m_is_active,
m.type			as m_type

from glpi_computers c, glpi_networkports n,
     nagios_objects o, nagios_hosts hst, nagios_services svc, itvision_monitor m
where
     n.itemtype = "Computer" and
     c.id = n.items_id and 
     n.id = m.networkports_id and
     m.host_object_id = o.object_id and
     m.service_object_id = o.object_id and
     not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id);
*/
select

c.id			as c_id,
c.entities_id		as c_entities_id,
c.name			as c_name,
c.serial		as c_serial,
c.otherserial		as c_otherserial,
c.locations_id		as c_locations_id,
c.is_template		as c_is_template,
c.is_deleted		as c_is_deleted,
c.states_id		as c_states_id,

n.id			as n_id,
n.items_id		as n_items_id,
n.itemtype		as n_itemtype,
n.entities_id		as n_entities_id,
n.logical_number	as n_logical_number,
n.name			as n_name,
n.ip			as n_ip,

null	as csv_id,
null	as csv_computers_id,
null	as csv_softwareversions_id,

null	as sv_id,
null	as sv_entities_id,
null	as sv_softwares_id,
null	as sv_states_id,
null	as sv_name,
null	as sv_comment,

null	as s_id,
null	as s_entities_id,
null	as s_is_recursive,
null	as s_name,
null	as s_locations_id,
null	as s_is_deleted,
null	as s_is_template,

o.object_id		as o_object_id,
o.instance_id		as o_instance_id,
o.objecttype_id		as o_objecttype_id,
o.name1			as o_name1,
o.name2			as o_name2,
o.is_active		as o_is_active,

null	as hst_host_id,
null	as hst_instance_id,
null	as hst_host_object_id,
null	as hst_alias,
null	as hst_display_name,
null	as hst_address,
null	as hst_check_command_object_id,
null	as hst_check_command_args,

null	as svc_service_id,
null	as svc_instance_id,
null	as svc_host_object_id,
null	as svc_service_object_id,
null	as svc_display_name,
null	as svc_check_command_object_id,
null	as svc_check_command_args,

m.networkports_id	as m_networkports_id,
m.softwareversions_id	as m_softwareversions_id,
m.host_object_id	as m_host_object_id,
m.service_object_id	as m_service_object_id,
m.is_active		as m_is_active,
m.type			as m_type

from glpi_computers c, glpi_networkports n,
     nagios_objects o, itvision_monitor m
where
     n.itemtype = "Computer" and
     c.id = n.items_id and 
     n.id = m.networkports_id and
     not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id);

/*
   QUERY 4 - computador com porta com software e com monitor - monitoracao de service por isso tem software associado
*/
select

c.id			as c_id,
c.entities_id		as c_entities_id,
c.name			as c_name,
c.serial		as c_serial,
c.otherserial		as c_otherserial,
c.locations_id		as c_locations_id,
c.is_template		as c_is_template,
c.is_deleted		as c_is_deleted,
c.states_id		as c_states_id,

n.id			as n_id,
n.items_id		as n_items_id,
n.itemtype		as n_itemtype,
n.entities_id		as n_entities_id,
n.logical_number	as n_logical_number,
n.name			as n_name,
n.ip			as n_ip,

csv.id			as csv_id,
csv.computers_id	as csv_computers_id,
csv.softwareversions_id	as csv_softwareversions_id,

sv.id			as sv_id,
sv.entities_id		as sv_entities_id,
sv.softwares_id		as sv_softwares_id,
sv.states_id		as sv_states_id,
sv.name			as sv_name,
sv.comment		as sv_comment,

s.id			as s_id,
s.entities_id		as s_entities_id,
s.is_recursive		as s_is_recursive,
s.name			as s_name,
s.locations_id		as s_locations_id,
s.is_deleted		as s_is_deleted,
s.is_template		as s_is_template,

o.object_id		as o_object_id,
o.instance_id		as o_instance_id,
o.objecttype_id		as o_objecttype_id,
o.name1			as o_name1,
o.name2			as o_name2,
o.is_active		as o_is_active,

hst.host_id		as hst_host_id,
hst.instance_id		as hst_instance_id,
hst.host_object_id	as hst_host_object_id,
hst.alias		as hst_alias,
hst.display_name	as hst_display_name,
hst.address		as hst_address,
hst.check_command_object_id	as hst_check_command_object_id,
hst.check_command_args	as hst_check_command_args,

svc.service_id		as svc_service_id,
svc.instance_id		as svc_instance_id,
svc.host_object_id	as svc_host_object_id,
svc.service_object_id	as svc_service_object_id,
svc.display_name	as svc_display_name,
svc.check_command_object_id	as svc_check_command_object_id,
svc.check_command_args	as svc_check_command_args,

m.networkports_id	as m_networkports_id,
m.softwareversions_id	as m_softwareversions_id,
m.host_object_id	as m_host_object_id,
m.service_object_id	as m_service_object_id,
m.is_active		as m_is_active,
m.type			as m_type

from glpi_computers c, glpi_networkports n, glpi_computers_softwareversions csv, glpi_softwareversions sv, glpi_softwares s,
     nagios_objects o, nagios_hosts hst, nagios_services svc, itvision_monitor m
where
     n.itemtype = "Computer" and
     c.id = n.items_id and 
     c.id = csv.computers_id and
     csv.softwareversions_id = sv.id and
     sv.softwares_id = s.id and
     n.id = m.networkports_id and
     m.host_object_id = o.object_id and
     m.service_object_id = o.object_id and
     m.softwareversions_id = sv.id;



/*
   todas as colunas
*/

show columns from glpi_computers;
show columns from glpi_networkports;
show columns from glpi_computers_softwareversions;
show columns from glpi_softwareversions;
show columns from glpi_softwares;
show columns from nagios_objects;
show columns from nagios_hosts;
show columns from nagios_services;
show columns from itvision_monitor;

/*
   lista completa de colunas somente 
*/


glpi_computers
id
entities_id
name
serial
otherserial
contact
contact_num
users_id_tech
comment
date_mod
operatingsystems_id
operatingsystemversions_id
operatingsystemservicepacks_id
os_license_number
os_licenseid
autoupdatesystems_id
locations_id
domains_id
networks_id
computermodels_id
computertypes_id
is_template
template_name
manufacturers_id
is_deleted
notepad
is_ocs_import
users_id
groups_id
states_id
ticket_tco

glpi_networkports
id
items_id
itemtype
entities_id
is_recursive
logical_number
name
ip
mac
networkinterfaces_id
netpoints_id
netmask
gateway
subnet

glpi_computers_softwareversions
id
computers_id
softwareversions_id

glpi_softwareversions
id
entities_id
is_recursive
softwares_id
states_id
name
comment

glpi_softwares
id
entities_id
is_recursive
name
comment
locations_id
users_id_tech
operatingsystems_id
is_update
softwares_id
manufacturers_id
is_deleted
is_template
template_name
date_mod
notepad
users_id
groups_id
ticket_tco
is_helpdesk_visible
softwarecategories_id

nagios_objects
object_id
instance_id
objecttype_id
name1
name2
is_active

nagios_hosts
host_id
instance_id
config_type
host_object_id
alias
display_name
address
check_command_object_id
check_command_args
eventhandler_command_object_id
eventhandler_command_args
notification_timeperiod_object_id
check_timeperiod_object_id
failure_prediction_options
check_interval
retry_interval
max_check_attempts
first_notification_delay
notification_interval
notify_on_down
notify_on_unreachable
notify_on_recovery
notify_on_flapping
notify_on_downtime
stalk_on_up
stalk_on_down
stalk_on_unreachable
flap_detection_enabled
flap_detection_on_up
flap_detection_on_down
flap_detection_on_unreachable
low_flap_threshold
high_flap_threshold
process_performance_data
freshness_checks_enabled
freshness_threshold
passive_checks_enabled
event_handler_enabled
active_checks_enabled
retain_status_information
retain_nonstatus_information
notifications_enabled
obsess_over_host
failure_prediction_enabled
notes
notes_url
action_url
icon_image
icon_image_alt
vrml_image
statusmap_image
have_2d_coords
x_2d
y_2d
have_3d_coords
x_3d
y_3d
z_3d
networkports_id

nagios_services
service_id
instance_id
config_type
host_object_id
service_object_id
display_name
check_command_object_id
check_command_args
eventhandler_command_object_id
eventhandler_command_args
notification_timeperiod_object_id
check_timeperiod_object_id
failure_prediction_options
check_interval
retry_interval
max_check_attempts
first_notification_delay
notification_interval
notify_on_warning
notify_on_unknown
notify_on_critical
notify_on_recovery
notify_on_flapping
notify_on_downtime
stalk_on_ok
stalk_on_warning
stalk_on_unknown
stalk_on_critical
is_volatile
flap_detection_enabled
flap_detection_on_ok
flap_detection_on_warning
flap_detection_on_unknown
flap_detection_on_critical
low_flap_threshold
high_flap_threshold
process_performance_data
freshness_checks_enabled
freshness_threshold
passive_checks_enabled
event_handler_enabled
active_checks_enabled
retain_status_information
retain_nonstatus_information
notifications_enabled
obsess_over_service
failure_prediction_enabled
notes
notes_url
action_url
icon_image
icon_image_alt

itvision_monitor
networkports_id
softwareversions_id
host_object_id
service_object_id
is_active
type


/*
   primeira selecao de colunas 
*/

-- glpi_computers
id
entities_id
name
serial
otherserial
comment
locations_id
computermodels_id
computertypes_id
is_template
is_deleted
states_id

-- glpi_networkports
id
items_id
itemtype
entities_id
logical_number
name
ip

-- glpi_computers_softwareversions
id
computers_id
softwareversions_id

-- glpi_softwareversions
id
entities_id
softwares_id
states_id
name
comment

-- glpi_softwares
id
entities_id
is_recursive
name
comment
locations_id
softwares_id
is_deleted
is_template
is_helpdesk_visible

-- nagios_objects
object_id
instance_id
objecttype_id
name1
name2
is_active

-- nagios_hosts
host_id
instance_id
config_type
host_object_id
alias
display_name
address
check_command_object_id
check_command_args

-- nagios_services
service_id
instance_id
config_type
host_object_id
service_object_id
display_name
check_command_object_id
check_command_args

-- itvision_monitor
networkports_id
softwareversions_id
host_object_id
service_object_id
is_active
type

/*
  selecao minima de colunas
*/


-- glpi_computers
id
entities_id
name
serial
otherserial
locations_id
is_template
is_deleted
states_id

-- glpi_networkports
id
items_id
itemtype
entities_id
logical_number
name
ip

-- glpi_computers_softwareversions
id
computers_id
softwareversions_id

-- glpi_softwareversions
id
entities_id
softwares_id
states_id
name
comment

-- glpi_softwares
id
entities_id
is_recursive
name
locations_id
is_deleted
is_template

-- nagios_objects
object_id
instance_id
objecttype_id
name1
name2
is_active

-- nagios_hosts
host_id
instance_id
host_object_id
alias
display_name
address
check_command_object_id
check_command_args

-- nagios_services
service_id
instance_id
host_object_id
service_object_id
display_name
check_command_object_id
check_command_args

-- itvision_monitor
networkports_id
softwareversions_id
host_object_id
service_object_id
is_active
type

/*
   para colocar na query
*/


-- glpi_computers
c.id			as c_id,
c.entities_id		as c_entities_id,
c.name			as c_name,
c.serial		as c_serial,
c.otherserial		as c_otherserial,
c.locations_id		as c_locations_id,
c.is_template		as c_is_template,
c.is_deleted		as c_is_deleted,
c.states_id		as c_states_id,

-- glpi_networkports
n.id			as n_id,
n.items_id		as n_items_id,
n.itemtype		as n_itemtype,
n.entities_id		as n_entities_id,
n.logical_number	as n_logical_number,
n.name			as n_name,
n.ip			as n_ip,

-- glpi_computers_softwareversions
csv.id			as csv_id,
csv.computers_id	as csv_computers_id,
csv.softwareversions_id	as csv_softwareversions_id,

-- glpi_softwareversions
sv.id			as sv_id,
sv.entities_id		as sv_entities_id,
sv.softwares_id		as sv_softwares_id,
sv.states_id		as sv_states_id,
sv.name			as sv_name,
sv.comment		as sv_comment,

-- glpi_softwares
s.id			as s_id,
s.entities_id		as s_entities_id,
s.is_recursive		as s_is_recursive,
s.name			as s_name,
s.locations_id		as s_locations_id,
s.is_deleted		as s_is_deleted,
s.is_template		as s_is_template,

-- nagios_objects
o.object_id		as o_object_id,
o.instance_id		as o_instance_id,
o.objecttype_id		as o_objecttype_id,
o.name1			as o_name1,
o.name2			as o_name2,
o.is_active		as o_is_active,

-- nagios_hosts
hst.host_id		as hst_host_id,
hst.instance_id		as hst_instance_id,
hst.host_object_id	as hst_host_object_id,
hst.alias		as hst_alias,
hst.display_name	as hst_display_name,
hst.address		as hst_address,
hst.check_command_object_id	as hst_check_command_object_id,
hst.check_command_args	as hst_check_command_args,

-- nagios_services
svc.service_id		as svc_service_id,
svc.instance_id		as svc_instance_id,
svc.host_object_id	as svc_host_object_id,
svc.service_object_id	as svc_service_object_id,
svc.display_name	as svc_display_name,
svc.check_command_object_id	as svc_check_command_object_id,
svc.check_command_args	as svc_check_command_args,

-- itvision_monitor
m.networkports_id	as m_networkports_id,
m.softwareversions_id	as m_softwareversions_id,
m.host_object_id	as m_host_object_id,
m.service_object_id	as m_service_object_id,
m.is_active		as m_is_active,
m.type			as m_type


