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

   --[[select count(*), ss.current_state 
   from nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_computers c
   where ss.service_object_id = o.object_id
       and o.name2 <> 'HOST_ALIVE' and o.name1 <> 'BUSPROC_HOST' and o.objecttype_id = 2
       and m.service_object_id = o.object_id
       and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'Computer'
       and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1
   group by ss.current_state;]]
   
   c = [[count(*) as count, ss.current_state as state]]
   t = [[nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_computers c]]
   r = [[ss.service_object_id = o.object_id
       and o.name2 <> 'HOST_ALIVE' and o.name1 <> 'BUSPROC_HOST' and o.objecttype_id = 2
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
   
   --[[select count(*), ss.current_state 
   from nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_networkequipments c
   where ss.service_object_id = o.object_id
       and o.name2 <> 'HOST_ALIVE' and o.name1 <> 'BUSPROC_HOST' and o.objecttype_id = 2
       and m.service_object_id = o.object_id
       and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'NetworkEquipment'
       and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1
   group by ss.current_state;]]

   c = [[count(*) as count, ss.current_state as state]]
   t = [[nagios_servicestatus ss, nagios_objects o, itvision_monitors m, glpi_networkports p, glpi_networkequipments c]]
   r = [[ss.service_object_id = o.object_id
       and o.name2 <> 'HOST_ALIVE' and o.name1 <> 'BUSPROC_HOST' and o.objecttype_id = 2
       and m.service_object_id = o.object_id
       and m.networkports_id = p.id and p.items_id = c.id and p.itemtype = 'NetworkEquipment'
       and c.is_deleted = 0 and c.is_template = 0 and c.states_id = 1]]
   e = [[group by ss.current_state]]
   q2 = Model.query(t, r, e, c)
--[[DEBUG
   for j,w in ipairs(q2) do
      print(w.state, w.count)
   end
   print("------------------------------")
]]

   res = make_result_table(res, q)
   res = make_result_table(res, q2)
   return res
end


function count_services()
   local res = {}

   --[[select count(*), ss.current_state 
   from nagios_servicestatus ss, nagios_objects o
   where ss.service_object_id = o.object_id
       and o.name2 = 'HOST_ALIVE' and o.objecttype_id = 2
   group by ss.current_state;]]

   c = [[count(*) as count, ss.current_state as state]]
   t = [[nagios_servicestatus ss, nagios_objects o]]
   r = [[ss.service_object_id = o.object_id
       and o.name2 = 'HOST_ALIVE' and o.objecttype_id = 2]]
   e = [[group by ss.current_state]]
   q = Model.query(t, r, e, c)

   res = make_result_table(res, q)
   return res
end


function count_apps()
   local res = {}

   --[[select count(*), ss.current_state 
   from nagios_servicestatus ss, nagios_objects o, itvision_apps a
   where ss.service_object_id = o.object_id
       and o.name1 = 'BUSPROC_HOST' and o.objecttype_id = 2
       and a.is_entity_root = 0
   group by ss.current_state;]]

   c = [[count(*) as count, ss.current_state as state]]
   t = [[nagios_servicestatus ss, nagios_objects o, itvision_apps a]]
   r = [[ss.service_object_id = o.object_id
       and o.name1 = 'BUSPROC_HOST' and o.objecttype_id = 2
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
       and o.name1 = 'BUSPROC_HOST' and o.objecttype_id = 2
       and o.object_id = a.service_object_id
       and a.is_entity_root = 1]]
   e = [[group by ss.current_state]]
   q = Model.query(t, r, e, c)

   res = make_result_table(res, q)
   return res
end


function counter()
   local bar = {}
   local row = {}
   local h = count_hosts()
   local s = count_services()
   local a = count_apps()
   local e = count_entities()
--[[DEBUG: 
   print_result(h)
   print_result(s)
   print_result(a)
   print_result(e)
  
   table.insert(bar,h)
   table.insert(bar,s)
   table.insert(bar,a)
   table.insert(bar,e)

   bar['hst'] = h
   bar['svc'] = s
   bar['app'] = a
   bar['ent'] = e

   for i,v in pairs(bar) do
      print("+++ "..i.." ++++++++++++++++")
      for j = 0,3 do
         print(j, v[j])
      end
   end
]]

   row = { strings.entity, e[0], e[1], e[2], e[3], strings.application, a[0], a[1], a[2], a[3], 
           strings.host,   h[0], h[1], h[2], h[3], strings.service,     s[0], s[1], s[2], s[3]  }

   return row
end

function render_counter(web)
   local row = {}
   local col = {}
   local hea = {}
   local span = 1
   local bgclass = "tab_bg_1"
   local class = "tab_cadre_fixe"
   local counts = counter()

   local h = count_hosts()
   local s = count_services()
   local a = count_apps()
   local e = count_entities()
   local white = "#FFFFFF"

   web.prefix = "/orb/app_monitor"

   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=white, strings.entity..":" }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[0].color, H("a"){ href= web:link("/all:ent:0:0"), e[0] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[1].color, H("a"){ href= web:link("/all:ent:0:1"), e[1] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[2].color, H("a"){ href= web:link("/all:ent:0:2"), e[2] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[3].color, H("a"){ href= web:link("/all:ent:0:3"), e[3] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=white, strings.application..":" }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[0].color, H("a"){ href= web:link("/all:app:0:0"), a[0] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[1].color, H("a"){ href= web:link("/all:app:0:1"), a[1] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[2].color, H("a"){ href= web:link("/all:app:0:2"), a[2] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[3].color, H("a"){ href= web:link("/all:app:0:3"), a[3] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=white, strings.host..":" }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[0].color, H("a"){ href= web:link("/all:hst:0:0"), h[0] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[1].color, H("a"){ href= web:link("/all:hst:0:1"), h[1] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[2].color, H("a"){ href= web:link("/all:hst:0:2"), h[2] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[3].color, H("a"){ href= web:link("/all:hst:0:3"), h[3] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=white, strings.service..":" }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[0].color, H("a"){ href= web:link("/all:svc:0:0"), s[0] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[1].color, H("a"){ href= web:link("/all:svc:0:1"), s[1] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[2].color, H("a"){ href= web:link("/all:svc:0:2"), s[2] } }
   col[#col+1] = td{ border="0", align="center", colspan=span, bgcolor=applic_alert[3].color, H("a"){ href= web:link("/all:svc:0:3"), s[3] } }

   row[#row+1] = tr{ class=bgclass, col }

   return H("table") { border="0", bordercolor="black", class=class, tbody{ row } }
end

--render_counter()

