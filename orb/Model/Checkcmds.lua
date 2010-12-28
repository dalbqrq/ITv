module("Checkcmds", package.seeall)

require "util"

function select_checkcmds(id, hide_check_host)
   local table_ = [[ nagios_objects o, itvision_checkcmds c ]]
   local cond_ = [[ objecttype_id = 12 and is_active = 1 and 
      o.object_id = c.cmd_object_id ]]

   if id then
      cond_ = cond_ .. [[ and o.object_id = ]]..id
   end

   if hide_check_host then
      cond_ = cond_ ..[[ and o.name1 <> ']]..config.monitor.check_host..[[']]
   end

   local extra_ = [[ order by name1 ]]

   --DEBUG: id = id or ""; text_file_writer ("/tmp/7"..id, "select * from ".. table_ .." where ".. cond_ .. " ".. extra_..";\n\n" )
   return Model.query(table_, cond_, extra_)
end


function select_checkcmd_params(id, exclude_fixed_params)
   local table_ = [[ nagios_objects o, itvision_checkcmds c, itvision_checkcmd_params p ]]
   local cond_ = [[ objecttype_id = 12 and is_active = 1 and 
      o.object_id = c.cmd_object_id and
      c.id = p.checkcmds_id and
      c.id = ]].. id

   if exclude_fixed_params then
      cond_ = cond_ .. [[ and p.sequence is not null ]]
   end

   local extra_ = [[ order by p.sequence ]]

   --DEBUG: id = id or ""; text_file_writer ("/tmp/8"..id, "select * from ".. table_ .." where ".. cond_ .. " ".. extra_..";\n\n" )
   return Model.query(table_, cond_, extra_)
end


-- Retorna comandos e parametros 
function get_checkhost_params(id)
   --print ("---> ", id)
   local c = select_checkcmds(id, false)
   local count = 0
   while c[1] == nil do
      count = count +1
      os.sleep(1)
      c = select_checkcmds(id, false)
      --print(".")
   end

   local p = select_checkcmd_params(c[1].id, true)
   return c, p
end


function get_check_params(id)
   local c = select_checkcmds(id, true)

   --[[ DEBUG
   if c[1] == nil then
      text_file_writer ("/tmp/9",id )
   end
   ]]

   -- Este temporizador foi colocado aqui em funcao de comportamenteo estranho
   -- identificado com o DEBUG acima. Curiosamente a query nao retornava o 
   -- valor apesar de existir a entrada. O loop abaixo insite na tentativa e
   -- acaba conseguindo.
   local counter, ui, x = 0, 0, 0
   while c[1] == nil do
      counter = counter + 1
      os.sleep(1)
      c = select_checkcmds(id, true)
   end
   text_file_writer("/tmp/contour_chkcmd", tostring(counter))

   local p = select_checkcmd_params(c[1].id, true)
   return c, p
end


function get_allcheck_params(id)
   local c = select_checkcmds(id, true)
   local p = select_checkcmd_params(c[1].id, false)
   return c, p
end


function how_to_use(object_id)
   local c, p = get_allcheck_params(object_id)

   chk = c[1].name1

   for i,v in ipairs(p) do
      chk = chk.."!"..v.default_value
   end

   print(chk) 
end

--how_to_use(30)


