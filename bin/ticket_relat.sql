SET NAMES 'utf8';

#
# TICKETS SOLUCIONADOS
#

select  * from 
            (

            select 
            t.id,
            t.entities_id,
            e.name as entity_name,
            t.name,
            t.date,
            t.closedate,
            t.solvedate,
            t.date_mod,
            t.status,
            t.users_id,
            u.name as user_login,
            u.firstname as user_firstname,
            u.realname as user_lastname,
            t.users_id_recipient,
            ur.name as user_recipient_name,
            ur.firstname as user_recipient_firstname,
            ur.realname as user_recipient_lastname,
            t.groups_id,
            g.name as group_name,
            t.requesttypes_id,
            rt.name as requesttype_name,
            t.users_id_assign,
            ua.name as user_assign_name,
            ua.firstname as user_assign_firstname,
            ua.realname as user_assign_lastname,
            t.content,
            t.urgency,
            t.impact,
            t.priority,
            t.user_email,
            t.use_email_notification,
            t.realtime,
            t.ticketcategories_id,
            tc.name as ticket_category_name,
            tc.completename as ticket_category_completename,
            t.cost_time,
            t.cost_fixed,
            t.cost_material,
            t.ticketsolutiontypes_id,
            ts.name as ticketsolutiontype_name,
            t.solution,
            t.global_validation,
            t.itemtype,
            t.items_id,
            i.name as itens_name
            
            from 
            glpi_tickets t,            glpi_entities e,            glpi_users u,            
            glpi_users ur,             glpi_requesttypes rt,       glpi_users ua,            
            glpi_groups g,            
            glpi_ticketcategories tc,  glpi_ticketsolutiontypes ts            ,
            glpi_networkequipments i
            
            where
            t.entities_id = e.id and
            t.users_id = u.id and
            t.users_id_recipient = ur.id and
            t.requesttypes_id = rt.id and
            t.users_id_assign = ua.id and
            t.groups_id_assign = g.id and
            t.ticketcategories_id = tc.id and
            t.ticketsolutiontypes_id = ts.id and
            t.itemtype = 'NetworkEquipment' and
            t.items_id = i.id
            
            union
            
            select 
            t.id,
            t.entities_id,
            e.name as entity_name,
            t.name,
            t.date,
            t.closedate,
            t.solvedate,
            t.date_mod,
            t.status,
            t.users_id,
            u.name as user_login,
            u.firstname as user_firstname,
            u.realname as user_lastname,
            t.users_id_recipient,
            ur.name as user_recipient_name,
            ur.firstname as user_recipient_firstname,
            ur.realname as user_recipient_lastname,
            t.groups_id,
            g.name as group_name,
            t.requesttypes_id,
            rt.name as requesttype_name,
            t.users_id_assign,
            ua.name as user_assign_name,
            ua.firstname as user_assign_firstname,
            ua.realname as user_assign_lastname,
            t.content,
            t.urgency,
            t.impact,
            t.priority,
            t.user_email,
            t.use_email_notification,
            t.realtime,
            t.ticketcategories_id,
            tc.name as ticket_category_name,
            tc.completename as ticket_category_completename,
            t.cost_time,
            t.cost_fixed,
            t.cost_material,
            t.ticketsolutiontypes_id,
            ts.name as ticketsolutiontype_name,
            t.solution,
            t.global_validation,
            t.itemtype,
            t.items_id,
            i.name as itens_name
            
            from 
            glpi_tickets t,            glpi_entities e,            glpi_users u,            
            glpi_users ur,             glpi_requesttypes rt,       glpi_users ua,            
            glpi_groups g,            
            glpi_ticketcategories tc,  glpi_ticketsolutiontypes ts            ,
            glpi_computers i
            
            where
            t.entities_id = e.id and
            t.users_id = u.id and
            t.users_id_recipient = ur.id and
            t.requesttypes_id = rt.id and
            t.users_id_assign = ua.id and
            t.groups_id_assign = g.id and
            t.ticketcategories_id = tc.id and
            t.ticketsolutiontypes_id = ts.id and
            t.itemtype = 'Computer' and
            t.items_id = i.id
            
            union
            
            select 
            t.id,
            t.entities_id,
            e.name as entity_name,
            t.name,
            t.date,
            t.closedate,
            t.solvedate,
            t.date_mod,
            t.status,
            t.users_id,
            u.name as user_login,
            u.firstname as user_firstname,
            u.realname as user_lastname,
            t.users_id_recipient,
            ur.name as user_recipient_name,
            ur.firstname as user_recipient_firstname,
            ur.realname as user_recipient_lastname,
            t.groups_id,
            g.name as group_name,
            t.requesttypes_id,
            rt.name as requesttype_name,
            t.users_id_assign,
            ua.name as user_assign_name,
            ua.firstname as user_assign_firstname,
            ua.realname as user_assign_lastname,
            t.content,
            t.urgency,
            t.impact,
            t.priority,
            t.user_email,
            t.use_email_notification,
            t.realtime,
            t.ticketcategories_id,
            tc.name as ticket_category_name,
            tc.completename as ticket_category_completename,
            t.cost_time,
            t.cost_fixed,
            t.cost_material,
            t.ticketsolutiontypes_id,
            ts.name as ticketsolutiontype_name,
            t.solution,
            t.global_validation,
            t.itemtype,
            t.items_id,
            i.name as itens_name
            
            from 
            glpi_tickets t,            glpi_entities e,            glpi_users u,            
            glpi_users ur,             glpi_requesttypes rt,       glpi_users ua,            
            glpi_groups g,            
            glpi_ticketcategories tc,  glpi_ticketsolutiontypes ts            ,
            glpi_peripherals i
            
            where
            t.entities_id = e.id and
            t.users_id = u.id and
            t.users_id_recipient = ur.id and
            t.requesttypes_id = rt.id and
            t.users_id_assign = ua.id and
            t.groups_id_assign = g.id and
            t.ticketcategories_id = tc.id and
            t.ticketsolutiontypes_id = ts.id and
            t.itemtype = 'Peripheral' and
            t.items_id = i.id
            
            
            union
            
            select 
            t.id,
            t.entities_id,
            e.name as entity_name,
            t.name,
            t.date,
            t.closedate,
            t.solvedate,
            t.date_mod,
            t.status,
            t.users_id,
            u.name as user_login,
            u.firstname as user_firstname,
            u.realname as user_lastname,
            t.users_id_recipient,
            ur.name as user_recipient_name,
            ur.firstname as user_recipient_firstname,
            ur.realname as user_recipient_lastname,
            t.groups_id,
            g.name as group_name,
            t.requesttypes_id,
            rt.name as requesttype_name,
            t.users_id_assign,
            ua.name as user_assign_name,
            ua.firstname as user_assign_firstname,
            ua.realname as user_assign_lastname,
            t.content,
            t.urgency,
            t.impact,
            t.priority,
            t.user_email,
            t.use_email_notification,
            t.realtime,
            t.ticketcategories_id,
            tc.name as ticket_category_name,
            tc.completename as ticket_category_completename,
            t.cost_time,
            t.cost_fixed,
            t.cost_material,
            t.ticketsolutiontypes_id,
            ts.name as ticketsolutiontype_name,
            t.solution,
            t.global_validation,
            t.itemtype,
            t.items_id,
            i.name as itens_name
            
            from 
            glpi_tickets t,            glpi_entities e,            glpi_users u,            
            glpi_users ur,             glpi_requesttypes rt,       glpi_users ua,            
            glpi_groups g,            
            glpi_ticketcategories tc,  glpi_ticketsolutiontypes ts            ,
            glpi_phones i
            
            where
            t.entities_id = e.id and
            t.users_id = u.id and
            t.users_id_recipient = ur.id and
            t.requesttypes_id = rt.id and
            t.users_id_assign = ua.id and
            t.groups_id_assign = g.id and
            t.ticketcategories_id = tc.id and
            t.ticketsolutiontypes_id = ts.id and
            t.itemtype = 'Phone' and
            t.items_id = i.id
            
            
            union
            
            select 
            t.id,
            t.entities_id,
            e.name as entity_name,
            t.name,
            t.date,
            t.closedate,
            t.solvedate,
            t.date_mod,
            t.status,
            t.users_id,
            u.name as user_login,
            u.firstname as user_firstname,
            u.realname as user_lastname,
            t.users_id_recipient,
            ur.name as user_recipient_name,
            ur.firstname as user_recipient_firstname,
            ur.realname as user_recipient_lastname,
            t.groups_id,
            g.name as group_name,
            t.requesttypes_id,
            rt.name as requesttype_name,
            t.users_id_assign,
            ua.name as user_assign_name,
            ua.firstname as user_assign_firstname,
            ua.realname as user_assign_lastname,
            t.content,
            t.urgency,
            t.impact,
            t.priority,
            t.user_email,
            t.use_email_notification,
            t.realtime,
            t.ticketcategories_id,
            tc.name as ticket_category_name,
            tc.completename as ticket_category_completename,
            t.cost_time,
            t.cost_fixed,
            t.cost_material,
            t.ticketsolutiontypes_id,
            ts.name as ticketsolutiontype_name,
            t.solution,
            t.global_validation,
            t.itemtype,
            t.items_id,
            '' as itens_name
            
            from 
            glpi_tickets t,            glpi_entities e,            glpi_users u,            
            glpi_users ur,             glpi_requesttypes rt,       glpi_users ua,            
            glpi_groups g,            
            glpi_ticketcategories tc,  glpi_ticketsolutiontypes ts
            
            where
            t.entities_id = e.id and
            t.users_id = u.id and
            t.users_id_recipient = ur.id and
            t.requesttypes_id = rt.id and
            t.users_id_assign = ua.id and
            t.groups_id_assign = g.id and
            t.ticketcategories_id = tc.id and
            t.ticketsolutiontypes_id = ts.id and
            t.itemtype = ''
            
            ) as U order by U.id;

