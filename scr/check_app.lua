--[[ 
]]
require "Model"
require "Monitor"
require "App"
require "util"
require "monitor_util"
--require "monitor_inc"
require "state"


function check_app(debug, app_id)
   if debug == "-d" or debug == "--debug" then debug = true else app_id = debug; debug = false end
   local state, logic, name
   local app = Model.query("itvision_apps", "id = "..app_id)
   local app_object_states = Monitor.select_monitors_app_objs(app_id)


   if app[1] then
      name = app[1].name
      if debug then print("APP_NAME: ", name) end
   end

   if app_object_states[1] then
      logic = app_object_states[1].a_type
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
   if debug then print("LOGIC: ", logic) end

   for i, v in ipairs(app_object_states) do
     if debug then  print(i,v.ss_current_state, v.a_name, v.ao_service_object_id) end
     current_state = tonumber(v.ss_current_state)
     monitor_state = tonumber(v.m_state)
     if monitor_state ~= 0 then
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
   end

   return state, name
end

local res, nom = check_app(arg[1], arg[2])
local info = ""
if nom then
   --info = "The state of the application "..nom.." is "..applic_alert[res].name..". | "..res
   info = nom.." | "..res
end

print("Aplic_Status "..applic_alert[res].name..": "..info)

os.exit(res)
