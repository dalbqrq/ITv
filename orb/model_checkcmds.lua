require "Model"

function select_checkcmds(id)
   local table_ = [[ nagios_objects o, itvision_checkcmds c ]]
   local cond_ = [[ objecttype_id = 12 and is_active = 1 and 
      o.object_id = c.cmd_object_id and
      o.name1 <> ']]..config.monitor.check_host..[[']]

   if id then
      cond_ = cond_ .. [[ and o.object_id = ]]..id
   end

   local extra_ = [[ order by name1 ]]

   return Model.query(table_, cond_, extra_)
end

function select_checkcmd_params(id)
   local table_ = [[ nagios_objects o, itvision_checkcmds c, itvision_checkcmd_params p ]]
   local cond_ = [[ objecttype_id = 12 and is_active = 1 and 
      o.object_id = c.cmd_object_id and
      c.id = p.checkcmds_id and
      c.id = ]].. id

   local extra_ = [[ order by p.id ]]

   return Model.query(table_, cond_)
end


function get_checkcmd(id)
   local c = select_checkcmds(id)
   local p = select_checkcmd_params(c[1].id)
   return c, p
end

--local c, p = get_checkcmd(121)


