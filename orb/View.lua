#!/usr/bin/env wsapi.cgi
--[[ 
  How to Make a Text Link Submit A Form:
  http://www.thesitewizard.com/archive/textsubmit.shtml

  FORMS I HTML4
  http://www.w3.org/2007/03/html-forms/#(1)
]]
require "Model"
require "Auth"
require "messages"
require "state"
require "monitor_inc"

module(Model.name, package.seeall, orbit.new)


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


function button_link(label, link, class)
   class = class or "none"
   return [[<div class="buttons"> <a href="]]..link..
          [[" class="]]..class..[[">]]..label..[[ </a> </div>]]
end


function make_logo(instance_name) 
   if instance_name == "IMPA" then
      return {
         { src="/pics/transparent.png", width='700px', height='40' },
         { src="/pics/logo_impa.png", height='40px'  },
      }
   
   elseif instance_name == "PRODERJ" then
      return {
         { src="/pics/transparent.png", width='540px', height='40px' },
         { src="/pics/logo_verto.jpg", height='35px' },
         { src="/pics/transparent.png", width='40px', height='40px' },
         { src="/pics/logo_proderj.jpg", height='35px' },
      }

   elseif instance_name == "VERTO" then
      return {
         { src="/pics/transparent.png", width='670', height='40px' },
         { src="/pics/logo_verto.jpg", height='35px' },
      }
   else
      return { }
   end
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

   local imgs = make_logo(config.database.instance_name)
   local logo = {}
   local header_imgs = {}

   for _,v in ipairs(imgs) do
      logo[#logo+1] = img{ src=v.src, width=v.width, height=v.height }
   end

   if #inner_html > 0 then header_imgs = { img{ src="/pics/logo_itv.png" }, logo } end

   return html{
      head{
         title("ITvision"),
         meta{ ["http-equiv"] = "Content-Type",  content = "text/html; charset=utf-8" },
         meta{ ["http-equiv"] = "Content-Language",  content = "pt-BR" },
         meta{ name="author", content="ATMA (http://www.itvision.com.br)" },
         meta{ name="description", content="IT monitoring" },
         link{ href="/pics/favicon.ico", rel="shortcut icon" },
         link{ href="/css/style.css", media="screen", rel="stylesheet", type="text/css" },
         link{ href="/css/style_menu.css", media="screen", rel="stylesheet", type="text/css" },
         script{ type="text/javascript", change_script },
      },

      body{
         div{ id="header", header_imgs, inner_html }
      }
   }
end


local entity_script1 = " \
//<![CDATA[ \
Ext.BLANK_IMAGE_URL = '/servdesk/lib/extjs/s.gif'; \
 Ext.Updater.defaults.loadScripts = true; \
Ext.UpdateManager.defaults.indicatorText='<\\span class=\"loading-indicator\">Carregando...<\\\/span>'; \
//]]> \
"

local entity_script3 = [[
<!--[if IE]><script type="text/javascript">
Ext.UpdateManager.defaults.indicatorText='<\span class="loading-indicator-ie">Carregando...<\/span>';
</script>
<![endif]-->
]]
   
local entity_script2 = [[
         cleanhide('modal_entity_content');
         var entity_window=new Ext.Window({
            layout:'fit', 
            width:800, 
            height:400, 
            closeAction:'hide',
            modal: true, 
            autoScroll: true, 
            title: 'Selecione a entidade desejada',
            autoLoad: '/servdesk/ajax/entitytree.php' });
   ]] 
            --autoLoad: '/servdesk/ajax/entitytree.php?target=/servdesk/front/central.php' });



--function render_layout(header, inner_html, refresh_time)
function render_layout(inner_html, refresh_time)
   local refresh = {}
   if type(tonumber(refresh_time)) == "number" then
      refresh = meta{ ["http-equiv"]="Refresh", content=refresh_time, target="main" }
   end

   return html{
      head{ 
         title("ITvision"), {"\n"},
         meta{ ["http-equiv"] = "Content-Type", content = "text/html; charset=utf-8" }, {"\n"},
         meta{ ["http-equiv"] = "Content-Language", content = "pt-BR" }, {"\n"},
         meta{ ["http-equiv"] = "Pragma",        content = "No-Cache" }, {"\n"},
         meta{ ["http-equiv"] = "Cache-Control", content = "No-Cache" }, {"\n"},
         refresh, {"\n"},

         --link{ rel='stylesheet', type='text/css', media='screen', href="/css/style.css" }, {"\n"},
         link{ rel='stylesheet', type='text/css', media='screen', href="/servdesk/css/styles.css" }, {"\n"},
         link{ rel='stylesheet', type='text/css', media='print',  href='/servdesk/css/print.css' }, {"\n"},
         link{ rel="shortcut icon", href="/pics/favicon.ico" }, {"\n"},
         script{ type="text/javascript", src='/servdesk/lib/extjs/adapter/ext/ext-base.js' }, {"\n"},
         script{ type="text/javascript", src='/servdesk/lib/extjs/ext-all.js' }, {"\n"},
         --link{ rel='stylesheet', type='text/css', media='screen', href="/css/glpi_styles.css" }, {"\n"},
         link{ rel='stylesheet', type='text/css', media='screen', href='/servdesk/lib/extjs/resources/css/ext-all.css' } , {"\n"},
         link{ rel='stylesheet', type='text/css', media='screen', href='/servdesk/css/ext-all-glpi.css' }, {"\n"},

         script{ type="text/javascript", src='/servdesk/lib/extjs/locale/ext-lang-pt_BR.js' }, {"\n"},
         script{ type="text/javascript", src='/servdesk/lib/extrajs/xdatefield.js' }, {"\n"},
         script{ type="text/javascript", src='/servdesk/lib/extrajs/datetime.js' }, {"\n"},
         script{ type="text/javascript", src='/servdesk/lib/extrajs/spancombobox.js' }, {"\n"},
         --script{ type="text/javascript", src='/js/confirmation.js' }, {"\n"},
         --script{ type="text/javascript", entity_script1 }, {"\n"},
         --entity_script3,
         script{ type="text/javascript", src='/servdesk/script.js' }, {"\n"},


      },
      --body{ header,  div{ id='page', inner_html } }
      body{ div{ id='page', inner_html } }
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
   render_table() original. A substitura está logo abaixo.

function render_table(t, h)
   local row = {}
   local col = {}
   local hea = {}
   local i, j, v, w
   local bgclass = "tab_bg_1"
   local span = 1

   if h ~= nil and table.getn(h) > 0 then -- h contendo o header
      for c, w in ipairs(h) do
         hea[#hea+1] = th{ align="center", w }
      end
      hea = tr{ class=bgclass, hea }
   end

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

      if bgclass == "tab_bg_1" then bgclass = "tab_bg_2" else bgclass = "tab_bg_1" end -- intercala bg
      if r == 1 and h ~= nil and table.getn(h) == 0 then  -- h vazio ({}) e header dentro de t
         hea = tr{ class=bgclass, hea }
      else 
         row[#row+1] = tr{ class=bgclass, col }
      end
      col = {}
   end

   return H("table") { border="0", class="tab_cadre_fixe", thead{ hea }, tbody{ row } }
end
]]


--[[
   render_table() recebe como parametros:

   t -> tabela lua a ser renderizada em uma tabela html. pode ou não possuir cabeçalho (ver parametro h)
         Se dentro desta tabela existir uma tabela de nome "status" esta será usada para "pintar" a linha
         com cores fortes e fracas conforme definido na tabela status.applic_alert{}. Isto deverá ser usado
         essencialmente para entradas de status de itens de monitoracao.
   h -> cabecalho da tabela. 
         Se "nil" então não possui header
         Se tabela vazia ("{}") entao o header estah dentro da tabela t
         Se tabela com lista de strings, estao este eh o header a ser utilizado
   class -> classe do css a ser usada para a tabela. Default: tab_cadre_fixe

]]
function render_table(t, h, class)
   local row = {}
   local col = {}
   local hea = {}
   local i, j, v, w
   local bgclass = "tab_bg_1"
   local span = 1
   class = class or "tab_cadre_fixe"

   if h ~= nil and table.getn(h) > 0 then -- h contendo o header
      for c, w in ipairs(h) do
         hea[#hea+1] = th{ align="center", w }
      end
      hea = tr{ class=bgclass, hea }
   end

   -- Percorre as linhas (rows)
   for r, v in ipairs(t) do
      local color, lightcolor, colnumber

      -- EXEMPLOS DE LINHAS: 
      --
      -- A primeira possui uma sub-tabela "status" a ser aplicada em cota a linha selecionando a coluna da 
      -- cor forte e colocando as cores leves nas demais colunas
      --
      --     row[#row + 1] = { status={ state=state, colnumber=2 }, name, statename, ip, probe, itemtype, output }
      --
      -- O segundo exemplo coloca cores individualmente em cada coluna com o auxilido de uma tabela.O
      --
      --     row[#row + 1] = { name, { value=statename, state=state }, ip, probe, itemtype, output 
      --
      -- Nada impede ainda que cada entrada da linha seja uma tabela, mas ela nao pode conter o campo "state".
      --
      -- A coluna "status" (uma sub-tabela) não deve ser apresentada. Serve somente para trazer as informações de 
      -- cores de determinada linha dada pelo status de um objeto
      if v.status then 
          color = applic_alert[tonumber(v.status.state)].color
          if v.status.nolightcolor ~= true then
             lightcolor = applic_alert[tonumber(v.status.state)].lightcolor
          end
          colnumber = v.status.colnumber -- colnumber pode ser um valor ou uma tabela contento as
                                        
      end

      -- Percorre as colunas (cols)
      for c, w in pairs(v) do
         --if c == "state" or c == "colnumber" then 
         if c == "status" then 
            --color = applic_alert[tonumber(v.state)].color
            --lightcolor = applic_alert[tonumber(v.state)].lightcolor
         elseif c == "colspan" then 
            span = w
         else 
            if r == 1 and h ~= nil and table.getn(h) == 0 then -- h vazio ({}) e header dentro de t
               hea[#hea+1] = th{ align="center", w }
            else                                               -- nao possui header, tudo eh linha
               local bgcolor = nil
               if type(w) == "table" and w.state ~= nil then -- cores individuais por coluna
                  bgcolor = applic_alert[tonumber(w.state)].color
                  value   = w.value
               else -- cores especificadas pela sub-tabela status
                  if c == tonumber(colnumber) then bgcolor = color else bgcolor = lightcolor end
                  value = w
               end
               col[#col+1] = td{ colspan=span, bgcolor=bgcolor, value }
            end
            span = 1
         end
      end

      if bgclass == "tab_bg_1" then bgclass = "tab_bg_2" else bgclass = "tab_bg_1" end -- intercala bg
      if r == 1 and h ~= nil and table.getn(h) == 0 then  -- h vazio ({}) e header dentro de t
         hea = tr{ class=bgclass, hea }
      else 
         row[#row+1] = tr{ class=bgclass, col }
      end
      col = {}
   end

   return H("table") { border="0", class=class, thead{ hea }, tbody{ row } }
end


function render_grid(content, class)
   local row = {}
   local col = {}
   local i, j, v, w
   local rowclass = "tab_bg_1"
   local span = 1
   class = class or "tab_cadre_grid"

   for r, v in ipairs(content) do
      for c, w in pairs(v) do
         if c == "colspan" then 
            span = w
         else 
            col[#col+1] = td{ colspan=span, w }
            span = 1
         end
      end

      row[#row+1] = tr{ class=rowclass, col }
      col = {}
   end

   return H("table") { border="0", class=class, tbody{ row } }

end


function render_form_bar(form_content, button_name, url_post, url_reset)
   if url_post then
      submit = H('table') { width='100%', tr{ 
               td{ class='center', 
                  input{ type='submit', value=button_name,  class='submit' }
               }, 
--[[ remove o botao de reset (x) dos formularios em barra
               td{ 
                  a{ href=url_reset, img{ src='/pics/reset.png', class='calendrier' } }
               } 
]]
            } }

   end
   return form{ name = "input", method = "post", action = url_post,
      H('table') { class='tab_cadre_fixe', tr{ class='tab_bg_1', 
         td{ 
            H('table') { tr{ td{ class='left', form_content } } }
         }, 
         td{  submit } 
      } }
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
   local r = {}
   if type(t) == "table" then
      for _,v in ipairs(t) do r[#r+1] = td {v} end
      return H("table") { class='tab_cadre_fixe', tr{ class='tab_bg_1', r } }
   else
      return H("table") { class='tab_cadre_fixe', tr{ class='tab_bg_1', td{ t } } }
   end
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
--[[ remove o botao de reset (x) dos formularios em barra
      a{ href=reset, img{ src='/pics/reset.png', class='calendrier' } },
]]
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
   return choose_name(NoOrYes, tonumber(id))
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


-- PUBLIC or PRIVATE (usado na visibilidade das aplicacoes)
PrivateOrPublic = {
   { id = 0, name = strings.private },
   { id = 1, name = strings.public },
}

function name_private_public(id)
   return choose_name(PrivateOrPublic, tonumber(id))
end

function select_private_public(name, default)
   return select_option(name, PrivateOrPublic, "id", "name", default)
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


-- SOFT or HARD
SoftOrHard = {
   { id = 0, name = "SOFT" },
   { id = 1, name = "HARD"},
}

function name_soft_hard(id)
   return choose_name(SoftOrHard, tonumber(id))
end

function select_soft_hard(name, default)
   return select_option(name, SoftOrHard, "id", "name", default)
end


--  HOST or SERVICE or APP
HostOrServiceOrApp = {
   { id = "all", name = strings.all},
   { id = "hst", name = strings.host },
   { id = "svc", name = strings.service},
   { id = "app", name = strings.application},
   { id = "ent", name = strings.entity},
}

function name_hst_svc_app(id)
   return choose_name(HostOrServiceOrApp, id, is_entity)
end

function select_hst_svc_app(name, default)
   return select_option(name, HostOrServiceOrApp, "id", "name", default)
end


--  HOST or SERVICE or APP
HostOrServiceOrAppOrEnt = {
   { id = "hst", name = strings.host },
   { id = "svc", name = strings.service},
   { id = "app", name = strings.application},
   { id = "ent", name = strings.entity},
}

function name_hst_svc_app_ent(id, is_entity)
   if is_entity == 1 then id = "ent" end
   return choose_name(HostOrServiceOrAppOrEnt, id, is_entity)
end

function select_hst_svc_app_ent(name, default)
   return select_option(name, HostOrServiceOrAppOrEnt, "id", "name", default)
end


-- OK or WARNING or CRITICAL or UNKNOWN
OkOrWarningOrCritialOrUnknown = {
   { id = -1,              name = strings.all },
   { id = APPLIC_OK,       name = applic_alert[APPLIC_OK].name },
   { id = APPLIC_WARNING,  name = applic_alert[APPLIC_WARNING].name },
   { id = APPLIC_CRITICAL, name = applic_alert[APPLIC_CRITICAL].name },
   { id = APPLIC_UNKNOWN,  name = applic_alert[APPLIC_UNKNOWN].name },
   { id = APPLIC_PENDING,  name = applic_alert[APPLIC_PENDING].name },
   { id = APPLIC_DISABLE,  name = applic_alert[APPLIC_DISABLE].name },
}

function name_ok_warning_critical_unknown(id)
   return choose_name(OkOrWarningOrCritialOrUnknown, tonumber(id))
end

function select_ok_warning_critical_unknown(name, default)
   return select_option(name, OkOrWarningOrCritialOrUnknown, "id", "name", default)
end


function choose_name(opts, id, is_entity)
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

function render_content_header(auth, name, add, list, edit, geotag, back)
   local myul = { li{ a{href='#', class='here', title="'"..name.."'", name} }, }

   myul[#myul+1] = li{ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" }

   if add then
      myul[#myul+1] = li{ a{ href=add, img{ src='/servdesk/pics/menu_add.png', title='Adicionar', alt='Adicionar'} } }
   else
      myul[#myul+1] = li{ img{ src='/servdesk/pics/menu_add_off.png'} }
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


   if type(auth) == "string" then
      myul[#myul+1] = li{ a{ href="#", auth }}
   else
      myul[#myul+1] = li{ 
         script{ type="text/javascript", entity_script1 },
         script{ type="text/javascript", entity_script2 },
         a {onclick='entity_window.show();', href='#modal_entity_content', 
            title=auth.session.glpiactive_entity_shortname, class='entity_select', 
            id='global_entity_select', auth.session.glpiactive_entity_shortname } }

      --DEBUG myul[#myul+1] = li{ Auth.make_entity_clause(auth) }
   end

   return div{ id='menu_navigate', div { id='c_ssmenu2', ul{ myul } } }
end



--[[
<div class='sep'></div><div id="tabspanel" class='center-h'></div>
<script type='text/javascript'> var tabpanel = new Ext.TabPanel({
            applyTo: 'tabspanel', activeTab: 0, deferredRender: false, autoTabs : true,
            width:950, enableTabScroll: true, resizeTabs: false, plain: true,
            renderTo: 'tabspanel', border: false,

            items: [{
                  title: 'Tab 1',
                  html: 'www.uol.com.br',
                  autoLoad: 'blank.html'
            },{
                  title: 'Tab 2',
                  html: 'www.google.com',
                  autoLoad: 'orb/login'
            }]

      });
</script>
]]
function render_tabs(t, active_tab)
   res = {}
   obj = {}

--[[
      autoTabs: true, 
      deferredRender: false, 
      renderTo: 'tabscontent', 
]]
   tab_config = [[ 
      applyTo: 'tabspanel', 
      activeTab: ]]..active_tab..[[, 
      width: 950, 
      enableTabScroll: true, 
      resizeTabs: false, 
      plain: true, 
      border: false, 
   ]]

   obj[#obj+1] = "var tabpanel = new Ext.TabPanel({ "..tab_config.." items: ["
   for i,v in ipairs(t) do
      obj[#obj+1] = "{ id: '"..i.."', title: '"..v.title.."', html: '"..v.html.."', autoLoad: '"..v.href.."' },"
--[[
      obj[#obj+1] = "{ id: '"..i.."', title: '"..v.title.."', autoLoad: { url: '"..v.href.."', \
                      scripts: true, nocache: true, params: '"..v.href.."'}, ".. 
                      listeners:{ // Force glpi_tab storage
                          beforeshow : function(panel){
                          /* clean content because append data instead of replace it : no more problem */
                          /* tabpanel.body.update(''); */
                          /* update active tab*/
                          Ext.Ajax.disableCaching = false;
                          Ext.Ajax.request({
                             url : '"..v.href.."',
                             success: function(objServerResponse){
                             //alert(objServerResponse.responseText);
                             }
                          });
                          }
                       }
                     },
]]

   end
   obj[#obj+1] = "] });"

   res[#res+1] = div{ class='sep' }
   res[#res+1] = div{ id="tabspanel", class='center-h' }
   res[#res+1] = script{ type='text/javascript', obj }
   --res[#res+1] = div { id='tabcontent' }
   --res[#res+1] = script{ type='text/javascript', "loadDefaultTab();" }

   return res
end

