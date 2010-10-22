#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "monitor_util"
require "View"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local hosts   = Model.nagios:model "hosts"
local objects = Model.nagios:model "objects"
local monitor = Model.itvision:model "monitor"

-- models ------------------------------------------------------------


function hosts:select_host(h_name)
   local clause = ""
   if h_name then
      clause = " alias = '"..h_name.."' "
   end

   return Model.query("nagios_hosts", clause)
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

function list(web)
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
   s_name e sv_name == "lkjh" entao os nomes sao nulos e isto é um host e nao um service
]]
function insert(web, n_id, sv_id, c_id, c_name, s_name, sv_name, ip)
   c_name = string.gsub(c_name," ", "_")
   s_name = string.gsub(s_name," ", "_")
   sv_name = string.gsub(sv_name," ", "_")

   local h = hosts:select_host(c_name)
   local dpl = ""
   local chk = ""
   local msg = ""

   -- cria check host e service ping caso nao exista
   if h[1] == nil then
      res, hst, os = insert_host_cfg_file (c_name, c_name, ip)
      res, svc, os = insert_service_cfg_file ("PING", c_name, 0)
      monitor:insert_monitor(n_id, nil, hst, svc, 1, "hst")
      msg = msg.."Check do HOST: "..c_name.." para o IP "..ip.." criado. " --" (hst,svc) = ("..hst..","..svc..") "
   else
      hst = h[1].host_object_id
      msg = msg.."Check do HOST: "..c_name.." já existe! "
   end   

   -- cria outro service check 
   if tonumber(sv_id) ~= 0 then
      chk = web.input.check
      dpl = web.input.display
      dpl = dpl or chk
      dpl = string.gsub(dpl," ", "_")
      res, svc, os = insert_service_cfg_file (dpl, c_name, chk)
      monitor:insert_monitor(n_id, sv_id, hst, svc, 1, "svc")
      msg = msg.."Check do SERVIÇO: "..dpl.." HOST: ".. c_name.." COMANDO: "..chk.." criado. "--" (hst,svc) = ("..hst..","..svc..") "
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
   
   --local header =  { "query", strings.name, "IP", "Software / Versão", strings.type, strings.command, "." }
   local header =  { strings.name, "IP", "Software / Versão", strings.type, strings.command, "." }

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
         --v[1], QUERY para debug
      row[#row + 1] = { 
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

   local header =  { "query", strings.name, "IP", "SW / Versão", strings.type, strings.command }

   if v then
      if v.s_name ~= "" then 
         serv = v.s_name.." / "..v.sv_name
      else 
         v.s_name = "lkjh"; v.sv_name = "lkjh"
      end
      if v.sv_id == "" then v.sv_id = 0 end
      url = "/insert/"..v.n_id..":"..v.sv_id..":"..v.c_id..":"..v.c_name..":"..v.s_name..":"..v.sv_name..":"..v.n_ip

      if v.sv_id == 0 then 
         cmd = render_form(web:link(url), { "<INPUT TYPE=HIDDEN NAME=\"check\" value=\"0\">", "host-alive", " " } )
      else
         cmd = render_form(web:link(url), { "Nome:", "<INPUT TYPE=TEXT NAME=\"display\" value=\""..display.."\">", 
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
         s = config.monitor.dir.."/libexec/"..c.name1.." -H "..v.n_ip.." "
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


