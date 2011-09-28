#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "View"
require "util"

module(Model.name, package.seeall,orbit.new)

local sysconfig = Model.itvision:model "sysconfig"


-- models ------------------------------------------------------------


function sysconfig:select_sysconfig(id)
   local clause = ""
   if id then
      clause = "id = "..id
   end
   return self:find_all(clause)
end

-- controllers ------------------------------------------------------------

function list(web, msg)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   return render_list(web, msg)
end
ITvision:dispatch_get(list, "/", "/list", "/list/", "/list/(.+)")


function reboot(web)
   local mgs = os.reboot()
   --return web:redirect(web:link("/list/"..mgs))
end
ITvision:dispatch_get(reboot, "/reboot")


function shutdown(web)
   local mgs = os.shutdown()
   --return web:redirect(web:link("/list/"..mgs))
end
ITvision:dispatch_get(shutdown, "/shutdown")


function reset_monitor(web)
   local mgs = os.reset_monitor()
   return web:redirect(web:link("/list/"..mgs))
end
ITvision:dispatch_get(reset_monitor, "/reset_monitor")


function reinit_monitor(web)
   local mgs = os.reinit_monitor()
   return web:redirect(web:link("/list/"..mgs))
end
ITvision:dispatch_get(reinit_monitor, "/reinit_monitor")


function reset_monitor_db(web)
   local mgs = os.reset_monitor_db()
   return web:redirect(web:link("/list/"..mgs))
end
ITvision:dispatch_get(reset_monitor_db, "/reset_monitor_db")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, msg)
   local rows = {}
   local res = {}
--[[
   res[#res + 1] = p{ br(), "<hr>", br() }
   res[#res + 1] = p{ br(), br() }
   res[#res + 1] = p{ msg } 
   res[#res + 1] = p{ br(), br() }
]]

   --res[#res + 1] = p{ br(), "<hr>", br() }
   res[#res + 1] = p{ br(), br() }
   --res[#res + 1] = p{ "Reboot" } 
   res[#res + 1] = p{ button_link("Reboot no Servidor ITvision", web:link("/reboot")) }
   res[#res + 1] = p{ br(), br() }
   --res[#res + 1] = p{ br(), "<hr>", br() }

   --res[#res + 1] = p{ "Desligar" } 
   res[#res + 1] = p{ button_link("Desligar o Servidor ITvision", web:link("/shutdown")) }
   res[#res + 1] = p{ br(), br() }
   --res[#res + 1] = p{ br(), "<hr>", br() }

   --res[#res + 1] = p{ "Atualizar Pendências" } 
   res[#res + 1] = p{ button_link("Atualizar Pendências no Monitor (Reload)", web:link("/reset_monitor")) }
   res[#res + 1] = p{ br(), br() }
   --res[#res + 1] = p{ br(), "<hr>", br() }

   --res[#res + 1] = p{ "Reset Monitor" } 
   res[#res + 1] = p{ button_link("Reiniciar Monitor (Reset)", web:link("/reinit_monitor")) }
   res[#res + 1] = p{ br(), br() }
   --res[#res + 1] = p{ br(), "<hr>", br() }

   --res[#res + 1] = p{ "Reset Database Monitor" } 
   res[#res + 1] = p{ button_link("Reiniciar Banco de Dados ITvision", web:link("/reset_monitor_db")) }
   res[#res + 1] = p{ br(), br() }
   res[#res + 1] = p{ br(), "<hr>", br() }

   return render_layout(res)
end



orbit.htmlify(ITvision, "render_.+")

return _M


