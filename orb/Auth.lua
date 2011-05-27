module("Auth", package.seeall)

require "Glpi"
require "App"

-- COOKIES ------------------------------------------------------------------------------

function set_cookie(web, name, value, path, expiration)
   local expiration_date
   path = path or "/"
   if expiration then expiration_date = os.time() + expiration end

   -- Nao está funcionando com expiracao!
   --web:set_cookie("itvision", { value="foo", path=path, expires = expiration_date })
   web:set_cookie(name, { value=value, path=path })
end


function delete_cookie(web, name, path)
   path = path or "/"
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


function logout(web)
   --[[ Nao grava profile: 
   local glpi_cookie = get_cookie(web, glpi_cookie_name) 
   local prof_filename = session_path.."/prof_"..glpi_cookie..".lua"
   remove_file(prof_filename)
   ]]
end


--[[
   Veja no final deste arquivo um exemplo da tabela criada a partir do arquivo de sessao do glpi
   que contem informacoes extridas do arquivo de sessao do glpi contendo o profile do usuário logado
]]
function is_logged_at_glpi(web)
   local is_logged, user_name, id, sess_, glpi_cookie
   local glpi_cookie = get_cookie(web, glpi_cookie_name) 

   if glpi_cookie == nil then
      return false
   end

   local sess_filename = session_path.."/sess_"..glpi_cookie
   local sess_ = text_file_reader(sess_filename)
   if not sess_ then return false end
   local session_prof_ = get_profile(sess_)

   local prof_filename = session_path.."/prof_"..glpi_cookie..".lua"
   text_file_writer(prof_filename, table.dump(session_prof_))

   --[[ 
       buscar em 'sess_filename' as strings abaixo 
           glpiID|s:1:"2";
           glpiname|s:5:"admin"; 
           glpiactive_entity|s:1:"3";
           glpiactiveprofile|a:88:{s:2:"id";s:1:"2";
   ]]
   local _, _, _, user_id = string.find(sess_, 'glpiID|s:(%d+):"(%d+)"')
   local _, _, _, user_name = string.find(sess_, 'glpiname|s:(%d+):"([%w-_%.]+)";')
   local _, _, _, entity_id = string.find(sess_, 'glpiactive_entity|s:(%d+):"(%d+)";')
   local _, _, _, _, _, profile_id = string.find(sess_, 'glpiactiveprofile|a:(%d+):{s:(%d+):"id";s:(%d+):"(%d+)";')

   local profile 
   if profile_id then profile = Glpi.select_profile(profile_id) end

   if user_id then
      return { is_logged=true, user_id=user_id, user_name=user_name, profile_id=profile_id,
               entity_id=entity_id, cookie=glpi_cookie, profile=profile, session=session_prof_, entities=session_prof_.glpiactiveentities }
   else
      return false
   end
end


-- Verifica se usuario estah logado
function check(web)
   local auth = is_logged_at_glpi(web)

   if auth then
      return auth
   else
      return false
   end
end


function redirect(web)
   web.prefix = "/orb"
   return false, web:redirect(web:link("/login"))
end


-- Verifica se usuario tem permissao de acesso à determinada página
-- O parametro 'field' eh fornecido pela pagina que estah tentado ser acessada
function check_permission(web, field, redirect_if_not_write_perm)
   local auth = check(web)

   if not auth.profile[field] or ( redirect_if_not_write_perm and auth.profile[field] == "r"  ) then
      web.prefix = "/"
      web:redirect(web:link("denied.html"))
      return "FALSE"
   else
      return auth.profile[field], auth
   end
end


-- 'entity_list' deve ser o resultado da chamada do metodo 'Auth.make_entity_clause(Auth.check(web))'
-- onde web é recebido pelo Orbit por um dos metodos do tipo controler.
-- Este metodo é usado para dar autorizacao para a visualizacao de uma aplicacao.
function check_entity_permission(web, app_id)
   if app_id then
      --local entity_auth = make_entity_clause(check(web))
      local auth = check(web)
      if auth then
         local entity_auth = make_entity_clause(auth)
         local cond_ = "id = "..app_id.." and entities_id in "..entity_auth
         local app = App.select_app(cond_)

         if app[1] then return true end
     end
   else
     web.prefix = "/orb/no_permission"
     return web:redirect(web:link("/"))
   end
end


function get_phpuserid()
   local cmd = "/usr/bin/php /usr/local/servdesk/inc/getuserid.php"
   return os.capture(cmd)
end


-- Extrai as conficuracoes da string no arquivo de sessao criado pelo glpi
function string.strip(s,is_array)
   local res = {}
   local cnt = 0
   local l, t, v, b

   while true do
      if not s then break end
      if not is_array then 
         _, _, l, t, v = string.find(s, "glpi([_%w]+)|(%a):(.+)")
      else
         _, _, t, v = string.find(s, "(%a)[:;](.+)")
      end

      if t == "N" then -- nil
         _, _, v, s = string.find(v,";(.+)")
         v = nil
      elseif t == "s" then -- string
         _, _, _, v, s = string.find(v,"(%d+):\"([^;]+)\";(.+)")
      elseif t == "a" then -- array
          _, _, _, v, s = string.find(v,"(%d+):(%b{})(.*)")
         v = string.strip(v,true)
      elseif t == "i" then -- inteiro
         _, _, v, s = string.find(v,"(%d*);(.+)")
      elseif t == "b" then -- boolean
         _, _, v, s = string.find(v,"(%d);(.+)")
      else
         break
      end
 
      if not is_array then 
         res["glpi"..l] = v
      else
         if cnt == 0 then
            cnt = cnt + 1
            --if tonumber(v) then b = "["..v.."]" else b = v end
            b = v
         else
            cnt = 0
            res[b] = v
         end
      end
   end

   return res
end


function get_profile(s)
   return string.strip(s)
end


function make_entity_clause(auth)
   local clause = ""

   for i,v in pairs(auth.session.glpiactiveentities) do
      if clause == "" then clause = "(" else clause = clause..", " end
      clause = clause..tonumber(v)
   end
   clause = clause..") "

   return clause
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

menu_itens = {
   { name="Monitor", link="#",
      submenu = {
      { name="Árvore", field="application", link="/orb/treeviz/show" },
      { name="Visão", field="application", link="/orb/gviz/show" },
      { name="Aplicações", field="application", link="/orb/app" },
      { name="Monitoração", field="checkcmds", link="/orb/app_monitor" },
      { name="Checagem", field="checkcmds", link="/orb/probe" },
      { name="Tipo de Relacionamento", field="app_relat_type", link="/orb/app_relat_types" },
      },
   },
   { name="ServiceDesk", link="#",
      submenu = {
      { name="Central", field=nil, link="/servdesk/front/central.php" },
      { name="Ticket", field=nil, link="/servdesk/front/ticket.php" },
      { name="Estatística", field=nil, link="/servdesk/front/stat.php" },
      },
   },
   { name="CMDB", link="#",
      submenu = {
      { name="Computadores", field="computer", link="/servdesk/front/computer.php" },
      { name="Redes", field="networking", link="/servdesk/front/networkequipment.php" },
      { name="Software", field="software", link="/servdesk/front/software.php" },
      { name="Telefones", field="phone", link="/servdesk/front/phone.php"  },
      { name="Periféricos", field="peripheral", link="/servdesk/front/peripheral.php" },
      { name="Status", field=nil, link="/servdesk/front/states.php" },
      },
   },
   { name="Gerência", link="#",
      submenu = {
      { name="Relatórios", field="reports", link="/servdesk/front/report.php" },
      { name="Notas", field="notes", link="/servdesk/front/reminder.php" },
      { name="Base de Conhecimento", field="knowbase", link="/servdesk/front/knowbaseitem.php" },
      { name="Contatos", field="contract", link="/servdesk/front/contact.php" },
      { name="Fornecedores", field="contact_enterprise", link="/servdesk/front/supplier.php" },
      { name="Contratos", field="contact_enterprise", link="/servdesk/front/contract.php" },
      { name="Orçamentos", field="budget", link="/servdesk/front/budget.php" },
      { name="Documentos", field="documents", link="/servdesk/front/document.php" },
      { name="Empréstimos", field="reservation_helpdesk", link="/servdesk/front/reservationitem.php" },
      { name="OCS-NG", field="ocsng", link="/servdesk/front/ocsng.php?ocsservers_id=1" },
      },
   },
   { name="Administrar", link="#",
      submenu = {
      { name="Usuários", field="user", link="/servdesk/front/user.php" },
      { name="Grupos", field="group", link="/servdesk/front/group.php" },
      { name="Entidades", field="entity", link="/servdesk/front/entity.php" },
      --{ name="Regras", field={ "rule_ticket", "entity_rule_ticket", "rule_ocs", "rule_ldap" }, link="/servdesk/front/rule.php" },
      --{ name="Dicionários", field={"rule_dictionnary_software", "rule_dictionnary_dropdown" }, link="/servdesk/front/dictionnary.php" },
      { name="Perfis", field="profile", link="/servdesk/front/profile.php" },
      { name="Logs", field="logs", link="/servdesk/front/event.php" },
      { name="Backup", field="backup", link="/servdesk/front/backup.php" },
      },
   },
   { name="Configurar", link="#",
      submenu = {
      { name="Dropdowns", field="dropdown", link="/servdesk/front/dropdown.php" },
      { name="Componentes", field="device", link="/servdesk/front/device.php" },
      { name="Notificações", field="notification", link="/servdesk/front/setup.notification.php" },
      { name="Geral", field="config", link="/servdesk/front/config.form.php" },
      { name="Ações Automáticas", field="config", link="/servdesk/front/crontask.php" },
      { name="Autenticação", field="config", link="/servdesk/front/setup.auth.php" },
      { name="Gateway de E-mail", field="config", link="/servdesk/front/mailcollector.php" },
      { name="Modo OCS-NG", field="config", link="/servdesk/front/ocsserver.php" },
      { name="Plugins", field="config", link="/servdesk/front/plugin.php" },
      },
   },
   { name="Ajuda", link="#",
      submenu = {
      { name="Sobre", link="/orb/about" },
      }, 
   },
}


function get_menu_itens(profile)
   local m = {}
   local k = 0

   for i, v in ipairs(menu_itens) do
      local s = {}
      for j,w in ipairs(v.submenu) do
         if type(w.field) == "string" and profile[w.field] then
            table.insert(s,w)
         elseif type(w.field) == "table" then
            local inc = nil
            for _,z in ipairs(w.field) do
               if z and profile[z] then inc = true end
            end
            if inc then
               table.insert(s,w)
            end
         elseif w.field == nil then
            table.insert(s,w)
         else
            --DEBUG: table.insert(s,w)
         end
      end
      if s[1] then 
         k = k+1
         table.insert(m, k, {})
         m[k].name = v.name
         m[k].link = "#"
         m[k].submenu = s
      end
   end
   return m
end



--[[

Tabela com informacoes extridaos do arquivo de sessao do glpi contendo o profile do usuário logado

{
   glpilanguage = "pt_BR",
   glpinumber_format = "2",
   glpisearchcount =    {
      Profile = 1,
      Computer = 1,
   }
   glpiis_categorized_soft_expanded = "1",
   glpi_currenttime = "2011-03-23 13:24:09",
   glpi_plugins =    {
   }
   glpiextauth = 0,
   glpiis_not_categorized_soft_expanded = "1",
   glpisearchcount2 =    {
      Profile = 0,
      Computer = 0,
   }
   glpiusers_idisation = 1,
   glpitask_private = "0",
   glpipriority_6 = "#ff5555",
   glpipriority_4 = "#ffbfbf",
   glpipriority_2 = "#ffe0e0",
   glpidate_format = "0",
   glpifollowup_private = "0",
   glpiis_ids_visible = "0",
   glpidefault_entity = "0",
   glpimassiveactionselected =    {
   }
   glpilisturl =    {
      Profile = "Computer",
      DeviceControl = "DeviceGraphicCard",
      DeviceMotherboard = "DeviceProcessor",
      DeviceMemory = "DeviceHardDrive",
      DeviceCase = "DevicePowerSupply",
      DeviceSoundCard = "DevicePci",
      DeviceNetworkCard = "DeviceDrive",
   }
   glpirealname = "",
   glpishow_jobs_at_login = "1",
   glpi_tabs =    {
      profile = "-1",
      computer = "1",
   }
   glpiactive_entity_name = "Entidade raiz (Estrutura da árvore)",
   glpilisttitle =    {
      DeviceSoundCard = "Computador = localhost",
      DeviceMotherboard = "Computador = localhost",
      DeviceCase = "Computador = localhost",
      DevicePowerSupply = "Computador = localhost",
      DevicePci = "Computador = localhost",
      DeviceHardDrive = "Computador = localhost",
      Profile = "Lista",
      DeviceDrive = "Computador = localhost",
      DeviceControl = "Computador = localhost",
      DeviceProcessor = "Computador = localhost",
      DeviceMemory = "Computador = localhost",
      Computer = "Lista",
      DeviceNetworkCard = "Computador = localhost",
      DeviceGraphicCard = "Computador = localhost",
   }
   glpilist_limit = "20",
   glpiactiveprofile =    {
      contract = "w",
      monitor = "w",
      is_default = "0",
      update_ticket = "1",
      global_add_tasks = "1",
      reservation_helpdesk = "1",
      steal_ticket = "1",
      reminder_public = "w",
      bookmark_public = "w",
      typedoc = "w",
      document = "w",
      reservation_central = "w",
      user_authtype = "w",
      knowbase = "w",
      peripheral = "w",
      printer = "w",
      interface = "central",
      view_ocsng = "r",
      rule_ldap = "w",
      link = "w",
      config = "w",
      show_planning = "1",
      check_update = "r",
      computer = "w",
      search_config = "w",
      search_config_global = "w",
      networking = "w",
      observe_ticket = "1",
      entity_dropdown = "w",
      logs = "r",
      helpdesk_hardware = "3",
      contact_enterprise = "w",
      show_assign_ticket = "1",
      infocom = "w",
      statistic = "1",
      device = "w",
      helpdesk_status = "N",
      update_tasks = "1",
      profile = "w",
      consumable = "w",
      name = "super-admin",
      rule_softwarecategories = "w",
      show_full_ticket = "1",
      helpdesk_item_type =       {
         "Software",
         "Phone",
         "Computer",
      }
      password_update = "1",
      show_all_planning = "1",
      cartridge = "w",
      group = "w",
      show_group_planning = "1",
      own_ticket = "1",
      faq = "w",
      group_add_followups = "1",
      assign_ticket = "1",
      ocsng = "w",
      entity_rule_ticket = "w",
      entity = "w",
      rule_ticket = "r",
      update_followups = "1",
      update_priority = "1",
      backup = "w",
      notes = "w",
      show_all_ticket = "1",
      user = "w",
      id = "4",
      global_add_followups = "1",
      rule_ocs = "w",
      reports = "r",
      add_followups = "1",
      dropdown = "w",
      transfer = "w",
      phone = "w",
      create_ticket = "1",
      sync_ocsng = "w",
      software = "w",
      delete_ticket = "1",
   }
   glpi_multientitiesmode = 0,
   glpiactiveentities_string = "'0'",
   glpisearch =    {
      Profile =       {
         distinct = "N",
         link =          {
         }
         order = "ASC",
         contains2 =          {
            "",
         }
         searchtype2 = "",
         field2 =          {
            "view",
         }
         itemtype2 = "",
         is_deleted = 0,
         sort = 1,
         link2 =          {
         }
         start = 0,
         contains =          {
            "",
         }
         searchtype =          {
            "contains",
         }
         field =          {
            "view",
         }
      }
      Computer =       {
         distinct = "N",
         link =          {
         }
         order = "ASC",
         contains2 =          {
            "",
         }
         searchtype2 = "",
         field2 =          {
            "view",
         }
         itemtype2 = "",
         is_deleted = 0,
         sort = 1,
         link2 =          {
         }
         start = 0,
         contains =          {
            "",
         }
         searchtype =          {
            "contains",
         }
         field =          {
            "view",
         }
      }
   }
   glpishowallentities = 1,
   glpicrontimer = 1300897445,
   glpiname = "admin",
   glpipriority_1 = "#fff2f2",
   glpiauthtype = "1",
   glpiactive_entity_shortname = "Entidade raiz (Estrutura da árvore)",
   glpilistitems =    {
      DeviceSoundCard =       {
      }
      DeviceMotherboard =       {
      }
      DeviceCase =       {
      }
      DevicePowerSupply =       {
      }
      DevicePci =       {
      }
      DeviceHardDrive =       {
      }
      Profile =       {
         "2",
         "1",
         "4",
         "3",
      }
      DeviceDrive =       {
      }
      DeviceControl =       {
      }
      DeviceProcessor =       {
      }
      DeviceMemory =       {
      }
      Computer =       {
         "1",
      }
      DeviceNetworkCard =       {
      }
      DeviceGraphicCard =       {
      }
   }
   glpiactive_entity = 0,
   glpi_use_mode = "0",
   glpiparententities_string = "",
   glpiroot = "/servdesk",
   glpiparententities =    {
   }
   glpigroups =    {
   }
   glpiactiveentities =    {
      0,
   }
   glpiID = "2",
   glpiprofiles =    {
      4 =       {
         name = "super-admin",
         entities =          {
            0 =             {
               id = "0",
               name = "N",
            }
         }
      }
   }
   glpiuse_flat_dropdowntree = "0",
   glpidropdown_chars_limit = "50",
   glpipriority_5 = "#ffadad",
   glpipriority_3 = "#ffcece",
   glpidefault_requesttypes_id = "1",
}


]]
