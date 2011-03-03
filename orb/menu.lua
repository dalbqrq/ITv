#!/usr/bin/env wsapi.cgi

-- includes & defs ------------------------------------------------------
require "Model"
require "View"
require "Auth"

module(Model.name, package.seeall,orbit.new)


-- models ------------------------------------------------------------

-- controllers ------------------------------------------------------------

function list(web, item, subitem)
   return render_list(web, item, subitem)
end
ITvision:dispatch_get(list, "/(%d+):(%d+)")


-- views ------------------------------------------------------------

menu_itens = {
   { name="Monitor", link="/orb/gviz/show",
      submenu = {
      { name="Visão", link="/orb/gviz/show" },
      { name="Árvore", link="/orb/treeviz/show" },
      { name="Aplicações", link="/orb/app" },
      { name="Checagem", link="/orb/probe" },
      { name="Tipo de Relacionamento", link="/orb/app_relat_types" },
      },
   },
   { name="ServiceDesk", link="/servdesk/front/central.php",
      submenu = {
      { name="Central", link="/servdesk/front/central.php" },
      { name="ticket", link="/servdesk/front/ticket.php" },
      { name="Estatística", link="/servdesk/front/stat.php" },
      },
   },
   { name="CMDB", link="#",
      submenu = {
      { name="Computadores", link="/servdesk/front/computer.php" },
      { name="Software", link="/servdesk/front/software.php" },
      { name="Equip. de Redes", link="/servdesk/front/networkequipment.php" },
      { name="Telefones", link="/servdesk/front/phone.php"  },
      { name="Periféricos", link="/servdesk/front/peripheral.php" },
      { name="Status", link="/servdesk/front/states.php" },
      },
   },
   { name="Gerência", link="#",
      submenu = {
      { name="Relatórios", link="/servdesk/front/report.php" },
      { name="Notas", link="/servdesk/front/reminder.php" },
      { name="Base de Conhecimento", link="/servdesk/front/knowbaseitem.php" },
      { name="Contatos", link="/servdesk/front/contact.php" },
      { name="Fornecedores", link="/servdesk/front/supplier.php" },
      { name="Orçamentos", link="/servdesk/front/budget.php" },
      { name="Contratos", link="/servdesk/front/contract.php" },
      { name="Documentos", link="/servdesk/front/document.php" },
      { name="Empréstimos", link="/servdesk/front/reservationitem.php" },
      { name="OCS-NG", link="/servdesk/front/ocsng.php?ocsservers_id=1" },
      },
   },
   { name="Administrar", link="#",
      submenu = {
      { name="Usuários", link="/servdesk/front/user.php" },
      { name="Grupos", link="/servdesk/front/group.php" },
      { name="Entidades", link="/servdesk/front/entity.php" },
      { name="Regras", link="/servdesk/front/rule.php" },
      { name="Dicionários", link="/servdesk/front/dictionnary.php" },
      { name="Perfis", link="/servdesk/front/profile.php" },
      { name="Logs", link="/servdesk/front/event.php" },
      { name="backup", link="/servdesk/front/backup.php" },
      },
   },
   { name="Configurar", link="#",
      submenu = {
      { name="Dropdowns", link="/servdesk/front/dropdown.php" },
      { name="Componentes", link="/servdesk/front/device.php" },
      { name="Notificações", link="/servdesk/front/setup.notification.php" },
      { name="Geral", link="/servdesk/front/config.form.php" },
      { name="Ações Automáticas", link="/servdesk/front/crontask.php" },
      { name="Autenticação", link="/servdesk/front/setup.auth.php" },
      { name="Gateway de E-mail", link="/servdesk/front/mailcollector.php" },
      { name="Modo OCS-NG", link="/servdesk/front/ocsserver.php" },
      { name="Plugins", link="/servdesk/front/plugin.php" },
      },
   },
   { name="Ajuda", link="/blank.html",
      submenu = { },
   },
}



function render_menu(web, item, subitem)
   item    = tonumber(item)
   subitem = tonumber(subitem)
   local itens, subitens = {}, {}
   local js = "javascript:void(0);"

   local islog, user_name, id = Auth.is_logged_at_glpi(web)

   if islog == false or ( item == 0 and subitem == 0 ) then
      return ""
   end

   for i,v in ipairs(menu_itens) do
      local active = ""
      if i == item then active = "current" end
      itens[#itens+1] = li{ a{ class=active, href=js, onClick="changeHead('/orb/menu/"..i..":1')", v.name } }
   end
   itens[#itens+1] = li{ a{ class="logout", href=js, onClick="changePage('/orb/menu/0:0', '/orb/login/logout')", 
                            "Logout: "..user_name } }

   for i,v in ipairs(menu_itens[item].submenu) do
      local active = ""
      if i == subitem then active = "current" end
      subitens[#subitens+1] = li{ a{ class=active, href=js, onClick="changePage('/orb/menu/"..item..":"..i.."','"..v.link.."')", 
                                     v.name } }
   end

   return { ul{ id="tablist", itens }, ul{ id="subtablist", subitens } }
end


function render_list(web, item, subitem)
   return render_menu_frame(render_menu(web, item, subitem))
end


orbit.htmlify(ITvision, "render_.+")

return _M

