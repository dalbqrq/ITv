select node.id, node.instance_id, node.lft, node.rgt, a.name, node.app_id, parent.id as parent,
             (COUNT(parent.id) - (sub_tree.depth + 1)) AS depth 
 from itvision_apps a, itvision_app_trees AS node, itvision_app_trees AS parent, itvision_app_trees AS sub_parent,
             (   SELECT node.id, (COUNT(parent.id) - 1) AS depth
             FROM itvision_app_trees AS node, itvision_app_trees AS parent
             WHERE node.lft BETWEEN parent.lft AND parent.rgt
             AND node.id = 3
             GROUP BY node.id
             ORDER BY node.lft
             ) AS sub_tree 
 where node.lft BETWEEN parent.lft AND parent.rgt
             AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
             AND sub_parent.id = sub_tree.id 
             AND node.app_id = a.id
 GROUP BY node.id ORDER BY node.lft


select parent.id, parent.instance_id, parent.lft, parent.rgt, parent.app_id
from itvision_app_trees AS node, itvision_app_trees AS parent
where node.lft BETWEEN parent.lft AND parent.rgt AND node.id = 8
ORDER BY parent.lft




-- lista de aplicacoes para nagios_bp
select distinct(node.app_id)
from itvision_app_trees AS node, itvision_app_trees AS parent 
where node.lft BETWEEN parent.lft AND parent.rgt 
      AND parent.id = (select t.id from itvision_app_trees t, itvision_apps a
                       where t.app_id = a.id and a.name = '_ROOT')
   ORDER BY node.lft desc;

-- lista de aplicacoes para adicao de subapp em uma app (app_objects)
 select distinct(a.service_object_id) from itvision_app_trees AS node, itvision_app_trees AS parent, itvision_apps a where node.lft BETWEEN parent.lft AND parent.rgt AND node.id in (select id from itvision_app_trees where app_id = 26) and parent.app_id <> 26 and a.id = parent.app_id and a.is_active = 1



-- arvore para grafico

select node.id, node.instance_id, node.lft, node.rgt, node.app_id, 
                app.name, papp.id as papp_id, papp.name as pname
from itvision_app_trees AS node, itvision_app_trees AS parent, 
                itvision_apps as app, itvision_apps as papp
where node.lft BETWEEN parent.lft AND parent.rgt AND parent.id = 3
                AND node.app_id = app.id AND parent.app_id = papp.id
   ORDER BY node.lft


select  node.id, node.instance_id, node.lft, node.rgt, node.app_id, 
            (COUNT(parent.id) - 1) AS depth, parent.id as parent
   from itvision_app_trees AS node, itvision_app_trees AS parent
   where      node.lft BETWEEN parent.lft AND parent.rgt AND node.id = 3
   GROUP BY node.id ORDER BY parent.lft


select node.id, node.instance_id, node.lft, node.rgt, node.app_id, sub_parent.app_id,
            (COUNT(parent.id) - (sub_tree.depth + 1)) AS depth
from itvision_app_trees AS node, itvision_app_trees AS parent, itvision_app_trees AS sub_parent, 
            (   SELECT node.id, (COUNT(parent.id) - 1) AS depth
            FROM itvision_app_trees AS node,
            itvision_app_trees AS parent
            WHERE node.lft BETWEEN parent.lft AND parent.rgt
            AND node.id = 3
            GROUP BY node.id
            ORDER BY node.lft
            ) AS sub_tree
where node.lft BETWEEN parent.lft AND parent.rgt
            AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
            AND sub_parent.id = sub_tree.id
GROUP BY node.id HAVING depth >= 0 ORDER BY node.lft



-- relacionamento entre pai e filho
select node.id, node.instance_id, node.lft, node.rgt, node.app_id, parent.app_id

from itvision_app_trees AS node, 
     itvision_app_trees AS parent

where node.lft BETWEEN     parent.lft AND     parent.rgt
  AND node.app_id <> parent.app_id
ORDER BY node.lft ;

-- apps
