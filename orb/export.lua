#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "Auth"
require "View"
require "Relats"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------

function select_relat()
   return Relats.select_tickets()
   --return Model.query("glpi_tickets")
end


-- controllers ---------------------------------------------------------

function show(web)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   local relat = select_relat()

   return render_show(web, relat)
end
ITvision:dispatch_get(show,"/show")


function download(web)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   return render_download(web)
end
ITvision:dispatch_get(download,"/download")


ITvision:dispatch_static("/css/%.css", "/script/%.js")



-- views ------------------------------------------------------------


function render_show(web, relat)
   local auth = Auth.check(web)
   local permission = Auth.check_permission(web, "application")
   local res = {}

   web.prefix = "/orb/export"
   local lnk = web:link("/download")

   res[#res+1] = render_resume(web)
   res[#res+1] = render_content_header(auth, "Relatório de Tickets", nil, web:link("/show"))
   res[#res+1] = render_bar( { 
           a{ href=lnk,  "Exportar Arquivo CSV" } ,
         } )

   res[#res+1] = render_table(relat, nil, "tab_cadre_grid")
   res[#res+1] = { br(), #relat, br(), br(), br() }

   return render_layout(res, refresh_time)
end


function render_download(web)
   os.capture("/usr/local/itvision/scr/ticket_relat")

   web.prefix = "/csv"
   return web:redirect(web:link("/ticket_relat.csv"))
end


orbit.htmlify(ITvision, "render_.+")

return _M


