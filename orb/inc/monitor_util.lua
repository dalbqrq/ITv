
require "config"
require "util"
require "Model"

local cfg_dir = config.monitor.dir.."/etc/itvision/"


----------------------------- CONFIG FILES ----------------------------------

function insert_host_cfg_file (hostname, alias, ip)
   if not  ( hostname and alias and ip ) then return false end
   -- hostname passa aqui a ser uma composicao do proprio hostname com o ip a ser monitorado
   local content, cmd
   local filename = cfg_dir..hostname..".cfg"

   local text = [[
define host{
        use]].."\t\t"..[[linux-server
        host_name]].."\t"..hostname..[[ 
        alias]].."\t\t"..alias..[[ 
        address]].."\t\t"..ip..[[ 
        } 
]]

   text_file_writer (filename, text)
   cmd = os.reset_monitor()

   return cmd
end


function insert_service_cfg_file (hostname, display_name, check_cmd)
   if not  ( display_name and hostname and check_cmd ) then return false end
   local check, content, cmd, filename

   if check_cmd == 0 then
      clause = "name1 = '"..config.monitor.check_ping.."'"
   else
      clause = "object_id = "..check_cmd
   end

   chk = Model.query("nagios_objects", clause)
   if chk[1] then check = chk[1].name1 else return false, 0, "ERROR" end
   filename = cfg_dir..hostname.."-"..display_name.."-"..check..".cfg"

   local text = [[
define service{
        use]].."\t\t\t"..[[generic-service
        host_name]].."\t\t"..hostname..[[ 
        service_description]].."\t"..display_name..[[ 
        check_command]].."\t\t"..check..[[ 
        } 
]]

   text_file_writer (filename, text)
   cmd = os.reset_monitor()

   return cmd
end


function insert_contact_cfg_file (name, full_name, email)
   if not  ( name and full_name and email ) then return false end
   name = string.gsub(tostring(name)," ","_")
   local cmd, filename = cfg_dir..name..".cfg"

   local text = [[
define contact{
        use]].."\t\t"..[[generic-contact 
        contact_name]].."\t"..name..[[ 
        alias]].."\t\t"..full_name..[[ 
        email]].."\t\t"..email..[[ 
        }
]]

   text_file_writer (filename, text)
   cmd = os.reset_monitor()

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
   cmd = os.reset_monitor()
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
   local s = ""
   local file_name = string.gsub(app.name," ", "_")

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

   text_file_writer(config.monitor.bp_dir.."/etc/apps/"..file_name..".conf", s)
   insert_bp_cfg_file(file_name)
   os.reset_monitor()
end


--[[
  Cria arquivo de configuracao do nagios a partir do arquivo de configuracao do BP
  criado na funcao "activate_app()" acima usando o script perl do proprio BP.
]]
function insert_bp_cfg_file(file_name)
   local cmd = config.monitor.bp_dir.."/bin/bp_cfg2service_cfg.pl"
   cmd = cmd .. " -f "..config.monitor.bp_dir.."/etc/apps/"..file_name..".conf"
   cmd = cmd .. " -o "..config.monitor.dir.."/etc/apps/"..file_name..".cfg"

   os.capture(cmd)
   os.reset_monitor()
   text_file_writer("/tmp/cmd.out", cmd)
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





