require "Model"
require "App"
require "util"
require "monitor_util"
require "probe"

local ipfile = "/usr/local/itvision/scr/update_ip.queue"


function ip_update(id)
   print("update: "..id)

   local n = Model.query("glpi_networkports", "id = "..id)
   local m = Model.query("itvision_monitors", "networkports_id = "..id)

   if m[1] then
      --DEBUG print ("name1 and name2: ", m[1].name1, m[1].name2, n[1].ip)
      insert_host_cfg_file (m[1].name1, m[1].name1, n[1].ip)
   end
end


function ip_delete(id)
   print("delete: "..id)
   local m = Model.query("itvision_monitors", "networkports_id = "..id)



   if m[1] then
      hst_name = m[1].name1

      local a = Model.query("itvision_app_objects ao, itvision_monitors m", 
                         "ao.service_object_id = m.service_object_id and m.name1 = '"..hst_name.."'",
                         nil, "distinct(app_id) as app_id")

      Model.delete ("itvision_monitors", "name1 = '"..hst_name.."'")
      Model.delete ("itvision_checkcmd_params", "name1 = '"..hst_name.."'")

      for _,v in ipairs(a) do
         local apps = Model.query("itvision_app_objects", "app_id = "..v.app_id, nil, "count(*) as count")
         if apps[1] and tonumber(apps[1].count) == 0 then
            App.deactivate_app (v.app_id, 0)
         end
      end

      for _,v in ipairs(m) do
         Model.delete ("itvision_app_objects", "service_object_id = "..v.service_object_id)
         Model.delete ("itvision_app_relats", "from_object_id = "..v.service_object_id)
         Model.delete ("itvision_app_relats", "to_object_id = "..v.service_object_id)
         ITvision.delete(nil, v.service_object_id)  -- chama funcao de remocao de probe.lua -  remove tudo que está relacionaod ao objeto
      end

      local hostfile = config.monitor.dir.."/hosts/"..id..".cfg"
      remove_file(hostfile)
   end
   os.reset_monitor()
end


