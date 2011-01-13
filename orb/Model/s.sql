
select node.id, node.instance_id, node.lft, node.rgt, parent.lft, parent.rgt, node.app_id as child_id , parent.app_id as parent_id
from   itvision_app_trees AS node, itvision_app_trees AS parent
where  node.lft BETWEEN parent.lft AND parent.rgt 
                  AND node.app_id <> parent.app_id
ORDER BY node.lft

select  node.id, node.instance_id, node.lft, node.rgt, node.app_id, parent.app_id, sub_parent.app_id, sub_tree.app_id, 
            (COUNT(parent.id) - (sub_tree.depth + 1)) AS depth
from    itvision_app_trees AS node, itvision_app_trees AS parent, itvision_app_trees AS sub_parent, 
            (   SELECT node.id, parent.app_id as app_id, (COUNT(parent.id) - 1) AS depth
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
GROUP BY node.id HAVING depth <= 100 ORDER BY node.lft



SELECT lft, rgt INTO @parent_left, @parent_right FROM itvision_app_trees WHERE id = 3;
SELECT child.id
FROM itvision_app_trees AS child
LEFT JOIN itvision_app_trees AS ancestor ON
    ancestor.lft BETWEEN @parent_left+1 AND @parent_right-1 AND
    child.lft BETWEEN ancestor.lft+1 AND ancestor.rgt-1
WHERE
    child.lft BETWEEN @parent_left+1 AND @parent_right-1 AND
    ancestor.id IS NULL


select  child.id, child.app_id, child.lft, child.rgt  from  itvision_app_trees AS child 
         LEFT JOIN itvision_app_trees AS ancestor OnnN
         ancestor.lft BETWEEN 1+1 AND 10-1 AND
         child.lft BETWEEN ancestor.lft+1 AND ancestor.rgt-1  where  child.lft BETWEEN 1+1 AND 10-1 AND
         ancestor.id IS NULL  


1 8
2 5
3 4
6 7

select 

from
nagios_objects no, itvision_app_objects ao, itvision_apps a, glpi_networkports n, itvision_monitors m


where



select
	a.id as a_id, 
	a.name as a_name, 
	a.alias as a_alias, 
	a.user_id_owner as a_user_id_owner, 
	a.type as a_type, 
	a.is_active as a_is_active, 
	a.notepad as a_notepad, 
	ar.from_object_id as ar_from_object_id, 
	ar.to_object_id as ar_to_object_id,
	rt.name as rt_name, 
	rt.type as rt_type,
	o1.name1 as from_name1, 
	o2.name1 as to_name1, 
	n1.itemtype as from_itemtype,
	n1.items_id as from_items_id,
	n2.itemtype as to_itemtype,
	n2.items_id as to_items_id,
	m1.display as from_display,
	m2.display as to_display

from
	itvision_apps a,
	itvision_app_relats ar,
	itvision_app_relat_types rt,
	nagios_objects o0,
	nagios_objects o1,
	nagios_objects o2,
	glpi_networkports n1,
	glpi_networkports n2,
	itvision_monitors m1,
	itvision_monitors m2

where
	ar.from_object_id = o1.object_id and 
	ar.to_object_id = o2.object_id and
	ar.app_relat_type_id = rt.id and
	ar.app_id = ap.id and
	o1.name1 = n1.id and 
	o2.name1 = n2.id and
	o1.name2 = m1.id and 
	o2.name2 = m2.id




