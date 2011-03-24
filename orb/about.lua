#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "View"
require "util"
require "version"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------

-- controllers ------------------------------------------------------------

function list(web)

   return render_list(web)
end
ITvision:dispatch_get(list, "/", "/list")

ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web)
   local res = {}
   
--[[

<center>
<img src="images/logopurple_big.png" alt="ITVision" border=0 />
<h1>ITVision</h1>
<h3>version 0.2.6</h3>
<p><p>

<b>ITVision</b> &eacute; um sistema de monitora&ccedil;&atilde;o, gerenciamento
<br>
e gest&atilde;o para infra-estruturas computacionais desenvolvido pela
<br>
<b>Verto Technologies</b>.

<p>
<img src="images/verto_1.jpg" alt="Verto" height=34 border=0/>

]]

   res = center{ img{ src="/pics/logopurple_big.png", alt="ITVision", border=0 },

     p{ br(), b{"ITvision"}, " &eacute; um sistema de monitora&ccedil;&atilde;o, gerenciamento", br(), 
          "e gest&atilde;o para infra-estruturas computacionais desenvolvido pela", br(),
          b{"Verto Technologies"}, br(), br(),
           img{ src="/pics/logo_verto.jpg", alt="Verto",  height=34, border=0 }, 
           br(), br(),
          "Versão: ", b{version},
      }
   }
   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


