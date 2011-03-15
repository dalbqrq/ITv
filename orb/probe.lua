#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "Monitor"
require "Checkcmds"
require "View"
require "util"
require "monitor_util"

module(Model.name, package.seeall,orbit.new)

local objects  = Model.nagios:model "objects"
local monitors = Model.itvision:model "monitors"

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

   clause = clause .. " and o.name2 is null and o.is_active = 1"

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
      clause = " object_id = '"..cmd.."' "
   end

   return Model.query("nagios_objects", clause)
end


function monitors:insert_monitor(networkport, softwareversion, service_object, name, name1, name2, state, type_)
   if tonumber(networkport)      == 0 then networkport      = nil end         
   if tonumber(softwareversion)  == 0 then softwareversion  = nil end         

   local mon = { 
      instance_id = Model.db.instance_id,
      entities_id = 0,
      service_object_id    = service_object,
      networkports_id      = networkport,
      softwareversions_id  = softwareversion,
      name  = name,
      name1 = name1,
      name2 = name2,
      state = state,
      type  = type_,
   }
   return Model.insert("itvision_monitors", mon)
end


-- controllers ------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function list(web, msg)
   local clause = nil
   if web.input.hostname ~= "" and web.input.hostname ~= nil then clause = "c.name like '%"..web.input.hostname.."%' " end
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

   local cmp = Monitor.select_monitors(clause)
   local chk = Checkcmds.select_checkcmds()

   return render_list(web, cmp, chk, msg)
end
ITvision:dispatch_get(list, "/", "/list", "/list/(.+)")
ITvision:dispatch_post(list, "/list", "/list/(.+)")



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function add(web, query, c_id, p_id, sv_id, default)
   local count = web.input.count
   local chk_id = web.input.chk_id
   local chk_name = web.input.chk_name
   local monitor_name = web.input.monitor_name
   local chk_params = nil

   local chk = Checkcmds.select_checkcmds(nil, true)
   local cmp = {}

   query = tonumber(query)

   if query == 1 then
      cmp = Monitor.make_query_1(c_id, p_id)
   elseif query == 2 then
      cmp = Monitor.make_query_2(c_id, p_id, sv_id)
   elseif query == 3 then
      cmp = Monitor.make_query_3(c_id, p_id)
   elseif query == 4 then
      cmp = Monitor.make_query_4(c_id, p_id, sv_id)
   end

   local params = { query=query, c_id=c_id, p_id=p_id, sv_id=sv_id, default=default }

   if chk_id then
      _, chk_params = Checkcmds.get_check_params(chk_id, false, false)
      for i,v in ipairs(chk_params) do
         chk_params[i].flag = web.input["flag"..i]
         chk_params[i].default_value = web.input["opt"..i]
      end
   end

   return render_add(web, cmp, chk, params, chk_params, monitor_name)
end
ITvision:dispatch_get(add, "/add/(%d+):(%d+):(%d+):(%d+)", "/add/(%d+):(%d+):(%d+):(%d+):(%d+)")
ITvision:dispatch_post(add, "/add/(%d+):(%d+):(%d+):(%d+)", "/add/(%d+):(%d+):(%d+):(%d+):(%d+)")



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

--[[
          command_name        = PING
          command_line        = chck_ping
name1   = host_name           = Euler
name2   = service_description = My_PING
c_alias = alias               = euler
          check_command       = PING!400.0,20%!999.0,70%
p_id    = address             = 147.65.1.3


]]


------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function insert_host(web, p_id, sv_id, c_id, n_id, c_name, ip)
   local msg = ""
   local hst_name = ip.."_"..c_id

   h = objects:select_host(hst_name)

   ------------------------------------------------------
   -- cria check host e service ping caso nao exista
   ------------------------------------------------------
   if h[1] == nil then
      chk_id = objects:select_check_host()

      -- cria monitor sem a referencia do servico check_alive associado.
      insert_host_cfg_file (hst_name, hst_name, ip)
      monitors:insert_monitor(p_id, nil, -1, config.monitor.check_host, hst_name, config.monitor.check_host, 0, "hst")
      insert_service_cfg_file (hst_name, config.monitor.check_host, config.monitor.check_host, nil)

      msg = msg.."Check do HOST: "..c_name.." para o IP "..ip.." criado. "..error_message(11)
   else
      msg = msg.."Check do HOST: "..c_name.." já existe! "
   end   

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
function insert_service(web, p_id, sv_id, c_id, n_id, c_name, sw_name, sv_name, ip)
   local msg = ""
   local hst_name = ip.."_"..c_id

   local flags, opts = {}, {}
   local chk, chk_id

   local cmd = web.input.cmd
   local args = web.input.args
   local count = web.input.count
   local monitor_name = web.input.monitor_name
   local chk_id = web.input.chk_id
   local chk_name = web.input.chk_name
   local check_args = ""

   -- o nome do monitoramento/sevice_description deve conter o nome do comando para o nagiosgrapher
   -- e ainda, o service_description (name2) deve possuir um numero sequencial ao final
   local service_desc = chk_name.."_"..objects:count_alike(hst_name, chk_name)

   for i = 1,count do
      check_args = check_args.."!"..web.input["opt"..i]
