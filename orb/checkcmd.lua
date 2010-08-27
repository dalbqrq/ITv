#!/usr/bin/env wsapi.cgi

-- configs ------------------------------------------------------------

require "orbit"
require "config"
require "util"
require "view_utils"


-- config direct access to db
--local ma = require "model_access"
--local mr = require "model_rules"


-- config ITVISION mvc app
module("itvision", package.seeall, orbit.new)
mapper.conn, mapper.driver = config.setup_orbdb()
--local apps = itvision:model "apps"


-- config NAGIOS mvc app
--nagios = orbit.new()
--nagios.mapper.conn, nagios.mapper.driver = config.setup_orbdb()
--nagios.mapper.table_prefix = 'nagios_'
--local services = nagios:model "services"


-- models ------------------------------------------------------------

--[[
function apps:select_apps(id)
   local clause = ""
   if id then
      clause = "app_id = "..id
   end
   return self:find_all(clause)
end
]]

-- controllers ------------------------------------------------------------

function list(web)
   return render_list(web)
end
itvision:dispatch_get(list, "/", "/list")


function chkexec(web)
   return render_chkexec(web, web.input.cmd, web.input.opts)
end
itvision:dispatch_post(chkexec, "/chkexec")


itvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web)
   local res = {}
   local chk = {}
   local path = "/usr/local/monitor/libexec"
   local url = "/chkexec"

   for file in lfs.dir(path) do
      if string.find(file, "check_", 1) then
         chk[#chk + 1] = { name = file }
      end
   end

   res[#res + 1] = form{
      name = "input",
      method = "post",
      action = web:link(url),

      strings.command..": ", select_option("cmd", chk, "name", "name"), br(),
      textarea{ name="opts", cols="100", rows="5", size="500", nil }, br(),

      p{ button_form(strings.send, "submit", "positive") },
      p{ button_form(strings.reset, "reset", "negative") },
   }

   return render_layout(res)
end


function render_chkexec(web, cmd, opts)
   local path = "/usr/local/monitor/libexec"
   cmd = cmd or "check_ping"
   if not opts or opts == "" then opts = "-h" end
   local chk = cmd.." "..opts
   local res = {}

   res[#res+1] = p{ chk }, br{}, br{}
   res[#res+1] = p{ os.capture(path.."/"..chk, true) }, br(), br()
   res[#res+1] = p{ button_link("Exec", web:link("/list")) }

   return render_layout(res)
end


orbit.htmlify(itvision, "render_.+")

return _M


