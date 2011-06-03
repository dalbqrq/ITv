-- SOMENTE APPS

-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: itvision
-- ------------------------------------------------------
-- Server version	5.1.41-3ubuntu12.7

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
-- Table structure for table `itvision_app_contacts`
--

DROP TABLE IF EXISTS `itvision_app_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_contacts` (
  `instance_id` smallint(6) NOT NULL,
  `app_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  KEY `fk_id6` (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_app_objects`
--

DROP TABLE IF EXISTS `itvision_app_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_objects` (
  `app_id` int(11) NOT NULL,
  `instance_id` smallint(6) NOT NULL,
  `service_object_id` int(11) NOT NULL,
  `type` enum('app','hst','svc') CHARACTER SET latin1 NOT NULL,
  KEY `fk_app_id4` (`app_id`),
  KEY `fk_object_id3` (`service_object_id`),
  KEY `fk_instance_id11` (`instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_app_relats`
--

DROP TABLE IF EXISTS `itvision_app_relats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_relats` (
  `instance_id` smallint(6) NOT NULL,
  `app_relat_type_id` int(11) NOT NULL,
  `app_id` int(11) NOT NULL,
  `from_object_id` int(11) NOT NULL,
  `to_object_id` int(11) NOT NULL,
  KEY `fk_id1` (`app_relat_type_id`),
  KEY `fk_id2` (`app_id`),
  KEY `fk_instance_id12` (`instance_id`),
  KEY `fk_object_id7` (`from_object_id`),
  KEY `fk_object_id8` (`to_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_app_trees`
--

DROP TABLE IF EXISTS `itvision_app_trees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_trees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `entity_id` int(11) DEFAULT '0',
  `app_id` int(11) NOT NULL,
  `lft` int(11) NOT NULL,
  `rgt` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_apps`
--

DROP TABLE IF EXISTS `itvision_apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_entity_root` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(45) COLLATE latin1_general_ci  NOT NULL,
  `type` enum('and','or') COLLATE latin1_general_ci  NOT NULL DEFAULT 'and',
  `is_active` tinyint(4) NOT NULL DEFAULT '0',
  `visibility` int(1) NOT NULL DEFAULT '0',
  `service_object_id` int(11) DEFAULT NULL,
  `notes` longtext COLLATE latin1_general_ci ,
  `app_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


INSERT INTO itvision_apps 
SET    instance_id = 1, entities_id = 0, is_entity_root = 1, name = 'ROOT';

INSERT INTO itvision_app_trees 
SET    instance_id = 1, app_id = (select id from itvision_apps where name = 'ROOT' and is_active = 0), lft = 1, rgt = 2;


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;