--daniel
      params:insert(hst_name, service_desc, chk_id)
   end

   ------------------------------------------------------
   -- cria check host e service ping caso nao exista
   ------------------------------------------------------
   insert_host(nil, p_id, sv_id, c_id, n_id, c_name, ip)

   ------------------------------------------------------
   -- cria o service check caso tenha sido requisitado
   -- e cria monitor sem a referencia do servico associado.
   ------------------------------------------------------
   monitors:insert_monitor(p_id, sv_id, -1, monitor_name, hst_name, service_desc, 0, "svc")
   insert_service_cfg_file (hst_name, service_desc, chk_name, check_args)

   msg = "Check de SERVIÇO: "..monitor_name.." - HOST: ".. c_name.." - COMANDO: "..chk_name.." criado."

   if web then
      os.sleep(1)
      return web:redirect(web:link("/list/"..msg..""))
   else
      return msg --para criacao de probes em massa
   end

end
ITvision:dispatch_get(insert_service, "/insert_service/(%d+):(%d+):(%d+):(%d+):(.+):(.+):(.+):(.+)")
ITvision:dispatch_post(insert_service, "/insert_service/(%d+):(%d+):(%d+):(%d+):(.+):(.+):(.+):(.+)")



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function blank(web)
   return render_blank(web)
