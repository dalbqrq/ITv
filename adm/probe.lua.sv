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


function objects:select_host(name1)
   local clause = ""
   if name1 ~= nil then
      clause = " o.name1 = '"..name1.."'"
   else
      clause = " o.name1 like '"..config.monitor.check_app.."%' "
   end

   clause = clause .. " and m.softwareversions_id is null and o.name2 = m.id and o.is_active = 1"

   return Model.query("nagios_objects o, itvision_monitors m", clause)
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


function monitors:insert_monitor(networkport, softwareversion, service_object, display_name, state, type_)
   if tonumber(networkport)      == 0 then networkport      = nil end         
   if tonumber(softwareversion)  == 0 then softwareversion  = nil end         

   local mon = { 
      instance_id = Model.db.instance_id,
      entities_id = 0,
      service_object_id    = service_object,
      networkports_id      = networkport,
      softwareversions_id  = softwareversion,
      display_name         = display_name,
      state = state,
      type  = type_,
   }
   return Model.insert_monitor("itvision_monitors", mon)
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

   return render_add(web, cmp, chk, params)
end
ITvision:dispatch_get(add, "/add/(%d+):(%d+):(%d+):(%d+)", "/add/(%d+):(%d+):(%d+):(%d+):(%d+)")



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--[[
   insert()

   sv_id == 0 significa que entrada nao possui software associado e eh somente uma maquina
   sw_name e sv_name == no_software_code entao os nomes sao nulos e isto é um host e nao um service


   O nome de um host deverá ser composto somente pelo p_id.
   O nome de um service deverah ser composto pelo p_id concatenado com o sv_id ligado por um _.
]]
function insert(web, p_id, sv_id, c_id, n_id, c_name, sw_name, sv_name, ip, display, display_name)
   local hst_name = p_id
   local svc_name = p_id.."_"..sv_id

   local cmd, hst, svc, dpl, chk, mon, chk_id, h, s
   local chk_name = config.monitor.check_host
   local msg = ""
   local content, counter, new_id

   h = objects:select_host(hst_name)

   ------------------------------------------------------
   -- cria check host e service ping caso nao exista
   ------------------------------------------------------
   if h[1] == nil then
      chk_id = objects:select_check_host()

      -- cria monitor sem a referencia do servico check_alive associado.
      cmd = insert_host_cfg_file (hst_name, hst_name, ip)
      new_id = monitors:insert_monitor(p_id, nil, -1, nil, 0, "hst")
      cmd = insert_service_cfg_file (hst_name, new_id, chk_name, chk_id)

      msg = msg.."Check do HOST: "..c_name.." para o IP "..ip.." criado. "..error_message(11)
   else
      msg = msg.."Check do HOST: "..c_name.." já existe! "
   end   


   ------------------------------------------------------
   -- cria o service check caso tenha sido requisitado
   ------------------------------------------------------
   if tonumber(sv_id) ~= 0 then
      local clause
      --chk = Model.query("nagios_objects", "object_id = "..display)
      chk = Model.query("nagios_objects", "name1 = '"..display.."'")
      if chk[1] then chk_name = chk[1].name1; chk_id = chk[1].object_id end

      dpl = web.input.display
      if dpl == "" or dpl == nil then 
         dpl = chk_name
      end

      -- cria monitor sem a referencia do servico associado.
      new_id = monitors:insert_monitor(p_id, sv_id, -1, dpl, 0, "svc")
      cmd = insert_service_cfg_file (hst_name, new_id, chk_name, chk_id)
      msg = msg.."Check de SERVIÇO: "..dpl.." - HOST: ".. c_name.." - COMANDO: "..chk_name.." criado."
   end

   if web then
      return web:redirect(web:link("/list/"..msg..""))
   else
      return msg --para criacao de probes em massa
   end

