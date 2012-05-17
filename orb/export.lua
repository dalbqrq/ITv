#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "Auth"
require "View"
require "Resume"
require "Relats"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------

function select_tickets(clause)
   return Relats.select_tickets(clause)
end


-- controllers ---------------------------------------------------------

function show(web)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   return render_show(web)
end
ITvision:dispatch_get(show,"/show")


function tickets(web)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   if tonumber(web.input.month) < 10 then web.input.month = "0"..web.input.month end
   local clause = " and t.entities_id in "..Auth.make_entity_clause(auth)
                .." and t.date like '"..web.input.year.."-"..web.input.month.."%'"

   local tkts = select_tickets(clause)

   return render_tickets(web, tkts, clause)
end
ITvision:dispatch_post(tickets,"/tickets")


ITvision:dispatch_static("/css/%.css", "/script/%.js")



-- views ------------------------------------------------------------


function render_show(web)
   local auth = Auth.check(web)
   local permission = Auth.check_permission(web, "application")
   local inc = {}
   local res = {}
   local tab = {}
   local month, year = tonumber(os.date("%m")) - 1, tonumber(os.date("%Y"))

   res[#res+1] = render_resume(web)

   web.prefix = "/orb/export"
   res[#res+1] = render_content_header(auth, "Exportar Arquivos CSV ", nil, web:link("/show"))

   if month == 0 then month = 12; year = year - 1 end
   inc = {
      "LISTAGEM DE TICKETS | Abertos em: ",
      strings.month..": ", select_months("month", month),  " ",
      strings.year..": ", select_years("year", year),  " ",
   }
   res[#res+1] = render_form_bar( inc, "Exportar", web:link("/tickets") )

   return render_layout(res, refresh_time)
end


function render_tickets(web, tkts, clause)
   local res = {}
   local filename = "/ticket_relat.csv"
   web.prefix = "/csv"

   -- Codigo original:
   os.capture(config.path.itvision.."/scr/ticket_relat")

   -- Código novo que nao funcionou pois retorna com problemas de mais de uma linha para a mesma
   -- tupla e com as colunas fora de ordem e sem nome:
   -- line_writer(config.path.itvision.."/html/csv/"..filename, tkts, "\t")

   return web:redirect(web:link(filename))
end


orbit.htmlify(ITvision, "render_.+")

return _M


