#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "monitor_util"
require "View"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local app        = Model.itvision:model "app"
local app_object = Model.itvision:model "app_object"
local hosts      = Model.nagios:model "hosts"
local services   = Model.nagios:model "services"
local computers  = Model.glpi:model "computers"

-- models ------------------------------------------------------------

function computers:select_computers(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
end


function computers:select_ci_ports(itemtype)
   return Model.select_ci_ports(itemtype)
end


function computers:select_computers_ports(id)
   local clause = ""
   if id then
      clause = "ic.id = "..id
   end
   return Model.select_ci_ports("Computer", clause)
end


-- controllers ------------------------------------------------------------

function list(web)
   local cmp = Model.select_monitors()
   local chk = Model.select_checkcmds()
   return render_list(web, cmp, chk)
end
ITvision:dispatch_get(list, "/", "/list")


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

   local default = web.input.check

   return render_add(web, cmp, chk, query, default)
end
ITvision:dispatch_get(add, "/add/(%d+):(%d+):(%d+):(%d+)")
ITvision:dispatch_post(add, "/add/(%d+):(%d+):(%d+):(%d+)")


function insert(web)
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_post(insert, "/insert")


function remove(web, id)
   return render_remove(web, id)
end
ITvision:dispatch_get(remove, "/remove/(%d+)")


function delete(web, id)
   return web:redirect(web:link("/list"))
end
ITvision:dispatch_get(delete, "/delete/(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, cmp, chk)
   local row = {}
   local res = {}
   
   local header =  { "query", strings.name, "IP", "SW / Versão", strings.type, strings.command, "." }

   for i, v in ipairs(cmp) do
      local serv = ""
      if v.s_name ~= "" then serv = v.s_name.." / "..v.sv_name end
      if v.sv_id == "" then v.sv_id = 0 end
      row[#row + 1] = { 
         v[1],
         a{ href= web:link("/add/"..v.c_id), v.c_name}, 
         v.n_ip, 
         serv,
         v.n_itemtype,
         v.svc_check_command_object_id,
         a{ href= web:link("/add/"..v[1]..":"..v.c_id..":"..v.n_id..":"..v.sv_id), strings.add} }
   end

   res[#res+1] = render_content_header("Checagem", web:link("/add"), web:link("/list"))
   res[#res+1] = render_table(row, header)

   return render_layout(res)
end

function render_show(web)
   -- VAZIO
end

function render_add(web, cmp, chk, query, default)
   local v = cmp[1]
   local row = {}
   local res = {}
   local serv = ""
   local s, r

   default = default or v.svc_check_command_object_id

   local header =  { "query", strings.name, "IP", "SW / Versão", strings.type, strings.command }

   if v then
      if v.s_name ~= "" then serv = v.s_name.." / "..v.sv_name end
      if v.sv_id == "" then v.sv_id = 0 end
      url = "/add/"..query..":"..v.c_id..":"..v.n_id..":"..v.sv_id
      row[#row + 1] = { 
         v[1],
         a{ href= web:link("/show/"..v.c_id), v.c_name}, 
         v.n_ip, 
         serv,
         v.n_itemtype,
         render_form(web:link(url), { select_option("check", chk, "object_id", "name1", default), " " } )
      }
   end

   res[#res+1] = render_content_header("Checagem", web:link("/add"), web:link("/list"))
   res[#res+1] = render_table(row, header)

   for _,c in ipairs(chk) do
      if c.object_id == default then
         s = config.monitor_dir.."/libexec/"..c.name1.." -H "..v.n_ip.." -p 24"
         r = os.capture(s)
      end
   end

   res[#res+1] = p{ "| ", default, " | ", s, " | ", r }

   return render_layout(res)
end


function render_remove(web)
   -- VAZIO
end


orbit.htmlify(ITvision, "render_.+")

return _M


