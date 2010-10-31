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
-- Table structure for table `itvision_app`
--

DROP TABLE IF EXISTS `itvision_app`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `name` varchar(45) NOT NULL,
  `type` enum('and','or') NOT NULL DEFAULT 'and',
  `is_active` enum('0','1') NOT NULL DEFAULT '0',
  `service_object_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_instance_id10` (`instance_id`),
  KEY `fk_object_id6` (`service_object_id`),
  CONSTRAINT `fk_instance_id10` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_instance_id17` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_object_id6` FOREIGN KEY (`service_object_id`) REFERENCES `nagios_objects` (`object_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_app`
--

LOCK TABLES `itvision_app` WRITE;
/*!40000 ALTER TABLE `itvision_app` DISABLE KEYS */;
INSERT INTO `itvision_app` VALUES (23,1,'ITvision','and','0',NULL),(24,1,'itiv_proto','and','0',NULL),(25,1,'TEST','or','1',NULL);
/*!40000 ALTER TABLE `itvision_app` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_app_object`
--

DROP TABLE IF EXISTS `itvision_app_object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_object` (
  `app_id` int(11) NOT NULL,
  `instance_id` smallint(6) NOT NULL,
  `object_id` int(11) NOT NULL,
  `type` enum('app','hst','svc') NOT NULL,
  KEY `fk_app_id4` (`app_id`),
  KEY `fk_object_id3` (`object_id`),
  KEY `fk_instance_id11` (`instance_id`),
  CONSTRAINT `fk_app_id6` FOREIGN KEY (`app_id`) REFERENCES `itvision_app` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_instance_id11` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_object_id3` FOREIGN KEY (`object_id`) REFERENCES `nagios_objects` (`object_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_app_object`
--

LOCK TABLES `itvision_app_object` WRITE;
/*!40000 ALTER TABLE `itvision_app_object` DISABLE KEYS */;
INSERT INTO `itvision_app_object` VALUES (23,1,5,'svc'),(23,1,6,'svc'),(24,1,55,'app'),(23,1,8,'svc'),(23,1,1,'hst'),(25,1,86,'hst'),(25,1,87,'svc');
/*!40000 ALTER TABLE `itvision_app_object` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_app_relat`
--

DROP TABLE IF EXISTS `itvision_app_relat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_relat` (
  `instance_id` smallint(6) NOT NULL,
  `app_relat_type_id` int(11) NOT NULL,
  `app_id` int(11) NOT NULL,
  `from_object_id` int(11) NOT NULL,
  `to_object_id` int(11) NOT NULL,
  KEY `fk_id1` (`app_relat_type_id`),
  KEY `fk_id2` (`app_id`),
  KEY `fk_instance_id12` (`instance_id`),
  KEY `fk_object_id7` (`from_object_id`),
  KEY `fk_object_id8` (`to_object_id`),
  CONSTRAINT `fk_id1` FOREIGN KEY (`app_relat_type_id`) REFERENCES `itvision_app_relat_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_id2` FOREIGN KEY (`app_id`) REFERENCES `itvision_app` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_instance_id12` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_object_id7` FOREIGN KEY (`from_object_id`) REFERENCES `nagios_objects` (`object_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_object_id8` FOREIGN KEY (`to_object_id`) REFERENCES `nagios_objects` (`object_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_app_relat`
--

LOCK TABLES `itvision_app_relat` WRITE;
/*!40000 ALTER TABLE `itvision_app_relat` DISABLE KEYS */;
INSERT INTO `itvision_app_relat` VALUES (1,12,23,5,1),(1,12,23,6,1),(1,12,23,8,1);
/*!40000 ALTER TABLE `itvision_app_relat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_app_relat_type`
--

DROP TABLE IF EXISTS `itvision_app_relat_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_relat_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `type` enum('physical','logical') DEFAULT 'logical',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_app_relat_type`
--

LOCK TABLES `itvision_app_relat_type` WRITE;
/*!40000 ALTER TABLE `itvision_app_relat_type` DISABLE KEYS */;
INSERT INTO `itvision_app_relat_type` VALUES (12,'roda em','physical'),(13,'conectado a','physical'),(14,'usa','logical'),(15,'faz backup em','logical');
/*!40000 ALTER TABLE `itvision_app_relat_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_app_tree`
--

DROP TABLE IF EXISTS `itvision_app_tree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_tree` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `app_id` int(11) NOT NULL,
  `lft` int(11) NOT NULL,
  `rgt` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_app_id5` (`app_id`),
  KEY `fk_instance_id16` (`instance_id`),
  CONSTRAINT `fk_app_id5` FOREIGN KEY (`app_id`) REFERENCES `itvision_app` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_instance_id16` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_app_tree`
--

LOCK TABLES `itvision_app_tree` WRITE;
/*!40000 ALTER TABLE `itvision_app_tree` DISABLE KEYS */;
INSERT INTO `itvision_app_tree` VALUES (3,1,24,1,4),(4,1,23,2,3);
/*!40000 ALTER TABLE `itvision_app_tree` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_monitor`
--

DROP TABLE IF EXISTS `itvision_monitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_monitor` (
  `networkports_id` int(11) NOT NULL,
  `softwareversions_id` int(11) DEFAULT NULL,
  `host_object_id` int(11) NOT NULL,
  `service_object_id` int(11) NOT NULL,
  `is_active` enum('0','1') NOT NULL DEFAULT '0',
  `type` enum('hst','svc') NOT NULL DEFAULT 'hst'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_monitor`
--

LOCK TABLES `itvision_monitor` WRITE;
/*!40000 ALTER TABLE `itvision_monitor` DISABLE KEYS */;
INSERT INTO `itvision_monitor` VALUES (6,NULL,86,87,'1','hst'),(7,NULL,80,81,'1','hst'),(7,2,80,92,'1','svc');
/*!40000 ALTER TABLE `itvision_monitor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itvision_site_tree`
--

DROP TABLE IF EXISTS `itvision_site_tree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_site_tree` (
  `site_tree_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `lft` int(11) NOT NULL,
  `rgt` int(11) NOT NULL,
  `location_tree_id` int(11) NOT NULL,
  `service_object_id` int(11) NOT NULL,
  PRIMARY KEY (`site_tree_id`,`instance_id`),
  KEY `fk_instance_id1` (`instance_id`),
  KEY `fk_object_id1` (`service_object_id`),
  CONSTRAINT `fk_instance_id1` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  `version` varchar(45) NOT NULL,
  `home_dir` varchar(45) NOT NULL,
  `monitor_dir` varchar(45) NOT NULL,
  `monitor_bp_dir` varchar(45) NOT NULL,
  PRIMARY KEY (`id`,`instance_id`),
  KEY `fk_instance_id7` (`instance_id`),
  CONSTRAINT `fk_instance_id7` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18446744073709551615 DEFAULT CHARSET=latin1 COMMENT='ITvision system configuration';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itvision_sysconfig`
--

LOCK TABLES `itvision_sysconfig` WRITE;
/*!40000 ALTER TABLE `itvision_sysconfig` DISABLE KEYS */;
INSERT INTO `itvision_sysconfig` VALUES (1,1,'0000-00-00 00:00:00','0000-00-00 00:00:00','0.9','/usr/local/itvision','/usr/local/monitor','/usr/local/monitorbp');
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-10-31 16:20:19
