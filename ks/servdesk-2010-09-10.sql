-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: servdesk
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
-- Table structure for table `glpi_alerts`
--

DROP TABLE IF EXISTS `glpi_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `items_id` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT 'see define.php ALERT_* constant',
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`itemtype`,`items_id`,`type`),
  KEY `type` (`type`),
  KEY `date` (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_alerts`
--

LOCK TABLES `glpi_alerts` WRITE;
/*!40000 ALTER TABLE `glpi_alerts` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_authldapreplicates`
--

DROP TABLE IF EXISTS `glpi_authldapreplicates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_authldapreplicates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authldaps_id` int(11) NOT NULL DEFAULT '0',
  `host` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `port` int(11) NOT NULL DEFAULT '389',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `authldaps_id` (`authldaps_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_authldapreplicates`
--

LOCK TABLES `glpi_authldapreplicates` WRITE;
/*!40000 ALTER TABLE `glpi_authldapreplicates` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_authldapreplicates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_authldaps`
--

DROP TABLE IF EXISTS `glpi_authldaps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_authldaps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `host` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `basedn` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rootdn` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rootdn_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `port` int(11) NOT NULL DEFAULT '389',
  `condition` text COLLATE utf8_unicode_ci,
  `login_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'uid',
  `use_tls` tinyint(1) NOT NULL DEFAULT '0',
  `group_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `group_condition` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `group_search_type` int(11) NOT NULL DEFAULT '0',
  `group_member_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `realname_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `firstname_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone2_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mobile_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `use_dn` tinyint(1) NOT NULL DEFAULT '1',
  `time_offset` int(11) NOT NULL DEFAULT '0' COMMENT 'in seconds',
  `deref_option` int(11) NOT NULL DEFAULT '0',
  `title_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `language_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity_condition` text COLLATE utf8_unicode_ci,
  `date_mod` datetime DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `date_mod` (`date_mod`),
  KEY `is_default` (`is_default`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_authldaps`
--

LOCK TABLES `glpi_authldaps` WRITE;
/*!40000 ALTER TABLE `glpi_authldaps` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_authldaps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_authmails`
--

DROP TABLE IF EXISTS `glpi_authmails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_authmails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `connect_string` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `host` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_authmails`
--

LOCK TABLES `glpi_authmails` WRITE;
/*!40000 ALTER TABLE `glpi_authmails` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_authmails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_autoupdatesystems`
--

DROP TABLE IF EXISTS `glpi_autoupdatesystems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_autoupdatesystems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_autoupdatesystems`
--

LOCK TABLES `glpi_autoupdatesystems` WRITE;
/*!40000 ALTER TABLE `glpi_autoupdatesystems` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_autoupdatesystems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_bookmarks`
--

DROP TABLE IF EXISTS `glpi_bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_bookmarks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT '0' COMMENT 'see define.php BOOKMARK_* constant',
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `is_private` tinyint(1) NOT NULL DEFAULT '1',
  `entities_id` int(11) NOT NULL DEFAULT '-1',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `query` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `type` (`type`),
  KEY `itemtype` (`itemtype`),
  KEY `entities_id` (`entities_id`),
  KEY `users_id` (`users_id`),
  KEY `is_private` (`is_private`),
  KEY `is_recursive` (`is_recursive`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_bookmarks`
--

LOCK TABLES `glpi_bookmarks` WRITE;
/*!40000 ALTER TABLE `glpi_bookmarks` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_bookmarks_users`
--

DROP TABLE IF EXISTS `glpi_bookmarks_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_bookmarks_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `bookmarks_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`users_id`,`itemtype`),
  KEY `bookmarks_id` (`bookmarks_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_bookmarks_users`
--

LOCK TABLES `glpi_bookmarks_users` WRITE;
/*!40000 ALTER TABLE `glpi_bookmarks_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_bookmarks_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_budgets`
--

DROP TABLE IF EXISTS `glpi_budgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_budgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `begin_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `value` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `is_template` tinyint(1) NOT NULL DEFAULT '0',
  `template_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `notepad` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `is_recursive` (`is_recursive`),
  KEY `entities_id` (`entities_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `begin_date` (`begin_date`),
  KEY `end_date` (`begin_date`),
  KEY `is_template` (`is_template`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_budgets`
--

LOCK TABLES `glpi_budgets` WRITE;
/*!40000 ALTER TABLE `glpi_budgets` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_budgets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_cartridgeitems`
--

DROP TABLE IF EXISTS `glpi_cartridgeitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_cartridgeitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ref` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locations_id` int(11) NOT NULL DEFAULT '0',
  `cartridgeitemtypes_id` int(11) NOT NULL DEFAULT '0',
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `users_id_tech` int(11) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `alarm_threshold` int(11) NOT NULL DEFAULT '10',
  `notepad` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `entities_id` (`entities_id`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `locations_id` (`locations_id`),
  KEY `users_id_tech` (`users_id_tech`),
  KEY `cartridgeitemtypes_id` (`cartridgeitemtypes_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `alarm_threshold` (`alarm_threshold`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_cartridgeitems`
--

LOCK TABLES `glpi_cartridgeitems` WRITE;
/*!40000 ALTER TABLE `glpi_cartridgeitems` DISABLE KEYS */;
INSERT INTO `glpi_cartridgeitems` VALUES (1,0,'HP inkjet 2100','',1,0,6,4,0,'',10,NULL);
/*!40000 ALTER TABLE `glpi_cartridgeitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_cartridgeitemtypes`
--

DROP TABLE IF EXISTS `glpi_cartridgeitemtypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_cartridgeitemtypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_cartridgeitemtypes`
--

LOCK TABLES `glpi_cartridgeitemtypes` WRITE;
/*!40000 ALTER TABLE `glpi_cartridgeitemtypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_cartridgeitemtypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_cartridges`
--

DROP TABLE IF EXISTS `glpi_cartridges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_cartridges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `cartridgeitems_id` int(11) NOT NULL DEFAULT '0',
  `printers_id` int(11) NOT NULL DEFAULT '0',
  `date_in` date DEFAULT NULL,
  `date_use` date DEFAULT NULL,
  `date_out` date DEFAULT NULL,
  `pages` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cartridgeitems_id` (`cartridgeitems_id`),
  KEY `printers_id` (`printers_id`),
  KEY `entities_id` (`entities_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_cartridges`
--

LOCK TABLES `glpi_cartridges` WRITE;
/*!40000 ALTER TABLE `glpi_cartridges` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_cartridges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_cartridges_printermodels`
--

DROP TABLE IF EXISTS `glpi_cartridges_printermodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_cartridges_printermodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cartridgeitems_id` int(11) NOT NULL DEFAULT '0',
  `printermodels_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`printermodels_id`,`cartridgeitems_id`),
  KEY `cartridgeitems_id` (`cartridgeitems_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_cartridges_printermodels`
--

LOCK TABLES `glpi_cartridges_printermodels` WRITE;
/*!40000 ALTER TABLE `glpi_cartridges_printermodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_cartridges_printermodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computerdisks`
--

DROP TABLE IF EXISTS `glpi_computerdisks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computerdisks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `device` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mountpoint` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filesystems_id` int(11) NOT NULL DEFAULT '0',
  `totalsize` int(11) NOT NULL DEFAULT '0',
  `freesize` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `device` (`device`),
  KEY `mountpoint` (`mountpoint`),
  KEY `totalsize` (`totalsize`),
  KEY `freesize` (`freesize`),
  KEY `computers_id` (`computers_id`),
  KEY `filesystems_id` (`filesystems_id`),
  KEY `entities_id` (`entities_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computerdisks`
--

LOCK TABLES `glpi_computerdisks` WRITE;
/*!40000 ALTER TABLE `glpi_computerdisks` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computerdisks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computermodels`
--

DROP TABLE IF EXISTS `glpi_computermodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computermodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computermodels`
--

LOCK TABLES `glpi_computermodels` WRITE;
/*!40000 ALTER TABLE `glpi_computermodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computermodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers`
--

DROP TABLE IF EXISTS `glpi_computers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `serial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `otherserial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact_num` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `users_id_tech` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `date_mod` datetime DEFAULT NULL,
  `operatingsystems_id` int(11) NOT NULL DEFAULT '0',
  `operatingsystemversions_id` int(11) NOT NULL DEFAULT '0',
  `operatingsystemservicepacks_id` int(11) NOT NULL DEFAULT '0',
  `os_license_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `os_licenseid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `autoupdatesystems_id` int(11) NOT NULL DEFAULT '0',
  `locations_id` int(11) NOT NULL DEFAULT '0',
  `domains_id` int(11) NOT NULL DEFAULT '0',
  `networks_id` int(11) NOT NULL DEFAULT '0',
  `computermodels_id` int(11) NOT NULL DEFAULT '0',
  `computertypes_id` int(11) NOT NULL DEFAULT '0',
  `is_template` tinyint(1) NOT NULL DEFAULT '0',
  `template_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `notepad` longtext COLLATE utf8_unicode_ci,
  `is_ocs_import` tinyint(1) NOT NULL DEFAULT '0',
  `users_id` int(11) NOT NULL DEFAULT '0',
  `groups_id` int(11) NOT NULL DEFAULT '0',
  `states_id` int(11) NOT NULL DEFAULT '0',
  `ticket_tco` decimal(20,4) DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  KEY `date_mod` (`date_mod`),
  KEY `name` (`name`),
  KEY `is_template` (`is_template`),
  KEY `autoupdatesystems_id` (`autoupdatesystems_id`),
  KEY `domains_id` (`domains_id`),
  KEY `entities_id` (`entities_id`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `groups_id` (`groups_id`),
  KEY `users_id` (`users_id`),
  KEY `locations_id` (`locations_id`),
  KEY `computermodels_id` (`computermodels_id`),
  KEY `networks_id` (`networks_id`),
  KEY `operatingsystems_id` (`operatingsystems_id`),
  KEY `operatingsystemservicepacks_id` (`operatingsystemservicepacks_id`),
  KEY `operatingsystemversions_id` (`operatingsystemversions_id`),
  KEY `states_id` (`states_id`),
  KEY `users_id_tech` (`users_id_tech`),
  KEY `computertypes_id` (`computertypes_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_ocs_import` (`is_ocs_import`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers`
--

LOCK TABLES `glpi_computers` WRITE;
/*!40000 ALTER TABLE `glpi_computers` DISABLE KEYS */;
INSERT INTO `glpi_computers` VALUES (1,0,'QIN','123123','000001','','',4,'','2010-08-26 00:51:37',1,0,0,'','',0,2,0,0,0,2,0,NULL,2,0,NULL,0,0,0,1,'0.0000'),(2,0,'METZLER','321321','000002','usuario alternativo','Num de usuario alternativo',2,'','2010-08-27 02:43:11',2,0,0,'','',0,2,0,0,0,2,0,NULL,1,0,NULL,0,4,0,1,'0.0000');
/*!40000 ALTER TABLE `glpi_computers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_devicecases`
--

DROP TABLE IF EXISTS `glpi_computers_devicecases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_devicecases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `devicecases_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `devicecases_id` (`devicecases_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_devicecases`
--

LOCK TABLES `glpi_computers_devicecases` WRITE;
/*!40000 ALTER TABLE `glpi_computers_devicecases` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_devicecases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_devicecontrols`
--

DROP TABLE IF EXISTS `glpi_computers_devicecontrols`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_devicecontrols` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `devicecontrols_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `devicecontrols_id` (`devicecontrols_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_devicecontrols`
--

LOCK TABLES `glpi_computers_devicecontrols` WRITE;
/*!40000 ALTER TABLE `glpi_computers_devicecontrols` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_devicecontrols` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_devicedrives`
--

DROP TABLE IF EXISTS `glpi_computers_devicedrives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_devicedrives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `devicedrives_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `devicedrives_id` (`devicedrives_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_devicedrives`
--

LOCK TABLES `glpi_computers_devicedrives` WRITE;
/*!40000 ALTER TABLE `glpi_computers_devicedrives` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_devicedrives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_devicegraphiccards`
--

DROP TABLE IF EXISTS `glpi_computers_devicegraphiccards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_devicegraphiccards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `devicegraphiccards_id` int(11) NOT NULL DEFAULT '0',
  `specificity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `devicegraphiccards_id` (`devicegraphiccards_id`),
  KEY `specificity` (`specificity`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_devicegraphiccards`
--

LOCK TABLES `glpi_computers_devicegraphiccards` WRITE;
/*!40000 ALTER TABLE `glpi_computers_devicegraphiccards` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_devicegraphiccards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_deviceharddrives`
--

DROP TABLE IF EXISTS `glpi_computers_deviceharddrives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_deviceharddrives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `deviceharddrives_id` int(11) NOT NULL DEFAULT '0',
  `specificity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `deviceharddrives_id` (`deviceharddrives_id`),
  KEY `specificity` (`specificity`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_deviceharddrives`
--

LOCK TABLES `glpi_computers_deviceharddrives` WRITE;
/*!40000 ALTER TABLE `glpi_computers_deviceharddrives` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_deviceharddrives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_devicememories`
--

DROP TABLE IF EXISTS `glpi_computers_devicememories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_devicememories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `devicememories_id` int(11) NOT NULL DEFAULT '0',
  `specificity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `devicememories_id` (`devicememories_id`),
  KEY `specificity` (`specificity`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_devicememories`
--

LOCK TABLES `glpi_computers_devicememories` WRITE;
/*!40000 ALTER TABLE `glpi_computers_devicememories` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_devicememories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_devicemotherboards`
--

DROP TABLE IF EXISTS `glpi_computers_devicemotherboards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_devicemotherboards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `devicemotherboards_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `devicemotherboards_id` (`devicemotherboards_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_devicemotherboards`
--

LOCK TABLES `glpi_computers_devicemotherboards` WRITE;
/*!40000 ALTER TABLE `glpi_computers_devicemotherboards` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_devicemotherboards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_devicenetworkcards`
--

DROP TABLE IF EXISTS `glpi_computers_devicenetworkcards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_devicenetworkcards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `devicenetworkcards_id` int(11) NOT NULL DEFAULT '0',
  `specificity` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `devicenetworkcards_id` (`devicenetworkcards_id`),
  KEY `specificity` (`specificity`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_devicenetworkcards`
--

LOCK TABLES `glpi_computers_devicenetworkcards` WRITE;
/*!40000 ALTER TABLE `glpi_computers_devicenetworkcards` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_devicenetworkcards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_devicepcis`
--

DROP TABLE IF EXISTS `glpi_computers_devicepcis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_devicepcis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `devicepcis_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `devicepcis_id` (`devicepcis_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_devicepcis`
--

LOCK TABLES `glpi_computers_devicepcis` WRITE;
/*!40000 ALTER TABLE `glpi_computers_devicepcis` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_devicepcis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_devicepowersupplies`
--

DROP TABLE IF EXISTS `glpi_computers_devicepowersupplies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_devicepowersupplies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `devicepowersupplies_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `devicepowersupplies_id` (`devicepowersupplies_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_devicepowersupplies`
--

LOCK TABLES `glpi_computers_devicepowersupplies` WRITE;
/*!40000 ALTER TABLE `glpi_computers_devicepowersupplies` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_devicepowersupplies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_deviceprocessors`
--

DROP TABLE IF EXISTS `glpi_computers_deviceprocessors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_deviceprocessors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `deviceprocessors_id` int(11) NOT NULL DEFAULT '0',
  `specificity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `deviceprocessors_id` (`deviceprocessors_id`),
  KEY `specificity` (`specificity`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_deviceprocessors`
--

LOCK TABLES `glpi_computers_deviceprocessors` WRITE;
/*!40000 ALTER TABLE `glpi_computers_deviceprocessors` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_deviceprocessors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_devicesoundcards`
--

DROP TABLE IF EXISTS `glpi_computers_devicesoundcards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_devicesoundcards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `devicesoundcards_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `devicesoundcards_id` (`devicesoundcards_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_devicesoundcards`
--

LOCK TABLES `glpi_computers_devicesoundcards` WRITE;
/*!40000 ALTER TABLE `glpi_computers_devicesoundcards` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_devicesoundcards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_items`
--

DROP TABLE IF EXISTS `glpi_computers_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `items_id` int(11) NOT NULL DEFAULT '0' COMMENT 'RELATION to various table, according to itemtype (ID)',
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`itemtype`,`items_id`,`computers_id`),
  KEY `computers_id` (`computers_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_items`
--

LOCK TABLES `glpi_computers_items` WRITE;
/*!40000 ALTER TABLE `glpi_computers_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_computers_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computers_softwareversions`
--

DROP TABLE IF EXISTS `glpi_computers_softwareversions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computers_softwareversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `softwareversions_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`),
  KEY `softwareversions_id` (`softwareversions_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computers_softwareversions`
--

LOCK TABLES `glpi_computers_softwareversions` WRITE;
/*!40000 ALTER TABLE `glpi_computers_softwareversions` DISABLE KEYS */;
INSERT INTO `glpi_computers_softwareversions` VALUES (1,2,1);
/*!40000 ALTER TABLE `glpi_computers_softwareversions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_computertypes`
--

DROP TABLE IF EXISTS `glpi_computertypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_computertypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_computertypes`
--

LOCK TABLES `glpi_computertypes` WRITE;
/*!40000 ALTER TABLE `glpi_computertypes` DISABLE KEYS */;
INSERT INTO `glpi_computertypes` VALUES (1,'Servidor',''),(2,'Desktop',''),(3,'Notebook','');
/*!40000 ALTER TABLE `glpi_computertypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_configs`
--

DROP TABLE IF EXISTS `glpi_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_configs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `show_jobs_at_login` tinyint(1) NOT NULL DEFAULT '0',
  `cut` int(11) NOT NULL DEFAULT '255',
  `list_limit` int(11) NOT NULL DEFAULT '20',
  `list_limit_max` int(11) NOT NULL DEFAULT '50',
  `version` char(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `event_loglevel` int(11) NOT NULL DEFAULT '5',
  `use_mailing` tinyint(1) NOT NULL DEFAULT '0',
  `admin_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `admin_reply` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mailing_signature` text COLLATE utf8_unicode_ci,
  `use_anonymous_helpdesk` tinyint(1) NOT NULL DEFAULT '0',
  `language` char(10) COLLATE utf8_unicode_ci DEFAULT 'en_GB' COMMENT 'see define.php CFG_GLPI[language] array',
  `priority_1` char(20) COLLATE utf8_unicode_ci DEFAULT '#fff2f2',
  `priority_2` char(20) COLLATE utf8_unicode_ci DEFAULT '#ffe0e0',
  `priority_3` char(20) COLLATE utf8_unicode_ci DEFAULT '#ffcece',
  `priority_4` char(20) COLLATE utf8_unicode_ci DEFAULT '#ffbfbf',
  `priority_5` char(20) COLLATE utf8_unicode_ci DEFAULT '#ffadad',
  `priority_6` char(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '#ff5555',
  `date_tax` date NOT NULL DEFAULT '2005-12-31',
  `default_alarm_threshold` int(11) NOT NULL DEFAULT '10',
  `cas_host` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cas_port` int(11) NOT NULL DEFAULT '443',
  `cas_uri` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cas_logout` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authldaps_id_extra` int(11) NOT NULL DEFAULT '0' COMMENT 'extra server',
  `existing_auth_server_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `existing_auth_server_field_clean_domain` tinyint(1) NOT NULL DEFAULT '0',
  `planning_begin` time NOT NULL DEFAULT '08:00:00',
  `planning_end` time NOT NULL DEFAULT '20:00:00',
  `utf8_conv` int(11) NOT NULL DEFAULT '0',
  `use_auto_assign_to_tech` tinyint(1) NOT NULL DEFAULT '0',
  `use_public_faq` tinyint(1) NOT NULL DEFAULT '0',
  `url_base` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `show_link_in_mail` tinyint(1) NOT NULL DEFAULT '0',
  `text_login` text COLLATE utf8_unicode_ci,
  `founded_new_version` char(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dropdown_max` int(11) NOT NULL DEFAULT '100',
  `ajax_wildcard` char(1) COLLATE utf8_unicode_ci DEFAULT '*',
  `use_ajax` tinyint(1) NOT NULL DEFAULT '0',
  `ajax_limit_count` int(11) NOT NULL DEFAULT '50',
  `use_ajax_autocompletion` tinyint(1) NOT NULL DEFAULT '1',
  `is_users_auto_add` tinyint(1) NOT NULL DEFAULT '1',
  `date_format` int(11) NOT NULL DEFAULT '0',
  `number_format` int(11) NOT NULL DEFAULT '0',
  `is_ids_visible` tinyint(1) NOT NULL DEFAULT '0',
  `dropdown_chars_limit` int(11) NOT NULL DEFAULT '50',
  `use_ocs_mode` tinyint(1) NOT NULL DEFAULT '0',
  `smtp_mode` int(11) NOT NULL DEFAULT '0' COMMENT 'see define.php MAIL_* constant',
  `smtp_host` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `smtp_port` int(11) NOT NULL DEFAULT '25',
  `smtp_username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `smtp_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `proxy_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `proxy_port` int(11) NOT NULL DEFAULT '8080',
  `proxy_user` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `proxy_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `add_followup_on_update_ticket` tinyint(1) NOT NULL DEFAULT '1',
  `default_contract_alert` int(11) NOT NULL DEFAULT '0',
  `default_infocom_alert` int(11) NOT NULL DEFAULT '0',
  `use_licenses_alert` tinyint(1) NOT NULL DEFAULT '0',
  `cartridges_alert_repeat` int(11) NOT NULL DEFAULT '0' COMMENT 'in seconds',
  `consumables_alert_repeat` int(11) NOT NULL DEFAULT '0' COMMENT 'in seconds',
  `keep_tickets_on_delete` tinyint(1) NOT NULL DEFAULT '1',
  `time_step` int(11) DEFAULT '5',
  `decimal_number` int(11) DEFAULT '2',
  `helpdesk_doc_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `central_doc_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `documentcategories_id_forticket` int(11) NOT NULL DEFAULT '0' COMMENT 'default category for documents added with a ticket',
  `monitors_management_restrict` int(11) NOT NULL DEFAULT '2',
  `phones_management_restrict` int(11) NOT NULL DEFAULT '2',
  `peripherals_management_restrict` int(11) NOT NULL DEFAULT '2',
  `printers_management_restrict` int(11) NOT NULL DEFAULT '2',
  `use_log_in_files` tinyint(1) NOT NULL DEFAULT '0',
  `time_offset` int(11) NOT NULL DEFAULT '0' COMMENT 'in seconds',
  `is_contact_autoupdate` tinyint(1) NOT NULL DEFAULT '1',
  `is_user_autoupdate` tinyint(1) NOT NULL DEFAULT '1',
  `is_group_autoupdate` tinyint(1) NOT NULL DEFAULT '1',
  `is_location_autoupdate` tinyint(1) NOT NULL DEFAULT '1',
  `state_autoupdate_mode` int(11) NOT NULL DEFAULT '0',
  `is_contact_autoclean` tinyint(1) NOT NULL DEFAULT '0',
  `is_user_autoclean` tinyint(1) NOT NULL DEFAULT '0',
  `is_group_autoclean` tinyint(1) NOT NULL DEFAULT '0',
  `is_location_autoclean` tinyint(1) NOT NULL DEFAULT '0',
  `state_autoclean_mode` int(11) NOT NULL DEFAULT '0',
  `use_flat_dropdowntree` tinyint(1) NOT NULL DEFAULT '0',
  `use_autoname_by_entity` tinyint(1) NOT NULL DEFAULT '1',
  `is_categorized_soft_expanded` tinyint(1) NOT NULL DEFAULT '1',
  `is_not_categorized_soft_expanded` tinyint(1) NOT NULL DEFAULT '1',
  `dbreplicate_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `softwarecategories_id_ondelete` int(11) NOT NULL DEFAULT '0' COMMENT 'category applyed when a software is deleted',
  `x509_email_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_ticket_title_mandatory` tinyint(1) NOT NULL DEFAULT '0',
  `is_ticket_content_mandatory` tinyint(1) NOT NULL DEFAULT '1',
  `is_ticket_category_mandatory` tinyint(1) NOT NULL DEFAULT '0',
  `default_mailcollector_filesize_max` int(11) NOT NULL DEFAULT '2097152',
  `followup_private` tinyint(1) NOT NULL DEFAULT '0',
  `task_private` tinyint(1) NOT NULL DEFAULT '0',
  `default_software_helpdesk_visible` tinyint(1) NOT NULL DEFAULT '1',
  `names_format` int(11) NOT NULL DEFAULT '0' COMMENT 'see *NAME_BEFORE constant in define.php',
  `default_graphtype` char(3) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'svg',
  `default_requesttypes_id` int(11) NOT NULL DEFAULT '1',
  `use_noright_users_add` tinyint(1) NOT NULL DEFAULT '1',
  `cron_limit` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Number of tasks execute by external cron',
  `priority_matrix` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'json encoded array for Urgence / Impact to Protority',
  `urgency_mask` int(11) NOT NULL DEFAULT '62',
  `impact_mask` int(11) NOT NULL DEFAULT '62',
  `use_infocoms_alert` tinyint(1) NOT NULL DEFAULT '0',
  `use_contracts_alert` tinyint(1) NOT NULL DEFAULT '0',
  `use_reservations_alert` tinyint(1) NOT NULL DEFAULT '0',
  `autoclose_delay` int(11) NOT NULL DEFAULT '0',
  `notclosed_delay` int(11) NOT NULL DEFAULT '0',
  `user_deleted_ldap` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_configs`
--

LOCK TABLES `glpi_configs` WRITE;
/*!40000 ALTER TABLE `glpi_configs` DISABLE KEYS */;
INSERT INTO `glpi_configs` VALUES (1,0,250,15,50,' 0.78',5,0,'admsys@xxxxx.fr',NULL,'SIGNATURE',0,'en_GB','#fff2f2','#ffe0e0','#ffcece','#ffbfbf','#ffadad','#ff5555','2005-12-31',10,'',443,'',NULL,1,NULL,0,'08:00:00','20:00:00',1,0,0,'http://itv/servdesk',0,'','',100,'*',0,50,1,1,0,0,0,50,0,0,NULL,25,NULL,NULL,NULL,8080,NULL,NULL,1,0,0,0,0,0,0,5,2,NULL,NULL,0,2,2,2,2,1,0,1,1,1,1,0,0,0,0,0,0,0,1,1,1,NULL,1,NULL,0,1,0,2097152,0,0,1,0,'svg',1,1,1,'{\"1\":{\"1\":1,\"2\":1,\"3\":2,\"4\":2,\"5\":2},\"2\":{\"1\":1,\"2\":2,\"3\":2,\"4\":3,\"5\":3},\"3\":{\"1\":2,\"2\":2,\"3\":3,\"4\":4,\"5\":4},\"4\":{\"1\":2,\"2\":3,\"3\":4,\"4\":4,\"5\":5},\"5\":{\"1\":2,\"2\":3,\"3\":4,\"4\":5,\"5\":5}}',62,62,0,0,0,0,0,0);
/*!40000 ALTER TABLE `glpi_configs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_consumableitems`
--

DROP TABLE IF EXISTS `glpi_consumableitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_consumableitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ref` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locations_id` int(11) NOT NULL DEFAULT '0',
  `consumableitemtypes_id` int(11) NOT NULL DEFAULT '0',
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `users_id_tech` int(11) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `alarm_threshold` int(11) NOT NULL DEFAULT '10',
  `notepad` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `entities_id` (`entities_id`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `locations_id` (`locations_id`),
  KEY `users_id_tech` (`users_id_tech`),
  KEY `consumableitemtypes_id` (`consumableitemtypes_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `alarm_threshold` (`alarm_threshold`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_consumableitems`
--

LOCK TABLES `glpi_consumableitems` WRITE;
/*!40000 ALTER TABLE `glpi_consumableitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_consumableitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_consumableitemtypes`
--

DROP TABLE IF EXISTS `glpi_consumableitemtypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_consumableitemtypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_consumableitemtypes`
--

LOCK TABLES `glpi_consumableitemtypes` WRITE;
/*!40000 ALTER TABLE `glpi_consumableitemtypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_consumableitemtypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_consumables`
--

DROP TABLE IF EXISTS `glpi_consumables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_consumables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `consumableitems_id` int(11) NOT NULL DEFAULT '0',
  `date_in` date DEFAULT NULL,
  `date_out` date DEFAULT NULL,
  `users_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `date_in` (`date_in`),
  KEY `date_out` (`date_out`),
  KEY `consumableitems_id` (`consumableitems_id`),
  KEY `users_id` (`users_id`),
  KEY `entities_id` (`entities_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_consumables`
--

LOCK TABLES `glpi_consumables` WRITE;
/*!40000 ALTER TABLE `glpi_consumables` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_consumables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_contacts`
--

DROP TABLE IF EXISTS `glpi_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `firstname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mobile` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fax` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contacttypes_id` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `notepad` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `entities_id` (`entities_id`),
  KEY `contacttypes_id` (`contacttypes_id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_contacts`
--

LOCK TABLES `glpi_contacts` WRITE;
/*!40000 ALTER TABLE `glpi_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_contacts_suppliers`
--

DROP TABLE IF EXISTS `glpi_contacts_suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_contacts_suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `suppliers_id` int(11) NOT NULL DEFAULT '0',
  `contacts_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`suppliers_id`,`contacts_id`),
  KEY `contacts_id` (`contacts_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_contacts_suppliers`
--

LOCK TABLES `glpi_contacts_suppliers` WRITE;
/*!40000 ALTER TABLE `glpi_contacts_suppliers` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_contacts_suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_contacttypes`
--

DROP TABLE IF EXISTS `glpi_contacttypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_contacttypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_contacttypes`
--

LOCK TABLES `glpi_contacttypes` WRITE;
/*!40000 ALTER TABLE `glpi_contacttypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_contacttypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_contracts`
--

DROP TABLE IF EXISTS `glpi_contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_contracts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `num` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `contracttypes_id` int(11) NOT NULL DEFAULT '0',
  `begin_date` date DEFAULT NULL,
  `duration` int(11) NOT NULL DEFAULT '0',
  `notice` int(11) NOT NULL DEFAULT '0',
  `periodicity` int(11) NOT NULL DEFAULT '0',
  `billing` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `accounting_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `week_begin_hour` time NOT NULL DEFAULT '00:00:00',
  `week_end_hour` time NOT NULL DEFAULT '00:00:00',
  `saturday_begin_hour` time NOT NULL DEFAULT '00:00:00',
  `saturday_end_hour` time NOT NULL DEFAULT '00:00:00',
  `use_saturday` tinyint(1) NOT NULL DEFAULT '0',
  `monday_begin_hour` time NOT NULL DEFAULT '00:00:00',
  `monday_end_hour` time NOT NULL DEFAULT '00:00:00',
  `use_monday` tinyint(1) NOT NULL DEFAULT '0',
  `max_links_allowed` int(11) NOT NULL DEFAULT '0',
  `notepad` longtext COLLATE utf8_unicode_ci,
  `alert` int(11) NOT NULL DEFAULT '0',
  `renewal` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `begin_date` (`begin_date`),
  KEY `name` (`name`),
  KEY `contracttypes_id` (`contracttypes_id`),
  KEY `entities_id` (`entities_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `use_monday` (`use_monday`),
  KEY `use_saturday` (`use_saturday`),
  KEY `alert` (`alert`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_contracts`
--

LOCK TABLES `glpi_contracts` WRITE;
/*!40000 ALTER TABLE `glpi_contracts` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_contracts_items`
--

DROP TABLE IF EXISTS `glpi_contracts_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_contracts_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contracts_id` int(11) NOT NULL DEFAULT '0',
  `items_id` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`contracts_id`,`itemtype`,`items_id`),
  KEY `FK_device` (`items_id`,`itemtype`),
  KEY `item` (`itemtype`,`items_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_contracts_items`
--

LOCK TABLES `glpi_contracts_items` WRITE;
/*!40000 ALTER TABLE `glpi_contracts_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_contracts_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_contracts_suppliers`
--

DROP TABLE IF EXISTS `glpi_contracts_suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_contracts_suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `suppliers_id` int(11) NOT NULL DEFAULT '0',
  `contracts_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`suppliers_id`,`contracts_id`),
  KEY `contracts_id` (`contracts_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_contracts_suppliers`
--

LOCK TABLES `glpi_contracts_suppliers` WRITE;
/*!40000 ALTER TABLE `glpi_contracts_suppliers` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_contracts_suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_contracttypes`
--

DROP TABLE IF EXISTS `glpi_contracttypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_contracttypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_contracttypes`
--

LOCK TABLES `glpi_contracttypes` WRITE;
/*!40000 ALTER TABLE `glpi_contracttypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_contracttypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_crontasklogs`
--

DROP TABLE IF EXISTS `glpi_crontasklogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_crontasklogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `crontasks_id` int(11) NOT NULL,
  `crontasklogs_id` int(11) NOT NULL COMMENT 'id of ''start'' event',
  `date` datetime NOT NULL,
  `state` int(11) NOT NULL COMMENT '0:start, 1:run, 2:stop',
  `elapsed` float NOT NULL COMMENT 'time elapsed since start',
  `volume` int(11) NOT NULL COMMENT 'for statistics',
  `content` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'message',
  PRIMARY KEY (`id`),
  KEY `date` (`date`),
  KEY `crontasks_id` (`crontasks_id`),
  KEY `crontasklogs_id_state` (`crontasklogs_id`,`state`)
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_crontasklogs`
--

LOCK TABLES `glpi_crontasklogs` WRITE;
/*!40000 ALTER TABLE `glpi_crontasklogs` DISABLE KEYS */;
INSERT INTO `glpi_crontasklogs` VALUES (1,6,0,'2010-08-26 00:41:41',0,0,0,'Run mode : GLPI'),(2,6,1,'2010-08-26 00:41:41',2,0.00250196,0,'Action completed, nothing to do'),(3,8,0,'2010-08-26 00:47:22',0,0,0,'Run mode : GLPI'),(4,8,3,'2010-08-26 00:47:22',2,0.033916,163,'Action completed, fully processed'),(5,9,0,'2010-08-26 00:52:37',0,0,0,'Run mode : GLPI'),(6,9,5,'2010-08-26 00:52:37',2,0.00202608,0,'Action completed, nothing to do'),(7,12,0,'2010-08-26 00:58:17',0,0,0,'Run mode : GLPI'),(8,12,7,'2010-08-26 00:58:17',2,0.00123096,0,'Action completed, nothing to do'),(9,13,0,'2010-08-26 01:03:07',0,0,0,'Run mode : GLPI'),(10,13,9,'2010-08-26 01:03:07',1,0.00275397,1,'Clean 1 graph file(s) created since more than 3600 seconds\n'),(11,13,9,'2010-08-26 01:03:07',2,0.00359511,1,'Action completed, fully processed'),(12,14,0,'2010-08-26 01:07:58',0,0,0,'Run mode : GLPI'),(13,14,12,'2010-08-26 01:07:58',2,0.0016129,0,'Action completed, nothing to do'),(14,15,0,'2010-08-26 01:53:33',0,0,0,'Run mode : GLPI'),(15,15,14,'2010-08-26 01:53:33',2,0.00467896,0,'Action completed, nothing to do'),(16,16,0,'2010-08-26 02:29:01',0,0,0,'Run mode : GLPI'),(17,16,16,'2010-08-26 02:29:01',2,0.00137591,0,'Action completed, nothing to do'),(18,5,0,'2010-08-26 02:34:14',0,0,0,'Run mode : GLPI'),(19,5,18,'2010-08-26 02:34:14',2,0.0012939,0,'Action completed, nothing to do'),(20,9,0,'2010-08-26 02:42:52',0,0,0,'Run mode : GLPI'),(21,9,20,'2010-08-26 02:42:52',2,0.00162983,0,'Action completed, nothing to do'),(22,13,0,'2010-08-26 02:42:54',0,0,0,'Run mode : GLPI'),(23,13,22,'2010-08-26 02:42:54',2,0.000905991,0,'Action completed, nothing to do'),(24,14,0,'2010-08-26 03:21:32',0,0,0,'Run mode : GLPI'),(25,14,24,'2010-08-26 03:21:32',2,0.001086,0,'Action completed, nothing to do'),(26,9,0,'2010-08-26 04:09:42',0,0,0,'Run mode : GLPI'),(27,9,26,'2010-08-26 04:09:42',2,0.00169706,0,'Action completed, nothing to do'),(28,13,0,'2010-08-26 04:10:57',0,0,0,'Run mode : GLPI'),(29,13,28,'2010-08-26 04:10:57',2,0.000983953,0,'Action completed, nothing to do'),(30,9,0,'2010-08-26 05:41:31',0,0,0,'Run mode : GLPI'),(31,9,30,'2010-08-26 05:41:31',2,0.003757,0,'Action completed, nothing to do'),(32,14,0,'2010-08-27 02:32:05',0,0,0,'Run mode : GLPI'),(33,14,32,'2010-08-27 02:32:05',2,0.164548,0,'Action completed, nothing to do'),(34,13,0,'2010-08-27 02:43:12',0,0,0,'Modo de execução : GLPI'),(35,13,34,'2010-08-27 02:43:12',2,0.0012641,0,'Action completed, nothing to do'),(36,9,0,'2010-09-09 12:48:24',0,0,0,'Modo de execução : GLPI'),(37,9,36,'2010-09-09 12:48:24',2,0.00228,0,'Action completed, nothing to do'),(38,15,0,'2010-09-09 12:53:52',0,0,0,'Modo de execução : GLPI'),(39,15,38,'2010-09-09 12:53:52',2,0.0113311,0,'Action completed, nothing to do');
/*!40000 ALTER TABLE `glpi_crontasklogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_crontasks`
--

DROP TABLE IF EXISTS `glpi_crontasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_crontasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL COMMENT 'task name',
  `frequency` int(11) NOT NULL COMMENT 'second between launch',
  `param` int(11) DEFAULT NULL COMMENT 'task specify parameter',
  `state` int(11) NOT NULL DEFAULT '1' COMMENT '0:disabled, 1:waiting, 2:running',
  `mode` int(11) NOT NULL DEFAULT '1' COMMENT '1:internal, 2:external',
  `allowmode` int(11) NOT NULL DEFAULT '3' COMMENT '1:internal, 2:external, 3:both',
  `hourmin` int(11) NOT NULL DEFAULT '0',
  `hourmax` int(11) NOT NULL DEFAULT '24',
  `logs_lifetime` int(11) NOT NULL DEFAULT '30' COMMENT 'number of days',
  `lastrun` datetime DEFAULT NULL COMMENT 'last run date',
  `lastcode` int(11) DEFAULT NULL COMMENT 'last run return code',
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`itemtype`,`name`),
  KEY `mode` (`mode`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Task run by internal / external cron.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_crontasks`
--

LOCK TABLES `glpi_crontasks` WRITE;
/*!40000 ALTER TABLE `glpi_crontasks` DISABLE KEYS */;
INSERT INTO `glpi_crontasks` VALUES (1,'OcsServer','ocsng',300,NULL,0,1,3,0,24,30,NULL,NULL,NULL),(2,'CartridgeItem','cartridge',86400,10,0,1,3,0,24,30,NULL,NULL,NULL),(3,'ConsumableItem','consumable',86400,10,0,1,3,0,24,30,NULL,NULL,NULL),(4,'SoftwareLicense','software',86400,NULL,0,1,3,0,24,30,NULL,NULL,NULL),(5,'Contract','contract',86400,NULL,1,1,3,0,24,30,'2010-08-26 02:34:14',NULL,NULL),(6,'InfoCom','infocom',86400,NULL,1,1,3,0,24,30,'2010-08-26 00:41:41',NULL,NULL),(7,'CronTask','logs',86400,30,0,1,3,0,24,30,NULL,NULL,NULL),(8,'CronTask','optimize',604800,NULL,1,1,3,0,24,30,'2010-08-26 00:47:22',NULL,NULL),(9,'MailCollector','mailgate',600,10,1,1,3,0,24,30,'2010-09-09 12:48:24',NULL,NULL),(10,'DBconnection','checkdbreplicate',300,NULL,0,1,3,0,24,30,NULL,NULL,NULL),(11,'CronTask','checkupdate',604800,NULL,0,1,3,0,24,30,NULL,NULL,NULL),(12,'CronTask','session',86400,NULL,1,1,3,0,24,30,'2010-08-26 00:58:17',NULL,NULL),(13,'CronTask','graph',3600,NULL,1,1,3,0,24,30,'2010-08-27 02:43:12',NULL,NULL),(14,'ReservationItem','reservation',3600,NULL,1,1,3,0,24,30,'2010-08-27 02:32:06',NULL,NULL),(15,'Ticket','closeticket',43200,NULL,1,1,3,0,24,30,'2010-09-09 12:53:52',NULL,NULL),(16,'Ticket','alertnotclosed',43200,NULL,1,1,3,0,24,30,'2010-08-26 02:29:01',NULL,NULL);
/*!40000 ALTER TABLE `glpi_crontasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_devicecases`
--

DROP TABLE IF EXISTS `glpi_devicecases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_devicecases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `devicecasetypes_id` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `designation` (`designation`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `devicecasetypes_id` (`devicecasetypes_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_devicecases`
--

LOCK TABLES `glpi_devicecases` WRITE;
/*!40000 ALTER TABLE `glpi_devicecases` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_devicecases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_devicecasetypes`
--

DROP TABLE IF EXISTS `glpi_devicecasetypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_devicecasetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_devicecasetypes`
--

LOCK TABLES `glpi_devicecasetypes` WRITE;
/*!40000 ALTER TABLE `glpi_devicecasetypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_devicecasetypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_devicecontrols`
--

DROP TABLE IF EXISTS `glpi_devicecontrols`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_devicecontrols` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_raid` tinyint(1) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `interfacetypes_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `designation` (`designation`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `interfacetypes_id` (`interfacetypes_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_devicecontrols`
--

LOCK TABLES `glpi_devicecontrols` WRITE;
/*!40000 ALTER TABLE `glpi_devicecontrols` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_devicecontrols` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_devicedrives`
--

DROP TABLE IF EXISTS `glpi_devicedrives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_devicedrives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_writer` tinyint(1) NOT NULL DEFAULT '1',
  `speed` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `interfacetypes_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `designation` (`designation`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `interfacetypes_id` (`interfacetypes_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_devicedrives`
--

LOCK TABLES `glpi_devicedrives` WRITE;
/*!40000 ALTER TABLE `glpi_devicedrives` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_devicedrives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_devicegraphiccards`
--

DROP TABLE IF EXISTS `glpi_devicegraphiccards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_devicegraphiccards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `interfacetypes_id` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `specif_default` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `designation` (`designation`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `interfacetypes_id` (`interfacetypes_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_devicegraphiccards`
--

LOCK TABLES `glpi_devicegraphiccards` WRITE;
/*!40000 ALTER TABLE `glpi_devicegraphiccards` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_devicegraphiccards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_deviceharddrives`
--

DROP TABLE IF EXISTS `glpi_deviceharddrives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_deviceharddrives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rpm` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `interfacetypes_id` int(11) NOT NULL DEFAULT '0',
  `cache` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `specif_default` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `designation` (`designation`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `interfacetypes_id` (`interfacetypes_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_deviceharddrives`
--

LOCK TABLES `glpi_deviceharddrives` WRITE;
/*!40000 ALTER TABLE `glpi_deviceharddrives` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_deviceharddrives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_devicememories`
--

DROP TABLE IF EXISTS `glpi_devicememories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_devicememories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `frequence` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `specif_default` int(11) NOT NULL,
  `devicememorytypes_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `designation` (`designation`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `devicememorytypes_id` (`devicememorytypes_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_devicememories`
--

LOCK TABLES `glpi_devicememories` WRITE;
/*!40000 ALTER TABLE `glpi_devicememories` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_devicememories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_devicememorytypes`
--

DROP TABLE IF EXISTS `glpi_devicememorytypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_devicememorytypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_devicememorytypes`
--

LOCK TABLES `glpi_devicememorytypes` WRITE;
/*!40000 ALTER TABLE `glpi_devicememorytypes` DISABLE KEYS */;
INSERT INTO `glpi_devicememorytypes` VALUES (1,'EDO',NULL),(2,'DDR',NULL),(3,'SDRAM',NULL),(4,'SDRAM-2',NULL);
/*!40000 ALTER TABLE `glpi_devicememorytypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_devicemotherboards`
--

DROP TABLE IF EXISTS `glpi_devicemotherboards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_devicemotherboards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `chipset` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `designation` (`designation`),
  KEY `manufacturers_id` (`manufacturers_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_devicemotherboards`
--

LOCK TABLES `glpi_devicemotherboards` WRITE;
/*!40000 ALTER TABLE `glpi_devicemotherboards` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_devicemotherboards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_devicenetworkcards`
--

DROP TABLE IF EXISTS `glpi_devicenetworkcards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_devicenetworkcards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bandwidth` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `specif_default` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `designation` (`designation`),
  KEY `manufacturers_id` (`manufacturers_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_devicenetworkcards`
--

LOCK TABLES `glpi_devicenetworkcards` WRITE;
/*!40000 ALTER TABLE `glpi_devicenetworkcards` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_devicenetworkcards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_devicepcis`
--

DROP TABLE IF EXISTS `glpi_devicepcis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_devicepcis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `designation` (`designation`),
  KEY `manufacturers_id` (`manufacturers_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_devicepcis`
--

LOCK TABLES `glpi_devicepcis` WRITE;
/*!40000 ALTER TABLE `glpi_devicepcis` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_devicepcis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_devicepowersupplies`
--

DROP TABLE IF EXISTS `glpi_devicepowersupplies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_devicepowersupplies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `power` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_atx` tinyint(1) NOT NULL DEFAULT '1',
  `comment` text COLLATE utf8_unicode_ci,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `designation` (`designation`),
  KEY `manufacturers_id` (`manufacturers_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_devicepowersupplies`
--

LOCK TABLES `glpi_devicepowersupplies` WRITE;
/*!40000 ALTER TABLE `glpi_devicepowersupplies` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_devicepowersupplies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_deviceprocessors`
--

DROP TABLE IF EXISTS `glpi_deviceprocessors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_deviceprocessors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `frequence` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `specif_default` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `designation` (`designation`),
  KEY `manufacturers_id` (`manufacturers_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_deviceprocessors`
--

LOCK TABLES `glpi_deviceprocessors` WRITE;
/*!40000 ALTER TABLE `glpi_deviceprocessors` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_deviceprocessors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_devicesoundcards`
--

DROP TABLE IF EXISTS `glpi_devicesoundcards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_devicesoundcards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `designation` (`designation`),
  KEY `manufacturers_id` (`manufacturers_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_devicesoundcards`
--

LOCK TABLES `glpi_devicesoundcards` WRITE;
/*!40000 ALTER TABLE `glpi_devicesoundcards` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_devicesoundcards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_displaypreferences`
--

DROP TABLE IF EXISTS `glpi_displaypreferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_displaypreferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `num` int(11) NOT NULL DEFAULT '0',
  `rank` int(11) NOT NULL DEFAULT '0',
  `users_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`users_id`,`itemtype`,`num`),
  KEY `rank` (`rank`),
  KEY `num` (`num`),
  KEY `itemtype` (`itemtype`)
) ENGINE=MyISAM AUTO_INCREMENT=174 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_displaypreferences`
--

LOCK TABLES `glpi_displaypreferences` WRITE;
/*!40000 ALTER TABLE `glpi_displaypreferences` DISABLE KEYS */;
INSERT INTO `glpi_displaypreferences` VALUES (32,'Computer',4,4,0),(34,'Computer',45,6,0),(33,'Computer',40,5,0),(31,'Computer',5,3,0),(30,'Computer',23,2,0),(86,'DocumentType',3,1,0),(49,'Monitor',31,1,0),(50,'Monitor',23,2,0),(51,'Monitor',3,3,0),(52,'Monitor',4,4,0),(44,'Printer',31,1,0),(38,'NetworkEquipment',31,1,0),(39,'NetworkEquipment',23,2,0),(45,'Printer',23,2,0),(46,'Printer',3,3,0),(63,'Software',4,3,0),(62,'Software',5,2,0),(61,'Software',23,1,0),(83,'CartridgeItem',4,2,0),(82,'CartridgeItem',34,1,0),(57,'Peripheral',3,3,0),(56,'Peripheral',23,2,0),(55,'Peripheral',31,1,0),(29,'Computer',31,1,0),(35,'Computer',3,7,0),(36,'Computer',19,8,0),(37,'Computer',17,9,0),(40,'NetworkEquipment',3,3,0),(41,'NetworkEquipment',4,4,0),(42,'NetworkEquipment',11,6,0),(43,'NetworkEquipment',19,7,0),(47,'Printer',4,4,0),(48,'Printer',19,6,0),(53,'Monitor',19,6,0),(54,'Monitor',7,7,0),(58,'Peripheral',4,4,0),(59,'Peripheral',19,6,0),(60,'Peripheral',7,7,0),(64,'Contact',3,1,0),(65,'Contact',4,2,0),(66,'Contact',5,3,0),(67,'Contact',6,4,0),(68,'Contact',9,5,0),(69,'Supplier',9,1,0),(70,'Supplier',3,2,0),(71,'Supplier',4,3,0),(72,'Supplier',5,4,0),(73,'Supplier',10,5,0),(74,'Supplier',6,6,0),(75,'Contract',4,1,0),(76,'Contract',3,2,0),(77,'Contract',5,3,0),(78,'Contract',6,4,0),(79,'Contract',7,5,0),(80,'Contract',11,6,0),(84,'CartridgeItem',23,3,0),(85,'CartridgeItem',3,4,0),(88,'DocumentType',6,2,0),(89,'DocumentType',4,3,0),(90,'DocumentType',5,4,0),(91,'Document',3,1,0),(92,'Document',4,2,0),(93,'Document',7,3,0),(94,'Document',5,4,0),(95,'Document',16,5,0),(96,'User',34,1,0),(98,'User',5,3,0),(99,'User',6,4,0),(100,'User',3,5,0),(101,'ConsumableItem',34,1,0),(102,'ConsumableItem',4,2,0),(103,'ConsumableItem',23,3,0),(104,'ConsumableItem',3,4,0),(105,'NetworkEquipment',40,5,0),(106,'Printer',40,5,0),(107,'Monitor',40,5,0),(108,'Peripheral',40,5,0),(109,'User',8,6,0),(110,'Phone',31,1,0),(111,'Phone',23,2,0),(112,'Phone',3,3,0),(113,'Phone',4,4,0),(114,'Phone',40,5,0),(115,'Phone',19,6,0),(116,'Phone',7,7,0),(117,'Group',16,1,0),(118,'States',31,1,0),(119,'ReservationItem',4,1,0),(120,'ReservationItem',3,2,0),(125,'Budget',3,2,0),(122,'Software',72,4,0),(123,'Software',163,5,0),(124,'Budget',2,1,0),(126,'Budget',4,3,0),(127,'Budget',19,4,0),(128,'Crontask',8,1,0),(129,'Crontask',3,2,0),(130,'Crontask',4,3,0),(131,'Crontask',7,4,0),(132,'RequestType',14,1,0),(133,'RequestType',15,2,0),(134,'NotificationTemplate',4,1,0),(135,'NotificationTemplate',16,2,0),(136,'Notification',5,1,0),(137,'Notification',6,2,0),(138,'Notification',2,3,0),(139,'Notification',4,4,0),(140,'Notification',80,5,0),(141,'Notification',86,6,0),(142,'MailCollector',2,1,0),(143,'MailCollector',19,2,0),(144,'AuthLDAP',3,1,0),(145,'AuthLDAP',19,2,0),(146,'AuthMail',3,1,0),(147,'AuthMail',19,2,0),(148,'OcsServer',3,1,0),(149,'OcsServer',19,2,0),(150,'Profile',2,1,0),(151,'Profile',3,2,0),(152,'Profile',19,3,0),(153,'Transfer',19,1,0),(154,'TicketValidation',3,1,0),(155,'TicketValidation',2,2,0),(156,'TicketValidation',8,3,0),(157,'TicketValidation',4,4,0),(158,'TicketValidation',9,5,0),(159,'TicketValidation',7,6,0),(160,'NotImportedEmail',2,1,0),(161,'NotImportedEmail',5,2,0),(162,'NotImportedEmail',4,3,0),(163,'NotImportedEmail',6,4,0),(164,'NotImportedEmail',16,5,0),(165,'NotImportedEmail',19,6,0),(166,'RuleRightParameter',11,1,0),(167,'Ticket',12,1,0),(168,'Ticket',19,2,0),(169,'Ticket',15,3,0),(170,'Ticket',3,4,0),(171,'Ticket',4,5,0),(172,'Ticket',5,6,0),(173,'Ticket',7,7,0);
/*!40000 ALTER TABLE `glpi_displaypreferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_documentcategories`
--

DROP TABLE IF EXISTS `glpi_documentcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_documentcategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_documentcategories`
--

LOCK TABLES `glpi_documentcategories` WRITE;
/*!40000 ALTER TABLE `glpi_documentcategories` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_documentcategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_documents`
--

DROP TABLE IF EXISTS `glpi_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'for display and transfert',
  `filepath` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'file storage path',
  `documentcategories_id` int(11) NOT NULL DEFAULT '0',
  `mime` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notepad` longtext COLLATE utf8_unicode_ci,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `tickets_id` int(11) NOT NULL DEFAULT '0',
  `sha1sum` char(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `date_mod` (`date_mod`),
  KEY `name` (`name`),
  KEY `entities_id` (`entities_id`),
  KEY `tickets_id` (`tickets_id`),
  KEY `users_id` (`users_id`),
  KEY `documentcategories_id` (`documentcategories_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `sha1sum` (`sha1sum`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_documents`
--

LOCK TABLES `glpi_documents` WRITE;
/*!40000 ALTER TABLE `glpi_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_documents_items`
--

DROP TABLE IF EXISTS `glpi_documents_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_documents_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `documents_id` int(11) NOT NULL DEFAULT '0',
  `items_id` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`documents_id`,`itemtype`,`items_id`),
  KEY `item` (`itemtype`,`items_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_documents_items`
--

LOCK TABLES `glpi_documents_items` WRITE;
/*!40000 ALTER TABLE `glpi_documents_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_documents_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_documenttypes`
--

DROP TABLE IF EXISTS `glpi_documenttypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_documenttypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ext` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `icon` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mime` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_uploadable` tinyint(1) NOT NULL DEFAULT '1',
  `date_mod` datetime DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`ext`),
  KEY `name` (`name`),
  KEY `is_uploadable` (`is_uploadable`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM AUTO_INCREMENT=68 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_documenttypes`
--

LOCK TABLES `glpi_documenttypes` WRITE;
/*!40000 ALTER TABLE `glpi_documenttypes` DISABLE KEYS */;
INSERT INTO `glpi_documenttypes` VALUES (1,'JPEG','jpg','jpg-dist.png','',1,'2004-12-13 19:47:21',NULL),(2,'PNG','png','png-dist.png','',1,'2004-12-13 19:47:21',NULL),(3,'GIF','gif','gif-dist.png','',1,'2004-12-13 19:47:21',NULL),(4,'BMP','bmp','bmp-dist.png','',1,'2004-12-13 19:47:21',NULL),(5,'Photoshop','psd','psd-dist.png','',1,'2004-12-13 19:47:21',NULL),(6,'TIFF','tif','tif-dist.png','',1,'2004-12-13 19:47:21',NULL),(7,'AIFF','aiff','aiff-dist.png','',1,'2004-12-13 19:47:21',NULL),(8,'Windows Media','asf','asf-dist.png','',1,'2004-12-13 19:47:21',NULL),(9,'Windows Media','avi','avi-dist.png','',1,'2004-12-13 19:47:21',NULL),(44,'C source','c','','',1,'2004-12-13 19:47:22',NULL),(27,'RealAudio','rm','rm-dist.png','',1,'2004-12-13 19:47:21',NULL),(16,'Midi','mid','mid-dist.png','',1,'2004-12-13 19:47:21',NULL),(17,'QuickTime','mov','mov-dist.png','',1,'2004-12-13 19:47:21',NULL),(18,'MP3','mp3','mp3-dist.png','',1,'2004-12-13 19:47:21',NULL),(19,'MPEG','mpg','mpg-dist.png','',1,'2004-12-13 19:47:21',NULL),(20,'Ogg Vorbis','ogg','ogg-dist.png','',1,'2004-12-13 19:47:21',NULL),(24,'QuickTime','qt','qt-dist.png','',1,'2004-12-13 19:47:21',NULL),(10,'BZip','bz2','bz2-dist.png','',1,'2004-12-13 19:47:21',NULL),(25,'RealAudio','ra','ra-dist.png','',1,'2004-12-13 19:47:21',NULL),(26,'RealAudio','ram','ram-dist.png','',1,'2004-12-13 19:47:21',NULL),(11,'Word','doc','doc-dist.png','',1,'2004-12-13 19:47:21',NULL),(12,'DjVu','djvu','','',1,'2004-12-13 19:47:21',NULL),(42,'MNG','mng','','',1,'2004-12-13 19:47:22',NULL),(13,'PostScript','eps','ps-dist.png','',1,'2004-12-13 19:47:21',NULL),(14,'GZ','gz','gz-dist.png','',1,'2004-12-13 19:47:21',NULL),(37,'WAV','wav','wav-dist.png','',1,'2004-12-13 19:47:22',NULL),(15,'HTML','html','html-dist.png','',1,'2004-12-13 19:47:21',NULL),(34,'Flash','swf','','',1,'2004-12-13 19:47:22',NULL),(21,'PDF','pdf','pdf-dist.png','',1,'2004-12-13 19:47:21',NULL),(22,'PowerPoint','ppt','ppt-dist.png','',1,'2004-12-13 19:47:21',NULL),(23,'PostScript','ps','ps-dist.png','',1,'2004-12-13 19:47:21',NULL),(40,'Windows Media','wmv','','',1,'2004-12-13 19:47:22',NULL),(28,'RTF','rtf','rtf-dist.png','',1,'2004-12-13 19:47:21',NULL),(29,'StarOffice','sdd','sdd-dist.png','',1,'2004-12-13 19:47:22',NULL),(30,'StarOffice','sdw','sdw-dist.png','',1,'2004-12-13 19:47:22',NULL),(31,'Stuffit','sit','sit-dist.png','',1,'2004-12-13 19:47:22',NULL),(43,'Adobe Illustrator','ai','ai-dist.png','',1,'2004-12-13 19:47:22',NULL),(32,'OpenOffice Impress','sxi','sxi-dist.png','',1,'2004-12-13 19:47:22',NULL),(33,'OpenOffice','sxw','sxw-dist.png','',1,'2004-12-13 19:47:22',NULL),(46,'DVI','dvi','dvi-dist.png','',1,'2004-12-13 19:47:22',NULL),(35,'TGZ','tgz','tgz-dist.png','',1,'2004-12-13 19:47:22',NULL),(36,'texte','txt','txt-dist.png','',1,'2004-12-13 19:47:22',NULL),(49,'RedHat/Mandrake/SuSE','rpm','rpm-dist.png','',1,'2004-12-13 19:47:22',NULL),(38,'Excel','xls','xls-dist.png','',1,'2004-12-13 19:47:22',NULL),(39,'XML','xml','xml-dist.png','',1,'2004-12-13 19:47:22',NULL),(41,'Zip','zip','zip-dist.png','',1,'2004-12-13 19:47:22',NULL),(45,'Debian','deb','deb-dist.png','',1,'2004-12-13 19:47:22',NULL),(47,'C header','h','','',1,'2004-12-13 19:47:22',NULL),(48,'Pascal','pas','','',1,'2004-12-13 19:47:22',NULL),(50,'OpenOffice Calc','sxc','sxc-dist.png','',1,'2004-12-13 19:47:22',NULL),(51,'LaTeX','tex','tex-dist.png','',1,'2004-12-13 19:47:22',NULL),(52,'GIMP multi-layer','xcf','xcf-dist.png','',1,'2004-12-13 19:47:22',NULL),(53,'JPEG','jpeg','jpg-dist.png','',1,'2005-03-07 22:23:17',NULL),(54,'Oasis Open Office Writer','odt','odt-dist.png','',1,'2006-01-21 17:41:13',NULL),(55,'Oasis Open Office Calc','ods','ods-dist.png','',1,'2006-01-21 17:41:31',NULL),(56,'Oasis Open Office Impress','odp','odp-dist.png','',1,'2006-01-21 17:42:54',NULL),(57,'Oasis Open Office Impress Template','otp','odp-dist.png','',1,'2006-01-21 17:43:58',NULL),(58,'Oasis Open Office Writer Template','ott','odt-dist.png','',1,'2006-01-21 17:44:41',NULL),(59,'Oasis Open Office Calc Template','ots','ods-dist.png','',1,'2006-01-21 17:45:30',NULL),(60,'Oasis Open Office Math','odf','odf-dist.png','',1,'2006-01-21 17:48:05',NULL),(61,'Oasis Open Office Draw','odg','odg-dist.png','',1,'2006-01-21 17:48:31',NULL),(62,'Oasis Open Office Draw Template','otg','odg-dist.png','',1,'2006-01-21 17:49:46',NULL),(63,'Oasis Open Office Base','odb','odb-dist.png','',1,'2006-01-21 18:03:34',NULL),(64,'Oasis Open Office HTML','oth','oth-dist.png','',1,'2006-01-21 18:05:27',NULL),(65,'Oasis Open Office Writer Master','odm','odm-dist.png','',1,'2006-01-21 18:06:34',NULL),(66,'Oasis Open Office Chart','odc','','',1,'2006-01-21 18:07:48',NULL),(67,'Oasis Open Office Image','odi','','',1,'2006-01-21 18:08:18',NULL);
/*!40000 ALTER TABLE `glpi_documenttypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_domains`
--

DROP TABLE IF EXISTS `glpi_domains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_domains`
--

LOCK TABLES `glpi_domains` WRITE;
/*!40000 ALTER TABLE `glpi_domains` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_domains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_entities`
--

DROP TABLE IF EXISTS `glpi_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_entities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `completename` text COLLATE utf8_unicode_ci,
  `comment` text COLLATE utf8_unicode_ci,
  `level` int(11) NOT NULL DEFAULT '0',
  `sons_cache` longtext COLLATE utf8_unicode_ci,
  `ancestors_cache` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`entities_id`,`name`),
  KEY `entities_id` (`entities_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_entities`
--

LOCK TABLES `glpi_entities` WRITE;
/*!40000 ALTER TABLE `glpi_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_entitydatas`
--

DROP TABLE IF EXISTS `glpi_entitydatas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_entitydatas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `address` text COLLATE utf8_unicode_ci,
  `postcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `town` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phonenumber` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fax` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `admin_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `admin_reply` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notepad` longtext COLLATE utf8_unicode_ci,
  `ldap_dn` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ldapservers_id` int(11) NOT NULL DEFAULT '0',
  `mail_domain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity_ldapfilter` text COLLATE utf8_unicode_ci,
  `mailing_signature` text COLLATE utf8_unicode_ci,
  `cartridges_alert_repeat` int(11) NOT NULL DEFAULT '-1',
  `consumables_alert_repeat` int(11) NOT NULL DEFAULT '-1',
  `use_licenses_alert` tinyint(1) NOT NULL DEFAULT '-1',
  `use_contracts_alert` tinyint(1) NOT NULL DEFAULT '-1',
  `use_infocoms_alert` tinyint(1) NOT NULL DEFAULT '-1',
  `use_reservations_alert` int(11) NOT NULL DEFAULT '-1',
  `autoclose_delay` int(11) NOT NULL DEFAULT '-1',
  `notclosed_delay` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`entities_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_entitydatas`
--

LOCK TABLES `glpi_entitydatas` WRITE;
/*!40000 ALTER TABLE `glpi_entitydatas` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_entitydatas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_events`
--

DROP TABLE IF EXISTS `glpi_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `items_id` int(11) NOT NULL DEFAULT '0',
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `service` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `level` int(11) NOT NULL DEFAULT '0',
  `message` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `date` (`date`),
  KEY `level` (`level`),
  KEY `item` (`type`,`items_id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_events`
--

LOCK TABLES `glpi_events` WRITE;
/*!40000 ALTER TABLE `glpi_events` DISABLE KEYS */;
INSERT INTO `glpi_events` VALUES (1,-1,'system','2010-08-26 00:41:46','login',3,'glpi IP connection: 192.168.153.1'),(2,1,'location','2010-08-26 00:44:07','setup',4,'glpi added IMPA.'),(3,2,'location','2010-08-26 00:44:33','setup',4,'glpi added Netadm.'),(4,3,'location','2010-08-26 00:44:48','setup',4,'glpi added CPD.'),(5,1,'operatingsystem','2010-08-26 00:45:21','setup',4,'glpi added Linux.'),(6,2,'operatingsystem','2010-08-26 00:45:29','setup',4,'glpi added Mac OS X.'),(7,3,'operatingsystem','2010-08-26 00:45:34','setup',4,'glpi added Windows.'),(8,1,'manufacturer','2010-08-26 00:45:56','setup',4,'glpi added Apple.'),(9,2,'manufacturer','2010-08-26 00:46:02','setup',4,'glpi added Dell.'),(10,3,'manufacturer','2010-08-26 00:46:06','setup',4,'glpi added IBM.'),(11,4,'manufacturer','2010-08-26 00:46:11','setup',4,'glpi added Intel.'),(12,1,'computers','2010-08-26 00:46:26','inventory',4,'glpi item added QIN.'),(13,0,'networkport','2010-08-26 00:48:32','inventory',5,'glpi network port added'),(14,0,'networkport','2010-08-26 00:49:32','inventory',5,'glpi network port added'),(15,1,'state','2010-08-26 00:50:20','setup',4,'glpi added Ativo.'),(16,2,'state','2010-08-26 00:50:26','setup',4,'glpi added Em Mannutencao.'),(17,1,'computertype','2010-08-26 00:50:41','setup',4,'glpi added Servidor.'),(18,2,'computertype','2010-08-26 00:50:46','setup',4,'glpi added Desktop.'),(19,3,'computertype','2010-08-26 00:50:55','setup',4,'glpi added Notebook.'),(20,2,'computers','2010-08-26 00:51:25','inventory',4,'glpi item added METZLER.'),(21,1,'computers','2010-08-26 00:51:37','inventory',4,'glpi update item'),(22,0,'networkport','2010-08-26 00:52:37','inventory',5,'glpi network port added'),(23,5,'manufacturer','2010-08-26 00:55:05','setup',4,'glpi added Cisco.'),(24,1,'networkequipment','2010-08-26 00:55:24','inventory',4,'glpi item added :  cat6509-1.'),(25,1,'network','2010-08-26 00:58:41','setup',4,'glpi added netadm.'),(26,2,'network','2010-08-26 00:58:45','setup',4,'glpi added pesq.'),(27,3,'network','2010-08-26 00:58:51','setup',4,'glpi added servidores.'),(28,4,'network','2010-08-26 00:58:55','setup',4,'glpi added alunos.'),(29,1,'peripherals','2010-08-26 02:29:48','inventory',4,'glpi item added iPhone.'),(30,1,'phones','2010-08-26 02:35:09','inventory',4,'glpi item added Rosa.'),(31,6,'manufacturer','2010-08-26 02:35:41','setup',4,'glpi added HP.'),(32,1,'cartridges','2010-08-26 02:36:05','inventory',4,'glpi item added HP inkjet 2100.'),(33,1,'netpoint','2010-08-26 03:20:58','setup',4,'glpi added 1000001.'),(34,2,'netpoint','2010-08-26 03:21:13','setup',4,'glpi added 1000002.'),(35,-1,'system','2010-08-26 04:07:15','login',3,'glpi IP connection: 192.168.153.1'),(36,-1,'system','2010-08-26 04:09:57','login',3,'glpi IP connection: 192.168.153.1'),(37,-1,'system','2010-08-26 04:10:58','login',3,'glpi IP connection: 192.168.153.1'),(38,-1,'system','2010-08-27 02:32:13','login',3,'glpi IP connection: 192.168.153.1'),(39,0,'users','2010-08-27 02:32:58','setup',5,'glpi  update item  glpi.'),(40,2,'computers','2010-08-27 02:43:11','inventory',4,'glpi atualizar itens'),(41,1,'software','2010-09-09 12:50:58','inventory',4,'glpi item adicionado Apache.'),(42,1,'software','2010-09-09 12:51:28','inventory',4,'glpi adicionando versão 1.'),(43,2,'computers','2010-09-09 12:52:12','inventory',5,'glpi installed software.'),(44,1,'software','2010-09-09 12:53:51','inventory',4,'glpi atualizar itens'),(45,2,'softwarelicensetype','2010-09-09 12:55:21','setup',4,'glpi added Freeware.'),(46,1,'software','2010-09-09 12:55:27','inventory',4,'glpi adicionar licença 1.'),(47,1,'software','2010-09-09 12:56:17','inventory',4,'glpi alteração da licença 1');
/*!40000 ALTER TABLE `glpi_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_filesystems`
--

DROP TABLE IF EXISTS `glpi_filesystems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_filesystems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_filesystems`
--

LOCK TABLES `glpi_filesystems` WRITE;
/*!40000 ALTER TABLE `glpi_filesystems` DISABLE KEYS */;
INSERT INTO `glpi_filesystems` VALUES (1,'ext',NULL),(2,'ext2',NULL),(3,'ext3',NULL),(4,'ext4',NULL),(5,'FAT',NULL),(6,'FAT32',NULL),(7,'VFAT',NULL),(8,'HFS',NULL),(9,'HPFS',NULL),(10,'HTFS',NULL),(11,'JFS',NULL),(12,'JFS2',NULL),(13,'NFS',NULL),(14,'NTFS',NULL),(15,'ReiserFS',NULL),(16,'SMBFS',NULL),(17,'UDF',NULL),(18,'UFS',NULL),(19,'XFS',NULL),(20,'ZFS',NULL);
/*!40000 ALTER TABLE `glpi_filesystems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_groups`
--

DROP TABLE IF EXISTS `glpi_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `ldap_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ldap_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ldap_group_dn` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `ldap_field` (`ldap_field`),
  KEY `ldap_group_dn` (`ldap_group_dn`),
  KEY `ldap_value` (`ldap_value`),
  KEY `entities_id` (`entities_id`),
  KEY `users_id` (`users_id`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_groups`
--

LOCK TABLES `glpi_groups` WRITE;
/*!40000 ALTER TABLE `glpi_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_groups_users`
--

DROP TABLE IF EXISTS `glpi_groups_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_groups_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `groups_id` int(11) NOT NULL DEFAULT '0',
  `is_dynamic` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`users_id`,`groups_id`),
  KEY `groups_id` (`groups_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_groups_users`
--

LOCK TABLES `glpi_groups_users` WRITE;
/*!40000 ALTER TABLE `glpi_groups_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_groups_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_infocoms`
--

DROP TABLE IF EXISTS `glpi_infocoms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_infocoms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `items_id` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `buy_date` date DEFAULT NULL,
  `use_date` date DEFAULT NULL,
  `warranty_duration` int(11) NOT NULL DEFAULT '0',
  `warranty_info` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `suppliers_id` int(11) NOT NULL DEFAULT '0',
  `order_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delivery_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `immo_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `warranty_value` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `sink_time` int(11) NOT NULL DEFAULT '0',
  `sink_type` int(11) NOT NULL DEFAULT '0',
  `sink_coeff` float NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `bill` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `budgets_id` int(11) NOT NULL DEFAULT '0',
  `alert` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`itemtype`,`items_id`),
  KEY `buy_date` (`buy_date`),
  KEY `alert` (`alert`),
  KEY `budgets_id` (`budgets_id`),
  KEY `suppliers_id` (`suppliers_id`),
  KEY `entities_id` (`entities_id`),
  KEY `is_recursive` (`is_recursive`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_infocoms`
--

LOCK TABLES `glpi_infocoms` WRITE;
/*!40000 ALTER TABLE `glpi_infocoms` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_infocoms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_interfacetypes`
--

DROP TABLE IF EXISTS `glpi_interfacetypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_interfacetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_interfacetypes`
--

LOCK TABLES `glpi_interfacetypes` WRITE;
/*!40000 ALTER TABLE `glpi_interfacetypes` DISABLE KEYS */;
INSERT INTO `glpi_interfacetypes` VALUES (1,'IDE',NULL),(2,'SATA',NULL),(3,'SCSI',NULL),(4,'USB',NULL),(5,'AGP',''),(6,'PCI',''),(7,'PCIe',''),(8,'PCI-X','');
/*!40000 ALTER TABLE `glpi_interfacetypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_knowbaseitemcategories`
--

DROP TABLE IF EXISTS `glpi_knowbaseitemcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_knowbaseitemcategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `knowbaseitemcategories_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `completename` text COLLATE utf8_unicode_ci,
  `comment` text COLLATE utf8_unicode_ci,
  `level` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`knowbaseitemcategories_id`,`name`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_knowbaseitemcategories`
--

LOCK TABLES `glpi_knowbaseitemcategories` WRITE;
/*!40000 ALTER TABLE `glpi_knowbaseitemcategories` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_knowbaseitemcategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_knowbaseitems`
--

DROP TABLE IF EXISTS `glpi_knowbaseitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_knowbaseitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '1',
  `knowbaseitemcategories_id` int(11) NOT NULL DEFAULT '0',
  `question` text COLLATE utf8_unicode_ci,
  `answer` longtext COLLATE utf8_unicode_ci,
  `is_faq` tinyint(1) NOT NULL DEFAULT '0',
  `users_id` int(11) NOT NULL DEFAULT '0',
  `view` int(11) NOT NULL DEFAULT '0',
  `date` datetime DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  KEY `knowbaseitemcategories_id` (`knowbaseitemcategories_id`),
  KEY `entities_id` (`entities_id`),
  KEY `is_faq` (`is_faq`),
  KEY `date_mod` (`date_mod`),
  FULLTEXT KEY `fulltext` (`question`,`answer`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_knowbaseitems`
--

LOCK TABLES `glpi_knowbaseitems` WRITE;
/*!40000 ALTER TABLE `glpi_knowbaseitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_knowbaseitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_links`
--

DROP TABLE IF EXISTS `glpi_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '1',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `entities_id` (`entities_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_links`
--

LOCK TABLES `glpi_links` WRITE;
/*!40000 ALTER TABLE `glpi_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_links_itemtypes`
--

DROP TABLE IF EXISTS `glpi_links_itemtypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_links_itemtypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `links_id` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`itemtype`,`links_id`),
  KEY `links_id` (`links_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_links_itemtypes`
--

LOCK TABLES `glpi_links_itemtypes` WRITE;
/*!40000 ALTER TABLE `glpi_links_itemtypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_links_itemtypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_locations`
--

DROP TABLE IF EXISTS `glpi_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locations_id` int(11) NOT NULL DEFAULT '0',
  `completename` text COLLATE utf8_unicode_ci,
  `comment` text COLLATE utf8_unicode_ci,
  `level` int(11) NOT NULL DEFAULT '0',
  `ancestors_cache` longtext COLLATE utf8_unicode_ci,
  `sons_cache` longtext COLLATE utf8_unicode_ci,
  `building` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `room` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `geotag` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`entities_id`,`locations_id`,`name`),
  KEY `locations_id` (`locations_id`),
  KEY `name` (`name`),
  KEY `is_recursive` (`is_recursive`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_locations`
--

LOCK TABLES `glpi_locations` WRITE;
/*!40000 ALTER TABLE `glpi_locations` DISABLE KEYS */;
INSERT INTO `glpi_locations` VALUES (1,0,0,'IMPA',0,'IMPA','',1,NULL,NULL,'110','',NULL),(2,0,0,'Netadm',1,'IMPA > Netadm','',2,NULL,NULL,'110','105',NULL),(3,0,0,'CPD',1,'IMPA > CPD','',2,NULL,NULL,'110','102',NULL);
/*!40000 ALTER TABLE `glpi_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_logs`
--

DROP TABLE IF EXISTS `glpi_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `items_id` int(11) NOT NULL DEFAULT '0',
  `itemtype_link` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `linked_action` int(11) NOT NULL DEFAULT '0' COMMENT 'see define.php HISTORY_* constant',
  `user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `id_search_option` int(11) NOT NULL DEFAULT '0' COMMENT 'see search.constant.php for value',
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `date_mod` (`date_mod`),
  KEY `itemtype_link` (`itemtype_link`),
  KEY `item` (`itemtype`,`items_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_logs`
--

LOCK TABLES `glpi_logs` WRITE;
/*!40000 ALTER TABLE `glpi_logs` DISABLE KEYS */;
INSERT INTO `glpi_logs` VALUES (1,'Computer',1,'NetworkPort',17,'glpi','2010-08-26 00:48:32',0,'','HTTP'),(2,'Computer',1,'NetworkPort',17,'glpi','2010-08-26 00:49:32',0,'','SSH'),(3,'Computer',1,'',0,'glpi','2010-08-26 00:51:37',31,'&nbsp;','Ativo'),(4,'Computer',1,'',0,'glpi','2010-08-26 00:51:37',4,'&nbsp;','Desktop'),(5,'Computer',2,'NetworkPort',17,'glpi','2010-08-26 00:52:37',0,'','SSH'),(6,'Computer',2,'Computer',7,'glpi','2010-08-26 01:07:58',0,'','QIN'),(7,'Computer',1,'Computer',7,'glpi','2010-08-26 01:07:58',0,'','METZLER'),(8,'User',2,'',0,'glpi','2010-08-27 02:32:58',17,'','pt_BR'),(9,'Computer',2,'',0,'glpi','2010-08-27 02:43:11',18,'','Num de usuario alternativo'),(10,'Computer',2,'',0,'glpi','2010-08-27 02:43:11',17,'','usuario alternativo'),(11,'Software',1,'SoftwareVersion',17,'glpi','2010-09-09 12:51:28',0,'','Versão2'),(12,'Computer',2,'0',4,'glpi','2010-09-09 12:52:12',0,'','Apache Versão2'),(13,'SoftwareVersion',1,'0',4,'glpi','2010-09-09 12:52:12',0,'','METZLER'),(14,'Software',1,'',0,'glpi','2010-09-09 12:53:51',4,'&nbsp;','Linux');
/*!40000 ALTER TABLE `glpi_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_mailcollectors`
--

DROP TABLE IF EXISTS `glpi_mailcollectors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_mailcollectors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `host` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `login` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filesize_max` int(11) NOT NULL DEFAULT '2097152',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `date_mod` datetime DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `is_active` (`is_active`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_mailcollectors`
--

LOCK TABLES `glpi_mailcollectors` WRITE;
/*!40000 ALTER TABLE `glpi_mailcollectors` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_mailcollectors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_manufacturers`
--

DROP TABLE IF EXISTS `glpi_manufacturers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_manufacturers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_manufacturers`
--

LOCK TABLES `glpi_manufacturers` WRITE;
/*!40000 ALTER TABLE `glpi_manufacturers` DISABLE KEYS */;
INSERT INTO `glpi_manufacturers` VALUES (1,'Apple',''),(2,'Dell',''),(3,'IBM',''),(4,'Intel',''),(5,'Cisco',''),(6,'HP','');
/*!40000 ALTER TABLE `glpi_manufacturers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_monitormodels`
--

DROP TABLE IF EXISTS `glpi_monitormodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_monitormodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_monitormodels`
--

LOCK TABLES `glpi_monitormodels` WRITE;
/*!40000 ALTER TABLE `glpi_monitormodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_monitormodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_monitors`
--

DROP TABLE IF EXISTS `glpi_monitors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_monitors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `contact` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact_num` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `users_id_tech` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `serial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `otherserial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` int(11) NOT NULL DEFAULT '0',
  `have_micro` tinyint(1) NOT NULL DEFAULT '0',
  `have_speaker` tinyint(1) NOT NULL DEFAULT '0',
  `have_subd` tinyint(1) NOT NULL DEFAULT '0',
  `have_bnc` tinyint(1) NOT NULL DEFAULT '0',
  `have_dvi` tinyint(1) NOT NULL DEFAULT '0',
  `have_pivot` tinyint(1) NOT NULL DEFAULT '0',
  `locations_id` int(11) NOT NULL DEFAULT '0',
  `monitortypes_id` int(11) NOT NULL DEFAULT '0',
  `monitormodels_id` int(11) NOT NULL DEFAULT '0',
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `is_global` tinyint(1) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_template` tinyint(1) NOT NULL DEFAULT '0',
  `template_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notepad` longtext COLLATE utf8_unicode_ci,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `groups_id` int(11) NOT NULL DEFAULT '0',
  `states_id` int(11) NOT NULL DEFAULT '0',
  `ticket_tco` decimal(20,4) DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `is_template` (`is_template`),
  KEY `is_global` (`is_global`),
  KEY `entities_id` (`entities_id`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `groups_id` (`groups_id`),
  KEY `users_id` (`users_id`),
  KEY `locations_id` (`locations_id`),
  KEY `monitormodels_id` (`monitormodels_id`),
  KEY `states_id` (`states_id`),
  KEY `users_id_tech` (`users_id_tech`),
  KEY `monitortypes_id` (`monitortypes_id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_monitors`
--

LOCK TABLES `glpi_monitors` WRITE;
/*!40000 ALTER TABLE `glpi_monitors` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_monitors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_monitortypes`
--

DROP TABLE IF EXISTS `glpi_monitortypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_monitortypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_monitortypes`
--

LOCK TABLES `glpi_monitortypes` WRITE;
/*!40000 ALTER TABLE `glpi_monitortypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_monitortypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_netpoints`
--

DROP TABLE IF EXISTS `glpi_netpoints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_netpoints` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `locations_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `complete` (`entities_id`,`locations_id`,`name`),
  KEY `location_name` (`locations_id`,`name`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_netpoints`
--

LOCK TABLES `glpi_netpoints` WRITE;
/*!40000 ALTER TABLE `glpi_netpoints` DISABLE KEYS */;
INSERT INTO `glpi_netpoints` VALUES (1,0,2,'1000001',''),(2,0,2,'1000002','');
/*!40000 ALTER TABLE `glpi_netpoints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_networkequipmentfirmwares`
--

DROP TABLE IF EXISTS `glpi_networkequipmentfirmwares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_networkequipmentfirmwares` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_networkequipmentfirmwares`
--

LOCK TABLES `glpi_networkequipmentfirmwares` WRITE;
/*!40000 ALTER TABLE `glpi_networkequipmentfirmwares` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_networkequipmentfirmwares` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_networkequipmentmodels`
--

DROP TABLE IF EXISTS `glpi_networkequipmentmodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_networkequipmentmodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_networkequipmentmodels`
--

LOCK TABLES `glpi_networkequipmentmodels` WRITE;
/*!40000 ALTER TABLE `glpi_networkequipmentmodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_networkequipmentmodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_networkequipments`
--

DROP TABLE IF EXISTS `glpi_networkequipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_networkequipments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ram` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `serial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `otherserial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact_num` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `users_id_tech` int(11) NOT NULL DEFAULT '0',
  `date_mod` datetime DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `locations_id` int(11) NOT NULL DEFAULT '0',
  `domains_id` int(11) NOT NULL DEFAULT '0',
  `networks_id` int(11) NOT NULL DEFAULT '0',
  `networkequipmenttypes_id` int(11) NOT NULL DEFAULT '0',
  `networkequipmentmodels_id` int(11) NOT NULL DEFAULT '0',
  `networkequipmentfirmwares_id` int(11) NOT NULL DEFAULT '0',
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_template` tinyint(1) NOT NULL DEFAULT '0',
  `template_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mac` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notepad` longtext COLLATE utf8_unicode_ci,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `groups_id` int(11) NOT NULL DEFAULT '0',
  `states_id` int(11) NOT NULL DEFAULT '0',
  `ticket_tco` decimal(20,4) DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `is_template` (`is_template`),
  KEY `domains_id` (`domains_id`),
  KEY `networkequipmentfirmwares_id` (`networkequipmentfirmwares_id`),
  KEY `entities_id` (`entities_id`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `groups_id` (`groups_id`),
  KEY `users_id` (`users_id`),
  KEY `locations_id` (`locations_id`),
  KEY `networkequipmentmodels_id` (`networkequipmentmodels_id`),
  KEY `networks_id` (`networks_id`),
  KEY `states_id` (`states_id`),
  KEY `users_id_tech` (`users_id_tech`),
  KEY `networkequipmenttypes_id` (`networkequipmenttypes_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_networkequipments`
--

LOCK TABLES `glpi_networkequipments` WRITE;
/*!40000 ALTER TABLE `glpi_networkequipments` DISABLE KEYS */;
INSERT INTO `glpi_networkequipments` VALUES (1,0,0,'cat6509-1','4000','999999','000003','','',2,'2010-08-26 00:55:24','',3,0,0,0,0,0,5,0,0,NULL,'00.00.00.00','147.65.14.7',NULL,4,0,1,'0.0000');
/*!40000 ALTER TABLE `glpi_networkequipments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_networkequipmenttypes`
--

DROP TABLE IF EXISTS `glpi_networkequipmenttypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_networkequipmenttypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_networkequipmenttypes`
--

LOCK TABLES `glpi_networkequipmenttypes` WRITE;
/*!40000 ALTER TABLE `glpi_networkequipmenttypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_networkequipmenttypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_networkinterfaces`
--

DROP TABLE IF EXISTS `glpi_networkinterfaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_networkinterfaces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_networkinterfaces`
--

LOCK TABLES `glpi_networkinterfaces` WRITE;
/*!40000 ALTER TABLE `glpi_networkinterfaces` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_networkinterfaces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_networkports`
--

DROP TABLE IF EXISTS `glpi_networkports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_networkports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `items_id` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `logical_number` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mac` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `networkinterfaces_id` int(11) NOT NULL DEFAULT '0',
  `netpoints_id` int(11) NOT NULL DEFAULT '0',
  `netmask` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gateway` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subnet` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `on_device` (`items_id`,`itemtype`),
  KEY `networkinterfaces_id` (`networkinterfaces_id`),
  KEY `netpoints_id` (`netpoints_id`),
  KEY `item` (`itemtype`,`items_id`),
  KEY `entities_id` (`entities_id`),
  KEY `is_recursive` (`is_recursive`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_networkports`
--

LOCK TABLES `glpi_networkports` WRITE;
/*!40000 ALTER TABLE `glpi_networkports` DISABLE KEYS */;
INSERT INTO `glpi_networkports` VALUES (1,1,'Computer',0,0,80,'HTTP','10.10.10.4','12.12.12.12',0,0,'255.255.255.0','10.10.10.1','10.10.10.0'),(2,1,'Computer',0,0,22,'SSH','10.10.10.4','12.12.12.12',0,0,'255.255.255.0','10.10.10.1','10.10.10.0'),(3,2,'Computer',0,0,22,'SSH','10.10.10.4','12.12.12.12',0,0,'255.255.255.0','10.10.10.1','10.10.10.0');
/*!40000 ALTER TABLE `glpi_networkports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_networkports_networkports`
--

DROP TABLE IF EXISTS `glpi_networkports_networkports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_networkports_networkports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `networkports_id_1` int(11) NOT NULL DEFAULT '0',
  `networkports_id_2` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`networkports_id_1`,`networkports_id_2`),
  KEY `networkports_id_2` (`networkports_id_2`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_networkports_networkports`
--

LOCK TABLES `glpi_networkports_networkports` WRITE;
/*!40000 ALTER TABLE `glpi_networkports_networkports` DISABLE KEYS */;
INSERT INTO `glpi_networkports_networkports` VALUES (1,3,2);
/*!40000 ALTER TABLE `glpi_networkports_networkports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_networkports_vlans`
--

DROP TABLE IF EXISTS `glpi_networkports_vlans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_networkports_vlans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `networkports_id` int(11) NOT NULL DEFAULT '0',
  `vlans_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`networkports_id`,`vlans_id`),
  KEY `vlans_id` (`vlans_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_networkports_vlans`
--

LOCK TABLES `glpi_networkports_vlans` WRITE;
/*!40000 ALTER TABLE `glpi_networkports_vlans` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_networkports_vlans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_networks`
--

DROP TABLE IF EXISTS `glpi_networks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_networks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_networks`
--

LOCK TABLES `glpi_networks` WRITE;
/*!40000 ALTER TABLE `glpi_networks` DISABLE KEYS */;
INSERT INTO `glpi_networks` VALUES (1,'netadm',''),(2,'pesq',''),(3,'servidores',''),(4,'alunos','');
/*!40000 ALTER TABLE `glpi_networks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_notifications`
--

DROP TABLE IF EXISTS `glpi_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `event` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `mode` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `notificationtemplates_id` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `date_mod` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `itemtype` (`itemtype`),
  KEY `entities_id` (`entities_id`),
  KEY `is_active` (`is_active`),
  KEY `date_mod` (`date_mod`),
  KEY `is_recursive` (`is_recursive`),
  KEY `notificationtemplates_id` (`notificationtemplates_id`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_notifications`
--

LOCK TABLES `glpi_notifications` WRITE;
/*!40000 ALTER TABLE `glpi_notifications` DISABLE KEYS */;
INSERT INTO `glpi_notifications` VALUES (1,'Alert Tickets not closed',0,'Ticket','alertnotclosed','mail',6,'',1,1,'2010-02-16 16:41:39'),(2,'New Ticket',0,'Ticket','new','mail',4,'',1,1,'2010-02-16 16:41:39'),(3,'Update Ticket',0,'Ticket','update','mail',4,'',1,1,'2010-02-16 16:41:39'),(4,'Close Ticket',0,'Ticket','closed','mail',4,'',1,1,'2010-02-16 16:41:39'),(5,'Add Followup',0,'Ticket','add_followup','mail',4,'',1,1,'2010-02-16 16:41:39'),(6,'Add Task',0,'Ticket','add_task','mail',4,'',1,1,'2010-02-16 16:41:39'),(7,'Update Followup',0,'Ticket','update_followup','mail',4,'',1,1,'2010-02-16 16:41:39'),(8,'Update Task',0,'Ticket','update_task','mail',4,'',1,1,'2010-02-16 16:41:39'),(9,'Delete Followup',0,'Ticket','delete_followup','mail',4,'',1,1,'2010-02-16 16:41:39'),(10,'Delete Task',0,'Ticket','delete_task','mail',4,'',1,1,'2010-02-16 16:41:39'),(11,'Resolve ticket',0,'Ticket','solved','mail',4,'',1,1,'2010-02-16 16:41:39'),(12,'Ticket Validation',0,'Ticket','validation','mail',7,'',1,1,'2010-02-16 16:41:39'),(13,'New Reservation',0,'Reservation','new','mail',2,'',1,1,'2010-02-16 16:41:39'),(14,'Update Reservation',0,'Reservation','update','mail',2,'',1,1,'2010-02-16 16:41:39'),(15,'Delete Reservation',0,'Reservation','delete','mail',2,'',1,1,'2010-02-16 16:41:39'),(16,'Alert Reservation',0,'Reservation','alert','mail',3,'',1,1,'2010-02-16 16:41:39'),(17,'Contract Notice',0,'Contract','notice','mail',12,'',1,1,'2010-02-16 16:41:39'),(18,'Contract End',0,'Contract','end','mail',12,'',1,1,'2010-02-16 16:41:39'),(19,'MySQL Synchronization',0,'DBConnection','desynchronization','mail',1,'',1,1,'2010-02-16 16:41:39'),(20,'Cartridges',0,'Cartridge','alert','mail',8,'',1,1,'2010-02-16 16:41:39'),(21,'Consumables',0,'Consumable','alert','mail',9,'',1,1,'2010-02-16 16:41:39'),(22,'Infocoms',0,'Infocom','alert','mail',10,'',1,1,'2010-02-16 16:41:39'),(23,'Software Licenses',0,'SoftwareLicense','alert','mail',11,'',1,1,'2010-02-16 16:41:39');
/*!40000 ALTER TABLE `glpi_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_notificationtargets`
--

DROP TABLE IF EXISTS `glpi_notificationtargets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_notificationtargets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `items_id` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0',
  `notifications_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `items` (`type`,`items_id`),
  KEY `notifications_id` (`notifications_id`)
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_notificationtargets`
--

LOCK TABLES `glpi_notificationtargets` WRITE;
/*!40000 ALTER TABLE `glpi_notificationtargets` DISABLE KEYS */;
INSERT INTO `glpi_notificationtargets` VALUES (1,3,1,13),(2,1,1,13),(3,3,2,2),(4,1,1,2),(5,1,1,3),(6,1,1,5),(7,1,1,4),(8,2,1,3),(9,4,1,3),(10,3,1,2),(11,3,1,3),(12,3,1,5),(13,3,1,4),(14,1,1,19),(15,14,1,12),(16,3,1,14),(17,1,1,14),(18,3,1,15),(19,1,1,15),(20,1,1,6),(21,3,1,6),(22,1,1,7),(23,3,1,7),(24,1,1,8),(25,3,1,8),(26,1,1,9),(27,3,1,9),(28,1,1,10),(29,3,1,10),(30,1,1,11),(31,3,1,11);
/*!40000 ALTER TABLE `glpi_notificationtargets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_notificationtemplates`
--

DROP TABLE IF EXISTS `glpi_notificationtemplates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_notificationtemplates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `date_mod` datetime DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `itemtype` (`itemtype`),
  KEY `date_mod` (`date_mod`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_notificationtemplates`
--

LOCK TABLES `glpi_notificationtemplates` WRITE;
/*!40000 ALTER TABLE `glpi_notificationtemplates` DISABLE KEYS */;
INSERT INTO `glpi_notificationtemplates` VALUES (1,'MySQL Synchronization','DBConnection','2010-02-01 15:51:46',''),(2,'Reservations','Reservation','2010-02-03 14:03:45',''),(3,'Alert Reservation','Reservation','2010-02-03 14:03:45',''),(4,'Tickets','Ticket','2010-02-07 21:39:15',''),(5,'Tickets (Simple)','Ticket','2010-02-07 21:39:15',''),(6,'Alert Tickets not closed','Ticket','2010-02-07 21:39:15',''),(7,'Tickets Validation','Ticket','2010-02-26 21:39:15',''),(8,'Cartridges','Cartridge','2010-02-16 13:17:24',''),(9,'Consumables','Consumable','2010-02-16 13:17:38',''),(10,'Infocoms','Infocom','2010-02-16 13:17:55',''),(11,'Licenses','SoftwareLicense','2010-02-16 13:18:12',''),(12,'Contracts','Contract','2010-02-16 13:18:12','');
/*!40000 ALTER TABLE `glpi_notificationtemplates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_notificationtemplatetranslations`
--

DROP TABLE IF EXISTS `glpi_notificationtemplatetranslations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_notificationtemplatetranslations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notificationtemplates_id` int(11) NOT NULL DEFAULT '0',
  `language` char(5) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `content_text` text COLLATE utf8_unicode_ci,
  `content_html` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `notificationtemplates_id` (`notificationtemplates_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_notificationtemplatetranslations`
--

LOCK TABLES `glpi_notificationtemplatetranslations` WRITE;
/*!40000 ALTER TABLE `glpi_notificationtemplatetranslations` DISABLE KEYS */;
INSERT INTO `glpi_notificationtemplatetranslations` VALUES (1,1,'','##lang.dbconnection.title##','##lang.dbconnection.delay## : ##dbconnection.delay##\n','&lt;p&gt;##lang.dbconnection.delay## : ##dbconnection.delay##&lt;/p&gt;'),(4,4,'','##ticket.action## ##ticket.title##',' ##IFticket.storestatus=solved##\n ##lang.ticket.url## : ##ticket.urlapprove##\n ##lang.ticket.autoclosewarning##\n ##lang.ticket.solvedate## : ##ticket.solvedate##\n ##lang.ticket.solution.type## : ##ticket.solution.type##\n ##lang.ticket.solution.description## : ##ticket.solution.description## ##ENDIFticket.storestatus##\n ##ELSEticket.storestatus## ##lang.ticket.url## : ##ticket.url## ##ENDELSEticket.storestatus##\n\n ##lang.ticket.description##\n\n ##lang.ticket.title##  :##ticket.title##\n ##lang.ticket.author.name##  :##IFticket.author.name## ##ticket.author.name## ##ENDIFticket.author.name## ##ELSEticket.author.name##--##ENDELSEticket.author.name##\n ##lang.ticket.creationdate##  :##ticket.creationdate##\n ##lang.ticket.closedate##  :##ticket.closedate##\n ##lang.ticket.requesttype##  :##ticket.requesttype##\n##IFticket.itemtype## ##lang.ticket.item.name##  : ##ticket.itemtype## - ##ticket.item.name## ##IFticket.item.model## - ##ticket.item.model## ##ENDIFticket.item.model## ##IFticket.item.serial## -##ticket.item.serial## ##ENDIFticket.item.serial##  ##IFticket.item.otherserial## -##ticket.item.otherserial## ##ENDIFticket.item.otherserial## ##ENDIFticket.itemtype##\n##IFticket.assigntouser## ##lang.ticket.assigntouser##  : ##ticket.assigntouser## ##ENDIFticket.assigntouser##\n ##lang.ticket.status##  : ##ticket.status##\n##IFticket.assigntogroup## ##lang.ticket.assigntogroup##  : ##ticket.assigntogroup## ##ENDIFticket.assigntogroup##\n ##lang.ticket.urgency##  : ##ticket.urgency##\n ##lang.ticket.impact##  : ##ticket.impact##\n ##lang.ticket.priority##  : ##ticket.priority##\n##IFticket.user.email## ##lang.ticket.user.email##  : ##ticket.user.email ##ENDIFticket.user.email##\n##IFticket.category## ##lang.ticket.category##  :##ticket.category## ##ENDIFticket.category## ##ELSEticket.category## ##lang.ticket.nocategoryassigned## ##ENDELSEticket.category##\n ##lang.ticket.content##  : ##ticket.content##\n ##IFticket.storestatus=closed##\n\n ##lang.ticket.solvedate## : ##ticket.solvedate##\n ##lang.ticket.solution.type## : ##ticket.solution.type##\n ##lang.ticket.solution.description## : ##ticket.solution.description##\n ##ENDIFticket.storestatus##\n ##lang.ticket.numberoffollowups## : ##ticket.numberoffollowups##\n\n##FOREACHfollowups##\n\n [##followup.date##] ##lang.followup.isprivate## : ##followup.isprivate##\n ##lang.followup.author## ##followup.author##\n ##lang.followup.description## ##followup.description##\n ##lang.followup.date## ##followup.date##\n ##lang.followup.requesttype## ##followup.requesttype##\n\n##ENDFOREACHfollowups##\n ##lang.ticket.numberoftasks## : ##ticket.numberoftasks##\n\n##FOREACHtasks##\n\n [##task.date##] ##lang.task.isprivate## : ##task.isprivate##\n ##lang.task.author## ##task.author##\n ##lang.task.description## ##task.description##\n ##lang.task.time## ##task.time##\n ##lang.task.category## ##task.category##\n\n##ENDFOREACHtasks##','<!-- description{ color: inherit; background: #ebebeb; border-style: solid;border-color: #8d8d8d; border-width: 0px 1px 1px 0px; }    -->\n<div>##IFticket.storestatus=solved##</div>\n<div>##lang.ticket.url## : <a href=\"##ticket.url##\">##ticket.urlapprove##</a> <strong>&#160;</strong></div>\n<div><strong>##lang.ticket.autoclosewarning##</strong></div>\n<div><span style=\"color: #888888;\"><strong><span style=\"text-decoration: underline;\">##lang.ticket.solvedate##</span></strong></span> : ##ticket.solvedate##<br /><span style=\"text-decoration: underline; color: #888888;\"><strong>##lang.ticket.solution.type##</strong></span> : ##ticket.solution.type##<br /><span style=\"text-decoration: underline; color: #888888;\"><strong>##lang.ticket.solution.description##</strong></span> : ##ticket.solution.description## ##ENDIFticket.storestatus##</div>\n<div>##ELSEticket.storestatus## ##lang.ticket.url## : <a href=\"##ticket.url##\">##ticket.url##</a> ##ENDELSEticket.storestatus##</div>\n<p class=\"description b\"><strong>##lang.ticket.description##</strong></p>\n<p><span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.title##</span>&#160;:##ticket.title## <br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.author.name##</span>&#160;:##IFticket.author.name## ##ticket.author.name## ##ENDIFticket.author.name##    ##ELSEticket.author.name##--##ENDELSEticket.author.name## <br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.creationdate##</span>&#160;:##ticket.creationdate## <br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.closedate##</span>&#160;:##ticket.closedate## <br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.requesttype##</span>&#160;:##ticket.requesttype##<br /> ##IFticket.itemtype## <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.item.name##</span>&#160;: ##ticket.itemtype## - ##ticket.item.name##    ##IFticket.item.model## - ##ticket.item.model##    ##ENDIFticket.item.model## ##IFticket.item.serial## -##ticket.item.serial## ##ENDIFticket.item.serial##&#160; ##IFticket.item.otherserial## -##ticket.item.otherserial##  ##ENDIFticket.item.otherserial## ##ENDIFticket.itemtype## <br /> ##IFticket.assigntouser## <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.assigntouser##</span>&#160;: ##ticket.assigntouser## ##ENDIFticket.assigntouser##<br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\">##lang.ticket.status## </span>&#160;: ##ticket.status##<br /> ##IFticket.assigntogroup## <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.assigntogroup##</span>&#160;: ##ticket.assigntogroup## ##ENDIFticket.assigntogroup##<br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.urgency##</span>&#160;: ##ticket.urgency##<br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.impact##</span>&#160;: ##ticket.impact##<br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.priority##</span>&#160;: ##ticket.priority## <br /> ##IFticket.user.email##<span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.user.email##</span>&#160;: ##ticket.user.email ##ENDIFticket.user.email##    <br /> ##IFticket.category##<span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\">##lang.ticket.category## </span>&#160;:##ticket.category## ##ENDIFticket.category## ##ELSEticket.category## ##lang.ticket.nocategoryassigned## ##ENDELSEticket.category##    <br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.ticket.content##</span>&#160;: ##ticket.content##</p>\n<br />##IFticket.storestatus=closed##<br /><span style=\"text-decoration: underline;\"><strong><span style=\"color: #888888;\">##lang.ticket.solvedate##</span></strong></span> : ##ticket.solvedate##<br /><span style=\"color: #888888;\"><strong><span style=\"text-decoration: underline;\">##lang.ticket.solution.type##</span></strong></span> : ##ticket.solution.type##<br /><span style=\"text-decoration: underline; color: #888888;\"><strong>##lang.ticket.solution.description##</strong></span> : ##ticket.solution.description##<br />##ENDIFticket.storestatus##</p>\n<div class=\"description b\">##lang.ticket.numberoffollowups##&#160;: ##ticket.numberoffollowups##</div>\n<p>##FOREACHfollowups##</p>\n<div class=\"description b\"><br /> <strong> [##followup.date##] <em>##lang.followup.isprivate## : ##followup.isprivate## </em></strong><br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.followup.author## </span> ##followup.author##<br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.followup.description## </span> ##followup.description##<br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.followup.date## </span> ##followup.date##<br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.followup.requesttype## </span> ##followup.requesttype##</div>\n<p>##ENDFOREACHfollowups##</p>\n<div class=\"description b\">##lang.ticket.numberoftasks##&#160;: ##ticket.numberoftasks##</div>\n<p>##FOREACHtasks##</p>\n<div class=\"description b\"><br /> <strong> [##task.date##] <em>##lang.task.isprivate## : ##task.isprivate## </em></strong><br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.task.author##</span> ##task.author##<br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.task.description##</span> ##task.description##<br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.task.time##</span> ##task.time##<br /> <span style=\"color: #8b8c8f; font-weight: bold; text-decoration: underline;\"> ##lang.task.category##</span> ##task.category##</div>\n<p>##ENDFOREACHtasks##</p>');
/*!40000 ALTER TABLE `glpi_notificationtemplatetranslations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_notimportedemails`
--

DROP TABLE IF EXISTS `glpi_notimportedemails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_notimportedemails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` varchar(255) NOT NULL,
  `to` varchar(255) NOT NULL,
  `mailcollectors_id` int(11) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL,
  `subject` text,
  `messageid` varchar(255) NOT NULL,
  `reason` int(11) NOT NULL DEFAULT '0',
  `users_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  KEY `mailcollectors_id` (`mailcollectors_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_notimportedemails`
--

LOCK TABLES `glpi_notimportedemails` WRITE;
/*!40000 ALTER TABLE `glpi_notimportedemails` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_notimportedemails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_ocsadmininfoslinks`
--

DROP TABLE IF EXISTS `glpi_ocsadmininfoslinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_ocsadmininfoslinks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `glpi_column` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ocs_column` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ocsservers_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ocsservers_id` (`ocsservers_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_ocsadmininfoslinks`
--

LOCK TABLES `glpi_ocsadmininfoslinks` WRITE;
/*!40000 ALTER TABLE `glpi_ocsadmininfoslinks` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_ocsadmininfoslinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_ocslinks`
--

DROP TABLE IF EXISTS `glpi_ocslinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_ocslinks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `ocsid` int(11) NOT NULL DEFAULT '0',
  `ocs_deviceid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `use_auto_update` tinyint(1) NOT NULL DEFAULT '1',
  `last_update` datetime DEFAULT NULL,
  `last_ocs_update` datetime DEFAULT NULL,
  `computer_update` longtext COLLATE utf8_unicode_ci,
  `import_device` longtext COLLATE utf8_unicode_ci,
  `import_disk` longtext COLLATE utf8_unicode_ci,
  `import_software` longtext COLLATE utf8_unicode_ci,
  `import_monitor` longtext COLLATE utf8_unicode_ci,
  `import_peripheral` longtext COLLATE utf8_unicode_ci,
  `import_printer` longtext COLLATE utf8_unicode_ci,
  `ocsservers_id` int(11) NOT NULL DEFAULT '0',
  `import_ip` longtext COLLATE utf8_unicode_ci,
  `ocs_agent_version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`ocsservers_id`,`ocsid`),
  KEY `last_update` (`last_update`),
  KEY `ocs_deviceid` (`ocs_deviceid`),
  KEY `last_ocs_update` (`ocsservers_id`,`last_ocs_update`),
  KEY `computers_id` (`computers_id`),
  KEY `use_auto_update` (`use_auto_update`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_ocslinks`
--

LOCK TABLES `glpi_ocslinks` WRITE;
/*!40000 ALTER TABLE `glpi_ocslinks` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_ocslinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_ocsservers`
--

DROP TABLE IF EXISTS `glpi_ocsservers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_ocsservers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ocs_db_user` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ocs_db_passwd` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ocs_db_host` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ocs_db_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `checksum` int(11) NOT NULL DEFAULT '0',
  `import_periph` tinyint(1) NOT NULL DEFAULT '0',
  `import_monitor` tinyint(1) NOT NULL DEFAULT '0',
  `import_software` tinyint(1) NOT NULL DEFAULT '0',
  `import_printer` tinyint(1) NOT NULL DEFAULT '0',
  `import_general_name` tinyint(1) NOT NULL DEFAULT '0',
  `import_general_os` tinyint(1) NOT NULL DEFAULT '0',
  `import_general_serial` tinyint(1) NOT NULL DEFAULT '0',
  `import_general_model` tinyint(1) NOT NULL DEFAULT '0',
  `import_general_manufacturer` tinyint(1) NOT NULL DEFAULT '0',
  `import_general_type` tinyint(1) NOT NULL DEFAULT '0',
  `import_general_domain` tinyint(1) NOT NULL DEFAULT '0',
  `import_general_contact` tinyint(1) NOT NULL DEFAULT '0',
  `import_general_comment` tinyint(1) NOT NULL DEFAULT '0',
  `import_device_processor` tinyint(1) NOT NULL DEFAULT '0',
  `import_device_memory` tinyint(1) NOT NULL DEFAULT '0',
  `import_device_hdd` tinyint(1) NOT NULL DEFAULT '0',
  `import_device_iface` tinyint(1) NOT NULL DEFAULT '0',
  `import_device_gfxcard` tinyint(1) NOT NULL DEFAULT '0',
  `import_device_sound` tinyint(1) NOT NULL DEFAULT '0',
  `import_device_drive` tinyint(1) NOT NULL DEFAULT '0',
  `import_device_port` tinyint(1) NOT NULL DEFAULT '0',
  `import_device_modem` tinyint(1) NOT NULL DEFAULT '0',
  `import_registry` tinyint(1) NOT NULL DEFAULT '0',
  `import_os_serial` tinyint(1) NOT NULL DEFAULT '0',
  `import_ip` tinyint(1) NOT NULL DEFAULT '0',
  `import_disk` tinyint(1) NOT NULL DEFAULT '0',
  `import_monitor_comment` tinyint(1) NOT NULL DEFAULT '0',
  `states_id_default` int(11) NOT NULL DEFAULT '0',
  `tag_limit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tag_exclude` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `use_soft_dict` tinyint(1) NOT NULL DEFAULT '0',
  `cron_sync_number` int(11) DEFAULT '1',
  `deconnection_behavior` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_glpi_link_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `use_ip_to_link` tinyint(1) NOT NULL DEFAULT '0',
  `use_name_to_link` tinyint(1) NOT NULL DEFAULT '0',
  `use_mac_to_link` tinyint(1) NOT NULL DEFAULT '0',
  `use_serial_to_link` tinyint(1) NOT NULL DEFAULT '0',
  `states_id_linkif` int(11) NOT NULL DEFAULT '0',
  `ocs_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_ocsservers`
--

LOCK TABLES `glpi_ocsservers` WRITE;
/*!40000 ALTER TABLE `glpi_ocsservers` DISABLE KEYS */;
INSERT INTO `glpi_ocsservers` VALUES (1,'localhost','ocs','ocs','localhost','ocsweb',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',NULL,0,1,NULL,0,0,0,0,0,0,'',NULL,NULL);
/*!40000 ALTER TABLE `glpi_ocsservers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_operatingsystems`
--

DROP TABLE IF EXISTS `glpi_operatingsystems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_operatingsystems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_operatingsystems`
--

LOCK TABLES `glpi_operatingsystems` WRITE;
/*!40000 ALTER TABLE `glpi_operatingsystems` DISABLE KEYS */;
INSERT INTO `glpi_operatingsystems` VALUES (1,'Linux',''),(2,'Mac OS X',''),(3,'Windows','');
/*!40000 ALTER TABLE `glpi_operatingsystems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_operatingsystemservicepacks`
--

DROP TABLE IF EXISTS `glpi_operatingsystemservicepacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_operatingsystemservicepacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_operatingsystemservicepacks`
--

LOCK TABLES `glpi_operatingsystemservicepacks` WRITE;
/*!40000 ALTER TABLE `glpi_operatingsystemservicepacks` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_operatingsystemservicepacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_operatingsystemversions`
--

DROP TABLE IF EXISTS `glpi_operatingsystemversions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_operatingsystemversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_operatingsystemversions`
--

LOCK TABLES `glpi_operatingsystemversions` WRITE;
/*!40000 ALTER TABLE `glpi_operatingsystemversions` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_operatingsystemversions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_peripheralmodels`
--

DROP TABLE IF EXISTS `glpi_peripheralmodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_peripheralmodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_peripheralmodels`
--

LOCK TABLES `glpi_peripheralmodels` WRITE;
/*!40000 ALTER TABLE `glpi_peripheralmodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_peripheralmodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_peripherals`
--

DROP TABLE IF EXISTS `glpi_peripherals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_peripherals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `contact` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact_num` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `users_id_tech` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `serial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `otherserial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locations_id` int(11) NOT NULL DEFAULT '0',
  `peripheraltypes_id` int(11) NOT NULL DEFAULT '0',
  `peripheralmodels_id` int(11) NOT NULL DEFAULT '0',
  `brand` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `is_global` tinyint(1) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_template` tinyint(1) NOT NULL DEFAULT '0',
  `template_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notepad` longtext COLLATE utf8_unicode_ci,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `groups_id` int(11) NOT NULL DEFAULT '0',
  `states_id` int(11) NOT NULL DEFAULT '0',
  `ticket_tco` decimal(20,4) DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `is_template` (`is_template`),
  KEY `is_global` (`is_global`),
  KEY `entities_id` (`entities_id`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `groups_id` (`groups_id`),
  KEY `users_id` (`users_id`),
  KEY `locations_id` (`locations_id`),
  KEY `peripheralmodels_id` (`peripheralmodels_id`),
  KEY `states_id` (`states_id`),
  KEY `users_id_tech` (`users_id_tech`),
  KEY `peripheraltypes_id` (`peripheraltypes_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_peripherals`
--

LOCK TABLES `glpi_peripherals` WRITE;
/*!40000 ALTER TABLE `glpi_peripherals` DISABLE KEYS */;
INSERT INTO `glpi_peripherals` VALUES (1,0,'iPhone','2010-08-26 02:29:48','','',2,'','','',2,0,0,'',1,0,0,0,NULL,NULL,2,0,1,'0.0000');
/*!40000 ALTER TABLE `glpi_peripherals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_peripheraltypes`
--

DROP TABLE IF EXISTS `glpi_peripheraltypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_peripheraltypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_peripheraltypes`
--

LOCK TABLES `glpi_peripheraltypes` WRITE;
/*!40000 ALTER TABLE `glpi_peripheraltypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_peripheraltypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_phonemodels`
--

DROP TABLE IF EXISTS `glpi_phonemodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_phonemodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_phonemodels`
--

LOCK TABLES `glpi_phonemodels` WRITE;
/*!40000 ALTER TABLE `glpi_phonemodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_phonemodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_phonepowersupplies`
--

DROP TABLE IF EXISTS `glpi_phonepowersupplies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_phonepowersupplies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_phonepowersupplies`
--

LOCK TABLES `glpi_phonepowersupplies` WRITE;
/*!40000 ALTER TABLE `glpi_phonepowersupplies` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_phonepowersupplies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_phones`
--

DROP TABLE IF EXISTS `glpi_phones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_phones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `contact` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact_num` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `users_id_tech` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `serial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `otherserial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `firmware` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locations_id` int(11) NOT NULL DEFAULT '0',
  `phonetypes_id` int(11) NOT NULL DEFAULT '0',
  `phonemodels_id` int(11) NOT NULL DEFAULT '0',
  `brand` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phonepowersupplies_id` int(11) NOT NULL DEFAULT '0',
  `number_line` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `have_headset` tinyint(1) NOT NULL DEFAULT '0',
  `have_hp` tinyint(1) NOT NULL DEFAULT '0',
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `is_global` tinyint(1) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_template` tinyint(1) NOT NULL DEFAULT '0',
  `template_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notepad` longtext COLLATE utf8_unicode_ci,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `groups_id` int(11) NOT NULL DEFAULT '0',
  `states_id` int(11) NOT NULL DEFAULT '0',
  `ticket_tco` decimal(20,4) DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `is_template` (`is_template`),
  KEY `is_global` (`is_global`),
  KEY `entities_id` (`entities_id`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `groups_id` (`groups_id`),
  KEY `users_id` (`users_id`),
  KEY `locations_id` (`locations_id`),
  KEY `phonemodels_id` (`phonemodels_id`),
  KEY `phonepowersupplies_id` (`phonepowersupplies_id`),
  KEY `states_id` (`states_id`),
  KEY `users_id_tech` (`users_id_tech`),
  KEY `phonetypes_id` (`phonetypes_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_phones`
--

LOCK TABLES `glpi_phones` WRITE;
/*!40000 ALTER TABLE `glpi_phones` DISABLE KEYS */;
INSERT INTO `glpi_phones` VALUES (1,0,'Rosa','2010-08-26 02:35:09','','',5,'','','','',2,0,0,'Cisco',0,'',0,1,5,0,0,0,NULL,NULL,4,0,1,'0.0000');
/*!40000 ALTER TABLE `glpi_phones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_phonetypes`
--

DROP TABLE IF EXISTS `glpi_phonetypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_phonetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_phonetypes`
--

LOCK TABLES `glpi_phonetypes` WRITE;
/*!40000 ALTER TABLE `glpi_phonetypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_phonetypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_plugins`
--

DROP TABLE IF EXISTS `glpi_plugins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_plugins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `directory` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0' COMMENT 'see define.php PLUGIN_* constant',
  `author` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `homepage` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`directory`),
  KEY `state` (`state`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_plugins`
--

LOCK TABLES `glpi_plugins` WRITE;
/*!40000 ALTER TABLE `glpi_plugins` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_plugins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_printermodels`
--

DROP TABLE IF EXISTS `glpi_printermodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_printermodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_printermodels`
--

LOCK TABLES `glpi_printermodels` WRITE;
/*!40000 ALTER TABLE `glpi_printermodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_printermodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_printers`
--

DROP TABLE IF EXISTS `glpi_printers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_printers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `contact` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact_num` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `users_id_tech` int(11) NOT NULL DEFAULT '0',
  `serial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `otherserial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `have_serial` tinyint(1) NOT NULL DEFAULT '0',
  `have_parallel` tinyint(1) NOT NULL DEFAULT '0',
  `have_usb` tinyint(1) NOT NULL DEFAULT '0',
  `have_wifi` tinyint(1) NOT NULL DEFAULT '0',
  `have_ethernet` tinyint(1) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `memory_size` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locations_id` int(11) NOT NULL DEFAULT '0',
  `domains_id` int(11) NOT NULL DEFAULT '0',
  `networks_id` int(11) NOT NULL DEFAULT '0',
  `printertypes_id` int(11) NOT NULL DEFAULT '0',
  `printermodels_id` int(11) NOT NULL DEFAULT '0',
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `is_global` tinyint(1) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_template` tinyint(1) NOT NULL DEFAULT '0',
  `template_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `init_pages_counter` int(11) NOT NULL DEFAULT '0',
  `notepad` longtext COLLATE utf8_unicode_ci,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `groups_id` int(11) NOT NULL DEFAULT '0',
  `states_id` int(11) NOT NULL DEFAULT '0',
  `ticket_tco` decimal(20,4) DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `is_template` (`is_template`),
  KEY `is_global` (`is_global`),
  KEY `domains_id` (`domains_id`),
  KEY `entities_id` (`entities_id`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `groups_id` (`groups_id`),
  KEY `users_id` (`users_id`),
  KEY `locations_id` (`locations_id`),
  KEY `printermodels_id` (`printermodels_id`),
  KEY `networks_id` (`networks_id`),
  KEY `states_id` (`states_id`),
  KEY `users_id_tech` (`users_id_tech`),
  KEY `printertypes_id` (`printertypes_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_printers`
--

LOCK TABLES `glpi_printers` WRITE;
/*!40000 ALTER TABLE `glpi_printers` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_printers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_printertypes`
--

DROP TABLE IF EXISTS `glpi_printertypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_printertypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_printertypes`
--

LOCK TABLES `glpi_printertypes` WRITE;
/*!40000 ALTER TABLE `glpi_printertypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_printertypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_profiles`
--

DROP TABLE IF EXISTS `glpi_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `interface` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'helpdesk',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `computer` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `monitor` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `software` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `networking` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `printer` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `peripheral` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cartridge` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `consumable` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notes` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact_enterprise` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `document` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contract` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `infocom` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `knowbase` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `faq` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reservation_helpdesk` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reservation_central` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reports` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ocsng` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `view_ocsng` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sync_ocsng` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dropdown` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity_dropdown` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `device` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `typedoc` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `config` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rule_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity_rule_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rule_ocs` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rule_ldap` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rule_softwarecategories` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `search_config` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `search_config_global` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `check_update` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `profile` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_authtype` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `group` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `transfer` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logs` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reminder_public` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bookmark_public` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `backup` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `create_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delete_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `add_followups` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `group_add_followups` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `global_add_followups` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `global_add_tasks` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `update_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `update_priority` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `own_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `steal_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assign_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `show_all_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `show_assign_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `show_full_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `observe_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `update_followups` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `update_tasks` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `show_planning` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `show_group_planning` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `show_all_planning` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `statistic` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_update` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `helpdesk_hardware` int(11) NOT NULL DEFAULT '0',
  `helpdesk_item_type` text COLLATE utf8_unicode_ci,
  `helpdesk_status` text COLLATE utf8_unicode_ci COMMENT 'json encoded array of from/dest allowed status change',
  `show_group_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `show_group_hardware` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rule_dictionnary_software` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rule_dictionnary_dropdown` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `budget` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `import_externalauth_users` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notification` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rule_mailcollector` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `validate_ticket` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `create_validation` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `interface` (`interface`),
  KEY `is_default` (`is_default`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_profiles`
--

LOCK TABLES `glpi_profiles` WRITE;
/*!40000 ALTER TABLE `glpi_profiles` DISABLE KEYS */;
INSERT INTO `glpi_profiles` VALUES (1,'post-only','helpdesk',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'r','1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1',NULL,'1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1',NULL,NULL,NULL,NULL,NULL,NULL,'1',1,'[\"Computer\",\"Software\",\"Phone\"]',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'normal','central',0,'r','r','r','r','r','r','r','r','r','r','r','r','r','r','r','r','1','r','r',NULL,'r',NULL,NULL,NULL,NULL,'r','r',NULL,NULL,NULL,NULL,NULL,NULL,'w',NULL,'r',NULL,'r','r','r',NULL,NULL,NULL,NULL,NULL,NULL,'1','1','1','0','0','0','0','0','1','0','0','1','1','0','1','0','0','1','0','0','1','1',1,'[\"Computer\",\"Software\",\"Phone\"]',NULL,'0','0',NULL,NULL,'r',NULL,NULL,NULL,NULL,NULL,'1','1'),(3,'admin','central',0,'w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','1','w','r','w','r','w','w','w','w','w','w',NULL,NULL,NULL,NULL,NULL,NULL,'w','w','r','r','w','w','w',NULL,NULL,NULL,NULL,NULL,NULL,'1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1',3,'[\"Computer\",\"Software\",\"Phone\"]',NULL,'0','0',NULL,NULL,'w','w',NULL,NULL,NULL,NULL,'1','1'),(4,'super-admin','central',0,'w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','1','w','r','w','r','w','w','w','w','w','w','w','w','w','w','w','w','w','w','r','w','w','w','w','w','w','r','w','w','w','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1',3,'[\"Computer\",\"Software\",\"Phone\"]',NULL,'0','0','w','w','w','w','w','w',NULL,NULL,'1','1');
/*!40000 ALTER TABLE `glpi_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_profiles_users`
--

DROP TABLE IF EXISTS `glpi_profiles_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_profiles_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `profiles_id` int(11) NOT NULL DEFAULT '0',
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '1',
  `is_dynamic` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entities_id` (`entities_id`),
  KEY `profiles_id` (`profiles_id`),
  KEY `users_id` (`users_id`),
  KEY `is_recursive` (`is_recursive`),
  KEY `is_dynamic` (`is_dynamic`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_profiles_users`
--

LOCK TABLES `glpi_profiles_users` WRITE;
/*!40000 ALTER TABLE `glpi_profiles_users` DISABLE KEYS */;
INSERT INTO `glpi_profiles_users` VALUES (2,2,4,0,1,0),(3,3,1,0,1,0),(4,4,4,0,1,0),(5,5,2,0,1,0);
/*!40000 ALTER TABLE `glpi_profiles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_registrykeys`
--

DROP TABLE IF EXISTS `glpi_registrykeys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_registrykeys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `hive` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ocs_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `computers_id` (`computers_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_registrykeys`
--

LOCK TABLES `glpi_registrykeys` WRITE;
/*!40000 ALTER TABLE `glpi_registrykeys` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_registrykeys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_reminders`
--

DROP TABLE IF EXISTS `glpi_reminders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_reminders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `date` datetime DEFAULT NULL,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `text` text COLLATE utf8_unicode_ci,
  `is_private` tinyint(1) NOT NULL DEFAULT '1',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `begin` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `is_planned` tinyint(1) NOT NULL DEFAULT '0',
  `date_mod` datetime DEFAULT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `date` (`date`),
  KEY `begin` (`begin`),
  KEY `end` (`end`),
  KEY `entities_id` (`entities_id`),
  KEY `users_id` (`users_id`),
  KEY `is_private` (`is_private`),
  KEY `is_recursive` (`is_recursive`),
  KEY `is_planned` (`is_planned`),
  KEY `state` (`state`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_reminders`
--

LOCK TABLES `glpi_reminders` WRITE;
/*!40000 ALTER TABLE `glpi_reminders` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_reminders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_requesttypes`
--

DROP TABLE IF EXISTS `glpi_requesttypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_requesttypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_helpdesk_default` tinyint(1) NOT NULL DEFAULT '0',
  `is_mail_default` tinyint(1) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `is_helpdesk_default` (`is_helpdesk_default`),
  KEY `is_mail_default` (`is_mail_default`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_requesttypes`
--

LOCK TABLES `glpi_requesttypes` WRITE;
/*!40000 ALTER TABLE `glpi_requesttypes` DISABLE KEYS */;
INSERT INTO `glpi_requesttypes` VALUES (1,'Helpdesk',1,0,NULL),(2,'E-Mail',0,1,NULL),(3,'Phone',0,0,NULL),(4,'Direct',0,0,NULL),(5,'Written',0,0,NULL),(6,'Other',0,0,NULL);
/*!40000 ALTER TABLE `glpi_requesttypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_reservationitems`
--

DROP TABLE IF EXISTS `glpi_reservationitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_reservationitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `items_id` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `is_active` (`is_active`),
  KEY `item` (`itemtype`,`items_id`),
  KEY `entities_id` (`entities_id`),
  KEY `is_recursive` (`is_recursive`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_reservationitems`
--

LOCK TABLES `glpi_reservationitems` WRITE;
/*!40000 ALTER TABLE `glpi_reservationitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_reservationitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_reservations`
--

DROP TABLE IF EXISTS `glpi_reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_reservations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reservationitems_id` int(11) NOT NULL DEFAULT '0',
  `begin` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `begin` (`begin`),
  KEY `end` (`end`),
  KEY `reservationitems_id` (`reservationitems_id`),
  KEY `users_id` (`users_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_reservations`
--

LOCK TABLES `glpi_reservations` WRITE;
/*!40000 ALTER TABLE `glpi_reservations` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_ruleactions`
--

DROP TABLE IF EXISTS `glpi_ruleactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_ruleactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `action_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'VALUE IN (assign, regex_result, append_regex_result, affectbyip, affectbyfqdn, affectbymac)',
  `field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_ruleactions`
--

LOCK TABLES `glpi_ruleactions` WRITE;
/*!40000 ALTER TABLE `glpi_ruleactions` DISABLE KEYS */;
INSERT INTO `glpi_ruleactions` VALUES (1,1,'assign','entities_id','0'),(2,2,'assign','entities_id','0'),(3,3,'assign','entities_id','0');
/*!40000 ALTER TABLE `glpi_ruleactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecachecomputermodels`
--

DROP TABLE IF EXISTS `glpi_rulecachecomputermodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecachecomputermodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `manufacturer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecachecomputermodels`
--

LOCK TABLES `glpi_rulecachecomputermodels` WRITE;
/*!40000 ALTER TABLE `glpi_rulecachecomputermodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecachecomputermodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecachecomputertypes`
--

DROP TABLE IF EXISTS `glpi_rulecachecomputertypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecachecomputertypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecachecomputertypes`
--

LOCK TABLES `glpi_rulecachecomputertypes` WRITE;
/*!40000 ALTER TABLE `glpi_rulecachecomputertypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecachecomputertypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecachemanufacturers`
--

DROP TABLE IF EXISTS `glpi_rulecachemanufacturers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecachemanufacturers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecachemanufacturers`
--

LOCK TABLES `glpi_rulecachemanufacturers` WRITE;
/*!40000 ALTER TABLE `glpi_rulecachemanufacturers` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecachemanufacturers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecachemonitormodels`
--

DROP TABLE IF EXISTS `glpi_rulecachemonitormodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecachemonitormodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `manufacturer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecachemonitormodels`
--

LOCK TABLES `glpi_rulecachemonitormodels` WRITE;
/*!40000 ALTER TABLE `glpi_rulecachemonitormodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecachemonitormodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecachemonitortypes`
--

DROP TABLE IF EXISTS `glpi_rulecachemonitortypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecachemonitortypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecachemonitortypes`
--

LOCK TABLES `glpi_rulecachemonitortypes` WRITE;
/*!40000 ALTER TABLE `glpi_rulecachemonitortypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecachemonitortypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecachenetworkequipmentmodels`
--

DROP TABLE IF EXISTS `glpi_rulecachenetworkequipmentmodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecachenetworkequipmentmodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `manufacturer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecachenetworkequipmentmodels`
--

LOCK TABLES `glpi_rulecachenetworkequipmentmodels` WRITE;
/*!40000 ALTER TABLE `glpi_rulecachenetworkequipmentmodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecachenetworkequipmentmodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecachenetworkequipmenttypes`
--

DROP TABLE IF EXISTS `glpi_rulecachenetworkequipmenttypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecachenetworkequipmenttypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecachenetworkequipmenttypes`
--

LOCK TABLES `glpi_rulecachenetworkequipmenttypes` WRITE;
/*!40000 ALTER TABLE `glpi_rulecachenetworkequipmenttypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecachenetworkequipmenttypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecacheoperatingsystems`
--

DROP TABLE IF EXISTS `glpi_rulecacheoperatingsystems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecacheoperatingsystems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecacheoperatingsystems`
--

LOCK TABLES `glpi_rulecacheoperatingsystems` WRITE;
/*!40000 ALTER TABLE `glpi_rulecacheoperatingsystems` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecacheoperatingsystems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecacheoperatingsystemservicepacks`
--

DROP TABLE IF EXISTS `glpi_rulecacheoperatingsystemservicepacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecacheoperatingsystemservicepacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecacheoperatingsystemservicepacks`
--

LOCK TABLES `glpi_rulecacheoperatingsystemservicepacks` WRITE;
/*!40000 ALTER TABLE `glpi_rulecacheoperatingsystemservicepacks` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecacheoperatingsystemservicepacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecacheoperatingsystemversions`
--

DROP TABLE IF EXISTS `glpi_rulecacheoperatingsystemversions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecacheoperatingsystemversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecacheoperatingsystemversions`
--

LOCK TABLES `glpi_rulecacheoperatingsystemversions` WRITE;
/*!40000 ALTER TABLE `glpi_rulecacheoperatingsystemversions` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecacheoperatingsystemversions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecacheperipheralmodels`
--

DROP TABLE IF EXISTS `glpi_rulecacheperipheralmodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecacheperipheralmodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `manufacturer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecacheperipheralmodels`
--

LOCK TABLES `glpi_rulecacheperipheralmodels` WRITE;
/*!40000 ALTER TABLE `glpi_rulecacheperipheralmodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecacheperipheralmodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecacheperipheraltypes`
--

DROP TABLE IF EXISTS `glpi_rulecacheperipheraltypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecacheperipheraltypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecacheperipheraltypes`
--

LOCK TABLES `glpi_rulecacheperipheraltypes` WRITE;
/*!40000 ALTER TABLE `glpi_rulecacheperipheraltypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecacheperipheraltypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecachephonemodels`
--

DROP TABLE IF EXISTS `glpi_rulecachephonemodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecachephonemodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `manufacturer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecachephonemodels`
--

LOCK TABLES `glpi_rulecachephonemodels` WRITE;
/*!40000 ALTER TABLE `glpi_rulecachephonemodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecachephonemodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecachephonetypes`
--

DROP TABLE IF EXISTS `glpi_rulecachephonetypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecachephonetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecachephonetypes`
--

LOCK TABLES `glpi_rulecachephonetypes` WRITE;
/*!40000 ALTER TABLE `glpi_rulecachephonetypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecachephonetypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecacheprintermodels`
--

DROP TABLE IF EXISTS `glpi_rulecacheprintermodels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecacheprintermodels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `manufacturer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecacheprintermodels`
--

LOCK TABLES `glpi_rulecacheprintermodels` WRITE;
/*!40000 ALTER TABLE `glpi_rulecacheprintermodels` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecacheprintermodels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecacheprintertypes`
--

DROP TABLE IF EXISTS `glpi_rulecacheprintertypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecacheprintertypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecacheprintertypes`
--

LOCK TABLES `glpi_rulecacheprintertypes` WRITE;
/*!40000 ALTER TABLE `glpi_rulecacheprintertypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecacheprintertypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecachesoftwares`
--

DROP TABLE IF EXISTS `glpi_rulecachesoftwares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecachesoftwares` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `manufacturer` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `new_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `new_manufacturer` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `ignore_ocs_import` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_helpdesk_visible` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `old_value` (`old_value`),
  KEY `rules_id` (`rules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecachesoftwares`
--

LOCK TABLES `glpi_rulecachesoftwares` WRITE;
/*!40000 ALTER TABLE `glpi_rulecachesoftwares` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_rulecachesoftwares` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulecriterias`
--

DROP TABLE IF EXISTS `glpi_rulecriterias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulecriterias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rules_id` int(11) NOT NULL DEFAULT '0',
  `criteria` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `condition` int(11) NOT NULL DEFAULT '0' COMMENT 'see define.php PATTERN_* and REGEX_* constant',
  `pattern` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rules_id` (`rules_id`),
  KEY `condition` (`condition`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulecriterias`
--

LOCK TABLES `glpi_rulecriterias` WRITE;
/*!40000 ALTER TABLE `glpi_rulecriterias` DISABLE KEYS */;
INSERT INTO `glpi_rulecriterias` VALUES (1,1,'TAG',0,'*'),(2,2,'uid',0,'*'),(3,2,'samaccountname',0,'*'),(4,2,'MAIL_EMAIL',0,'*'),(5,3,'subject',6,'/.*/');
/*!40000 ALTER TABLE `glpi_rulecriterias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rulerightparameters`
--

DROP TABLE IF EXISTS `glpi_rulerightparameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rulerightparameters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rulerightparameters`
--

LOCK TABLES `glpi_rulerightparameters` WRITE;
/*!40000 ALTER TABLE `glpi_rulerightparameters` DISABLE KEYS */;
INSERT INTO `glpi_rulerightparameters` VALUES (1,'(LDAP)Organization','o',''),(2,'(LDAP)Common Name','cn',''),(3,'(LDAP)Department Number','departmentnumber',''),(4,'(LDAP)Email','mail',''),(5,'Object Class','objectclass',''),(6,'(LDAP)User ID','uid',''),(7,'(LDAP)Telephone Number','phone',''),(8,'(LDAP)Employee Number','employeenumber',''),(9,'(LDAP)Manager','manager',''),(10,'(LDAP)DistinguishedName','dn',''),(12,'(AD)User ID','samaccountname',''),(13,'(LDAP) Title','title','');
/*!40000 ALTER TABLE `glpi_rulerightparameters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_rules`
--

DROP TABLE IF EXISTS `glpi_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `sub_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `ranking` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `match` char(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'see define.php *_MATCHING constant',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `comment` text COLLATE utf8_unicode_ci,
  `date_mod` datetime DEFAULT NULL,
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entities_id` (`entities_id`),
  KEY `is_active` (`is_active`),
  KEY `sub_type` (`sub_type`),
  KEY `date_mod` (`date_mod`),
  KEY `is_recursive` (`is_recursive`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_rules`
--

LOCK TABLES `glpi_rules` WRITE;
/*!40000 ALTER TABLE `glpi_rules` DISABLE KEYS */;
INSERT INTO `glpi_rules` VALUES (1,0,'RuleOcs',0,'Root','','AND',1,NULL,NULL,0),(2,0,'RuleRight',1,'Root','','OR',1,NULL,NULL,0),(3,0,'RuleMailCollector',1,'Root','','OR',1,NULL,NULL,0);
/*!40000 ALTER TABLE `glpi_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_softwarecategories`
--

DROP TABLE IF EXISTS `glpi_softwarecategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_softwarecategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_softwarecategories`
--

LOCK TABLES `glpi_softwarecategories` WRITE;
/*!40000 ALTER TABLE `glpi_softwarecategories` DISABLE KEYS */;
INSERT INTO `glpi_softwarecategories` VALUES (1,'FUSION',NULL);
/*!40000 ALTER TABLE `glpi_softwarecategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_softwarelicenses`
--

DROP TABLE IF EXISTS `glpi_softwarelicenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_softwarelicenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `softwares_id` int(11) NOT NULL DEFAULT '0',
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `number` int(11) NOT NULL DEFAULT '0',
  `softwarelicensetypes_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `serial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `otherserial` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `softwareversions_id_buy` int(11) NOT NULL DEFAULT '0',
  `softwareversions_id_use` int(11) NOT NULL DEFAULT '0',
  `expire` date DEFAULT NULL,
  `computers_id` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `serial` (`serial`),
  KEY `otherserial` (`otherserial`),
  KEY `expire` (`expire`),
  KEY `softwareversions_id_buy` (`softwareversions_id_buy`),
  KEY `computers_id` (`computers_id`),
  KEY `entities_id` (`entities_id`),
  KEY `softwares_id` (`softwares_id`),
  KEY `softwarelicensetypes_id` (`softwarelicensetypes_id`),
  KEY `softwareversions_id_use` (`softwareversions_id_use`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_softwarelicenses`
--

LOCK TABLES `glpi_softwarelicenses` WRITE;
/*!40000 ALTER TABLE `glpi_softwarelicenses` DISABLE KEYS */;
INSERT INTO `glpi_softwarelicenses` VALUES (1,1,0,0,-1,2,'OpenSource','','',1,1,NULL,-1,'');
/*!40000 ALTER TABLE `glpi_softwarelicenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_softwarelicensetypes`
--

DROP TABLE IF EXISTS `glpi_softwarelicensetypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_softwarelicensetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_softwarelicensetypes`
--

LOCK TABLES `glpi_softwarelicensetypes` WRITE;
/*!40000 ALTER TABLE `glpi_softwarelicensetypes` DISABLE KEYS */;
INSERT INTO `glpi_softwarelicensetypes` VALUES (1,'OEM',''),(2,'Freeware','');
/*!40000 ALTER TABLE `glpi_softwarelicensetypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_softwares`
--

DROP TABLE IF EXISTS `glpi_softwares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_softwares` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `locations_id` int(11) NOT NULL DEFAULT '0',
  `users_id_tech` int(11) NOT NULL DEFAULT '0',
  `operatingsystems_id` int(11) NOT NULL DEFAULT '0',
  `is_update` tinyint(1) NOT NULL DEFAULT '0',
  `softwares_id` int(11) NOT NULL DEFAULT '0',
  `manufacturers_id` int(11) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_template` tinyint(1) NOT NULL DEFAULT '0',
  `template_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `notepad` longtext COLLATE utf8_unicode_ci,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `groups_id` int(11) NOT NULL DEFAULT '0',
  `ticket_tco` decimal(20,4) DEFAULT '0.0000',
  `is_helpdesk_visible` tinyint(1) NOT NULL DEFAULT '1',
  `softwarecategories_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `date_mod` (`date_mod`),
  KEY `name` (`name`),
  KEY `is_template` (`is_template`),
  KEY `is_update` (`is_update`),
  KEY `softwarecategories_id` (`softwarecategories_id`),
  KEY `entities_id` (`entities_id`),
  KEY `manufacturers_id` (`manufacturers_id`),
  KEY `groups_id` (`groups_id`),
  KEY `users_id` (`users_id`),
  KEY `locations_id` (`locations_id`),
  KEY `operatingsystems_id` (`operatingsystems_id`),
  KEY `users_id_tech` (`users_id_tech`),
  KEY `softwares_id` (`softwares_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_helpdesk_visible` (`is_helpdesk_visible`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_softwares`
--

LOCK TABLES `glpi_softwares` WRITE;
/*!40000 ALTER TABLE `glpi_softwares` DISABLE KEYS */;
INSERT INTO `glpi_softwares` VALUES (1,0,0,'Apache','',1,4,1,0,0,0,0,0,NULL,'2010-09-09 12:53:51',NULL,5,0,'0.0000',1,0);
/*!40000 ALTER TABLE `glpi_softwares` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_softwareversions`
--

DROP TABLE IF EXISTS `glpi_softwareversions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_softwareversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `softwares_id` int(11) NOT NULL DEFAULT '0',
  `states_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `softwares_id` (`softwares_id`),
  KEY `states_id` (`states_id`),
  KEY `entities_id` (`entities_id`),
  KEY `is_recursive` (`is_recursive`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_softwareversions`
--

LOCK TABLES `glpi_softwareversions` WRITE;
/*!40000 ALTER TABLE `glpi_softwareversions` DISABLE KEYS */;
INSERT INTO `glpi_softwareversions` VALUES (1,0,0,1,1,'Versão2','');
/*!40000 ALTER TABLE `glpi_softwareversions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_states`
--

DROP TABLE IF EXISTS `glpi_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_states`
--

LOCK TABLES `glpi_states` WRITE;
/*!40000 ALTER TABLE `glpi_states` DISABLE KEYS */;
INSERT INTO `glpi_states` VALUES (1,'Ativo',''),(2,'Em Mannutencao','');
/*!40000 ALTER TABLE `glpi_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_suppliers`
--

DROP TABLE IF EXISTS `glpi_suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `suppliertypes_id` int(11) NOT NULL DEFAULT '0',
  `address` text COLLATE utf8_unicode_ci,
  `postcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `town` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phonenumber` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `fax` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notepad` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `entities_id` (`entities_id`),
  KEY `suppliertypes_id` (`suppliertypes_id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_suppliers`
--

LOCK TABLES `glpi_suppliers` WRITE;
/*!40000 ALTER TABLE `glpi_suppliers` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_suppliertypes`
--

DROP TABLE IF EXISTS `glpi_suppliertypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_suppliertypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_suppliertypes`
--

LOCK TABLES `glpi_suppliertypes` WRITE;
/*!40000 ALTER TABLE `glpi_suppliertypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_suppliertypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_taskcategories`
--

DROP TABLE IF EXISTS `glpi_taskcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_taskcategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `taskcategories_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `completename` text COLLATE utf8_unicode_ci,
  `comment` text COLLATE utf8_unicode_ci,
  `level` int(11) NOT NULL DEFAULT '0',
  `ancestors_cache` longtext COLLATE utf8_unicode_ci,
  `sons_cache` longtext COLLATE utf8_unicode_ci,
  `is_helpdeskvisible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `taskcategories_id` (`taskcategories_id`),
  KEY `entities_id` (`entities_id`),
  KEY `is_recursive` (`is_recursive`),
  KEY `is_helpdeskvisible` (`is_helpdeskvisible`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_taskcategories`
--

LOCK TABLES `glpi_taskcategories` WRITE;
/*!40000 ALTER TABLE `glpi_taskcategories` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_taskcategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_ticketcategories`
--

DROP TABLE IF EXISTS `glpi_ticketcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_ticketcategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `is_recursive` tinyint(1) NOT NULL DEFAULT '0',
  `ticketcategories_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `completename` text COLLATE utf8_unicode_ci,
  `comment` text COLLATE utf8_unicode_ci,
  `level` int(11) NOT NULL DEFAULT '0',
  `knowbaseitemcategories_id` int(11) NOT NULL DEFAULT '0',
  `users_id` int(11) NOT NULL DEFAULT '0',
  `groups_id` int(11) NOT NULL DEFAULT '0',
  `ancestors_cache` longtext COLLATE utf8_unicode_ci,
  `sons_cache` longtext COLLATE utf8_unicode_ci,
  `is_helpdeskvisible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `ticketcategories_id` (`ticketcategories_id`),
  KEY `entities_id` (`entities_id`),
  KEY `is_recursive` (`is_recursive`),
  KEY `knowbaseitemcategories_id` (`knowbaseitemcategories_id`),
  KEY `users_id` (`users_id`),
  KEY `groups_id` (`groups_id`),
  KEY `is_helpdeskvisible` (`is_helpdeskvisible`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_ticketcategories`
--

LOCK TABLES `glpi_ticketcategories` WRITE;
/*!40000 ALTER TABLE `glpi_ticketcategories` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_ticketcategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_ticketfollowups`
--

DROP TABLE IF EXISTS `glpi_ticketfollowups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_ticketfollowups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tickets_id` int(11) NOT NULL DEFAULT '0',
  `date` datetime DEFAULT NULL,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `content` longtext COLLATE utf8_unicode_ci,
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  `requesttypes_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `date` (`date`),
  KEY `users_id` (`users_id`),
  KEY `tickets_id` (`tickets_id`),
  KEY `is_private` (`is_private`),
  KEY `requesttypes_id` (`requesttypes_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_ticketfollowups`
--

LOCK TABLES `glpi_ticketfollowups` WRITE;
/*!40000 ALTER TABLE `glpi_ticketfollowups` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_ticketfollowups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_ticketplannings`
--

DROP TABLE IF EXISTS `glpi_ticketplannings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_ticketplannings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tickettasks_id` int(11) NOT NULL DEFAULT '0',
  `users_id` int(11) NOT NULL DEFAULT '0',
  `begin` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `state` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `begin` (`begin`),
  KEY `end` (`end`),
  KEY `users_id` (`users_id`),
  KEY `ticketfollowups_id` (`tickettasks_id`),
  KEY `state` (`state`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_ticketplannings`
--

LOCK TABLES `glpi_ticketplannings` WRITE;
/*!40000 ALTER TABLE `glpi_ticketplannings` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_ticketplannings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_tickets`
--

DROP TABLE IF EXISTS `glpi_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `closedate` datetime DEFAULT NULL,
  `solvedate` datetime DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'new',
  `users_id` int(11) NOT NULL DEFAULT '0',
  `users_id_recipient` int(11) NOT NULL DEFAULT '0',
  `groups_id` int(11) NOT NULL DEFAULT '0',
  `requesttypes_id` int(11) NOT NULL DEFAULT '0',
  `users_id_assign` int(11) NOT NULL DEFAULT '0',
  `suppliers_id_assign` int(11) NOT NULL DEFAULT '0',
  `groups_id_assign` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `items_id` int(11) NOT NULL DEFAULT '0',
  `content` longtext COLLATE utf8_unicode_ci,
  `urgency` int(11) NOT NULL DEFAULT '1',
  `impact` int(11) NOT NULL DEFAULT '1',
  `priority` int(11) NOT NULL DEFAULT '1',
  `user_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `use_email_notification` tinyint(1) NOT NULL DEFAULT '0',
  `realtime` float NOT NULL DEFAULT '0',
  `ticketcategories_id` int(11) NOT NULL DEFAULT '0',
  `cost_time` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `cost_fixed` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `cost_material` decimal(20,4) NOT NULL DEFAULT '0.0000',
  `ticketsolutiontypes_id` int(11) NOT NULL DEFAULT '0',
  `solution` text COLLATE utf8_unicode_ci,
  `global_validation` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'accepted',
  PRIMARY KEY (`id`),
  KEY `date` (`date`),
  KEY `closedate` (`closedate`),
  KEY `status` (`status`),
  KEY `priority` (`priority`),
  KEY `request_type` (`requesttypes_id`),
  KEY `date_mod` (`date_mod`),
  KEY `users_id_assign` (`users_id_assign`),
  KEY `groups_id_assign` (`groups_id_assign`),
  KEY `suppliers_id_assign` (`suppliers_id_assign`),
  KEY `users_id` (`users_id`),
  KEY `ticketcategories_id` (`ticketcategories_id`),
  KEY `entities_id` (`entities_id`),
  KEY `groups_id` (`groups_id`),
  KEY `users_id_recipient` (`users_id_recipient`),
  KEY `item` (`itemtype`,`items_id`),
  KEY `solvedate` (`solvedate`),
  KEY `ticketsolutiontypes_id` (`ticketsolutiontypes_id`),
  KEY `urgency` (`urgency`),
  KEY `impact` (`impact`),
  KEY `global_validation` (`global_validation`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_tickets`
--

LOCK TABLES `glpi_tickets` WRITE;
/*!40000 ALTER TABLE `glpi_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_ticketsolutiontypes`
--

DROP TABLE IF EXISTS `glpi_ticketsolutiontypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_ticketsolutiontypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_ticketsolutiontypes`
--

LOCK TABLES `glpi_ticketsolutiontypes` WRITE;
/*!40000 ALTER TABLE `glpi_ticketsolutiontypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_ticketsolutiontypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_tickettasks`
--

DROP TABLE IF EXISTS `glpi_tickettasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_tickettasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tickets_id` int(11) NOT NULL DEFAULT '0',
  `taskcategories_id` int(11) NOT NULL DEFAULT '0',
  `date` datetime DEFAULT NULL,
  `users_id` int(11) NOT NULL DEFAULT '0',
  `content` longtext COLLATE utf8_unicode_ci,
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  `realtime` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `date` (`date`),
  KEY `users_id` (`users_id`),
  KEY `tickets_id` (`tickets_id`),
  KEY `is_private` (`is_private`),
  KEY `taskcategories_id` (`taskcategories_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_tickettasks`
--

LOCK TABLES `glpi_tickettasks` WRITE;
/*!40000 ALTER TABLE `glpi_tickettasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_tickettasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_ticketvalidations`
--

DROP TABLE IF EXISTS `glpi_ticketvalidations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_ticketvalidations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `users_id` int(11) NOT NULL DEFAULT '0',
  `tickets_id` int(11) NOT NULL DEFAULT '0',
  `users_id_validate` int(11) NOT NULL DEFAULT '0',
  `comment_submission` text COLLATE utf8_unicode_ci,
  `comment_validation` text COLLATE utf8_unicode_ci,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'waiting',
  `submission_date` datetime DEFAULT NULL,
  `validation_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `entities_id` (`entities_id`),
  KEY `users_id` (`users_id`),
  KEY `users_id_validate` (`users_id_validate`),
  KEY `tickets_id` (`tickets_id`),
  KEY `submission_date` (`submission_date`),
  KEY `validation_date` (`validation_date`),
  KEY `status` (`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_ticketvalidations`
--

LOCK TABLES `glpi_ticketvalidations` WRITE;
/*!40000 ALTER TABLE `glpi_ticketvalidations` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_ticketvalidations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_transfers`
--

DROP TABLE IF EXISTS `glpi_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_transfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `keep_ticket` int(11) NOT NULL DEFAULT '0',
  `keep_networklink` int(11) NOT NULL DEFAULT '0',
  `keep_reservation` int(11) NOT NULL DEFAULT '0',
  `keep_history` int(11) NOT NULL DEFAULT '0',
  `keep_device` int(11) NOT NULL DEFAULT '0',
  `keep_infocom` int(11) NOT NULL DEFAULT '0',
  `keep_dc_monitor` int(11) NOT NULL DEFAULT '0',
  `clean_dc_monitor` int(11) NOT NULL DEFAULT '0',
  `keep_dc_phone` int(11) NOT NULL DEFAULT '0',
  `clean_dc_phone` int(11) NOT NULL DEFAULT '0',
  `keep_dc_peripheral` int(11) NOT NULL DEFAULT '0',
  `clean_dc_peripheral` int(11) NOT NULL DEFAULT '0',
  `keep_dc_printer` int(11) NOT NULL DEFAULT '0',
  `clean_dc_printer` int(11) NOT NULL DEFAULT '0',
  `keep_supplier` int(11) NOT NULL DEFAULT '0',
  `clean_supplier` int(11) NOT NULL DEFAULT '0',
  `keep_contact` int(11) NOT NULL DEFAULT '0',
  `clean_contact` int(11) NOT NULL DEFAULT '0',
  `keep_contract` int(11) NOT NULL DEFAULT '0',
  `clean_contract` int(11) NOT NULL DEFAULT '0',
  `keep_software` int(11) NOT NULL DEFAULT '0',
  `clean_software` int(11) NOT NULL DEFAULT '0',
  `keep_document` int(11) NOT NULL DEFAULT '0',
  `clean_document` int(11) NOT NULL DEFAULT '0',
  `keep_cartridgeitem` int(11) NOT NULL DEFAULT '0',
  `clean_cartridgeitem` int(11) NOT NULL DEFAULT '0',
  `keep_cartridge` int(11) NOT NULL DEFAULT '0',
  `keep_consumable` int(11) NOT NULL DEFAULT '0',
  `date_mod` datetime DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `date_mod` (`date_mod`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_transfers`
--

LOCK TABLES `glpi_transfers` WRITE;
/*!40000 ALTER TABLE `glpi_transfers` DISABLE KEYS */;
INSERT INTO `glpi_transfers` VALUES (1,'complete',2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,NULL,NULL);
/*!40000 ALTER TABLE `glpi_transfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_usercategories`
--

DROP TABLE IF EXISTS `glpi_usercategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_usercategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_usercategories`
--

LOCK TABLES `glpi_usercategories` WRITE;
/*!40000 ALTER TABLE `glpi_usercategories` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_usercategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_users`
--

DROP TABLE IF EXISTS `glpi_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` char(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mobile` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `realname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `firstname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locations_id` int(11) NOT NULL DEFAULT '0',
  `language` char(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'see define.php CFG_GLPI[language] array',
  `use_mode` int(11) NOT NULL DEFAULT '0',
  `list_limit` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `comment` text COLLATE utf8_unicode_ci,
  `auths_id` int(11) NOT NULL DEFAULT '0',
  `authtype` int(11) NOT NULL DEFAULT '0',
  `last_login` datetime DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `profiles_id` int(11) NOT NULL DEFAULT '0',
  `entities_id` int(11) NOT NULL DEFAULT '0',
  `usertitles_id` int(11) NOT NULL DEFAULT '0',
  `usercategories_id` int(11) NOT NULL DEFAULT '0',
  `date_format` int(11) DEFAULT NULL,
  `number_format` int(11) DEFAULT NULL,
  `is_ids_visible` tinyint(1) DEFAULT NULL,
  `dropdown_chars_limit` int(11) DEFAULT NULL,
  `use_flat_dropdowntree` tinyint(1) DEFAULT NULL,
  `show_jobs_at_login` tinyint(1) DEFAULT NULL,
  `priority_1` char(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority_2` char(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority_3` char(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority_4` char(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority_5` char(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority_6` char(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_categorized_soft_expanded` tinyint(1) DEFAULT NULL,
  `is_not_categorized_soft_expanded` tinyint(1) DEFAULT NULL,
  `followup_private` tinyint(1) DEFAULT NULL,
  `task_private` tinyint(1) DEFAULT NULL,
  `default_requesttypes_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unicity` (`name`),
  KEY `firstname` (`firstname`),
  KEY `realname` (`realname`),
  KEY `entities_id` (`entities_id`),
  KEY `profiles_id` (`profiles_id`),
  KEY `locations_id` (`locations_id`),
  KEY `usertitles_id` (`usertitles_id`),
  KEY `usercategories_id` (`usercategories_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_active` (`is_active`),
  KEY `date_mod` (`date_mod`),
  KEY `authitem` (`authtype`,`auths_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_users`
--

LOCK TABLES `glpi_users` WRITE;
/*!40000 ALTER TABLE `glpi_users` DISABLE KEYS */;
INSERT INTO `glpi_users` VALUES (2,'glpi','0915bd0a5c6e56d8f38ca2b390857d4949073f41','','','','','',NULL,0,'pt_BR',0,20,1,NULL,0,1,'2010-08-27 02:32:13','2010-08-27 02:32:58',0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'post-only','3177926a7314de24680a9938aaa97703','','','','','',NULL,0,NULL,0,20,1,NULL,0,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,'tech','d9f9133fb120cd6096870bc2b496805b','','','','','',NULL,0,NULL,0,20,1,NULL,0,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,'normal','fea087517c26fadd409bd4b9dc642555','','','','','',NULL,0,NULL,0,20,1,NULL,0,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `glpi_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_usertitles`
--

DROP TABLE IF EXISTS `glpi_usertitles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_usertitles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_usertitles`
--

LOCK TABLES `glpi_usertitles` WRITE;
/*!40000 ALTER TABLE `glpi_usertitles` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_usertitles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_vlans`
--

DROP TABLE IF EXISTS `glpi_vlans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_vlans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_vlans`
--

LOCK TABLES `glpi_vlans` WRITE;
/*!40000 ALTER TABLE `glpi_vlans` DISABLE KEYS */;
/*!40000 ALTER TABLE `glpi_vlans` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-09-10 17:41:53
