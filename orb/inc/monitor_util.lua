
require "config"
require "util"
require "Model"

local cfg_dir = config.monitor.dir.."/etc/itvision/"


----------------------------- MAKE NAMES ----------------------------------

function make_obj_name(host, service)
   local name = ""

   if string.find(host,config.monitor.check_app) == nil then 
       name = host
   end
   if service ~= config.monitor.check_host then
      if name ~= "" then
         name = " @ "..name
      else
         name = " (app)"..name
      end
      name = service..name
   end

   return name
end


----------------------------- CONFIG FILES ----------------------------------

function insert_host_cfg_file (hostname, alias, ip)
   if not  ( hostname and alias and ip ) then return false end
   -- hostname passa aqui a ser uma composicao do proprio hostname com o ip a ser monitorado
   local content, cmd
   local filename = config.monitor.dir.."/hosts/"..hostname..".cfg"

   local text = [[
define host{
        use]].."\t\t"..[[generic-host
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
   local content, cmd, filename
   --local c, p = get_checkcmd(check_cmd)
   --local chk = ""

   filename = config.monitor.dir.."/services/"..hostname.."-"..display_name.."-"..check_cmd..".cfg"

   local text = [[
define service{
        use]].."\t\t\t"..[[generic-service
        host_name]].."\t\t"..hostname..[[ 
        service_description]].."\t"..display_name..[[ 
        check_command]].."\t\t"..check_cmd..cmds[check_cmd].default..[[ 
        } 
]]

   text_file_writer (filename, text)
   cmd = os.reset_monitor()

   return cmd
end


function insert_contact_cfg_file (name, full_name, email)
   if not  ( name and full_name and email ) then return false end
   name = string.gsub(tostring(name)," ","_")
   local cmd, filename = config.monitor.dir.."/contacts/"..name..".cfg"

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


-- Ainda nao está funcionando
function delete_cfg_file(filename, conf_type)
   filename = string.gsub(tostring(filename)," ","_")
   local cmd
   cmd = os.capture ("rm -f "..config.monitor.dir.."/"..conf_type.."/"..filename..".cfg", 1)
   cmd = os.reset_monitor()
end



--[[
  Cria arquivo de conf do business process para uma unica aplicacao. 

  display 0 - significa usar o template de service "generic-bp-detail-service" que possiu 
              os parametros de configuracao active_checks_enabled=0 e passive_checks_enabled=0
              para desabilitar os alertas de um servico no nagios

  display 1 - sinifica usar o template de service "generic-bp-service" que corresponde a
              um servico ativo.

  PS: na definicao do business process, "display"quer dizer outra coisa (visibilidade) 
      Veja em /usr/local/monitorbp/README
]]
function activate_app(app, objs, flag)
   --app = app[1]
   local s = ""
   local file_name = string.gsub(app.name," ", "_")

   if app.type == "and" then op = " & " else op = " | " end

   for i, v  in ipairs(objs) do
      if s ~= "" then s = s..op end

      if v.obj_type == "app" then
         s = s..v.name2 
      else
         s = s..v.name1..";"..v.name2 
      end
      
   end

   ref = string.gsub(string.gsub(app.name,"(%p+)","_")," ","_")

--[[
   s = "\n"..app.name.." = "..s.."\n"
   s = s.."display "..flag..";"..ref..";"..app.name.."\n\n"
]]
   s = "\n"..ref.." = "..s.."\n"
   s = s.."display "..flag..";"..ref..";"..ref.."\n\n"

   --text_file_writer(config.monitor.bp_dir.."/etc/apps/"..file_name..".conf", s)
   --insert_bp_cfg_file(file_name)
   --os.reset_monitor()
   return s
end


--[[
  Cria aquivo de conf para todas a aplicacoes

]]
function activate_all_apps(apps)
   local s = ""
   local op
   local file_name = config.monitor.bp_dir.."/etc/nagios-bp.conf"

   for i, v  in ipairs(apps) do
      local objs = Model.select_app_app_objects(v.id)
      if objs[1] then s = s .. activate_app(v, objs, v.is_active) end
   end

   text_file_writer(file_name, s)
   insert_bp_cfg_file()
   os.reset_monitor()
end



--[[
  Cria arquivo de configuracao do nagios a partir do arquivo de configuracao do BP
  criado na funcao "activate_all_apps()" acima usando o script perl do proprio BP.
]]
function insert_bp_cfg_file()
   local cmd = config.monitor.bp_dir.."/bin/bp_cfg2service_cfg.pl"
   cmd = cmd .. " -f "..config.monitor.bp_dir.."/etc/nagios-bp.conf"
   cmd = cmd .. " -o "..config.monitor.dir.."/apps/apps.cfg"

   os.capture(cmd)
   -- DEBUG: text_file_writer("/tmp/cmd.out", cmd)
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
   DHCP      = { def="$USER1$/check_dhcp $ARG1$", default=nil },
   FTP       = { def="$USER1$/check_ftp -H $HOSTADDRESS$ $ARG1$", default=nil },
   HPJD      = { def="$USER1$/check_hpjd -H $HOSTADDRESS$ $ARG1$", default=nil },
   HTTP      = { def="$USER1$/check_http -I $HOSTADDRESS$", default="" },
   HTTPNAME  = { def="$USER1$/check_http -H $HOSTNAME$ $ARG1$", default="" },
   HTTPURL   = { def="$USER1$/check_http -I $ARG1$", default="" },
   IMAP      = { def="$USER1$/check_imap -H $HOSTADDRESS$ $ARG1$", default=nil },
   DISK      = { def="$USER1$/check_disk -w $ARG1$ -c $ARG2$ -p $ARG3$", default=nil },
   LOAD      = { def="$USER1$/check_load -w $ARG1$ -c $ARG2$", default=nil },
   MRTGTRAF  = { def="$USER1$/check_mrtgtraf -F $ARG1$ -a $ARG2$ -w $ARG3$ -c $ARG4$ -e $ARG5$", default=nil },
   PROCS     = { def="$USER1$/check_procs -w $ARG1$ -c $ARG2$ -s $ARG3$", default=nil },
   SWAP      = { def="$USER1$/check_swap -w $ARG1$ -c $ARG2$", default=nil },
   USERS     = { def="$USER1$/check_users -w $ARG1$ -c $ARG2$", default=nil },
   NT        = { def="$USER1$/check_nt -H $HOSTADDRESS$ -p 12489 -v $ARG1$ $ARG2$", default=nil },
   PING      = { def="$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5", default="!400.0,20%!999.0,70%" },
-- DEPRICATED!
   HOST_PING = { def="$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5", default="!400.0,20%!999.0,70%" },
   HOST_ALIVE = { def="$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5", default="!400.0,20%!999.0,70%" },
   POP       = { def="$USER1$/check_pop -H $HOSTADDRESS$ $ARG1$", default=nil },
   SMTP      = { def="$USER1$/check_smtp -H $HOSTADDRESS$ $ARG1$", default=nil },
   SNMP      = { def="$USER1$/check_snmp -H $HOSTADDRESS$ $ARG1$", default=nil },
   SSH       = { def="$USER1$/check_ssh $ARG1$ $HOSTADDRESS$", default="" },
   TCP       = { def="$USER1$/check_tcp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$", default=nil },
   UDP       = { def="$USER1$/check_udp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$", default=nil },
}





