#!/usr/bin/env wsapi.cgi
--[[ 

  How to Make a Text Link Submit A Form:
  http://www.thesitewizard.com/archive/textsubmit.shtml

  FORMS I HTML4
  http://www.w3.org/2007/03/html-forms/#(1)

]]

require "orbit"
module("itvision", package.seeall, orbit.new)
require "cosmo"

require "messages"

local scrt = [[
   function confirmation(question, url) { 
      var answer = confirm(question) 
      if (answer){ 
         //alert("The answer is OK!"); 
         window.location = url;
      } else { 
         //alert("The answer is CANCEL!") 
      } 
   } 
   ]]

function do_button(web, label, url, question)
   -- TODO: do_button() NAO ESTAh FUNCIONANDO !!!!
   return { form = { action = web:link(url),  input = { value = label, type = "submit" } } }
end


function button_form(label, btype, class)
   class = class or "none"
   return [[<div class="buttons"><button type="]]..btype..
          [[" class="]]..class..[["> ]]..label..[[ </button> </div> ]]
end


function button_link(label, link, class)
   class = class or "none"
   return [[<div class="buttons"> <a href="]]..link..
          [[" class="]]..class..[[">]]..label..[[ </a> </div>]]
end


local menu = {}
   menu[#menu + 1] = button_link("IC", "/orb/ci")
   menu[#menu + 1] = button_link("COMP", "/orb/computer")
   menu[#menu + 1] = button_link("ARVORE APPS", "/orb/app_tree")
   menu[#menu + 1] = button_link("APPS", "/orb/apps")
   menu[#menu + 1] = button_link("APP LIST", "/orb/app_list")
   menu[#menu + 1] = button_link("RELAC.", "/orb/app_relat")
   menu[#menu + 1] = button_link("TIPO RELAC.", "/orb/app_relat_type")
   menu[#menu + 1] = button_link("CONTRATOS", "/orb/contract")
   menu[#menu + 1] = button_link("LOCAL.", "/orb/location_tree")
   menu[#menu + 1] = button_link("FABR.", "/orb/manufacturer")
   menu[#menu + 1] = button_link("USUARIO", "/orb/user")
   menu[#menu + 1] = button_link("GRUPO", "/orb/user_group")
   menu[#menu + 1] = button_link("CHECK", "/orb/checkcmd")
   menu[#menu + 1] = button_link("SIS.", "/orb/sysconfig")
--[[
   menu[#menu + 1] = button_link("ARVORE APPS", "http://itv/orb/app_tree")
   menu[#menu + 1] = button_link("APPS", "http://itv/orb/apps")
   menu[#menu + 1] = button_link("APP LIST", "http://itv/orb/app_list")
   menu[#menu + 1] = button_link("RELACIONAMENTOS", "http://itiv/orb/app_relat")
   menu[#menu + 1] = button_link("TIPO RELAC.", "http://itiv/orb/app_relat_type")
   menu[#menu + 1] = button_link("CONTRATOS", "http://itiv/orb/contract")
   menu[#menu + 1] = button_link("LOCALIZACAO", "http://itiv/orb/location_tree")
   menu[#menu + 1] = button_link("FABRICANTE", "http://itiv/orb/manufacturer")
   menu[#menu + 1] = button_link("USUARIO", "http://itiv/orb/user")
   menu[#menu + 1] = button_link("GRUPO", "http://itiv/orb/user_group")
   menu[#menu + 1] = button_link("CHECK", "http://itiv/orb/checkcmd")
   menu[#menu + 1] = button_link("SISTEMA", "http://itiv/orb/sysconfig")
]]
   menu[#menu + 1] = "<br><br><br><p><br><p> "



function render_layout(inner_html)
   return html{
      head{ 
         title("ITvision"),
         meta{ ["http-equiv"] = "Content-Type",
            content = "text/html; charset=utf-8" },
         link{ rel = 'stylesheet', type = 'text/css', 
            href = '/css/style.css', media = 'screen' },
         --script{ type="text/javascript", src="http://itv/js/scripts.js" },
         script{ type="text/javascript", scrt },

      },
      body{ menu, inner_html }
   }
end


function select_option(name, T, value_idx, label_idx, default_value)
--[[
   Parametros:

      name -> nome da variavel do form-html que serah recuperado pelo respectivo metodo 'controler'
              tipicamete um metodo 'update' ou 'insert'  
      T -> eh a tabela de tuplas com o campo que deve ser apresentado no 'select' do html
      value_idx -> eh o indice (chave primaria) da tabela T
      label_idx -> eh o nome do indice da coluna que deve ser apresentado na lista de opcoes
      default_value -> eh a opcao (dentre as que estao na tabela T) que deve ser apresentada inicialmente 

   Ex: T = {
      { x_id = 101, name = "hardware", alias = "HW", type = 0, category = 9 },
      { x_id = 102, name = "software", alias = "SW", type = 1, category = 6 },
      { x_id = 103, name = "link",     alias = "LK", type = 5, category = 2 }  }

      Para a tabela acima, uma tipica chamada desta funcao ficaria assim:

      select_option("tipo", T, "x_id", "name", "link")
      
]]
   local olist = {}

   olist[#olist + 1] = "<select name=\""..name.."\">"
   for i, v in ipairs(T) do
      if default_value then
         if ((type(tonumber(default_value)) ~= "nil") and (tonumber(default_value) == tonumber(v[value_idx])) )
            or ( default_value == v[value_idx] )
         then
            selected = "selected "
         else
            selected = ""
         end
      else
         selected = ""
      end

      local str= ""

      str = str..v[value_idx]

      str = str..v[label_idx]

      str = str..selected

      olist[#olist + 1] = "<option "..selected.." value=\""..v[value_idx].."\" label=\"".. 
                           v[label_idx].."\">"..  v[label_idx].."</option>"

   end
   olist[#olist + 1] = "</select>"

   return olist

end

AndOrOr = {
   { id = "and", name = strings.logical_and },
   { id = "or",  name = strings.logical_or },
}

NoOrYes = {
      { id = 0, name = strings.no },
      { id = 1, name = strings.yes },
   }


function select_and_or(name, default)
   return select_option(name, AndOrOr, "id", "name", default)
end


function select_yes_no(name, default)
   return select_option(name, NoOrYes, "id", "name", default)
end


function render_map(web, lat, lon)

    s = [[
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=ISO-8859-1">
<title>Exemplo de Google Maps API</title>
<script src="http://maps.google.com/maps?file=api&v=2&key=#SUA CHAVE GOOGLE MAPS#" type="text/javascript"></script>
<script type="text/javascript">
   //<![CDATA[
   
   //função para carregar um mapa de Google. 
   //Esta função é chamada quando a página termina de carregar. Evento onload
   function load() {
      //comprovamos se o navegador é compatível com os mapas de google
      if (GBrowserIsCompatible()) {
         //instanciamos um mapa com GMap, passando-lhe uma referência à camada ou <div> onde quisermos mostrar o mapa
         var map = new GMap2(document.getElementById("map"));   
         //centralizamos o mapa em uma latitude e longitude desejadas
         map.setCenter(new GLatLng(]]..lat..[[,]]..lon..[[), 18);   
         //adicionamos controles ao mapa, para interação com o usuário
         map.setMapType(G_SATELLITE_MAP)
         map.addControl(new GLargeMapControl());
         map.addControl(new GMapTypeControl()); 
         //daniel  map.addControl(new GOverviewMapControl()); ;
      }
   }
   
   //] ]>
   </script>
</head>
<body onload="load()" onunload="GUnload()">
<div id="map" style="width: 615px; height: 400px"></div>
</body>
</html>
]]

    return s
end

