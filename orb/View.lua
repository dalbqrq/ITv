#!/usr/bin/env wsapi.cgi
--[[ 

  How to Make a Text Link Submit A Form:
  http://www.thesitewizard.com/archive/textsubmit.shtml

  FORMS I HTML4
  http://www.w3.org/2007/03/html-forms/#(1)

]]

require "Model"
module(Model.name, package.seeall, orbit.new)
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


function button_form(label, btype, class, div)
   class = class or "none"
   local but = [[<button type="]]..btype..[[" class="]]..class..[[">]]..label..[[</button>]]

   if div then but = [[<div class="]]..div..[[">]]..but..[[</div>]] end

   return but
end


--[[ 
  Cada entrada da tabela menu_item é uma tabela com os seguintes campos:
  { level, name, link }

  O campo level pode ter os seguinte valores:
     0 - item principal sem submenu
     1 - item principal que eh entrada para um submenu
     2 - item de submenu

  Ex:
    Um menu com a seguite disposicao:
   
       menu1   |   menu2   |   menu3   |   menu4
                   item2.1     item3.1     item4.1
                   item2.2                 item4.2
                   item2.3

    Ficaria assim:
       menu_itens = {
	   { 0, "menu1",   "href.html" },
	   { 1, "menu2",   "href.html" },
	   { 2, "item2.1", "href.html" },
	   { 2, "item2.2", "href.html" },
	   { 2, "item2.3", "href.html" },
	   { 1, "menu3",   "href.html" },
	   { 2, "item3.1", "href.html" },
	   { 1, "menu4",   "href.html" },
	   { 2, "item4.1", "href.html" },
	   { 2, "item4.2", "href.html" },
    }
]]
menu_itens = {
	{ 1, "Monitor", "/orb/gv/show" },
	{ 2, "Lógico", "/orb/gv/show" },
	{ 2, "Físico", "/orb/gv/show" },
	{ 2, "Árvore", "/orb/app_tree" },
	{ 2, "Aplicações", "/orb/app" },
	{ 2, "Objetos", "/orb/app_object" },
	{ 2, "Relacionamento", "/orb/app_relat" },
	{ 2, "Checagem", "/orb/probe" },
	{ 2, "Tipo de Relacionamento", "/orb/app_relat_type" },
	{ 2, "Teste de Atividade", "/orb/probe" },
	{ 2, "Relatórios", "/blank.html" },
	{ 1, "ServiceDesk", "/servdesk/front/central.php" },
	{ 2, "Central", "/servdesk/front/central.php" },
	{ 2, "ticket", "/servdesk/front/ticket.php" },
	{ 2, "Estatística", "/servdesk/front/stat.php" },
	{ 1, "CMDB", "#" },
	{ 2, "Computadores", "/servdesk/front/computer.php" },
	{ 2, "Software", "/servdesk/front/software.php" },
	{ 2, "Equip. de Redes", "/servdesk/front/networkequipment.php" },
	{ 2, "Telefones", "/servdesk/front/phone.php"  },
	{ 2, "Periféricos", "/servdesk/front/peripheral.php" },
	{ 2, "Status", "/servdesk/front/states.php" },
	{ 2, "Base de Conhecimento", "/servdesk/front/knowbaseitem.php" },
	{ 2, "Fornecedores", "/servdesk/front/supplier.php" },
	{ 2, "Contratos", "/servdesk/front/contract.php" },
	{ 2, "Contatos", "/servdesk/front/contact.php" },
	{ 1, "Administrar", "#" },
	{ 2, "Usuários", "/servdesk/front/user.php" },
	{ 2, "Grupos", "/servdesk/front/group.php" },
	{ 2, "Regras", "/servdesk/front/rule.php" },
	{ 2, "Logs", "/servdesk/front/event.php" },
	{ 2, "Comandos de Teste", "/orb/checkcmd" },
	{ 2, "Manutenção", "/orb/system" },
	{ 0, "Ajuda", "/blank.html" },
}

