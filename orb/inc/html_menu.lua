


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
	{ 1, "Monitor", "/fig1.html" },
	{ 2, "Lógico", "/fig1.html" },
	{ 2, "Físico", "/fig2.html" },
	{ 2, "Relatórios", "/blank.html" },
	{ 2, "Árvore", "/orb/app_tree" },
	{ 2, "Aplicações", "/orb/app" },
	{ 2, "Lista Aplicações", "/orb/app_object" },
	{ 2, "Relacionamento Aplicações", "/orb/app_relat" },
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
	{ 1, "Ajuda", "/blank.html" },
	{ 2, "iFrame", "/c.html" },
}

-- o parametro 'link_at_level_1' diz se o menu cujo nivel eh 1 serah tratado como um link
function make_menu(link_at_level_1) 
   local menu = {}
   local o_level = 0
   local s = ""

   for i, v in ipairs(menu_itens) do

      local level = v[1]
      local name  = v[2]
      local link  = v[3]

      if level == 0 or level == 2 then
         --<li><a href="./content.html" target="content">Home</a></li>
         s = s .. "\t\t<li><a href=\""..link.."\" target=\"content\">"..name.."</a></li>\n"
         if ( level == 0 or level == 1 ) and o_level == 2 then
            --</ul></li>
            s = s .. "\t\t</ul>\n\t</li>\n"
         end
      elseif level == 1 then
         -- <li><span class="dir">About Us</span> <ul>
         --   ou
         -- <li><a href="./" class="dir">Contact Us</a>
         if link_at_level_1 then
            s = s .. "<li><href=\""..link.."\" class=\"dir\">"..name.."</a></li>\n"
         else
            s = s .. "<li><span class=\"dir\">"..name.."</a></li>\n"
         end
      end

      o_level = level

   end

   return s

end

print( make_menu() )