end
ITvision:dispatch_post(insert, "/insert/(%d+):(%d+):(%d+):(%d+):(.+):(.+):(.+):(.+):(.+):(.+)")



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function chkexec(web)
   local flags, opts = {}, {}
   local cmd = web.input.cmd
   local args = web.input.args
   local display = web.input["display"]
   local display_name = web.input["display_name"]
   local count = web.input["count"]

   for i = 1,count do
      flags[#flags+1] = web.input["flag"..i]
      opts[#opts+1]   = web.input["opt"..i]
   end

   return render_chkexec(web, cmd, count, flags, opts, args, display, display_name)
end
ITvision:dispatch_post(chkexec, "/chkexec")



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
      alias = v.m_display_name


      if v.p_itemtype then itemtype = v.p_itemtype else itemtype = "NetworkEquipment" end
      if v.p_ip then ip = v.p_ip else ip = v.n_ip end
      if v.c_id ~= 0 then id = v.c_id else id = v.n_id end


      if v.s_check_command_object_id == nil then 
         chk = ""
         if tonumber(v.m_service_object_id) == -1 then
            link = font{ color="orange", "Pendente" }
         else
            link = a{ href= web:link("/add/"..v[1]..":"..id..":"..v.p_id..":"..v.sv_id), strings.add }
         end
      else
         content = objects:select_checks(v.s_check_command_object_id)
         chk = content[1].name1
         link = "-"
      end


      web.prefix = "/servdesk"
      if itemtype == "Computer" then
         url = web:link("/front/computer.form.php?id="..id)
      elseif itemtype == "NetworkEquipment" then
         url = web:link("/front/networkequipment.form.php?id="..id)
      end

      if v.sw_name ~= "" then itemtype = "Service" end
      web.prefix = "/adm/probe"
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
function render_checkcmd_test(web, cur_cmd, name, ip, args_to_insert)
   local row, row_hidden, cmd, url = {}, {}, "", ""
   local readonly, text = "", ""
   local header = { strings.parameter.." #", strings.value, strings.description }
   local params = {}

   local c, p = Checkcmds.get_check_params(cur_cmd, false, false)
   local hidden = { 
      "<INPUT TYPE=HIDDEN NAME=\"cmd\" value=\""..c[1].command.."\">",
      "<INPUT TYPE=HIDDEN NAME=\"display_name\" value=\""..c[1].name1.."\">",
      "<INPUT TYPE=HIDDEN NAME=\"args\" value=\""..args_to_insert.."\">" ,
      "<INPUT TYPE=HIDDEN NAME=\"count\" value=\""..#p.."\">" 
   }
   local display = {
      { "Label", "<INPUT TYPE=TEXT NAME=\"display\" value=\""..c[1].name1.."\">", 
        "Nome alternativo para o comando a ser criado." }
   }
   local display_hidden = { "<INPUT TYPE=HIDDEN NAME=\"display\" value=\""..c[1].name1.."\">" }

   for i, v in ipairs(p) do
      if v.sequence == nil then readonly="readonly=\"readonly\"" else readonly="" end
      if v.variable == "$HOSTNAME$" then
         value = name
      elseif v.variable == "$HOSTADDRESS$" then
         value = ip
      else
         v.default_value = v.default_value or ""
         value = v.default_value
      end
      v.flag = v.flag or ""
      row[#row + 1] = { i,
         { "<INPUT TYPE=HIDDEN NAME=\"flag"..i.."\" value=\""..v.flag.."\">" ,
           "<INPUT TYPE=TEXT NAME=\"opt"..i.."\" value=\""..value.."\" "..readonly..">" }, v.description }
      row_hidden[#row_hidden + 1] = { 
         { "<INPUT TYPE=HIDDEN NAME=\"flag"..i.."\" value=\""..v.flag.."\">" ,
           "<INPUT TYPE=HIDDEN NAME=\"opt"..i.."\" value=\""..value.."\" "..readonly..">" } }
   end

   if c[1].name1 == config.monitor.check_host then
      params = {hidden, display_hidden, row_hidden}
      text = ""
   else
      params = {hidden, br(), render_table(display, nil), br(), render_table(row, header)}
      text = strings.parameter.."s do comando "..c[1].name1
   end

   res[#res+1] = center{ br(), text, br() }

   -- A IDEIA AQUI Eh COLOCAR A OPCAO DE CRIAR DIRETO O PROBE.
   --if c[1].name1 == config.monitor.check_host then
   --   res[#res+1] = iframe{name="check", src=web:link("/chkexec"), width="100%",  height="300", frameborder=0}
   --else
      res[#res+1] = center{ render_form(web:link("/chkexec"), nil, params, "check", strings.test, "check" ) }
   --end

   return res
end




------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_chkexec(web, cmd, count, flags, opts, args, display, display_name)
   local path = "/usr/lib/nagios/plugins"
   local chk = path.."/"..cmd.." "
   local res = {}
   local err = false

   for i = 1,count do
      if flags[i] == nil then flags[i] = "" end
      if opts[i]  == "" or opts[i] == nil then opts[i] = ""; err = true end
      chk = chk ..flags[i].." "..opts[i].." "
   end

   _, _, v.p_id, v.sv_id, v.c_id, v.n_id, hst_name, v.sw_name, v.sv_name, ip = 
                                string.find(args, "(%d+):(%d+):(%d+):(%d+):(.+):(.+):(.+):(.+)")

   if err == true then
      res[#res+1] = { br(), br(), strings.fillall }
   else
      local url = "/insert/"..args..":"..display..":"..display_name
      -- DEBUG: 
      res[#res+1] = { br(), args, " A ", display, " B", display_name, " C ", br() }
      res[#res+1] = { br(), br(), os.capture(chk, true) }
      res[#res+1] = { br(), render_form(web:link(url), web:link("/blank"), "", "", "Criar checagem" ) }
   end

   return render_layout(res)
end




------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function render_add(web, cmp, chk, params)
   local v = cmp[1]
   local row = {}
   local res = {}
   local serv, ip, itemtype, id, hst_name = "", "", "", "", nil
   local s, r, url
   local args_to_insert = ""

   params.default = params.default or chk[1].object_id
   local header = { strings.alias.."/"..strings.name, "IP", "SW / Versão", strings.type, strings.command }

   if v then
      if v.sw_name ~= nil then 
         serv = v.sw_name.." / "..v.sv_name
      else 
         v.sw_name, v.sv_name = no_software_code, no_software_code
      end

      v.c_id = v.c_id or 0; v.n_id = v.n_id or 0; v.p_id = v.p_id or 0; v.sv_id = v.sv_id or 0;

      if v.p_itemtype then itemtype = v.p_itemtype else itemtype = "NetworkEquipment" end
      if v.p_ip then ip = v.p_ip else ip = v.n_ip end

      hst_name = find_hostname(v.c_alias, v.c_name, v.c_itv_key)
      args_to_insert = v.p_id..":"..v.sv_id..":"..v.c_id..":"..v.n_id..":"..hst_name..":"..v.sw_name..":"..v.sv_name..":"..ip

      if v.sv_id == 0 then  -- entao nao eh service e sim um host ou um network
         local hl = objects:select(config.monitor.check_host, nil)
         params.default = hl[1].object_id
         chk = Checkcmds.select_checkcmds(params.default, false)
         cmd = { "<INPUT TYPE=HIDDEN NAME=\"check\" value=\""..params.default.."\">", config.monitor.check_host, " " }
      else
         url="/add/"..params.query..":"..params.c_id
         if params.p_id    then url = url ..":"..params.p_id    end
         if params.sv_id   then url = url ..":"..params.sv_id   end
         url=web:link(url)

         cmd = { select_option_onchange("check", chk, "object_id", "name1", params.default, url), " " }
      end

      row[#row + 1] = { hst_name, ip, serv, itemtype, cmd, }
   end

-- VER: http://stackoverflow.com/questions/942772/html-form-with-two-submit-buttons-and-two-target-attributes

   res[#res+1] = render_content_header("Checagem", nil, web:link("/list"))
   res[#res+1] = render_table(row, header)

   --if v.sv_id ~= 0 then 
      res[#res+1] = render_checkcmd_test(web, params.default, hst_name, ip, args_to_insert)
      res[#res+1] = iframe{name="check", src=web:link("/blank"), width="100%",  height="300", frameborder=0}
   --end

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


