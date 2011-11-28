--[[ 

check_app[.sh,.lua] é o check_command utilizado pelo nagios para checar o status de uma aplicação.

]]
require "Model"
require "Monitor"
require "App"
require "util"
require "monitor_util"
require "state"


function check_app(debug, app_id)
   if debug == "-d" or debug == "--debug" then debug = true else app_id = debug; debug = false end
   local state, logic, name
   local app = Model.query("itvision_apps", "id = "..app_id)
   local app_object_states = Monitor.select_monitors_app_objs(app_id)
   local APPLIC_UNDEF = -1

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
      state = APPLIC_UNDEF
   elseif logic == "or" then
      state = APPLIC_UNKNOWN
   else
      return APPLIC_UNKNOWN
   end
   if debug then print("LOGIC: ", logic) end


   for i, v in ipairs(app_object_states) do
     obj_name = v.ax_name
     current_state = tonumber(v.ss_current_state)
     monitor_state = tonumber(v.m_state)
     is_active = tonumber(v.ax_is_active)

     -- se objeto for uma host ou service e nao uma aplicacao
     is_active = is_active or monitor_state
     if obj_name == "" then obj_name = v.m_name end
     

     if debug then  print(i,applic_alert[current_state].name, is_active, obj_name, v.ao_service_object_id) end

     -- as duas linhas abaixo colocam os estados de WARNING e CRITICAL como mais relevantes na escala de prioridades
     if current_state == APPLIC_WARNING then current_state = APPLIC_DISABLE + 1 end
     if current_state == APPLIC_CRITICAL then current_state = APPLIC_DISABLE + 2 end

     if is_active ~= 0 then
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

   -- as duas linhas abaixo recolocam os estados de WARNING e CRITICAL com valores originais
   if state == APPLIC_DISABLE + 1 then state = APPLIC_WARNING end
   if state == APPLIC_DISABLE + 2 then state = APPLIC_CRITICAL end

   if state == APPLIC_UNDEF then state = APPLIC_UNKNOWN end

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
