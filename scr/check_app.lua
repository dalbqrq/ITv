--[[ 
]]
require "Model"
require "App"
require "util"
require "monitor_util"
require "monitor_inc"


function check_app(app_id)
   local state
   local logic
   local app_object_states = Model.query("itvision_apps a, itvision_app_objects ao, nagios_servicestatus ss", 
          "a.id = ao.app_id and ao.service_object_id = ss.service_object_id and ao.app_id = "..app_id, nil, "a.type, ss.current_state" )


   if app_object_states[1] == nil then
      return APPLIC_PENDING
   else
      logic = app_object_states[1].type
   end

   if logic == "and" then
      state = APPLIC_OK
   elseif logic == "or" then
      state = APPLIC_UNKNOWN
   else
      return APPLIC_UNKNOWN
   end
   print(logic)

   for i, v in ipairs(app_object_states) do
     print(v.current_state)
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

   return state
end

local res = check_app(arg[1])

print("ITvision App ",res)

return res
