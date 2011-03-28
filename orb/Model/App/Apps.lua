require "monitor_util"

APP_VISIBILITY_PRIVATE = 0
APP_VISIBILITY_PUBLIC = 1

----------------------------- SERVICE APP ----------------------------------

function select_service_app (cond_, extra_, columns_)
   return select_service (cond_, extra_, columns_, "app")
end


function select_service_app_object (cond_, extra_, columns_)
   return select_service_object (cond_, extra_, columns_, "app")
end


function select_root_app()
   local root = Model.query("itvision_apps a, itvision_app_trees at", "a.id = at.app_id and at.lft = 1", nil, "a.id as app_id")
   if root[1] then
      return root[1].app_id
   else
      return nil
   end
end



----------------------------- APP ----------------------------------

-- Retorna as aplicacoes já com os nomes da entidades e os seus estados (nagios_servicestatus).
-- POREM... por enquanto tenho que remover o status pois, depois que uma app é criada ela nao
--   tem nagios_objects nem status. A solucao é parecida com as make_queries do modulo Monitor.
function select_app (cond__, extra_, columns_)
--   local tables_  = [[  itvision_apps a, nagios_servicestatus ss ,
--                        (select a.entities_id as entity_id, a.name as entity_name, a.name as entity_completename 
--                         from itvision_app_trees t, itvision_apps a 
--                         where a.id = t.app_id and t.lft=1
--                         union 
--                         select id as entity_id, name as entity_name, completename asentity_completename 
--                         from glpi_entities) as e ]]
--   local cond_   = [[ a.entities_id = e.entity_id and a.service_object_id = ss.service_object_id ]]
   local tables_  = [[  itvision_apps a,
                        (select a.entities_id as entity_id, a.name as entity_name, 
                            a.name as entity_completename 
                         from itvision_app_trees t, itvision_apps a 
                         where a.id = t.app_id and t.lft=1
                         union 
                         select id as entity_id, name as entity_name, completename as entity_completename 
                         from glpi_entities) as e ]]
   local cond_   = [[ a.entities_id = e.entity_id ]]
   local extra_  = [[ order by entity_completename ]]

   if cond__ then cond_ = cond_.." and "..cond__ end
   local content = query (tables_, cond_, extra_, columns_)

   return content
end



function insert_app (content_)
   local table_ = "itvision_apps"
   insert (table_, content_)
   
   local content = query (table_, "name = '"..content_.name.."'")
   
   return content
end


function activate_app (app_id, flag)
   local table_ = "itvision_apps"
   flag = flag or 1;
   local content_ = { is_active = flag }
   update (table_, content_, "id = "..app_id)
   remake_apps_config_file()

   return true
end


function deactivate_app (app_id, flag)
   local table_ = "itvision_apps"
   flag = flag or 0;
   activate_app (app_id, flag)

   return true
end

require "App.Tree"

function remake_apps_config_file()
   -- local APPS = select_uniq_app_in_tree() -- Nao precisa mais disso pois nao usa mais o nagiosbp
   local APPS = query("itvision_apps", "is_active = 1")
   make_all_apps_config(APPS)
end


----------------------------- APP OBJECTS ----------------------------------

function select_app_object (cond_, extra_, columns_)
   local content = query ("itvision_app_objects", cond_, extra_, columns_)
   return content
end


function insert_app_object (content_)
   local table_ = "itvision_app_objects"
   insert (table_, content_)
   
   local content = query (table_, "app_id = '"..content_.app_id.."'")
   
   return content
end


function count_app_objects (id)
   local content = query ("itvision_app_objects", "app_id = "..id, nil, "count(app_id) as count")
   
   return tonumber(content[1].count)
end



