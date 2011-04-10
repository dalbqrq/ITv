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
  KEY `fk_id6` (`app_id`),
  CONSTRAINT `fk_id6` FOREIGN KEY (`app_id`) REFERENCES `itvision_apps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  KEY `fk_instance_id11` (`instance_id`),
  CONSTRAINT `fk_app_id6` FOREIGN KEY (`app_id`) REFERENCES `itvision_apps` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_object_id3` FOREIGN KEY (`service_object_id`) REFERENCES `nagios_objects` (`object_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_app_relat_types`
--

DROP TABLE IF EXISTS `itvision_app_relat_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_relat_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET latin1 NOT NULL,
  `type` enum('physical','logical') CHARACTER SET latin1 DEFAULT 'logical',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
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
  KEY `fk_object_id8` (`to_object_id`),
  CONSTRAINT `fk_id1` FOREIGN KEY (`app_relat_type_id`) REFERENCES `itvision_app_relat_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_id2` FOREIGN KEY (`app_id`) REFERENCES `itvision_apps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  PRIMARY KEY (`id`),
  KEY `fk_app_id5` (`app_id`),
  KEY `fk_instance_id16` (`instance_id`),
  CONSTRAINT `fk_app_id5` FOREIGN KEY (`app_id`) REFERENCES `itvision_apps` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_app_type`
--

DROP TABLE IF EXISTS `itvision_app_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_app_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
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
  `name` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `type` enum('and','or') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'and',
  `is_active` tinyint(4) NOT NULL DEFAULT '0',
  `visibility` int(1) NOT NULL DEFAULT '0',
  `service_object_id` int(11) DEFAULT NULL,
  `notes` longtext COLLATE utf8_unicode_ci,
  `app_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_instance_id10` (`instance_id`),
  KEY `fk_object_id6` (`service_object_id`),
  CONSTRAINT `fk_instance_id20` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_instance_id27` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_object_id26` FOREIGN KEY (`service_object_id`) REFERENCES `nagios_objects` (`object_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_checkcmd_default_params`
--

DROP TABLE IF EXISTS `itvision_checkcmd_default_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_checkcmd_default_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `checkcmds_id` int(11) NOT NULL,
  `sequence` int(11) DEFAULT NULL,
  `flag` varchar(20) DEFAULT NULL,
  `variable` varchar(25) NOT NULL,
  `default_value` varchar(45) DEFAULT NULL,
  `description` varchar(245) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_checkcmd_params`
--

DROP TABLE IF EXISTS `itvision_checkcmd_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_checkcmd_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_object_id` int(11) NOT NULL,
  `name1` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name2` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `checkcmds_id` int(11) NOT NULL,
  `sequence` int(11) DEFAULT NULL,
  `value` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_checkcmds`
--

DROP TABLE IF EXISTS `itvision_checkcmds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_checkcmds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cmd_object_id` int(11) NOT NULL,
  `command` varchar(65) NOT NULL,
  `label` varchar(65) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_monitors`
--

DROP TABLE IF EXISTS `itvision_monitors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_monitors` (
  `instance_id` smallint(6) NOT NULL,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `service_object_id` int(11) NOT NULL,
  `networkports_id` int(11) NOT NULL,
  `softwareversions_id` int(11) DEFAULT NULL,
  `name` varchar(40) DEFAULT NULL,
  `name1` varchar(40) DEFAULT NULL,
  `name2` varchar(40) DEFAULT NULL,
  `state` tinyint(4) NOT NULL DEFAULT '0',
  `type` enum('hst','svc') CHARACTER SET latin1 NOT NULL DEFAULT 'hst'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_site_trees`
--

DROP TABLE IF EXISTS `itvision_site_trees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_site_trees` (
  `site_tree_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `lft` int(11) NOT NULL,
  `rgt` int(11) NOT NULL,
  `location_tree_id` int(11) NOT NULL,
  `service_object_id` int(11) NOT NULL,
  PRIMARY KEY (`site_tree_id`,`instance_id`),
  KEY `fk_instance_id1` (`instance_id`),
  KEY `fk_object_id1` (`service_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tree to organize ITvision instances';
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `version` varchar(45) CHARACTER SET latin1 NOT NULL,
  `home_dir` varchar(45) CHARACTER SET latin1 NOT NULL,
  `monitor_dir` varchar(45) CHARACTER SET latin1 NOT NULL,
  `monitor_bp_dir` varchar(45) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`,`instance_id`),
  KEY `fk_instance_id7` (`instance_id`),
  CONSTRAINT `fk_instance_id7` FOREIGN KEY (`instance_id`) REFERENCES `nagios_instances` (`instance_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ITvision system configuration';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_user`
--

DROP TABLE IF EXISTS `itvision_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_id` smallint(6) NOT NULL,
  `login` varchar(45) CHARACTER SET latin1 NOT NULL,
  `password` varchar(45) CHARACTER SET latin1 NOT NULL,
  `user_group_id` int(11) NOT NULL,
  `user_prefs_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`user_group_id`,`user_prefs_id`,`instance_id`),
  KEY `fk_user_group_id1` (`user_group_id`),
  KEY `fk_user_prefs_id1` (`user_prefs_id`,`instance_id`),
  CONSTRAINT `fk_user_group_id1` FOREIGN KEY (`user_group_id`) REFERENCES `itvision_user_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_prefs_id1` FOREIGN KEY (`user_prefs_id`) REFERENCES `itvision_user_prefs` (`user_prefs_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itvision_user_groups`
--

DROP TABLE IF EXISTS `itvision_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itvision_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET latin1 NOT NULL,
  `root_app` int(11) DEFAULT NULL,
  `instance_id` smallint(6) NOT NULL,
  PRIMARY KEY (`id`,`instance_id`),
  KEY `fk_instance_id6` (`instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-04-09  4:52:06
