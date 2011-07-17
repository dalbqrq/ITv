require "Model"
require "App"
require "util"
require "monitor_util"
require "probe"

local icfile = "/usr/local/itvision/scr/ic.queue"


-- Esta funcao nao está funcionando pois a funcao desable_service recebe dados de web.input!
-- O que está sendo feito é que qualquer alteracao em status remove todas as probes
function ic_update(id, itemtype)
   print("update: "..id)
   local e
   local m = Model.query("itvision_monitors", "name1 like '"..id.."_%'")
   if itemtype == "Computer" then
      e = Model.query("glpi_computers", "id = "..id)
   else
      e = Model.query("glpi_networkequipments", "id = "..id)
   end

   --[[ ITvision.desable_service NAO FUNCIONA 
   if e[1].states_id == "1" then flag = 1 else flag = 0 end

   --DEBUG: text_file_writer("/tmp/cu", id)
   if m[1] then
      for i,v in ipairs(m) do
         service_object_id = v.service_object_id
         ITvision.desable_service(nil, service_object_id, nil, nil, nil, nil, flag) -- chama funcao de desabilitacao de probe.lua
         --DEBUG: text_file_writer("/tmp/cu"..i, service_object_id)
      end
   end
   ]]

   if e[1].states_id ~= "1" then
      ic_delete(id, itemtype) -- chama remocao de probes através da remocao do ic
   end

   os.reset_monitor()
end


function ic_delete(id, itemtype)
   print("delete: "..id)
   local m = Model.query("itvision_monitors", "name1 like '"..id.."_%'")

   if m[1] then
      for i,v in ipairs(m) do
         ITvision.delete(nil, v.service_object_id)  -- chama funcao de remocao de probe.lua -  remove tudo que está relacionaod ao objeto
      end
   end
   os.reset_monitor()
end