function select_app_app_objects (id)
   -- seleciona objetos (hosts e services) de uma aplicacao 
   local cond_ = "o.object_id = ao.service_object_id and ao.app_id = a.id and o.object_id = m.service_object_id and m.networkports_id = p.id "
   if id then
      cond_ = cond_ .. " and a.id = "..id
   end
   local tables_ = "nagios_objects o, itvision_app_objects ao, itvision_apps a, glpi_networkports p, itvision_monitors m"
   local columns_ = [[ o.object_id, o.objecttype_id, o.name1, o.name2, ao.type as obj_type, a.id as 
	app_id, a.name as a_name, a.type as a_type, a.is_active, a.service_object_id as service_id, 
        p.itemtype as itemtype, p.items_id as items_id, p.ip as ip,
        m.name as name ]]
   local content = query (tables_, cond_, extra_, columns_)

   -- seleciona sub-aplicacoes de uma aplicacao
   local cond_ = [[ o.object_id = ao.service_object_id and ao.app_id = a.id and ab.service_object_id = o.object_id
        and ab.is_active = 1 and ao.type = 'app' ]]
   if id then
      cond_ = cond_ .. " and a.id = "..id
   end
   local tables_ = [[ nagios_objects o, itvision_app_objects ao, itvision_apps a, itvision_apps ab ]]
   local columns_ = [[ o.object_id, o.objecttype_id, o.name1, o.name2, ao.type as obj_type, a.id as 
	app_id, a.name as a_name, a.type as a_type, a.is_active, a.service_object_id as service_id, 
        NULL as itemtype, NULL as items_id, o.name2 as name2, ab.name as name, ab.id as id,
        a.app_type_id, a.is_entity_root ]]
   local content2 = query (tables_, cond_, extra_, columns_)

   for _,v in ipairs(content2) do
      table.insert(content,v)
   end

   return content
end


function select_app_to_graph (id)
   local columns_ = "app_id, a.name as a_name, ao.type as ao_type, o.object_id as obj_id, o.name1, o.name2, ss.current_state as curr_state"
   local tables_  = "itvision_apps a, itvision_app_objects ao, nagios_services s, nagios_objects o, nagios_servicestatus ss"
   local cond_    = "a.id = ao.app_id and ao.service_object_id = s.service_object_id and \
                     s.service_object_id = o.object_id and s.service_object_id = ss.service_object_id and \
                     a.id = "..id

   local content = query (tables_, cond_, extra_, columns_)
   return content
end


----------------------------- APP RELAT ----------------------------------

function select_app_relat (cond_, extra_, columns_)
   local content = query ("itvision_app_relats", cond_, extra_, columns_)
   return content
end



function insert_app_relat (content_)
   local table_ = "itvision_app_relats"
   insert (table_, content_)
   
   local content = query (table_, "app_id = "..content_.app_id.." and "..
      "from_object_id = "..content_.from_object_id..
      " and to_object_id = "..content_.to_object_id)
   
   return content
end



