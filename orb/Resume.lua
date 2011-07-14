require "Model"
require "messages"
require "state"
require "monitor_inc"

module(Model.name, package.seeall, orbit.new)


function make_result_table(t, q)
   local empty = true
   --print("#: "..#q)
   if t and #t ~= 0  then empty = false --[[; print("p")]] end
   for i,v in pairs(applic_alert) do
      if empty == true then t[i] = 0 end
      --print (i,v.name, type(t), t[i])
      for _,w in pairs(q) do
         if tonumber(w.state) == i then t[i] = t[i] + tonumber(w.count) --[[; print(w.count)]] end
      end
   end

   return t
end

function print_result(res)
   print("=============================")
   for i,v in pairs(res) do
      print(i,v)
   end
   print("=============================")
end

function count_hosts()
   local res = {}

-- COMPUTERS HABILITADOS
   --[[select count(*), ss.current_state
   from nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_computers c
   where ss.service_object_id = o.object_id and ss.active_checks_enabled = 1
       and o.name2 = 'HOST_ALIVE' and o.objecttype_id = 2 and o.is_active = 1
       and m.service_object_id = o.object_id
       and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'Computer'
       and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1
   group by ss.current_state;]]
   
   c = [[count(*) as count, ss.current_state as state]]
   t = [[nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_computers c]]
   r = [[ss.service_object_id = o.object_id and ss.active_checks_enabled = 1
       and o.name2 = ']]..config.monitor.check_host..[[' and o.objecttype_id = 2 and o.is_active = 1
       and m.service_object_id = o.object_id
       and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'Computer'
       and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1]]
   e = [[group by ss.current_state]]
   q = Model.query(t, r, e, c)
--[[DEBUG
   for j,w in ipairs(q) do
      print(w.state, w.count)
   end
   print("------------------------------")
]]
   
-- NETWORKEQUIPMENTS HABILITADOS
   --[[select count(*), ss.current_state 
   from nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_networkequipments c
   where ss.service_object_id = o.object_id and ss.active_checks_enabled = 1
       and o.name2 = 'HOST_ALIVE' and o.objecttype_id = 2 and o.is_active = 1
       and m.service_object_id = o.object_id
       and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'NetworkEquipment'
       and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1
   group by ss.current_state;]]

   c = [[count(*) as count, ss.current_state as state]]
   t = [[nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_networkequipments c]]
   r = [[ss.service_object_id = o.object_id and ss.active_checks_enabled = 1
       and o.name2 = ']]..config.monitor.check_host..[[' and o.objecttype_id = 2 and o.is_active = 1
       and m.service_object_id = o.object_id
       and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'NetworkEquipment'
       and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1]]
   e = [[group by ss.current_state]]
   q2 = Model.query(t, r, e, c)

-- COMPUTERS DESABILITADOS
   --[[select count(*) as count, 5 as state
   from nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_computers c
   where ss.service_object_id = o.object_id and ss.active_checks_enabled = 0
       and o.name2 = 'HOST_ALIVE' and o.objecttype_id = 2 and o.is_active = 1
       and m.service_object_id = o.object_id
       and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'Computer'
       and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1]]
   
   c = [[count(*) as count, 5 as state]]
   t = [[nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_computers c]]
   r = [[ss.service_object_id = o.object_id and ss.active_checks_enabled = 0
       and o.name2 = ']]..config.monitor.check_host..[[' and o.objecttype_id = 2 and o.is_active = 1
       and m.service_object_id = o.object_id
       and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'Computer'
       and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1]]
   e = nil
   q3 = Model.query(t, r, e, c)
   
-- NETWORKEQUIPMENTS DESABILITADOS
   --[[select count(*) as count, 5 as state
   from nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_networkequipments c
   where ss.service_object_id = o.object_id and ss.active_checks_enabled = 0
       and o.name2 = 'HOST_ALIVE' and o.objecttype_id = 2 and o.is_active = 1
       and m.service_object_id = o.object_id
       and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'NetworkEquipment'
       and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1]]

   c = [[count(*) as count, 5 as state]]
   t = [[nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_networkequipments c]]
   r = [[ss.service_object_id = o.object_id and ss.active_checks_enabled = 0
       and o.name2 = ']]..config.monitor.check_host..[[' and o.objecttype_id = 2 and o.is_active = 1
       and m.service_object_id = o.object_id
       and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'NetworkEquipment'
       and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1]]
   e = nil
   q4 = Model.query(t, r, e, c)


   res = make_result_table(res, q)
   res = make_result_table(res, q2)
   res = make_result_table(res, q3)
   res = make_result_table(res, q4)
   return res
end


function count_services()
   local res = {}

--SERVICES HABILITADOS
   --[[select count(*), ss.current_state 
   from nagios_servicestatus ss, nagios_objects o
   where ss.service_object_id = o.object_id and ss.active_checks_enabled = 1
       and o.name2 <> 'HOST_ALIVE' and o.name1 <> 'BUSPROC_HOST' and o.objecttype_id = 2
       and o.is_active = 1 and o.name1 <> 'dummy'
   group by ss.current_state;]]

   c = [[count(*) as count, ss.current_state as state]]
   t = [[nagios_servicestatus ss, nagios_objects o, itvision_monitors m]]
   r = [[ss.service_object_id = o.object_id and ss.active_checks_enabled = 1
       and o.name2 <> ']]..config.monitor.check_host..[[' and o.name1 <> ']]..config.monitor.check_app..[[' and o.objecttype_id = 2
       and o.is_active = 1 and o.name1 <> 'dummy' and m.service_object_id = ss.service_object_id]]
   e = [[group by ss.current_state]]
   q = Model.query(t, r, e, c)


--SERVICES DESABILITADOS
   --[[select count(*) as count, 5 as state
   from nagios_servicestatus ss, nagios_objects o
   where ss.service_object_id = o.object_id and ss.active_checks_enabled = 0
       and o.name2 <> 'HOST_ALIVE' and o.name1 <> 'BUSPROC_HOST' and o.objecttype_id = 2
       and o.is_active = 1 and o.name1 <> 'dummy']]

   c = [[count(*) as count, 5 as state]]
   t = [[nagios_servicestatus ss, nagios_objects o, itvision_monitors m]]
   r = [[ss.service_object_id = o.object_id and ss.active_checks_enabled = 0
       and o.name2 <> ']]..config.monitor.check_host..[[' and o.name1 <> ']]..config.monitor.check_app..[[' and o.objecttype_id = 2
       and o.is_active = 1 and o.name1 <> 'dummy' and m.service_object_id = ss.service_object_id]]
   e = nil
   q2 = Model.query(t, r, e, c)

   res = make_result_table(res, q)
   res = make_result_table(res, q2)
   return res
end


function count_apps()
   local res = {}

   --[[select count(*), ss.current_state 
   from nagios_servicestatus ss, nagios_objects o, itvision_apps a
   where ss.service_object_id = o.object_id
       and o.name1 = 'BUSPROC_HOST' and o.objecttype_id = 2
       and o.object_id = a.service_object_id and o.is_active = 1
       and a.is_entity_root = 0
   group by ss.current_state;]]

   c = [[count(*) as count, ss.current_state as state]]
   t = [[nagios_servicestatus ss, nagios_objects o, itvision_apps a]]
   r = [[ss.service_object_id = o.object_id
       and o.name1 = ']]..config.monitor.check_app..[[' and o.objecttype_id = 2
       and o.object_id = a.service_object_id and o.is_active = 1
       and a.is_entity_root = 0]]
   e = [[group by ss.current_state]]
   q = Model.query(t, r, e, c)

   res = make_result_table(res, q)
   return res
end


function count_entities()
   local res = {}

   --[[select count(*), ss.current_state 
   from nagios_servicestatus ss, nagios_objects o, itvision_apps a
   where ss.service_object_id = o.object_id
       and o.name1 = 'BUSPROC_HOST' and o.objecttype_id = 2
       and o.object_id = a.service_object_id
       and a.is_entity_root = 1
   group by ss.current_state;]]

   c = [[count(*) as count, ss.current_state as state]]
   t = [[nagios_servicestatus ss, nagios_objects o, itvision_apps a]]
   r = [[ss.service_object_id = o.object_id
       and o.name1 = ']]..config.monitor.check_app..[[' and o.objecttype_id = 2
       and o.object_id = a.service_object_id
       and a.is_entity_root = 1]]
   e = [[group by ss.current_state]]
   q = Model.query(t, r, e, c)

   res = make_result_table(res, q)
   return res
end


function render_resume(web)
   local row = {}
   local col = {}
   local hea = {}
   local span = 1
   --local bgclass = "tab_bg_1"
   local bgclass = "tab_bg_X"
   --local class = "tab_cadre_fixe"
   --local class = "tab_glpi"
   local class = "tab_resume"
   local counts = counter()

   local h = count_hosts()
   local s = count_services()
   local a = count_apps()
   local e = count_entities()
   local white = "#FFFFFF"

   web.prefix = "/orb/app_monitor"

   col[#col+1] = td{ align="right", width="40px", bgcolor=white, "Entidades: " }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[0].color, H("a"){ href= web:link("/all:ent:0:0"), font{ color="black", e[0] } } }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[1].color, H("a"){ href= web:link("/all:ent:0:1"), font{ color="black", e[1] } } }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[2].color, H("a"){ href= web:link("/all:ent:0:2"), font{ color="white", e[2] } } }
   --col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[3].color, H("a"){ href= web:link("/all:ent:0:3"), font{ color="black", e[3] } } }
   col[#col+1] = td{ align="right", width="40px", bgcolor=white, "Aplicações: " }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[0].color, H("a"){ href= web:link("/all:app:0:0"), font{ color="black", a[0] } } }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[1].color, H("a"){ href= web:link("/all:app:0:1"), font{ color="black", a[1] } } }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[2].color, H("a"){ href= web:link("/all:app:0:2"), font{ color="white", a[2] } } }
   --col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[3].color, H("a"){ href= web:link("/all:app:0:3"), font{ color="black", a[3] } } }
   col[#col+1] = td{ align="right", width="40px", bgcolor=white, "Dispositivos: " }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[0].color, H("a"){ href= web:link("/all:hst:0:0"), font{ color="black", h[0] } } }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[1].color, H("a"){ href= web:link("/all:hst:0:1"), font{ color="black", h[1] } } }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[2].color, H("a"){ href= web:link("/all:hst:0:2"), font{ color="white", h[2] } } }
   --col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[3].color, H("a"){ href= web:link("/all:hst:0:3"), font{ color="black", h[3] } } }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[5].color, H("a"){ href= web:link("/all:hst:0:5"), font{ color="white", h[5] } } }
   col[#col+1] = td{ align="right", width="40px", bgcolor=white, "Serviços: " }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[0].color, H("a"){ href= web:link("/all:svc:0:0"), font{ color="black", s[0] } } }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[1].color, H("a"){ href= web:link("/all:svc:0:1"), font{ color="black", s[1] } } }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[2].color, H("a"){ href= web:link("/all:svc:0:2"), font{ color="white", s[2] } } }
   --col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[3].color, H("a"){ href= web:link("/all:svc:0:3"), font{ color="black", s[3] } } }
   col[#col+1] = td{ align="center", width="40px", bgcolor=applic_alert[5].color, H("a"){ href= web:link("/all:svc:0:5"), font{ color="white", s[5] } } }

   row[#row+1] = tr{ class=bgclass, col }

   return H("table") { class=class, tbody{ row } }
end

--render_counter()

