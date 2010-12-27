#!/usr/bin/env wsapi.cgi
--[[ 

  How to Make a Text Link Submit A Form:
  http://www.thesitewizard.com/archive/textsubmit.shtml

  FORMS I HTML4
  http://www.w3.org/2007/03/html-forms/#(1)

]]

require "Model"
require "config"
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
	{ 1, "Monitor", "/orb/gviz/show" },
	{ 2, "Lógico", "/orb/gviz/show" },
	{ 2, "Físico", "/orb/gviz/show" },
	--{ 2, "Árvore", "/orb/app_tree" },
	{ 2, "Aplicações", "/adm/app" },
	{ 2, "Objetos & Relacionamentos", "/adm/app_objects" },
	--{ 2, "Objetos", "/adm/app_object" },
	--{ 2, "Relacionamento", "/adm/app_relat" },
	{ 2, "Checagem", "/adm/probe" },
	{ 2, "Tipo de Relacionamento", "/adm/app_relat_types" },
	--{ 2, "Teste de Atividade", "/adm/probe" },
	--{ 2, "Relatórios", "/blank.html" },
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
	{ 2, "Login", "/orb/login" },
	{ 2, "Usuários", "/servdesk/front/user.php" },
	{ 2, "Grupos", "/servdesk/front/group.php" },
	{ 2, "Regras", "/servdesk/front/rule.php" },
	{ 2, "Logs", "/servdesk/front/event.php" },
	{ 2, "Comandos de Teste", "/adm/checkcmd" },
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


