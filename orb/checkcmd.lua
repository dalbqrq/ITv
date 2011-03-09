#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "Auth"
require "View"
require "util"
require "monitor_util"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------


-- controllers ------------------------------------------------------------

function blank(web)
   return render_blank(web)
end
ITvision:dispatch_get(blank, "/blank")


function chkexec(web)
   local flags, opts = {}, {}
   local cmd = web.input.cmd
   --local count = web.input.count
   local count = web.input["count"]

   for i = 1,count do
      flags[#flags+1] = web.input["flag"..i]
      opts[#opts+1]   = web.input["opt"..i]
   end

   return render_chkexec(web, cmd, count, flags, opts)
end
ITvision:dispatch_post(chkexec, "/")


function chktest(web, cmd, opts)
   return render_chktest(web, cmd, opts)
end
ITvision:dispatch_get(chktest, "/test/(.+):(.+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function render_chkexec(web, cmd, count, flags, opts)
   local permission = Auth.check_permission(web, "checkcmds", true)
   local path = "/usr/lib/nagios/plugins"
   local chk = path.."/"..cmd.." "
   local res = {}
   local err = false
   
   for i = 1,count do
      if flags[i] == nil then flags[i] = "" end
      --if opts[i] == nil then opts[i] = "opt"..i end
      if opts[i] == "" or opts[i] == nil then opts[i] = ""; err = true end
      chk = chk ..flags[i].." "..opts[i].." "
   end
 
   if err == true then
      res[#res+1] = { br(), br(), strings.fillall }
   else
      res[#res+1] = { br(), br(), os.capture(chk, true) }
   end

   return render_layout(res)
end


function render_chktest(web, cmd, opts)
   local permission = Auth.check_permission(web, "checkcmds", true)
   local path = "/usr/lib/nagios/plugins"
   local chk = path.."/"..cmd.." "
   local res = {}
   local err = false
   
   opts = string.gsub(opts,"!", " ")
 
   if err == true then
      res[#res+1] = { br(), br(), strings.fillall }
   else
      res[#res+1] = { br(), br(), os.capture(chk.." "..opts, true) }
   end

   return render_layout(res)
end


function render_blank(web)
   return render_layout()
end


orbit.htmlify(ITvision, "render_.+")

return _M


