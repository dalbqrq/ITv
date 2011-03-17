module("Auth", package.seeall)

-- COOKIES ------------------------------------------------------------------------------

function set_cookie(web, name, value, path, expiration)
   local expiration_date
   path = path or "/"
   if expiration then expiration_date = os.time() + expiration end

   -- Nao está funcionando com expiracao!
   --web:set_cookie("itvision", { value="foo", path=path, expires = expiration_date })
   web:set_cookie(name, { value=value, path=path })
end


function delete_cookie(web, name, value)
   web:delete_cookie(name, path)
end


function get_cookie(web, name)
   return web.cookies[name]
end


function show_cookie(web, name)
   local cookie = web.cookies[name]
   return "COOKIE: "..name.." - "..cookie, br()
end


-- GLPI ------------------------------------------------------------------------------
local glpi_cookie_name = "PHPSESSID"
local session_path = "/usr/local/servdesk/files/_sessions"


function is_logged_at_glpi(web)
   local is_logged, user_name, id, sess_, glpi_cookie
   local glpi_cookie = get_cookie(web, glpi_cookie_name) 

   if glpi_cookie == nil then
      return false
   end

   local file_name = session_path.."/sess_"..glpi_cookie

   --[[ 
       buscar em 'file_name' as strings abaixo 
           glpiID|s:1:"2";
           glpiname|s:5:"admin";
   ]]
   local sess_ = text_file_reader(file_name)
   local a, b, c, user_id = string.find(sess_, 'glpiID|s:(%d+):"(%d+)"')
   local d, e, f, user_name = string.find(sess_, 'glpiname|s:(%d+):"([%w-_%.]+)";')


   if user_name ~= nil then
      return { is_logged=true, user_name=user_name, user_id=user_id, session=sess_, cookie=glpi_cookie } 
   else
      return false
   end
end


function check(web)
   local auth = is_logged_at_glpi(web)

   if auth ~= false then
      return auth
   else
      web.prefix = "/orb"
      web:redirect(web:link("/login"))
      return false
   end
end


-- ITvision ------------------------------------------------------------------------------
local itvision_cookie_name = "ITvision"

function set_itvision_cookie(web, user_name)
    set_cookie(web, itvision_cookie_name, user_name)
end


function login_at_itvision(web, user_name, user_id)
   local value = user_id
   --local value = user_name
   set_cookie(web, itvision_cookie_name, value)
end


function is_logged_at_itvision(web, user_name)
   local cookie = get_cookie(web, itvision_cookie_name)
   local res = string.find(cookie, user_name)
end


function get_itvision_cookie(web)
   return get_cookie(web, itvision_cookie_name)
end

