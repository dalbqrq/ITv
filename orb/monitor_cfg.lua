
local m = require "model_access"
local r = require "model_rules"

require "config"
require "util"

local cfg_dir = config.monitor_dir.."/etc/itvision/"


----------------------------- IO FILES ----------------------------------

function write_cfg_file (filename, text)
   local f = io.open(filename, 'w')
   f:write(text)
   f:close()
end

----------------------------- SYSTEM MANTEINANCE ----------------------------------

function restart_monitor ()
   m.execute ( "LOCK TABLE itvision_app_tree WRITE" )
   --local cmd = os.capture (config.monitor_script.." restart", 1)
   m.execute ( "UNLOCK TABLES" )
   return cmd
end


function restart_monitor_bp ()
   m.execute ( "LOCK TABLE itvision_app_tree WRITE" )
   local cmd = os.capture (config.monitor_bp_script.." restart", 1)
   m.execute ( "UNLOCK TABLES" )
   return cmd
end


----------------------------- CONFIG FILES ----------------------------------

function insert_host_cfg_file (hostname, alias, ip)
   if not  ( hostname and alias and ip ) then return false end
   local content = m.select("nagios_objects",nil, nil, "max(object_id)+1 as id")
   local text = [[
define host{
        use]].."\t\t"..[[linux-server
        host_name]].."\t"..hostname..[[ 
        alias]].."\t\t"..alias..[[ 
        address]].."\t\t"..ip..[[ 
        } 
]]

   local filename  = cfg_dir..tostring(content[1].id)..".cfg"
   write_cfg_file (filename, text)
   local cmd = restart_monitor ()

   return true, cmd
end


function insert_service_cfg_file (display_name, hostname, check_cmd)
   if not  ( display_name and hostname and check_cmd ) then return false end
   local content = m.select("nagios_objects",nil, nil, "max(object_id)+1 as id")
   local text = [[
define service{
        use]].."\t\t\t"..[[linux-server 
        host_name]].."\t\t"..hostname..[[ 
        service_description]].."\t"..display_name..[[ 
        check_command]].."\t\t"..check_cmd..[[ 
        } 
]]

   local filename  = cfg_dir..tostring(content[1].id)..".cfg"
   write_cfg_file (filename, text)
   local cmd = restart_monitor ()

   return true, cmd
end


function insert_contact_cfg_file (name, full_name, email)
   if not  ( name and full_name and email ) then return false end
   name = string.gsub(tostring(name)," ","_")
   local text = [[
define contact{
        use]].."\t\t"..[[generic-contact 
        contact_name]].."\t"..name..[[ 
        alias]].."\t\t"..full_name..[[ 
        email]].."\t\t"..email..[[ 
        }
]]

   local filename  = cfg_dir..name..".cfg"
   write_cfg_file (filename, text)
   local cmd = restart_monitor ()

   return true, cmd
end

--[[

TODO: 

Falta criar grupos de contatos e poder remover contados dos grupos
Falta ainda associar service tipo BP aos contatos ou aos grupos de contatos

]]



function delete_cfg_file(filename) -- no caso de hosts e services, filename eh o object_id
				   -- no caso de contacts, filename eh o contact_name
   filename = string.gsub(tostring(filename)," ","_")
   local cmd
   cmd = os.capture ("rm -f "..cfg_dir..filename..".cfg", 1)
   cmd = os.capture (config.monitor_script.." restart", 1)
end


