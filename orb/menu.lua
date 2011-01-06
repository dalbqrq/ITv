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
      { name="Lógico", link="/orb/gviz/show" },
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
      { name="Base de Conhecimento", link="/servdesk/front/knowbaseitem.php" },
      { name="Fornecedores", link="/servdesk/front/supplier.php" },
      { name="Contratos", link="/servdesk/front/contract.php" },
      { name="Contatos", link="/servdesk/front/contact.php" },
      },
   },
   { name="Administrar", link="#",
      submenu = {
      { name="Login", link="/orb/login" },
      { name="Usuários", link="/servdesk/front/user.php" },
      { name="Grupos", link="/servdesk/front/group.php" },
      { name="Regras", link="/servdesk/front/rule.php" },
      { name="Logs", link="/servdesk/front/event.php" },
      { name="Comandos de Teste", link="/orb/checkcmd" },
      { name="Manutenção", link="/orb/system" },
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

