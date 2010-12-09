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
      clause = " name1 = '"..name1
   else
      clause = " name1 like '"..config.monitor.check_app.."%' "
   end

   if name2 ~= nil then
      clause = clause.."' and name2 = '"..name2.."' "
   else
      clause = clause.."' and name2 is NULL "
   end
   clause = clause .. " and is_active = 1"

   return Model.query("nagios_objects", clause)
end


function objects:select_checks(cmd)
   local clause = ""
   if cmd then
      clause = " object_id = '"..cmd.."' "
   end

   return Model.query("nagios_objects", clause)
end


function monitors:insert_monitor(networkport, softwareversion, networkequipment, service_object, is_active, type_)
   if tonumber(networkport)      == 0 then networkport      = nil end         
   if tonumber(softwareversion)  == 0 then softwareversion  = nil end         
   if tonumber(networkequipment) == 0 then networkequipment = nil end         

   local mon = { 
      instance_id = Model.db.instance_id,
      entities_id = 0,
      service_object_id    = service_object,
      networkports_id      = networkport,
      softwareversions_id  = softwareversion,
      networkequipments_id = networkequipment,
      is_active = is_active,
      type = type_,
   }
   Model.insert("itvision_monitors", mon)
end


-- controllers ------------------------------------------------------------

function list(web, msg)
   local clause = nil
   if web.input.hostname  then clause = "c.name like '%"..web.input.hostname.."%' " end
   if web.input.inventory then 
      local a = ""
      if clause then a = " and " end
      clause = clause..a.."c.otherserial like '%"..web.input.inventory.."%' "
   end
   if web.input.sn then 
      local a = ""
      if clause then a = " and " end
      clause = clause..a.."c.serial like '%"..web.input.sn.."%' "
   end

   local cmp = Monitor.select_monitors(clause)
   local chk = Checkcmds.select_checkcmds()

   return render_list(web, cmp, chk, msg)
end
ITvision:dispatch_get(list, "/", "/list", "/list/(.+)")
ITvision:dispatch_post(list, "/list")


--[[
function show(web, id)
   return render_show(web, id)
end 
ITvision:dispatch_get(show, "/show/(%d+)")


function edit(web, id)
   return render_add(web, id)
end
ITvision:dispatch_get(edit, "/edit/(%d+)")


function update(web, id)
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_post(update, "/update/(%d+)")
]]


function add(web, query, c_id, p_id, sv_id, default)
   local chk = Checkcmds.select_checkcmds(nil, true)
-- get_allcheck_params()
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


--[[
   insert()

   sv_id == 0 significa que entrada nao possui software associado e eh somente uma maquina
   sw_name e sv_name == no_software_code entao os nomes sao nulos e isto é um host e nao um service
]]
function insert(web, p_id, sv_id, c_id, n_id, c_name, sw_name, sv_name, ip)
   -- hostname passa aqui a ser uma composicao do proprio hostname com o ip a ser monitorado
   local hostname = string.gsub(string.toid(c_name).."-"..ip,"(%s+)","_")
   local software = string.toid(sw_name.." "..sv_name)
   local cmd, hst, svc, dpl, chk, chk_name, chk_id, h, s
   local msg = ""
   local content, counter

   h = objects:select(hostname)

   ------------------------------------------------------
   -- cria check host e service ping caso nao exista
   ------------------------------------------------------
   if h[1] == nil then
      chk = Model.query("nagios_objects", "name1 = '"..config.monitor.check_host.."'")
      if chk[1] then chk_name = chk[1].name1; chk_id = chk[1].object_id end

      cmd = insert_host_cfg_file (hostname, c_name, ip)
      cmd = insert_service_cfg_file (hostname, config.monitor.check_host, config.monitor.check_host, chk_id, false)
      h = objects:select(hostname)
      -- caso host ainda nao tenha sido incluido aguarde e tente novamente
      counter = 0
      while h[1] == nil do
         counter = counter + 1
         os.sleep(1)
         h = objects:select(hostname)
      end
      --text_file_writer("/tmp/contour_insert_h", tostring(counter))
      -- DEBUG: text_file_writer ("/tmp/1", "Counter: "..counter.."\n")
      s = objects:select(hostname, config.monitor.check_host)
      -- caso service ainda nao tenha sido incluido aguarde e tente novamente
      counter = 0
      while s[1] == nil do
         counter = counter + 1
         os.sleep(1)
         s = objects:select(hostname, config.monitor.check_host)
      end
      --text_file_writer("/tmp/contour_insert_ha", tostring(counter))
      -- DEBUG: text_file_writer ("/tmp/2", "Counter: "..counter.."\n")
      svc = s[1].object_id
      monitors:insert_monitor(p_id, nil, n_id, svc, 1, "hst")
      msg = msg.."Check do HOST: "..c_name.." para o IP "..ip.." criado. "
      -- DEBUG:         .." (hst,svc) = ("..hst..","..svc..") "
   else
      msg = msg.."Check do HOST: "..c_name.." já existe! "
   end   

   -- DEBUG: text_file_writer ("/tmp/3", "Counter: "..counter.."\n")
   if h[1] == nil then 
      msg = msg..error_message(11)
   else
      -- DEBUG: msg = msg.." ||| hostobjid"..hst.." ||| "
      hst = h[1].object_id
   end


   ------------------------------------------------------
   -- cria o service check caso tenha sido requisitado
   ------------------------------------------------------
   if tonumber(sv_id) ~= 0 then
      local clause

      if web.input.check == 0 then
         clause = "name1 = '"..config.monitor.check_host.."'"
      else
         clause = "object_id = "..web.input.check
      end
      chk = Model.query("nagios_objects", clause)
      -- DEBUG: text_file_writer ("/tmp/4", "clause: "..clause.."\n")
      if chk[1] then chk_name = chk[1].name1; chk_id = chk[1].object_id end

      dpl = string.toid(web.input.display)
      if dpl == "" then 
         dpl = software
      end
      -- DEBUG: text_file_writer ("/tmp/5", "chk_name: "..chk_name.."\n".."chk_id: "..chk_id)
      cmd = insert_service_cfg_file (hostname, dpl, chk_name, chk_id, true)
      s = objects:select(hostname, dpl)

      -- caso service ainda nao tenha sido incluido aguarde e tente novamente
      counter = 0
      while s[1] == nil do
         counter = counter + 1
         os.sleep(1)
         s = objects:select(hostname, dpl)
      end
      text_file_writer("/tmp/contour_insert_s", tostring(counter))
      -- DEBUG: text_file_writer ("/tmp/6", "Counter: "..counter.."\n")

      if s[1] == nil then 
         msg = msg..error_message(12)
      else
         svc = s[1].object_id
         monitors:insert_monitor(p_id, sv_id, n_id, svc, 1, "svc")
         msg = msg.."Check do SERVIÇO: "..dpl.." HOST: ".. c_name.." COMANDO: "..chk_name.." criado. "
         -- DEBUG:       .." (hst,svc) = ("..hst..","..svc..") "
         -- DEBUG: msg = msg.." ||| serviceobjid"..svc.." ||| " 
      end
   end

   os.reset_monitor() -- isto estah aqui pois as vezes o probe nao aparece na lista mesmo que itvivion_monitor
                      -- e nagios_objects tenham sido criados

   if web then
      return web:redirect(web:link("/list/"..msg..""))
   else
      return msg --para criacao de probes em massa
   end
