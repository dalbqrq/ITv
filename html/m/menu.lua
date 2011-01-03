
menu_itens = {
   { name="Monitor", link="/orb/gviz/show",
      submenu = {
      { name="Lógico", link="/orb/gviz/show" },
      { name="Físico", link="/orb/gviz/show" },
      { name="Aplicações", link="/orb/app" },
      { name="Objetos & Relacionamentos", link="/orb/app_objects" },
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

m=2
s=2

for i,v in ipairs(menu_itens) do
   local active = ""
   if i == m then active = "current" end
   print(i, active, v.name, v.link)
end

for i,v in ipairs(menu_itens[m].submenu) do
   local active = ""
   if i == m then active = "current" end
   print(i, active, v.name, v.link)
end



