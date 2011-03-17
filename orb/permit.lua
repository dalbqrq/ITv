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

$LANG['Menu'][0]="Computadores";
$LANG['Menu'][1]="Redes";
$LANG['Menu'][2]="Impressoras";
$LANG['Menu'][3]="Monitores";
$LANG['Menu'][4]="Softwares";
$LANG['Menu'][5]="Tickets";
$LANG['Menu'][6]="Relatórios";
$LANG['Menu'][11]="Preferências";
$LANG['Menu'][12]="Maintenance";
$LANG['Menu'][13]="Estatísticas";
$LANG['Menu'][14]="Usuários";
$LANG['Menu'][15]="Administração";
$LANG['Menu'][16]="Periféricos";
$LANG['Menu'][17]="Empréstimos";
$LANG['Menu'][18]="Ferramentas";
$LANG['Menu'][19]="Knowledge base";
$LANG['Menu'][20]="FAQ";
$LANG['Menu'][21]="Cartuchos";
$LANG['Menu'][22]="Contatos";
$LANG['Menu'][23]="Fornecedores";
$LANG['Menu'][24]="Informações comerciais";
$LANG['Menu'][25]="Contratos";
$LANG['Menu'][26]="Gerência";
$LANG['Menu'][27]="Documentos";
$LANG['Menu'][28]="Status";
$LANG['Menu'][29]="Planejamento";
$LANG['Menu'][30]="Logs";
$LANG['Menu'][31]="Simplified interface";
$LANG['Menu'][32]="Insumos";
$LANG['Menu'][33]="OCS-NG";
$LANG['Menu'][34]="Telefone";
$LANG['Menu'][35]="Perfis";
$LANG['Menu'][36]="Grupos";
$LANG['Menu'][37]="Entidades";
$LANG['Menu'][38]="Inventário";
$LANG['Menu'][39]="Gateway de e-mail";
$LANG['Menu'][40]="Favoritos";
$LANG['Menu'][41]="Direitos";


]]

-- views ------------------------------------------------------------

menu_itens = {
   { name="Monitor",
      submenu = {
      { column="", name="Visão", link="/orb/gviz/show" },
      { column="", name="Árvore", link="/orb/treeviz/show" },
      { column="", name="Aplicações", link="/orb/app" },
      { column="", name="Checagem", link="/orb/probe" },
      { column="", name="Tipo de Relacionamento", link="/orb/app_relat_types" },
      },
   },
   { name="ServiceDesk",
      submenu = {
      { column="", name="Central", link="/servdesk/front/central.php" },
      { column="", name="Ticket", link="/servdesk/front/ticket.php" },
      { column="", name="Estatística", link="/servdesk/front/stat.php" },
      },
   },
   { name="CMDB",
      submenu = {
      { column="", name="Computadores", link="/servdesk/front/computer.php" },
      { column="", name="Software", link="/servdesk/front/software.php" },
      { column="", name="Equip. de Redes", link="/servdesk/front/networkequipment.php" },
      { column="", name="Telefones", link="/servdesk/front/phone.php"  },
      { column="", name="Periféricos", link="/servdesk/front/peripheral.php" },
      { column="", name="Status", link="/servdesk/front/states.php" },
      },
   },
   { name="Gerência",
      submenu = {
      { column="", name="Relatórios", link="/servdesk/front/report.php" },
      { column="", name="Notas", link="/servdesk/front/reminder.php" },
      { column="", name="Base de Conhecimento", link="/servdesk/front/knowbaseitem.php" },
      { column="", name="Contatos", link="/servdesk/front/contact.php" },
      { column="", name="Fornecedores", link="/servdesk/front/supplier.php" },
      { column="", name="Orçamentos", link="/servdesk/front/budget.php" },
      { column="", name="Contratos", link="/servdesk/front/contract.php" },
      { column="", name="Documentos", link="/servdesk/front/document.php" },
      { column="", name="Empréstimos", link="/servdesk/front/reservationitem.php" },
      { column="", name="OCS-NG", link="/servdesk/front/ocsng.php?ocsservers_id=1" },
      },
   },
   { name="Administrar",
      submenu = {
      { column="", name="Usuários", link="/servdesk/front/user.php" },
      { column="", name="Grupos", link="/servdesk/front/group.php" },
      { column="", name="Entidades", link="/servdesk/front/entity.php" },
      { column="", name="Regras", link="/servdesk/front/rule.php" },
      { column="", name="Dicionários", link="/servdesk/front/dictionnary.php" },
      { column="", name="Perfis", link="/servdesk/front/profile.php" },
      { column="", name="Logs", link="/servdesk/front/event.php" },
      { column="", name="backup", link="/servdesk/front/backup.php" },
      },
   },
   { name="Configurar",
      submenu = {
      { column="", name="Dropdowns", link="/servdesk/front/dropdown.php" },
      { column="", name="Componentes", link="/servdesk/front/device.php" },
      { column="", name="Notificações", link="/servdesk/front/setup.notification.php" },
      { column="", name="Geral", link="/servdesk/front/config.form.php" },
      { column="", name="Ações Automáticas", link="/servdesk/front/crontask.php" },
      { column="", name="Autenticação", link="/servdesk/front/setup.auth.php" },
      { column="", name="Gateway de E-mail", link="/servdesk/front/mailcollector.php" },
      { column="", name="Modo OCS-NG", link="/servdesk/front/ocsserver.php" },
      { column="", name="Plugins", link="/servdesk/front/plugin.php" },
      },
   },
}


