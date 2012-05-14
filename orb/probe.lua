#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "Monitor"
require "Auth"
require "Checkcmds"
require "View"
require "Resume"
require "util"
require "monitor_util"
require "sync_services"

module(Model.name, package.seeall,orbit.new)

local objects  = Model.nagios:model "objects"
local monitors = Model.itvision:model "monitors"
local checkcmds = Model.itvision:model "checkcmds"
local app_objects = Model.itvision:model "app_objects"
local app_relats = Model.itvision:model "app_relats"

local no_software_code = "_no_software_code_"

-- models ------------------------------------------------------------


function objects:select(name1, name2)
   local clause = ""
   if name1 ~= nil then
      clause = " name1 = '"..name1.."'"
   else
      clause = " name1 like '"..config.monitor.check_app.."%'"
   end

   if name2 ~= nil then
      clause = clause.." and name2 = '"..name2.."'"
   else
      clause = clause.." and name2 is NULL"
   end
   clause = clause .. " and is_active = 1"

   return Model.query("nagios_objects", clause)
end


-- conta quantas entradas existe parecidas com a que possui os parametros name1 e name2.
-- serve para numerar sequencialmente as entradas incluidas para servicos no nagios_objects
-- caso mais de um servico com o mesmo check_command seja criado.
function objects:count_alike(name1, name2)
   local res, q = 1, {}
   local clause = ""
   if name1 ~= nil then
      clause = " name1 = '"..name1.."'"
   end

   if name2 ~= nil then
      clause = clause.." and name2 like '"..name2.."%'"
   end

   if clause ~= "" then clause = clause.." and " end
   clause = clause .. " objecttype_id = 2"

   q = Model.query("nagios_objects", clause)
   if q then res = #q + 1 end
   
   return res
end



function objects:select_host(name1)
   local clause = ""
   if name1 ~= nil then
      clause = " o.name1 = '"..name1.."'"
   else
      clause = " o.name1 like '"..config.monitor.check_app.."%' "
   end

   clause = clause .. " and objecttype_id = 1 and o.name2 is null and o.is_active = 1"

   return Model.query("nagios_objects o", clause)
end


function objects:select_check_host()
   local clause = "name1 = '"..config.monitor.check_host.."' and name2 is NULL"
   local chk =  Model.query("nagios_objects", clause)

   return chk[1].object_id
end


function objects:select_checks(cmd)
   local clause = ""
   if cmd then
      clause = " object_id = '"..cmd.."'  and objecttype_id = 12 and is_active = 1"
   end

   return Model.query("nagios_objects", clause)
end


function monitors:select_monitors(name1, name2)
   local clause = "name1 = '"..name1.."'"
   if name2 then
      clause = clause.." and name2 = '"..name2.."'"
   else
      clause = clause.." and name2 = '"..config.monitor.check_host.."' "
   end

   return Model.query("itvision_monitors", clause)
end


function monitors:select_monitor_from_service(service_object_id)
   clause = " service_object_id = "..service_object_id

   return Model.query("itvision_monitors", clause)
end


function monitors:insert_monitor(entity, networkport, softwareversion, service_object, cmd_object, name, name1, name2, monitor_state, type_)
   if tonumber(networkport)      == 0 then networkport      = nil end         
   if tonumber(softwareversion)  == 0 then softwareversion  = nil end         

   local mon = { 
      instance_id = Model.db.instance_id,
      entities_id = entity,
      service_object_id    = service_object,
      cmd_object_id        = cmd_object,
      networkports_id      = networkport,
      softwareversions_id  = softwareversion,
      name  = name,
      name1 = name1,
      name2 = name2,
      state = monitor_state,
      type  = type_,
   }
   return Model.insert("itvision_monitors", mon)
end


function monitors:update_monitor(service_object_id, monitor_name)

   local mon = { 
      name  = monitor_name,
   }
   return Model.update("itvision_monitors", mon, "service_object_id = "..service_object_id)
end


function monitors:enable_monitor(service_object_id, monitor_state)

   local mon = { 
      state  = monitor_state,
   }
   return Model.update("itvision_monitors", mon, "service_object_id = "..service_object_id)
end


function monitors:delete(service_object_id)
   return Model.delete("itvision_monitors", "service_object_id = "..service_object_id)
end


function monitors:delete_cond(cond)
   return Model.delete("itvision_monitors", cond)
end


function app_objects:delete(service_object_id)
   return Model.delete("itvision_app_objects", "service_object_id = "..service_object_id)
end


function app_objects:delete_cond(cond)
   return Model.delete("itvision_app_objects", cond)
end


function app_relats:delete_cond(cond)
   return Model.delete("itvision_app_relats", cond)
end


function insert_params( hst_name, service_desc, chk_id, seq, value )

   local param = { 
      name1 = hst_name,
      name2 = service_desc,
      cmd_object_id = chk_id,
      sequence = seq,
      value = value,
   }

   return Model.insert("itvision_checkcmd_params", param)

end


function update_params( service_object_id, seq, value )

   local param = { 
      value = value,
   }

   return Model.update("itvision_checkcmd_params", param, "sequence = "..seq.." and service_object_id = "..service_object_id)

