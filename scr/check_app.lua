--[[ 
]]
require "Model"
require "App"
require "util"
require "monitor_util"
--require "monitor_inc"
require "state"


function check_app(app_id)
   local state, logic, name
   local app = Model.query("itvision_apps", "id = "..app_id)
   local app_object_states = Model.query("itvision_apps a, itvision_app_objects ao, nagios_objects o, nagios_servicestatus ss", 
          [[a.id = ao.app_id and ao.service_object_id = ss.service_object_id and o.is_active = 1 and 
            o.object_id = ss.service_object_id 
             and o.is_active = 1 and ao.app_id = ]].. app_id, nil, 
           "a.type, ao.service_object_id, ss.current_state, a.name" )

--o.instance_id = ]]..config.database.instance_id..[[

   if app[1] then
      name = app[1].name
   end

   if app_object_states[1] then
      logic = app_object_states[1].type
   else
      return APPLIC_UNKNOWN, name
   end


   if logic == "and" then
      state = APPLIC_OK
   elseif logic == "or" then
      state = APPLIC_UNKNOWN
   else
      return APPLIC_UNKNOWN
   end
   --DEBUG: print(logic)

   for i, v in ipairs(app_object_states) do
     --DEBUG: print(i,v.current_state, v.name, v.service_object_id)
     current_state = tonumber(v.current_state)
     if logic == "and" then
        if current_state > state then
           state = current_state
        end
     elseif logic == "or" then
        if current_state < state then
           state = current_state
        end
     end
   end

   return state, name
end

local res, nom = check_app(arg[1])
local info = ""
if nom then
   --info = "The state of the application "..nom.." is "..applic_alert[res].name..". | "..res
   info = nom.." | "..res
end

print("Aplic_Status "..applic_alert[res].name..": "..info)

os.exit(res)
