require "Model"
require "App"


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


