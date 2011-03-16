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


function update_new_apps()
   --   local udt = [[ update itvision_apps a set service_object_id = 
   --         (select object_id from nagios_objects o where a.id = o.name2 and name1 = ']]..
   --         config.monitor.check_app..[[') where a.service_object_id is null ]]

   local app = Model.query("itvision_apps a, nagios_objects o",  
       "a.service_object_id is null and a.id = o.name2 and name1 = '"..config.monitor.check_app.."'" ,
       nil, "a.id as app_id, o.object_id as object_id")

   for i,v in ipairs(app) do
      -- print(v.app_id,  config.database.instance_id, v.object_id, 'app' )
      local _, root = App.select_root_app_tree ()
      local ao = { app_id = root.app_id, instance_id = config.database.instance_id, 
                   service_object_id = v.object_id, type = 'app' }
      Model.update("itvision_apps", { service_object_id = v.object_id }, "id = "..v.app_id)
      Model.insert("itvision_app_objects", ao)
   end

end


update_new_services()
update_new_apps()

