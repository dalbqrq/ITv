require "Model"
require "monitor_util"
require "util"

local ipfile = "/usr/local/itvision/scr/update_ip.queue"


function update_ip_address(id)

   local n = Model.query("glpi_networkports", "id = "..id)
   local m = Model.query("itvision_monitors", "networkports_id = "..id)

   if m[1] then
      --print ("name1 and name2: ", m[1].name1, m[1].name2, n[1].ip)
      insert_host_cfg_file (m[1].name1, m[1].name1, n[1].ip)
   end
end


function delete_ip_address(id)

end


function update_ip()

   local lines = line_reader(ipfile)
   for _,l in ipairs(lines) do
      local _, _, n_id, op = string.find(l, '(%d+) (%a+)')
      print(n_id, op)
      if op == "update" then
         update_ip_address(n_id)
      elseif op == "delete" then
         delete_ip_address(n_id)
      else
         print("Unknown operation")
      end
   end

   --text_file_writer(ipfile, "") 
end


update_ip()