-- Authorization -------------------------------------------------------------------------
--[[
> desc glpi_profiles;
+---------------------------+--------------+------+-----+----------+----------------+
| Field                     | Type         | Null | Key | Default  | Extra          |
+---------------------------+--------------+------+-----+----------+----------------+
| id                        | int(11)      | NO   | PRI | NULL     | auto_increment |
| name                      | varchar(255) | YES  |     | NULL     |                |
| interface                 | varchar(255) | YES  | MUL | helpdesk |                |
| is_default                | tinyint(1)   | NO   | MUL | 0        |                |
| computer                  | char(1)      | YES  |     | NULL     |                |
| monitor                   | char(1)      | YES  |     | NULL     |                |
| software                  | char(1)      | YES  |     | NULL     |                |
| networking                | char(1)      | YES  |     | NULL     |                |
| printer                   | char(1)      | YES  |     | NULL     |                |
| peripheral                | char(1)      | YES  |     | NULL     |                |
| cartridge                 | char(1)      | YES  |     | NULL     |                |
| consumable                | char(1)      | YES  |     | NULL     |                |
| phone                     | char(1)      | YES  |     | NULL     |                |
| notes                     | char(1)      | YES  |     | NULL     |                |
| contact_enterprise        | char(1)      | YES  |     | NULL     |                |
| document                  | char(1)      | YES  |     | NULL     |                |
| contract                  | char(1)      | YES  |     | NULL     |                |
| infocom                   | char(1)      | YES  |     | NULL     |                |
| knowbase                  | char(1)      | YES  |     | NULL     |                |
| faq                       | char(1)      | YES  |     | NULL     |                |
| reservation_helpdesk      | char(1)      | YES  |     | NULL     |                |
| reservation_central       | char(1)      | YES  |     | NULL     |                |
| reports                   | char(1)      | YES  |     | NULL     |                |
| ocsng                     | char(1)      | YES  |     | NULL     |                |
| view_ocsng                | char(1)      | YES  |     | NULL     |                |
| sync_ocsng                | char(1)      | YES  |     | NULL     |                |
| dropdown                  | char(1)      | YES  |     | NULL     |                |
| entity_dropdown           | char(1)      | YES  |     | NULL     |                |
| device                    | char(1)      | YES  |     | NULL     |                |
| typedoc                   | char(1)      | YES  |     | NULL     |                |
| link                      | char(1)      | YES  |     | NULL     |                |
| config                    | char(1)      | YES  |     | NULL     |                |
| rule_ticket               | char(1)      | YES  |     | NULL     |                |
| entity_rule_ticket        | char(1)      | YES  |     | NULL     |                |
| rule_ocs                  | char(1)      | YES  |     | NULL     |                |
| rule_ldap                 | char(1)      | YES  |     | NULL     |                |
| rule_softwarecategories   | char(1)      | YES  |     | NULL     |                |
| search_config             | char(1)      | YES  |     | NULL     |                |
| search_config_global      | char(1)      | YES  |     | NULL     |                |
| check_update              | char(1)      | YES  |     | NULL     |                |
| profile                   | char(1)      | YES  |     | NULL     |                |
| user                      | char(1)      | YES  |     | NULL     |                |
| user_authtype             | char(1)      | YES  |     | NULL     |                |
| group                     | char(1)      | YES  |     | NULL     |                |
| entity                    | char(1)      | YES  |     | NULL     |                |
| transfer                  | char(1)      | YES  |     | NULL     |                |
| logs                      | char(1)      | YES  |     | NULL     |                |
| reminder_public           | char(1)      | YES  |     | NULL     |                |
| bookmark_public           | char(1)      | YES  |     | NULL     |                |
| backup                    | char(1)      | YES  |     | NULL     |                |
| create_ticket             | char(1)      | YES  |     | NULL     |                |
| delete_ticket             | char(1)      | YES  |     | NULL     |                |
| add_followups             | char(1)      | YES  |     | NULL     |                |
| group_add_followups       | char(1)      | YES  |     | NULL     |                |
| global_add_followups      | char(1)      | YES  |     | NULL     |                |
| global_add_tasks          | char(1)      | YES  |     | NULL     |                |
| update_ticket             | char(1)      | YES  |     | NULL     |                |
| update_priority           | char(1)      | YES  |     | NULL     |                |
| own_ticket                | char(1)      | YES  |     | NULL     |                |
| steal_ticket              | char(1)      | YES  |     | NULL     |                |
| assign_ticket             | char(1)      | YES  |     | NULL     |                |
| show_all_ticket           | char(1)      | YES  |     | NULL     |                |
| show_assign_ticket        | char(1)      | YES  |     | NULL     |                |
| show_full_ticket          | char(1)      | YES  |     | NULL     |                |
| observe_ticket            | char(1)      | YES  |     | NULL     |                |
| update_followups          | char(1)      | YES  |     | NULL     |                |
| update_tasks              | char(1)      | YES  |     | NULL     |                |
| show_planning             | char(1)      | YES  |     | NULL     |                |
| show_group_planning       | char(1)      | YES  |     | NULL     |                |
| show_all_planning         | char(1)      | YES  |     | NULL     |                |
| statistic                 | char(1)      | YES  |     | NULL     |                |
| password_update           | char(1)      | YES  |     | NULL     |                |
| helpdesk_hardware         | int(11)      | NO   |     | 0        |                |
| helpdesk_item_type        | text         | YES  |     | NULL     |                |
| helpdesk_status           | text         | YES  |     | NULL     |                |
| show_group_ticket         | char(1)      | YES  |     | NULL     |                |
| show_group_hardware       | char(1)      | YES  |     | NULL     |                |
| rule_dictionnary_software | char(1)      | YES  |     | NULL     |                |
| rule_dictionnary_dropdown | char(1)      | YES  |     | NULL     |                |
| budget                    | char(1)      | YES  |     | NULL     |                |
| import_externalauth_users | char(1)      | YES  |     | NULL     |                |
| notification              | char(1)      | YES  |     | NULL     |                |
| rule_mailcollector        | char(1)      | YES  |     | NULL     |                |
| date_mod                  | datetime     | YES  | MUL | NULL     |                |
| comment                   | text         | YES  |     | NULL     |                |
| validate_ticket           | char(1)      | YES  |     | NULL     |                |
| create_validation         | char(1)      | YES  |     | NULL     |                |
+---------------------------+--------------+------+-----+----------+----------------+

]]


