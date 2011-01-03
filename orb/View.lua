#!/usr/bin/env wsapi.cgi
--[[ 
  How to Make a Text Link Submit A Form:
  http://www.thesitewizard.com/archive/textsubmit.shtml

  FORMS I HTML4
  http://www.w3.org/2007/03/html-forms/#(1)
]]
require "Model"
require "messages"

module(Model.name, package.seeall, orbit.new)


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



function render_menu_frame(inner_html)
   local change_script = [[
         function changeHead(headPage) {
            parent.headFrame.location.href = headPage;
         }
         function changePage(headPage, bodyPage) {
            parent.headFrame.location.href = headPage;
            parent.bodyFrame.location.href = bodyPage;
         }
   ]]

   return html{
      head{
         title("ITvision"),
         meta{ ["http-equiv"] = "Content-Type",  content = "text/html; charset=utf-8" },
         meta{ name="author", content="ATMA (http://www.itvision.com.br)" },
         meta{ name="description", content="IT monitoring" },
         link{ href="/pics/favicon.ico", rel="shortcut icon" },
         link{ href="/css/style.css", media="screen", rel="stylesheet", type="text/css" },
         link{ href="/css/style_menu.css", media="screen", rel="stylesheet", type="text/css" },
         script{ type="text/javascript", change_script },
      },

      body{
         div{ id="header", img{ src="/pics/logo_itv.png" },
            img{ src="/pics/transparent.png", width='500px', height='54px' },
            img{ src="/pics/logo_verto.jpg", height='35px' },
            img{ src="/pics/transparent.png", width='40px', height='44px' },
            img{ src="/pics/logo_proderj.jpg", height='35px' },
            --ul{ id="nav", class="dropdown dropdown-linear", inner_html }
            inner_html
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
   refresh_time = refresh_time or 180
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

