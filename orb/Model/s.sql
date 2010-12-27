
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