end
ITvision:dispatch_get(blank, "/blank")



ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_filter(web)
   local res = {}

   res[#res+1] = {strings.name..": ", input{ type="text", name="hostname", value = "" }, " "}
   res[#res+1] = {strings.inventory..": ", input{ type="text", name="inventory", value = "" }, " "}
   res[#res+1] = {strings.sn..": ", input{ type="text", name="sn", value = "" }, " "}

   return res
end



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_list(web, cmp, chk, msg)
   local row, res, link, url = {}, {}, {}, ""
   local header = {
      strings.alias.."/"..strings.name, "IP", "Software / Versão", strings.type, strings.command, strings.alias, "."
   }

   for i, v in ipairs(cmp) do
      local serv, ip, itemtype, id, hst_name, alias = "", "", "", "", nil, nil
      if v.sw_name ~= "" then serv = v.sw_name.." / "..v.sv_name end


      -- muitos dos ifs abaixo existem em funcao da direrenca entre as queries com Computer e as com Network
      v.c_id = v.c_id or 0 v.n_id = v.n_id or 0 v.p_id = v.p_id or 0 v.sv_id = v.sv_id or 0
      hst_name = find_hostname(v.c_alias, v.c_name, v.c_itv_key)
      alias = v.m_name


      if v.p_itemtype then itemtype = v.p_itemtype else itemtype = "NetworkEquipment" end
      if v.p_ip then ip = v.p_ip else ip = v.n_ip end
      if v.c_id ~= 0 then c_id = v.c_id else c_id = v.n_id end


      if v.s_check_command_object_id == nil then 
         chk = ""
         if tonumber(v.m_service_object_id) == -1 then
            link = font{ color="orange", "Pendente" }
         elseif serv ~= "" then
            link = a{ href= web:link("/add/"..v[1]..":"..c_id..":"..v.p_id..":"..v.sv_id), strings.add }
         else
            link = a{ href= web:link("/insert_host/"..v.p_id..":"..v.sv_id..":"..v.c_id..":"..v.n_id..":"
                                      ..hst_name..":"..ip), strings.add.." host" }
         end
      else
         content = objects:select_checks(v.s_check_command_object_id)
         chk = content[1].name1
         link = "-"
      end


      web.prefix = "/servdesk"
      if itemtype == "Computer" then
         url = web:link("/front/computer.form.php?id="..c_id)
      elseif itemtype == "NetworkEquipment" then
         url = web:link("/front/networkequipment.form.php?id="..c_id)
      end

      if v.sw_name ~= "" then itemtype = "Service" end
      web.prefix = "/orb/probe"
      row[#row + 1] = { a{ href=url, hst_name}, ip, serv, itemtype, chk, alias, link }
   end

   res[#res+1] = render_content_header("Checagem", nil, web:link("/list"))
   if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ font{ color="red", msg } } end
   res[#res+1] = render_form_bar( render_filter(web), strings.search, web:link("/list"), web:link("/list") )
   res[#res+1] = render_table(row, header)

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
function render_checkcmd(web, chk_id, hst_name, ip, url_test, url_insert, chk_params, monitor_name)
   local row, row_hidden, cmd = {}, {}, ""
   local readonly, text = "", ""
   local header = { strings.parameter.." #", strings.value, strings.description }
   local params, params_hidden, args = {}, {} , ""
   local path = "/usr/lib/nagios/plugins"
   local count = 0

   local c, p = Checkcmds.get_check_params(chk_id, false, false)
   if chk_params then p = chk_params end
   local chk = path.."/"..c[1].command

   monitor_name = monitor_name or c[1].name1
   
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
         row_hidden[#row_hidden + 1] = { 
            { "<INPUT TYPE=HIDDEN NAME=\"flag"..count.."\" value=\""..v.flag.."\">" ,
              "<INPUT TYPE=HIDDEN NAME=\"opt"..count.."\" value=\""..value.."\" "..readonly..">",
              "<INPUT TYPE=HIDDEN NAME=\"seq\" value=\""..v.sequence.."\">" } }
      end

      row[#row + 1] = { i,
         { "<INPUT TYPE=HIDDEN NAME=\"flag"..i.."\" value=\""..v.flag.."\">" ,
           "<INPUT TYPE=TEXT NAME=\"opt"..i.."\" value=\""..value.."\" "..readonly..">" }, v.description }

      args = args.." "..v.flag.." "..value
   end

   local hidden = { 
      "<INPUT TYPE=HIDDEN NAME=\"cmd\" value=\""..c[1].command.."\">",
      "<INPUT TYPE=HIDDEN NAME=\"chk_id\" value=\""..chk_id.."\">" ,
      "<INPUT TYPE=HIDDEN NAME=\"chk_name\" value=\""..c[1].name1.."\">",
      "<INPUT TYPE=HIDDEN NAME=\"count\" value=\""..count.."\">" 
   }
   local display_show = {
      { strings.alias, "<INPUT TYPE=TEXT NAME=\"monitor_name\" value=\""..monitor_name.."\">", 
        "Nome alternativo para o comando a ser criado." }
   }
   local display_hidden = { "<INPUT TYPE=HIDDEN NAME=\"monitor_name\" value=\""..monitor_name.."\">" }

   params = {hidden, br(), render_table(row, header)}
   params_hidden = {hidden, br(), br(), render_table(display_show, nil), row_hidden}
   text = strings.parameter.."s do comando "..c[1].name1

   res[#res+1] = center{ render_form(web:link(url_test), nil, params, true, strings.test ) }
   res[#res+1] = { br(), os.capture(chk.." "..args, true) }
   res[#res+1] = center{ render_form(web:link(url_insert), nil, params_hidden, true, "Criar checagem" ) }

   return res
end



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_add(web, cmp, chk, params, chk_params, monitor_name)
   local v = cmp[1]
   local row = {}
   local res = {}
   local serv, ip, itemtype, id, hst_name = "", "", "", "", nil
   local s, r, url_test, url_insert, chk_id

   -- ESTE RENDER SOh SERVE PARA SERVICES.
   if params.default then chk_id = params.default else chk_id = chk[1].object_id end
   local header = { strings.alias.."/"..strings.name, "IP", "SW / Versão", strings.type, strings.command }

   if v then
      serv = v.sw_name.." / "..v.sv_name
      v.c_id = v.c_id or 0; v.n_id = v.n_id or 0; v.p_id = v.p_id or 0; v.sv_id = v.sv_id or 0;
      --if v.p_itemtype then itemtype = v.p_itemtype else itemtype = "NetworkEquipment" end

      hst_name = find_hostname(v.c_alias, v.c_name, v.c_itv_key)
      url_insert = "/insert_service/"..v.p_id..":"..v.sv_id..":"..v.c_id..":"..v.n_id..":"..hst_name..":"..v.sw_name
                    ..":"..v.sv_name..":"..v.p_ip

      url_test="/add/"..params.query..":"..params.c_id
      if params.p_id    then url_test = url_test..":"..params.p_id    end
      if params.sv_id   then url_test = url_test..":"..params.sv_id   end

      cmd = { select_option_onchange("check", chk, "object_id", "name1", chk_id, web:link(url_test)), " " }
      row[#row + 1] = { hst_name, v.p_ip, serv, itemtype, cmd, }

      url_test = url_test..":"..chk_id
   end


   res[#res+1] = render_content_header("Checagem", nil, web:link("/list"))
   res[#res+1] = render_table(row, header)
   res[#res+1] = render_checkcmd(web, chk_id, hst_name, v.p_ip, url_test, url_insert, chk_params, monitor_name)


   return render_layout(res)
end




------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_remove(web)
   -- VAZIO
end


------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_blank(web)
   return render_layout()
end


orbit.htmlify(ITvision, "render_.+")

return _M


