
update glpi_computers set name = ucase(name) where name not like 'www%';
update glpi_networkequipments set name = ucase(name) where name not like 'www%';

select description, id from itvision_checkcmd_default_params;


update itvision_checkcmd_default_params  set description = "Endereço IP" where id in ( 4, 6,7,10, 13, 19, 21, 26, 29, 30, 34, 42, 44, 49, 50, 54, 55, 60, 61 );

update itvision_checkcmd_default_params  set description = 'Endereço IP Server' where id =  2;
update itvision_checkcmd_default_params  set description = 'Endereço IP Virtual Host' where id =  3;
update itvision_checkcmd_default_params  set description = 'Usuário PostgreSQL' where id = 14;
update itvision_checkcmd_default_params  set description = 'Endereço IP Server CUPS' where id = 17;
update itvision_checkcmd_default_params  set description = 'Porta do serviço CUPS' where id = 18;
update itvision_checkcmd_default_params  set description = 'URL (Endereço de página web)' where id = 23;
update itvision_checkcmd_default_params  set description = 'Número de pacotes' where id = 33;
update itvision_checkcmd_default_params  set description = 'Usuário Mysql' where id = 35;
update itvision_checkcmd_default_params  set description = 'Endereço IP Server' where id = 39;
update itvision_checkcmd_default_params  set description = 'Endereço IP Virtual Host' where id = 40;
update itvision_checkcmd_default_params  set description = 'Usuário e senha para autenticação básica' where id = 41;
update itvision_checkcmd_default_params  set description = 'Nome do usuário para autenticação' where id = 45;
update itvision_checkcmd_default_params  set description = 'Senha do usuário para autenticação' where id = 46;
update itvision_checkcmd_default_params  set description = 'Porta Radius para autenticação' where id = 48;
update itvision_checkcmd_default_params  set description = 'Número de pacotes' where id = 53;
update itvision_checkcmd_default_params  set description = 'Endereço IP DHCP' where id = 62;
update itvision_checkcmd_default_params  set description = 'Endereço IP DHCP' where id = 64;

:
