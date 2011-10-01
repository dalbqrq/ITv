#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "App"
require "Auth"
require "View"
require "Resume"
require "Glpi"
require "util"
require "monitor_util"

module(Model.name, package.seeall,orbit.new)

-- models ------------------------------------------------------------


-- controllers ------------------------------------------------------------


function add(web)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   return render_add(web)
end
ITvision:dispatch_get(add, "/add")


function export(web, month, year)
   return render_export(web)
end
ITvision:dispatch_get(export, "/export/(%d+):(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


-- TODO: edit deve receber os valores a serem alterados
function render_add(web, edit)
   local permission, auth = Auth.check_permission(web, "application", true)
   local exp_link = web:link("/export")
   local res = {}
   local Years = {}
   local min_year = 2011
   local cur_year = tonumber(os.date("%m"))
   local cur_month = tonumber(os.date("%Y"))

   local c =1
   for m = min_year, cur_year do
      Years[#Years+1] = { id=c, name=m }
      c = c + 1
   end

   -- cria conteudo do formulario em barra
   local inc = {
      "Mês: ", select_month("month", cur_month), " "
      "Ano: ", select_option("year",  Years,  "id", "name", cur_year),  " ",
   }
   
   res[#res+1] = render_content_header(auth, strings.application, add_link, web:link("/list"))
   res[#res+1] = render_form_bar( inc, strbar, link, add_link )

   return render_layout(res)
end



orbit.htmlify(ITvision, "render_.+")

return _M


