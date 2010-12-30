require "Model"


function update_pending()

   os.reset_monitor()

   -- ATUALIZA OS HOSTS PENDENTES

   local cond1 = " m.service_object_id = -1 and m.networkports_id = o.name1 and m.display_name = o.name2 "
   local res1 = Model.query("nagios_objects o, itvision_monitors m", cond1, nil, 
                           "o.object_id, o.name1, o.name2, m.networkports_id, m.softwareversions_id")

   local cond2 = " m.service_object_id = -1 and m.networkports_id = o.name1 and m.display_name is null "..
                 " and o.name2 = '"..config.monitor.check_host.."'"
   local res2 = Model.query("nagios_objects o, itvision_monitors m", cond2, nil, 
                           "o.object_id, o.name1, o.name2, m.networkports_id, m.softwareversions_id")
   
   for i, v in ipairs(res2) do
      table.insert(res1, v)
   end


   for i, v in ipairs(res1) do
      local n_id, sv_id, dpl, sv = v.name1, v.softwareversions_id, v.name2, nil
      if sv_id then 
         sv_id = " = "..sv_id 
         sv    = v.name2
      else 
         sv_id = "is null" 
      end
      if dpl ~= config.monitor.check_host then dpl = "= '"..dpl.."'" else dpl = " is null " end

      local udt = { service_object_id = v.object_id, state = 1 }
      local cond = [[service_object_id = -1 and networkports_id = ]]..n_id..[[ and softwareversions_id ]]..sv_id..
                    [[ and display_name ]]..dpl

      print(v.object_id, v.name1, v.name2, v.networkports_id, v.softwareversions_id, cond____)
      Model.update("itvision_monitors", udt, cond)
   end

end

update_pending()