function select_app_relat_object (id, from, to)

   -- PRIMEIRO SELECIONA RELACIONAMENTOS ENTRE HOSTS e SERVICES
   local tables_  = [[itvision_app_relats ar, nagios_objects o1, nagios_objects o2, 
                      itvision_app_relat_types art, itvision_apps ap,
                      glpi_networkports n1, glpi_networkports n2, 
                      itvision_monitors m1, itvision_monitors m2 ]]
   local cond_    = [[ar.from_object_id = o1.object_id and 
                      ar.to_object_id = o2.object_id and
                      ar.app_relat_type_id = art.id and
                      ar.app_id = ap.id and
                      o1.object_id = m1.service_object_id and 
                      o2.object_id = m2.service_object_id and
                      m1.networkports_id = n1.id and
                      m2.networkports_id = n2.id ]]
   local columns_ = [[o1.name1 as from_name1, o1.name2 as from_name2, 
                      o2.name1 as to_name1, o2.name2 as to_name2,
                      ar.from_object_id, ar.to_object_id,
                      ar.app_id as app_id, ap.name as app_name, 
                      ar.app_relat_type_id, 
                      art.name as art_name, art.type as art_type,
                      ar.from_object_id, ar.to_object_id,
                      n1.itemtype as from_itemtype,
                      n1.items_id as from_items_id,
                      n2.itemtype as to_itemtype,
                      n2.items_id as to_items_id,
                      n1.ip as from_ip,
                      n2.ip as to_ip,
                      m1.name as from_name,
                      m2.name as to_name,
                      m1.type as from_type,
                      m2.type as to_type ]]

   if id then cond_ = cond_ .. " and ar.app_id = "..id end
   if from and to then cond_ = cond_  .. " and from_object_id = "..from.." and to_object_id = "..to end
   local content = query (tables_, cond_, extra_, columns_)

   -- AGORA SELECIONA RELACIONAMENTOS ENTRE HOSTS e SERVICES NA ORIGEM E APLICACOES NO DESTINO
   local tables_  = [[itvision_app_relats ar, nagios_objects o1, nagios_objects o2, 
                      itvision_app_relat_types art, itvision_apps ap,
                      glpi_networkports n1,
                      itvision_monitors m1 ]]
   local cond_    = [[ar.from_object_id = o1.object_id and 
                      ar.to_object_id = o2.object_id and
                      ar.app_relat_type_id = art.id and
                      ar.app_id = ap.id and
                      o1.object_id = m1.service_object_id and 
                      m1.networkports_id = n1.id and
                      o2.name1 = ']]..config.monitor.check_app..[[']]
   local columns_ = [[o1.name1 as from_name1, o1.name2 as from_name2, 
                      o2.name1 as to_name1, o2.name2 as to_name2,
                      ar.from_object_id, ar.to_object_id,
                      ar.app_id as app_id, ap.name as app_name, 
                      ar.app_relat_type_id, 
                      ar.from_object_id, ar.to_object_id,
                      art.name as art_name, art.type as art_type,
                      n1.itemtype as from_itemtype,
                      n1.items_id as from_items_id,
                      NULL as to_itemtype,
                      NULL as to_items_id,
                      n1.ip as from_ip,
                      NULL as to_ip,
                      m1.name as from_name,
                      m1.type as from_type,
                      ap.name as to_name,
                      'app' as to_type 
                    ]]

   if id then cond_ = cond_ .. " and ar.app_id = "..id end
   if from and to then cond_ = cond_  .. " and from_object_id = "..from.." and to_object_id = "..to end
   local content2 = query (tables_, cond_, extra_, columns_)

   -- AINDA, SELECIONA RELACIONAMENTOS ENTRE APLICACOES NA ORIGEM e HOSTS e SERVICES NO DESTINO
   local tables_  = [[itvision_app_relats ar, nagios_objects o1, nagios_objects o2, 
                      itvision_app_relat_types art, itvision_apps ap,
                      glpi_networkports n2,
                      itvision_monitors m2 ]]
   local cond_    = [[ar.from_object_id = o1.object_id and 
                      ar.to_object_id = o2.object_id and
                      ar.app_relat_type_id = art.id and
                      ar.app_id = ap.id and
                      o2.object_id = m2.service_object_id and 
                      m2.networkports_id = n2.id and
                      o1.name1 = ']]..config.monitor.check_app..[[']]
   local columns_ = [[o1.name1 as from_name1, o1.name2 as from_name2, 
                      o2.name1 as to_name1, o2.name2 as to_name2,

                      ar.from_object_id, ar.to_object_id,
                      ar.app_id as app_id, ap.name as app_name, 
                      ar.app_relat_type_id, 
                      ar.from_object_id, ar.to_object_id,
                      art.name as art_name, art.type as art_type,

                      n2.itemtype as from_itemtype,
                      n2.items_id as from_items_id,
                      NULL as to_itemtype,
                      NULL as to_items_id,
                      NULL as from_ip,
                      n2.ip as to_ip,

                      ap.name as from_name,
                      'app' as from_type,
                      m2.name as to_name,
                      m2.type as to_type
                    ]]

   if id then cond_ = cond_ .. " and ar.app_id = "..id end
   if from and to then cond_ = cond_  .. " and from_object_id = "..from.." and to_object_id = "..to end
   local content3 = query (tables_, cond_, extra_, columns_)

   -- POR FIM, SELECIONA RELACIONAMENTOS ENTRE APLICACOES NA ORIGEM e NO DESTINO
   local tables_  = [[itvision_app_relats ar, nagios_objects o1, nagios_objects o2, 
                      itvision_app_relat_types art, itvision_apps ap,
                      itvision_apps a1, itvision_apps a2 ]]
   local cond_    = [[ar.from_object_id = o1.object_id and 
                      ar.to_object_id = o2.object_id and
                      ar.app_relat_type_id = art.id and
                      ar.app_id = ap.id and
                      o1.name1 = ']]..config.monitor.check_app..[[' and 
                      o2.name1 = ']]..config.monitor.check_app..[[' and
                      a1.id = o1.name2 and
                      a2.id = o2.name2
                      ]]
   local columns_ = [[o1.name1 as from_name1, o1.name2 as from_name2, 
                      o2.name1 as to_name1,   o2.name2 as to_name2,

                      ar.from_object_id, ar.to_object_id,
                      ar.app_id as app_id, ap.name as app_name, 
                      ar.app_relat_type_id, 
                      ar.from_object_id, ar.to_object_id,
                      art.name as art_name, art.type as art_type,

                      NULL as from_itemtype,
                      NULL as from_items_id,
                      NULL as to_itemtype,
                      NULL as to_items_id,

                      a1.name as from_name,
                      'app' as from_type,
                      a2.name as to_name,
                      'app' as to_type
                    ]]

   if id then cond_ = cond_ .. " and ar.app_id = "..id end
   if from and to then cond_ = cond_  .. " and from_object_id = "..from.." and to_object_id = "..to end
   local content4 = query (tables_, cond_, extra_, columns_)

   -- JUNTA TODOS OS RESULTADOS
   for _,v in ipairs(content2) do
      table.insert(content,v)
   end

   for _,v in ipairs(content3) do
      table.insert(content,v)
   end

   for _,v in ipairs(content4) do
      table.insert(content,v)
   end

   return content