-- o parametro 'link_at_level_1' diz se o menu cujo nivel eh 1 serah tratado como um link
function render_menu(link_at_level_1) 
   local o_level = 0
   local s = ""

   for i, v in ipairs(menu_itens) do
      local level = v[1]
      local name  = v[2]
      local link  = v[3]

      if ( ( level == 0 or level == 1 ) and o_level == 2 ) then
         s = s .. "\t</ul>\n</li>\n"
      end

      if level == 0 or level == 2 then
         s = s .. "\t\t<li><a href=\""..link.."\" target=\"content\">"..name.."</a></li>\n"
      elseif level == 1 then
         if link_at_level_1 then
            s = s .. "<li><a href=\""..link.."\" class=\"dir\">"..name.."</a>\n\t<ul>\n"
         else
            s = s .. "<li><span class=\"dir\">"..name.."</span>\n\t<ul>\n"
         end
      end

      o_level = level
   end

   return { s }
end


function render_menu_frame(inner_html)
   return html{
      head{
         title("ITvision"),
         meta{ ["http-equiv"] = "Content-Type",  content = "text/html; charset=utf-8" },
         meta{ name="author", content="ATMA (http://www.itvision.com.br)" },
         meta{ name="description", content="IT monitoring" },
         link{ href="/pics/favicon.ico", rel="shortcut icon" },
         link{ href="/css/menu/helper.css", media="screen", rel="stylesheet", type="text/css" },
         link{ href="/css/menu/dropdown.linear.css", media="screen", rel="stylesheet", type="text/css" },
         link{ href="/css/menu/default.ultimate.linear.css", media="screen", rel="stylesheet", type="text/css" },
         link{ href="/css/style.css", media="screen", rel="stylesheet", type="text/css" },
      },

      body{
         div{ id="header", img{ src="/pics/logopurple.png" }, " ITvision",
            ul{ id="nav", class="dropdown dropdown-linear", inner_html }
         }
      }
   }
end


function render_layout(inner_html, opt_refresh)
   local refresh = {}
   if opt_refresh then
      refresh = meta{ ["http-equiv"] = "Refresh", content = "5", target = "main" }
   end

   return html{
      head{ 
         title("ITvision"),
         meta{ ["http-equiv"] = "Content-Type", content = "text/html; charset=utf-8" },
         refresh,
         link{ href="/pics/favicon.ico", rel="shortcut icon" },
         link{ href="/css/style.css", media="screen", rel="stylesheet", type="text/css" },
         link{ href="/css/glpi_styles.css", media="screen", rel="stylesheet", type="text/css" },
         --script{ type="text/javascript", src="http://itv/js/scripts.js" },
         script{ type="text/javascript", scrt },
      },
      body{ div{ id='page', inner_html } }
      --body{ inner_html }
   }
end


