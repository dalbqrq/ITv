require "Model"
require "App"

--[[

   sync_apps: atualiza a tabela itvision_apps incluindo a entrada service_object_id quando esta 
   passar a existir na tabela nagios_objects.

]]


function sync_apps()

   local app = Model.query("itvision_apps a, nagios_objects o",  
       "o.is_active = 1 and a.service_object_id is null and a.id = o.name2 and name1 = '"..config.monitor.check_app.."'" ,
       nil, "a.id as app_id, o.object_id as object_id")

   for i,v in ipairs(app) do
      local p_id
      print(v.app_id,  config.database.instance_id, v.object_id, 'app' )
      Model.update("itvision_apps", { service_object_id = v.object_id }, "id = "..v.app_id)

      local parent_app = Model.query( "itvision_apps a, glpi_entities e, itvision_apps p", 
        "a.entities_id = e.id and e.entities_id = p.entities_id and a.id = "..v.app_id, nil, "p.id as id" ) 

      -- Se a aplicacao for uma entidade, entao já cria a respeciva entrada me itvision_app_objects
      if v.app_type_id then
         if parent_app[1] then 
            p_id = parent_app[1].id 
         else 
            p_id = App.select_root_app ()
         end

         local ao = { app_id = p_id, instance_id = config.database.instance_id, 
                      service_object_id = v.object_id, type = 'app' }
         Model.insert("itvision_app_objects", ao)
      end
   end

   if app[1] then
      App.remake_apps_config_file()
   end

end

