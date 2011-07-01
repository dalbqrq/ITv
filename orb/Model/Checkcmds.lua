module("Checkcmds", package.seeall)

require "Model"
require "util"

function select_checkcmds(id, object_id, hide_check_host)
   local table_ = [[ nagios_objects o, itvision_checkcmds c ]]
   local cond_ = [[ objecttype_id = 12 and is_active = 1 and 
      o.object_id = c.cmd_object_id ]]

   if id ~= nil then
      cond_ = cond_ .. [[ and c.id = ]]..id
   end

   if object_id ~= nil then
      cond_ = cond_ .. [[ and o.object_id = ]]..object_id
   end

   if hide_check_host then
      cond_ = cond_ ..[[ and o.name1 <> ']]..config.monitor.check_host..[[']]
   end

   local extra_ = [[ order by label ]]

   return Model.query(table_, cond_, extra_)
end


function select_checkcmd_params(service_object_id)
   -- parametros variaveis (possuem sequencia e sao armazenados em itvision_checkcmd_params)
   local table_ = [[ nagios_objects o, itvision_checkcmds c, itvision_checkcmd_default_params p, itvision_checkcmd_params pp ]]
   local cond_ = [[ objecttype_id = 12 and is_active = 1 and 
      o.object_id = c.cmd_object_id and
      c.id = p.checkcmds_id and
      c.cmd_object_id = pp.cmd_object_id and
      pp.sequence = p.sequence and
      pp.service_object_id = ]].. service_object_id
   local extra_ = [[ order by pp.sequence ]]
   local q1 = Model.query(table_, cond_, extra_)

   -- parametros fixos (NÃO possuem sequencia e NÃO sao armazenados em itvision_checkcmd_params)
   local table_ = [[ itvision_monitors m, itvision_checkcmds cmd, itvision_checkcmd_default_params dp ]]
   local cond_ = [[ m.cmd_object_id = cmd.cmd_object_id and
      cmd.id = dp.checkcmds_id and
      dp.sequence is null and
      m.service_object_id = ]]..service_object_id
   local extra_ = [[]]
   local q2 = Model.query(table_, cond_, extra_)

   for _,v in ipairs(q1) do table.insert(q2, v) end
   return q2
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

   return Model.query(table_, cond_, extra_ )
end


function get_checkcmd_params(id)
   return select_checkcmd_params(id)
end


function get_checkcmd_default_params(id, exclude_fixed_params, hide_check_host)
   local c = select_checkcmds(nil, id, hide_check_host)
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

