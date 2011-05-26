module("Glpi", package.seeall)

require "Auth"
require "util"

----------------------------- PROFILES ----------------------------------

function select_profile(profile_id)
   local content = query ("glpi_profiles", "id = "..profile_id)
   return content[1]
end



----------------------------- COMPUTERS ----------------------------------

function select_computers (cond_, extra_, columns_) 
   local content = query ("glpi_computers", cond_, extra_, columns_)
   return content
end


--[[ 

Um Item de Configuracao (IC) pode ser de um dos seguites tipos (parametro 'type_')

TIPOS DE NETWORDPORTS:
   Computer
   Phone
   Peripheral
   NetworkEquipment

]]

function select_ci_ports (type_, cond_, extra_, columns_)
   local itemtype, content, tables_
   if cond_ ~= nil and cond_ ~= "" then cond_ = " and "..cond_ else cond_ = "" end

   --[[ CAMPOS RETORNADOS

   -- Computers
    c.id                as c_id,
    c.entities_id       as c_entities_id,
    c.name              as c_name,
    c.users_id_tech     as c_users_id_tech,
    c.comment           as c_comment,
    c.locations_id      as c_locations_id,
    c.states_id         as c_states_id,

   -- Networkports
    n.itemtype		as n_itemype
    n.logical_number	as n_logical_number
    n.name		as n_name
    n.ip		as n_ip

]]

   columns_ = [[ c.id as c_id,
         c.entities_id as c_entities_id,
         c.name as c_name,
         c.users_id_tech as c_users_id_tech,
         c.comment as c_comment,
         c.locations_id as c_locations_id,
         c.states_id as c_states_id,
         n.itemtype as n_itemtype,
         n.logical_number as n_logical_number,
         n.name as n_name,
         n.ip as n_ip

   ]]


   if type_ == "Phone" then
      itemtype = " and n.itemtype = 'Phone'"
      tables_ = "glpi_phones c, glpi_networkports n "

   elseif type_ == "Peripheral" then
      itemtype = " and n.itemtype = 'Peripheral'"
      tables_ = "glpi_peripherals c, glpi_networkports n "

   elseif  type_ == "NetworkEquipment"  then
      itemtype = " and n.itemtype = 'NetworkEquipment'"
      tables_ = "glpi_networkequipments c, glpi_networkports n "

   else  -- Default item eh 'Computer'
      itemtype = " and n.itemtype = 'Computer'"
      tables_ = "glpi_computers c, glpi_networkports n "

   end

   content = query (tables_, "c.id = n.items_id "..cond_..itemtype, extra_, columns_)
   return content
end


----------------------------- SOFTWARES ----------------------------------


function select_computer_software (cond_)
   if cond_ then cond_ = cond_.." and " else cond_ = "" end
   cond_ = cond_.." c.id = csv.computers_id and csv.softwareversions_id = sv.id and sv.softwares_id = s.id"
   cond_ = cond_.." and c.is_template = 0 and s.is_template = 0 and c.is_deleted = 0 and s.is_deleted = 0 "

   local tables_ = "glpi_computers c, glpi_computers_softwareversions csv, glpi_softwareversions sv, glpi_softwares s"

   --[[ CAMPOS RETORNADOS

   -- Computers
    c.id 		as c_id,
    c.entities_id 	as c_entities_id,
    c.name 		as c_name,
    c.users_id_tech 	as c_users_id_tech,
    c.comment 	 	as c_comment,
    c.locations_id  	as c_locations_id,
    c.states_id 	as c_states_id,

   -- SoftwareVersion
    sv.id 		as sv_id,
    sv.states_id 	as sv_states_id,
    sv.name 		as sv_name,
    sv.comment 		as sv_comment,
   
   -- Software
    s.id 		as s_id,
    s.name 		as s_name,
    s.comment 		as s_comment,
    s.users_id_tech	as s_users_id_tech,

]]

   columns_ = [[ c.id as c_id,
         c.entities_id as c_entities_id,
         c.name as c_name,
         c.users_id_tech as c_users_id_tech,
         c.comment as c_comment,
         c.locations_id as c_locations_id,
         c.states_id as c_states_id,
         sv.id as sv_id,
         sv.states_id as sv_states_id,
         sv.name as sv_name,
         sv.comment as sv_comment,
         s.id as s_id,
         s.name as s_name,
         s.comment as s_comment,
         s.users_id_tech as s_users_id_tech ]]

   local content = query ( tables_, cond_, extra_, columns_)
   return content
