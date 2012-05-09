require "logger"
require "sync_apps"
require "sync_services"
require "sync_entities"
require "sync_ip"
require "sync_ic"

--[[

externals[.sh,.lua] é o wrapper para que o glpi realize chamadas no itvision.

]]


function execute_external_command(op, arg1, arg2, arg3)

   -- Operacoes com entidades chamadas por servdesk/front/dropdown.common.form.php
   if op == "ENTITY_ADD" then
      entity_add(arg1)

   elseif op == "ENTITY_DELETE" then
      entity_delete(arg1)

   elseif op == "ENTITY_REPLACE" then
      entity_replace(arg1, arg2)

   elseif op == "ENTITY_UPDATE" then
      entity_update(arg1, arg2)


   -- Operacoes com networkports chamadas por servdesk/front/networkport.form.php
   elseif op == "IP_UPDATE" then
      ip_update(arg1)

   elseif op == "IP_DELETE" then
      ip_delete(arg1)


   -- Operacoes com networkequipment chamadas por servdesk/front/networkequipment.form.php
   elseif op == "NETWORKEQUIPMENT_UPDATE" then
      ic_update(arg1, "NetworkEquipment")

   elseif op == "NETWORKEQUIPMENT_DELETE" then
      ic_delete(arg1, "NetworkEquipment")


   -- Operacoes com computer chamadas por servdesk/front/computer.form.php
   elseif op == "COMPUTER_UPDATE" then
      ic_update(arg1, "Computer")

   elseif op == "COMPUTER_DELETE" then
      ic_delete(arg1, "Computer")


   -- Operacao desconhecida
   else
      if not op then op = "NIL" end
      log_glpisync("Unknown operation: |"..op.."|\n")
      return false

   end

   arg1 = arg1 or ""
   arg2 = arg2 or ""
   arg3 = arg3 or ""
   log_glpisync(op..": "..arg1.." "..arg2.." "..arg3.."\n")
   return true

end


execute_external_command(arg[1], arg[2], arg[3], arg[4])

