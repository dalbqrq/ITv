require "Model"
require "Itvision"
require "Checkcmds"
require "config"
require "util"

local cfg_dir = config.monitor.dir.."/etc/itvision/"


----------------------------- MAKE NAMES ----------------------------------

function make_obj_name(host, service)
   local name = ""

   if string.find(host,config.monitor.check_app) == nil then 
       name = host
   end
   --if service ~= config.monitor.check_host then
   if service then
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
--[[
          command_name        = PING
          command_line        = chck_ping
name1   = host_name           = Euler
name2   = service_description = My_PING
c_alias = alias               = euler
          check_command       = PING!400.0,20%!999.0,70%
p_id    = address             = 147.65.1.3


]]



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



function insert_service_cfg_file (hostname, service_desc, check_cmd, check_args)
   local content, cmd, filename

   if check_args == nil then
      check_args = ""
      local tables_ = [[nagios_objects o, itvision_checkcmds c, itvision_checkcmd_params p]]
      local cond_   = [[o.objecttype_id = 12 and o.is_active = 1 and o.object_id = c.cmd_object_id and c.id = p.checkcmds_id 
                        and p.sequence is not null and o.name2 is null and o.name1 = ']]..check_cmd..[[']]
      local extras_ = [[order by p.sequence]]
      local p = Model.query(tables_, cond_, extras_)
      
      for i,v in ipairs(p) do
         check_args = check_args.."!"..v.default_value 
      end
   end

   filename = config.monitor.dir.."/services/"..hostname.."-"..service_desc..".cfg"

   local text = [[
define service{
        use]].."\t\t\t"..[[generic-service
        host_name]].."\t\t"..hostname..[[ 
        service_description]].."\t"..service_desc..[[ 
        check_command]].."\t\t"..check_cmd..check_args..[[ 
        } 
]]

   text_file_writer (filename, text)
   cmd = os.reset_monitor()

   return cmd
end



function insert_contact_cfg_file (name, full_name, email, apps)
   --if not  ( name and full_name and email ) then return false end
   local app_list = ""
   local sep, cmd
   local filename = config.monitor.dir.."/contacts/"..name..".cfg"

   for _,v in ipairs(apps) do
      if app_list == "" then 
         sep = ""; 
      else 
         sep = ","
      end

      app_list = app_list..sep..v.app_name
   end

   local text = [[
define contact{
        use]].."\t\t"..[[generic-contact 
        contact_name]].."\t"..name..[[ 
        alias]].."\t\t"..full_name..[[ 
        email]].."\t\t"..email..[[ 
        contactgroup]].."\t"..app_list..[[

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

   s = "\n"..ref.." = "..s.."\n"
   s = s.."display "..flag..";"..ref..";"..ref.."\n\n"

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
      local objs = Itvision.select_app_app_objects(v.id)
      if objs[1] then s = s .. activate_app(v, objs, v.is_active) end
   end

   text_file_writer(file_name, s)
   insert_bp_cfg_file()

   insert_contactgroup_cfg_file(apps)

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



function insert_contactgroup_cfg_file (apps)
   if not apps then return false end
   local filename = config.monitor.dir.."/apps/contactgroups.cfg"
   local text = ""

   for _,v in ipairs(apps) do
      text = text ..[[
define contactgroup{
        contactgroup_name]].."\t"..v.name..[[ 
        alias]].."\t\t\t"..v.name..[[ 
        }


]]
   end

   text_file_writer (filename, text)
   cmd = os.reset_monitor()

   return true, cmd
end