end
ITvision:dispatch_post(insert, "/insert/(%d+):(%d+):(%d+):(%d+):(.+):(.+):(.+):(.+)")

--[[
function remove(web, id)
   return render_remove(web, id)
end
ITvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_get(delete, "/delete/(%d+)")
]]


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_filter(web)
   local res = {}

   res[#res+1] = {strings.name..": ", input{ type="text", name="hostname", value = "" }, " "}
   res[#res+1] = {strings.inventory..": ", input{ type="text", name="inventory", value = "" }, " "}
   res[#res+1] = {strings.sn..": ", input{ type="text", name="sn", value = "" }, " "}

   return res
end


function render_list(web, cmp, chk, msg)
   local row = {}
   local res = {}
   local link = {}
   
   -- DEBUG: local header =  { "query", strings.name, "IP", "Software / Versão", strings.type, strings.command, "." }
   local header =  { strings.name, "IP", "Software / Versão", strings.type, strings.command, "." }

   for i, v in ipairs(cmp) do
      local serv, ip, itemtype, name, id = "", "", "", "", ""

      if v.sw_name ~= "" then serv = v.sw_name.." / "..v.sv_name end

      -- muitos dos ifs abaixo existem em funcao da direrenca entre as queries com Computer e as com Network
      v.c_id = v.c_id or 0
      v.n_id = v.n_id or 0
      v.p_id = v.p_id or 0
      v.sv_id = v.sv_id or 0
      if v.p_itemtype then itemtype = v.p_itemtype else itemtype = "NetworkEquipment" end
      if v.p_ip then ip = v.p_ip else ip = v.n_ip end
      if v.c_name then name = v.c_name else name = v.n_name end

      if v.c_id ~= 0 then id = v.c_id else id = v.n_id end

      if v.s_check_command_object_id == nil then 
         chk = ""
         link = a{ href= web:link("/add/"..v[1]..":"..id..":"..v.p_id..":"..v.sv_id), strings.add }
      else
         content = objects:select_checks(v.s_check_command_object_id)
         chk = content[1].name1
         link = "-"
      end

         -- DEBUG v[1] é o numero da query_?: v[1],
--[[
web.prefix = "/"
if itemtype == "Computer" then
/servdesk/front/computer.form.php?id=
elseif itemtype == "NetworkEquipment" then
/servdesk/front/computer.form.php?id=
else
end
]]
 
      row[#row + 1] = { 
         a{ href= web:link("/add/"..id), name}, 
         ip, 
         serv,
         itemtype,
         chk,
         link }
   end

   res[#res+1] = render_content_header("Checagem", nil, web:link("/list"))
   if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ msg } end
   res[#res+1] = render_form_bar( render_filter(web), strings.search, web:link("/list"), web:link("/list") )
   res[#res+1] = render_table(row, header)

   return render_layout(res)
end


function render_confirm(web, msg)
   local res = p{ "SHOW", br(), msg }
   return render_layout(res)
end


function render_checkcmd_test(web, cur_cmd, name, ip)
   local row, cmd, url = {}, "", ""
   local c, p
   local readonly = ""
   local hidden = {}
   local header = { strings.parameter.." #", strings.value, strings.description }

   web.prefix = "/orb/checkcmd"
   c, p = get_allcheck_params(cur_cmd)
   url = web:link("")

   hidden = { 
      "<INPUT TYPE=HIDDEN NAME=\"cmd\" value=\""..c[1].command.."\">",
      "<INPUT TYPE=HIDDEN NAME=\"count\" value=\""..#p.."\">" 
   }

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
      row[#row + 1] = { 
         i,
         { "<INPUT TYPE=HIDDEN NAME=\"flag"..i.."\" value=\""..v.flag.."\">" ,
           "<INPUT TYPE=TEXT NAME=\"opt"..i.."\" value=\""..value.."\" "..readonly..">" },
         v.description 
      }
   end

   res[#res+1] = center{ br(), br(), strings.parameter.."s do comando "..c[1].name1, br() }
   res[#res+1] = center{ render_form(web:link(url), nil, {hidden, render_table(row, header)}, "check", strings.test, "check" ) }

   return res
end


function render_add(web, cmp, chk, params)
   local v = cmp[1]
   local row = {}
   local res = {}
   local serv, ip, itemtype, name, id = "", "", "", "", ""
   local s, r, url, url2
   local display = ""

   params.default = params.default or chk[1].object_id

   --local header = { "query", strings.name, "IP", "SW / Versão", strings.type, strings.command }
   local header = { strings.name, "IP", "SW / Versão", strings.type, strings.command }

   if v then
      if v.sw_name ~= nil then 
         serv = v.sw_name.." / "..v.sv_name
      else 
         v.sw_name, v.sv_name = no_software_code, no_software_code
      end

      v.c_id = v.c_id or 0
      v.n_id = v.n_id or 0
      v.p_id = v.p_id or 0
      v.sv_id = v.sv_id or 0
      if v.p_itemtype then itemtype = v.p_itemtype else itemtype = "NetworkEquipment" end
      if v.p_ip then ip = v.p_ip else ip = v.n_ip end
      if v.c_name then name = v.c_name else name = v.n_name end

      url = "/insert/"..v.p_id..":"..v.sv_id..":"..v.c_id..":"..v.n_id..":"..name..":"..v.sw_name..":"..v.sv_name..":"..ip

      -- se sv_id == 0 entao eh um host ou um network
      if v.sv_id == 0 then 
         cmd = render_form(web:link(url), nil,
               { "<INPUT TYPE=HIDDEN NAME=\"check\" value=\"0\">", config.monitor.check_host, " " } )
      else
         url2="/add/"..params.query..":"..params.c_id
         if params.p_id    then url2 = url2 ..":"..params.p_id    end
         if params.sv_id   then url2 = url2 ..":"..params.sv_id   end
         --if params.default then url2 = url2 ..":"..params.default end
         url2=web:link(url2)

         cmd = render_form(web:link(url), nil,
               { "Nome:", "<INPUT TYPE=TEXT NAME=\"display\" value=\""..display.."\">", 
               --select_option("check", chk, "object_id", "name1", params.default), " " } )
               select_option_onchange("check", chk, "object_id", "name1", params.default, url2), " " } )
      end

         --a{ href= web:link("/show/"..v.c_id), v.c_name}, 
         --v[1],
      row[#row + 1] = { 
         name,
         ip, 
         serv,
         itemtype,
         cmd,
      }
   end

--[[
   if v.sv_id ~= 0 then 
      row[#row + 1] = { colspan=6, text=render_checkcmd_test(web, params.default, name, ip) } 
   end
]]

-- VER: http://stackoverflow.com/questions/942772/html-form-with-two-submit-buttons-and-two-target-attributes

   res[#res+1] = render_content_header("Checagem", nil, web:link("/list"))
   res[#res+1] = render_table(row, header)

   if v.sv_id ~= 0 then 
      res[#res+1] = render_checkcmd_test(web, params.default, name, ip)
      res[#res+1] = iframe{name="check", src=web:link("/blank"), width="100%",  height="300", frameborder=0}
   end


   for _,c in ipairs(chk) do
      if c.object_id == default then
         --s = config.monitor.dir.."/libexec/"..c.name1.." -H "..v.p_ip.." "
         --r = os.capture(s)
      end
   end

   -- DEBUG res[#res+1] = p{ "| ", default, " | ", s, " | ", r }

   return render_layout(res)
end


function render_remove(web)
   -- VAZIO
end


orbit.htmlify(ITvision, "render_.+")

return _M