end


function select_computer_software_port (cond_)
   if cond_ then cond_ = cond_.." and " else cond_ = "" end
   cond_ = cond_.." c.id = n.item_id and c.id = csv.computers_id and csv.softwareversions_id = sv.id \
                  and sv.softwares_id = s.id"

   local tables_ = "glpi_computers c, glpi_networkports n, glpi_computers_softwareversions csv, \
                  glpi_softwareversions sv, glpi_softwares s"

   local columns_ = "*"

   local content = query ( tables_, cond_, extra_, columns_)
   return content
end



function select_contacts_in_app (id)
   local cond_ = " u.id = c.user_id and a.id = c.app_id "
   if id then cond_ = cond_.." and a.id = "..id end
   local tables_ = "glpi_users u, itvision_app_contacts c, itvision_apps a"
   local columns_ = "u.name as name, u.firstname as firstname, u.realname as realname, u.email as email, a.id as app_id, u.id as user_id"

   local content = query ( tables_, cond_, extra_, columns_)
   return content
end



function select_contacts_not_in_app (id)
   local cond_ = " "
   if id then cond_ = cond_.." id not in (select user_id from itvision_app_contacts where app_id = "..id..")" end
   local tables_ = "glpi_users u"
   local extra_ = "order by u.name"
   local columns_ = "*"

   local content = query ( tables_, cond_, extra_, columns_)
   return content
end



function select_viewers_in_app (id)
   local cond_ = " u.id = v.user_id and a.id = v.app_id "
   if id then cond_ = cond_.." and a.id = "..id end
   local tables_ = "glpi_users u, itvision_app_viewers v, itvision_apps a"
   local extra_ = "order by u.name"
   local columns_ = "u.name as name, u.firstname as firstname, u.realname as realname, u.email as email, a.id as app_id, u.id as user_id"

   local content = query ( tables_, cond_, extra_, columns_)
   return content
end



function select_viewers_not_in_app (id)
   local cond_ = " "
   if id then cond_ = cond_.." id not in (select user_id from itvision_app_viewers where app_id = "..id..")" end
   local tables_ = "glpi_users u"
   local extra_ = "order by u.name"
   local columns_ = "*"

   local content = query ( tables_, cond_, extra_, columns_)
   return content
end


function select_app_by_contact (user_id)
   local cond_ = " u.id = c.user_id and a.id = c.app_id and u.id = "..user_id
   local tables_ = "glpi_users u, itvision_app_contacts c, itvision_apps a"
   local extra_ = "order by u.name"
   local columns_ = "u.name as name, u.firstname as firstname, u.realname as realname, u.email as email, a.name as app_name, a.id as app_id, u.id as user_id"

   local content = query ( tables_, cond_, extra_, columns_)
   return content
end


--function select_active_entities(clause, root_entity)
function select_active_entities(auth)
   -- se nao houver "glpiactive_entity" no session profile, quer dizer que se trata da entidade
   -- raiz e que esta deve ser incluida na lista de entidades. Por isso, extrai só o nome dessa
   -- entidade (que deve vir da string colocada em servdesk/locale/pt_BR.php - 
   local root_entity = nil
   if auth.session.glpiactive_entity == nil then
      _, _, root_entity = string.find(auth.session.glpiactive_entity_shortname, "([%a%s%d]+) %(Árvore%)")
   end
   local clause = Auth.make_entity_clause(auth)

   local cond_ = "id in "..clause
   local tables_ = "glpi_entities"
   local columns_ = "id, name, completename"
   local extra_ = "order by completename"
   if root_entity ~= nil then
     extra_ = "union select 0 as id, '"..root_entity.."' as name, '"..root_entity.."' as completename "..extra_
   end

   local content = query(tables_, cond_, extra_, columns_)
   return content
end
