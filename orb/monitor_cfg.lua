
local m = require "model_access"
local r = require "model_rules"

require "config"
require "util"

local cfg_dir = config.monitor_dir.."/etc/itvision/"

function insert_host_cfg_file (alias, ip)
   local content = m.select("nagios_objects",nil, nil, "max(object_id)+1 as id")
   local text = [[
define host{
        use]].."\t\t"..[[linux-server
        host_name]].."\t"..alias..[[ 
        alias]].."\t\t"..alias..[[ 
        address]].."\t\t"..ip..[[ 
        } 
]]

   local filename  = cfg_dir..tostring(content[1].id)..".cfg"
   local f = io.open(filename, 'w')
   f:write(text)
   f:close()

   m.execute ( "LOCK TABLE itvision_app_tree WRITE" )
   local cmd = os.capture (config.monitor_script.." restart", 1)
   m.execute ( "UNLOCK TABLES" )

   --print(filename)
   --print(text)
   --print(cmd)

end


function delete_cfg_file(id)
   local cmd
   cmd = os.capture ("rm -f "..cfg_dir..tostring(id)..".cfg", 1)
   cmd = os.capture (config.monitor_script.." restart", 1)
end


insert_host_cfg_file ("DNS 2", "147.65.1.2")