function render_map(marker_maker, center, google_key)
   marker_maker = marker_maker or [[ function marker_maker() {} ]]
   --center = center or "-22.966849,-43.243217" -- IMPA
   --center = center or "-22.865104,-43.430157" -- Av Bradil
   center = center or "-22.88604,-43.229721" -- Av Brasil - Celula 01
   --google_key = google_key or "ABQIAAAAsqOIUfpoX_G_Pw0Ar48BRhS64UBg-UePRXM9viX4hk4iiwv9HRSiOpB5WKHSB9ZBy9mHRo7Ycwp9JA" --www.impa.br
   google_key = google_key or "ABQIAAAAsqOIUfpoX_G_Pw0Ar48BRhRtyMmS1TXEK_DXFnd23B1n8zvUnRT_9hDq4-PHCmE33vrSdHVrdUyjgw" --itv.impa.br

   java_code = [[
// http://code.google.com/apis/maps/documentation/javascript/events.html

var red    = '/pics/red.png';
var blue   = '/pics/blue.png';
var green  = '/pics/green.png';
var gray   = '/pics/gray.png';
var orange = '/pics/orange.png';

var map;
function initialize() {
  var myLatlng = new google.maps.LatLng(]]..center..[[);
  var myOptions = {
    zoom: 15,
    center: myLatlng,
    //mapTypeId: google.maps.MapTypeId.ROADMAP
    mapTypeId: google.maps.MapTypeId.HYBRID
  }

  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  marker_maker();
}
   ]]

   return { "<!DOCTYPE html>", html{
      head{
         title("ITvision"),
         meta{ name = "viewport", content = "initial-scale=1.0, user-scalable=no" },
         meta{ ["http-equiv"] = "Content-Type", content = "text/html; charset=utf-8" },
         link{ href="http://code.google.com/apis/maps/documentation/javascript/examples/default.css", rel="stylesheet", type="text/css" },

         script{ type="text/javascript", src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key="..google_key },
         script{ type="text/javascript", src="http://maps.google.com/maps/api/js?sensor=false" },
         script{ type="text/javascript", java_code, marker_maker },
      },
      body{ onload="initialize()", div{ id="map_canvas" } }
   } }

end


--[[
   render_table() recebe como parametros:

   t -> tabela lua a ser renderizada em uma tabela html. pode ou não possuir cabeçalho (ver parametro h)
   h -> cabecalho da tabela. 
         Se "nil" então não possui header
         Se tabela vazia ("{}") entao o header estah dentro da tabela t
         Se tabela com lista de strings, estao este eh o header a ser utilizado

]]
function render_table(t, h)
   local row = {}
   local col = {}
   local hea = {}
   local i, j, v, w

   if h ~= nil and table.getn(h) > 0 then -- h contendo o header
      for c, w in ipairs(h) do
         hea[#hea+1] = th{ align="center", w }
      end
      hea = tr{ class="tab_bg_1", hea }
   end

   for r, v in ipairs(t) do
      for c, w in ipairs(v) do
         if r == 1 and h ~= nil and table.getn(h) == 0 then -- h vazio ({}) e header dentro de t
            hea[#hea+1] = th{ align="center", w }
         else                                               -- nao possui header, tudo eh linha
            col[#col+1] = td{ w }
         end
      end

      if r == 1 and h ~= nil and table.getn(h) == 0 then  -- h vazio ({}) e header dentro de t
         hea = tr{ class="tab_bg_1", hea }
      else 
         row[#row+1] = tr{ class='tab_bg_1', col }
      end

      col = {}
   end

   return H("table") { border="0", class="tab_cadrehov", thead{ hea }, tbody{ row } }
end


function render_form_bar(form_content, button_name, url_post, url_reset)
         --td{ width='150px', 
               --td{ width='80', class='center', 
   return form{ name = "input", method = "post", action = url_post,
      H('table') { class='tab_cadre_fixe', tr{ class='tab_bg_1', 
         td{ 
            H('table') { tr{ td{ class='left', form_content } } }
         }, 
         td{ 
            H('table') { width='100%', tr{ 
               td{ class='center', 
                  input{ type='submit', value=button_name,  class='submit' }
               }, 
               td{ 
                  --a{ href=url_bookmark, img{ src='/pics/bookmark_record.png' } }
                  a{ href=url_reset, img{ src='/pics/reset.png', class='calendrier' } }
               } 
            } }
         } 
      } } --, br() 
   }
end


function render_selector_bar(web, A, id, path)
   local url = ""
   local res = {}
   local selected = ""
   local curr_app = 0
   id = id or -1

   for i, v in ipairs(A) do
      url = web:link(path.."/"..v.id)
      if tonumber(v.id) == tonumber(id) then
         selected = "selected"
         curr_app = i
      else
         selected = nil
      end
      res[#res+1] = option{ selected=selected, value=url, v.name }
   end

   return { form{ H("select"){ ONCHANGE="location = this.options[this.selectedIndex].value;", res } } }

   
end


function render_bar(t)
   return { H("table") { class='tab_cadre_fixe', tr{ class='tab_bg_1', td{ t } } }, br() }
end


--[[ 
   render_form()

   Exemplo do que pode aparecer em uma tabela t a ser insertida na funcao

   t = {
      strings.name..": ", input{ type="text", name="name", value = val1 },br(),
      strings.type..": ", select_and_or("type", default_val2), br(),
   }
]]
function render_form(url, t)
   return form{
      name = "input",
      method = "post",
      action = url,
      t,
      button_form(strings.send, "submit", "positive"),
      button_form(strings.reset, "reset", "negative"),
   }
end

--[[
   select_options() Parametros:

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
function select_option(name, T, value_idx, label_idx, default_value)
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


NoOrYes = {
      { id = 0, name = strings.no },
      { id = 1, name = strings.yes },
   }

AndOrOr = {
   { id = "and", name = strings.logical_and },
   { id = "or",  name = strings.logical_or },
}

PhysicalOrLogical = {
   { id = "physical", name = strings.physical },
   { id = "logical",  name = strings.logical},
}


function select_yes_no(name, default)
   return select_option(name, NoOrYes, "id", "name", default)
end


function select_and_or(name, default)
   return select_option(name, AndOrOr, "id", "name", default)
end


function select_physical_logical(name, default)
   return select_option(name, PhysicalOrLogical, "id", "name", default)
end


function render_content_header(name, add, list, edit, geotag)
   local myul = { li{ a{href='#', class='here', title="'"..name.."'", name} }, }

   myul[#myul+1] = li{ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" }

   if add then
      myul[#myul+1] = li{ a{ href="'"..add.."'", img{ src='/servdesk/pics/menu_add.png', title='Adicionar', alt='Adicionar'} } }
   end

   if list then
      myul[#myul+1] = li{ a{ href="'"..list.."'",img{ src='/servdesk/pics/menu_search.png', title='Pesquisar', alt='Pesquisar'} } }
   end

   if edit then
      myul[#myul+1] = li{ a{ href="'"..edit.."'",img{ src='/servdesk/pics/edit.png', title='Editar', alt='Editar'} } }
   end

   if geotag then
      myul[#myul+1] = li{ a{ href="'"..geotag.."'",img{ src='/pics/icon32.png', title='GeoVision', alt='Geotag'} } }
   end

   return div{ id='menu_navigate', div { id='c_ssmenu2', ul{ myul } } }
end


function render_map_old(web, lat, lon)

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


-- ESTE MODO DE FAZER MENU ESTAh OBSOLETO --
function button_link(label, link, class)
   class = class or "none"
   return [[<div class="buttons"> <a href="]]..link..
          [[" class="]]..class..[[">]]..label..[[ </a> </div>]]
end

-- ESTE MODO DE FAZER MENU ESTAh OBSOLETO --
local menu = {}
   menu[#menu + 1] = button_link("ARVORE APPS", "/orb/app_tree")
   menu[#menu + 1] = button_link("APPS", "/orb/app")
   menu[#menu + 1] = button_link("APP LIST", "/orb/app_object")
   menu[#menu + 1] = button_link("APP RELAC", "/orb/app_relat")
   menu[#menu + 1] = button_link("TIPO RELAC", "/orb/app_relat_type")
   menu[#menu + 1] = button_link("PROBE", "/orb/probe")
   menu[#menu + 1] = button_link("USUARIO", "/orb/user")
   menu[#menu + 1] = button_link("GRUPO", "/orb/user_group")
   menu[#menu + 1] = button_link("CHECK CMDS", "/orb/checkcmd")
   menu[#menu + 1] = button_link("SISTEMA", "/orb/sysconfig")
   menu[#menu + 1] = "<br><br><br><p><br><p> "

