
require "config"
require "util"


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
function make_bp(app_name)

   local cmd = config.monitor_bp_dir.."/bin/bp_cfg2service_cfg.pl"
   cmd = cmd .. " -f "..config.monitor_bp_dir.."/etc/apps/"..app_name..".conf"
   cmd = cmd .. " -o "..config.monitor_dir.."/etc/apps/"..app_name..".cfg"
   os.capture(cmd)
   --text_file_writer("/tmp/cmd.out", cmd)

end


