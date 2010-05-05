/* 
Acesso externo a base de dados

GRANT ALL ON ndoutils.* TO ndoutils@192.168.153.1 IDENTIFIED BY 'itv'; 
GRANT ALL ON ndoutils.* TO     root@192.168.153.1 IDENTIFIED BY 'itv'; 

*/


DROP TABLE IF EXISTS `itvision_app_tree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_tree` (
  `app_tree_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `service_object_id` int(11) DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT '0',
  `rgt` int(11) NOT NULL DEFAULT '0',
  `app_list_id` int(11) DEFAULT NULL,
  `app_tree_type` enum('and','or') DEFAULT 'and',
  `is_active` enum('0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`app_tree_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`service_object_id`,`lft`,`rgt`) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Application tree';
/*!40101 SET character_set_client = @saved_cs_client */;



DROP TABLE IF EXISTS `itvision_app_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_list` (
  `app_list_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `app_list_type` enum('and','or','hst','svc') NOT NULL,
  PRIMARY KEY (`app_list_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Application list';
/*!40101 SET character_set_client = @saved_cs_client */;



DROP TABLE IF EXISTS `itvision_app_relat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_relat` (
  `app_relat_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `app_list_id` int(11) NOT NULL DEFAULT '0',
  `from_object_id` int(11) NOT NULL DEFAULT '0',
  `to_object_id` int(11) NOT NULL DEFAULT '0',
  `app_relat_type` enum('physical','logical') NOT NULL,
  PRIMARY KEY (`app_relat_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`app_list_id`,`from_object_id`,`to_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Application relationship';
/*!40101 SET character_set_client = @saved_cs_client */;

