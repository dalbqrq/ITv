-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ndoutils
-- ------------------------------------------------------
-- Server version	5.1.41-3ubuntu12

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `itvision_app_list`
--

DROP TABLE IF EXISTS `itvision_app_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_list` (
  `app_id` int(11) NOT NULL,
  `instance_id` smallint(6) NOT NULL,
  `object_id` int(11) NOT NULL,
  `type` enum('app','hst','svc') NOT NULL,
  KEY `fk_app_id2` (`app_id`,`instance_id`),
  CONSTRAINT `fk_app_id2` FOREIGN KEY (`app_id`, `instance_id`) REFERENCES `itvision_apps` (`app_id`, `instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Application list';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_app_list`
--

LOCK TABLES `itvision_app_list` WRITE;
/*!40000 ALTER TABLE `itvision_app_list` DISABLE KEYS */;
INSERT INTO `itvision_app_list` VALUES (16,1,5,'svc'),(16,1,6,'svc'),(16,1,7,'svc'),(16,1,8,'svc'),(17,1,52,'app'),(16,1,1,'hst'),(19,1,1,'hst'),(19,1,5,'svc');
/*!40000 ALTER TABLE `itvision_app_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_app_relat`
--

DROP TABLE IF EXISTS `itvision_app_relat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_relat` (
  `app_id` int(11) NOT NULL,
  `instance_id` smallint(6) NOT NULL,
  `from_object_id` int(11) NOT NULL,
  `to_object_id` int(11) NOT NULL,
  `connection_type` enum('physical','logical') NOT NULL,
  `app_relat_type_id` int(11) NOT NULL,
  PRIMARY KEY (`from_object_id`,`to_object_id`,`app_id`,`instance_id`,`app_relat_type_id`),
  KEY `fk_object_id4` (`from_object_id`),
  KEY `fk_object_id5` (`to_object_id`),
  KEY `fk_app_id3` (`app_id`,`instance_id`),
  KEY `fk_app_relat_type_id1` (`app_relat_type_id`),
  CONSTRAINT `fk_app_id3` FOREIGN KEY (`app_id`, `instance_id`) REFERENCES `itvision_apps` (`app_id`, `instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_app_relat_type_id1` FOREIGN KEY (`app_relat_type_id`) REFERENCES `itvision_app_relat_type` (`app_relat_type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_object_id4` FOREIGN KEY (`from_object_id`) REFERENCES `nagios_objects` (`object_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_object_id5` FOREIGN KEY (`to_object_id`) REFERENCES `nagios_objects` (`object_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Application relationship';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_app_relat`
--

LOCK TABLES `itvision_app_relat` WRITE;
/*!40000 ALTER TABLE `itvision_app_relat` DISABLE KEYS */;
INSERT INTO `itvision_app_relat` VALUES (16,1,1,53,'physical',20),(19,1,5,5,'logical',19),(16,1,53,1,'logical',21);
/*!40000 ALTER TABLE `itvision_app_relat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_app_relat_type`
--

DROP TABLE IF EXISTS `itvision_app_relat_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_relat_type` (
  `app_relat_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`app_relat_type_id`,`instance_id`),
  KEY `fk_instance_id5` (`instance_id`),
  CONSTRAINT `fk_instance_id5` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_app_relat_type`
--

LOCK TABLES `itvision_app_relat_type` WRITE;
/*!40000 ALTER TABLE `itvision_app_relat_type` DISABLE KEYS */;
INSERT INTO `itvision_app_relat_type` VALUES (19,1,'Roda em'),(20,1,'Conectado a'),(21,1,'Faz backup em');
/*!40000 ALTER TABLE `itvision_app_relat_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_app_tree`
--

DROP TABLE IF EXISTS `itvision_app_tree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_tree` (
  `app_tree_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `lft` int(11) NOT NULL DEFAULT '0',
  `rgt` int(11) NOT NULL DEFAULT '0',
  `app_id` int(11) NOT NULL,
  PRIMARY KEY (`app_tree_id`,`instance_id`,`app_id`),
  KEY `fk_instance_id4` (`instance_id`),
  KEY `fk_app_id1` (`app_id`),
  CONSTRAINT `fk_app_id1` FOREIGN KEY (`app_id`) REFERENCES `itvision_apps` (`app_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_instance_id4` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 COMMENT='Application tree';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_app_tree`
--

LOCK TABLES `itvision_app_tree` WRITE;
/*!40000 ALTER TABLE `itvision_app_tree` DISABLE KEYS */;
INSERT INTO `itvision_app_tree` VALUES (8,1,1,8,17),(9,1,2,3,16);
/*!40000 ALTER TABLE `itvision_app_tree` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_apps`
--

DROP TABLE IF EXISTS `itvision_apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_apps` (
  `app_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `name` varchar(45) NOT NULL,
  `type` enum('and','or') NOT NULL,
  `is_active` enum('0','1') NOT NULL DEFAULT '0',
  `service_object_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`app_id`,`instance_id`),
  KEY `fk_instance_id8` (`instance_id`),
  CONSTRAINT `fk_instance_id8` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_apps`
--

LOCK TABLES `itvision_apps` WRITE;
/*!40000 ALTER TABLE `itvision_apps` DISABLE KEYS */;
INSERT INTO `itvision_apps` VALUES (16,1,'ITvision','or','0',NULL),(17,1,'itiv_proto','and','1',7),(19,1,'LOCAL_AP','and','0',NULL);
/*!40000 ALTER TABLE `itvision_apps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_ci`
--

DROP TABLE IF EXISTS `itvision_ci`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_ci` (
  `ci_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `alias` varchar(45) DEFAULT NULL,
  `sn` varchar(45) DEFAULT NULL,
  `contact_id` int(11) DEFAULT NULL,
  `manufacturer_id` int(11) DEFAULT NULL,
  `location_tree_id` int(11) DEFAULT NULL,
  `ci_parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`ci_id`,`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_ci`
--

LOCK TABLES `itvision_ci` WRITE;
/*!40000 ALTER TABLE `itvision_ci` DISABLE KEYS */;
INSERT INTO `itvision_ci` VALUES (1,1,'QIN Linux','qin','10291029',NULL,NULL,5,NULL);
/*!40000 ALTER TABLE `itvision_ci` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_ci_host`
--

DROP TABLE IF EXISTS `itvision_ci_host`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_ci_host` (
  `ci_host_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `host_object_id` int(11) NOT NULL,
  `ci_id` int(11) NOT NULL,
  PRIMARY KEY (`ci_host_id`,`instance_id`,`host_object_id`,`ci_id`),
  KEY `fk_instance_id` (`instance_id`),
  KEY `fk_object_id2` (`host_object_id`),
  KEY `fk_config_item1` (`ci_id`),
  CONSTRAINT `fk_config_item1` FOREIGN KEY (`ci_id`) REFERENCES `itvision_ci` (`ci_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_instance_id` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_object_id2` FOREIGN KEY (`host_object_id`) REFERENCES `nagios_objects` (`object_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Group hosts (ethernet interfaces) into one device';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_ci_host`
--

LOCK TABLES `itvision_ci_host` WRITE;
/*!40000 ALTER TABLE `itvision_ci_host` DISABLE KEYS */;
/*!40000 ALTER TABLE `itvision_ci_host` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_contract`
--

DROP TABLE IF EXISTS `itvision_contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_contract` (
  `contract_id` int(11) NOT NULL AUTO_INCREMENT,
  `company` varchar(45) NOT NULL,
  `begins` datetime NOT NULL,
  `ends` datetime NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`contract_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_contract`
--

LOCK TABLES `itvision_contract` WRITE;
/*!40000 ALTER TABLE `itvision_contract` DISABLE KEYS */;
INSERT INTO `itvision_contract` VALUES (2,'ATMA','0000-00-00 00:00:00','0000-00-00 00:00:00','okokok ok ok okok kokok \n'),(3,'Verto','2010-03-08 00:00:00','2011-07-30 00:00:00','gb askdf asdfkasd');
/*!40000 ALTER TABLE `itvision_contract` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_location_tree`
--

DROP TABLE IF EXISTS `itvision_location_tree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_location_tree` (
  `location_tree_id` int(11) NOT NULL AUTO_INCREMENT,
  `lft` int(11) NOT NULL,
  `rgt` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `obs` varchar(145) DEFAULT NULL,
  `geotag` varchar(25) DEFAULT NULL,
  `instance_id` smallint(6) NOT NULL,
  PRIMARY KEY (`location_tree_id`,`instance_id`),
  KEY `fk_instance_id2` (`instance_id`),
  CONSTRAINT `fk_instance_id2` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COMMENT='Location schema for sites and configuration itens';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_location_tree`
--

LOCK TABLES `itvision_location_tree` WRITE;
/*!40000 ALTER TABLE `itvision_location_tree` DISABLE KEYS */;
INSERT INTO `itvision_location_tree` VALUES (4,1,2,'Verto','SunPlaza','-23.001232,-43.390484',1),(5,2,3,'IMPA','Inf','-22.965476,-43.237746',1);
/*!40000 ALTER TABLE `itvision_location_tree` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_manufacturer`
--

DROP TABLE IF EXISTS `itvision_manufacturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_manufacturer` (
  `manufacturer_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`manufacturer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_manufacturer`
--

LOCK TABLES `itvision_manufacturer` WRITE;
/*!40000 ALTER TABLE `itvision_manufacturer` DISABLE KEYS */;
INSERT INTO `itvision_manufacturer` VALUES (1,'IBM'),(2,'DELL'),(3,'Cisco'),(4,'HP'),(8,'Intel');
/*!40000 ALTER TABLE `itvision_manufacturer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_site_tree`
--

DROP TABLE IF EXISTS `itvision_site_tree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_site_tree` (
  `site_tree_id` int(11) NOT NULL AUTO_INCREMENT,
  `lft` int(11) NOT NULL,
  `rgt` int(11) NOT NULL,
  `instance_id` smallint(6) NOT NULL,
  `location_tree_id` int(11) NOT NULL,
  `service_object_id` int(11) NOT NULL,
  PRIMARY KEY (`site_tree_id`,`instance_id`,`location_tree_id`,`service_object_id`),
  KEY `fk_instance_id1` (`instance_id`),
  KEY `fk_location_tree_id1` (`location_tree_id`),
  KEY `fk_object_id1` (`service_object_id`),
  CONSTRAINT `fk_instance_id1` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_location_tree_id1` FOREIGN KEY (`location_tree_id`) REFERENCES `itvision_location_tree` (`location_tree_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_object_id1` FOREIGN KEY (`service_object_id`) REFERENCES `nagios_objects` (`object_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tree to organize ITvision instances';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_site_tree`
--

LOCK TABLES `itvision_site_tree` WRITE;
/*!40000 ALTER TABLE `itvision_site_tree` DISABLE KEYS */;
/*!40000 ALTER TABLE `itvision_site_tree` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_sysconfig`
--

DROP TABLE IF EXISTS `itvision_sysconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_sysconfig` (
  `sysconfig_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  `version` varchar(45) NOT NULL,
  `home_dir` varchar(45) NOT NULL,
  `monitor_dir` varchar(45) NOT NULL,
  `monitor_bp_dir` varchar(45) NOT NULL,
  PRIMARY KEY (`sysconfig_id`,`instance_id`),
  KEY `fk_instance_id7` (`instance_id`),
  CONSTRAINT `fk_instance_id7` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18446744073709551615 DEFAULT CHARSET=latin1 COMMENT='ITvision system configuration';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_sysconfig`
--

LOCK TABLES `itvision_sysconfig` WRITE;
/*!40000 ALTER TABLE `itvision_sysconfig` DISABLE KEYS */;
INSERT INTO `itvision_sysconfig` VALUES (1,1,'2010-07-14 00:00:00','2010-07-14 00:00:00','0.9.1','/usr/local/itvision','/usr/local/monitor','/usr/local/monitorbp');
/*!40000 ALTER TABLE `itvision_sysconfig` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_user`
--

DROP TABLE IF EXISTS `itvision_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `login` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `user_group_id` int(11) NOT NULL,
  `user_prefs_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`user_group_id`,`user_prefs_id`,`instance_id`),
  KEY `fk_user_group_id1` (`user_group_id`),
  KEY `fk_user_prefs_id1` (`user_prefs_id`,`instance_id`),
  CONSTRAINT `fk_user_group_id1` FOREIGN KEY (`user_group_id`) REFERENCES `itvision_user_group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_prefs_id1` FOREIGN KEY (`user_prefs_id`) REFERENCES `itvision_user_prefs` (`user_prefs_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_user`
--

LOCK TABLES `itvision_user` WRITE;
/*!40000 ALTER TABLE `itvision_user` DISABLE KEYS */;
INSERT INTO `itvision_user` VALUES (2,1,'daniel','0tucamis',10,0),(9,1,'jantonio','asdfas',17,0);
/*!40000 ALTER TABLE `itvision_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_user_group`
--

DROP TABLE IF EXISTS `itvision_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_user_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `root_app` int(11) DEFAULT NULL,
  `instance_id` smallint(6) NOT NULL,
  PRIMARY KEY (`id`,`instance_id`),
  KEY `fk_instance_id6` (`instance_id`),
  CONSTRAINT `fk_instance_id6` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_user_group`
--

LOCK TABLES `itvision_user_group` WRITE;
/*!40000 ALTER TABLE `itvision_user_group` DISABLE KEYS */;
INSERT INTO `itvision_user_group` VALUES (2,'LINS',17,1),(10,'ATMA',16,1),(17,'ATK_ust',17,1),(22,'GrPo',16,1);
/*!40000 ALTER TABLE `itvision_user_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_user_prefs`
--

DROP TABLE IF EXISTS `itvision_user_prefs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_user_prefs` (
  `user_prefs_id` int(11) NOT NULL,
  `root_app` int(11) DEFAULT NULL,
  `instance_id` smallint(6) NOT NULL,
  PRIMARY KEY (`user_prefs_id`,`instance_id`),
  KEY `fk_instance_id9` (`instance_id`),
  CONSTRAINT `fk_instance_id9` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_user_prefs`
--

LOCK TABLES `itvision_user_prefs` WRITE;
/*!40000 ALTER TABLE `itvision_user_prefs` DISABLE KEYS */;
INSERT INTO `itvision_user_prefs` VALUES (0,16,1);
/*!40000 ALTER TABLE `itvision_user_prefs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_acknowledgements`
--

DROP TABLE IF EXISTS `nagios_acknowledgements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_acknowledgements` (
  `acknowledgement_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `entry_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `entry_time_usec` int(11) NOT NULL DEFAULT '0',
  `acknowledgement_type` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `state` smallint(6) NOT NULL DEFAULT '0',
  `author_name` varchar(64) NOT NULL DEFAULT '',
  `comment_data` varchar(255) NOT NULL DEFAULT '',
  `is_sticky` smallint(6) NOT NULL DEFAULT '0',
  `persistent_comment` smallint(6) NOT NULL DEFAULT '0',
  `notify_contacts` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`acknowledgement_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Current and historical host and service acknowledgements';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_acknowledgements`
--

LOCK TABLES `nagios_acknowledgements` WRITE;
/*!40000 ALTER TABLE `nagios_acknowledgements` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_acknowledgements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_commands`
--

DROP TABLE IF EXISTS `nagios_commands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_commands` (
  `command_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `command_line` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`command_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`object_id`,`config_type`)
) ENGINE=InnoDB AUTO_INCREMENT=283 DEFAULT CHARSET=latin1 COMMENT='Command definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_commands`
--

LOCK TABLES `nagios_commands` WRITE;
/*!40000 ALTER TABLE `nagios_commands` DISABLE KEYS */;
INSERT INTO `nagios_commands` VALUES (257,1,1,12,'$USER1$/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100% -p 5'),(258,1,1,48,'/usr/local/monitorbp/libexec/check_bp_status.pl -b $ARG1$ -f $ARG2$'),(259,1,1,13,'$USER1$/check_dhcp $ARG1$'),(260,1,1,14,'$USER1$/check_ftp -H $HOSTADDRESS$ $ARG1$'),(261,1,1,15,'$USER1$/check_hpjd -H $HOSTADDRESS$ $ARG1$'),(262,1,1,16,'$USER1$/check_http -I $HOSTADDRESS$ $ARG1$'),(263,1,1,17,'$USER1$/check_imap -H $HOSTADDRESS$ $ARG1$'),(264,1,1,18,'$USER1$/check_disk -w $ARG1$ -c $ARG2$ -p $ARG3$'),(265,1,1,19,'$USER1$/check_load -w $ARG1$ -c $ARG2$'),(266,1,1,20,'$USER1$/check_mrtgtraf -F $ARG1$ -a $ARG2$ -w $ARG3$ -c $ARG4$ -e $ARG5$'),(267,1,1,21,'$USER1$/check_procs -w $ARG1$ -c $ARG2$ -s $ARG3$'),(268,1,1,22,'$USER1$/check_swap -w $ARG1$ -c $ARG2$'),(269,1,1,23,'$USER1$/check_users -w $ARG1$ -c $ARG2$'),(270,1,1,24,'$USER1$/check_nt -H $HOSTADDRESS$ -p 12489 -v $ARG1$ $ARG2$'),(271,1,1,25,'$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5'),(272,1,1,26,'$USER1$/check_pop -H $HOSTADDRESS$ $ARG1$'),(273,1,1,27,'$USER1$/check_smtp -H $HOSTADDRESS$ $ARG1$'),(274,1,1,28,'$USER1$/check_snmp -H $HOSTADDRESS$ $ARG1$'),(275,1,1,29,'$USER1$/check_ssh $ARG1$ $HOSTADDRESS$'),(276,1,1,30,'$USER1$/check_tcp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$'),(277,1,1,31,'$USER1$/check_udp -H $HOSTADDRESS$ -p $ARG1$ $ARG2$'),(278,1,1,32,'/usr/bin/printf \"%b\" \"***** Nagios *****\\n\\nNotification Type: $NOTIFICATIONTYPE$\\nHost: $HOSTNAME$\\nState: $HOSTSTATE$\\nAddress: $HOSTADDRESS$\\nInfo: $HOSTOUTPUT$\\n\\nDate/Time: $LONGDATETIME$\\n\" | /bin/mail -s \"** $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME'),(279,1,1,33,'/usr/bin/printf \"%b\" \"***** Nagios *****\\n\\nNotification Type: $NOTIFICATIONTYPE$\\n\\nService: $SERVICEDESC$\\nHost: $HOSTALIAS$\\nAddress: $HOSTADDRESS$\\nState: $SERVICESTATE$\\n\\nDate/Time: $LONGDATETIME$\\n\\nAdditional Info:\\n\\n$SERVICEOUTPUT$\" | /bin/mail '),(280,1,1,34,'/usr/bin/printf \"%b\" \"$LASTHOSTCHECK$\\t$HOSTNAME$\\t$HOSTSTATE$\\t$HOSTATTEMPT$\\t$HOSTSTATETYPE$\\t$HOSTEXECUTIONTIME$\\t$HOSTOUTPUT$\\t$HOSTPERFDATA$\\n\" >> /usr/local/monitor/var/host-perfdata.out'),(281,1,1,35,'/usr/bin/printf \"%b\" \"$LASTSERVICECHECK$\\t$HOSTNAME$\\t$SERVICEDESC$\\t$SERVICESTATE$\\t$SERVICEATTEMPT$\\t$SERVICESTATETYPE$\\t$SERVICEEXECUTIONTIME$\\t$SERVICELATENCY$\\t$SERVICEOUTPUT$\\t$SERVICEPERFDATA$\\n\" >> /usr/local/monitor/var/service-perfdata.out'),(282,1,1,49,'$USER1$/check_dummy 0');
/*!40000 ALTER TABLE `nagios_commands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_commenthistory`
--

DROP TABLE IF EXISTS `nagios_commenthistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_commenthistory` (
  `commenthistory_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `entry_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `entry_time_usec` int(11) NOT NULL DEFAULT '0',
  `comment_type` smallint(6) NOT NULL DEFAULT '0',
  `entry_type` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `comment_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `internal_comment_id` int(11) NOT NULL DEFAULT '0',
  `author_name` varchar(64) NOT NULL DEFAULT '',
  `comment_data` varchar(255) NOT NULL DEFAULT '',
  `is_persistent` smallint(6) NOT NULL DEFAULT '0',
  `comment_source` smallint(6) NOT NULL DEFAULT '0',
  `expires` smallint(6) NOT NULL DEFAULT '0',
  `expiration_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deletion_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deletion_time_usec` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`commenthistory_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`comment_time`,`internal_comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historical host and service comments';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_commenthistory`
--

LOCK TABLES `nagios_commenthistory` WRITE;
/*!40000 ALTER TABLE `nagios_commenthistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_commenthistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_comments`
--

DROP TABLE IF EXISTS `nagios_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_comments` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `entry_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `entry_time_usec` int(11) NOT NULL DEFAULT '0',
  `comment_type` smallint(6) NOT NULL DEFAULT '0',
  `entry_type` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `comment_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `internal_comment_id` int(11) NOT NULL DEFAULT '0',
  `author_name` varchar(64) NOT NULL DEFAULT '',
  `comment_data` varchar(255) NOT NULL DEFAULT '',
  `is_persistent` smallint(6) NOT NULL DEFAULT '0',
  `comment_source` smallint(6) NOT NULL DEFAULT '0',
  `expires` smallint(6) NOT NULL DEFAULT '0',
  `expiration_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`comment_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`comment_time`,`internal_comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_comments`
--

LOCK TABLES `nagios_comments` WRITE;
/*!40000 ALTER TABLE `nagios_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_configfiles`
--

DROP TABLE IF EXISTS `nagios_configfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_configfiles` (
  `configfile_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `configfile_type` smallint(6) NOT NULL DEFAULT '0',
  `configfile_path` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`configfile_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`configfile_type`,`configfile_path`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COMMENT='Configuration files';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_configfiles`
--

LOCK TABLES `nagios_configfiles` WRITE;
/*!40000 ALTER TABLE `nagios_configfiles` DISABLE KEYS */;
INSERT INTO `nagios_configfiles` VALUES (11,1,0,'/usr/local/monitor/etc/nagios.cfg');
/*!40000 ALTER TABLE `nagios_configfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_configfilevariables`
--

DROP TABLE IF EXISTS `nagios_configfilevariables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_configfilevariables` (
  `configfilevariable_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `configfile_id` int(11) NOT NULL DEFAULT '0',
  `varname` varchar(64) NOT NULL DEFAULT '',
  `varvalue` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`configfilevariable_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`configfile_id`,`varname`)
) ENGINE=InnoDB AUTO_INCREMENT=1254 DEFAULT CHARSET=latin1 COMMENT='Configuration file variables';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_configfilevariables`
--

LOCK TABLES `nagios_configfilevariables` WRITE;
/*!40000 ALTER TABLE `nagios_configfilevariables` DISABLE KEYS */;
INSERT INTO `nagios_configfilevariables` VALUES (1139,1,11,'log_file','/usr/local/monitor/var/nagios.log'),(1140,1,11,'cfg_file','/usr/local/monitor/etc/objects/commands.cfg'),(1147,1,11,'cfg_dir','/usr/local/monitor/etc/itvision'),(1148,1,11,'object_cache_file','/usr/local/monitor/var/objects.cache'),(1149,1,11,'precached_object_file','/usr/local/monitor/var/objects.precache'),(1150,1,11,'resource_file','/usr/local/monitor/etc/resource.cfg'),(1151,1,11,'status_file','/usr/local/monitor/var/status.dat'),(1152,1,11,'status_update_interval','10'),(1153,1,11,'nagios_user','itiv'),(1154,1,11,'nagios_group','itiv'),(1155,1,11,'check_external_commands','1'),(1156,1,11,'command_check_interval','-1'),(1157,1,11,'command_file','/usr/local/monitor/var/rw/nagios.cmd'),(1158,1,11,'external_command_buffer_slots','4096'),(1159,1,11,'lock_file','/usr/local/monitor/var/nagios.lock'),(1160,1,11,'temp_file','/usr/local/monitor/var/nagios.tmp'),(1161,1,11,'temp_path','/tmp'),(1162,1,11,'event_broker_options','-1'),(1163,1,11,'broker_module','/usr/lib/ndoutils/ndomod-mysql-3x.o config_file=/usr/local/monitor/etc/ndomod.cfg'),(1164,1,11,'log_rotation_method','d'),(1165,1,11,'log_archive_path','/usr/local/monitor/var/archives'),(1166,1,11,'use_syslog','1'),(1167,1,11,'log_notifications','1'),(1168,1,11,'log_service_retries','1'),(1169,1,11,'log_host_retries','1'),(1170,1,11,'log_event_handlers','1'),(1171,1,11,'log_initial_states','0'),(1172,1,11,'log_external_commands','1'),(1173,1,11,'log_passive_checks','1'),(1174,1,11,'service_inter_check_delay_method','s'),(1175,1,11,'max_service_check_spread','30'),(1176,1,11,'service_interleave_factor','s'),(1177,1,11,'host_inter_check_delay_method','s'),(1178,1,11,'max_host_check_spread','30'),(1179,1,11,'max_concurrent_checks','0'),(1180,1,11,'check_result_reaper_frequency','10'),(1181,1,11,'max_check_result_reaper_time','30'),(1182,1,11,'check_result_path','/usr/local/monitor/var/spool/checkresults'),(1183,1,11,'max_check_result_file_age','3600'),(1184,1,11,'cached_host_check_horizon','15'),(1185,1,11,'cached_service_check_horizon','15'),(1186,1,11,'enable_predictive_host_dependency_checks','1'),(1187,1,11,'enable_predictive_service_dependency_checks','1'),(1188,1,11,'soft_state_dependencies','0'),(1189,1,11,'auto_reschedule_checks','0'),(1190,1,11,'auto_rescheduling_interval','30'),(1191,1,11,'auto_rescheduling_window','180'),(1192,1,11,'sleep_time','0.25'),(1193,1,11,'service_check_timeout','60'),(1194,1,11,'host_check_timeout','30'),(1195,1,11,'event_handler_timeout','30'),(1196,1,11,'notification_timeout','30'),(1197,1,11,'ocsp_timeout','5'),(1198,1,11,'perfdata_timeout','5'),(1199,1,11,'retain_state_information','1'),(1200,1,11,'state_retention_file','/usr/local/monitor/var/retention.dat'),(1201,1,11,'retention_update_interval','60'),(1202,1,11,'use_retained_program_state','1'),(1203,1,11,'use_retained_scheduling_info','1'),(1204,1,11,'retained_host_attribute_mask','0'),(1205,1,11,'retained_service_attribute_mask','0'),(1206,1,11,'retained_process_host_attribute_mask','0'),(1207,1,11,'retained_process_service_attribute_mask','0'),(1208,1,11,'retained_contact_host_attribute_mask','0'),(1209,1,11,'retained_contact_service_attribute_mask','0'),(1210,1,11,'interval_length','60'),(1211,1,11,'check_for_updates','1'),(1212,1,11,'bare_update_check','0'),(1213,1,11,'use_aggressive_host_checking','0'),(1214,1,11,'execute_service_checks','1'),(1215,1,11,'accept_passive_service_checks','1'),(1216,1,11,'execute_host_checks','1'),(1217,1,11,'accept_passive_host_checks','1'),(1218,1,11,'enable_notifications','1'),(1219,1,11,'enable_event_handlers','1'),(1220,1,11,'process_performance_data','0'),(1221,1,11,'obsess_over_services','0'),(1222,1,11,'obsess_over_hosts','0'),(1223,1,11,'translate_passive_host_checks','0'),(1224,1,11,'passive_host_checks_are_soft','0'),(1225,1,11,'check_for_orphaned_services','1'),(1226,1,11,'check_for_orphaned_hosts','1'),(1227,1,11,'check_service_freshness','1'),(1228,1,11,'service_freshness_check_interval','60'),(1229,1,11,'check_host_freshness','0'),(1230,1,11,'host_freshness_check_interval','60'),(1231,1,11,'additional_freshness_latency','15'),(1232,1,11,'enable_flap_detection','1'),(1233,1,11,'low_service_flap_threshold','5.0'),(1234,1,11,'high_service_flap_threshold','20.0'),(1235,1,11,'low_host_flap_threshold','5.0'),(1236,1,11,'high_host_flap_threshold','20.0'),(1237,1,11,'date_format','us'),(1238,1,11,'p1_file','/usr/local/monitor/bin/p1.pl'),(1239,1,11,'enable_embedded_perl','1'),(1240,1,11,'use_embedded_perl_implicitly','1'),(1241,1,11,'illegal_object_name_chars','`~!$%^&*|\'\"<>?,()='),(1242,1,11,'illegal_macro_output_chars','`~$&|\'\"<>'),(1243,1,11,'use_regexp_matching','0'),(1244,1,11,'use_true_regexp_matching','0'),(1245,1,11,'admin_email','itiv@localhost'),(1246,1,11,'admin_pager','pageitiv@localhost'),(1247,1,11,'daemon_dumps_core','0'),(1248,1,11,'use_large_installation_tweaks','0'),(1249,1,11,'enable_environment_macros','1'),(1250,1,11,'debug_level','0'),(1251,1,11,'debug_verbosity','1'),(1252,1,11,'debug_file','/usr/local/monitor/var/nagios.debug'),(1253,1,11,'max_debug_file_size','1000000');
/*!40000 ALTER TABLE `nagios_configfilevariables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_conninfo`
--

DROP TABLE IF EXISTS `nagios_conninfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_conninfo` (
  `conninfo_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `agent_name` varchar(32) NOT NULL DEFAULT '',
  `agent_version` varchar(8) NOT NULL DEFAULT '',
  `disposition` varchar(16) NOT NULL DEFAULT '',
  `connect_source` varchar(16) NOT NULL DEFAULT '',
  `connect_type` varchar(16) NOT NULL DEFAULT '',
  `connect_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `disconnect_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_checkin_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `data_start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `data_end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `bytes_processed` int(11) NOT NULL DEFAULT '0',
  `lines_processed` int(11) NOT NULL DEFAULT '0',
  `entries_processed` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`conninfo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1 COMMENT='NDO2DB daemon connection information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_conninfo`
--

LOCK TABLES `nagios_conninfo` WRITE;
/*!40000 ALTER TABLE `nagios_conninfo` DISABLE KEYS */;
INSERT INTO `nagios_conninfo` VALUES (1,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','INITIAL','2010-04-25 18:19:23','2010-04-25 18:19:27','2010-04-25 18:19:27','2010-04-25 18:19:23','2010-04-25 18:19:27',21655,2029,107),(2,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','INITIAL','2010-04-25 18:19:27','2010-04-26 17:15:22','2010-04-26 17:15:22','2010-04-25 18:19:27','2010-04-26 17:15:22',9207002,1366643,108826),(3,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','INITIAL','2010-04-26 17:15:22','2010-04-26 17:31:34','2010-04-26 17:31:34','2010-04-26 17:15:22','2010-04-26 17:31:34',459145,66613,5164),(4,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','INITIAL','2010-04-26 17:31:34','0000-00-00 00:00:00','2010-04-26 17:34:37','2010-04-26 17:31:34','0000-00-00 00:00:00',100845,13765,1033),(5,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','RECONNECT','2010-04-26 17:35:45','2010-04-26 17:43:57','2010-04-26 17:43:57','2010-04-26 17:35:45','2010-04-26 17:43:57',229961,33983,2668),(6,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','INITIAL','2010-04-26 17:43:57','0000-00-00 00:00:00','2010-04-26 17:43:57','2010-04-26 17:43:57','0000-00-00 00:00:00',334,23,0),(7,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','INITIAL','2010-04-26 17:44:05','2010-04-26 17:47:20','2010-04-26 17:47:20','2010-04-26 17:44:05','2010-04-26 17:47:20',118500,15933,1152),(8,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','INITIAL','2010-04-26 17:47:20','2010-04-26 17:50:06','2010-04-26 17:50:06','2010-04-26 17:47:20','2010-04-26 17:50:05',90754,12420,935),(9,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','INITIAL','2010-04-26 17:50:06','0000-00-00 00:00:00','2010-05-04 17:23:33','2010-04-26 17:50:06','0000-00-00 00:00:00',57357920,8413641,651826),(10,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','RECONNECT','2010-05-27 22:39:35','0000-00-00 00:00:00','2010-05-27 22:39:35','2010-05-27 22:39:35','0000-00-00 00:00:00',316,22,0),(11,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','RECONNECT','2010-05-27 22:40:01','0000-00-00 00:00:00','2010-05-27 22:41:02','2010-05-27 22:40:01','0000-00-00 00:00:00',31248,4770,392),(12,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','RECONNECT','2010-05-27 22:41:35','2010-05-27 22:41:49','2010-05-27 22:41:49','2010-05-27 22:41:35','2010-05-27 22:41:49',12467,1881,159),(13,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','INITIAL','2010-05-27 22:50:07','0000-00-00 00:00:00','2010-05-27 22:50:07','2010-05-27 22:50:07','0000-00-00 00:00:00',301,22,0),(14,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','INITIAL','2010-05-27 22:50:42','0000-00-00 00:00:00','2010-05-27 22:50:42','2010-05-27 22:50:42','0000-00-00 00:00:00',314,22,0),(15,1,'NDOMOD','1.4b7','REALTIME','UNIXSOCKET','RECONNECT','2010-05-27 22:51:00','0000-00-00 00:00:00','2010-05-29 09:39:12','2010-05-27 22:51:00','0000-00-00 00:00:00',1862658,273628,21299);
/*!40000 ALTER TABLE `nagios_conninfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_contact_addresses`
--

DROP TABLE IF EXISTS `nagios_contact_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_contact_addresses` (
  `contact_address_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `contact_id` int(11) NOT NULL DEFAULT '0',
  `address_number` smallint(6) NOT NULL DEFAULT '0',
  `address` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`contact_address_id`),
  UNIQUE KEY `contact_id` (`contact_id`,`address_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contact addresses';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_contact_addresses`
--

LOCK TABLES `nagios_contact_addresses` WRITE;
/*!40000 ALTER TABLE `nagios_contact_addresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_contact_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_contact_notificationcommands`
--

DROP TABLE IF EXISTS `nagios_contact_notificationcommands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_contact_notificationcommands` (
  `contact_notificationcommand_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `contact_id` int(11) NOT NULL DEFAULT '0',
  `notification_type` smallint(6) NOT NULL DEFAULT '0',
  `command_object_id` int(11) NOT NULL DEFAULT '0',
  `command_args` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`contact_notificationcommand_id`),
  UNIQUE KEY `contact_id` (`contact_id`,`notification_type`,`command_object_id`,`command_args`)
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=latin1 COMMENT='Contact host and service notification commands';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_contact_notificationcommands`
--

LOCK TABLES `nagios_contact_notificationcommands` WRITE;
/*!40000 ALTER TABLE `nagios_contact_notificationcommands` DISABLE KEYS */;
INSERT INTO `nagios_contact_notificationcommands` VALUES (121,1,11,0,40,''),(122,1,11,0,41,''),(123,1,11,0,42,''),(124,1,11,0,43,''),(125,1,11,0,44,''),(126,1,11,0,45,''),(127,1,11,1,40,''),(128,1,11,1,41,''),(129,1,11,1,42,''),(130,1,11,1,43,''),(131,1,11,1,44,''),(132,1,11,1,45,'');
/*!40000 ALTER TABLE `nagios_contact_notificationcommands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_contactgroup_members`
--

DROP TABLE IF EXISTS `nagios_contactgroup_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_contactgroup_members` (
  `contactgroup_member_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `contactgroup_id` int(11) NOT NULL DEFAULT '0',
  `contact_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`contactgroup_member_id`),
  UNIQUE KEY `instance_id` (`contactgroup_id`,`contact_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COMMENT='Contactgroup members';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_contactgroup_members`
--

LOCK TABLES `nagios_contactgroup_members` WRITE;
/*!40000 ALTER TABLE `nagios_contactgroup_members` DISABLE KEYS */;
INSERT INTO `nagios_contactgroup_members` VALUES (11,1,11,11);
/*!40000 ALTER TABLE `nagios_contactgroup_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_contactgroups`
--

DROP TABLE IF EXISTS `nagios_contactgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_contactgroups` (
  `contactgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `contactgroup_object_id` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`contactgroup_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`config_type`,`contactgroup_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COMMENT='Contactgroup definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_contactgroups`
--

LOCK TABLES `nagios_contactgroups` WRITE;
/*!40000 ALTER TABLE `nagios_contactgroups` DISABLE KEYS */;
INSERT INTO `nagios_contactgroups` VALUES (11,1,1,46,'Nagios Administrators');
/*!40000 ALTER TABLE `nagios_contactgroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_contactnotificationmethods`
--

DROP TABLE IF EXISTS `nagios_contactnotificationmethods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_contactnotificationmethods` (
  `contactnotificationmethod_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `contactnotification_id` int(11) NOT NULL DEFAULT '0',
  `start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `start_time_usec` int(11) NOT NULL DEFAULT '0',
  `end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_time_usec` int(11) NOT NULL DEFAULT '0',
  `command_object_id` int(11) NOT NULL DEFAULT '0',
  `command_args` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`contactnotificationmethod_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`contactnotification_id`,`start_time`,`start_time_usec`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1 COMMENT='Historical record of contact notification methods';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_contactnotificationmethods`
--

LOCK TABLES `nagios_contactnotificationmethods` WRITE;
/*!40000 ALTER TABLE `nagios_contactnotificationmethods` DISABLE KEYS */;
INSERT INTO `nagios_contactnotificationmethods` VALUES (1,1,1,'2010-04-25 18:40:57',169159,'2010-04-25 18:40:57',215953,33,''),(3,1,3,'2010-04-25 19:15:57',40069,'2010-04-25 19:15:57',54192,33,''),(5,1,5,'2010-04-27 15:57:16',138145,'2010-04-27 15:57:16',184538,33,''),(7,1,7,'2010-04-27 16:57:16',34965,'2010-04-27 16:57:16',48521,33,''),(9,1,9,'2010-04-27 17:12:16',124133,'2010-04-27 17:12:16',142896,33,''),(11,1,11,'2010-04-27 17:22:16',132233,'2010-04-27 17:22:16',151097,33,''),(13,1,13,'2010-04-27 18:22:16',247611,'2010-04-27 18:22:16',262176,33,''),(15,1,15,'2010-04-27 19:22:16',135591,'2010-04-27 19:22:16',150067,33,''),(17,1,17,'2010-04-27 20:22:16',241545,'2010-04-27 20:22:16',255360,33,''),(19,1,19,'2010-04-27 21:22:16',88977,'2010-04-27 21:22:16',102934,33,''),(21,1,21,'2010-04-27 21:27:16',194806,'2010-04-27 21:27:16',208825,33,'');
/*!40000 ALTER TABLE `nagios_contactnotificationmethods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_contactnotifications`
--

DROP TABLE IF EXISTS `nagios_contactnotifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_contactnotifications` (
  `contactnotification_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `notification_id` int(11) NOT NULL DEFAULT '0',
  `contact_object_id` int(11) NOT NULL DEFAULT '0',
  `start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `start_time_usec` int(11) NOT NULL DEFAULT '0',
  `end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_time_usec` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`contactnotification_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`contact_object_id`,`start_time`,`start_time_usec`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1 COMMENT='Historical record of contact notifications';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_contactnotifications`
--

LOCK TABLES `nagios_contactnotifications` WRITE;
/*!40000 ALTER TABLE `nagios_contactnotifications` DISABLE KEYS */;
INSERT INTO `nagios_contactnotifications` VALUES (1,1,1,11,'2010-04-25 18:40:57',169147,'2010-04-25 18:40:57',215975),(3,1,3,11,'2010-04-25 19:15:57',40057,'2010-04-25 19:15:57',54212),(5,1,5,11,'2010-04-27 15:57:16',138134,'2010-04-27 15:57:16',184563),(7,1,7,11,'2010-04-27 16:57:16',34954,'2010-04-27 16:57:16',48543),(9,1,9,11,'2010-04-27 17:12:16',124118,'2010-04-27 17:12:16',142920),(11,1,11,11,'2010-04-27 17:22:16',132224,'2010-04-27 17:22:16',151118),(13,1,13,11,'2010-04-27 18:22:16',247595,'2010-04-27 18:22:16',262187),(15,1,15,11,'2010-04-27 19:22:16',135581,'2010-04-27 19:22:16',150091),(17,1,17,11,'2010-04-27 20:22:16',241531,'2010-04-27 20:22:16',255373),(19,1,19,11,'2010-04-27 21:22:16',88966,'2010-04-27 21:22:16',102948),(21,1,21,11,'2010-04-27 21:27:16',194798,'2010-04-27 21:27:16',208847);
/*!40000 ALTER TABLE `nagios_contactnotifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_contacts`
--

DROP TABLE IF EXISTS `nagios_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_contacts` (
  `contact_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `contact_object_id` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(64) NOT NULL DEFAULT '',
  `email_address` varchar(255) NOT NULL DEFAULT '',
  `pager_address` varchar(64) NOT NULL DEFAULT '',
  `host_timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  `service_timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  `host_notifications_enabled` smallint(6) NOT NULL DEFAULT '0',
  `service_notifications_enabled` smallint(6) NOT NULL DEFAULT '0',
  `can_submit_commands` smallint(6) NOT NULL DEFAULT '0',
  `notify_service_recovery` smallint(6) NOT NULL DEFAULT '0',
  `notify_service_warning` smallint(6) NOT NULL DEFAULT '0',
  `notify_service_unknown` smallint(6) NOT NULL DEFAULT '0',
  `notify_service_critical` smallint(6) NOT NULL DEFAULT '0',
  `notify_service_flapping` smallint(6) NOT NULL DEFAULT '0',
  `notify_service_downtime` smallint(6) NOT NULL DEFAULT '0',
  `notify_host_recovery` smallint(6) NOT NULL DEFAULT '0',
  `notify_host_down` smallint(6) NOT NULL DEFAULT '0',
  `notify_host_unreachable` smallint(6) NOT NULL DEFAULT '0',
  `notify_host_flapping` smallint(6) NOT NULL DEFAULT '0',
  `notify_host_downtime` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`contact_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`config_type`,`contact_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COMMENT='Contact definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_contacts`
--

LOCK TABLES `nagios_contacts` WRITE;
/*!40000 ALTER TABLE `nagios_contacts` DISABLE KEYS */;
INSERT INTO `nagios_contacts` VALUES (11,1,1,11,'Nagios Admin','itiv@localhost','',2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
/*!40000 ALTER TABLE `nagios_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_contactstatus`
--

DROP TABLE IF EXISTS `nagios_contactstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_contactstatus` (
  `contactstatus_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `contact_object_id` int(11) NOT NULL DEFAULT '0',
  `status_update_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `host_notifications_enabled` smallint(6) NOT NULL DEFAULT '0',
  `service_notifications_enabled` smallint(6) NOT NULL DEFAULT '0',
  `last_host_notification` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_service_notification` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_attributes` int(11) NOT NULL DEFAULT '0',
  `modified_host_attributes` int(11) NOT NULL DEFAULT '0',
  `modified_service_attributes` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`contactstatus_id`),
  UNIQUE KEY `contact_object_id` (`contact_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COMMENT='Contact status';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_contactstatus`
--

LOCK TABLES `nagios_contactstatus` WRITE;
/*!40000 ALTER TABLE `nagios_contactstatus` DISABLE KEYS */;
INSERT INTO `nagios_contactstatus` VALUES (11,1,11,'2010-05-27 22:50:42',1,1,'1969-12-31 16:00:00','2010-04-27 21:27:16',0,0,0);
/*!40000 ALTER TABLE `nagios_contactstatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_customvariables`
--

DROP TABLE IF EXISTS `nagios_customvariables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_customvariables` (
  `customvariable_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `has_been_modified` smallint(6) NOT NULL DEFAULT '0',
  `varname` varchar(255) NOT NULL DEFAULT '',
  `varvalue` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`customvariable_id`),
  UNIQUE KEY `object_id_2` (`object_id`,`config_type`,`varname`),
  KEY `varname` (`varname`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Custom variables';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_customvariables`
--

LOCK TABLES `nagios_customvariables` WRITE;
/*!40000 ALTER TABLE `nagios_customvariables` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_customvariables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_customvariablestatus`
--

DROP TABLE IF EXISTS `nagios_customvariablestatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_customvariablestatus` (
  `customvariablestatus_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `status_update_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `has_been_modified` smallint(6) NOT NULL DEFAULT '0',
  `varname` varchar(255) NOT NULL DEFAULT '',
  `varvalue` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`customvariablestatus_id`),
  UNIQUE KEY `object_id_2` (`object_id`,`varname`),
  KEY `varname` (`varname`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Custom variable status information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_customvariablestatus`
--

LOCK TABLES `nagios_customvariablestatus` WRITE;
/*!40000 ALTER TABLE `nagios_customvariablestatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_customvariablestatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_dbversion`
--

DROP TABLE IF EXISTS `nagios_dbversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_dbversion` (
  `name` varchar(10) NOT NULL DEFAULT '',
  `version` varchar(10) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_dbversion`
--

LOCK TABLES `nagios_dbversion` WRITE;
/*!40000 ALTER TABLE `nagios_dbversion` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_dbversion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_downtimehistory`
--

DROP TABLE IF EXISTS `nagios_downtimehistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_downtimehistory` (
  `downtimehistory_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `downtime_type` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `entry_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `author_name` varchar(64) NOT NULL DEFAULT '',
  `comment_data` varchar(255) NOT NULL DEFAULT '',
  `internal_downtime_id` int(11) NOT NULL DEFAULT '0',
  `triggered_by_id` int(11) NOT NULL DEFAULT '0',
  `is_fixed` smallint(6) NOT NULL DEFAULT '0',
  `duration` smallint(6) NOT NULL DEFAULT '0',
  `scheduled_start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `scheduled_end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `was_started` smallint(6) NOT NULL DEFAULT '0',
  `actual_start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `actual_start_time_usec` int(11) NOT NULL DEFAULT '0',
  `actual_end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `actual_end_time_usec` int(11) NOT NULL DEFAULT '0',
  `was_cancelled` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`downtimehistory_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`object_id`,`entry_time`,`internal_downtime_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historical scheduled host and service downtime';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_downtimehistory`
--

LOCK TABLES `nagios_downtimehistory` WRITE;
/*!40000 ALTER TABLE `nagios_downtimehistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_downtimehistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_eventhandlers`
--

DROP TABLE IF EXISTS `nagios_eventhandlers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_eventhandlers` (
  `eventhandler_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `eventhandler_type` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `state` smallint(6) NOT NULL DEFAULT '0',
  `state_type` smallint(6) NOT NULL DEFAULT '0',
  `start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `start_time_usec` int(11) NOT NULL DEFAULT '0',
  `end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_time_usec` int(11) NOT NULL DEFAULT '0',
  `command_object_id` int(11) NOT NULL DEFAULT '0',
  `command_args` varchar(255) NOT NULL DEFAULT '',
  `command_line` varchar(255) NOT NULL DEFAULT '',
  `timeout` smallint(6) NOT NULL DEFAULT '0',
  `early_timeout` smallint(6) NOT NULL DEFAULT '0',
  `execution_time` double NOT NULL DEFAULT '0',
  `return_code` smallint(6) NOT NULL DEFAULT '0',
  `output` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`eventhandler_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`object_id`,`start_time`,`start_time_usec`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historical host and service event handlers';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_eventhandlers`
--

LOCK TABLES `nagios_eventhandlers` WRITE;
/*!40000 ALTER TABLE `nagios_eventhandlers` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_eventhandlers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_externalcommands`
--

DROP TABLE IF EXISTS `nagios_externalcommands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_externalcommands` (
  `externalcommand_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `entry_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `command_type` smallint(6) NOT NULL DEFAULT '0',
  `command_name` varchar(128) NOT NULL DEFAULT '',
  `command_args` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`externalcommand_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historical record of processed external commands';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_externalcommands`
--

LOCK TABLES `nagios_externalcommands` WRITE;
/*!40000 ALTER TABLE `nagios_externalcommands` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_externalcommands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_flappinghistory`
--

DROP TABLE IF EXISTS `nagios_flappinghistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_flappinghistory` (
  `flappinghistory_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `event_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `event_time_usec` int(11) NOT NULL DEFAULT '0',
  `event_type` smallint(6) NOT NULL DEFAULT '0',
  `reason_type` smallint(6) NOT NULL DEFAULT '0',
  `flapping_type` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `percent_state_change` double NOT NULL DEFAULT '0',
  `low_threshold` double NOT NULL DEFAULT '0',
  `high_threshold` double NOT NULL DEFAULT '0',
  `comment_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `internal_comment_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`flappinghistory_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Current and historical record of host and service flapping';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_flappinghistory`
--

LOCK TABLES `nagios_flappinghistory` WRITE;
/*!40000 ALTER TABLE `nagios_flappinghistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_flappinghistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_host_contactgroups`
--

DROP TABLE IF EXISTS `nagios_host_contactgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_host_contactgroups` (
  `host_contactgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `host_id` int(11) NOT NULL DEFAULT '0',
  `contactgroup_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`host_contactgroup_id`),
  UNIQUE KEY `instance_id` (`host_id`,`contactgroup_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1 COMMENT='Host contact groups';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_host_contactgroups`
--

LOCK TABLES `nagios_host_contactgroups` WRITE;
/*!40000 ALTER TABLE `nagios_host_contactgroups` DISABLE KEYS */;
INSERT INTO `nagios_host_contactgroups` VALUES (1,1,1,46),(2,1,2,46),(3,1,3,46),(4,1,4,46),(5,1,5,46),(6,1,6,46),(7,1,7,46),(8,1,8,46),(9,1,9,46),(10,1,10,46),(11,1,11,46),(12,1,12,46),(13,1,13,46),(14,1,14,46),(15,1,15,46),(16,1,16,46),(17,1,17,46),(18,1,18,46),(19,1,19,46),(20,1,20,46),(21,1,21,46),(22,1,22,46),(23,1,23,46),(24,1,24,46),(25,1,25,46),(26,1,26,46),(27,1,27,46),(28,1,28,46),(29,1,29,46),(30,1,30,46),(31,1,31,46),(32,1,32,46);
/*!40000 ALTER TABLE `nagios_host_contactgroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_host_contacts`
--

DROP TABLE IF EXISTS `nagios_host_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_host_contacts` (
  `host_contact_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `host_id` int(11) NOT NULL DEFAULT '0',
  `contact_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`host_contact_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`host_id`,`contact_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_host_contacts`
--

LOCK TABLES `nagios_host_contacts` WRITE;
/*!40000 ALTER TABLE `nagios_host_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_host_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_host_parenthosts`
--

DROP TABLE IF EXISTS `nagios_host_parenthosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_host_parenthosts` (
  `host_parenthost_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `host_id` int(11) NOT NULL DEFAULT '0',
  `parent_host_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`host_parenthost_id`),
  UNIQUE KEY `instance_id` (`host_id`,`parent_host_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parent hosts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_host_parenthosts`
--

LOCK TABLES `nagios_host_parenthosts` WRITE;
/*!40000 ALTER TABLE `nagios_host_parenthosts` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_host_parenthosts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_hostchecks`
--

DROP TABLE IF EXISTS `nagios_hostchecks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_hostchecks` (
  `hostcheck_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `host_object_id` int(11) NOT NULL DEFAULT '0',
  `check_type` smallint(6) NOT NULL DEFAULT '0',
  `is_raw_check` smallint(6) NOT NULL DEFAULT '0',
  `current_check_attempt` smallint(6) NOT NULL DEFAULT '0',
  `max_check_attempts` smallint(6) NOT NULL DEFAULT '0',
  `state` smallint(6) NOT NULL DEFAULT '0',
  `state_type` smallint(6) NOT NULL DEFAULT '0',
  `start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `start_time_usec` int(11) NOT NULL DEFAULT '0',
  `end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_time_usec` int(11) NOT NULL DEFAULT '0',
  `command_object_id` int(11) NOT NULL DEFAULT '0',
  `command_args` varchar(255) NOT NULL DEFAULT '',
  `command_line` varchar(255) NOT NULL DEFAULT '',
  `timeout` smallint(6) NOT NULL DEFAULT '0',
  `early_timeout` smallint(6) NOT NULL DEFAULT '0',
  `execution_time` double NOT NULL DEFAULT '0',
  `latency` double NOT NULL DEFAULT '0',
  `return_code` smallint(6) NOT NULL DEFAULT '0',
  `output` varchar(255) NOT NULL DEFAULT '',
  `perfdata` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`hostcheck_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`host_object_id`,`start_time`,`start_time_usec`)
) ENGINE=InnoDB AUTO_INCREMENT=2822 DEFAULT CHARSET=latin1 COMMENT='Historical host checks';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_hostchecks`
--

LOCK TABLES `nagios_hostchecks` WRITE;
/*!40000 ALTER TABLE `nagios_hostchecks` DISABLE KEYS */;
INSERT INTO `nagios_hostchecks` VALUES (2702,1,51,0,0,1,3,0,1,'2010-05-27 22:40:22',125769,'2010-05-27 22:40:27',140110,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01277,0.125,0,'OK',''),(2704,1,1,0,0,1,10,0,1,'2010-05-27 22:42:37',198092,'2010-05-27 22:42:49',220871,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.01204,0.197,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.040000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2706,1,53,0,0,1,10,0,1,'2010-05-27 22:43:27',38420,'2010-05-27 22:43:39',67175,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.04215,0.038,0,'PING OK - Packet loss = 0%, RTA = 20.93 ms','rta=20.931999ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2708,1,50,0,0,1,3,0,1,'2010-05-27 22:43:57',100503,'2010-05-27 22:43:59',107750,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01076,0.1,0,'OK',''),(2710,1,51,0,0,1,3,0,1,'2010-05-27 22:45:27',8533,'2010-05-27 22:45:29',16794,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01124,0.008,0,'OK',''),(2712,1,1,0,0,1,10,0,1,'2010-05-27 22:47:49',243979,'2010-05-27 22:47:59',22643,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.0107,0.243,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.037000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2714,1,53,0,0,1,10,0,1,'2010-05-27 22:48:39',98019,'2010-05-27 22:48:49',123812,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.04619,0.097,0,'PING OK - Packet loss = 0%, RTA = 25.10 ms','rta=25.103001ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2716,1,50,0,0,1,3,0,1,'2010-05-27 22:48:59',139137,'2010-05-27 22:49:09',177061,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01222,0.139,0,'OK',''),(2718,1,51,0,0,1,3,0,1,'2010-05-27 22:50:29',99585,'2010-05-27 22:50:38',117936,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.0126,0.099,0,'OK',''),(2720,1,1,0,0,1,10,0,1,'2010-05-27 22:52:59',146416,'2010-05-27 22:53:12',175033,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.01426,0.146,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.040000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2722,1,53,0,0,1,10,0,1,'2010-05-27 22:53:49',9418,'2010-05-27 22:54:02',40381,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.04765,0.009,0,'PING OK - Packet loss = 0%, RTA = 25.50 ms','rta=25.500000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2724,1,50,0,0,1,3,0,1,'2010-05-27 22:54:09',75938,'2010-05-27 22:54:12',86995,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01191,0.075,0,'OK',''),(2726,1,51,0,0,1,3,0,1,'2010-05-27 22:55:38',225253,'2010-05-27 22:55:42',237819,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.0126,0.225,0,'OK',''),(2728,1,1,0,0,1,10,0,1,'2010-05-27 22:58:12',242568,'2010-05-27 22:58:22',16729,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.01297,0.242,0,'PING OK - Packet loss = 0%, RTA = 0.03 ms','rta=0.032000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2730,1,53,0,0,1,10,0,1,'2010-05-27 22:59:02',104022,'2010-05-27 22:59:12',144504,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.07724,0.103,0,'PING OK - Packet loss = 0%, RTA = 27.22 ms','rta=27.219999ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2732,1,50,0,0,1,3,0,1,'2010-05-27 22:59:12',146842,'2010-05-27 22:59:22',174389,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.02091,0.146,0,'OK',''),(2734,1,51,0,0,1,3,0,1,'2010-05-27 23:00:42',54997,'2010-05-27 23:00:52',82706,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01842,0.054,0,'OK',''),(2736,1,1,0,0,1,10,0,1,'2010-05-27 23:03:22',99959,'2010-05-27 23:03:32',136824,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.01326,0.099,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.040000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2738,1,53,0,0,1,10,0,1,'2010-05-27 23:04:12',240964,'2010-05-27 23:04:22',15969,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.05057,0.24,0,'PING OK - Packet loss = 0%, RTA = 20.00 ms','rta=20.004000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2740,1,50,0,0,1,3,0,1,'2010-05-27 23:04:22',18185,'2010-05-27 23:04:32',41382,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01575,0.017,0,'OK',''),(2742,1,51,0,0,1,3,0,1,'2010-05-27 23:05:52',169043,'2010-05-27 23:06:02',191618,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.0148,0.168,0,'OK',''),(2744,1,1,0,0,1,10,0,1,'2010-05-27 23:08:32',221782,'2010-05-27 23:08:42',248066,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.0186,0.221,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.038000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2746,1,53,0,0,1,10,0,1,'2010-05-27 23:09:22',100170,'2010-05-27 23:09:32',122560,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.04677,0.1,0,'PING OK - Packet loss = 0%, RTA = 22.62 ms','rta=22.617001ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2748,1,50,0,0,1,3,0,1,'2010-05-27 23:09:32',123502,'2010-05-27 23:09:42',148662,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01741,0.123,0,'OK',''),(2750,1,51,0,0,1,3,0,1,'2010-05-27 23:11:02',32715,'2010-05-27 23:11:12',54783,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01324,0.032,0,'OK',''),(2752,1,1,0,0,1,10,0,1,'2010-05-27 23:13:42',86079,'2010-05-27 23:13:52',116417,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.03425,0.086,0,'PING OK - Packet loss = 0%, RTA = 0.05 ms','rta=0.052000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2754,1,53,0,0,1,10,0,1,'2010-05-27 23:14:32',205154,'2010-05-27 23:14:42',228617,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.04671,0.205,0,'PING OK - Packet loss = 0%, RTA = 26.41 ms','rta=26.410000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2756,1,50,0,0,1,3,0,1,'2010-05-27 23:14:42',229837,'2010-05-27 23:14:52',4806,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.019,0.229,0,'OK',''),(2758,1,51,0,0,1,3,0,1,'2010-05-27 23:16:12',134339,'2010-05-27 23:16:22',163892,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01566,0.134,0,'OK',''),(2760,1,1,0,0,1,10,0,1,'2010-05-27 23:18:52',204693,'2010-05-27 23:19:02',229932,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.01596,0.204,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.038000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2762,1,53,0,0,1,10,0,1,'2010-05-27 23:19:42',73344,'2010-05-27 23:19:52',99505,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.11867,0.072,0,'PING OK - Packet loss = 0%, RTA = 35.83 ms','rta=35.833000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2764,1,50,0,0,1,3,0,1,'2010-05-27 23:19:52',100428,'2010-05-27 23:20:02',125153,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01705,0.1,0,'OK',''),(2766,1,51,0,0,1,3,0,1,'2010-05-27 23:21:22',12967,'2010-05-27 23:21:32',38154,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.0162,0.012,0,'OK',''),(2768,1,1,0,0,1,10,0,1,'2010-05-27 23:24:02',73466,'2010-05-27 23:24:12',115015,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.02942,0.073,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.037000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2770,1,53,0,0,1,10,0,1,'2010-05-27 23:24:52',179873,'2010-05-27 23:25:02',202279,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.05233,0.179,0,'PING OK - Packet loss = 0%, RTA = 22.46 ms','rta=22.459000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2772,1,50,0,0,1,3,0,1,'2010-05-27 23:25:02',204452,'2010-05-27 23:25:12',230227,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01522,0.203,0,'OK',''),(2774,1,51,0,0,1,3,0,1,'2010-05-27 23:26:32',116346,'2010-05-27 23:26:42',138317,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01324,0.116,0,'OK',''),(2776,1,1,0,0,1,10,0,1,'2010-05-27 23:29:12',193560,'2010-05-27 23:29:22',215174,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.01176,0.192,0,'PING OK - Packet loss = 0%, RTA = 0.03 ms','rta=0.034000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2778,1,53,0,0,1,10,0,1,'2010-05-27 23:30:02',31817,'2010-05-27 23:30:12',55012,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.04616,0.031,0,'PING OK - Packet loss = 0%, RTA = 26.31 ms','rta=26.309000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2780,1,50,0,0,1,3,0,1,'2010-05-27 23:30:12',56902,'2010-05-27 23:30:22',81742,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01686,0.056,0,'OK',''),(2782,1,51,0,0,1,3,0,1,'2010-05-27 23:31:42',220099,'2010-05-27 23:31:52',245374,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01615,0.219,0,'OK',''),(2784,1,1,0,0,1,10,0,1,'2010-05-27 23:34:22',52895,'2010-05-27 23:34:32',76951,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.01736,0.052,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.044000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2786,1,53,0,0,1,10,0,1,'2010-05-27 23:35:12',145086,'2010-05-27 23:35:22',166997,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.04447,0.143,0,'PING OK - Packet loss = 0%, RTA = 23.29 ms','rta=23.291000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2788,1,50,0,0,1,3,0,1,'2010-05-27 23:35:22',168829,'2010-05-27 23:35:32',192535,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01452,0.168,0,'OK',''),(2790,1,51,0,0,1,3,0,1,'2010-05-27 23:36:52',78650,'2010-05-27 23:37:02',102946,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01591,0.078,0,'OK',''),(2792,1,1,0,0,1,10,0,1,'2010-05-27 23:39:32',159950,'2010-05-27 23:39:42',185377,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.0134,0.159,0,'PING OK - Packet loss = 0%, RTA = 0.03 ms','rta=0.033000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2794,1,53,0,0,1,10,0,1,'2010-05-27 23:40:22',249787,'2010-05-27 23:40:32',22405,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.04733,0.249,0,'PING OK - Packet loss = 0%, RTA = 22.71 ms','rta=22.709999ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2796,1,50,0,0,1,3,0,1,'2010-05-27 23:40:32',24729,'2010-05-27 23:40:42',52605,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.02002,0.023,0,'OK',''),(2798,1,51,0,0,1,3,0,1,'2010-05-27 23:42:02',191666,'2010-05-27 23:42:12',213438,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01339,0.19,0,'OK',''),(2800,1,1,0,0,1,10,0,1,'2010-05-27 23:44:42',28956,'2010-05-27 23:44:52',65570,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.03113,0.027,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.037000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2802,1,53,0,0,1,10,0,1,'2010-05-27 23:45:32',132208,'2010-05-27 23:45:42',154504,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.04451,0.131,0,'PING OK - Packet loss = 0%, RTA = 24.24 ms','rta=24.236000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2804,1,50,0,0,1,3,0,1,'2010-05-27 23:45:42',156530,'2010-05-27 23:45:52',182987,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01794,0.155,0,'OK',''),(2806,1,51,0,0,1,3,0,1,'2010-05-27 23:47:12',88056,'2010-05-27 23:47:22',106574,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01132,0.087,0,'OK',''),(2808,1,1,0,0,1,10,0,1,'2010-05-27 23:49:52',156124,'2010-05-27 23:50:02',178123,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.014,0.155,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.038000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2810,1,53,0,0,1,10,0,1,'2010-05-27 23:50:42',247221,'2010-05-27 23:50:52',22088,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.04549,0.246,0,'PING OK - Packet loss = 0%, RTA = 22.25 ms','rta=22.250999ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2812,1,50,0,0,1,3,0,1,'2010-05-27 23:50:52',24245,'2010-05-27 23:51:02',46427,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01345,0.023,0,'OK',''),(2814,1,51,0,0,1,3,0,1,'2010-05-27 23:52:22',186493,'2010-05-27 23:52:32',213930,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.02155,0.186,0,'OK',''),(2816,1,1,0,0,1,10,0,1,'2010-05-27 23:55:02',12009,'2010-05-27 23:55:12',33749,12,'','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.01838,0.011,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.039000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2818,1,53,0,0,1,10,0,1,'2010-05-27 23:55:52',100251,'2010-05-27 23:56:02',124632,12,'','/usr/local/monitor/libexec/check_ping -H 147.65.1.2 -w 3000.0,80% -c 5000.0,100% -p 5',30,0,4.04483,0.1,0,'PING OK - Packet loss = 0%, RTA = 21.40 ms','rta=21.403999ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0'),(2820,1,50,0,0,1,3,0,1,'2010-05-27 23:56:02',127071,'1969-12-31 16:00:00',0,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0,0.126,0,'',''),(2821,1,51,0,0,1,3,0,1,'2010-05-29 09:38:37',32838,'2010-05-29 09:38:47',54040,49,'','/usr/local/monitor/libexec/check_dummy 0',30,0,0.01246,0.032,0,'OK','');
/*!40000 ALTER TABLE `nagios_hostchecks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_hostdependencies`
--

DROP TABLE IF EXISTS `nagios_hostdependencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_hostdependencies` (
  `hostdependency_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `host_object_id` int(11) NOT NULL DEFAULT '0',
  `dependent_host_object_id` int(11) NOT NULL DEFAULT '0',
  `dependency_type` smallint(6) NOT NULL DEFAULT '0',
  `inherits_parent` smallint(6) NOT NULL DEFAULT '0',
  `timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  `fail_on_up` smallint(6) NOT NULL DEFAULT '0',
  `fail_on_down` smallint(6) NOT NULL DEFAULT '0',
  `fail_on_unreachable` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`hostdependency_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`config_type`,`host_object_id`,`dependent_host_object_id`,`dependency_type`,`inherits_parent`,`fail_on_up`,`fail_on_down`,`fail_on_unreachable`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Host dependency definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_hostdependencies`
--

LOCK TABLES `nagios_hostdependencies` WRITE;
/*!40000 ALTER TABLE `nagios_hostdependencies` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_hostdependencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_hostescalation_contactgroups`
--

DROP TABLE IF EXISTS `nagios_hostescalation_contactgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_hostescalation_contactgroups` (
  `hostescalation_contactgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `hostescalation_id` int(11) NOT NULL DEFAULT '0',
  `contactgroup_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`hostescalation_contactgroup_id`),
  UNIQUE KEY `instance_id` (`hostescalation_id`,`contactgroup_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Host escalation contact groups';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_hostescalation_contactgroups`
--

LOCK TABLES `nagios_hostescalation_contactgroups` WRITE;
/*!40000 ALTER TABLE `nagios_hostescalation_contactgroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_hostescalation_contactgroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_hostescalation_contacts`
--

DROP TABLE IF EXISTS `nagios_hostescalation_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_hostescalation_contacts` (
  `hostescalation_contact_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `hostescalation_id` int(11) NOT NULL DEFAULT '0',
  `contact_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`hostescalation_contact_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`hostescalation_id`,`contact_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_hostescalation_contacts`
--

LOCK TABLES `nagios_hostescalation_contacts` WRITE;
/*!40000 ALTER TABLE `nagios_hostescalation_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_hostescalation_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_hostescalations`
--

DROP TABLE IF EXISTS `nagios_hostescalations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_hostescalations` (
  `hostescalation_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `host_object_id` int(11) NOT NULL DEFAULT '0',
  `timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  `first_notification` smallint(6) NOT NULL DEFAULT '0',
  `last_notification` smallint(6) NOT NULL DEFAULT '0',
  `notification_interval` double NOT NULL DEFAULT '0',
  `escalate_on_recovery` smallint(6) NOT NULL DEFAULT '0',
  `escalate_on_down` smallint(6) NOT NULL DEFAULT '0',
  `escalate_on_unreachable` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`hostescalation_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`config_type`,`host_object_id`,`timeperiod_object_id`,`first_notification`,`last_notification`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Host escalation definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_hostescalations`
--

LOCK TABLES `nagios_hostescalations` WRITE;
/*!40000 ALTER TABLE `nagios_hostescalations` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_hostescalations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_hostgroup_members`
--

DROP TABLE IF EXISTS `nagios_hostgroup_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_hostgroup_members` (
  `hostgroup_member_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `hostgroup_id` int(11) NOT NULL DEFAULT '0',
  `host_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`hostgroup_member_id`),
  UNIQUE KEY `instance_id` (`hostgroup_id`,`host_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COMMENT='Hostgroup members';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_hostgroup_members`
--

LOCK TABLES `nagios_hostgroup_members` WRITE;
/*!40000 ALTER TABLE `nagios_hostgroup_members` DISABLE KEYS */;
INSERT INTO `nagios_hostgroup_members` VALUES (11,1,11,1);
/*!40000 ALTER TABLE `nagios_hostgroup_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_hostgroups`
--

DROP TABLE IF EXISTS `nagios_hostgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_hostgroups` (
  `hostgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `hostgroup_object_id` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`hostgroup_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`hostgroup_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COMMENT='Hostgroup definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_hostgroups`
--

LOCK TABLES `nagios_hostgroups` WRITE;
/*!40000 ALTER TABLE `nagios_hostgroups` DISABLE KEYS */;
INSERT INTO `nagios_hostgroups` VALUES (11,1,1,47,'Linux Servers');
/*!40000 ALTER TABLE `nagios_hostgroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_hosts`
--

DROP TABLE IF EXISTS `nagios_hosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_hosts` (
  `host_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `host_object_id` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(64) NOT NULL DEFAULT '',
  `display_name` varchar(64) NOT NULL DEFAULT '',
  `address` varchar(128) NOT NULL DEFAULT '',
  `check_command_object_id` int(11) NOT NULL DEFAULT '0',
  `check_command_args` varchar(255) NOT NULL DEFAULT '',
  `eventhandler_command_object_id` int(11) NOT NULL DEFAULT '0',
  `eventhandler_command_args` varchar(255) NOT NULL DEFAULT '',
  `notification_timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  `check_timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  `failure_prediction_options` varchar(64) NOT NULL DEFAULT '',
  `check_interval` double NOT NULL DEFAULT '0',
  `retry_interval` double NOT NULL DEFAULT '0',
  `max_check_attempts` smallint(6) NOT NULL DEFAULT '0',
  `first_notification_delay` double NOT NULL DEFAULT '0',
  `notification_interval` double NOT NULL DEFAULT '0',
  `notify_on_down` smallint(6) NOT NULL DEFAULT '0',
  `notify_on_unreachable` smallint(6) NOT NULL DEFAULT '0',
  `notify_on_recovery` smallint(6) NOT NULL DEFAULT '0',
  `notify_on_flapping` smallint(6) NOT NULL DEFAULT '0',
  `notify_on_downtime` smallint(6) NOT NULL DEFAULT '0',
  `stalk_on_up` smallint(6) NOT NULL DEFAULT '0',
  `stalk_on_down` smallint(6) NOT NULL DEFAULT '0',
  `stalk_on_unreachable` smallint(6) NOT NULL DEFAULT '0',
  `flap_detection_enabled` smallint(6) NOT NULL DEFAULT '0',
  `flap_detection_on_up` smallint(6) NOT NULL DEFAULT '0',
  `flap_detection_on_down` smallint(6) NOT NULL DEFAULT '0',
  `flap_detection_on_unreachable` smallint(6) NOT NULL DEFAULT '0',
  `low_flap_threshold` double NOT NULL DEFAULT '0',
  `high_flap_threshold` double NOT NULL DEFAULT '0',
  `process_performance_data` smallint(6) NOT NULL DEFAULT '0',
  `freshness_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `freshness_threshold` smallint(6) NOT NULL DEFAULT '0',
  `passive_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `event_handler_enabled` smallint(6) NOT NULL DEFAULT '0',
  `active_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `retain_status_information` smallint(6) NOT NULL DEFAULT '0',
  `retain_nonstatus_information` smallint(6) NOT NULL DEFAULT '0',
  `notifications_enabled` smallint(6) NOT NULL DEFAULT '0',
  `obsess_over_host` smallint(6) NOT NULL DEFAULT '0',
  `failure_prediction_enabled` smallint(6) NOT NULL DEFAULT '0',
  `notes` varchar(255) NOT NULL DEFAULT '',
  `notes_url` varchar(255) NOT NULL DEFAULT '',
  `action_url` varchar(255) NOT NULL DEFAULT '',
  `icon_image` varchar(255) NOT NULL DEFAULT '',
  `icon_image_alt` varchar(255) NOT NULL DEFAULT '',
  `vrml_image` varchar(255) NOT NULL DEFAULT '',
  `statusmap_image` varchar(255) NOT NULL DEFAULT '',
  `have_2d_coords` smallint(6) NOT NULL DEFAULT '0',
  `x_2d` smallint(6) NOT NULL DEFAULT '0',
  `y_2d` smallint(6) NOT NULL DEFAULT '0',
  `have_3d_coords` smallint(6) NOT NULL DEFAULT '0',
  `x_3d` double NOT NULL DEFAULT '0',
  `y_3d` double NOT NULL DEFAULT '0',
  `z_3d` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`host_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`config_type`,`host_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1 COMMENT='Host definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_hosts`
--

LOCK TABLES `nagios_hosts` WRITE;
/*!40000 ALTER TABLE `nagios_hosts` DISABLE KEYS */;
INSERT INTO `nagios_hosts` VALUES (29,1,1,53,'DNS 2','DNS 2','147.65.1.2',12,'',0,'',39,2,'',5,1,10,0,120,1,1,1,0,0,0,0,0,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,'','','','','','','',0,-1,0,0,0,0,0),(30,1,1,50,'Business Processe','business_processes','10.6.255.99 # dummy IP',49,'',0,'',2,0,'',5,1,3,0,30,1,1,1,1,1,0,0,0,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,'','','','','','','',0,-1,0,0,0,0,0),(31,1,1,51,'untergeordnete Business Processe','business_processes_detail','10.6.255.99 # dummy IP',49,'',0,'',2,0,'',5,1,3,0,30,1,1,1,1,1,0,0,0,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,'','','','','','','',0,-1,0,0,0,0,0),(32,1,1,1,'localhost','localhost','127.0.0.1',12,'',0,'',39,2,'',5,1,10,0,120,1,1,1,0,0,0,0,0,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,'','','','','','','',0,-1,0,0,0,0,0);
/*!40000 ALTER TABLE `nagios_hosts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_hoststatus`
--

DROP TABLE IF EXISTS `nagios_hoststatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_hoststatus` (
  `hoststatus_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `host_object_id` int(11) NOT NULL DEFAULT '0',
  `status_update_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `output` varchar(255) NOT NULL DEFAULT '',
  `perfdata` varchar(255) NOT NULL DEFAULT '',
  `current_state` smallint(6) NOT NULL DEFAULT '0',
  `has_been_checked` smallint(6) NOT NULL DEFAULT '0',
  `should_be_scheduled` smallint(6) NOT NULL DEFAULT '0',
  `current_check_attempt` smallint(6) NOT NULL DEFAULT '0',
  `max_check_attempts` smallint(6) NOT NULL DEFAULT '0',
  `last_check` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `next_check` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `check_type` smallint(6) NOT NULL DEFAULT '0',
  `last_state_change` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_hard_state_change` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_hard_state` smallint(6) NOT NULL DEFAULT '0',
  `last_time_up` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_time_down` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_time_unreachable` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `state_type` smallint(6) NOT NULL DEFAULT '0',
  `last_notification` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `next_notification` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `no_more_notifications` smallint(6) NOT NULL DEFAULT '0',
  `notifications_enabled` smallint(6) NOT NULL DEFAULT '0',
  `problem_has_been_acknowledged` smallint(6) NOT NULL DEFAULT '0',
  `acknowledgement_type` smallint(6) NOT NULL DEFAULT '0',
  `current_notification_number` smallint(6) NOT NULL DEFAULT '0',
  `passive_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `active_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `event_handler_enabled` smallint(6) NOT NULL DEFAULT '0',
  `flap_detection_enabled` smallint(6) NOT NULL DEFAULT '0',
  `is_flapping` smallint(6) NOT NULL DEFAULT '0',
  `percent_state_change` double NOT NULL DEFAULT '0',
  `latency` double NOT NULL DEFAULT '0',
  `execution_time` double NOT NULL DEFAULT '0',
  `scheduled_downtime_depth` smallint(6) NOT NULL DEFAULT '0',
  `failure_prediction_enabled` smallint(6) NOT NULL DEFAULT '0',
  `process_performance_data` smallint(6) NOT NULL DEFAULT '0',
  `obsess_over_host` smallint(6) NOT NULL DEFAULT '0',
  `modified_host_attributes` int(11) NOT NULL DEFAULT '0',
  `event_handler` varchar(255) NOT NULL DEFAULT '',
  `check_command` varchar(255) NOT NULL DEFAULT '',
  `normal_check_interval` double NOT NULL DEFAULT '0',
  `retry_check_interval` double NOT NULL DEFAULT '0',
  `check_timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`hoststatus_id`),
  UNIQUE KEY `object_id` (`host_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=228 DEFAULT CHARSET=latin1 COMMENT='Current host status information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_hoststatus`
--

LOCK TABLES `nagios_hoststatus` WRITE;
/*!40000 ALTER TABLE `nagios_hoststatus` DISABLE KEYS */;
INSERT INTO `nagios_hoststatus` VALUES (224,1,53,'2010-05-29 09:37:10','PING OK - Packet loss = 0%, RTA = 21.40 ms','rta=21.403999ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0',0,1,1,1,10,'2010-05-29 09:36:57','2010-05-29 09:42:07',0,'1969-12-31 16:00:00','1969-12-31 16:00:00',0,'2010-05-27 23:56:02','1969-12-31 16:00:00','1969-12-31 16:00:00',1,'1969-12-31 16:00:00','1969-12-31 18:00:00',0,1,0,0,0,1,1,1,1,0,0,0.1,4.04483,0,1,1,1,0,'','check-host-alive',5,0,2),(225,1,50,'2010-05-29 09:37:10','OK','',0,1,1,1,3,'2010-05-29 09:31:57','2010-05-29 09:37:07',0,'2010-05-04 15:01:54','2010-05-04 15:01:54',0,'2010-05-27 23:51:02','1969-12-31 16:00:00','1969-12-31 16:00:00',1,'1969-12-31 16:00:00','1969-12-31 16:30:00',0,1,0,0,0,1,1,1,1,0,0,0.023,0.01345,0,1,1,1,0,'','return_true',5,0,0),(226,1,51,'2010-05-29 09:38:47','OK','',0,1,1,1,3,'2010-05-29 09:38:37','2010-05-29 09:43:47',0,'1969-12-31 16:00:00','1969-12-31 16:00:00',0,'2010-05-29 09:38:47','1969-12-31 16:00:00','1969-12-31 16:00:00',1,'1969-12-31 16:00:00','1969-12-31 16:30:00',0,1,0,0,0,1,1,1,1,0,0,0.032,0.01246,0,1,1,1,0,'','return_true',5,0,0),(227,1,1,'2010-05-29 09:37:10','PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.039000ms;3000.000000;5000.000000;0.000000 pl=0%;80;100;0',0,1,1,1,10,'2010-05-29 09:36:07','2010-05-29 09:41:17',0,'2010-05-04 03:43:11','2010-05-04 03:43:11',0,'2010-05-27 23:55:12','1969-12-31 16:00:00','1969-12-31 16:00:00',1,'1969-12-31 16:00:00','1969-12-31 18:00:00',0,1,0,0,0,1,1,1,1,0,0,0.011,4.01838,0,1,1,1,0,'','check-host-alive',5,0,2);
/*!40000 ALTER TABLE `nagios_hoststatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_instances`
--

DROP TABLE IF EXISTS `nagios_instances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_instances` (
  `instance_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `instance_name` varchar(64) NOT NULL DEFAULT '',
  `instance_description` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Location names of various Nagios installations';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_instances`
--

LOCK TABLES `nagios_instances` WRITE;
/*!40000 ALTER TABLE `nagios_instances` DISABLE KEYS */;
INSERT INTO `nagios_instances` VALUES (1,'itiv_proto','');
/*!40000 ALTER TABLE `nagios_instances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_logentries`
--

DROP TABLE IF EXISTS `nagios_logentries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_logentries` (
  `logentry_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` int(11) NOT NULL DEFAULT '0',
  `logentry_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `entry_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `entry_time_usec` int(11) NOT NULL DEFAULT '0',
  `logentry_type` int(11) NOT NULL DEFAULT '0',
  `logentry_data` varchar(255) NOT NULL DEFAULT '',
  `realtime_data` smallint(6) NOT NULL DEFAULT '0',
  `inferred_data_extracted` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`logentry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=230 DEFAULT CHARSET=latin1 COMMENT='Historical record of log entries';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_logentries`
--

LOCK TABLES `nagios_logentries` WRITE;
/*!40000 ALTER TABLE `nagios_logentries` DISABLE KEYS */;
INSERT INTO `nagios_logentries` VALUES (1,1,'2010-04-25 18:19:23','2010-04-25 18:19:23',814358,262144,'Event broker module \'/usr/lib/ndoutils/ndomod-mysql-3x.o\' initialized successfully.',1,1),(2,1,'2010-04-25 18:19:23','2010-04-25 18:19:23',827716,64,'Finished daemonizing... (New PID=21639)',1,1),(3,1,'2010-04-25 18:19:27','2010-04-25 18:19:27',906429,64,'Caught SIGTERM, shutting down...',1,1),(4,1,'2010-04-25 18:19:27','2010-04-25 18:19:27',908029,64,'Successfully shutdown... (PID=21639)',1,1),(5,1,'2010-04-25 18:19:27','2010-04-25 18:19:27',964277,262144,'Event broker module \'/usr/lib/ndoutils/ndomod-mysql-3x.o\' initialized successfully.',1,1),(6,1,'2010-04-25 18:19:27','2010-04-25 18:19:27',978812,64,'Finished daemonizing... (New PID=21674)',1,1),(7,1,'2010-04-25 18:37:57','2010-04-25 18:37:57',247406,65536,'SERVICE ALERT: localhost;HTTP;CRITICAL;SOFT;1;Connection refused',1,1),(8,1,'2010-04-25 18:38:57','2010-04-25 18:38:57',132467,65536,'SERVICE ALERT: localhost;HTTP;CRITICAL;SOFT;2;Connection refused',1,1),(9,1,'2010-04-25 18:39:57','2010-04-25 18:39:57',27429,65536,'SERVICE ALERT: localhost;HTTP;CRITICAL;SOFT;3;Connection refused',1,1),(10,1,'2010-04-25 18:40:57','2010-04-25 18:40:57',168881,65536,'SERVICE ALERT: localhost;HTTP;CRITICAL;HARD;4;Connection refused',1,1),(11,1,'2010-04-25 18:40:57','2010-04-25 18:40:57',169289,1048576,'SERVICE NOTIFICATION: itiv;localhost;HTTP;CRITICAL;notify-service-by-email;Connection refused',1,1),(12,1,'2010-04-25 18:40:57','2010-04-25 18:40:57',215864,2,'Warning: Attempting to execute the command \"/usr/bin/printf \"%b\" \"***** Nagios *****\n\nNotification Type: PROBLEM\n\nService: HTTP\nHost: localhost\nAddress: 127.0.0.1\nState: CRITICAL\n\nDate/Time: Sun Apr 25 18:40:57 PDT 2010\n\nAdditional Info:\n\nConnection refus',1,1),(13,1,'2010-04-25 19:15:57','2010-04-25 19:15:57',39798,8192,'SERVICE ALERT: localhost;HTTP;OK;HARD;4;HTTP OK: HTTP/1.1 200 OK - 453 bytes in 0.002 second response time',1,1),(14,1,'2010-04-25 19:15:57','2010-04-25 19:15:57',40446,1048576,'SERVICE NOTIFICATION: itiv;localhost;HTTP;OK;notify-service-by-email;HTTP OK: HTTP/1.1 200 OK - 453 bytes in 0.002 second response time',1,1),(15,1,'2010-04-25 19:15:57','2010-04-25 19:15:57',54146,2,'Warning: Attempting to execute the command \"/usr/bin/printf \"%b\" \"***** Nagios *****\n\nNotification Type: RECOVERY\n\nService: HTTP\nHost: localhost\nAddress: 127.0.0.1\nState: OK\n\nDate/Time: Sun Apr 25 19:15:57 PDT 2010\n\nAdditional Info:\n\nHTTP OK: HTTP/1.1 200',1,1),(16,1,'2010-04-25 19:19:27','2010-04-25 19:19:27',31093,64,'Auto-save of retention data completed successfully.',1,1),(17,1,'2010-04-26 13:14:22','2010-04-26 13:14:22',675121,66,'Warning: A system time change of 0d 17h 5m 28s (forwards in time) has been detected.  Compensating...',1,1),(18,1,'2010-04-26 13:24:55','2010-04-26 13:24:55',9539,64,'Auto-save of retention data completed successfully.',1,1),(19,1,'2010-04-26 14:24:55','2010-04-26 14:24:55',229419,64,'Auto-save of retention data completed successfully.',1,1),(20,1,'2010-04-26 15:24:55','2010-04-26 15:24:55',237029,64,'Auto-save of retention data completed successfully.',1,1),(21,1,'2010-04-26 16:24:55','2010-04-26 16:24:55',127060,64,'Auto-save of retention data completed successfully.',1,1),(22,1,'2010-04-26 17:15:22','2010-04-26 17:15:22',507907,64,'Caught SIGTERM, shutting down...',1,1),(23,1,'2010-04-26 17:15:22','2010-04-26 17:15:22',518896,64,'Successfully shutdown... (PID=21674)',1,1),(24,1,'2010-04-26 17:15:22','2010-04-26 17:15:22',622584,262144,'Event broker module \'/usr/lib/ndoutils/ndomod-mysql-3x.o\' initialized successfully.',1,1),(25,1,'2010-04-26 17:15:22','2010-04-26 17:15:22',627053,8,'Warning: Host \'business_processes\' has no services associated with it!',1,1),(26,1,'2010-04-26 17:15:22','2010-04-26 17:15:22',627166,8,'Warning: Host \'business_processes_detail\' has no services associated with it!',1,1),(27,1,'2010-04-26 17:15:22','2010-04-26 17:15:22',633867,64,'Finished daemonizing... (New PID=11183)',1,1),(28,1,'2010-04-26 17:31:34','2010-04-26 17:31:34',207955,64,'Caught SIGTERM, shutting down...',1,1),(29,1,'2010-04-26 17:31:34','2010-04-26 17:31:34',210439,64,'Successfully shutdown... (PID=11183)',1,1),(30,1,'2010-04-26 17:31:34','2010-04-26 17:31:34',269251,262144,'Event broker module \'/usr/lib/ndoutils/ndomod-mysql-3x.o\' initialized successfully.',1,1),(31,1,'2010-04-26 17:31:34','2010-04-26 17:31:34',276104,8,'Warning: Host \'business_processes\' has no services associated with it!',1,1),(32,1,'2010-04-26 17:31:34','2010-04-26 17:31:34',276219,8,'Warning: Host \'business_processes_detail\' has no services associated with it!',1,1),(33,1,'2010-04-26 17:31:34','2010-04-26 17:31:34',289788,64,'Finished daemonizing... (New PID=11585)',1,1),(34,1,'2010-04-26 17:35:29','2010-04-26 17:35:29',531831,262144,'ndomod: Error writing to data sink!  Some output may get lost...',1,1),(35,1,'2010-04-26 17:35:45','2010-04-26 17:35:45',63195,262144,'ndomod: Successfully flushed 89 queued items to data sink.',1,1),(36,1,'2010-04-26 17:35:45','2010-04-26 17:35:45',62875,262144,'ndomod: Successfully reconnected to data sink!  0 items lost, 89 queued items to flush.',1,1),(37,1,'2010-04-26 17:43:57','2010-04-26 17:43:57',457327,64,'Caught SIGTERM, shutting down...',1,1),(38,1,'2010-04-26 17:43:57','2010-04-26 17:43:57',459838,64,'Successfully shutdown... (PID=11585)',1,1),(39,1,'2010-04-26 17:43:57','2010-04-26 17:43:57',515635,262144,'Event broker module \'/usr/lib/ndoutils/ndomod-mysql-3x.o\' initialized successfully.',1,1),(40,1,'2010-04-26 17:43:57','2010-04-26 17:43:57',519503,8,'Warning: Host \'business_processes_detail\' has no services associated with it!',1,1),(41,1,'2010-04-26 17:43:57','2010-04-26 17:43:57',529179,64,'Finished daemonizing... (New PID=11956)',1,1),(42,1,'2010-04-26 17:44:03','2010-04-26 17:44:03',309163,262144,'ndomod: Error writing to data sink!  Some output may get lost...',1,1),(43,1,'2010-04-26 17:44:05','2010-04-26 17:44:05',480479,64,'Caught SIGTERM, shutting down...',1,1),(44,1,'2010-04-26 17:44:05','2010-04-26 17:44:05',481962,64,'Successfully shutdown... (PID=11956)',1,1),(45,1,'2010-04-26 17:44:05','2010-04-26 17:44:05',535656,262144,'Event broker module \'/usr/lib/ndoutils/ndomod-mysql-3x.o\' initialized successfully.',1,1),(46,1,'2010-04-26 17:44:05','2010-04-26 17:44:05',539445,8,'Warning: Host \'business_processes_detail\' has no services associated with it!',1,1),(47,1,'2010-04-26 17:44:05','2010-04-26 17:44:05',548930,64,'Finished daemonizing... (New PID=12020)',1,1),(48,1,'2010-04-26 17:45:55','2010-04-26 17:45:55',40191,2,'Warning: Return code of 127 for check of service \'app1\' on host \'business_processes\' was out of bounds. Make sure the plugin you\'re trying to run actually exists.',1,1),(49,1,'2010-04-26 17:45:55','2010-04-26 17:45:55',45939,65536,'SERVICE ALERT: business_processes;app1;CRITICAL;HARD;1;(Return code of 127 is out of bounds - plugin may be missing)',1,1),(50,1,'2010-04-26 17:47:20','2010-04-26 17:47:20',345525,64,'Caught SIGTERM, shutting down...',1,1),(51,1,'2010-04-26 17:47:20','2010-04-26 17:47:20',348683,64,'Successfully shutdown... (PID=12020)',1,1),(52,1,'2010-04-26 17:47:20','2010-04-26 17:47:20',403153,262144,'Event broker module \'/usr/lib/ndoutils/ndomod-mysql-3x.o\' initialized successfully.',1,1),(53,1,'2010-04-26 17:47:20','2010-04-26 17:47:20',407096,8,'Warning: Host \'business_processes_detail\' has no services associated with it!',1,1),(54,1,'2010-04-26 17:47:20','2010-04-26 17:47:20',416912,64,'Finished daemonizing... (New PID=12154)',1,1),(55,1,'2010-04-26 17:50:05','2010-04-26 17:50:05',996956,64,'Caught SIGTERM, shutting down...',1,1),(56,1,'2010-04-26 17:50:05','2010-04-26 17:50:05',999244,64,'Successfully shutdown... (PID=12154)',1,1),(57,1,'2010-04-26 17:50:06','2010-04-26 17:50:06',57493,262144,'Event broker module \'/usr/lib/ndoutils/ndomod-mysql-3x.o\' initialized successfully.',1,1),(58,1,'2010-04-26 17:50:06','2010-04-26 17:50:06',62942,8,'Warning: Host \'business_processes_detail\' has no services associated with it!',1,1),(59,1,'2010-04-26 17:50:06','2010-04-26 17:50:06',74668,64,'Finished daemonizing... (New PID=12230)',1,1),(60,1,'2010-04-26 17:55:56','2010-04-26 17:55:56',112303,8192,'SERVICE ALERT: business_processes;app1;OK;HARD;3;Business Process OK: My Applic 01',1,1),(61,1,'2010-04-26 18:50:06','2010-04-26 18:50:06',66899,64,'Auto-save of retention data completed successfully.',1,1),(62,1,'2010-04-26 19:50:06','2010-04-26 19:50:06',16192,64,'Auto-save of retention data completed successfully.',1,1),(63,1,'2010-04-27 15:17:36','2010-04-27 15:17:36',834425,66,'Warning: A system time change of 0d 18h 37m 50s (forwards in time) has been detected.  Compensating...',1,1),(64,1,'2010-04-27 15:27:56','2010-04-27 15:27:56',200074,64,'Auto-save of retention data completed successfully.',1,1),(65,1,'2010-04-27 15:54:16','2010-04-27 15:54:16',20798,32768,'SERVICE ALERT: localhost;HTTP;WARNING;SOFT;1;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.002 second response time',1,1),(66,1,'2010-04-27 15:55:16','2010-04-27 15:55:16',148172,32768,'SERVICE ALERT: localhost;HTTP;WARNING;SOFT;2;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.002 second response time',1,1),(67,1,'2010-04-27 15:56:16','2010-04-27 15:56:16',27321,32768,'SERVICE ALERT: localhost;HTTP;WARNING;SOFT;3;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.002 second response time',1,1),(68,1,'2010-04-27 15:57:16','2010-04-27 15:57:16',137948,32768,'SERVICE ALERT: localhost;HTTP;WARNING;HARD;4;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.002 second response time',1,1),(69,1,'2010-04-27 15:57:16','2010-04-27 15:57:16',138288,1048576,'SERVICE NOTIFICATION: itiv;localhost;HTTP;WARNING;notify-service-by-email;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.002 second response time',1,1),(70,1,'2010-04-27 15:57:16','2010-04-27 15:57:16',184368,2,'Warning: Attempting to execute the command \"/usr/bin/printf \"%b\" \"***** Nagios *****\n\nNotification Type: PROBLEM\n\nService: HTTP\nHost: localhost\nAddress: 127.0.0.1\nState: WARNING\n\nDate/Time: Tue Apr 27 15:57:16 PDT 2010\n\nAdditional Info:\n\nHTTP WARNING: HTT',1,1),(71,1,'2010-04-27 16:27:56','2010-04-27 16:27:56',232951,64,'Auto-save of retention data completed successfully.',1,1),(72,1,'2010-04-27 16:57:16','2010-04-27 16:57:16',35203,1048576,'SERVICE NOTIFICATION: itiv;localhost;HTTP;WARNING;notify-service-by-email;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',1,1),(73,1,'2010-04-27 16:57:16','2010-04-27 16:57:16',48414,2,'Warning: Attempting to execute the command \"/usr/bin/printf \"%b\" \"***** Nagios *****\n\nNotification Type: PROBLEM\n\nService: HTTP\nHost: localhost\nAddress: 127.0.0.1\nState: WARNING\n\nDate/Time: Tue Apr 27 16:57:16 PDT 2010\n\nAdditional Info:\n\nHTTP WARNING: HTT',1,1),(74,1,'2010-04-27 17:12:16','2010-04-27 17:12:16',123980,65536,'SERVICE ALERT: localhost;HTTP;CRITICAL;HARD;4;Connection refused',1,1),(75,1,'2010-04-27 17:12:16','2010-04-27 17:12:16',124226,1048576,'SERVICE NOTIFICATION: itiv;localhost;HTTP;CRITICAL;notify-service-by-email;Connection refused',1,1),(76,1,'2010-04-27 17:12:16','2010-04-27 17:12:16',142825,2,'Warning: Attempting to execute the command \"/usr/bin/printf \"%b\" \"***** Nagios *****\n\nNotification Type: PROBLEM\n\nService: HTTP\nHost: localhost\nAddress: 127.0.0.1\nState: CRITICAL\n\nDate/Time: Tue Apr 27 17:12:16 PDT 2010\n\nAdditional Info:\n\nConnection refus',1,1),(77,1,'2010-04-27 17:22:16','2010-04-27 17:22:16',132123,32768,'SERVICE ALERT: localhost;HTTP;WARNING;HARD;4;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',1,1),(78,1,'2010-04-27 17:22:16','2010-04-27 17:22:16',132325,1048576,'SERVICE NOTIFICATION: itiv;localhost;HTTP;WARNING;notify-service-by-email;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',1,1),(79,1,'2010-04-27 17:22:16','2010-04-27 17:22:16',151042,2,'Warning: Attempting to execute the command \"/usr/bin/printf \"%b\" \"***** Nagios *****\n\nNotification Type: PROBLEM\n\nService: HTTP\nHost: localhost\nAddress: 127.0.0.1\nState: WARNING\n\nDate/Time: Tue Apr 27 17:22:16 PDT 2010\n\nAdditional Info:\n\nHTTP WARNING: HTT',1,1),(80,1,'2010-04-27 17:27:56','2010-04-27 17:27:56',107521,64,'Auto-save of retention data completed successfully.',1,1),(81,1,'2010-04-27 18:22:16','2010-04-27 18:22:16',247909,1048576,'SERVICE NOTIFICATION: itiv;localhost;HTTP;WARNING;notify-service-by-email;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',1,1),(82,1,'2010-04-27 18:22:16','2010-04-27 18:22:16',262121,2,'Warning: Attempting to execute the command \"/usr/bin/printf \"%b\" \"***** Nagios *****\n\nNotification Type: PROBLEM\n\nService: HTTP\nHost: localhost\nAddress: 127.0.0.1\nState: WARNING\n\nDate/Time: Tue Apr 27 18:22:16 PDT 2010\n\nAdditional Info:\n\nHTTP WARNING: HTT',1,1),(83,1,'2010-04-27 18:27:56','2010-04-27 18:27:56',211653,64,'Auto-save of retention data completed successfully.',1,1),(84,1,'2010-04-27 19:22:16','2010-04-27 19:22:16',135834,1048576,'SERVICE NOTIFICATION: itiv;localhost;HTTP;WARNING;notify-service-by-email;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',1,1),(85,1,'2010-04-27 19:22:16','2010-04-27 19:22:16',150006,2,'Warning: Attempting to execute the command \"/usr/bin/printf \"%b\" \"***** Nagios *****\n\nNotification Type: PROBLEM\n\nService: HTTP\nHost: localhost\nAddress: 127.0.0.1\nState: WARNING\n\nDate/Time: Tue Apr 27 19:22:16 PDT 2010\n\nAdditional Info:\n\nHTTP WARNING: HTT',1,1),(86,1,'2010-04-27 19:27:56','2010-04-27 19:27:56',76583,64,'Auto-save of retention data completed successfully.',1,1),(87,1,'2010-04-27 20:22:16','2010-04-27 20:22:16',241928,1048576,'SERVICE NOTIFICATION: itiv;localhost;HTTP;WARNING;notify-service-by-email;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',1,1),(88,1,'2010-04-27 20:22:16','2010-04-27 20:22:16',255287,2,'Warning: Attempting to execute the command \"/usr/bin/printf \"%b\" \"***** Nagios *****\n\nNotification Type: PROBLEM\n\nService: HTTP\nHost: localhost\nAddress: 127.0.0.1\nState: WARNING\n\nDate/Time: Tue Apr 27 20:22:16 PDT 2010\n\nAdditional Info:\n\nHTTP WARNING: HTT',1,1),(89,1,'2010-04-27 20:27:56','2010-04-27 20:27:56',158486,64,'Auto-save of retention data completed successfully.',1,1),(90,1,'2010-04-27 21:22:16','2010-04-27 21:22:16',89177,1048576,'SERVICE NOTIFICATION: itiv;localhost;HTTP;WARNING;notify-service-by-email;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',1,1),(91,1,'2010-04-27 21:22:16','2010-04-27 21:22:16',102646,2,'Warning: Attempting to execute the command \"/usr/bin/printf \"%b\" \"***** Nagios *****\n\nNotification Type: PROBLEM\n\nService: HTTP\nHost: localhost\nAddress: 127.0.0.1\nState: WARNING\n\nDate/Time: Tue Apr 27 21:22:16 PDT 2010\n\nAdditional Info:\n\nHTTP WARNING: HTT',1,1),(92,1,'2010-04-27 21:27:16','2010-04-27 21:27:16',194747,8192,'SERVICE ALERT: localhost;HTTP;OK;HARD;4;HTTP OK: HTTP/1.1 200 OK - 294 bytes in 0.002 second response time',1,1),(93,1,'2010-04-27 21:27:16','2010-04-27 21:27:16',194883,1048576,'SERVICE NOTIFICATION: itiv;localhost;HTTP;OK;notify-service-by-email;HTTP OK: HTTP/1.1 200 OK - 294 bytes in 0.002 second response time',1,1),(94,1,'2010-04-27 21:27:16','2010-04-27 21:27:16',208625,2,'Warning: Attempting to execute the command \"/usr/bin/printf \"%b\" \"***** Nagios *****\n\nNotification Type: RECOVERY\n\nService: HTTP\nHost: localhost\nAddress: 127.0.0.1\nState: OK\n\nDate/Time: Tue Apr 27 21:27:16 PDT 2010\n\nAdditional Info:\n\nHTTP OK: HTTP/1.1 200',1,1),(95,1,'2010-04-27 21:27:56','2010-04-27 21:27:56',28312,64,'Auto-save of retention data completed successfully.',1,1),(96,1,'2010-04-27 21:32:16','2010-04-27 21:32:16',79017,65536,'SERVICE ALERT: localhost;HTTP;CRITICAL;SOFT;1;Connection refused',1,1),(97,1,'2010-04-27 21:33:16','2010-04-27 21:33:16',203786,8192,'SERVICE ALERT: localhost;HTTP;OK;SOFT;2;HTTP OK: HTTP/1.1 200 OK - 294 bytes in 0.002 second response time',1,1),(98,1,'2010-04-27 21:43:16','2010-04-27 21:43:16',156937,32768,'SERVICE ALERT: localhost;HTTP;WARNING;SOFT;1;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',1,1),(99,1,'2010-04-27 21:44:16','2010-04-27 21:44:16',58248,32768,'SERVICE ALERT: localhost;HTTP;WARNING;SOFT;2;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.002 second response time',1,1),(100,1,'2010-04-27 21:45:16','2010-04-27 21:45:16',173298,8192,'SERVICE ALERT: localhost;HTTP;OK;SOFT;3;HTTP OK: HTTP/1.1 200 OK - 294 bytes in 0.002 second response time',1,1),(101,1,'2010-04-27 22:27:56','2010-04-27 22:27:56',133449,64,'Auto-save of retention data completed successfully.',1,1),(102,1,'2010-04-28 15:37:09','2010-04-28 15:37:09',380988,66,'Warning: A system time change of 0d 16h 43m 52s (forwards in time) has been detected.  Compensating...',1,1),(103,1,'2010-04-28 16:11:48','2010-04-28 16:11:48',241314,64,'Auto-save of retention data completed successfully.',1,1),(104,1,'2010-04-28 17:11:48','2010-04-28 17:11:48',47214,64,'Auto-save of retention data completed successfully.',1,1),(105,1,'2010-04-28 18:11:48','2010-04-28 18:11:48',163960,64,'Auto-save of retention data completed successfully.',1,1),(106,1,'2010-04-28 19:11:48','2010-04-28 19:11:48',23217,64,'Auto-save of retention data completed successfully.',1,1),(107,1,'2010-04-28 20:11:48','2010-04-28 20:11:48',107716,64,'Auto-save of retention data completed successfully.',1,1),(108,1,'2010-04-28 21:11:48','2010-04-28 21:11:48',27231,64,'Auto-save of retention data completed successfully.',1,1),(109,1,'2010-04-29 16:37:27','2010-04-29 16:37:27',221949,66,'Warning: A system time change of 0d 19h 13m 23s (forwards in time) has been detected.  Compensating...',1,1),(110,1,'2010-04-29 16:37:33','2010-04-29 16:37:33',560493,66,'Warning: A system time change of 0d 0h 0m 1s (backwards in time) has been detected.  Compensating...',1,1),(111,1,'2010-04-29 16:49:10','2010-04-29 16:49:10',8281,2,'Warning: The check of service \'HTTP\' on host \'localhost\' looks like it was orphaned (results never came back).  I\'m scheduling an immediate check of the service...',1,1),(112,1,'2010-04-29 17:25:10','2010-04-29 17:25:10',65890,64,'Auto-save of retention data completed successfully.',1,1),(113,1,'2010-04-29 18:25:10','2010-04-29 18:25:10',226417,64,'Auto-save of retention data completed successfully.',1,1),(114,1,'2010-04-29 19:25:10','2010-04-29 19:25:10',99524,64,'Auto-save of retention data completed successfully.',1,1),(115,1,'2010-04-29 20:25:10','2010-04-29 20:25:10',173923,64,'Auto-save of retention data completed successfully.',1,1),(116,1,'2010-04-29 21:25:10','2010-04-29 21:25:10',47802,64,'Auto-save of retention data completed successfully.',1,1),(117,1,'2010-04-29 22:25:10','2010-04-29 22:25:10',67920,64,'Auto-save of retention data completed successfully.',1,1),(118,1,'2010-04-29 23:25:10','2010-04-29 23:25:10',85332,64,'Auto-save of retention data completed successfully.',1,1),(119,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',477623,64,'LOG ROTATION: DAILY',1,1),(120,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',478269,64,'LOG VERSION: 2.0',1,1),(121,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',479025,262144,'CURRENT HOST STATE: business_processes;UP;HARD;1;OK',1,1),(122,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',479151,262144,'CURRENT HOST STATE: business_processes_detail;UP;HARD;1;OK',1,1),(123,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',479227,262144,'CURRENT HOST STATE: localhost;UP;HARD;1;PING OK - Packet loss = 0%, RTA = 0.03 ms',1,1),(124,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',479293,262144,'CURRENT SERVICE STATE: business_processes;app1;OK;HARD;1;Business Process OK: My Applic 01',1,1),(125,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',479355,262144,'CURRENT SERVICE STATE: localhost;Current Load;OK;HARD;1;OK - load average: 0.00, 0.00, 0.00',1,1),(126,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',479416,262144,'CURRENT SERVICE STATE: localhost;Current Users;OK;HARD;1;USERS OK - 2 users currently logged in',1,1),(127,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',479478,262144,'CURRENT SERVICE STATE: localhost;HTTP;OK;HARD;1;HTTP OK: HTTP/1.1 200 OK - 294 bytes in 0.001 second response time',1,1),(128,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',479539,262144,'CURRENT SERVICE STATE: localhost;PING;OK;HARD;1;PING OK - Packet loss = 0%, RTA = 0.04 ms',1,1),(129,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',479600,262144,'CURRENT SERVICE STATE: localhost;Root Partition;OK;HARD;1;DISK OK - free space: / 16738 MB (91% inode=96%):',1,1),(130,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',479662,262144,'CURRENT SERVICE STATE: localhost;SSH;OK;HARD;1;SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',1,1),(131,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',479723,262144,'CURRENT SERVICE STATE: localhost;Swap Usage;OK;HARD;1;SWAP OK - 100% free (894 MB out of 894 MB)',1,1),(132,1,'2010-04-30 00:00:00','2010-04-30 00:00:00',479784,262144,'CURRENT SERVICE STATE: localhost;Total Processes;OK;HARD;1;PROCS OK: 60 processes with STATE = RSZDT',1,1),(133,1,'2010-04-30 00:25:10','2010-04-30 00:25:10',58785,64,'Auto-save of retention data completed successfully.',1,1),(134,1,'2010-04-30 01:25:10','2010-04-30 01:25:10',3665,64,'Auto-save of retention data completed successfully.',1,1),(135,1,'2010-04-30 02:25:10','2010-04-30 02:25:10',147351,64,'Auto-save of retention data completed successfully.',1,1),(136,1,'2010-04-30 03:25:10','2010-04-30 03:25:10',226757,64,'Auto-save of retention data completed successfully.',1,1),(137,1,'2010-04-30 04:25:10','2010-04-30 04:25:10',203100,64,'Auto-save of retention data completed successfully.',1,1),(138,1,'2010-05-03 15:13:30','2010-05-03 15:13:30',954454,66,'Warning: A system time change of 3d 10h 13m 19s (forwards in time) has been detected.  Compensating...',1,1),(139,1,'2010-05-03 15:38:29','2010-05-03 15:38:29',167843,64,'Auto-save of retention data completed successfully.',1,1),(140,1,'2010-05-03 16:38:29','2010-05-03 16:38:29',229286,64,'Auto-save of retention data completed successfully.',1,1),(141,1,'2010-05-03 17:38:29','2010-05-03 17:38:29',231759,64,'Auto-save of retention data completed successfully.',1,1),(142,1,'2010-05-03 18:38:29','2010-05-03 18:38:29',126275,64,'Auto-save of retention data completed successfully.',1,1),(143,1,'2010-05-03 19:38:29','2010-05-03 19:38:29',3023,64,'Auto-save of retention data completed successfully.',1,1),(144,1,'2010-05-03 20:38:29','2010-05-03 20:38:29',189442,64,'Auto-save of retention data completed successfully.',1,1),(145,1,'2010-05-03 21:38:29','2010-05-03 21:38:29',20545,64,'Auto-save of retention data completed successfully.',1,1),(146,1,'2010-05-04 17:00:10','2010-05-04 17:00:10',487149,66,'Warning: A system time change of 0d 18h 46m 38s (forwards in time) has been detected.  Compensating...',1,1),(147,1,'2010-05-04 17:04:17','2010-05-04 17:04:17',234397,32768,'SERVICE ALERT: localhost;HTTP;WARNING;SOFT;1;HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.006 second response time',1,1),(148,1,'2010-05-04 17:05:17','2010-05-04 17:05:17',141617,8192,'SERVICE ALERT: localhost;HTTP;OK;SOFT;2;HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.006 second response time',1,1),(149,1,'2010-05-27 22:39:19','2010-05-27 22:39:19',275999,262144,'ndomod: Error writing to data sink!  Some output may get lost...',1,1),(150,1,'2010-05-27 22:39:35','2010-05-27 22:39:35',49826,262144,'ndomod: Successfully flushed 80 queued items to data sink.',1,1),(151,1,'2010-05-27 22:39:35','2010-05-27 22:39:35',49571,262144,'ndomod: Successfully reconnected to data sink!  0 items lost, 80 queued items to flush.',1,1),(152,1,'2010-05-27 22:39:45','2010-05-27 22:39:45',316043,262144,'ndomod: Error writing to data sink!  Some output may get lost...',1,1),(153,1,'2010-05-27 22:40:01','2010-05-27 22:40:01',90799,262144,'ndomod: Successfully flushed 81 queued items to data sink.',1,1),(154,1,'2010-05-27 22:40:01','2010-05-27 22:40:01',90518,262144,'ndomod: Successfully reconnected to data sink!  0 items lost, 81 queued items to flush.',1,1),(155,1,'2010-05-27 22:41:19','2010-05-27 22:41:19',980917,262144,'ndomod: Error writing to data sink!  Some output may get lost...',1,1),(156,1,'2010-05-27 22:41:35','2010-05-27 22:41:35',2520,262144,'ndomod: Successfully flushed 77 queued items to data sink.',1,1),(157,1,'2010-05-27 22:41:35','2010-05-27 22:41:35',2198,262144,'ndomod: Successfully reconnected to data sink!  0 items lost, 77 queued items to flush.',1,1),(158,1,'2010-05-27 22:41:49','2010-05-27 22:41:49',314351,64,'Caught SIGTERM, shutting down...',1,1),(159,1,'2010-05-27 22:41:49','2010-05-27 22:41:49',317410,64,'Successfully shutdown... (PID=22453)',1,1),(160,1,'2010-05-27 22:41:49','2010-05-27 22:41:49',360277,262144,'ndomod: Warning - No file rotation command defined.',1,1),(161,1,'2010-05-27 22:41:49','2010-05-27 22:41:49',360413,262144,'Event broker module \'/usr/lib/ndoutils/ndomod-mysql-3x.o\' initialized successfully.',1,1),(162,1,'2010-05-27 22:41:49','2010-05-27 22:41:49',363244,8,'Warning: Host \'DNS 2\' has no services associated with it!',1,1),(163,1,'2010-05-27 22:41:49','2010-05-27 22:41:49',363356,8,'Warning: Host \'business_processes_detail\' has no services associated with it!',1,1),(164,1,'2010-05-27 22:41:49','2010-05-27 22:41:49',369811,64,'Finished daemonizing... (New PID=22616)',1,1),(165,1,'2010-05-27 22:42:05','2010-05-27 22:42:05',147429,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 292 queued items to flush.',1,1),(166,1,'2010-05-27 22:42:21','2010-05-27 22:42:21',171406,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 374 queued items to flush.',1,1),(167,1,'2010-05-27 22:42:37','2010-05-27 22:42:37',197911,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 455 queued items to flush.',1,1),(168,1,'2010-05-27 22:42:53','2010-05-27 22:42:53',227192,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 550 queued items to flush.',1,1),(169,1,'2010-05-27 22:43:09','2010-05-27 22:43:09',5485,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 631 queued items to flush.',1,1),(170,1,'2010-05-27 22:43:25','2010-05-27 22:43:25',31001,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 712 queued items to flush.',1,1),(171,1,'2010-05-27 22:43:39','2010-05-27 22:43:39',66903,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(172,1,'2010-05-27 22:43:41','2010-05-27 22:43:41',71497,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 816 queued items to flush.',1,1),(173,1,'2010-05-27 22:43:57','2010-05-27 22:43:57',100353,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 904 queued items to flush.',1,1),(174,1,'2010-05-27 22:44:13','2010-05-27 22:44:13',146539,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1009 queued items to flush.',1,1),(175,1,'2010-05-27 22:44:29','2010-05-27 22:44:29',171088,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1088 queued items to flush.',1,1),(176,1,'2010-05-27 22:44:45','2010-05-27 22:44:45',197455,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1170 queued items to flush.',1,1),(177,1,'2010-05-27 22:45:01','2010-05-27 22:45:01',220532,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1257 queued items to flush.',1,1),(178,1,'2010-05-27 22:45:17','2010-05-27 22:45:17',243781,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1332 queued items to flush.',1,1),(179,1,'2010-05-27 22:45:33','2010-05-27 22:45:33',24040,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1420 queued items to flush.',1,1),(180,1,'2010-05-27 22:45:49','2010-05-27 22:45:49',48176,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1494 queued items to flush.',1,1),(181,1,'2010-05-27 22:46:05','2010-05-27 22:46:05',73027,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1582 queued items to flush.',1,1),(182,1,'2010-05-27 22:46:21','2010-05-27 22:46:21',103462,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1671 queued items to flush.',1,1),(183,1,'2010-05-27 22:46:37','2010-05-27 22:46:37',126007,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1745 queued items to flush.',1,1),(184,1,'2010-05-27 22:46:53','2010-05-27 22:46:53',151631,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1833 queued items to flush.',1,1),(185,1,'2010-05-27 22:47:09','2010-05-27 22:47:09',177703,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1908 queued items to flush.',1,1),(186,1,'2010-05-27 22:47:25','2010-05-27 22:47:25',207485,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 1992 queued items to flush.',1,1),(187,1,'2010-05-27 22:47:41','2010-05-27 22:47:41',230901,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 2078 queued items to flush.',1,1),(188,1,'2010-05-27 22:47:57','2010-05-27 22:47:57',19045,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 2164 queued items to flush.',1,1),(189,1,'2010-05-27 22:48:13','2010-05-27 22:48:13',45667,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 2253 queued items to flush.',1,1),(190,1,'2010-05-27 22:48:29','2010-05-27 22:48:29',75169,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 2331 queued items to flush.',1,1),(191,1,'2010-05-27 22:48:39','2010-05-27 22:48:39',96418,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(192,1,'2010-05-27 22:48:45','2010-05-27 22:48:45',117139,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 2431 queued items to flush.',1,1),(193,1,'2010-05-27 22:49:01','2010-05-27 22:49:01',147508,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 2529 queued items to flush.',1,1),(194,1,'2010-05-27 22:49:17','2010-05-27 22:49:17',190100,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 2625 queued items to flush.',1,1),(195,1,'2010-05-27 22:49:33','2010-05-27 22:49:33',213271,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 2711 queued items to flush.',1,1),(196,1,'2010-05-27 22:49:49','2010-05-27 22:49:49',237401,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 2785 queued items to flush.',1,1),(197,1,'2010-05-27 22:50:05','2010-05-27 22:50:05',11467,262144,'ndomod: Still unable to connect to data sink.  0 items lost, 2872 queued items to flush.',1,1),(198,1,'2010-05-27 22:50:07','2010-05-27 22:50:07',431726,64,'Caught SIGTERM, shutting down...',1,1),(199,1,'2010-05-27 22:50:07','2010-05-27 22:50:07',433265,64,'Successfully shutdown... (PID=22616)',1,1),(200,1,'2010-05-27 22:50:08','2010-05-27 22:50:08',7629,262144,'Event broker module \'/usr/lib/ndoutils/ndomod-mysql-3x.o\' initialized successfully.',1,1),(201,1,'2010-05-27 22:50:08','2010-05-27 22:50:08',11256,8,'Warning: Host \'DNS 2\' has no services associated with it!',1,1),(202,1,'2010-05-27 22:50:08','2010-05-27 22:50:08',12058,8,'Warning: Host \'business_processes_detail\' has no services associated with it!',1,1),(203,1,'2010-05-27 22:50:08','2010-05-27 22:50:08',57728,64,'Finished daemonizing... (New PID=22903)',1,1),(204,1,'2010-05-27 22:50:40','2010-05-27 22:50:40',373069,262144,'ndomod: Error writing to data sink!  Some output may get lost...',1,1),(205,1,'2010-05-27 22:50:42','2010-05-27 22:50:42',340578,64,'Caught SIGTERM, shutting down...',1,1),(206,1,'2010-05-27 22:50:42','2010-05-27 22:50:42',341778,64,'Successfully shutdown... (PID=22903)',1,1),(207,1,'2010-05-27 22:50:42','2010-05-27 22:50:42',384262,262144,'Event broker module \'/usr/lib/ndoutils/ndomod-mysql-3x.o\' initialized successfully.',1,1),(208,1,'2010-05-27 22:50:42','2010-05-27 22:50:42',388197,8,'Warning: Host \'DNS 2\' has no services associated with it!',1,1),(209,1,'2010-05-27 22:50:42','2010-05-27 22:50:42',388672,8,'Warning: Host \'business_processes_detail\' has no services associated with it!',1,1),(210,1,'2010-05-27 22:50:42','2010-05-27 22:50:42',397412,64,'Finished daemonizing... (New PID=22935)',1,1),(211,1,'2010-05-27 22:50:44','2010-05-27 22:50:44',659916,262144,'ndomod: Error writing to data sink!  Some output may get lost...',1,1),(212,1,'2010-05-27 22:51:00','2010-05-27 22:51:00',182804,262144,'ndomod: Successfully flushed 72 queued items to data sink.',1,1),(213,1,'2010-05-27 22:51:00','2010-05-27 22:51:00',182521,262144,'ndomod: Successfully reconnected to data sink!  0 items lost, 72 queued items to flush.',1,1),(214,1,'2010-05-27 22:53:32','2010-05-27 22:53:32',221171,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(215,1,'2010-05-27 22:58:32','2010-05-27 22:58:32',46389,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(216,1,'2010-05-27 23:03:32','2010-05-27 23:03:32',137867,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(217,1,'2010-05-27 23:08:32','2010-05-27 23:08:32',218878,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(218,1,'2010-05-27 23:13:32','2010-05-27 23:13:32',67779,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(219,1,'2010-05-27 23:18:32','2010-05-27 23:18:32',159816,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(220,1,'2010-05-27 23:23:32','2010-05-27 23:23:32',11211,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(221,1,'2010-05-27 23:28:32','2010-05-27 23:28:32',98199,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(222,1,'2010-05-27 23:33:32','2010-05-27 23:33:32',184353,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(223,1,'2010-05-27 23:38:32','2010-05-27 23:38:32',28445,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(224,1,'2010-05-27 23:43:32','2010-05-27 23:43:32',128742,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(225,1,'2010-05-27 23:48:32','2010-05-27 23:48:32',243765,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(226,1,'2010-05-27 23:50:42','2010-05-27 23:50:42',244294,64,'Auto-save of retention data completed successfully.',1,1),(227,1,'2010-05-27 23:53:32','2010-05-27 23:53:32',81241,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1),(228,1,'2010-05-29 09:37:10','2010-05-29 09:37:10',17805,66,'Warning: A system time change of 1d 9h 41m 5s (forwards in time) has been detected.  Compensating...',1,1),(229,1,'2010-05-29 09:39:37','2010-05-29 09:39:37',156610,2,'Warning: Return code of 255 for check of service \'app1\' on host \'business_processes\' was out of bounds.',1,1);
/*!40000 ALTER TABLE `nagios_logentries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_notifications`
--

DROP TABLE IF EXISTS `nagios_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_notifications` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `notification_type` smallint(6) NOT NULL DEFAULT '0',
  `notification_reason` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `start_time_usec` int(11) NOT NULL DEFAULT '0',
  `end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_time_usec` int(11) NOT NULL DEFAULT '0',
  `state` smallint(6) NOT NULL DEFAULT '0',
  `output` varchar(255) NOT NULL DEFAULT '',
  `escalated` smallint(6) NOT NULL DEFAULT '0',
  `contacts_notified` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`notification_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`object_id`,`start_time`,`start_time_usec`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1 COMMENT='Historical record of host and service notifications';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_notifications`
--

LOCK TABLES `nagios_notifications` WRITE;
/*!40000 ALTER TABLE `nagios_notifications` DISABLE KEYS */;
INSERT INTO `nagios_notifications` VALUES (1,1,1,0,5,'2010-04-25 18:40:57',168991,'2010-04-25 18:40:57',216036,2,'Connection refused',0,1),(3,1,1,0,5,'2010-04-25 19:15:57',39841,'2010-04-25 19:15:57',54273,0,'HTTP OK: HTTP/1.1 200 OK - 453 bytes in 0.002 second response time',0,1),(5,1,1,0,5,'2010-04-27 15:57:16',138007,'2010-04-27 15:57:16',184629,1,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.002 second response time',0,1),(7,1,1,0,5,'2010-04-27 16:57:16',34905,'2010-04-27 16:57:16',48603,1,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',0,1),(9,1,1,0,5,'2010-04-27 17:12:16',124058,'2010-04-27 17:12:16',142987,2,'Connection refused',0,1),(11,1,1,0,5,'2010-04-27 17:22:16',132169,'2010-04-27 17:22:16',151174,1,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',0,1),(13,1,1,0,5,'2010-04-27 18:22:16',247549,'2010-04-27 18:22:16',262240,1,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',0,1),(15,1,1,0,5,'2010-04-27 19:22:16',135532,'2010-04-27 19:22:16',150152,1,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',0,1),(17,1,1,0,5,'2010-04-27 20:22:16',241465,'2010-04-27 20:22:16',255435,1,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',0,1),(19,1,1,0,5,'2010-04-27 21:22:16',88917,'2010-04-27 21:22:16',103015,1,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time',0,1),(21,1,1,0,5,'2010-04-27 21:27:16',194766,'2010-04-27 21:27:16',208904,0,'HTTP OK: HTTP/1.1 200 OK - 294 bytes in 0.002 second response time',0,1);
/*!40000 ALTER TABLE `nagios_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_objects`
--

DROP TABLE IF EXISTS `nagios_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_objects` (
  `object_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `objecttype_id` smallint(6) NOT NULL DEFAULT '0',
  `name1` varchar(128) NOT NULL DEFAULT '',
  `name2` varchar(128) DEFAULT NULL,
  `is_active` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`object_id`),
  KEY `objecttype_id` (`objecttype_id`,`name1`,`name2`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=latin1 COMMENT='Current and historical objects of all kinds';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_objects`
--

LOCK TABLES `nagios_objects` WRITE;
/*!40000 ALTER TABLE `nagios_objects` DISABLE KEYS */;
INSERT INTO `nagios_objects` VALUES (1,1,1,'localhost',NULL,1),(2,1,9,'24x7',NULL,1),(3,1,2,'localhost','Current Load',1),(4,1,2,'localhost','Current Users',1),(5,1,2,'localhost','HTTP',1),(6,1,2,'localhost','PING',1),(7,1,2,'localhost','Root Partition',1),(8,1,2,'localhost','SSH',1),(9,1,2,'localhost','Swap Usage',1),(10,1,2,'localhost','Total Processes',1),(11,1,10,'itiv',NULL,1),(12,1,12,'check-host-alive',NULL,1),(13,1,12,'check_dhcp',NULL,1),(14,1,12,'check_ftp',NULL,1),(15,1,12,'check_hpjd',NULL,1),(16,1,12,'check_http',NULL,1),(17,1,12,'check_imap',NULL,1),(18,1,12,'check_local_disk',NULL,1),(19,1,12,'check_local_load',NULL,1),(20,1,12,'check_local_mrtgtraf',NULL,1),(21,1,12,'check_local_procs',NULL,1),(22,1,12,'check_local_swap',NULL,1),(23,1,12,'check_local_users',NULL,1),(24,1,12,'check_nt',NULL,1),(25,1,12,'check_ping',NULL,1),(26,1,12,'check_pop',NULL,1),(27,1,12,'check_smtp',NULL,1),(28,1,12,'check_snmp',NULL,1),(29,1,12,'check_ssh',NULL,1),(30,1,12,'check_tcp',NULL,1),(31,1,12,'check_udp',NULL,1),(32,1,12,'notify-host-by-email',NULL,1),(33,1,12,'notify-service-by-email',NULL,1),(34,1,12,'process-host-perfdata',NULL,1),(35,1,12,'process-service-perfdata',NULL,1),(36,1,9,'24x7_sans_holidays',NULL,1),(37,1,9,'none',NULL,1),(38,1,9,'us-holidays',NULL,1),(39,1,9,'workhours',NULL,1),(40,1,12,'1',NULL,0),(41,1,12,'2',NULL,0),(42,1,12,'3',NULL,0),(43,1,12,'4',NULL,0),(44,1,12,'5',NULL,0),(45,1,12,'6',NULL,0),(46,1,11,'admins',NULL,1),(47,1,3,'linux-servers',NULL,1),(48,1,12,'check_bp_status',NULL,1),(49,1,12,'return_true',NULL,1),(50,1,1,'business_processes',NULL,1),(51,1,1,'business_processes_detail',NULL,1),(52,1,2,'business_processes','app1',1),(53,1,1,'DNS 2',NULL,1);
/*!40000 ALTER TABLE `nagios_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_processevents`
--

DROP TABLE IF EXISTS `nagios_processevents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_processevents` (
  `processevent_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `event_type` smallint(6) NOT NULL DEFAULT '0',
  `event_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `event_time_usec` int(11) NOT NULL DEFAULT '0',
  `process_id` int(11) NOT NULL DEFAULT '0',
  `program_name` varchar(16) NOT NULL DEFAULT '',
  `program_version` varchar(20) NOT NULL DEFAULT '',
  `program_date` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`processevent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=latin1 COMMENT='Historical Nagios process events';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_processevents`
--

LOCK TABLES `nagios_processevents` WRITE;
/*!40000 ALTER TABLE `nagios_processevents` DISABLE KEYS */;
INSERT INTO `nagios_processevents` VALUES (1,1,104,'2010-04-25 18:19:23',814432,21637,'Nagios','3.2.1','03-09-2010'),(2,1,100,'2010-04-25 18:19:23',817035,21637,'Nagios','3.2.1','03-09-2010'),(3,1,101,'2010-04-25 18:19:23',827151,21639,'Nagios','3.2.1','03-09-2010'),(4,1,105,'2010-04-25 18:19:23',831837,21639,'Nagios','3.2.1','03-09-2010'),(5,1,106,'2010-04-25 18:19:27',906445,21639,'Nagios','3.2.1','03-09-2010'),(6,1,103,'2010-04-25 18:19:27',906450,21639,'Nagios','3.2.1','03-09-2010'),(7,1,104,'2010-04-25 18:19:27',964335,21672,'Nagios','3.2.1','03-09-2010'),(8,1,100,'2010-04-25 18:19:27',966508,21672,'Nagios','3.2.1','03-09-2010'),(9,1,101,'2010-04-25 18:19:27',976208,21674,'Nagios','3.2.1','03-09-2010'),(10,1,105,'2010-04-25 18:19:27',982474,21674,'Nagios','3.2.1','03-09-2010'),(11,1,106,'2010-04-26 17:15:22',507922,21674,'Nagios','3.2.1','03-09-2010'),(12,1,103,'2010-04-26 17:15:22',507928,21674,'Nagios','3.2.1','03-09-2010'),(13,1,104,'2010-04-26 17:15:22',622620,11181,'Nagios','3.2.1','03-09-2010'),(14,1,100,'2010-04-26 17:15:22',627261,11181,'Nagios','3.2.1','03-09-2010'),(15,1,101,'2010-04-26 17:15:22',633350,11183,'Nagios','3.2.1','03-09-2010'),(16,1,105,'2010-04-26 17:15:25',738727,11183,'Nagios','3.2.1','03-09-2010'),(17,1,106,'2010-04-26 17:31:34',207972,11183,'Nagios','3.2.1','03-09-2010'),(18,1,103,'2010-04-26 17:31:34',207977,11183,'Nagios','3.2.1','03-09-2010'),(19,1,104,'2010-04-26 17:31:34',269295,11583,'Nagios','3.2.1','03-09-2010'),(20,1,100,'2010-04-26 17:31:34',276317,11583,'Nagios','3.2.1','03-09-2010'),(21,1,101,'2010-04-26 17:31:34',285601,11585,'Nagios','3.2.1','03-09-2010'),(22,1,105,'2010-04-26 17:31:34',293706,11585,'Nagios','3.2.1','03-09-2010'),(23,1,106,'2010-04-26 17:43:57',457343,11585,'Nagios','3.2.1','03-09-2010'),(24,1,103,'2010-04-26 17:43:57',457347,11585,'Nagios','3.2.1','03-09-2010'),(25,1,104,'2010-04-26 17:43:57',515677,11954,'Nagios','3.2.1','03-09-2010'),(26,1,100,'2010-04-26 17:43:57',519594,11954,'Nagios','3.2.1','03-09-2010'),(27,1,101,'2010-04-26 17:43:57',527391,11956,'Nagios','3.2.1','03-09-2010'),(28,1,105,'2010-04-26 17:43:57',542094,11956,'Nagios','3.2.1','03-09-2010'),(29,1,106,'2010-04-26 17:44:05',480488,11956,'Nagios','3.2.1','03-09-2010'),(30,1,103,'2010-04-26 17:44:05',480492,11956,'Nagios','3.2.1','03-09-2010'),(31,1,104,'2010-04-26 17:44:05',535695,12018,'Nagios','3.2.1','03-09-2010'),(32,1,100,'2010-04-26 17:44:05',539534,12018,'Nagios','3.2.1','03-09-2010'),(33,1,101,'2010-04-26 17:44:05',547486,12020,'Nagios','3.2.1','03-09-2010'),(34,1,105,'2010-04-26 17:44:05',556885,12020,'Nagios','3.2.1','03-09-2010'),(35,1,106,'2010-04-26 17:47:20',345540,12020,'Nagios','3.2.1','03-09-2010'),(36,1,103,'2010-04-26 17:47:20',345545,12020,'Nagios','3.2.1','03-09-2010'),(37,1,104,'2010-04-26 17:47:20',403199,12152,'Nagios','3.2.1','03-09-2010'),(38,1,100,'2010-04-26 17:47:20',407191,12152,'Nagios','3.2.1','03-09-2010'),(39,1,101,'2010-04-26 17:47:20',415229,12154,'Nagios','3.2.1','03-09-2010'),(40,1,105,'2010-04-26 17:47:20',429099,12154,'Nagios','3.2.1','03-09-2010'),(41,1,106,'2010-04-26 17:50:05',996972,12154,'Nagios','3.2.1','03-09-2010'),(42,1,103,'2010-04-26 17:50:05',996977,12154,'Nagios','3.2.1','03-09-2010'),(43,1,104,'2010-04-26 17:50:06',57534,12228,'Nagios','3.2.1','03-09-2010'),(44,1,100,'2010-04-26 17:50:06',63055,12228,'Nagios','3.2.1','03-09-2010'),(45,1,101,'2010-04-26 17:50:06',71014,12230,'Nagios','3.2.1','03-09-2010'),(46,1,105,'2010-04-26 17:50:06',78872,12230,'Nagios','3.2.1','03-09-2010'),(47,1,106,'2010-05-27 22:41:49',314368,22453,'Nagios','3.2.1','03-09-2010'),(48,1,103,'2010-05-27 22:41:49',314374,22453,'Nagios','3.2.1','03-09-2010'),(49,1,104,'2010-05-27 22:41:49',360423,22615,'Nagios','3.2.1','03-09-2010'),(50,1,100,'2010-05-27 22:41:49',363453,22615,'Nagios','3.2.1','03-09-2010'),(51,1,101,'2010-05-27 22:41:49',369305,22616,'Nagios','3.2.1','03-09-2010'),(52,1,105,'2010-05-27 22:41:49',373762,22616,'Nagios','3.2.1','03-09-2010'),(53,1,106,'2010-05-27 22:50:07',431735,22616,'Nagios','3.2.1','03-09-2010'),(54,1,103,'2010-05-27 22:50:07',431739,22616,'Nagios','3.2.1','03-09-2010'),(55,1,104,'2010-05-27 22:50:08',7695,22901,'Nagios','3.2.1','03-09-2010'),(56,1,100,'2010-05-27 22:50:08',13027,22901,'Nagios','3.2.1','03-09-2010'),(57,1,101,'2010-05-27 22:50:08',56783,22903,'Nagios','3.2.1','03-09-2010'),(58,1,105,'2010-05-27 22:50:08',63084,22903,'Nagios','3.2.1','03-09-2010'),(59,1,106,'2010-05-27 22:50:42',340587,22903,'Nagios','3.2.1','03-09-2010'),(60,1,103,'2010-05-27 22:50:42',340597,22903,'Nagios','3.2.1','03-09-2010'),(61,1,104,'2010-05-27 22:50:42',384295,22933,'Nagios','3.2.1','03-09-2010'),(62,1,100,'2010-05-27 22:50:42',388764,22933,'Nagios','3.2.1','03-09-2010'),(63,1,101,'2010-05-27 22:50:42',396242,22935,'Nagios','3.2.1','03-09-2010'),(64,1,105,'2010-05-27 22:50:42',405830,22935,'Nagios','3.2.1','03-09-2010');
/*!40000 ALTER TABLE `nagios_processevents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_programstatus`
--

DROP TABLE IF EXISTS `nagios_programstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_programstatus` (
  `programstatus_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `status_update_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `program_start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `program_end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `is_currently_running` smallint(6) NOT NULL DEFAULT '0',
  `process_id` int(11) NOT NULL DEFAULT '0',
  `daemon_mode` smallint(6) NOT NULL DEFAULT '0',
  `last_command_check` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_log_rotation` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `notifications_enabled` smallint(6) NOT NULL DEFAULT '0',
  `active_service_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `passive_service_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `active_host_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `passive_host_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `event_handlers_enabled` smallint(6) NOT NULL DEFAULT '0',
  `flap_detection_enabled` smallint(6) NOT NULL DEFAULT '0',
  `failure_prediction_enabled` smallint(6) NOT NULL DEFAULT '0',
  `process_performance_data` smallint(6) NOT NULL DEFAULT '0',
  `obsess_over_hosts` smallint(6) NOT NULL DEFAULT '0',
  `obsess_over_services` smallint(6) NOT NULL DEFAULT '0',
  `modified_host_attributes` int(11) NOT NULL DEFAULT '0',
  `modified_service_attributes` int(11) NOT NULL DEFAULT '0',
  `global_host_event_handler` varchar(255) NOT NULL DEFAULT '',
  `global_service_event_handler` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`programstatus_id`),
  UNIQUE KEY `instance_id` (`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6359 DEFAULT CHARSET=latin1 COMMENT='Current program status information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_programstatus`
--

LOCK TABLES `nagios_programstatus` WRITE;
/*!40000 ALTER TABLE `nagios_programstatus` DISABLE KEYS */;
INSERT INTO `nagios_programstatus` VALUES (6358,1,'2010-05-29 09:39:52','2010-05-29 08:31:47','0000-00-00 00:00:00',1,22935,1,'2010-05-29 09:39:52','1969-12-31 16:00:00',1,1,1,1,1,1,1,1,0,0,0,0,0,'','');
/*!40000 ALTER TABLE `nagios_programstatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_runtimevariables`
--

DROP TABLE IF EXISTS `nagios_runtimevariables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_runtimevariables` (
  `runtimevariable_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `varname` varchar(64) NOT NULL DEFAULT '',
  `varvalue` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`runtimevariable_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`varname`)
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=latin1 COMMENT='Runtime variables from the Nagios daemon';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_runtimevariables`
--

LOCK TABLES `nagios_runtimevariables` WRITE;
/*!40000 ALTER TABLE `nagios_runtimevariables` DISABLE KEYS */;
INSERT INTO `nagios_runtimevariables` VALUES (181,1,'config_file','/usr/local/monitor/etc/nagios.cfg'),(182,1,'total_services','9'),(183,1,'total_scheduled_services','9'),(184,1,'total_hosts','4'),(185,1,'total_scheduled_hosts','4'),(186,1,'average_services_per_host','2.250000'),(187,1,'average_scheduled_services_per_host','2.250000'),(188,1,'service_check_interval_total','2700'),(189,1,'host_check_interval_total','1200'),(190,1,'average_service_check_interval','300.000000'),(191,1,'average_host_check_interval','300.000000'),(192,1,'average_service_inter_check_delay','33.333333'),(193,1,'average_host_inter_check_delay','75.000000'),(194,1,'service_inter_check_delay','33.333333'),(195,1,'host_inter_check_delay','75.000000'),(196,1,'service_interleave_factor','3'),(197,1,'max_service_check_spread','30'),(198,1,'max_host_check_spread','30');
/*!40000 ALTER TABLE `nagios_runtimevariables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_scheduleddowntime`
--

DROP TABLE IF EXISTS `nagios_scheduleddowntime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_scheduleddowntime` (
  `scheduleddowntime_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `downtime_type` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `entry_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `author_name` varchar(64) NOT NULL DEFAULT '',
  `comment_data` varchar(255) NOT NULL DEFAULT '',
  `internal_downtime_id` int(11) NOT NULL DEFAULT '0',
  `triggered_by_id` int(11) NOT NULL DEFAULT '0',
  `is_fixed` smallint(6) NOT NULL DEFAULT '0',
  `duration` smallint(6) NOT NULL DEFAULT '0',
  `scheduled_start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `scheduled_end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `was_started` smallint(6) NOT NULL DEFAULT '0',
  `actual_start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `actual_start_time_usec` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`scheduleddowntime_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`object_id`,`entry_time`,`internal_downtime_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Current scheduled host and service downtime';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_scheduleddowntime`
--

LOCK TABLES `nagios_scheduleddowntime` WRITE;
/*!40000 ALTER TABLE `nagios_scheduleddowntime` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_scheduleddowntime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_service_contactgroups`
--

DROP TABLE IF EXISTS `nagios_service_contactgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_service_contactgroups` (
  `service_contactgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `service_id` int(11) NOT NULL DEFAULT '0',
  `contactgroup_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`service_contactgroup_id`),
  UNIQUE KEY `instance_id` (`service_id`,`contactgroup_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=latin1 COMMENT='Service contact groups';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_service_contactgroups`
--

LOCK TABLES `nagios_service_contactgroups` WRITE;
/*!40000 ALTER TABLE `nagios_service_contactgroups` DISABLE KEYS */;
INSERT INTO `nagios_service_contactgroups` VALUES (1,1,1,46),(2,1,2,46),(3,1,3,46),(4,1,4,46),(5,1,5,46),(6,1,6,46),(7,1,7,46),(8,1,8,46),(9,1,9,46),(10,1,10,46),(11,1,11,46),(12,1,12,46),(13,1,13,46),(14,1,14,46),(15,1,15,46),(16,1,16,46),(17,1,17,46),(18,1,18,46),(19,1,19,46),(20,1,20,46),(21,1,21,46),(22,1,22,46),(23,1,23,46),(24,1,24,46),(25,1,25,46),(26,1,26,46),(27,1,27,46),(28,1,28,46),(29,1,29,46),(30,1,30,46),(31,1,31,46),(32,1,32,46),(33,1,33,46),(34,1,34,46),(35,1,35,46),(36,1,36,46),(37,1,37,46),(38,1,38,46),(39,1,39,46),(40,1,40,46),(41,1,41,46),(42,1,42,46),(43,1,43,46),(44,1,44,46),(45,1,45,46),(46,1,46,46),(47,1,47,46),(48,1,48,46),(49,1,49,46),(50,1,50,46),(51,1,51,46),(52,1,52,46),(53,1,53,46),(54,1,54,46),(55,1,55,46),(56,1,56,46),(57,1,57,46),(58,1,58,46),(59,1,59,46),(60,1,60,46),(61,1,61,46),(62,1,62,46),(63,1,63,46),(64,1,64,46),(65,1,65,46),(66,1,66,46),(67,1,67,46),(68,1,68,46),(69,1,69,46),(70,1,70,46),(71,1,71,46),(72,1,72,46),(73,1,73,46),(74,1,74,46),(75,1,75,46),(76,1,76,46),(77,1,77,46),(78,1,78,46),(79,1,79,46),(80,1,80,46),(81,1,81,46),(82,1,82,46),(83,1,83,46),(84,1,84,46),(85,1,85,46),(86,1,86,46),(87,1,87,46),(88,1,88,46),(89,1,89,46),(90,1,90,46),(91,1,91,46),(92,1,92,46),(93,1,93,46),(94,1,94,46),(95,1,95,46);
/*!40000 ALTER TABLE `nagios_service_contactgroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_service_contacts`
--

DROP TABLE IF EXISTS `nagios_service_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_service_contacts` (
  `service_contact_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `service_id` int(11) NOT NULL DEFAULT '0',
  `contact_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`service_contact_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`service_id`,`contact_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_service_contacts`
--

LOCK TABLES `nagios_service_contacts` WRITE;
/*!40000 ALTER TABLE `nagios_service_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_service_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_servicechecks`
--

DROP TABLE IF EXISTS `nagios_servicechecks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_servicechecks` (
  `servicecheck_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `service_object_id` int(11) NOT NULL DEFAULT '0',
  `check_type` smallint(6) NOT NULL DEFAULT '0',
  `current_check_attempt` smallint(6) NOT NULL DEFAULT '0',
  `max_check_attempts` smallint(6) NOT NULL DEFAULT '0',
  `state` smallint(6) NOT NULL DEFAULT '0',
  `state_type` smallint(6) NOT NULL DEFAULT '0',
  `start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `start_time_usec` int(11) NOT NULL DEFAULT '0',
  `end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_time_usec` int(11) NOT NULL DEFAULT '0',
  `command_object_id` int(11) NOT NULL DEFAULT '0',
  `command_args` varchar(255) NOT NULL DEFAULT '',
  `command_line` varchar(255) NOT NULL DEFAULT '',
  `timeout` smallint(6) NOT NULL DEFAULT '0',
  `early_timeout` smallint(6) NOT NULL DEFAULT '0',
  `execution_time` double NOT NULL DEFAULT '0',
  `latency` double NOT NULL DEFAULT '0',
  `return_code` smallint(6) NOT NULL DEFAULT '0',
  `output` varchar(255) NOT NULL DEFAULT '',
  `perfdata` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`servicecheck_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`service_object_id`,`start_time`,`start_time_usec`)
) ENGINE=InnoDB AUTO_INCREMENT=9301 DEFAULT CHARSET=latin1 COMMENT='Historical service checks';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_servicechecks`
--

LOCK TABLES `nagios_servicechecks` WRITE;
/*!40000 ALTER TABLE `nagios_servicechecks` DISABLE KEYS */;
INSERT INTO `nagios_servicechecks` VALUES (9020,1,9,0,1,4,0,1,'2010-05-27 22:41:15',216880,'2010-05-27 22:41:15',232935,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01605,0.216,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9022,1,7,0,1,4,0,1,'2010-05-27 22:42:22',172709,'2010-05-27 22:42:22',182852,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01014,0.172,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9024,1,10,0,1,4,0,1,'2010-05-27 22:42:55',230713,'2010-05-27 22:42:55',249211,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.0185,0.23,0,'PROCS OK: 67 processes with STATE = RSZDT',''),(9026,1,8,0,1,4,0,1,'2010-05-27 22:43:26',32535,'2010-05-27 22:43:26',53401,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02087,0.032,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9028,1,52,0,3,3,2,1,'2010-05-27 22:43:29',47492,'2010-05-27 22:43:29',150703,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.10321,0.047,255,'(Return code of 255 is out of bounds)',''),(9030,1,4,0,1,4,0,1,'2010-05-27 22:43:42',72911,'2010-05-27 22:43:42',86694,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.01378,0.072,0,'USERS OK - 4 users currently logged in','users=4;20;50;0'),(9032,1,5,0,1,4,0,1,'2010-05-27 22:44:02',113438,'2010-05-27 22:44:02',127775,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.01434,0.113,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.001 second response time','time=0.001301s;;;0.000000 size=311B;;;0'),(9033,1,6,0,1,4,0,1,'2010-05-27 22:44:06',123906,'2010-05-27 22:44:10',134842,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01094,0.123,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.037000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9034,1,3,0,1,4,0,1,'2010-05-27 22:44:07',130223,'2010-05-27 22:44:07',142147,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01192,0.13,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9038,1,9,0,1,4,0,1,'2010-05-27 22:46:15',88564,'2010-05-27 22:46:15',100600,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01204,0.088,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9040,1,7,0,1,4,0,1,'2010-05-27 22:47:22',198583,'2010-05-27 22:47:22',210147,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01156,0.198,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9042,1,10,0,1,4,0,1,'2010-05-27 22:47:55',10055,'2010-05-27 22:47:55',31517,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02146,0.009,0,'PROCS OK: 67 processes with STATE = RSZDT',''),(9044,1,8,0,1,4,0,1,'2010-05-27 22:48:26',65735,'2010-05-27 22:48:26',86864,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02113,0.065,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9046,1,52,0,3,3,2,1,'2010-05-27 22:48:29',77129,'2010-05-27 22:48:29',157280,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.08015,0.077,255,'(Return code of 255 is out of bounds)',''),(9048,1,4,0,1,4,0,1,'2010-05-27 22:48:42',107036,'2010-05-27 22:48:42',122454,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.01542,0.106,0,'USERS OK - 4 users currently logged in','users=4;20;50;0'),(9050,1,5,0,1,4,0,1,'2010-05-27 22:49:02',149064,'2010-05-27 22:49:02',164677,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.01561,0.148,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.002 second response time','time=0.001588s;;;0.000000 size=311B;;;0'),(9051,1,6,0,1,4,0,1,'2010-05-27 22:49:06',159856,'2010-05-27 22:49:10',172746,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01289,0.159,0,'PING OK - Packet loss = 0%, RTA = 0.03 ms','rta=0.030000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9052,1,3,0,1,4,0,1,'2010-05-27 22:49:07',166948,'2010-05-27 22:49:07',180188,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01324,0.166,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9056,1,9,0,1,4,0,1,'2010-05-27 22:51:15',206347,'2010-05-27 22:51:15',220001,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01365,0.206,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9058,1,7,0,1,4,0,1,'2010-05-27 22:52:22',72177,'2010-05-27 22:52:22',88259,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01608,0.072,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9060,1,10,0,1,4,0,1,'2010-05-27 22:52:55',134770,'2010-05-27 22:52:55',156224,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02145,0.134,0,'PROCS OK: 68 processes with STATE = RSZDT',''),(9062,1,8,0,1,4,0,1,'2010-05-27 22:53:26',198108,'2010-05-27 22:53:26',221204,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.0231,0.197,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9063,1,52,0,3,3,2,1,'2010-05-27 22:53:29',208935,'2010-05-27 22:53:29',292675,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.08374,0.208,255,'(Return code of 255 is out of bounds)',''),(9066,1,4,0,1,4,0,1,'2010-05-27 22:53:42',239067,'2010-05-27 22:53:42',257051,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.01798,0.238,0,'USERS OK - 4 users currently logged in','users=4;20;50;0'),(9068,1,5,0,1,4,0,1,'2010-05-27 22:54:02',42451,'2010-05-27 22:54:02',61521,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.01907,0.041,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.001 second response time','time=0.001380s;;;0.000000 size=311B;;;0'),(9069,1,6,0,1,4,0,1,'2010-05-27 22:54:06',57715,'2010-05-27 22:54:10',70384,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01267,0.057,0,'PING OK - Packet loss = 0%, RTA = 0.05 ms','rta=0.046000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9070,1,3,0,1,4,0,1,'2010-05-27 22:54:07',65256,'2010-05-27 22:54:07',79258,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.014,0.065,0,'OK - load average: 0.02, 0.02, 0.00','load1=0.020;5.000;10.000;0; load5=0.020;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9074,1,9,0,1,4,0,1,'2010-05-27 22:56:15',45342,'2010-05-27 22:56:15',70477,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.02514,0.045,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9076,1,7,0,1,4,0,1,'2010-05-27 22:57:22',156866,'2010-05-27 22:57:22',171744,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01488,0.156,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9078,1,10,0,1,4,0,1,'2010-05-27 22:57:55',208293,'2010-05-27 22:57:55',232282,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02399,0.208,0,'PROCS OK: 66 processes with STATE = RSZDT',''),(9080,1,8,0,1,4,0,1,'2010-05-27 22:58:26',24117,'2010-05-27 22:58:26',46636,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02252,0.023,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9081,1,52,0,3,3,2,1,'2010-05-27 22:58:29',34500,'2010-05-27 22:58:29',114262,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.07976,0.034,255,'(Return code of 255 is out of bounds)',''),(9084,1,4,0,1,4,0,1,'2010-05-27 22:58:42',63244,'2010-05-27 22:58:42',82647,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.0194,0.063,0,'USERS OK - 4 users currently logged in','users=4;20;50;0'),(9086,1,5,0,1,4,0,1,'2010-05-27 22:59:02',112440,'2010-05-27 22:59:02',135127,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.02269,0.112,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.004 second response time','time=0.004173s;;;0.000000 size=311B;;;0'),(9087,1,6,0,1,4,0,1,'2010-05-27 22:59:06',123780,'2010-05-27 22:59:10',140297,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01652,0.123,0,'PING OK - Packet loss = 0%, RTA = 0.06 ms','rta=0.062000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9088,1,3,0,1,4,0,1,'2010-05-27 22:59:07',128216,'2010-05-27 22:59:07',142543,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01433,0.128,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9092,1,9,0,1,4,0,1,'2010-05-27 23:01:15',116375,'2010-05-27 23:01:15',129759,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01338,0.116,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9094,1,7,0,1,4,0,1,'2010-05-27 23:02:22',235513,'2010-05-27 23:02:22',250407,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01489,0.234,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9096,1,10,0,1,4,0,1,'2010-05-27 23:02:55',48764,'2010-05-27 23:02:55',69955,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02119,0.048,0,'PROCS OK: 66 processes with STATE = RSZDT',''),(9098,1,8,0,1,4,0,1,'2010-05-27 23:03:26',114030,'2010-05-27 23:03:26',144570,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.03054,0.113,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9099,1,52,0,3,3,2,1,'2010-05-27 23:03:29',125782,'2010-05-27 23:03:29',208943,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.08316,0.125,255,'(Return code of 255 is out of bounds)',''),(9102,1,4,0,1,4,0,1,'2010-05-27 23:03:42',155321,'2010-05-27 23:03:42',172849,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.01753,0.155,0,'USERS OK - 4 users currently logged in','users=4;20;50;0'),(9104,1,5,0,1,4,0,1,'2010-05-27 23:04:02',199165,'2010-05-27 23:04:02',217102,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.01794,0.199,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.002 second response time','time=0.002005s;;;0.000000 size=311B;;;0'),(9105,1,6,0,1,4,0,1,'2010-05-27 23:04:06',212946,'2010-05-27 23:04:10',229627,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01668,0.212,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.038000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9106,1,3,0,1,4,0,1,'2010-05-27 23:04:07',226387,'2010-05-27 23:04:07',237956,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01157,0.226,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9110,1,9,0,1,4,0,1,'2010-05-27 23:06:15',218501,'2010-05-27 23:06:15',232286,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01379,0.218,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9112,1,7,0,1,4,0,1,'2010-05-27 23:07:22',83982,'2010-05-27 23:07:22',99060,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01508,0.083,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9114,1,10,0,1,4,0,1,'2010-05-27 23:07:55',141603,'2010-05-27 23:07:55',163734,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02213,0.141,0,'PROCS OK: 66 processes with STATE = RSZDT',''),(9116,1,8,0,1,4,0,1,'2010-05-27 23:08:26',196092,'2010-05-27 23:08:26',217143,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02105,0.195,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9117,1,52,0,3,3,2,1,'2010-05-27 23:08:29',206418,'2010-05-27 23:08:29',288432,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.08201,0.206,255,'(Return code of 255 is out of bounds)',''),(9120,1,4,0,1,4,0,1,'2010-05-27 23:08:42',250371,'2010-05-27 23:08:42',268124,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.01775,0.249,0,'USERS OK - 3 users currently logged in','users=3;20;50;0'),(9122,1,5,0,1,4,0,1,'2010-05-27 23:09:02',44589,'2010-05-27 23:09:02',64822,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.02023,0.043,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.003 second response time','time=0.002536s;;;0.000000 size=311B;;;0'),(9123,1,6,0,1,4,0,1,'2010-05-27 23:09:06',59489,'2010-05-27 23:09:10',73522,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01403,0.059,0,'PING OK - Packet loss = 0%, RTA = 0.03 ms','rta=0.034000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9124,1,3,0,1,4,0,1,'2010-05-27 23:09:07',66430,'2010-05-27 23:09:07',80676,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01425,0.066,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9128,1,9,0,1,4,0,1,'2010-05-27 23:11:15',60481,'2010-05-27 23:11:15',73219,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01274,0.06,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9130,1,7,0,1,4,0,1,'2010-05-27 23:12:22',180103,'2010-05-27 23:12:22',193814,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01371,0.179,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9132,1,10,0,1,4,0,1,'2010-05-27 23:12:55',240823,'2010-05-27 23:12:55',263574,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02275,0.24,0,'PROCS OK: 62 processes with STATE = RSZDT',''),(9134,1,8,0,1,4,0,1,'2010-05-27 23:13:26',46309,'2010-05-27 23:13:26',67935,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02163,0.046,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9135,1,52,0,3,3,2,1,'2010-05-27 23:13:29',56218,'2010-05-27 23:13:29',145344,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.08913,0.056,255,'(Return code of 255 is out of bounds)',''),(9138,1,4,0,1,4,0,1,'2010-05-27 23:13:42',97917,'2010-05-27 23:13:42',117816,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.0199,0.097,0,'USERS OK - 0 users currently logged in','users=0;20;50;0'),(9140,1,5,0,1,4,0,1,'2010-05-27 23:14:02',133626,'2010-05-27 23:14:02',154761,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.02114,0.133,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.003 second response time','time=0.002919s;;;0.000000 size=311B;;;0'),(9141,1,6,0,1,4,0,1,'2010-05-27 23:14:06',148021,'2010-05-27 23:14:10',162923,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.0149,0.147,0,'PING OK - Packet loss = 0%, RTA = 0.03 ms','rta=0.034000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9142,1,3,0,1,4,0,1,'2010-05-27 23:14:07',155843,'2010-05-27 23:14:07',170275,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01443,0.155,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9146,1,9,0,1,4,0,1,'2010-05-27 23:16:15',148126,'2010-05-27 23:16:15',159743,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01162,0.147,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9148,1,7,0,1,4,0,1,'2010-05-27 23:17:22',18271,'2010-05-27 23:17:22',31694,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01342,0.017,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9150,1,10,0,1,4,0,1,'2010-05-27 23:17:55',78708,'2010-05-27 23:17:55',99216,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02051,0.078,0,'PROCS OK: 62 processes with STATE = RSZDT',''),(9152,1,8,0,1,4,0,1,'2010-05-27 23:18:26',136976,'2010-05-27 23:18:26',161408,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02443,0.136,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9153,1,52,0,3,3,2,1,'2010-05-27 23:18:29',148879,'2010-05-27 23:18:29',228498,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.07962,0.148,255,'(Return code of 255 is out of bounds)',''),(9156,1,4,0,1,4,0,1,'2010-05-27 23:18:42',177221,'2010-05-27 23:18:42',196522,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.0193,0.176,0,'USERS OK - 0 users currently logged in','users=0;20;50;0'),(9158,1,5,0,1,4,0,1,'2010-05-27 23:19:02',231065,'2010-05-27 23:19:02',252028,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.02096,0.231,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.002 second response time','time=0.002464s;;;0.000000 size=311B;;;0'),(9159,1,6,0,1,4,0,1,'2010-05-27 23:19:06',247397,'2010-05-27 23:19:10',260319,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01292,0.247,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.037000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9160,1,3,0,1,4,0,1,'2010-05-27 23:19:07',4776,'2010-05-27 23:19:07',19225,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01445,0.004,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9164,1,9,0,1,4,0,1,'2010-05-27 23:21:15',243459,'2010-05-27 23:21:15',256947,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01349,0.243,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9166,1,7,0,1,4,0,1,'2010-05-27 23:22:22',122562,'2010-05-27 23:22:22',137087,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01452,0.122,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9168,1,10,0,1,4,0,1,'2010-05-27 23:22:55',182927,'2010-05-27 23:22:55',203521,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02059,0.182,0,'PROCS OK: 62 processes with STATE = RSZDT',''),(9170,1,8,0,1,4,0,1,'2010-05-27 23:23:26',238075,'2010-05-27 23:23:26',260328,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02225,0.237,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9171,1,52,0,3,3,2,1,'2010-05-27 23:23:29',248335,'2010-05-27 23:23:29',329293,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.08096,0.248,255,'(Return code of 255 is out of bounds)',''),(9174,1,4,0,1,4,0,1,'2010-05-27 23:23:42',29551,'2010-05-27 23:23:42',47748,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.0182,0.028,0,'USERS OK - 0 users currently logged in','users=0;20;50;0'),(9176,1,5,0,1,4,0,1,'2010-05-27 23:24:02',80172,'2010-05-27 23:24:02',105633,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.02546,0.08,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.004 second response time','time=0.004211s;;;0.000000 size=311B;;;0'),(9177,1,6,0,1,4,0,1,'2010-05-27 23:24:06',91206,'2010-05-27 23:24:10',110129,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01892,0.091,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.041000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9178,1,3,0,1,4,0,1,'2010-05-27 23:24:07',98941,'2010-05-27 23:24:07',112141,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.0132,0.098,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9182,1,9,0,1,4,0,1,'2010-05-27 23:26:15',83684,'2010-05-27 23:26:15',96767,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01308,0.083,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9184,1,7,0,1,4,0,1,'2010-05-27 23:27:22',204193,'2010-05-27 23:27:22',218544,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01435,0.204,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9186,1,10,0,1,4,0,1,'2010-05-27 23:27:55',16299,'2010-05-27 23:27:55',36782,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02048,0.016,0,'PROCS OK: 62 processes with STATE = RSZDT',''),(9188,1,8,0,1,4,0,1,'2010-05-27 23:28:26',75428,'2010-05-27 23:28:26',96276,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02085,0.075,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9189,1,52,0,3,3,2,1,'2010-05-27 23:28:29',86016,'2010-05-27 23:28:29',168482,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.08247,0.085,255,'(Return code of 255 is out of bounds)',''),(9192,1,4,0,1,4,0,1,'2010-05-27 23:28:42',114449,'2010-05-27 23:28:42',128113,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.01366,0.113,0,'USERS OK - 0 users currently logged in','users=0;20;50;0'),(9194,1,5,0,1,4,0,1,'2010-05-27 23:29:02',153753,'2010-05-27 23:29:02',172642,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.01889,0.153,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.002 second response time','time=0.001761s;;;0.000000 size=311B;;;0'),(9195,1,6,0,1,4,0,1,'2010-05-27 23:29:06',167881,'2010-05-27 23:29:10',182698,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01482,0.167,0,'PING OK - Packet loss = 0%, RTA = 0.03 ms','rta=0.033000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9196,1,3,0,1,4,0,1,'2010-05-27 23:29:07',175371,'2010-05-27 23:29:07',190027,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01466,0.175,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9200,1,9,0,1,4,0,1,'2010-05-27 23:31:15',169623,'2010-05-27 23:31:15',182486,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01286,0.169,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9202,1,7,0,1,4,0,1,'2010-05-27 23:32:22',46392,'2010-05-27 23:32:22',61633,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01524,0.045,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9204,1,10,0,1,4,0,1,'2010-05-27 23:32:55',107837,'2010-05-27 23:32:55',127718,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.01988,0.107,0,'PROCS OK: 62 processes with STATE = RSZDT',''),(9206,1,8,0,1,4,0,1,'2010-05-27 23:33:26',163199,'2010-05-27 23:33:26',184363,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02116,0.163,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9207,1,52,0,3,3,2,1,'2010-05-27 23:33:29',173171,'2010-05-27 23:33:29',254794,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.08162,0.172,255,'(Return code of 255 is out of bounds)',''),(9210,1,4,0,1,4,0,1,'2010-05-27 23:33:42',201913,'2010-05-27 23:33:42',219171,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.01726,0.201,0,'USERS OK - 0 users currently logged in','users=0;20;50;0'),(9212,1,5,0,1,4,0,1,'2010-05-27 23:34:02',245140,'2010-05-27 23:34:02',266412,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.02127,0.244,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.002 second response time','time=0.001668s;;;0.000000 size=311B;;;0'),(9213,1,6,0,1,4,0,1,'2010-05-27 23:34:06',11315,'2010-05-27 23:34:10',25903,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01459,0.011,0,'PING OK - Packet loss = 0%, RTA = 0.03 ms','rta=0.032000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9214,1,3,0,1,4,0,1,'2010-05-27 23:34:07',19350,'2010-05-27 23:34:07',33406,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01406,0.019,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9218,1,9,0,1,4,0,1,'2010-05-27 23:36:15',13625,'2010-05-27 23:36:15',25985,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01236,0.013,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9220,1,7,0,1,4,0,1,'2010-05-27 23:37:22',138424,'2010-05-27 23:37:22',153168,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01474,0.137,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9222,1,10,0,1,4,0,1,'2010-05-27 23:37:55',197965,'2010-05-27 23:37:55',218458,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02049,0.197,0,'PROCS OK: 62 processes with STATE = RSZDT',''),(9224,1,8,0,1,4,0,1,'2010-05-27 23:38:26',4724,'2010-05-27 23:38:26',26163,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02144,0.004,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9225,1,52,0,3,3,2,1,'2010-05-27 23:38:29',15999,'2010-05-27 23:38:29',97741,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.08174,0.015,255,'(Return code of 255 is out of bounds)',''),(9228,1,4,0,1,4,0,1,'2010-05-27 23:38:42',46911,'2010-05-27 23:38:42',65851,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.01894,0.046,0,'USERS OK - 0 users currently logged in','users=0;20;50;0'),(9230,1,5,0,1,4,0,1,'2010-05-27 23:39:02',88789,'2010-05-27 23:39:02',106788,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.018,0.088,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.002 second response time','time=0.001741s;;;0.000000 size=311B;;;0'),(9231,1,6,0,1,4,0,1,'2010-05-27 23:39:06',102477,'2010-05-27 23:39:10',115825,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01335,0.102,0,'PING OK - Packet loss = 0%, RTA = 0.03 ms','rta=0.034000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9232,1,3,0,1,4,0,1,'2010-05-27 23:39:07',109972,'2010-05-27 23:39:07',123239,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01327,0.109,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9236,1,9,0,1,4,0,1,'2010-05-27 23:41:15',111157,'2010-05-27 23:41:15',123972,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01282,0.111,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9238,1,7,0,1,4,0,1,'2010-05-27 23:42:22',231968,'2010-05-27 23:42:22',251581,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01961,0.23,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9240,1,10,0,1,4,0,1,'2010-05-27 23:42:55',47879,'2010-05-27 23:42:55',68561,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02068,0.047,0,'PROCS OK: 62 processes with STATE = RSZDT',''),(9242,1,8,0,1,4,0,1,'2010-05-27 23:43:26',105926,'2010-05-27 23:43:26',126162,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02024,0.105,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9243,1,52,0,3,3,2,1,'2010-05-27 23:43:29',116317,'2010-05-27 23:43:29',200230,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.08391,0.116,255,'(Return code of 255 is out of bounds)',''),(9246,1,4,0,1,4,0,1,'2010-05-27 23:43:42',146388,'2010-05-27 23:43:42',165575,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.01919,0.146,0,'USERS OK - 0 users currently logged in','users=0;20;50;0'),(9248,1,5,0,1,4,0,1,'2010-05-27 23:44:02',187683,'2010-05-27 23:44:02',205611,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.01793,0.187,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.002 second response time','time=0.001561s;;;0.000000 size=311B;;;0'),(9249,1,6,0,1,4,0,1,'2010-05-27 23:44:06',201769,'2010-05-27 23:44:10',215986,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01422,0.201,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.035000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9250,1,3,0,1,4,0,1,'2010-05-27 23:44:07',209783,'2010-05-27 23:44:07',223234,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01345,0.209,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9254,1,9,0,1,4,0,1,'2010-05-27 23:46:15',221895,'2010-05-27 23:46:15',234882,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01299,0.221,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9256,1,7,0,1,4,0,1,'2010-05-27 23:47:22',107522,'2010-05-27 23:47:22',120656,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01313,0.107,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9258,1,10,0,1,4,0,1,'2010-05-27 23:47:55',163859,'2010-05-27 23:47:55',185034,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02117,0.163,0,'PROCS OK: 62 processes with STATE = RSZDT',''),(9260,1,8,0,1,4,0,1,'2010-05-27 23:48:26',220644,'2010-05-27 23:48:26',242079,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02143,0.22,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9261,1,52,0,3,3,2,1,'2010-05-27 23:48:29',231134,'2010-05-27 23:48:29',316921,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.08579,0.23,255,'(Return code of 255 is out of bounds)',''),(9264,1,4,0,1,4,0,1,'2010-05-27 23:48:42',10532,'2010-05-27 23:48:42',29990,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.01946,0.01,0,'USERS OK - 0 users currently logged in','users=0;20;50;0'),(9266,1,5,0,1,4,0,1,'2010-05-27 23:49:02',54185,'2010-05-27 23:49:02',71764,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.01758,0.053,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.002 second response time','time=0.001746s;;;0.000000 size=311B;;;0'),(9267,1,6,0,1,4,0,1,'2010-05-27 23:49:06',69200,'2010-05-27 23:49:10',83828,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.01463,0.068,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.037000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9268,1,3,0,1,4,0,1,'2010-05-27 23:49:07',76141,'2010-05-27 23:49:07',91214,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01507,0.075,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9272,1,9,0,1,4,0,1,'2010-05-27 23:51:15',69611,'2010-05-27 23:51:15',81995,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01238,0.069,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9274,1,7,0,1,4,0,1,'2010-05-27 23:52:22',194531,'2010-05-27 23:52:22',212112,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01758,0.194,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9276,1,10,0,1,4,0,1,'2010-05-27 23:52:55',2150,'2010-05-27 23:52:55',22547,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.0204,0.002,0,'PROCS OK: 62 processes with STATE = RSZDT',''),(9278,1,8,0,1,4,0,1,'2010-05-27 23:53:26',58859,'2010-05-27 23:53:26',79242,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02038,0.058,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9279,1,52,0,3,3,2,1,'2010-05-27 23:53:29',68962,'2010-05-27 23:53:29',149930,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.08097,0.068,255,'(Return code of 255 is out of bounds)',''),(9282,1,4,0,1,4,0,1,'2010-05-27 23:53:42',100201,'2010-05-27 23:53:42',117644,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0.01744,0.1,0,'USERS OK - 0 users currently logged in','users=0;20;50;0'),(9284,1,5,0,1,4,0,1,'2010-05-27 23:54:02',143171,'2010-05-27 23:54:02',162819,16,'','/usr/local/monitor/libexec/check_http -I 127.0.0.1 ',60,0,0.01965,0.143,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.002 second response time','time=0.001535s;;;0.000000 size=311B;;;0'),(9285,1,6,0,1,4,0,1,'2010-05-27 23:54:06',156610,'2010-05-27 23:54:10',170311,25,'100.0,20%!500.0,60%','/usr/local/monitor/libexec/check_ping -H 127.0.0.1 -w 100.0,20% -c 500.0,60% -p 5',60,0,4.0137,0.156,0,'PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.039000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0'),(9286,1,3,0,1,4,0,1,'2010-05-27 23:54:07',164475,'2010-05-27 23:54:07',178741,19,'5.0,4.0,3.0!10.0,6.0,4.0','/usr/local/monitor/libexec/check_load -w 5.0,4.0,3.0 -c 10.0,6.0,4.0',60,0,0.01427,0.164,0,'OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;'),(9290,1,9,0,1,4,0,1,'2010-05-29 09:37:20',100780,'2010-05-29 09:37:20',120372,22,'20!10','/usr/local/monitor/libexec/check_swap -w 20 -c 10',60,0,0.01959,0.1,0,'SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894'),(9292,1,7,0,1,4,0,1,'2010-05-29 09:38:27',8794,'2010-05-29 09:38:27',23553,18,'20%!10%!/','/usr/local/monitor/libexec/check_disk -w 20% -c 10% -p /',60,0,0.01476,0.008,0,'DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274'),(9294,1,10,0,1,4,0,1,'2010-05-29 09:39:00',79690,'2010-05-29 09:39:00',103346,21,'250!400!RSZDT','/usr/local/monitor/libexec/check_procs -w 250 -c 400 -s RSZDT',60,0,0.02366,0.079,0,'PROCS OK: 64 processes with STATE = RSZDT',''),(9296,1,8,0,1,4,0,1,'2010-05-29 09:39:31',133431,'2010-05-29 09:39:31',158650,29,'','/usr/local/monitor/libexec/check_ssh  127.0.0.1',60,0,0.02522,0.133,0,'SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)',''),(9297,1,52,0,3,3,2,1,'2010-05-29 09:39:34',144383,'2010-05-29 09:39:34',241108,48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf','/usr/local/monitorbp/libexec/check_bp_status.pl -b app1 -f /usr/local/monitorbp/etc/nagios-bp.conf',60,0,0.09672,0.144,255,'(Return code of 255 is out of bounds)',''),(9300,1,4,0,1,4,0,1,'2010-05-29 09:39:47',174758,'1969-12-31 16:00:00',0,23,'20!50','/usr/local/monitor/libexec/check_users -w 20 -c 50',60,0,0,0.173,0,'USERS OK - 0 users currently logged in','users=0;20;50;0');
/*!40000 ALTER TABLE `nagios_servicechecks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_servicedependencies`
--

DROP TABLE IF EXISTS `nagios_servicedependencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_servicedependencies` (
  `servicedependency_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `service_object_id` int(11) NOT NULL DEFAULT '0',
  `dependent_service_object_id` int(11) NOT NULL DEFAULT '0',
  `dependency_type` smallint(6) NOT NULL DEFAULT '0',
  `inherits_parent` smallint(6) NOT NULL DEFAULT '0',
  `timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  `fail_on_ok` smallint(6) NOT NULL DEFAULT '0',
  `fail_on_warning` smallint(6) NOT NULL DEFAULT '0',
  `fail_on_unknown` smallint(6) NOT NULL DEFAULT '0',
  `fail_on_critical` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`servicedependency_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`config_type`,`service_object_id`,`dependent_service_object_id`,`dependency_type`,`inherits_parent`,`fail_on_ok`,`fail_on_warning`,`fail_on_unknown`,`fail_on_critical`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Service dependency definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_servicedependencies`
--

LOCK TABLES `nagios_servicedependencies` WRITE;
/*!40000 ALTER TABLE `nagios_servicedependencies` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_servicedependencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_serviceescalation_contactgroups`
--

DROP TABLE IF EXISTS `nagios_serviceescalation_contactgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_serviceescalation_contactgroups` (
  `serviceescalation_contactgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `serviceescalation_id` int(11) NOT NULL DEFAULT '0',
  `contactgroup_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`serviceescalation_contactgroup_id`),
  UNIQUE KEY `instance_id` (`serviceescalation_id`,`contactgroup_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Service escalation contact groups';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_serviceescalation_contactgroups`
--

LOCK TABLES `nagios_serviceescalation_contactgroups` WRITE;
/*!40000 ALTER TABLE `nagios_serviceescalation_contactgroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_serviceescalation_contactgroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_serviceescalation_contacts`
--

DROP TABLE IF EXISTS `nagios_serviceescalation_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_serviceescalation_contacts` (
  `serviceescalation_contact_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `serviceescalation_id` int(11) NOT NULL DEFAULT '0',
  `contact_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`serviceescalation_contact_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`serviceescalation_id`,`contact_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_serviceescalation_contacts`
--

LOCK TABLES `nagios_serviceescalation_contacts` WRITE;
/*!40000 ALTER TABLE `nagios_serviceescalation_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_serviceescalation_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_serviceescalations`
--

DROP TABLE IF EXISTS `nagios_serviceescalations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_serviceescalations` (
  `serviceescalation_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `service_object_id` int(11) NOT NULL DEFAULT '0',
  `timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  `first_notification` smallint(6) NOT NULL DEFAULT '0',
  `last_notification` smallint(6) NOT NULL DEFAULT '0',
  `notification_interval` double NOT NULL DEFAULT '0',
  `escalate_on_recovery` smallint(6) NOT NULL DEFAULT '0',
  `escalate_on_warning` smallint(6) NOT NULL DEFAULT '0',
  `escalate_on_unknown` smallint(6) NOT NULL DEFAULT '0',
  `escalate_on_critical` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`serviceescalation_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`config_type`,`service_object_id`,`timeperiod_object_id`,`first_notification`,`last_notification`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Service escalation definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_serviceescalations`
--

LOCK TABLES `nagios_serviceescalations` WRITE;
/*!40000 ALTER TABLE `nagios_serviceescalations` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_serviceescalations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_servicegroup_members`
--

DROP TABLE IF EXISTS `nagios_servicegroup_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_servicegroup_members` (
  `servicegroup_member_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `servicegroup_id` int(11) NOT NULL DEFAULT '0',
  `service_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`servicegroup_member_id`),
  UNIQUE KEY `instance_id` (`servicegroup_id`,`service_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Servicegroup members';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_servicegroup_members`
--

LOCK TABLES `nagios_servicegroup_members` WRITE;
/*!40000 ALTER TABLE `nagios_servicegroup_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_servicegroup_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_servicegroups`
--

DROP TABLE IF EXISTS `nagios_servicegroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_servicegroups` (
  `servicegroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `servicegroup_object_id` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`servicegroup_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`config_type`,`servicegroup_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Servicegroup definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_servicegroups`
--

LOCK TABLES `nagios_servicegroups` WRITE;
/*!40000 ALTER TABLE `nagios_servicegroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_servicegroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_services`
--

DROP TABLE IF EXISTS `nagios_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_services` (
  `service_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `host_object_id` int(11) NOT NULL DEFAULT '0',
  `service_object_id` int(11) NOT NULL DEFAULT '0',
  `display_name` varchar(64) NOT NULL DEFAULT '',
  `check_command_object_id` int(11) NOT NULL DEFAULT '0',
  `check_command_args` varchar(255) NOT NULL DEFAULT '',
  `eventhandler_command_object_id` int(11) NOT NULL DEFAULT '0',
  `eventhandler_command_args` varchar(255) NOT NULL DEFAULT '',
  `notification_timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  `check_timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  `failure_prediction_options` varchar(64) NOT NULL DEFAULT '',
  `check_interval` double NOT NULL DEFAULT '0',
  `retry_interval` double NOT NULL DEFAULT '0',
  `max_check_attempts` smallint(6) NOT NULL DEFAULT '0',
  `first_notification_delay` double NOT NULL DEFAULT '0',
  `notification_interval` double NOT NULL DEFAULT '0',
  `notify_on_warning` smallint(6) NOT NULL DEFAULT '0',
  `notify_on_unknown` smallint(6) NOT NULL DEFAULT '0',
  `notify_on_critical` smallint(6) NOT NULL DEFAULT '0',
  `notify_on_recovery` smallint(6) NOT NULL DEFAULT '0',
  `notify_on_flapping` smallint(6) NOT NULL DEFAULT '0',
  `notify_on_downtime` smallint(6) NOT NULL DEFAULT '0',
  `stalk_on_ok` smallint(6) NOT NULL DEFAULT '0',
  `stalk_on_warning` smallint(6) NOT NULL DEFAULT '0',
  `stalk_on_unknown` smallint(6) NOT NULL DEFAULT '0',
  `stalk_on_critical` smallint(6) NOT NULL DEFAULT '0',
  `is_volatile` smallint(6) NOT NULL DEFAULT '0',
  `flap_detection_enabled` smallint(6) NOT NULL DEFAULT '0',
  `flap_detection_on_ok` smallint(6) NOT NULL DEFAULT '0',
  `flap_detection_on_warning` smallint(6) NOT NULL DEFAULT '0',
  `flap_detection_on_unknown` smallint(6) NOT NULL DEFAULT '0',
  `flap_detection_on_critical` smallint(6) NOT NULL DEFAULT '0',
  `low_flap_threshold` double NOT NULL DEFAULT '0',
  `high_flap_threshold` double NOT NULL DEFAULT '0',
  `process_performance_data` smallint(6) NOT NULL DEFAULT '0',
  `freshness_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `freshness_threshold` smallint(6) NOT NULL DEFAULT '0',
  `passive_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `event_handler_enabled` smallint(6) NOT NULL DEFAULT '0',
  `active_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `retain_status_information` smallint(6) NOT NULL DEFAULT '0',
  `retain_nonstatus_information` smallint(6) NOT NULL DEFAULT '0',
  `notifications_enabled` smallint(6) NOT NULL DEFAULT '0',
  `obsess_over_service` smallint(6) NOT NULL DEFAULT '0',
  `failure_prediction_enabled` smallint(6) NOT NULL DEFAULT '0',
  `notes` varchar(255) NOT NULL DEFAULT '',
  `notes_url` varchar(255) NOT NULL DEFAULT '',
  `action_url` varchar(255) NOT NULL DEFAULT '',
  `icon_image` varchar(255) NOT NULL DEFAULT '',
  `icon_image_alt` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`service_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`config_type`,`service_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=latin1 COMMENT='Service definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_services`
--

LOCK TABLES `nagios_services` WRITE;
/*!40000 ALTER TABLE `nagios_services` DISABLE KEYS */;
INSERT INTO `nagios_services` VALUES (87,1,1,50,52,'app1',48,'app1!/usr/local/monitorbp/etc/nagios-bp.conf',0,'',37,2,'',5,1,3,0,60,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,'','','','',''),(88,1,1,1,3,'Current Load',19,'5.0,4.0,3.0!10.0,6.0,4.0',0,'',2,2,'',5,1,4,0,60,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,'','','','',''),(89,1,1,1,4,'Current Users',23,'20!50',0,'',2,2,'',5,1,4,0,60,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,'','','','',''),(90,1,1,1,5,'HTTP',16,'',0,'',2,2,'',5,1,4,0,60,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,'','','','',''),(91,1,1,1,6,'PING',25,'100.0,20%!500.0,60%',0,'',2,2,'',5,1,4,0,60,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,'','','','',''),(92,1,1,1,7,'Root Partition',18,'20%!10%!/',0,'',2,2,'',5,1,4,0,60,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,'','','','',''),(93,1,1,1,8,'SSH',29,'',0,'',2,2,'',5,1,4,0,60,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0,1,1,1,1,1,0,1,1,'','','','',''),(94,1,1,1,9,'Swap Usage',22,'20!10',0,'',2,2,'',5,1,4,0,60,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,'','','','',''),(95,1,1,1,10,'Total Processes',21,'250!400!RSZDT',0,'',2,2,'',5,1,4,0,60,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,'','','','','');
/*!40000 ALTER TABLE `nagios_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_servicestatus`
--

DROP TABLE IF EXISTS `nagios_servicestatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_servicestatus` (
  `servicestatus_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `service_object_id` int(11) NOT NULL DEFAULT '0',
  `status_update_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `output` varchar(255) NOT NULL DEFAULT '',
  `perfdata` varchar(255) NOT NULL DEFAULT '',
  `current_state` smallint(6) NOT NULL DEFAULT '0',
  `has_been_checked` smallint(6) NOT NULL DEFAULT '0',
  `should_be_scheduled` smallint(6) NOT NULL DEFAULT '0',
  `current_check_attempt` smallint(6) NOT NULL DEFAULT '0',
  `max_check_attempts` smallint(6) NOT NULL DEFAULT '0',
  `last_check` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `next_check` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `check_type` smallint(6) NOT NULL DEFAULT '0',
  `last_state_change` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_hard_state_change` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_hard_state` smallint(6) NOT NULL DEFAULT '0',
  `last_time_ok` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_time_warning` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_time_unknown` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_time_critical` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `state_type` smallint(6) NOT NULL DEFAULT '0',
  `last_notification` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `next_notification` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `no_more_notifications` smallint(6) NOT NULL DEFAULT '0',
  `notifications_enabled` smallint(6) NOT NULL DEFAULT '0',
  `problem_has_been_acknowledged` smallint(6) NOT NULL DEFAULT '0',
  `acknowledgement_type` smallint(6) NOT NULL DEFAULT '0',
  `current_notification_number` smallint(6) NOT NULL DEFAULT '0',
  `passive_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `active_checks_enabled` smallint(6) NOT NULL DEFAULT '0',
  `event_handler_enabled` smallint(6) NOT NULL DEFAULT '0',
  `flap_detection_enabled` smallint(6) NOT NULL DEFAULT '0',
  `is_flapping` smallint(6) NOT NULL DEFAULT '0',
  `percent_state_change` double NOT NULL DEFAULT '0',
  `latency` double NOT NULL DEFAULT '0',
  `execution_time` double NOT NULL DEFAULT '0',
  `scheduled_downtime_depth` smallint(6) NOT NULL DEFAULT '0',
  `failure_prediction_enabled` smallint(6) NOT NULL DEFAULT '0',
  `process_performance_data` smallint(6) NOT NULL DEFAULT '0',
  `obsess_over_service` smallint(6) NOT NULL DEFAULT '0',
  `modified_service_attributes` int(11) NOT NULL DEFAULT '0',
  `event_handler` varchar(255) NOT NULL DEFAULT '',
  `check_command` varchar(255) NOT NULL DEFAULT '',
  `normal_check_interval` double NOT NULL DEFAULT '0',
  `retry_check_interval` double NOT NULL DEFAULT '0',
  `check_timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`servicestatus_id`),
  UNIQUE KEY `object_id` (`service_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1381 DEFAULT CHARSET=latin1 COMMENT='Current service status information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_servicestatus`
--

LOCK TABLES `nagios_servicestatus` WRITE;
/*!40000 ALTER TABLE `nagios_servicestatus` DISABLE KEYS */;
INSERT INTO `nagios_servicestatus` VALUES (1372,1,52,'2010-05-29 09:39:37','(Return code of 255 is out of bounds)','',2,1,1,3,3,'2010-05-29 09:39:34','2010-05-29 09:44:34',0,'2010-05-06 03:06:54','2010-05-06 03:08:54',2,'2010-05-04 17:20:49','1969-12-31 16:00:00','1969-12-31 16:00:00','2010-05-29 09:39:34',1,'1969-12-31 16:00:00','2010-05-29 09:39:37',0,1,0,0,0,1,1,1,1,0,0,0.144,0.09672,0,1,1,1,0,'','check_bp_status!app1!/usr/local/monitorbp/etc/nagios-bp.conf',5,1,2),(1373,1,3,'2010-05-29 09:37:10','OK - load average: 0.00, 0.00, 0.00','load1=0.000;5.000;10.000;0; load5=0.000;4.000;6.000;0; load15=0.000;3.000;4.000;0;',0,1,1,1,4,'2010-05-29 09:35:12','2010-05-29 09:40:12',0,'2010-05-04 03:43:11','2010-05-04 03:43:11',0,'2010-05-27 23:54:07','1969-12-31 16:00:00','1969-12-31 16:00:00','1969-12-31 16:00:00',1,'1969-12-31 16:00:00','1969-12-31 17:00:00',0,1,0,0,0,1,1,1,1,0,0,0.164,0.01427,0,1,1,1,0,'','check_local_load!5.0,4.0,3.0!10.0,6.0,4.0',5,1,2),(1374,1,4,'2010-05-29 09:37:10','USERS OK - 0 users currently logged in','users=0;20;50;0',0,1,1,1,4,'2010-05-29 09:34:47','2010-05-29 09:39:47',0,'2010-05-04 03:43:49','2010-05-04 03:43:49',0,'2010-05-27 23:53:42','1969-12-31 16:00:00','1969-12-31 16:00:00','1969-12-31 16:00:00',1,'1969-12-31 16:00:00','1969-12-31 17:00:00',0,1,0,0,0,1,1,1,1,0,0,0.1,0.01744,0,1,1,1,0,'','check_local_users!20!50',5,1,2),(1375,1,5,'2010-05-29 09:37:10','HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.002 second response time','time=0.001535s;;;0.000000 size=311B;;;0',0,1,1,1,4,'2010-05-29 09:35:07','2010-05-29 09:40:07',0,'2010-05-06 02:46:12','2010-05-05 00:05:26',0,'2010-05-27 23:54:02','2010-05-04 17:04:07','1969-12-31 16:00:00','2010-04-27 21:32:10',1,'1969-12-31 16:00:00','1969-12-31 17:00:00',0,1,0,0,0,1,1,1,1,0,0,0.143,0.01965,0,1,1,1,1,'','check_http',5,1,2),(1376,1,6,'2010-05-29 09:37:10','PING OK - Packet loss = 0%, RTA = 0.04 ms','rta=0.039000ms;100.000000;500.000000;0.000000 pl=0%;20;60;0',0,1,1,1,4,'2010-05-29 09:35:11','2010-05-29 09:40:11',0,'2010-05-04 03:45:04','2010-05-04 03:45:04',0,'2010-05-27 23:54:06','1969-12-31 16:00:00','1969-12-31 16:00:00','1969-12-31 16:00:00',1,'1969-12-31 16:00:00','1969-12-31 17:00:00',0,1,0,0,0,1,1,1,1,0,0,0.156,4.0137,0,1,1,1,0,'','check_ping!100.0,20%!500.0,60%',5,1,2),(1377,1,7,'2010-05-29 09:38:37','DISK OK - free space: / 16736 MB (91% inode=96%):','/=1559MB;15419;17346;0;19274',0,1,1,1,4,'2010-05-29 09:38:27','2010-05-29 09:43:27',0,'2010-05-04 03:45:41','2010-05-04 03:45:41',0,'2010-05-29 09:38:27','1969-12-31 16:00:00','1969-12-31 16:00:00','1969-12-31 16:00:00',1,'1969-12-31 16:00:00','1969-12-31 16:00:00',0,1,0,0,0,1,1,1,1,0,0,0.008,0.01476,0,1,1,1,0,'','check_local_disk!20%!10%!/',5,1,2),(1378,1,8,'2010-05-29 09:39:37','SSH OK - OpenSSH_5.3p1 Debian-3ubuntu3 (protocol 2.0)','',0,1,1,1,4,'2010-05-29 09:39:31','2010-05-29 09:44:31',0,'2010-05-04 03:46:19','2010-05-04 03:46:19',0,'2010-05-29 09:39:31','1969-12-31 16:00:00','1969-12-31 16:00:00','1969-12-31 16:00:00',1,'1969-12-31 16:00:00','1969-12-31 16:00:00',0,0,0,0,0,1,1,1,1,0,0,0.133,0.02522,0,1,1,1,0,'','check_ssh',5,1,2),(1379,1,9,'2010-05-29 09:37:27','SWAP OK - 100% free (894 MB out of 894 MB)','swap=894MB;0;0;0;894',0,1,1,1,4,'2010-05-29 09:37:20','2010-05-29 09:42:20',0,'2010-05-04 03:46:56','2010-05-04 03:46:56',0,'2010-05-29 09:37:20','1969-12-31 16:00:00','1969-12-31 16:00:00','1969-12-31 16:00:00',1,'1969-12-31 16:00:00','1969-12-31 16:00:00',0,1,0,0,0,1,1,1,1,0,0,0.1,0.01959,0,1,1,1,0,'','check_local_swap!20!10',5,1,2),(1380,1,10,'2010-05-29 09:39:07','PROCS OK: 64 processes with STATE = RSZDT','',0,1,1,1,4,'2010-05-29 09:39:00','2010-05-29 09:44:00',0,'2010-05-04 03:47:34','2010-05-04 03:47:34',0,'2010-05-29 09:39:00','1969-12-31 16:00:00','1969-12-31 16:00:00','1969-12-31 16:00:00',1,'1969-12-31 16:00:00','1969-12-31 16:00:00',0,1,0,0,0,1,1,1,1,0,0,0.079,0.02366,0,1,1,1,0,'','check_local_procs!250!400!RSZDT',5,1,2);
/*!40000 ALTER TABLE `nagios_servicestatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_statehistory`
--

DROP TABLE IF EXISTS `nagios_statehistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_statehistory` (
  `statehistory_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `state_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `state_time_usec` int(11) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `state_change` smallint(6) NOT NULL DEFAULT '0',
  `state` smallint(6) NOT NULL DEFAULT '0',
  `state_type` smallint(6) NOT NULL DEFAULT '0',
  `current_check_attempt` smallint(6) NOT NULL DEFAULT '0',
  `max_check_attempts` smallint(6) NOT NULL DEFAULT '0',
  `last_state` smallint(6) NOT NULL DEFAULT '-1',
  `last_hard_state` smallint(6) NOT NULL DEFAULT '-1',
  `output` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`statehistory_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1 COMMENT='Historical host and service state changes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_statehistory`
--

LOCK TABLES `nagios_statehistory` WRITE;
/*!40000 ALTER TABLE `nagios_statehistory` DISABLE KEYS */;
INSERT INTO `nagios_statehistory` VALUES (1,1,'2010-04-25 18:37:57',247437,5,1,2,0,1,4,0,0,'Connection refused'),(2,1,'2010-04-25 18:38:57',133168,5,1,2,0,2,4,2,0,'Connection refused'),(3,1,'2010-04-25 18:39:57',27443,5,1,2,0,3,4,2,0,'Connection refused'),(4,1,'2010-04-25 18:40:57',216061,5,1,2,1,4,4,2,0,'Connection refused'),(5,1,'2010-04-25 19:15:57',54300,5,1,0,1,4,4,2,2,'HTTP OK: HTTP/1.1 200 OK - 453 bytes in 0.002 second response time'),(6,1,'2010-04-26 17:45:55',46128,52,1,2,1,1,1,0,0,'(Return code of 127 is out of bounds - plugin may be missing)'),(7,1,'2010-04-26 17:55:56',112442,52,1,0,1,3,3,2,2,'Business Process OK: My Applic 01'),(8,1,'2010-04-27 15:54:16',20825,5,1,1,0,1,4,0,0,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.002 second response time'),(9,1,'2010-04-27 15:55:16',148181,5,1,1,0,2,4,1,0,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.002 second response time'),(10,1,'2010-04-27 15:56:16',27330,5,1,1,0,3,4,1,0,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.002 second response time'),(11,1,'2010-04-27 15:57:16',184659,5,1,1,1,4,4,1,0,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.002 second response time'),(12,1,'2010-04-27 17:12:16',143017,5,1,2,1,4,4,1,1,'Connection refused'),(13,1,'2010-04-27 17:22:16',151207,5,1,1,1,4,4,2,2,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time'),(14,1,'2010-04-27 21:27:16',208934,5,1,0,1,4,4,1,1,'HTTP OK: HTTP/1.1 200 OK - 294 bytes in 0.002 second response time'),(15,1,'2010-04-27 21:32:16',79042,5,1,2,0,1,4,0,0,'Connection refused'),(16,1,'2010-04-27 21:33:16',203795,5,1,0,0,2,4,2,0,'HTTP OK: HTTP/1.1 200 OK - 294 bytes in 0.002 second response time'),(17,1,'2010-04-27 21:43:16',156966,5,1,1,0,1,4,0,0,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.001 second response time'),(18,1,'2010-04-27 21:44:16',58263,5,1,1,0,2,4,1,0,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.002 second response time'),(19,1,'2010-04-27 21:45:16',173319,5,1,0,0,3,4,1,0,'HTTP OK: HTTP/1.1 200 OK - 294 bytes in 0.002 second response time'),(20,1,'2010-05-04 17:04:17',234426,5,1,1,0,1,4,0,0,'HTTP WARNING: HTTP/1.1 403 Forbidden - 489 bytes in 0.006 second response time'),(21,1,'2010-05-04 17:05:17',141626,5,1,0,0,2,4,1,0,'HTTP OK: HTTP/1.1 200 OK - 311 bytes in 0.006 second response time');
/*!40000 ALTER TABLE `nagios_statehistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_systemcommands`
--

DROP TABLE IF EXISTS `nagios_systemcommands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_systemcommands` (
  `systemcommand_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `start_time_usec` int(11) NOT NULL DEFAULT '0',
  `end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_time_usec` int(11) NOT NULL DEFAULT '0',
  `command_line` varchar(255) NOT NULL DEFAULT '',
  `timeout` smallint(6) NOT NULL DEFAULT '0',
  `early_timeout` smallint(6) NOT NULL DEFAULT '0',
  `execution_time` double NOT NULL DEFAULT '0',
  `return_code` smallint(6) NOT NULL DEFAULT '0',
  `output` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`systemcommand_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`start_time`,`start_time_usec`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historical system commands that are executed';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_systemcommands`
--

LOCK TABLES `nagios_systemcommands` WRITE;
/*!40000 ALTER TABLE `nagios_systemcommands` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios_systemcommands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_timedeventqueue`
--

DROP TABLE IF EXISTS `nagios_timedeventqueue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_timedeventqueue` (
  `timedeventqueue_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `event_type` smallint(6) NOT NULL DEFAULT '0',
  `queued_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `queued_time_usec` int(11) NOT NULL DEFAULT '0',
  `scheduled_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `recurring_event` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`timedeventqueue_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39091 DEFAULT CHARSET=latin1 COMMENT='Current Nagios event queue';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_timedeventqueue`
--

LOCK TABLES `nagios_timedeventqueue` WRITE;
/*!40000 ALTER TABLE `nagios_timedeventqueue` DISABLE KEYS */;
INSERT INTO `nagios_timedeventqueue` VALUES (39029,1,2,'2010-05-29 09:37:10',31659,'2010-05-30 00:00:00',1,0),(39030,1,7,'2010-05-29 09:37:10',31919,'2010-05-29 10:31:47',1,0),(39031,1,16,'2010-05-29 09:37:10',32172,'2010-05-30 03:59:54',0,0),(39039,1,0,'2010-05-29 09:37:10',34861,'2010-05-29 09:40:07',0,5),(39040,1,0,'2010-05-29 09:37:10',35158,'2010-05-29 09:40:11',0,6),(39041,1,0,'2010-05-29 09:37:10',35427,'2010-05-29 09:40:12',0,3),(39042,1,12,'2010-05-29 09:37:10',57623,'2010-05-29 09:41:17',0,1),(39043,1,12,'2010-05-29 09:37:10',60480,'2010-05-29 09:42:07',0,53),(39046,1,0,'2010-05-29 09:37:27',127398,'2010-05-29 09:42:20',0,9),(39064,1,0,'2010-05-29 09:38:37',31806,'2010-05-29 09:43:27',0,7),(39070,1,12,'2010-05-29 09:38:47',53912,'2010-05-29 09:43:47',0,51),(39075,1,0,'2010-05-29 09:39:07',95719,'2010-05-29 09:44:00',0,10),(39082,1,0,'2010-05-29 09:39:37',155165,'2010-05-29 09:44:31',0,8),(39083,1,0,'2010-05-29 09:39:37',156795,'2010-05-29 09:44:34',0,52),(39086,1,6,'2010-05-29 09:39:47',171938,'2010-05-29 09:40:47',1,0),(39087,1,10,'2010-05-29 09:39:47',171967,'2010-05-29 09:40:47',1,0),(39088,1,1,'2010-05-29 09:39:47',171991,'2010-05-29 09:40:47',1,0),(39089,1,5,'2010-05-29 09:39:47',172110,'2010-05-29 09:39:57',1,0),(39090,1,8,'2010-05-29 09:39:47',173930,'2010-05-29 09:39:57',1,0);
/*!40000 ALTER TABLE `nagios_timedeventqueue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_timedevents`
--

DROP TABLE IF EXISTS `nagios_timedevents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_timedevents` (
  `timedevent_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `event_type` smallint(6) NOT NULL DEFAULT '0',
  `queued_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `queued_time_usec` int(11) NOT NULL DEFAULT '0',
  `event_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `event_time_usec` int(11) NOT NULL DEFAULT '0',
  `scheduled_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `recurring_event` smallint(6) NOT NULL DEFAULT '0',
  `object_id` int(11) NOT NULL DEFAULT '0',
  `deletion_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deletion_time_usec` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`timedevent_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`event_type`,`scheduled_time`,`object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=77814 DEFAULT CHARSET=latin1 COMMENT='Historical events from the Nagios event queue';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_timedevents`
--

LOCK TABLES `nagios_timedevents` WRITE;
/*!40000 ALTER TABLE `nagios_timedevents` DISABLE KEYS */;
INSERT INTO `nagios_timedevents` VALUES (75056,1,16,'2010-05-27 22:41:49',373180,'0000-00-00 00:00:00',0,'2010-05-28 18:58:15',0,0,'0000-00-00 00:00:00',0),(75369,1,16,'2010-05-27 22:50:08',62414,'0000-00-00 00:00:00',0,'2010-05-28 17:44:08',0,0,'0000-00-00 00:00:00',0),(75404,1,16,'2010-05-27 22:50:42',405185,'0000-00-00 00:00:00',0,'2010-05-28 18:18:49',0,0,'0000-00-00 00:00:00',0),(77700,1,5,'2010-05-29 09:37:10',30383,'2010-05-29 09:37:17',46557,'2010-05-29 09:37:17',1,0,'0000-00-00 00:00:00',0),(77701,1,8,'2010-05-29 09:37:10',30733,'2010-05-29 09:37:17',47414,'2010-05-29 09:37:17',1,0,'0000-00-00 00:00:00',0),(77702,1,6,'2010-05-29 09:37:10',30975,'2010-05-29 09:37:47',170016,'2010-05-29 09:37:47',1,0,'0000-00-00 00:00:00',0),(77703,1,10,'2010-05-29 09:37:10',31153,'2010-05-29 09:37:47',170058,'2010-05-29 09:37:47',1,0,'0000-00-00 00:00:00',0),(77704,1,1,'2010-05-29 09:37:10',31337,'2010-05-29 09:37:47',170073,'2010-05-29 09:37:47',1,0,'0000-00-00 00:00:00',0),(77705,1,2,'2010-05-29 09:37:10',31659,'0000-00-00 00:00:00',0,'2010-05-30 00:00:00',1,0,'0000-00-00 00:00:00',0),(77706,1,7,'2010-05-29 09:37:10',31919,'0000-00-00 00:00:00',0,'2010-05-29 10:31:47',1,0,'0000-00-00 00:00:00',0),(77707,1,16,'2010-05-29 09:37:10',32172,'0000-00-00 00:00:00',0,'2010-05-30 03:59:54',0,0,'0000-00-00 00:00:00',0),(77708,1,0,'2010-05-29 09:37:10',32647,'2010-05-29 09:37:20',99768,'2010-05-29 09:37:20',0,9,'0000-00-00 00:00:00',0),(77709,1,0,'2010-05-29 09:37:10',33023,'2010-05-29 09:38:27',8588,'2010-05-29 09:38:27',0,7,'0000-00-00 00:00:00',0),(77710,1,12,'2010-05-29 09:37:10',33219,'2010-05-29 09:38:37',32733,'2010-05-29 09:38:37',0,51,'0000-00-00 00:00:00',0),(77711,1,0,'2010-05-29 09:37:10',33468,'2010-05-29 09:39:00',78378,'2010-05-29 09:39:00',0,10,'0000-00-00 00:00:00',0),(77712,1,0,'2010-05-29 09:37:10',33812,'2010-05-29 09:39:31',133163,'2010-05-29 09:39:31',0,8,'0000-00-00 00:00:00',0),(77713,1,0,'2010-05-29 09:37:10',34122,'2010-05-29 09:39:34',144214,'2010-05-29 09:39:34',0,52,'0000-00-00 00:00:00',0),(77714,1,0,'2010-05-29 09:37:10',34494,'2010-05-29 09:39:47',173950,'2010-05-29 09:39:47',0,4,'0000-00-00 00:00:00',0),(77715,1,0,'2010-05-29 09:37:10',34861,'0000-00-00 00:00:00',0,'2010-05-29 09:40:07',0,5,'0000-00-00 00:00:00',0),(77716,1,0,'2010-05-29 09:37:10',35158,'0000-00-00 00:00:00',0,'2010-05-29 09:40:11',0,6,'0000-00-00 00:00:00',0),(77717,1,0,'2010-05-29 09:37:10',35427,'0000-00-00 00:00:00',0,'2010-05-29 09:40:12',0,3,'0000-00-00 00:00:00',0),(77718,1,12,'2010-05-29 09:37:10',57623,'0000-00-00 00:00:00',0,'2010-05-29 09:41:17',0,1,'0000-00-00 00:00:00',0),(77719,1,12,'2010-05-29 09:37:10',60480,'0000-00-00 00:00:00',0,'2010-05-29 09:42:07',0,53,'0000-00-00 00:00:00',0),(77721,1,5,'2010-05-29 09:37:17',47385,'2010-05-29 09:37:27',126748,'2010-05-29 09:37:27',1,0,'0000-00-00 00:00:00',0),(77723,1,8,'2010-05-29 09:37:17',49016,'2010-05-29 09:37:27',127543,'2010-05-29 09:37:27',1,0,'0000-00-00 00:00:00',0),(77726,1,0,'2010-05-29 09:37:27',127398,'0000-00-00 00:00:00',0,'2010-05-29 09:42:20',0,9,'0000-00-00 00:00:00',0),(77727,1,5,'2010-05-29 09:37:27',127530,'2010-05-29 09:37:37',152008,'2010-05-29 09:37:37',1,0,'0000-00-00 00:00:00',0),(77729,1,8,'2010-05-29 09:37:27',129248,'2010-05-29 09:37:37',153589,'2010-05-29 09:37:37',1,0,'0000-00-00 00:00:00',0),(77731,1,5,'2010-05-29 09:37:37',153576,'2010-05-29 09:37:47',170104,'2010-05-29 09:37:47',1,0,'0000-00-00 00:00:00',0),(77733,1,8,'2010-05-29 09:37:37',154665,'2010-05-29 09:37:47',170160,'2010-05-29 09:37:47',1,0,'0000-00-00 00:00:00',0),(77735,1,6,'2010-05-29 09:37:47',170049,'2010-05-29 09:38:47',53497,'2010-05-29 09:38:47',1,0,'0000-00-00 00:00:00',0),(77737,1,10,'2010-05-29 09:37:47',170065,'2010-05-29 09:38:47',53542,'2010-05-29 09:38:47',1,0,'0000-00-00 00:00:00',0),(77739,1,1,'2010-05-29 09:37:47',170080,'2010-05-29 09:38:47',53562,'2010-05-29 09:38:47',1,0,'0000-00-00 00:00:00',0),(77741,1,5,'2010-05-29 09:37:47',170146,'2010-05-29 09:37:57',206236,'2010-05-29 09:37:57',1,0,'0000-00-00 00:00:00',0),(77743,1,8,'2010-05-29 09:37:47',171722,'2010-05-29 09:37:57',206346,'2010-05-29 09:37:57',1,0,'0000-00-00 00:00:00',0),(77745,1,5,'2010-05-29 09:37:57',206326,'2010-05-29 09:38:07',225181,'2010-05-29 09:38:07',1,0,'0000-00-00 00:00:00',0),(77747,1,8,'2010-05-29 09:37:57',208973,'2010-05-29 09:38:07',225322,'2010-05-29 09:38:07',1,0,'0000-00-00 00:00:00',0),(77749,1,5,'2010-05-29 09:38:07',225300,'2010-05-29 09:38:17',242566,'2010-05-29 09:38:17',1,0,'0000-00-00 00:00:00',0),(77751,1,8,'2010-05-29 09:38:07',227986,'2010-05-29 09:38:17',242634,'2010-05-29 09:38:17',1,0,'0000-00-00 00:00:00',0),(77753,1,5,'2010-05-29 09:38:17',242623,'2010-05-29 09:38:27',7621,'2010-05-29 09:38:27',1,0,'0000-00-00 00:00:00',0),(77755,1,8,'2010-05-29 09:38:17',243448,'2010-05-29 09:38:27',7696,'2010-05-29 09:38:27',1,0,'0000-00-00 00:00:00',0),(77757,1,5,'2010-05-29 09:38:27',7684,'2010-05-29 09:38:37',31512,'2010-05-29 09:38:37',1,0,'0000-00-00 00:00:00',0),(77759,1,8,'2010-05-29 09:38:27',8576,'2010-05-29 09:38:37',31943,'2010-05-29 09:38:37',1,0,'0000-00-00 00:00:00',0),(77762,1,0,'2010-05-29 09:38:37',31806,'0000-00-00 00:00:00',0,'2010-05-29 09:43:27',0,7,'0000-00-00 00:00:00',0),(77763,1,5,'2010-05-29 09:38:37',31931,'2010-05-29 09:38:47',53582,'2010-05-29 09:38:47',1,0,'0000-00-00 00:00:00',0),(77765,1,8,'2010-05-29 09:38:37',32720,'2010-05-29 09:38:47',54090,'2010-05-29 09:38:47',1,0,'0000-00-00 00:00:00',0),(77768,1,6,'2010-05-29 09:38:47',53530,'2010-05-29 09:39:47',171873,'2010-05-29 09:39:47',1,0,'0000-00-00 00:00:00',0),(77770,1,10,'2010-05-29 09:38:47',53551,'2010-05-29 09:39:47',171954,'2010-05-29 09:39:47',1,0,'0000-00-00 00:00:00',0),(77772,1,1,'2010-05-29 09:38:47',53571,'2010-05-29 09:39:47',171980,'2010-05-29 09:39:47',1,0,'0000-00-00 00:00:00',0),(77774,1,12,'2010-05-29 09:38:47',53912,'0000-00-00 00:00:00',0,'2010-05-29 09:43:47',0,51,'0000-00-00 00:00:00',0),(77775,1,5,'2010-05-29 09:38:47',54075,'2010-05-29 09:38:57',69722,'2010-05-29 09:38:57',1,0,'0000-00-00 00:00:00',0),(77777,1,8,'2010-05-29 09:38:47',55014,'2010-05-29 09:38:57',69921,'2010-05-29 09:38:57',1,0,'0000-00-00 00:00:00',0),(77779,1,5,'2010-05-29 09:38:57',69893,'2010-05-29 09:39:07',95301,'2010-05-29 09:39:07',1,0,'0000-00-00 00:00:00',0),(77781,1,8,'2010-05-29 09:38:57',71612,'2010-05-29 09:39:07',96064,'2010-05-29 09:39:07',1,0,'0000-00-00 00:00:00',0),(77784,1,0,'2010-05-29 09:39:07',95719,'0000-00-00 00:00:00',0,'2010-05-29 09:44:00',0,10,'0000-00-00 00:00:00',0),(77785,1,5,'2010-05-29 09:39:07',96047,'2010-05-29 09:39:17',111067,'2010-05-29 09:39:17',1,0,'0000-00-00 00:00:00',0),(77787,1,8,'2010-05-29 09:39:07',97139,'2010-05-29 09:39:17',111178,'2010-05-29 09:39:17',1,0,'0000-00-00 00:00:00',0),(77789,1,5,'2010-05-29 09:39:17',111162,'2010-05-29 09:39:27',126462,'2010-05-29 09:39:27',1,0,'0000-00-00 00:00:00',0),(77791,1,8,'2010-05-29 09:39:17',112820,'2010-05-29 09:39:27',126625,'2010-05-29 09:39:27',1,0,'0000-00-00 00:00:00',0),(77793,1,5,'2010-05-29 09:39:27',126591,'2010-05-29 09:39:37',154336,'2010-05-29 09:39:37',1,0,'0000-00-00 00:00:00',0),(77795,1,8,'2010-05-29 09:39:27',128305,'2010-05-29 09:39:37',156872,'2010-05-29 09:39:37',1,0,'0000-00-00 00:00:00',0),(77799,1,0,'2010-05-29 09:39:37',155165,'0000-00-00 00:00:00',0,'2010-05-29 09:44:31',0,8,'0000-00-00 00:00:00',0),(77800,1,0,'2010-05-29 09:39:37',156795,'0000-00-00 00:00:00',0,'2010-05-29 09:44:34',0,52,'0000-00-00 00:00:00',0),(77801,1,5,'2010-05-29 09:39:37',156860,'2010-05-29 09:39:47',172004,'2010-05-29 09:39:47',1,0,'0000-00-00 00:00:00',0),(77803,1,8,'2010-05-29 09:39:37',157715,'2010-05-29 09:39:47',172138,'2010-05-29 09:39:47',1,0,'0000-00-00 00:00:00',0),(77805,1,6,'2010-05-29 09:39:47',171938,'0000-00-00 00:00:00',0,'2010-05-29 09:40:47',1,0,'0000-00-00 00:00:00',0),(77807,1,10,'2010-05-29 09:39:47',171967,'0000-00-00 00:00:00',0,'2010-05-29 09:40:47',1,0,'0000-00-00 00:00:00',0),(77809,1,1,'2010-05-29 09:39:47',171991,'0000-00-00 00:00:00',0,'2010-05-29 09:40:47',1,0,'0000-00-00 00:00:00',0),(77811,1,5,'2010-05-29 09:39:47',172110,'0000-00-00 00:00:00',0,'2010-05-29 09:39:57',1,0,'0000-00-00 00:00:00',0),(77813,1,8,'2010-05-29 09:39:47',173930,'0000-00-00 00:00:00',0,'2010-05-29 09:39:57',1,0,'0000-00-00 00:00:00',0);
/*!40000 ALTER TABLE `nagios_timedevents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_timeperiod_timeranges`
--

DROP TABLE IF EXISTS `nagios_timeperiod_timeranges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_timeperiod_timeranges` (
  `timeperiod_timerange_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `timeperiod_id` int(11) NOT NULL DEFAULT '0',
  `day` smallint(6) NOT NULL DEFAULT '0',
  `start_sec` int(11) NOT NULL DEFAULT '0',
  `end_sec` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`timeperiod_timerange_id`),
  UNIQUE KEY `instance_id` (`timeperiod_id`,`day`,`start_sec`,`end_sec`)
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=latin1 COMMENT='Timeperiod definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_timeperiod_timeranges`
--

LOCK TABLES `nagios_timeperiod_timeranges` WRITE;
/*!40000 ALTER TABLE `nagios_timeperiod_timeranges` DISABLE KEYS */;
INSERT INTO `nagios_timeperiod_timeranges` VALUES (191,1,51,0,0,86400),(192,1,51,1,0,86400),(193,1,51,2,0,86400),(194,1,51,3,0,86400),(195,1,51,4,0,86400),(196,1,51,5,0,86400),(197,1,51,6,0,86400),(198,1,52,0,0,86400),(199,1,52,1,0,86400),(200,1,52,2,0,86400),(201,1,52,3,0,86400),(202,1,52,4,0,86400),(203,1,52,5,0,86400),(204,1,52,6,0,86400),(205,1,55,1,32400,61200),(206,1,55,2,32400,61200),(207,1,55,3,32400,61200),(208,1,55,4,32400,61200),(209,1,55,5,32400,61200);
/*!40000 ALTER TABLE `nagios_timeperiod_timeranges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_timeperiods`
--

DROP TABLE IF EXISTS `nagios_timeperiods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_timeperiods` (
  `timeperiod_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL DEFAULT '0',
  `config_type` smallint(6) NOT NULL DEFAULT '0',
  `timeperiod_object_id` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`timeperiod_id`),
  UNIQUE KEY `instance_id` (`instance_id`,`config_type`,`timeperiod_object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=latin1 COMMENT='Timeperiod definitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_timeperiods`
--

LOCK TABLES `nagios_timeperiods` WRITE;
/*!40000 ALTER TABLE `nagios_timeperiods` DISABLE KEYS */;
INSERT INTO `nagios_timeperiods` VALUES (51,1,1,2,'24 Hours A Day, 7 Days A Week'),(52,1,1,36,'24x7 Sans Holidays'),(53,1,1,37,'No Time Is A Good Time'),(54,1,1,38,'U.S. Holidays'),(55,1,1,39,'Normal Work Hours');
/*!40000 ALTER TABLE `nagios_timeperiods` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-09-08 17:43:21