-- views ------------------------------------------------------------

menu_itens_admin = {
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
      { name="Chamado", link="servdesk/front/helpdesk.public.php" },
      { name="Central", link="/servdesk/front/central.php" },
      { name="Ticket", link="/servdesk/front/ticket.php" },
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
--      { name="OCS-NG", link="/servdesk/front/ocsng.php?ocsservers_id=1" },
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
--[[
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
]]
}

--[[
   { name="Ajuda", link="/blank.html",
      submenu = { },
   },
]]


-- viewadmins ------------------------------------------------------------


menu_itens_normal = {
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
      { name="Ticket", link="/servdesk/front/ticket.php" },
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
--[[
      { name="OCS-NG", link="/servdesk/front/ocsng.php?ocsservers_id=1" },
]]
      },
   },
   { name="Administrar", link="#",
      submenu = {
      { name="Usuários", link="/servdesk/front/user.php" },
      { name="Grupos", link="/servdesk/front/group.php" },
--[[
      { name="Entidades", link="/servdesk/front/entity.php" },
      { name="Regras", link="/servdesk/front/rule.php" },
      { name="Dicionários", link="/servdesk/front/dictionnary.php" },
      { name="Perfis", link="/servdesk/front/profile.php" },
      { name="Logs", link="/servdesk/front/event.php" },
      { name="backup", link="/servdesk/front/backup.php" },
]]
      },
   },
--[[
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
]]
}

--[[
   { name="Ajuda", link="/blank.html",
      submenu = { },
   },
]]


-- views ------------------------------------------------------------

menu_itens_post_only = {
   { name="Monitor", link="/orb/gviz/show",
      submenu = {
      { name="Visão", link="/orb/gviz/show" },
      { name="Árvore", link="/orb/treeviz/show" },
      },
   },
   { name="ServiceDesk", link="#",
      submenu = {
      --{ name="Chamado", link="/servdesk/front/helpdesk.public.php" },
      { name="Central", link="/servdesk/front/central.php" },
      { name="Ticket", link="/servdesk/front/ticket.php" },
      { name="Empréstimos", link="/servdesk/front/reservationitem.php" },
      --{ name="FAQ", link="/servdesk/front/helpdesk.faq.php" },
      },
   },
--[[
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
      { name="Ticket", link="/servdesk/front/ticket.php" },
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
]]
}

--[[
   { name="Ajuda", link="/blank.html",
      submenu = { },
   },
]]


-- views ------------------------------------------------------------

menu_itens_super_admin = {
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
      { name="Ticket", link="/servdesk/front/ticket.php" },
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
}

--[[
   { name="Ajuda", link="/blank.html",
      submenu = { },
   },
]]


function get_menu_itens(profile)

   if profile == "admin" then
      return menu_itens_admin
   elseif profile == "post-only" then
      return menu_itens_post_only
   elseif profile == "normal" then
      return menu_itens_normal
   elseif profile == "super-admin" then
      return menu_itens_super_admin
   end

end


