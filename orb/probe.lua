#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
local no_software_code = "_no_software_code_"

require "util"
require "monitor_util"
require "View"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

--[[
local hosts    = Model.nagios:model "hosts"
local services = Model.nagios:model "services"
]]
local objects  = Model.nagios:model "objects"
local monitor  = Model.itvision:model "monitor"


-- models ------------------------------------------------------------


--[[
function hosts:select_host(h_name)
   local clause = ""
   if h_name then
      clause = " display_name = '"..h_name.."' "
   end

   return Model.query("nagios_hosts", clause)
end


function services:select_service(h_id)
   local clause = ""
   if h_id then
      clause = " host_object_id = "..h_id.." and display_name = \"PING\" "
   end

   return Model.query("nagios_services", clause)
end
]]

function objects:select(name1, name2)
   local clause = ""
   if name1 ~= nil then
      clause = " name1 = '"..name1
   end
   if name2 ~= nil then
      clause = clause.."' and name2 = '"..name2.."' "
   else
      clause = clause.."' and name2 is NULL "
   end
   clause = clause.." and is_active = 1 "

   return Model.query("nagios_objects", clause)
end


function objects:select_checks(cmd)
   local clause = ""
   if cmd then
      clause = " object_id = '"..cmd.."' "
   end

   return Model.query("nagios_objects", clause)
end


function monitor:insert_monitor(networkports, softwareversions, host_object, service_object, is_active, type_)
      local mon = { 
         networkports_id = networkports,
         softwareversions_id = softwareversions,
         host_object_id = host_object,
         service_object_id = service_object,
         is_active = is_active,
         type = type_,
      }
      Model.insert("itvision_monitor", mon)
end


-- controllers ------------------------------------------------------------

function list(web, msg)
   local clause = ""
   if web.input.hostname  then clause = clause.." and c.name like '%"..web.input.hostname.."%' " end
   if web.input.inventory then clause = clause.." and c.otherserial like '%"..web.input.inventory.."%' " end
   if web.input.sn        then clause = clause.." and c.serial like '%"..web.input.sn.."%' " end

   local cmp = Model.select_monitors(clause)
   local chk = Model.select_checkcmds()

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


function add(web, query, c_id, n_id, sv_id)
   local chk = Model.select_checkcmds()
   local cmp = {}

   query = tonumber(query)

   if query == 1 then
      cmp = Model.query_1(c_id, n_id)
   elseif query == 2 then
      cmp = Model.query_2(c_id, n_id, sv_id)
   elseif query == 3 then
      cmp = Model.query_3(c_id, n_id)
   elseif query == 4 then
      cmp = Model.query_4(c_id, n_id, sv_id)
   elseif query == 5 then
      cmp = Model.query_5(c_id, n_id)
   elseif query == 6 then
      cmp = Model.query_6(c_id, n_id)
   end

   return render_add(web, cmp, chk, query, default)
end
ITvision:dispatch_get(add, "/add/(%d+):(%d+):(%d+):(%d+)")


--[[
   insert()

   sv_id == 0 significa que entrada nao possui software associado e eh somente uma maquina
   s_name e sv_name == no_software_code entao os nomes sao nulos e isto é um host e nao um service
]]
function insert(web, n_id, sv_id, c_id, c_name, s_name, sv_name, ip)
   -- hostname passa aqui a ser uma composicao do proprio hostname com o ip a ser monitorado
   local hostname = string.gsub(string.gsub(c_name,"(%p+)"," ").."-"..ip,"(%s+)","_")
   local software = string.gsub(string.gsub(s_name.." "..sv_name,"(%p+)"," "),"(%s+)","_")
   local cmd, hst, svc, dpl, chk, h, s
   local msg = ""
   local content
   local counter

   h = objects:select(hostname)


   ------------------------------------------------------
   -- cria check host e service ping caso nao exista
   ------------------------------------------------------
   if h[1] == nil then
      cmd = insert_host_cfg_file (hostname, c_name, ip)
      cmd = insert_service_cfg_file (hostname, "PING", config.monitor.check_ping)
      h = objects:select(hostname)
      -- caso host ainda nao tenha sido incluido aguarde e tente novamente
      counter = 0
      while h[1] == nil do
         counter = counter + 1
         for i = 1,loop do x = i/2 end -- aguarde...
         h = objects:select(hostname)
      end
      -- DEBUG: text_file_writer ("/tmp/1", "Counter: "..counter.."\n")
      hst = h[1].object_id
      s = objects:select(hostname, "PING")
      -- caso service ainda nao tenha sido incluido aguarde e tente novamente
      counter = 0
      while s[1] == nil do
         counter = counter + 1
         for i = 1,loop do x = i/2 end -- aguarde...
         s = objects:select(hostname, "PING")
      end
      -- DEBUG: text_file_writer ("/tmp/2", "Counter: "..counter.."\n")
      svc = s[1].object_id
      monitor:insert_monitor(n_id, nil, hst, svc, 1, "hst")
      msg = msg.."Check do HOST: "..c_name.." para o IP "..ip.." criado. "
      -- DEBUG:         .." (hst,svc) = ("..hst..","..svc..") "
   else
      hst = h[1].object_id
      msg = msg.."Check do HOST: "..c_name.." já existe! "
   end   

   h = objects:select(hostname)
   counter = 0
   while h[1] == nil do
      counter = counter + 1
      for i = 1,loop do x = i/2 end -- aguarde...
      h = objects:select(hostname)
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
         clause = "name1 = '"..config.monitor.check_ping.."'"
      else
         clause = "object_id = "..web.input.check
      end
      chk = Model.query("nagios_objects", clause)
      if chk[1] then chk = chk[1].name1 end

      dpl = string.gsub(string.gsub(web.input.display,"(%p+)","_")," ","_")
      if dpl == "" then 
         dpl = software
      end
      cmd = insert_service_cfg_file (hostname, dpl, chk)
      s = objects:select(hostname, dpl)

      -- caso service ainda nao tenha sido incluido aguarde e tente novamente
      counter = 0
      while s[1] == nil do
         counter = counter + 1
         for i = 1,loop do x = i/2 end -- aguarde...
         s = objects:select(hostname, dpl)
      end
      -- DEBUG: text_file_writer ("/tmp/4", "Counter: "..counter.."\n")

      if s[1] == nil then 
         msg = msg..error_message(12)
      else
         svc = s[1].object_id
         monitor:insert_monitor(n_id, sv_id, hst, svc, 1, "svc")
         msg = msg.."Check do SERVIÇO: "..dpl.." HOST: ".. c_name.." COMANDO: "..chk.." criado. "
         -- DEBUG:       .." (hst,svc) = ("..hst..","..svc..") "
         -- DEBUG: msg = msg.." ||| serviceobjid"..svc.." ||| " 
      end
   end

   return web:redirect(web:link("/list/"..msg..""))