end




------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------


-- controllers ------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function list(web, msg)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local clause = nil

   if web.input.hostname ~= "" and web.input.hostname ~= nil then 
      clause = "(c.name like '%"..web.input.hostname.."%' or c.alias like '%"..web.input.hostname.."%' or c.itv_key like '%"..web.input.hostname.."%')"
   end
   if web.input.inventory ~= "" and web.input.inventory ~= nil then 
      local a = ""
      if clause then a = " and " else clause = "" end
      clause = clause..a.."c.otherserial like '%"..web.input.inventory.."%' "
   end
   if web.input.sn ~= "" and web.input.sn ~= nil then 
      local a = ""
      if clause then a = " and " else clause = ""  end
      clause = clause..a.."c.serial like '%"..web.input.sn.."%' "
   end
   local a = ""
   if clause then a = " and " else clause = "" end
   clause = clause..a.." p.entities_id in "..Auth.make_entity_clause(auth)

   local ics = Monitor.select_monitors(clause)
   local chk = Checkcmds.select_checkcmds()

   return render_list(web, ics, chk, msg)
end
ITvision:dispatch_get(list, "/", "/list", "/list/(.+)")
ITvision:dispatch_post(list, "/list", "/list/(.+)")



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function add(web, query, c_id, p_id, sv_id, do_test, new_cmd)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end
   if do_test ~= nil then do_test = true else do_test = false end

   local count = web.input.count
   local chk_id = web.input.chk_id
   local chk_name = web.input.chk_name
   local monitor_name = web.input.monitor_name
   local chk_params = nil
   local chk = Checkcmds.select_checkcmds(nil, nil, true)
   local ics = {}

   query = tonumber(query)

   if query == 1 then
      ics = Monitor.make_query_1(c_id, p_id)
   elseif query == 3 then
      ics = Monitor.make_query_3(c_id, p_id)
   elseif query == 4 then
      ics = Monitor.make_query_4(c_id, p_id)
   end

   local params = { query=query, c_id=c_id, p_id=p_id, sv_id=sv_id, origin="add", cmd=new_cmd, 
                    monitor_state=1, do_test=do_test, no_header="0", service_object_id=0,
                    msg=msg }

   if chk_id then
      _, chk_params = Checkcmds.get_checkcmd_default_params(chk_id, false, false)
      for i,v in ipairs(chk_params) do
         chk_params[i].flag = web.input["flag"..i]
         chk_params[i].default_value = web.input["opt"..i]
      end
      --DEBUG: text_file_writer("/tmp/ss", #chk_params.." "..chk_id.."\n")
   end

   return render_add(web, ics, chk, params, chk_params, monitor_name)
end
ITvision:dispatch_get(add, "/add/(%d+):(%d+):(%d+):(%d+)","/add/(%d+):(%d+):(%d+):(%d+):(%d+)","/add/(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")
ITvision:dispatch_post(add, "/add/(%d+):(%d+):(%d+):(%d+)","/add/(%d+):(%d+):(%d+):(%d+):(%d+)","/add/(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")


-- do_test e no_header devem receber 0 ou 1 para false ou true
function update(web, query, c_id, p_id, sv_id, do_test, service_object_id, no_header, msg)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end
   local ics = {}
   do_test = tonumber(do_test)
   --if no_header == nil then no_header = 1 else no_header = 0 end
   if no_header == nil then no_header = 0 end
   no_header = tonumber(no_header)
   query = tonumber(query)

   local count = web.input.count
   local chk_id = web.input.chk_id
   local chk_name = web.input.chk_name
   --local monitor_name = web.input.monitor_name
   local chk_params = nil

   if query == 3 then
      ics = Monitor.make_query_3(c_id, p_id)
   elseif query == 4 then
      ics = Monitor.make_query_4(c_id, p_id)
   end

   local monitor = monitors:select_monitor_from_service(service_object_id) 
   local chk = Checkcmds.select_checkcmds(nil, monitor[1].cmd_object_id)

   if do_test == 1 then
      do_test = true
      _, chk_params = Checkcmds.get_checkcmd_default_params(monitor[1].cmd_object_id, false, false)
      for i,v in ipairs(chk_params) do
         chk_params[i].flag = web.input["flag"..i]
         chk_params[i].default_value = web.input["opt"..i]
      end
   else
      do_test = false
      chk_params = Checkcmds.get_checkcmd_params(service_object_id)
      for i,v in ipairs(chk_params) do
         chk_params[i].flag = v.flag
         chk_params[i].default_value = v.value
      end
   end


   local params = { query=query, c_id=c_id, p_id=p_id, sv_id==nil, origin="update", cmd=monitor[1].cmd_object_id, 
                    monitor_state=monitor[1].state, do_test=do_test, no_header=no_header, service_object_id=service_object_id,
                    msg=msg }

   return render_add(web, ics, chk, params, chk_params, monitor[1].name)
end
ITvision:dispatch_get(update, "/update/(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)", "/update/(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)", "/update/(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(.+)")
ITvision:dispatch_post(update, "/update/(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)", "/update/(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)", "/update/(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(.+)")


------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
-- prepara a operacao para remover uma monitoracao
function remove(web, service_object_id)
   local APPS_S = {}
   local M = Monitor.select_ics("m.service_object_id = "..service_object_id)
   local S = Monitor.select_ics("m.name1 = '"..M[1].m_name1.."' and m.name2 <> '"..config.monitor.check_host.."'")
   -- aplicacoes com o objecto especificado
   local APPS = Monitor.make_query_5(nil,
                      "ax.id in (select app_id from itvision_app_objects where service_object_id = "..service_object_id..")", true)
   -- se o objecto for host e se ele possuir services associados, APPS_S sao as aplicacoes que possuem estes services
   local slist = ""
   if #S > 0 then
      for i,v in ipairs(S) do
         if slist ~= "" then slist = slist.."," end
         slist = slist..v.m_service_object_id --"298"
      end
      APPS_S = Monitor.make_query_5(nil,
                      "ax.id in (select app_id from itvision_app_objects where service_object_id in ("..slist.."))", true)
   end

   --DEBUG: text_file_writer("/tmp/q", slist)

   return render_remove(web, M, S, APPS, APPS_S)
end
ITvision:dispatch_get(remove, "/remove/(%d+)")
ITvision:dispatch_post(remove, "/remove/(%d+)")


------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
-- executa a operacao de remocao da monitoracao e de todos os servicos associados se objeto for hsot
-- remove ainda todas as entrada relacionada aos hosts e servicos que existam em alguma aplicacao
function delete(web, service_object_id)
   local msg = ""
   local monitor = monitors:select_monitor_from_service(service_object_id) 
   local hostname = monitor[1].name1
   local service_desc = monitor[1].name2
   local cond_

   -- remove o monitor e o host/sevice de todas as apps
   remove_svc_cfg_file (hostname, service_desc)
   monitors:delete_cond("service_object_id = "..service_object_id)
   app_objects:delete_cond("service_object_id = "..service_object_id)
   app_relats:delete_cond("from_object_id = "..service_object_id.." or to_object_id = "..service_object_id)
   --DEBUG: text_file_writer("/tmp/rr", hostname.."\n"..service_desc.."\n"..service_object_id.."\n")

   -- se o objeto for um host remova os servicos associados e as aplicacoes associadas a estes servicos
   if service_desc == config.monitor.check_host then
      remove_hst_cfg_file (hostname)

      svc = Model.query("itvision_monitors", "name1 = '"..hostname.."'", nil, "service_object_id, name2")
      if #svc > 0 then
         for i,v in ipairs(svc) do
            local service_desc = v.name2
            --DEBUG: text_file_writer("/tmp/rs"..i, hostname.."\n"..service_desc.."\n"..v.service_object_id.."\n")
            remove_svc_cfg_file (hostname, service_desc)
            monitors:delete_cond("service_object_id = "..v.service_object_id)
            app_objects:delete_cond("service_object_id = "..v.service_object_id)
            app_relats:delete_cond("from_object_id = "..v.service_object_id.." or to_object_id = "..v.service_object_id)
         end         
      end
   end

   msg = "Check de SERVIÇO: "..monitor[1].name.." removido."

   os.reset_monitor()
   if web then
      return web:redirect(web:link("/list/"..msg))
   else
      return true
   end

end
ITvision:dispatch_get(delete, "/delete/(%d+)")
ITvision:dispatch_post(delete, "/delete/(%d+)")



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function pend(web)
   os.reset_monitor()
   sync_services()
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_get(pend, "/pend/")


------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
-- executa a operacao de insersao de host
function insert_host(web, p_id, sv_id, c_id, n_id, c_name, ip)
   local msg, check_args = "", ""
   local hst_name = c_id.."_"..p_id
   local h = monitors:select_monitors(hst_name)

   ------------------------------------------------------------
   -- recupera argumentos defaults do check_host (HOST_ALIVE)
   ------------------------------------------------------------
   local tables_ = [[nagios_objects o, itvision_checkcmds c, itvision_checkcmd_default_params p]]
   local cond_   = [[o.objecttype_id = 12 and o.is_active = 1 and o.object_id = c.cmd_object_id and c.id = p.checkcmds_id 
                     and p.sequence is not null and o.name2 is null and o.name1 = ']]..config.monitor.check_host..[[']]
   local extras_ = [[order by p.sequence]]
   local p = Model.query(tables_, cond_, extras_)

   ------------------------------------------------------
   -- cria check host e service ping caso nao exista
   ------------------------------------------------------
   if h[1] == nil then
      --chk_id = objects:select_check_host() desnecessario???
      local cmd_object = p[1].object_id

      -- cria lista de parametros do comando HOST_ALIVE
      for i,v in ipairs(p) do
         check_args = check_args.."!"..v.default_value
         insert_params( hst_name, config.monitor.check_host, v.object_id, i, v.default_value )
      end

      -- cria monitor sem a referencia do servico check_alive associado.
      insert_host_cfg_file (hst_name, hst_name, ip)
      monitors:insert_monitor(c_entity_id, p_id, nil, -1, cmd_object, config.monitor.check_host, hst_name, config.monitor.check_host, 0, "hst")
      insert_service_cfg_file (hst_name, config.monitor.check_host, config.monitor.check_host, check_args)

      msg = msg.."Check do HOST: "..c_name.." para o IP "..ip.." "..error_message(11)
   else
      msg = msg.."Check do HOST: "..c_name.." já existe! "
   end   

   --os.sleep(1)
   os.reset_monitor()
   if web then
      return web:redirect(web:link("/list/"..msg..""))
   else
      return msg --para criacao de probes em massa
   end

end
ITvision:dispatch_get(insert_host, "/insert_host/(%d+):(%d+):(%d+):(%d+):(.+):(.+)")
ITvision:dispatch_post(insert_host, "/insert_host/(%d+):(%d+):(%d+):(%d+):(.+):(.+)")



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
-- executa a operacao de insersao de service
function insert_service(web, p_id, sv_id, c_id, n_id, c_name, sw_name, sv_name, ip)
   local msg = ""
   local hst_name = c_id.."_"..p_id

   local flags, opts = {}, {}
   local chk, chk_id

   local cmd = web.input.cmd
   local args = web.input.args
   local count = web.input.count
   local monitor_name = web.input.monitor_name
   local cmd_object = web.input.chk_id
   local chk_name = web.input.chk_name
   local check_args = ""

   -- o nome do monitoramento/sevice_description deve conter o nome do comando para o nagiosgrapher
   -- e ainda, o service_description (name2) deve possuir um numero sequencial ao final
   local service_desc = chk_name.."_"..objects:count_alike(hst_name, chk_name)

   for i = 1,count do
      check_args = check_args.."!"..web.input["opt"..i]
      insert_params( hst_name, service_desc, cmd_object, i, web.input["opt"..i] )
   end

   ------------------------------------------------------
   -- cria check host e service ping caso nao exista
   ------------------------------------------------------
   insert_host(nil, p_id, sv_id, c_id, n_id, c_name, ip)

   ------------------------------------------------------
   -- cria o service check caso tenha sido requisitado
   -- e cria monitor sem a referencia do servico associado.
   ------------------------------------------------------
   monitors:insert_monitor(c_entity_id, p_id, sv_id, -1, cmd_object, monitor_name, hst_name, service_desc, 0, "svc")
   insert_service_cfg_file (hst_name, service_desc, chk_name, check_args)

   msg = "Check de SERVIÇO: "..monitor_name.." - HOST: ".. c_name.." - COMANDO: "..chk_name.." criado."

   if web then
      --os.sleep(1)
      return web:redirect(web:link("/list/"..msg..""))
   else
      return msg --para criacao de probes em massa
   end

end
ITvision:dispatch_get(insert_service, "/insert_service/(%d+):(%d+):(%d+):(%d+):(.+):(.+):(.+):(.+)")
ITvision:dispatch_post(insert_service, "/insert_service/(%d+):(%d+):(%d+):(%d+):(.+):(.+):(.+):(.+)")


------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
-- executa a operacao de update de monitoracao de servico
function update_service(web, service_object_id, c_id, p_id, query, no_header)
   local msg = ""

   local flags, opts = {}, {}
   local chk, chk_id

   local cmd = web.input.cmd
   local args = web.input.args
   local count = web.input.count
   local monitor_name = web.input.monitor_name
   local cmd_object = web.input.chk_id
   local chk_name = web.input.chk_name
   local check_args = ""

   for i = 1,count do
      check_args = check_args.."!"..web.input["opt"..i]
      update_params( service_object_id, i, web.input["opt"..i] )
   end

   ------------------------------------------------------
   -- atualiza o service check caso tenha sido requisitado
   -- e cria monitor sem a referencia do servico associado.
   ------------------------------------------------------
   if not monitor_name then monitor_name = config.monitor.check_host end
   monitors:update_monitor(service_object_id, monitor_name)
   local monitor = monitors:select_monitor_from_service(service_object_id) 
   local host_name = monitor[1].name1
   local service_desc = monitor[1].name2
   insert_service_cfg_file (host_name, service_desc, chk_name, check_args)

   msg = "Check de SERVIÇO: "..monitor_name.." atualizado."

   if web then
      --os.sleep(1)
      return web:redirect(web:link("/update/"..query..":"..c_id..":"..p_id..":0:0:"..service_object_id..":"..no_header..":"..msg))
   else
      return msg --para criacao de probes em massa
   end

end
ITvision:dispatch_get(update_service, "/update_service/(%d+):(%d+):(%d+):(%d+):(%d+)")
ITvision:dispatch_post(update_service, "/update_service/(%d+):(%d+):(%d+):(%d+):(%d+)")


------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--executa a desabilitacao de monitoracao de servico
function desable_service(web, service_object_id, c_id, p_id, query, no_header, flag)
   local msg = ""
   local flags, opts = {}, {}
   local chk, chk_id
   flag = tonumber(flag)

   local cmd = web.input.cmd
   local args = web.input.args
   local count = web.input.count
   local monitor_name = web.input.monitor_name
   local cmd_object = web.input.chk_id
   local chk_name = web.input.chk_name
   local check_args = ""

   for i = 1,count do
      check_args = check_args.."!"..web.input["opt"..i]
      update_params( service_object_id, i, web.input["opt"..i] )
   end

   ------------------------------------------------------
   -- atualiza o service check caso tenha sido requisitado
   -- e cria monitor sem a referencia do servico associado.
   ------------------------------------------------------
   monitors:enable_monitor(service_object_id, flag)
   local monitor = monitors:select_monitor_from_service(service_object_id) 
   local host_name = monitor[1].name1
   local service_desc = monitor[1].name2
   insert_service_cfg_file (host_name, service_desc, chk_name, check_args, flag)

   if tonumber(flag) == 0 then
      msg = "Check de SERVIÇO: desabilitado."
   else
      msg = "Check de SERVIÇO: habilitado."
   end

   if web then
      --os.sleep(1)
      return web:redirect(web:link("/update/"..query..":"..c_id..":"..p_id..":0:0:"..service_object_id..":"..no_header..":"..msg))
   else
      return true, msg --para criacao de probes em massa
   end

end
ITvision:dispatch_get(desable_service, "/desable_service/(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")
ITvision:dispatch_post(desable_service, "/desable_service/(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function blank(web)
   return render_blank(web)
end
ITvision:dispatch_get(blank, "/blank")


ITvision:dispatch_static("/css/%.css", "/script/%.js")




------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------


-- views ------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_filter(web)
   local res = {}

   res[#res+1] = {strings.name..": ", input{ type="text", name="hostname", value = web.input.hostname }, " "}
   res[#res+1] = {strings.inventory..": ", input{ type="text", name="inventory", value = web.input.inventory }, " "}
   res[#res+1] = {strings.sn..": ", input{ type="text", name="sn", value = web.input.sn }, " "}

   return res
end



---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
function render_list(web, ics, chk, msg)
   local permission, auth = Auth.check_permission(web, "checkcmds")
   local row, res, link_add_host, link_del_host, link_add_serv, url = {}, {}, "", "", nil

   local header = { -- sem o nome do comando 'chk'. Só que agora o alias aparece como o 'Comando' na tabela
      "Dispositivo", "IP", "Status", strings.type, strings.command, ".","Ação"
   }

   for i, v in ipairs(ics) do
      local ip, itemtype, id, hst_name, m_name, name = "", "", "", nil, nil, nil
      v.c_id = v.c_id or 0 v.n_id = v.n_id or 0 v.p_id = v.p_id or 0 v.sv_id = v.sv_id or 0
      hst_name = find_hostname(v.c_alias, v.c_name, v.c_itv_key)
      if v.m_name == "" then m_name = "-" else m_name = v.m_name end -- nome do comando de checagem
      link_add_host = "-"
      link_add_serv = "-"

      -- os ifs abaixo existem em funcao da direrenca entre as queries com Computer e as com Network
      if v.p_itemtype then itemtype = v.p_itemtype else itemtype = "NetworkEquipment" end
      if v.p_ip then ip = v.p_ip else ip = v.n_ip end
      if v.c_id ~= 0 then c_id = v.c_id else c_id = v.n_id end

      if v.s_check_command_object_id == nil then -- se o ic não possuir um comando de check associado entao...
         chk = ""
         if permission == "w" then
            if tonumber(v.m_service_object_id) == -1 then -- se check cmd pendente...
               link_add_host = font{ color="orange", "Pendente" }
            else
               link_add_host = a{ href= web:link("/insert_host/"..v.p_id..":"..v.sv_id..":"..v.c_id..":"..v.n_id..":"
                                         ..hst_name..":"..ip), strings.add.." "..strings.host }
            end
         end
      else -- caso o ic possua um comando de check associado...
         content = objects:select_checks(v.s_check_command_object_id)
         if content[1] then
            chk = content[1].name1
         else
            chk = "Ainda Desconhecido" -- TODO: Este é um caso particular ainda nao totalmente entendido      
                                       -- Deve estar relacionado a demora do ndo2db
                                       -- Por isso estou tirando esta entrada da tabela na tela de checagem!
         end
         link_add_host = a{ href= web:link("/update/"..v[1]..":"..c_id..":"..v.p_id..":0:0:"..v.m_service_object_id..":0"), strings.edit }
         link_del_host = a{ href= web:link("/remove/"..v.m_service_object_id), strings.remove }
         link_add_host = link_add_host.." | "..link_del_host
         link_del_host = nil
         link_add_serv = a{ href= web:link("/add/"..v[1]..":"..c_id..":"..v.p_id..":0"), strings.add.." "..strings.service }
      end

      web.prefix = "/orb/obj_info"
      if v.m_service_object_id == nil then
         name = hst_name
         --url = nil
         web.prefix = "/servdesk"
         if itemtype == "Computer" then
            url = web:link("/front/computer.form.php?id="..c_id)
         elseif itemtype == "NetworkEquipment" then
            url = web:link("/front/networkequipment.form.php?id="..c_id)
         end
      elseif m_name == config.monitor.check_host or m_name ==  "-" then
         url = web:link("/hst/"..v.m_service_object_id)
      else 
         url = web:link("/svc/"..v.m_service_object_id)
      end

      if permission == "w" and url ~= nil then
         name = a{ href=url, hst_name}
      else
         name = hst_name
      end

      if v.sw_name ~= "" then itemtype = "Service" end
      web.prefix = "/orb/probe"

      local state, statename, status
      if tonumber(v.ss_has_been_checked) == 1 then
         if tonumber(v.m_state) == 0 then
            state = tonumber(APPLIC_DISABLE)
            output = ""
         else
            state = tonumber(v.ss_current_state)
            output = v.ss_output
         end
         statename = applic_alert[state].name
         status={ state=state, colnumber=3 }
      else
         state = -1
         statename = "-"
         status=nil
      end

      imgs = { a{ href="#", title="Editar", img{src="/pics/pencil.png", height="20px"}}, " ", 
               a{ href="#", title="Editar", img{src="/pics/plus.png",   height="20ps"}}, " ", 
               a{ href="#", title="Editar", img{src="/pics/trash.png",  height="20ps"}}, " ", 
      }

      -- com nome do comando de checagem
      row[#row + 1] = { status=status, name, ip, statename, itemtype, m_name, link_add_host, imgs } 

      -- se o nome do comando é o HOST_ALIVE, deve-se abrir a opcao para a criacao de mais um servico
      if ( m_name == config.monitor.check_host ) then 
         row[#row + 1] = { hst_name, ip, "-", "-", "-", link_add_serv } -- sem nome do comando de checagem
      end
   end

   res[#res+1] = render_resume(web)
   res[#res+1] = render_content_header(auth, "Checagem", nil, web:link("/list"))
   if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ font{ color="red", msg } } end
   local bar = {}
   web.prefix = "/orb/probe"
   res[#res+1] = render_form_bar( render_filter(web), strings.search, web:link("/list"), web:link("/list") )
   res[#res+1] = render_table(row, header)
   res[#res+1] = render_bar( button_link("Forçar Pendências", web:link("/pend/"), "calendrier") )
   res[#res+1] = { br(), br(), br(), br() }

   return render_layout(res)
end




------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_confirm(web, msg)
   local res = p{ "SHOW", br(), msg }
   return render_layout(res)
end



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_checkcmd(web, chk_id, hst_name, ip, url_test, url_insert, url_update, url_desable, url_remove, chk_params, monitor_name, do_test, origin, monitor_state)
   local permission = Auth.check_permission(web, "checkcmds")
   local row, row_hidden, cmd = {}, {}, ""
   local readonly, text = "", ""
   local header = { strings.parameter.." #", strings.value, strings.description }
   local params, params_hidden, args = {}, {} , ""
   local path = "/usr/lib/nagios/plugins"
   local count = 0
   local disabled = ""
   monitor_state = tonumber(monitor_state)

   if chk_id == 0 then
      res[#res+1] = { br(), "Selecione um comando de checagem!", br() }
      return res
   end

   --DEBUG: text_file_writer("/tmp/cm", " "..chk_id.."\n")
   local c, p = Checkcmds.get_checkcmd_default_params(chk_id, nil, false)
   local chk = path.."/"..c[1].command
   monitor_name = monitor_name or c[1].label
   
   for i, v in ipairs(p) do
      v.flag = v.flag or ""
      if v.sequence == nil then readonly="readonly=\"readonly\"" else readonly="" end
      if v.variable == "$HOSTNAME$" then
         value = hst_name
      elseif v.variable == "$HOSTADDRESS$" then
         value = ip
      else
         v.default_value = v.default_value or ""
         value = v.default_value

      end

      -- soh os parametros variaveis eh que serao usado na criacao do comando
      if string.sub(v.variable,1,4) == "$ARG" then
         count = count + 1
         if chk_params and chk_params[i].flag then
            row_hidden[#row_hidden + 1] = { 
               { "<INPUT TYPE=HIDDEN NAME=\"flag"..count.."\" value=\""..chk_params[i].flag.."\">" ,
                 "<INPUT TYPE=HIDDEN NAME=\"opt"..count.."\" value=\""..chk_params[i].default_value.."\" "..readonly..">",
                 "<INPUT TYPE=HIDDEN NAME=\"seq\" value=\""..v.sequence.."\">" } }

            row[#row + 1] = { count,
               { "<INPUT TYPE=HIDDEN NAME=\"flag"..i.."\" value=\""..chk_params[i].flag.."\">" ,
                 "<INPUT TYPE=TEXT NAME=\"opt"..i.."\" value=\""..chk_params[i].default_value.."\" "..readonly..">" }, v.description }

            args = args.." "..chk_params[i].flag.." "..chk_params[i].default_value

         else
            row_hidden[#row_hidden + 1] = { 
               { "<INPUT TYPE=HIDDEN NAME=\"flag"..count.."\" value=\""..v.flag.."\">" ,
                 "<INPUT TYPE=HIDDEN NAME=\"opt"..count.."\" value=\""..value.."\" "..readonly..">",
                 "<INPUT TYPE=HIDDEN NAME=\"seq\" value=\""..v.sequence.."\">" } }

            row[#row + 1] = { count,
               { "<INPUT TYPE=HIDDEN NAME=\"flag"..i.."\" value=\""..v.flag.."\">" ,
                 "<INPUT TYPE=TEXT NAME=\"opt"..i.."\" value=\""..value.."\" "..readonly..">" }, v.description }

            args = args.." "..v.flag.." "..value

         end
      else
         args = args.." "..v.flag.." "..value
      end
   end

   local hidden = { 
      "<INPUT TYPE=HIDDEN NAME=\"cmd\" value=\""..c[1].command.."\">",
      "<INPUT TYPE=HIDDEN NAME=\"chk_id\" value=\""..chk_id.."\">" ,
      "<INPUT TYPE=HIDDEN NAME=\"chk_name\" value=\""..c[1].name1.."\">",
      "<INPUT TYPE=HIDDEN NAME=\"count\" value=\""..count.."\">" 
   }
   -- desabilita campo caso o comando seja o HOST_ALIVE que nao pode ser mudado
   if monitor_name == config.monitor.check_host then disabled="disabled" end
   local display_show = {
      { strings.alias, "<INPUT TYPE=TEXT "..disabled.." NAME=\"monitor_name\" value=\""..monitor_name.."\">", 
        "Nome alternativo para o comando a ser criado." }
   }
   local display_hidden = { "<INPUT TYPE=HIDDEN NAME=\"monitor_name\" value=\""..monitor_name.."\">" }

   params = {hidden, br(), render_table(row, header)}
   params_hidden = {hidden, br(), br(), render_table(display_show, nil), row_hidden}
   text = strings.parameter.."s do comando "..c[1].name1


   if permission == "w" then
      if monitor_state == 1 then
         res[#res+1] = center{ render_form(web:link(url_test), nil, params, true, strings.test ) }
      end 

      if do_test then
         -- DEBUG: res[#res+1] = { br(), chk.." "..args, br() }; 
         res[#res+1] = { br(), br(), os.capture(chk.." "..args, true) }
      end
      if origin == "add" then
         res[#res+1] = center{ render_form(web:link(url_insert), nil, params_hidden, true, "Criar checagem" ) }
      else
         local b_name, flag
         if do_test then
            res[#res+1] = center{ render_form(web:link(url_update), nil, params_hidden, true, "Atualizar checagem" ) }
         end
         if monitor_state == 1 then 
            b_name = "Desabilitar checagem"
            flag = ":0"
         else
            b_name = "Habilitar checagem"
            flag = ":1"
         end
         res[#res+1] = center{ render_form(web:link(url_desable..flag), nil, { hidden, row_hidden } , true, b_name ) }
         local r_name = "Remover checagem"
         res[#res+1] = center{ render_form(web:link(url_remove), nil, { hidden, row_hidden } , true, r_name ) }
      end
   else
      res[#res+1] = params
   end

   return res
end



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_add(web, ics, chk, params, chk_params, monitor_name)
   local auth = Auth.check(web)
   local v = ics[1]
   local row = {}
   local res = {}
   local serv, ip, itemtype, id, hst_name = "", "", "", "", nil
   local s, r, url_test, url_insert, url_update, url_desable, url_remove, chk_id

   -- ESTE RENDER SOh SERVE PARA SERVICES.
   --if params.cmd then chk_id = params.cmd else chk_id = chk[1].object_id end
   if params.cmd then chk_id = params.cmd else chk_id = 0 end
   --local header = { "Dispositivo", "IP", "Nome da Checagem", strings.type, strings.command }
   local header = { "Dispositivo", "IP", "Nome da Checagem", strings.command }

   if v then
      v.c_id = v.c_id or 0; v.n_id = v.n_id or 0; v.p_id = v.p_id or 0; v.sv_id = v.sv_id or 0;

      hst_name = find_hostname(v.c_alias, v.c_name, v.c_itv_key)

      url_insert = "/insert_service/"..v.p_id..":"..v.sv_id..":"..v.c_id..":"..v.n_id..":"..hst_name..":nana:nono:"..v.p_ip
      url_update = "/update_service/"..params.service_object_id..":"..params.c_id..":".. params.p_id..":"..params.query..":".. params.no_header
      url_desable = "/desable_service/"..params.service_object_id..":"..params.c_id..":".. params.p_id..":"..params.query..":".. params.no_header
      url_remove = "/remove/"..params.service_object_id
      url_test   = "/"..params.origin.."/"..params.query..":"..params.c_id

      if params.p_id  then url_test = url_test..":"..params.p_id  else url_test = url_test..":0" end
      if params.sv_id then url_test = url_test..":"..params.sv_id else url_test = url_test..":0" end

      if params.origin == "update" then
         url_test = url_test..":1" -- nao testar - parametro do_test
      else
         url_test = url_test..":0" -- testar - parametro do_test
      end

      cmd = { select_option_onchange("check", chk, "object_id", "label", chk_id, web:link(url_test)), " " }
      row[#row + 1] = { hst_name, v.p_ip, "-", cmd, }
      
      if params.origin == "update" then
         url_test = url_test..":"..params.service_object_id..":"..params.no_header
      else
         url_test = url_test..":"..chk_id
      end
   end


   if params.no_header == 0 then
      res[#res+1] = render_content_header(auth, "Checagem", nil, web:link("/list"))
   end
   if params.msg ~= nil then
      res[#res + 1] = p{ font{ color="red", params.msg }, br()  }
   end
   res[#res+1] = render_table(row, header)
   res[#res+1] = render_checkcmd(web, chk_id, hst_name, v.p_ip, url_test, url_insert, url_update, url_desable, url_remove, chk_params, monitor_name, params.do_test, params.origin, params.monitor_state)


   return render_layout(res)
end




------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_remove(web, M, S, APPS, APPS_S)
   M = M[1]
   local res, row, url, tp = {}, {}, "" , ""
   --local permission, auth = Auth.check_permission(web, "probe", true)

   if M.m_name2 == config.monitor.check_host then
      tp = "DISPOSITIVO"
      name = find_hostname(M.c_alias, M.c_name, M.c_itv_key)
   else 
      tp = "SERVIÇO"
      name = find_hostname(M.c_alias, M.c_name, M.c_itv_key).."@"..M.m_name
   end
   res[#res+1] = { b{ "REMOÇÃO DO "..tp..": "..name } , br(), br() } 

   -- APLICACOES
   if #APPS > 0 then
      header = { "NOME", "STATUS ATUAL", "Última checagem", "Próxima checagem", "Última mudança de estado"  }
      res[#res+1] = { b{ "APLICAÇÕES QUE POSSUEM ESTE "..tp.." QUE SERÃO ALTERADAS" }}
      for i, v in ipairs(APPS) do
         row[#row+1] = { v.ax_name, {value=name_ok_warning_critical_unknown(v.ss_current_state), state=v.ss_current_state}, 
                      string.extract_datetime(v.ss_last_check), string.extract_datetime(v.ss_next_check), string.extract_datetime(v.ss_last_state_change), }
      end
      res[#res+1] = render_table( row, header )
      res[#res+1] = { br(), br(), br() }
   end

   -- SERVIÇOS
   if #S > 0 then
      if tp == "DISPOSITIVO" then
         row = {}
         header = { "NOME", "STATUS ATUAL", "Última checagem", "Próxima checagem", "Última mudança de estado"  }
         res[#res+1] = { b{ "SERVIÇOS ASSOCIADOS A ESTE "..tp.." QUE TAMBÉM SERÃO REMOVIDOS" }}
         if M.m_name2 == config.monitor.check_host and v.m_name then
            for i, v in ipairs(S) do
               row[#row+1] = { v.m_name, {value=name_ok_warning_critical_unknown(v.ss_current_state), state=v.ss_current_state}, 
                            string.extract_datetime(v.ss_last_check), string.extract_datetime(v.ss_next_check), string.extract_datetime(v.ss_last_state_change), }
            end
         end
         res[#res+1] = render_table( row, header )
         res[#res+1] = { br(), br(), br() }
      end
   end


   -- APLICACOES DOS SERVIÇOS
   if APPS_S and #APPS_S > 0 then
      if tp == "DISPOSITIVO" then
         row = {}
         header = { "NOME", "STATUS ATUAL", "Última checagem", "Próxima checagem", "Última mudança de estado"  }
         res[#res+1] = { b{ "APLICAÇÕES QUE POSSUEM SERVIÇOS ASSOCIADOS A ESTE "..tp.." QUE TAMBÉM SERÃO ALTERADOS" }}
         if M.m_name2 == config.monitor.check_host and v.m_name then
            for i, v in ipairs(APPS_S) do
               row[#row+1] = { v.ax_name, {value=name_ok_warning_critical_unknown(v.ss_current_state), state=v.ss_current_state}, 
                            string.extract_datetime(v.ss_last_check), string.extract_datetime(v.ss_next_check), string.extract_datetime(v.ss_last_state_change), }
            end
         end
         res[#res+1] = render_table( row, header )
         res[#res+1] = { br(), br(), br() }
      end
   end


   -- FORM de pergunta
   if service_object_id then
      web.prefix = "/orb/probe"
      url_ok = web:link("/delete/"..M.m_service_object_id)
      url_cancel = web:link("/list")

      res[#res+1] = p{
         b{ strings.exclude_quest.." "..strings.checkcommand.." "..M.m_name.." para o dispositivo "..name.."?" }, 
         p{ button_link(strings.yes, url_ok) },
         p{ button_link(strings.cancel, url_cancel) },
      }
   end

   return render_layout(res)
end



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_blank(web)
   return render_layout()
end


orbit.htmlify(ITvision, "render_.+")

return _M


