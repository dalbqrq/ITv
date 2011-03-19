require "Model"
require "App"


function update_new_services()

   local res = Model.query("itvision_monitors m, nagios_objects o", 
      "m.service_object_id = -1 and o.name1 = m.name1 and o.name2 = m.name2 and o.is_active = 1",
       nil, "m.name1 as name1, m.name2 as name2")

   for i, v in ipairs(res) do
      local udt1 = [[ update itvision_monitors set state = 1, service_object_id = 
         (select object_id from nagios_objects where name1 = ']]..v.name1..[[' and name2 = ']]..v.name2..[[')
         where name1 = ']]..v.name1..[[' and name2 = ']]..v.name2..[[' ;]]
      local udt2 = [[ update itvision_checkcmd_params set service_object_id = 
         (select object_id from nagios_objects where name1 = ']]..v.name1..[[' and name2 = ']]..v.name2..[[')
         where name1 = ']]..v.name1..[[' and name2 = ']]..v.name2..[[' ;]]

      print( "Updating: ",v.name1, v.name2)
         
      Model.execute(udt1)
      Model.execute(udt2)
   end

end

--update_new_services()

