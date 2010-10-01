
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
   filename  = "/tmp/"..tostring(content[1].id)..".cfg"
   filename  = "/tmp/cfg"
   write_cfg_file (filename, text)
   --local cmd = restart_monitor ()

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



--[[
check_ping!100.0,20%!500.0,60%
check_local_disk!20%!10%!/
check_local_users!20!50
check_local_procs!250!400!RSZDT
check_local_load!5.0,4.0,3.0!10.0,6.0,4.0
check_local_swap!20!10
check_ssh
check_http
]]

cmds = {
   check_dhcp      = { def="$USER1$/check_dhcp $ARG1$", default=nil },
   check_ftp       = { def="$USER1$/check_ftp -H $HOSTADDRESS$ $ARG1$", default=nil },
   check_hpjd      = { def="$USER1$/check_hpjd -H $HOSTADDRESS$ $ARG1$", default=nil },
   check_http      = { def="$USER1$/check_http -I $HOSTADDRESS$ $ARG1$", default="" },
   check_imap      = { def="$USER1$/check_imap -H $HOSTADDRESS$ $ARG1$", default=nil },
   check_disk      = { def="$USER1$/check_disk -w $ARG1$ -c $ARG2$ -p $ARG3$", default=nil },
   check_load      = { def="$USER1$/check_load -w $ARG1$ -c $ARG2$", default=nil },
   check_mrtgtraf  = { def="$USER1$/check_mrtgtraf -F $ARG1$ -a $ARG2$ -w $ARG3$ -c $ARG4$ -e $ARG5$", default=nil },
   check_procs     = { def="$USER1$/check_procs -w $ARG1$ -c $ARG2$ -s $ARG3$", default=nil },
   check_swap      = { def="$USER1$/check_swap -w $ARG1$ -c $ARG2$", default=nil },
   check_users     = { def="$USER1$/check_users -w $ARG1$ -c $ARG2$", default=nil },
   check_nt        = { def="$USER1$/check_nt -H $HOSTADDRESS$ -p 12489 -v $ARG1$ $ARG2$", default=nil },
   check_ping      = { def="$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5", default="!100.0,20%!500.0,60%" },
   check_pop       = { def="$USER1$/check_pop -H $HOSTADDRESS$ $ARG1$", default=nil },
   check_smtp      = { def="$USER1$/check_smtp -H $HOSTADDRESS$ $ARG1$", default=nil },
   check_snmp      = { def="$USER1$/check_snmp -H $HOSTADDRESS$ $ARG1$", default=nil },
   check_ssh       = { def="$USER1$/check_ssh $ARG1$ $HOSTADDRESS$", default="" },
   check_tcp       = { def="$USER1$/check_tcp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$", default=nil },
   check_udp       = { def="$USER1$/check_udp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$", default=nil },
}





