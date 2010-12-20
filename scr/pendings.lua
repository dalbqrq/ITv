require "Model"


function update_pending()

   -- ATUALIZA OS HOSTS PENDENTES
   --local qry = [[ select object_id, name2 from nagios_objects where name1 = 
   --      (select networkports_id from itvision_monitors  where service_object_id = -1 and softwareversions_id is null) 
   --      and name2 = ']]..config.monitor.check_host..[[' and objecttype_id = 2 ]]

   local cond_ = [[ name1 in (select networkports_id from itvision_monitors where service_object_id = -1 ) and
                    name2 is not null ]]

   local res = Model.query("nagios_objects", cond_, nil, "object_id, name1, name2")

   for i, v in ipairs(res) do
      local n_id, sv_id, sv = v.name1, v.name2
      if sv_id ~= config.monitor.check_host then 
         sv_id = " = "..sv_id 
         sv    = v.name2
      else 
         sv_id = "is null" 
         sv    = nil
      end

      local udt = { service_object_id = v.object_id, softwareversions_id = sv, state = 1 }
      local cond_ = [[service_object_id = -1 and networkports_id = ]]..n_id..[[ and softwareversions_id ]]..sv_id

      print(v.object_id, v.name1, v.name2, cond_)
      Model.update("itvision_monitors", udt, cond_)
   end

end

update_pending()

