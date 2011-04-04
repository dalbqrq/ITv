require "Model"
require "App"
require "monitor_util"
require "util"

local entityfile = "/usr/local/itvision/scr/update_entity.queue"


function add_entity(id)
   print("add: "..id)
   --local m = Model.query("itvision_monitors", "networkports_id = "..id)
end


function delete_entity(id)
   print("delete: "..id)
   --local m = Model.query("itvision_monitors", "networkports_id = "..id)
   --os.reset_monitor()
end


function replace_entity(id, id2)
   print("replace: "..id.." to "..id2)
   --local m = Model.query("itvision_monitors", "networkports_id = "..id)
   --os.reset_monitor()
end


function update_entity(id)
   print("update: "..id)
   --local m = Model.query("itvision_monitors", "networkports_id = "..id)
   --os.reset_monitor()
end


function processe_entity_queue()

   local lines = line_reader(entityfile)
   for _,l in ipairs(lines) do
      local _, _, id, op, s, id2 = string.find(l, '(%d+) (%a+)( *)(%d*)')

      if id2 then id2 = string.gsub(id2," ","") end

      if op == "add" then
         add_entity(id)
      elseif op == "delete" then
         delete_entity(id)
      elseif op == "replace" then
         replace_entity(id, id2)
      elseif op == "update" then
         update_entity(id)
      else
         print("Unknown operation")
      end

      id, op, s, id2 = nil, nil, nil, nil
   end

   --text_file_writer(entityfile, "") 
end


processe_entity_queue()
