require "Model"
require "App"


function sync_apps()
   --   local udt = [[ update itvision_apps a set service_object_id = 
   --         (select object_id from nagios_objects o where a.id = o.name2 and name1 = ']]..
   --         config.monitor.check_app..[[') where a.service_object_id is null ]]

   local app = Model.query("itvision_apps a, nagios_objects o",  
       "o.is_active = 1 and a.service_object_id is null and a.id = o.name2 and name1 = '"..config.monitor.check_app.."'" ,
       nil, "a.id as app_id, o.object_id as object_id")

   for i,v in ipairs(app) do
      local root_id
      -- print(v.app_id,  config.database.instance_id, v.object_id, 'app' )
      local sub_root = Model.query( "itvision_apps a, glpi_entities e, itvision_apps p", 
        "a.entities_id = e.id and e.entities_id = p.entities_id and a.id = "..v.app_id, nil, "p.id as id" ) 

      if sub_root[1] then 
         root_id = sub_root[1].id 
      else 
         root_id = App.select_root_app_tree ()
      end

      local ao = { app_id = root_id, instance_id = config.database.instance_id, 
                   service_object_id = v.object_id, type = 'app' }
      print(table.dump(ao).."\n")
      Model.update("itvision_apps", { service_object_id = v.object_id }, "id = "..v.app_id)
      --Model.insert("itvision_app_objects", ao)
   end

end

