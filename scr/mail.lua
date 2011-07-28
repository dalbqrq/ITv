require "Model"
require "Monitor"

--[[

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
