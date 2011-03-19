require "Model"
require "App"
require "monitor_util"
require "util"

local ipfile = "/usr/local/itvision/scr/update_ip.queue"


function update_ip_address(id)
   print("update: "..id)

   local n = Model.query("glpi_networkports", "id = "..id)
   local m = Model.query("itvision_monitors", "networkports_id = "..id)

   if m[1] then
      --print ("name1 and name2: ", m[1].name1, m[1].name2, n[1].ip)
      insert_host_cfg_file (m[1].name1, m[1].name1, n[1].ip)
   end
end


function delete_ip_address(id)
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
         local servicefile = config.monitor.dir.."/services/"..v.name1.."-"..v.name2..".cfg"
         Model.delete ("itvision_app_objects", "service_object_id = "..v.service_object_id)
         Model.delete ("itvision_app_relats", "from_object_id = "..v.service_object_id)
         Model.delete ("itvision_app_relats", "to_object_id = "..v.service_object_id)
         remove_file(servicefile)
      end

      local hostfile = config.monitor.dir.."/hosts/"..id..".cfg"
      remove_file(hostfile)
   end
   os.reset_monitor()
end


function update_ip()

   local lines = line_reader(ipfile)
   for _,l in ipairs(lines) do
      local _, _, n_id, op = string.find(l, '(%d+) (%a+)')

      if op == "update" then
         update_ip_address(n_id)
      elseif op == "delete" then
         delete_ip_address(n_id)
      else
         print("Unknown operation")
      end
   end

   text_file_writer(ipfile, "") 
end


--update_ip()