function render_layout(inner_html, refresh_time)
   local refresh = {}
   if refresh_time then
      refresh = meta{ ["http-equiv"]="Refresh", content=refresh_time, target="main" }
   end

   return html{
      head{ 
         title("ITvision"),
         meta{ ["http-equiv"] = "Content-Type", content = "text/html; charset=utf-8" },
         refresh,
         meta{ ["http-equiv"] = "Cache-Control", content = "No-Cache" },
         meta{ ["http-equiv"] = "Pragma",        content = "No-Cache" },
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


function render_map(marker_maker, center, google_key, refresh_time)
   marker_maker = marker_maker or [[ function marker_maker() {} ]]
   refresh_time = refresh_time or 45
   --center = center or "-22.966849,-43.243217" -- IMPA
   --center = center or "-22.865104,-43.430157" -- Av Bradil
   center = center or "-22.88604,-43.229721" -- Av Brasil - Celula 01
   google_key = google_key or config.view.google_maps_key

   java_code = [[
// http://code.google.com/apis/maps/documentation/javascript/events.html

var red    = '/pics/red.png';
var blue   = '/pics/blue.png';
var green  = '/pics/green.png';
var gray   = '/pics/gray.png';
var orange = '/pics/orange.png';
var yellow = '/pics/yellow.png';

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

   local refresh = meta{ ["http-equiv"]="Refresh", content=refresh_time, target="main" }

   return { "<!DOCTYPE html>", html{
      head{
         title("ITvision"),
         meta{ name = "viewport", content = "initial-scale=1.0, user-scalable=no" },
         meta{ ["http-equiv"] = "Content-Type", content = "text/html; charset=utf-8" },
         refresh,
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

      local span = 1
   for r, v in ipairs(t) do
      for c, w in pairs(v) do

if c == "colspan" then 
   span = w
else 
         if r == 1 and h ~= nil and table.getn(h) == 0 then -- h vazio ({}) e header dentro de t
            hea[#hea+1] = th{ align="center", w }
         else                                               -- nao possui header, tudo eh linha
            col[#col+1] = td{ colspan=span, w }
         end
   span = 1
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
      --H('table') { class='tab_cadre_fixe', tr{ class='tab_bg_1', 
      H('table') { class='tab_cadrehov', tr{ class='tab_bg_1', 
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

   --return { form{ H("select"){ ONCHANGE="location = this.options[this.selectedIndex].value;", res } } }
   return form{ H("select"){ ONCHANGE="location = this.options[this.selectedIndex].value;", res } }
   
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
function render_form(url, url_reset, t, line, button_name, iframe_target)
   url_reset = url_reset or ""
   iframe_target = iframe_target or ""
   local reset
   if button_name == nil then button_name = strings.send end
   if url_reset == nil then reset = "" else reset = url_reset end
   if line then line = br() else line = "" end

   return form{
      name = "input",
      method = "post",
      action = url,
      target = iframe_target,
      t,
      line,
      input{ type='submit', value=button_name,  class='submit' },
      " ",
      a{ href=reset, img{ src='/pics/reset.png', class='calendrier' } },
   }
end

function render_form_default(url, t)
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


function select_option_onchange(name, T, value_idx, label_idx, default_value, url)
   local olist = {}

   olist[#olist + 1] = "<select name=\""..name.."\" ONCHANGE=\"location = this.options[this.selectedIndex].label;\">"
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
                           url..":"..v[value_idx].."\">"..  v[label_idx].."</option>"

   end
   olist[#olist + 1] = "</select>"

   return olist
end


-- YES or NO
NoOrYes = {
   { id = 0, name = strings.no },
   { id = 1, name = strings.yes },
}

function name_yes_no(id)
   return choose_name(NoOrYes, id)
end

function select_yes_no(name, default)
   return select_option(name, NoOrYes, "id", "name", default)
end


-- AND or OR
AndOrOr = {
   { id = "and", name = strings.logical_and },
   { id = "or",  name = strings.logical_or },
}

function name_and_or(id)
   return choose_name(AndOrOr, id)
end

function select_and_or(name, default)
   return select_option(name, AndOrOr, "id", "name", default)
end


-- PHYSICAL or LOGICAL
PhysicalOrLogical = {
   { id = "physical", name = strings.physical },
   { id = "logical",  name = strings.logical},
}

function name_physical_logical(id)
   return choose_name(PhysicalOrLogical, id)
end

function select_physical_logical(name, default)
   return select_option(name, PhysicalOrLogical, "id", "name", default)
end


--  HOST or SERVICE or APP
HostOrServiceOrApp = {
   { id = "hst", name = strings.host },
   { id = "svc", name = strings.service},
   { id = "app", name = strings.application},
}

function name_hst_svc_app(id)
   return choose_name(HostOrServiceOrApp, id)
end

function select_hst_svc_app(name, default)
   return select_option(name, HostOrServiceOrApp, "id", "name", default)
end


function choose_name(opts, id)
   for _, v in ipairs(opts) do
      if v.id == id then
         return v.name
      end
   end
   return "noname"
end


function select_hst_or_svc_or_app(name, default)
   return select_option(name, HostOrServiceOrApp, "id", "name", default)
end


function render_content_header(name, add, list, edit, geotag, back)
   local myul = { li{ a{href='#', class='here', title="'"..name.."'", name} }, }

   myul[#myul+1] = li{ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" }

   if add then
      myul[#myul+1] = li{ a{ href=add, img{ src='/servdesk/pics/menu_add.png', title='Adicionar', alt='Adicionar'} } }
   end

   if list then
      myul[#myul+1] = li{ a{ href=list,img{ src='/servdesk/pics/menu_search.png', title='Pesquisar', alt='Pesquisar'} } }
   end

   if edit then
      myul[#myul+1] = li{ a{ href=edit,img{ src='/servdesk/pics/edit.png', title='Editar', alt='Editar'} } }
   end

   if geotag then
      myul[#myul+1] = li{ a{ href=geotag,img{ src='/pics/icon32.png', title='GeoVision', alt='Geotag', "Visão Georeferenciada "} } }
   end

   if back then
      myul[#myul+1] = li{ a{ href="#", onClick="history.go(-1)", "Back" } }
   end

   return div{ id='menu_navigate', div { id='c_ssmenu2', ul{ myul } } }
end


function button_link(label, link, class)
   class = class or "none"
   return [[<div class="buttons"> <a href="]]..link..
          [[" class="]]..class..[[">]]..label..[[ </a> </div>]]
end


-- includes & defs ------------------------------------------------------
require "util"
require "View"
require "Graph"

require "orbit"
require "Model"
module(Model.name, package.seeall,orbit.new)

local apps = Model.itvision:model "apps"


-- models ------------------------------------------------------------

function apps:select_apps(id)
   local clause = " is_active = 1 "
   if id then
      clause = " id = "..id
   end
   --return self:find_all(clause)
   return Model.query("itvision_apps", clause, "order by id")
end


-- controllers ---------------------------------------------------------

function list(web)
   local A = apps:select_apps()
   return render_list(web, A)
end
ITvision:dispatch_get(list, "/", "/list")

--[[
   id -> é uma id de aplicacao
]]
function show(web, id)
   local app, app_name, obj_id
   local all_apps = apps:select_apps()

   if id == "/show" then
      if all_apps[1] then 
         id = all_apps[1].id 
         if config.database.instance_name == "VERTO" then
           id = 48
         end
      else
         return render_blank(web)
      end
   end

   app = apps:select_apps(id)

   -- para presentacao Verto
   --if id == "/show" and app[1] then id = 31 end
   --local app = apps:select_apps(id)
   --local obj = Model.select_app_to_graph(id)
   local obj = Model.select_monitors_app_objs(id)
   local rel = Model.select_app_relat_to_graph(id)
   app_name = app[1].name
   obj_id = app[1].service_object_id

   return render_show(web, all_apps, app_name, id, obj, rel, obj_id)
end
ITvision:dispatch_get(show,"/show", "/show/(%d+)")


ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------

function render_list(web, A)
   local res = {}
   res[#res + 1] = p{ br(), br() }
   return render_layout(res)
end


function render_show(web, app, app_name, app_id, obj, rel, obj_id)
   local res = {}
   local engene = "dot"
   local file_type = "png"
   local refresh_time = 15
   local imgfile, imglink, mapfile, maplink, dotfile = Graph.make_gv_filename(app_name, file_type)

--[[
   if string.find(app_name, "Av Brasil") then
]]
   if tonumber(app_id) == 48 then
      engene = "dot"
      engene = "neato"
      engene = "twopi"
      engene = "fdp"
      engene = "circo"
   else
      engene = "circo"
      engene = "dot"
   end

   local content = Graph.make_content(obj, rel)
   Graph.render(app_name, file_type, engene, content)
   local imgmap = text_file_reader(mapfile)

   local lnkgeo = nil
   if obj_id then 
      web.prefix = "/adm/obj_info"
      lnkgeo = web:link("/geotag/app:"..obj_id) 
      web.prefix = "/orb/gviz"
   end
   res[#res+1] = render_bar( render_selector_bar(web, app, app_id, "/show") )
   res[#res+1] = render_content_header("", nil, nil, nil, lnkgeo)
   res[#res+1] = { imgmap }
   res[#res+1] = img{ 
      src=imglink,
      alt="Realistic ITvision",
      border=0,
      class="figs",
      USEMAP="#G",
   }
 
   return render_layout(res, refresh_time)
end


function render_blank(web)
   local res = {}
   res[#res+1]  = { b{ "Não há aplicações configuradas" } } 

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