end



function select_app_relat_to_graph (id)
   -- PRIMEIRO SELECIONA RELACIONAMENTOS ENTRE HOSTS e SERVICES
   local tables_  = "itvision_apps a, itvision_app_relats ar, itvision_app_relat_types art, "..
                    "nagios_objects o1, nagios_objects o2, "..
                    "glpi_networkports n1, glpi_networkports n2, "..
                    "itvision_monitors m1, itvision_monitors m2"
   local columns_ = "a.name as a_name, art.name as art_name, o1.name1 as o1_name1, o1.name2 as o1_name2, "..
                    "o2.name1 as o2_name1, o2.name2 as o2_name2, "..
                    "n1.itemtype as from_itemtype, n1.items_id as from_items_id, "..
                    "n2.itemtype as to_itemtype, n2.items_id as to_items_id, "..
                    "m1.name as m1_name, m2.name as m2_name "
   local cond_    = "a.id = ar.app_id and \
                     ar.from_object_id = o1.object_id and \
                     ar.to_object_id = o2.object_id and \
                     ar.app_relat_type_id = art.id and \
                     o1.object_id = m1.service_object_id and \
                     o2.object_id = m2.service_object_id and \
                     m1.networkports_id = n1.id and \
                     m2.networkports_id = n2.id and \
                     a.id = "..id 

   local content = query (tables_, cond_, extra_, columns_)

   -- AGORA SELECIONA RELACIONAMENTOS ENTRE HOSTS e SERVICES NA ORIGEM E APLICACOES NO DESTINO
   local tables_  = "itvision_apps a, itvision_app_relats ar, itvision_app_relat_types art, "..
                    "nagios_objects o1, nagios_objects o2, "..
                    "glpi_networkports n1, "..
                    "itvision_monitors m1 "
   local columns_ = "a.name as a_name, art.name as art_name, "..
                    "o1.name1 as o1_name1, o1.name2 as o1_name2, "..
                    "o2.name1 as o2_name1, o2.name2 as o2_name2, "..
                    "n1.itemtype as from_itemtype, n1.items_id as from_items_id, "..
                    "'app' as to_itemtype, NULL as to_items_id, "..
                    "m1.name as m1_name, "..
                    "o2.name2 as m2_name "
   local cond_    = "a.id = ar.app_id and \
                     ar.from_object_id = o1.object_id and \
                     ar.to_object_id = o2.object_id and \
                     ar.app_relat_type_id = art.id and \
                     o1.object_id = m1.service_object_id and \
                     m1.networkports_id = n1.id and \
                     a.id = "..id.." and \
                     o2.name1 = '"..config.monitor.check_app.."'"

   local content2 = query (tables_, cond_, extra_, columns_)

   -- AINDA, SELECIONA RELACIONAMENTOS ENTRE APLICACOES NA ORIGEM e HOSTS e SERVICES NO DESTINO
   local tables_  = "itvision_apps a, itvision_app_relats ar, itvision_app_relat_types art, "..
                    "nagios_objects o1, nagios_objects o2, "..
                    "glpi_networkports n2, "..
                    "itvision_monitors m2 "
   local columns_ = "a.name as a_name, art.name as art_name, "..
                    "o1.name1 as o1_name1, o1.name2 as o1_name2, "..
                    "o2.name1 as o2_name1, o2.name2 as o2_name2, "..
                    "'app' as from_itemtype, NULL as from_items_id, "..
                    "n2.itemtype as to_itemtype, n2.items_id as to_items_id, "..
                    "m2.name as m2_name, "..
                    "o1.name2 as m1_name "
   local cond_    = "a.id = ar.app_id and \
                     ar.from_object_id = o1.object_id and \
                     ar.to_object_id = o2.object_id and \
                     ar.app_relat_type_id = art.id and \
                     o2.object_id = m2.service_object_id and \
                     m2.networkports_id = n2.id and \
                     a.id = "..id.." and \
                     o1.name1 = '"..config.monitor.check_app.."'"


   local content3 = query (tables_, cond_, extra_, columns_)

   -- POR FIM, SELECIONA RELACIONAMENTOS ENTRE APLICACOES NA ORIGEM e HOSTS e SERVICES NO DESTINO
   local tables_  = "itvision_apps a, itvision_app_relats ar, itvision_app_relat_types art, "..
                    "nagios_objects o1, nagios_objects o2 "
   local columns_ = "a.name as a_name, art.name as art_name, "..
                    "o1.name1 as o1_name1, o1.name2 as o1_name2, "..
                    "o2.name1 as o2_name1, o2.name2 as o2_name2, "..
                    "'app' as from_itemtype, NULL as from_items_id, "..
                    "'app' as to_itemtype, NULL as to_items_id, "..
                    "o2.name2 as m2_name, "..
                    "o1.name2 as m1_name "
   local cond_    = "a.id = ar.app_id and \
                     ar.from_object_id = o1.object_id and \
                     ar.to_object_id = o2.object_id and \
                     ar.app_relat_type_id = art.id and \
                     a.id = "..id.." and \
                     o1.name1 = '"..config.monitor.check_app.."' and  \
                     o2.name1 = '"..config.monitor.check_app.."'"


   local content4 = query (tables_, cond_, extra_, columns_)


   -- JUNTA TODOS OS RESULTADOS
   for _,v in ipairs(content2) do
      table.insert(content,v)
   end

   for _,v in ipairs(content3) do
      table.insert(content,v)
   end

   for _,v in ipairs(content4) do
      table.insert(content,v)
   end

   return content
end


