
require "config"
require "util"
require "Model"

local cfg_dir = config.monitor_dir.."/etc/itvision/"


----------------------------- IO FILES ----------------------------------

function write_cfg_file (filename, text)
   local f = io.open(filename, 'w')
   f:write(text)
   f:close()
end

----------------------------- SYSTEM MANTEINANCE ----------------------------------

function restart_monitor ()
   Model.execute ( "LOCK TABLE itvision_app_tree WRITE" )
   local cmd = os.reset_monitor()
   Model.execute ( "UNLOCK TABLES" )
   return cmd
end


function restart_monitor_bp ()
   Model.execute ( "LOCK TABLE itvision_app_tree WRITE" )
   local cmd = os.reset_monitor()
   Model.execute ( "UNLOCK TABLES" )
   return cmd
end


----------------------------- CONFIG FILES ----------------------------------

function insert_host_cfg_file (hostname, alias, ip)
   if not  ( hostname and alias and ip ) then return false end
   local content = Model.query("nagios_objects",nil, nil, "max(object_id)+1 as id")
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
   local content = Model.query("nagios_objects",nil, nil, "max(object_id)+1 as id")
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



--[[
  Cria arquivo de conf do business process. 

  display 0 - significa usar o template de service "generic-bp-detail-service" que possiu 
              os parametros de configuracao active_checks_enabled=0 e passive_checks_enabled=0
              para desabilitar os alertas de um servico no nagios

  display 1 - sinifica usar o template de service "generic-bp-service" que corresponde a
              um servico ativo.

  PS: na definicao do business process, "display"quer dizer outra coisa (visibilidade) 
      Veja em /usr/local/monitorbp/README
]]
function activate_app(app, objs, flag)
   app = app[1]
   s = ""

   if app.type == "and" then op = " & " else op = " | " end

   for i, v  in ipairs(objs) do
      if s ~= "" then s = s..op end

      if v.obj_type == "app" then
         s = s..v.name2 
      elseif v.obj_type == "hst" then
         s = s..v.name1
      elseif v.obj_type == "svc" then
         s = s..v.name1..";"..v.name2 
      end
      
   end

   s = app.name.." = "..s.."\n"
   s = s.."display "..flag..";"..app.name..";"..app.name.."\n"

   text_file_writer(config.monitor_bp_dir.."/etc/apps/"..app.name..".conf", s)
   make_bp(app.name)
   os.reset_monitor()

end


--[[
  Cria arquivo de configuracao do nagios a partir do arquivo de configuracao do BP
  criado na funcao "activate_app()" acima usando o script perl do proprio BP.
]]
function insert_bp_cfg_file(app_name)

   local cmd = config.monitor_bp_dir.."/bin/bp_cfg2service_cfg.pl"
   cmd = cmd .. " -f "..config.monitor_bp_dir.."/etc/apps/"..app_name..".conf"
   cmd = cmd .. " -o "..config.monitor_dir.."/etc/apps/"..app_name..".cfg"
   os.capture(cmd)
   --text_file_writer("/tmp/cmd.out", cmd)

end


