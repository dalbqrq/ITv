require "Model"
require "App"
require "monitor_util"
require "util"

local entityfile = "/usr/local/itvision/scr/update_entity.queue"


function add_entity(id)
   print("add: "..id)
   local entity = Model.query("glpi_entities e", "e.id = "..id)
   local parent_app = Model.query("itvision_apps a, glpi_entities e", 
               "e.id = "..id.." and e.entities_id = a.entities_id and is_entity_root = true", 
               nil, "a.id as app_id")
   print (parent_app[1].app_id, entity[1].name)

   new_app = {
      instance_id  = config.database.instance_id,
      entities_id  = id,
      is_entity_root = 1,
      name         = entity[1].name,
      type         = "and",
      is_active    = 0,
      visibility   = 0,
      --app_type_id  = 1,
   }
   Model.insert("itvision_apps", new_app)

   local child_app = Model.query("itvision_apps a", "entities_id = "..id.." and a.is_entity_root = true")
   local parent_node = Model.query("itvision_apps a, itvision_app_trees t", 
            "a.id = t.app_id and a.is_entity_root = true and a.id = "..parent_app[1].app_id, nil, "t.id as origin")

   App.insert_node_app_tree(child_app[1].id, id, parent_node[1].origin, 1)
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
