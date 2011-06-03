-- MySQL dump 10.11
--
-- Host: localhost    Database: glpi
-- ------------------------------------------------------
-- Server version	5.0.51a-24+lenny4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES latin1 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `prioridade`
--

DROP TABLE IF EXISTS `prioridade`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `prioridade` (
  `prioridade` int(11) NOT NULL,
  `tempo` int(11) NOT NULL,
  `descricao` varchar(11) NOT NULL,
  PRIMARY KEY  (`prioridade`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `prioridade`
--

LOCK TABLES `prioridade` WRITE;
/*!40000 ALTER TABLE `prioridade` DISABLE KEYS */;
INSERT INTO `prioridade` VALUES (1,16,'Muito Baixa'),(2,12,'Baixa'),(3,10,'Media'),(4,6,'Alta'),(5,2,'Muito Alta');
/*!40000 ALTER TABLE `prioridade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocorabertas`
--

DROP TABLE IF EXISTS `ocorabertas`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ocorabertas` (
  `ID` int(11) NOT NULL,
  `entidade` varchar(50) NOT NULL,
  `titulo` varchar(50) NOT NULL,
  `solicitante` varchar(50) NOT NULL,
  `dataabertura` datetime NOT NULL,
  `dataultatualiz` datetime NOT NULL,
  `datavencsla` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `ocorabertas`
--

LOCK TABLES `ocorabertas` WRITE;
/*!40000 ALTER TABLE `ocorabertas` DISABLE KEYS */;
INSERT INTO `ocorabertas` VALUES (1264,'VERTO > ESCRITORIO BARRA','Testes de conectividade câmera Av.Brasil','Tecyr Lima','2011-04-26 12:07:00','2011-05-30 14:06:57','0000-00-00 00:00:00'),(1456,'VERTO > ESCRITORIO BARRA','Problema Sap','Tiago Duarte','2011-05-31 17:23:00','2011-06-01 15:19:54','0000-00-00 00:00:00'),(1463,'VERTO > ESCRITORIO BARRA','Formatar e recuperar emails do colaborador Cléber','Cléber Reis','2011-06-01 14:42:00','2011-06-01 15:24:08','0000-00-00 00:00:00'),(1461,'VERTO > ESCRITORIO BARRA','usuário solicitou instalação Instalação de Softwar','Paulo Henrique Silva','2011-06-01 11:41:00','2011-06-01 11:50:02','0000-00-00 00:00:00'),(1462,'VERTO > ESCRITORIO CENTRO','Usuário com problemas em acessar o Site da Oracle.','Ravenal Moraes','2011-06-01 13:14:00','2011-06-01 13:25:36','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `ocorabertas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-06-01 18:39:46
