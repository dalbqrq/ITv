require "Model"
require "util"


function get_checkcmd_params()
   local s = ""
   
   local cmds = Model.query("nagios_objects o, itvision_checkcmds c", "o.object_id = c.cmd_object_id", "order by name1", "name1, c.id as id, command")
   s = s.."cmds = {\n\n"
   for i, v in pairs(cmds) do
      local params = Model.query("itvision_checkcmd_default_params", "checkcmds_id = "..v.id)


      s = s.."   "..v.name1.." = {\n"
      s = s.."      command = \""..v.command.."\",\n"
      s = s.."      args = {\n"

      for j, w in pairs(params) do
         local sequence;  if w.sequence then sequence = w.sequence else sequence = "nil" end
         local flag;  if w.flag then flag = "\""..w.flag.."\"" else flag = "nil" end
         local variable;  if w.variable then variable = "\""..w.variable.."\"" else variable = "" end
         local default_value;  if w.default_value then default_value = "\""..w.default_value.."\"" else default_value = "nil" end
         local description;  if w.description then description = "\""..w.description.."\"" else description = "" end
         if default_value == "\"nil\"" then default_value = "nil" end
         s = s.."         { sequence="..sequence..", flag="..flag..",  variable="..variable.. 
               ", default_value="..default_value..", description="..description.." },\n"
      end

      s = s.."      },\n"
      s = s.."   },\n\n"
   end
   s = s.."\n}\n"

   text_file_writer("./Checkcmd_params.lua", s)
end


get_checkcmd_params()

