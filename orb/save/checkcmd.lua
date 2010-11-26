#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "util"
require "View"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------


-- controllers ------------------------------------------------------------

function list(web)
   return render_list(web)
end
ITvision:dispatch_get(list, "/", "/list")


function chkexec(web)
   return render_chkexec(web, web.input.cmd, web.input.opts)
end
ITvision:dispatch_post(chkexec, "/chkexec")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web)
   local res = {}
   local chk = {}
   local path = "/usr/lib/nagios/plugins"
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
   local path = "/usr/lib/nagios/plugins"
   cmd = cmd or "check_ping"
   if not opts or opts == "" then opts = "-h" end
   local chk = cmd.." "..opts
   local res = {}

   res[#res+1] = p{ chk }, br{}, br{}
   res[#res+1] = p{ os.capture(path.."/"..chk, true) }, br(), br()
   res[#res+1] = p{ button_link("Exec", web:link("/list")) }

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


