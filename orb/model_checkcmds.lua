require "Model"

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

   return Model.query(table_, cond_, extra_)
end


function select_checkcmd_params(id, exclude_fixed_params)
   local table_ = [[ nagios_objects o, itvision_checkcmds c, itvision_checkcmd_params p ]]
   local cond_ = [[ objecttype_id = 12 and is_active = 1 and 
      o.object_id = c.cmd_object_id and
      c.id = p.checkcmds_id and
      c.id = ]].. id

   if exclude_fixed_params then
      cond_ = cond_ .. [[ and .sequence is not null ]]
   end

   local extra_ = [[ order by p.sequence ]]

   return Model.query(table_, cond_, extra_)
end


-- Retorna comandos e parametros 
function get_checkhost_params(id)
   local c = select_checkcmds(id, false)
   local p = select_checkcmd_params(c[1].id, true)
   return c, p
end


function get_check_params(id)
   local c = select_checkcmds(id, true)
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


