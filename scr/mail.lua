require "Model"
require "Monitor"

--[[
 clear; echo "service_object_idcurrent_statehas_been_checkedcurrent_check_attemptmax_check_attemptscheck_typestate_typeproblem_has_been_acknowledgedacknowledgement_type"; while [ 1 ]; do echo "select service_object_id, current_state, has_been_checked, current_check_attempt, max_check_attempts, check_type, state_type, problem_has_been_acknowledged, acknowledgement_type from nagios_servicestatus where service_object_id = 370;" | mysql -u itv --password=itv itvision |grep -v service_object_id ; sleep 10; done


]]


function mail_body(app_id)
   local a, q

   print ("ITvision - ALERTA\n")

   a = App.select_app_state("a.id = "..app_id); a = a[1]
   print(a.name, a.current_state, "\n")

   q = Monitor.make_query_3(nil, nil, app_id)
   for i, v in ipairs(q) do
      print(v.c_name, "\t", v.ss_current_state, v.ss_output)
   end

   q = Monitor.make_query_4(nil, nil, app_id)
   for i, v in ipairs(q) do
      print(v.c_name, v.m_name, v.ss_current_state, v.ss_output)
   end

   q = Monitor.make_query_5(app_id)
   for i, v in ipairs(q) do
      print(v.ax_name, v.ss_current_state, v.ss_output)
   end
end

mail_body(arg[1])
