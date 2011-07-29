require "Model"
require "Monitor"
require "monitor_inc"

--[[
 clear; echo "service_object_idcurrent_statehas_been_checkedcurrent_check_attemptmax_check_attemptscheck_typestate_typeproblem_has_been_acknowledgedacknowledgement_type"; while [ 1 ]; do echo "select service_object_id, current_state, has_been_checked, current_check_attempt, max_check_attempts, check_type, state_type, problem_has_been_acknowledged, acknowledgement_type from nagios_servicestatus where service_object_id = 370;" | mysql -u itv --password=itv itvision |grep -v service_object_id ; sleep 10; done


]]

state_name = {
        [APPLIC_OK]       = "NORMAL",
        [APPLIC_WARNING]  = "ANORMAL",
        [APPLIC_CRITICAL] = "CRÍTICO",
        [APPLIC_UNKNOWN]  = "DESCONHECIDO",
        [APPLIC_PENDING]  = "PENDENTE",
        [APPLIC_DISABLE]  = "DESABILITADO",
}




function mail_body(app_id)
   local a, q

   local tm = os.date("*t", os.time())
--[[
   for i,v in pairs(tm) do
      print( i, v)
   end
]]

   print ("ITvision - Notificação \n")

   a = App.select_app_state("a.id = "..app_id); a = a[1]
   print("Aplicação:\t".. a.name)
   print("Funcionamento:\t".. state_name[tonumber(a.current_state)])
   print("Data e hora:\t"..tm.day.."-"..tm.month.."-"..tm.year.." "..tm.hour..":"..tm.min)

   print("\nHardwares em estado CRÍTICO:")
   q = Monitor.make_query_3(nil, nil, app_id)
   for i, v in ipairs(q) do
      if tonumber(v.ss_current_state) == APPLIC_CRITICAL then
         print("\t".. v.c_name)
      end
   end

   print("\nSoftwares em estado CRÍTICO:")
   q = Monitor.make_query_4(nil, nil, app_id)
   for i, v in ipairs(q) do
      if tonumber(v.ss_current_state) == APPLIC_CRITICAL then
         print("\t".. v.c_name, v.m_name)
      end
   end

   print("\nAplicações em estado CRÍTICO:")
   q = Monitor.make_query_5(app_id)
   for i, v in ipairs(q) do
      if tonumber(v.ss_current_state) == APPLIC_CRITICAL then
         print("\t".. v.ax_name)
      end
   end

   print("\n--")
end

mail_body(arg[1])
