module("Checkcmds", package.seeall)

require "Model"
require "util"

function select_checkcmds(id, hide_check_host)
   local table_ = [[ nagios_objects o, itvision_checkcmds c ]]
   local cond_ = [[ objecttype_id = 12 and is_active = 1 and 
      o.object_id = c.cmd_object_id ]]

   if id ~= nil then
      cond_ = cond_ .. [[ and o.object_id = ]]..id
   end

   if hide_check_host then
      cond_ = cond_ ..[[ and o.name1 <> ']]..config.monitor.check_host..[[']]
   end

   local extra_ = [[ order by label ]]

   return Model.query(table_, cond_, extra_)
end


function select_checkcmd_params(object_id)
   local table_ = [[ itvision_checkcmd_params  ]]
   local cond_ =  [[ cmd_object_id = ]].. object_id
   local extra_ = [[ order by sequence ]]

   return Model.query(table_, cond_, extra_)
end


function select_checkcmd_default_params(id, exclude_fixed_params)
   local table_ = [[ nagios_objects o, itvision_checkcmds c, itvision_checkcmd_default_params p ]]
   local cond_ = [[ objecttype_id = 12 and is_active = 1 and 
      o.object_id = c.cmd_object_id and
      c.id = p.checkcmds_id and
      c.id = ]].. id

   if exclude_fixed_params then
      cond_ = cond_ .. [[ and p.sequence is not null ]]
   end

   local extra_ = [[ order by p.sequence ]]

   return Model.query(table_, cond_, extra_)
end


function get_checkcmd_params(id)
   return select_checkcmd_params(id)
end


function get_checkcmd_default_params(id, exclude_fixed_params, hide_check_host)
   local c = select_checkcmds(id, hide_check_host)
   local counter = 0

   local p = select_checkcmd_default_params(c[1].id, exclude_fixed_params)
   return c, p
end


function how_to_use(object_id)
   local c, p = get_checkcmd_default_params(object_id)

   chk = c[1].name1

   for j,w in ipairs(p) do
       print(chk, c[1].command, w.default_value)
   end

end

--how_to_use(87)

