require "Model"


--[[

      COMO OS RESULTADOS DESSAS QUERIES DEVEM SER JUNTADOS EM UMA ÚNICA LISTA, A LISTA DE CAMPOS DEVE SER EXATAMENTE A MESMA
      ONDE O CONTEUDO DAS COLUNAS QUE NAO EXISTIREM SERÃO DE VALOR 'null'.

      ESTAS DEVERÃO SER AS QUERIES DEFINITIVAS QUE VIRARÃO FUNCÕES EM UM MÓDULO LUA DO PROJETO ITvision

]]


--   QUERY 1 - computador com porta sem software e sem monitor

function query_1()

   local columns_ = [[
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
      ]]

   local table_ = [[glpi_computers c, glpi_networkports n]]

   local cond_ = [[ n.itemtype = "Computer" and
           c.id = n.items_id and 
           not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id) and
           not exists (select 1 from itvision_monitor m where m.networkports_id = n.id)]]

   return Model.query(table_, cond_, nil, columns_)

end


           
--   QUERY 2 - computador com porta com software e sem monitor

function query_2()

   local columns_ = [[
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
      ]]

   local table_ = [[ glpi_computers c, glpi_networkports n, glpi_computers_softwareversions csv, glpi_softwareversions sv, glpi_softwares s]]

   local cond_ = [[ n.itemtype = "Computer" and
           c.id = n.items_id and 
           c.id = csv.computers_id and
           csv.softwareversions_id = sv.id and
           sv.softwares_id = s.id and
           not exists (select 1 from itvision_monitor m where m.networkports_id = n.id)]]

   return Model.query(table_, cond_, nil, columns_)

end



--   QUERY 3 - computador com porta sem software e com monitor - monitoracao de host onde o service eh ping


function query_3()

   local columns_ = [[
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
      ]]

   local table_ = [[ glpi_computers c, glpi_networkports n,
          nagios_objects o, nagios_hosts hst, nagios_services svc, itvision_monitor m]]

   local cond_ = [[ n.itemtype = "Computer" and
           c.id = n.items_id and 
           n.id = m.networkports_id and
           m.host_object_id = o.object_id and
           m.service_object_id = o.object_id and
           not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id)]]
 
   return Model.query(table_, cond_, nil, columns_)

end



--   QUERY 4 - computador com porta com software e com monitor - monitoracao de service por isso tem software associado

function query_4()

   local columns_ = [[
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
      ]]

   local table_ = [[ glpi_computers c, glpi_networkports n, glpi_computers_softwareversions csv, glpi_softwareversions sv, glpi_softwares s,
           nagios_objects o, nagios_hosts hst, nagios_services svc, itvision_monitor m]]
   local cond_ = [[ n.itemtype = "Computer" and
           c.id = n.items_id and 
           c.id = csv.computers_id and
           csv.softwareversions_id = sv.id and
           sv.softwares_id = s.id and
           n.id = m.networkports_id and
           m.host_object_id = o.object_id and
           m.service_object_id = o.object_id and
           m.softwareversions_id = sv.id]]

   return Model.query(table_, cond_, nil, columns_)

end




