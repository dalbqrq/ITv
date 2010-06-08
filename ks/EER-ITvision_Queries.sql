select * from itvision_app_relat_type;
select * from itvision_app_list;
select * from itvision_app_relat;
select * from itvision_app_tree;
select * from itvision_apps;


delete from itvision_app_relat_type;
delete from itvision_app_list;
delete from itvision_app_relat;
delete from itvision_app_tree;
delete from itvision_apps;


insert into itvision_app_relat (to_object_id,from_object_id,connection_type,app_id,instance_id) values ('40','44','physical','107','1')