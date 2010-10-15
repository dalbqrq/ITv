require "Model"


--[[
      COMO OS RESULTADOS DESSAS QUERIES DEVEM SER JUNTADOS EM UMA ÚNICA LISTA, A LISTA DE CAMPOS DEVE SER 
      EXATAMENTE A MESMA ONDE O CONTEUDO DAS COLUNAS QUE NAO EXISTIREM SERÃO DE VALOR ''''.

      ESTAS DEVERÃO SER AS QUERIES DEFINITIVAS QUE VIRARÃO FUNCÕES EM UM MÓDULO LUA DO PROJETO ITvision
]]


--   QUERY 1 - computador com porta sem software e sem monitor

function query_1(c_id, n_id)

   local columns_ = [[
      c.id			as c_id,
      c.entities_id		as c_entities_id,
      c.name			as c_name,
      c.serial			as c_serial,
      c.otherserial		as c_otherserial,
      c.locations_id		as c_locations_id,
      c.is_template		as c_is_template,
      c.is_deleted		as c_is_deleted,
      c.states_id		as c_states_id,

      n.id			as n_id,
      n.items_id		as n_items_id,
      n.itemtype		as n_itemtype,
      n.entities_id		as n_entities_id,
      n.logical_number		as n_logical_number,
      n.name			as n_name,
      n.ip			as n_ip,

      ''			as csv_id,
      ''			as csv_computers_id,
      ''			as csv_softwareversions_id,

      ''			as sv_id,
      ''			as sv_entities_id,
      ''			as sv_softwares_id,
      ''			as sv_states_id,
      ''			as sv_name,
      ''			as sv_comment,

      ''			as s_id,
      ''			as s_entities_id,
      ''			as s_is_recursive,
      ''			as s_name,
      ''			as s_locations_id,
      ''			as s_is_deleted,
      ''			as s_is_template,

      ''			as o_object_id,
      ''			as o_instance_id,
      ''			as o_objecttype_id,
      ''			as o_name1,
      ''			as o_name2,
      ''			as o_is_active,

      ''			as hst_host_id,
      ''			as hst_instance_id,
      ''			as hst_host_object_id,
      ''			as hst_alias,
      ''			as hst_display_name,
      ''			as hst_address,
      ''			as hst_check_command_object_id,
      ''			as hst_check_command_args,

      ''			as svc_service_id,
      ''			as svc_instance_id,
      ''			as svc_host_object_id,
      ''			as svc_service_object_id,
      ''			as svc_display_name,
      ''			as svc_check_command_object_id,
      ''			as svc_check_command_args,

      ''			as m_networkports_id,
      ''			as m_softwareversions_id,
      ''			as m_host_object_id,
      ''			as m_service_object_id,
      ''			as m_is_active,
      ''			as m_type
      ]]

   local table_ = [[glpi_computers c, glpi_networkports n]]

   local cond_ = [[ n.itemtype = "Computer" and
           c.id = n.items_id and 
           not exists (select 1 from itvision_monitor m where m.networkports_id = n.id)]]
           --not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id) and

   if c_id  then cond_ = cond_ .. " and c.id = "  .. c_id  end
   if n_id  then cond_ = cond_ .. " and n.id = "  .. n_id  end

   local q = Model.query(table_, cond_, nil, columns_)
   for _,v in ipairs(q) do table.insert(v, 1, 1) end

   return q

end


           
--   QUERY 2 - computador com porta com software e sem monitor

function query_2(c_id, n_id, sv_id)

   local columns_ = [[
      c.id			as c_id,
      c.entities_id		as c_entities_id,
      c.name			as c_name,
      c.serial			as c_serial,
      c.otherserial		as c_otherserial,
      c.locations_id		as c_locations_id,
      c.is_template		as c_is_template,
      c.is_deleted		as c_is_deleted,
      c.states_id		as c_states_id,

      n.id			as n_id,
      n.items_id		as n_items_id,
      n.itemtype		as n_itemtype,
      n.entities_id		as n_entities_id,
      n.logical_number		as n_logical_number,
      n.name			as n_name,
      n.ip			as n_ip,

      csv.id			as csv_id,
      csv.computers_id		as csv_computers_id,
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

      ''			as o_object_id,
      ''			as o_instance_id,
      ''			as o_objecttype_id,
      ''			as o_name1,
      ''			as o_name2,
      ''			as o_is_active,

      ''			as hst_host_id,
      ''			as hst_instance_id,
      ''			as hst_host_object_id,
      ''			as hst_alias,
      ''			as hst_display_name,
      ''			as hst_address,
      ''			as hst_check_command_object_id,
      ''			as hst_check_command_args,

      ''			as svc_service_id,
      ''			as svc_instance_id,
      ''			as svc_host_object_id,
      ''			as svc_service_object_id,
      ''			as svc_display_name,
      ''			as svc_check_command_object_id,
      ''			as svc_check_command_args,

      ''			as m_networkports_id,
      ''			as m_softwareversions_id,
      ''			as m_host_object_id,
      ''			as m_service_object_id,
      ''			as m_is_active,
      ''			as m_type
      ]]

   local table_ = [[ glpi_computers c, glpi_networkports n, glpi_computers_softwareversions csv, 
                     glpi_softwareversions sv, glpi_softwares s]]

   local cond_ = [[ n.itemtype = "Computer" and
           c.id = n.items_id and 
           c.id = csv.computers_id and
           csv.softwareversions_id = sv.id and
           sv.softwares_id = s.id and
           not exists (select 1 from itvision_monitor m where m.networkports_id = n.id)]]

   if c_id  then cond_ = cond_ .. " and c.id = "  .. c_id  end
   if n_id  then cond_ = cond_ .. " and n.id = "  .. n_id  end
   if sv_id then cond_ = cond_ .. " and sv.id = " .. sv_id end

   local q = Model.query(table_, cond_, nil, columns_)
   for _,v in ipairs(q) do table.insert(v, 1, 2) end

   return q
end



--   QUERY 3 - computador com porta sem software e com monitor - monitoracao de host onde o service eh ping


function query_3(c_id, n_id)

   local columns_ = [[
      c.id			as c_id,
      c.entities_id		as c_entities_id,
      c.name			as c_name,
      c.serial			as c_serial,
      c.otherserial		as c_otherserial,
      c.locations_id		as c_locations_id,
      c.is_template		as c_is_template,
      c.is_deleted		as c_is_deleted,
      c.states_id		as c_states_id,

      n.id			as n_id,
      n.items_id		as n_items_id,
      n.itemtype		as n_itemtype,
      n.entities_id		as n_entities_id,
      n.logical_number		as n_logical_number,
      n.name			as n_name,
      n.ip			as n_ip,

      ''			as csv_id,
      ''			as csv_computers_id,
      ''			as csv_softwareversions_id,

      ''			as sv_id,
      ''			as sv_entities_id,
      ''			as sv_softwares_id,
      ''			as sv_states_id,
      ''			as sv_name,
      ''			as sv_comment,

      ''			as s_id,
      ''			as s_entities_id,
      ''			as s_is_recursive,
      ''			as s_name,
      ''			as s_locations_id,
      ''			as s_is_deleted,
      ''			as s_is_template,

      o.object_id		as o_object_id,
      o.instance_id		as o_instance_id,
      o.objecttype_id		as o_objecttype_id,
      o.name1			as o_name1,
      o.name2			as o_name2,
      o.is_active		as o_is_active,

      hst.host_id		as hst_host_id,
      hst.instance_id		as hst_instance_id,
      hst.host_object_id	as hst_host_object_id,
      hst.alias			as hst_alias,
      hst.display_name		as hst_display_name,
      hst.address		as hst_address,
      hst.check_command_object_id	as hst_check_command_object_id,
      hst.check_command_args	as hst_check_command_args,

      svc.service_id		as svc_service_id,
      svc.instance_id		as svc_instance_id,
      svc.host_object_id	as svc_host_object_id,
      svc.service_object_id	as svc_service_object_id,
      svc.display_name		as svc_display_name,
      svc.check_command_object_id	as svc_check_command_object_id,
      svc.check_command_args	as svc_check_command_args,

      m.networkports_id		as m_networkports_id,
      m.softwareversions_id	as m_softwareversions_id,
      m.host_object_id		as m_host_object_id,
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
 
   if c_id  then cond_ = cond_ .. " and c.id = "  .. c_id  end
   if n_id  then cond_ = cond_ .. " and n.id = "  .. n_id  end

   local q = Model.query(table_, cond_, nil, columns_)
   for _,v in ipairs(q) do table.insert(v, 1, 3) end

   return q
end



--   QUERY 4 - computador com porta com software e com monitor - monitoracao de service por isso tem software associado

function query_4(c_id, n_id, sv_id)

   local columns_ = [[
      c.id			as c_id,
      c.entities_id		as c_entities_id,
      c.name			as c_name,
      c.serial			as c_serial,
      c.otherserial		as c_otherserial,
      c.locations_id		as c_locations_id,
      c.is_template		as c_is_template,
      c.is_deleted		as c_is_deleted,
      c.states_id		as c_states_id,

      n.id			as n_id,
      n.items_id		as n_items_id,
      n.itemtype		as n_itemtype,
      n.entities_id		as n_entities_id,
      n.logical_number		as n_logical_number,
      n.name			as n_name,
      n.ip			as n_ip,

      csv.id			as csv_id,
      csv.computers_id		as csv_computers_id,
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
      hst.alias			as hst_alias,
      hst.display_name		as hst_display_name,
      hst.address		as hst_address,
      hst.check_command_object_id	as hst_check_command_object_id,
      hst.check_command_args	as hst_check_command_args,

      svc.service_id		as svc_service_id,
      svc.instance_id		as svc_instance_id,
      svc.host_object_id	as svc_host_object_id,
      svc.service_object_id	as svc_service_object_id,
      svc.display_name		as svc_display_name,
      svc.check_command_object_id	as svc_check_command_object_id,
      svc.check_command_args	as svc_check_command_args,

      m.networkports_id		as m_networkports_id,
      m.softwareversions_id	as m_softwareversions_id,
      m.host_object_id		as m_host_object_id,
      m.service_object_id	as m_service_object_id,
      m.is_active		as m_is_active,
      m.type			as m_type
      ]]

   local table_ = [[ glpi_computers c, glpi_networkports n, glpi_computers_softwareversions csv, 
                     glpi_softwareversions sv, glpi_softwares s,
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

   if c_id  then cond_ = cond_ .. " and c.id = "  .. c_id  end
   if n_id  then cond_ = cond_ .. " and n.id = "  .. n_id  end
   if sv_id then cond_ = cond_ .. " and sv.id = " .. sv_id end

   local q = Model.query(table_, cond_, nil, columns_)
   for _,v in ipairs(q) do table.insert(v, 1, 4) end

   return q
end


--[[
  AS DUAS PROXIMAS QUERIES SAO RELACIONADAS A TABELA DE "NetworkEquipment" E REPRODUZEM 
  AS QUERIES 1 E 3 
]]

--   QUERY 5 - computador com porta sem software e sem monitor

function query_5(c_id, n_id)

   local columns_ = [[
      c.id			as c_id,
      c.entities_id		as c_entities_id,
      c.name			as c_name,
      c.serial			as c_serial,
      c.otherserial		as c_otherserial,
      c.locations_id		as c_locations_id,
      c.is_template		as c_is_template,
      c.is_deleted		as c_is_deleted,
      c.states_id		as c_states_id,

      n.id			as n_id,
      n.items_id		as n_items_id,
      n.itemtype		as n_itemtype,
      n.entities_id		as n_entities_id,
      n.logical_number		as n_logical_number,
      n.name			as n_name,
      n.ip			as n_ip,

      ''			as csv_id,
      ''			as csv_computers_id,
      ''			as csv_softwareversions_id,

      ''			as sv_id,
      ''			as sv_entities_id,
      ''			as sv_softwares_id,
      ''			as sv_states_id,
      ''			as sv_name,
      ''			as sv_comment,

      ''			as s_id,
      ''			as s_entities_id,
      ''			as s_is_recursive,
      ''			as s_name,
      ''			as s_locations_id,
      ''			as s_is_deleted,
      ''			as s_is_template,

      ''			as o_object_id,
      ''			as o_instance_id,
      ''			as o_objecttype_id,
      ''			as o_name1,
      ''			as o_name2,
      ''			as o_is_active,

      ''			as hst_host_id,
      ''			as hst_instance_id,
      ''			as hst_host_object_id,
      ''			as hst_alias,
      ''			as hst_display_name,
      ''			as hst_address,
      ''			as hst_check_command_object_id,
      ''			as hst_check_command_args,

      ''			as svc_service_id,
      ''			as svc_instance_id,
      ''			as svc_host_object_id,
      ''			as svc_service_object_id,
      ''			as svc_display_name,
      ''			as svc_check_command_object_id,
      ''			as svc_check_command_args,

      ''			as m_networkports_id,
      ''			as m_softwareversions_id,
      ''			as m_host_object_id,
      ''			as m_service_object_id,
      ''			as m_is_active,
      ''			as m_type
      ]]

   local table_ = [[glpi_networkequipments c, glpi_networkports n]]

   local cond_ = [[ n.itemtype = "NetworkEquipment" and
           c.id = n.items_id and 
           not exists (select 1 from itvision_monitor m where m.networkports_id = n.id)]]
           --not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id) and

   if c_id  then cond_ = cond_ .. " and c.id = "  .. c_id  end
   if n_id  then cond_ = cond_ .. " and n.id = "  .. n_id  end

   local q = Model.query(table_, cond_, nil, columns_)
   for _,v in ipairs(q) do table.insert(v, 1, 5) end

   return q
end




--   QUERY 6 - computador com porta sem software e com monitor - monitoracao de host onde o service eh ping


function query_6(c_id, n_id)

   local columns_ = [[
      c.id			as c_id,
      c.entities_id		as c_entities_id,
      c.name			as c_name,
      c.serial			as c_serial,
      c.otherserial		as c_otherserial,
      c.locations_id		as c_locations_id,
      c.is_template		as c_is_template,
      c.is_deleted		as c_is_deleted,
      c.states_id		as c_states_id,

      n.id			as n_id,
      n.items_id		as n_items_id,
      n.itemtype		as n_itemtype,
      n.entities_id		as n_entities_id,
      n.logical_number		as n_logical_number,
      n.name			as n_name,
      n.ip			as n_ip,

      ''			as csv_id,
      ''			as csv_computers_id,
      ''			as csv_softwareversions_id,

      ''			as sv_id,
      ''			as sv_entities_id,
      ''			as sv_softwares_id,
      ''			as sv_states_id,
      ''			as sv_name,
      ''			as sv_comment,

      ''			as s_id,
      ''			as s_entities_id,
      ''			as s_is_recursive,
      ''			as s_name,
      ''			as s_locations_id,
      ''			as s_is_deleted,
      ''			as s_is_template,

      o.object_id		as o_object_id,
      o.instance_id		as o_instance_id,
      o.objecttype_id		as o_objecttype_id,
      o.name1			as o_name1,
      o.name2			as o_name2,
      o.is_active		as o_is_active,

      hst.host_id		as hst_host_id,
      hst.instance_id		as hst_instance_id,
      hst.host_object_id	as hst_host_object_id,
      hst.alias			as hst_alias,
      hst.display_name		as hst_display_name,
      hst.address		as hst_address,
      hst.check_command_object_id	as hst_check_command_object_id,
      hst.check_command_args	as hst_check_command_args,

      svc.service_id		as svc_service_id,
      svc.instance_id		as svc_instance_id,
      svc.host_object_id	as svc_host_object_id,
      svc.service_object_id	as svc_service_object_id,
      svc.display_name		as svc_display_name,
      svc.check_command_object_id	as svc_check_command_object_id,
      svc.check_command_args	as svc_check_command_args,

      m.networkports_id		as m_networkports_id,
      m.softwareversions_id	as m_softwareversions_id,
      m.host_object_id		as m_host_object_id,
      m.service_object_id	as m_service_object_id,
      m.is_active		as m_is_active,
      m.type			as m_type
      ]]

   local table_ = [[ glpi_networkequipments c, glpi_networkports n,
                     nagios_objects o, nagios_hosts hst, nagios_services svc, itvision_monitor m]]

   local cond_ = [[ n.itemtype = "NetworkEquipment" and
           c.id = n.items_id and 
           n.id = m.networkports_id and
           m.host_object_id = o.object_id and
           m.service_object_id = o.object_id and
           not exists (select 1 from glpi_computers_softwareversions csv where c.id = csv.computers_id)]]
 
   if c_id  then cond_ = cond_ .. " and c.id = "  .. c_id  end
   if n_id  then cond_ = cond_ .. " and n.id = "  .. n_id  end

   local q = Model.query(table_, cond_, nil, columns_)
   for _,v in ipairs(q) do table.insert(v, 1, 6) end

   return q
end


           
-- A FUNCAO ABAIXO JUNTA O RESULTADO DE TODAS AS QUERIES (1 à 6) EM UM UNICO RESULT SET

function select_monitors()
   local q = {}
   local q1 = query_1()
   local q2 = query_2()
   local q3 = query_3()
   local q4 = query_4()
   local q5 = query_5()
   local q6 = query_6()

   for _,v in ipairs(q1) do table.insert(q, v) end
   for _,v in ipairs(q2) do table.insert(q, v) end
   for _,v in ipairs(q3) do table.insert(q, v) end
   for _,v in ipairs(q4) do table.insert(q, v) end
   for _,v in ipairs(q5) do table.insert(q, v) end
   for _,v in ipairs(q6) do table.insert(q, v) end

   return q
end


function select_checkcmds()
   local table_ = [[ nagios_objects ]]
   local cond_ = [[ objecttype_id = 12 and is_active = 1 and name1 not in 
      ('check-host-alive', 'notify-host-by-email', 'notify-service-by-email', 'process-host-perfdata', 'process-service-perfdata') ]]

   return Model.query(table_, cond_)
end


