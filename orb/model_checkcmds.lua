require "Model"

function select_checkcmds(cmd)
   local table_ = [[ nagios_objects o, itvision_checkcmds c ]]
   local cond_ = [[ objecttype_id = 12 and is_active = 1 and 
      o.object_id = c.cmd_object_id
   ]]

   if cmd then
      cond_ = cond_ .. [[ and o.object_id = ]]..cmd
   end

   return Model.query(table_, cond_)
end

function select_checkcmd_params(id)
   local table_ = [[ nagios_objects o, itvision_checkcmds c, itvision_checkcmd_params p ]]
   local cond_ = [[ objecttype_id = 12 and is_active = 1 and 
      o.object_id = c.cmd_object_id and
      c.id = p.checkcmds_id and
      c.id = ]].. id

   return Model.query(table_, cond_)
end


function get_checkcmd(cmd)
   local path = "/usr/lib/nagios/plugins"

   local k = select_checkcmds(cmd)
   local p = select_checkcmd_params(k[1].cmd_object_id)
   local c = path.."/"..k[1].command

   return c, p, k
end