end
ITvision:dispatch_post(insert, "/insert/(%d+):(%d+):(%d+):(.+):(.+):(.+):(.+)")


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
   
   local header =  { "query", strings.name, "IP", "Software / Versão", strings.type, strings.command, "." }
   --local header =  { strings.name, "IP", "Software / Versão", strings.type, strings.command, "." }

   for i, v in ipairs(cmp) do
      local serv = ""
      if v.s_name ~= "" then serv = v.s_name.." / "..v.sv_name end
      if v.sv_id == "" then v.sv_id = 0 end
      if v.svc_check_command_object_id == "" then 
         chk = ""
         link = a{ href= web:link("/add/"..v[1]..":"..v.c_id..":"..v.n_id..":"..v.sv_id), strings.add }
      else
         content = objects:select_checks(v.svc_check_command_object_id)
         chk = content[1].name1
         link = "-"
      end
      row[#row + 1] = { 
         v[1],
         a{ href= web:link("/add/"..v.c_id), v.c_name}, 
         v.n_ip, 
         serv,
         v.n_itemtype,
         chk,
         link }
   end

   res[#res+1] = render_content_header("Checagem", web:link("/add"), web:link("/list"))
   if msg ~= "/" and msg ~= "/list" and msg ~= "/list/" then res[#res+1] = p{ msg } end
   res[#res+1] = render_form_bar( render_filter(web), strings.search, web:link("/list"), web:link("/list") )
   res[#res+1] = render_table(row, header)

   return render_layout(res)
end


function render_confirm(web, msg)
   local res = {}

   res[#res+1] = p{ "SHOW", br(), msg }

   return render_layout(res)
end


function render_add(web, cmp, chk, query, default)
   local v = cmp[1]
   local row = {}
   local res = {}
   local serv = ""
   local s, r
   local display = ""

   default = default or v.svc_check_command_object_id

   local header = { "query", strings.name, "IP", "SW / Versão", strings.type, strings.command }

   if v then
      if v.s_name ~= "" then 
         serv = v.s_name.." / "..v.sv_name
      else 
         v.s_name = no_software_code; v.sv_name = no_software_code
      end

      if v.sv_id == "" then v.sv_id = 0 end
      url = "/insert/"..v.n_id..":"..v.sv_id..":"..v.c_id..":"..v.c_name..":"..v.s_name..":"
            ..v.sv_name..":"..v.n_ip

      -- se sv_id == 0 entao eh um host
      if v.sv_id == 0 then 
         cmd = render_form(web:link(url), 
               { "<INPUT TYPE=HIDDEN NAME=\"check\" value=\"0\">", config.monitor.check_ping, " " } )
      else
         cmd = render_form(web:link(url), 
               { "Nome:", "<INPUT TYPE=TEXT NAME=\"display\" value=\""..display.."\">", 
               select_option("check", chk, "object_id", "name1", default), " " } )
      end

      --a{ href= web:link("/show/"..v.c_id), v.c_name}, 
      row[#row + 1] = { 
         v[1],
         v.c_name,
         v.n_ip, 
         serv,
         v.n_itemtype,
         cmd,
      }
   end

   res[#res+1] = render_content_header("Checagem", web:link("/add"), web:link("/list"))
   res[#res+1] = render_table(row, header)

   for _,c in ipairs(chk) do
      if c.object_id == default then
         --s = config.monitor.dir.."/libexec/"..c.name1.." -H "..v.n_ip.." "
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


