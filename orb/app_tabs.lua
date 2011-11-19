#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Auth"
require "Model"
require "Resume"
require "View"
require "util"

module(Model.name, package.seeall,orbit.new)

local apps = Model.itvision:model "apps"


-- models ------------------------------------------------------------

-- Esta funcao recebe um ou outro parametro, nunca os dois
function apps:select(id, obj_id)
   local clause = ""
   if id then clause = "id = "..id end
   if obj_id then clause = "service_object_id = "..obj_id end
   return Model.query("itvision_apps", clause)
end



-- controllers ------------------------------------------------------------

function list(web, app_id, active_tab, no_menu, msg)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end

   return render_list(web, app_id, active_tab, msg)
end
ITvision:dispatch_get(list, "/(%d+):(%d+)", "/list/(%d+):(%d+)", "/list/(%d+):(%d+):(.+)")

ITvision:dispatch_static("/css/%.css", "/script/%.js")


-- views ------------------------------------------------------------


function render_list(web, app_id, active_tab, no_menu, msg)
   local auth = Auth.check(web)
   if not auth then return Auth.redirect(web) end
   local res, t = {}, {}
   local A = apps:select(app_id)

   if msg then msg = ":"..msg else msg = "" end
   no_menu = no_menu or false
   active_tab = active_tab or 1


   if A[1].service_object_id then
   t = { 
      { title="Principal", html="", href="/orb/app/show/"..app_id },
      { title="Objetos", html="", href="/orb/app_objects/add/"..app_id..msg }, 
      { title="Relacionamentos", html="", href="/orb/app_relats/add/"..app_id }, 
      { title="Contatos", html="", href="/orb/app_contacts/add/"..app_id }, 
      { title="Grafo", html="", href="/orb/gviz/show/"..app_id..":1" }, 
      { title="Status", html="", href="/orb/app_info/1:"..A[1].service_object_id },
      { title="Histórico", html="", href="/orb/app_info/2:"..A[1].service_object_id },
   }
   else
   t = { 
      { title="Principal", html="", href="/orb/app/show/"..app_id },
      { title="Objetos", html="", href="/orb/app_objects/add/"..app_id..msg }, 
      { title="Relacionamentos", html="", href="/orb/app_relats/add/"..app_id }, 
      { title="Contatos", html="", href="/orb/app_contacts/add/"..app_id }, 
      { title="Visão Gráfica", html="", href="/orb/gviz/show/"..app_id..":1" }, 
   }
   end

--[[ TODO: incluir navegacao de apps. segue o html usago pelo glpi para computers
   <div id='menu_navigate'>
   <ul>
      <li>
         <a href="javascript:showHideDiv('tabsbody','tabsbodyimg','/servdesk/pics/deplier_down.png','/servdesk/pics/deplier_up.png')">
         <img alt='' name='tabsbodyimg' src="/servdesk/pics/deplier_up.png"> </a>
      </li>
      <li>
         <a href="/servdesk/front/computer.php">Lista </a>&nbsp;:&nbsp;
      </li>
      <li>
         <a href='/servdesk/front/computer.form.php?id=5&amp;withtemplate='>
         <img src="/servdesk/pics/first.png" alt='Primeiro' title='Primeiro'> </a>
      </li>
      <li>
         <a href='/servdesk/front/computer.form.php?id=2&amp;withtemplate='>
         <img src="/servdesk/pics/left.png" alt='Anterior' title='Anterior'> </a>
      </li>
      <li>
         3/5
      </li>
      <li>
         <a href='/servdesk/front/computer.form.php?id=1&amp;withtemplate='>
         <img src="/servdesk/pics/right.png" alt='Próximo' title='Próximo'> </a>
      </li>
      <li>
         <a href='/servdesk/front/computer.form.php?id=3&amp;withtemplate='>
         <img src="/servdesk/pics/last.png" alt='Último' title='Último'> </a>
      </li>
   </ul>
   </div>
]]


   if no_menu == false then
      res[#res+1] = render_resume(web)
      web.prefix = "/orb/app"
      res[#res+1] = render_content_header(auth.session.glpiactive_entity_shortname, strings.application, web:link("/add"), 
         web:link("/list"))
   end

   -- inicio da implementacao da navegacao pelas apps
   res[#res+1] = div{ id="menu_navigate", ul{ 
      li{ a{ href="javascript:showHideDiv('tabsbody','tabsbodyimg','/servdesk/pics/deplier_down.png','/servdesk/pics/deplier_up.png')",
             img{ alt='', name='tabsbodyimg', src="/servdesk/pics/deplier_up.png" } } },
      li{ a{ href=web:link("/"), "Lista" }, "&nbsp;:&nbsp;" } 
   } }

   res[#res+1] = render_tabs(t, active_tab)

   return render_layout(res)
end


orbit.htmlify(ITvision, "render_.+")

return _M


