-- MySQL dump 10.16  Distrib 10.1.48-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 10.240.0.2    Database: __glisweb__
-- ------------------------------------------------------
-- Server version	5.5.62-0+deb8u1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `__acl_anagrafica__`
--

DROP TABLE IF EXISTS `__acl_anagrafica__`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__acl_anagrafica__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_entita` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  `id_account` int(11) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_entita` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita_2` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_anagrafica___ibfk_1_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_anagrafica___ibfk_2_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_anagrafica___ibfk_3_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `__acl_attivita__`
--

DROP TABLE IF EXISTS `__acl_attivita__`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__acl_attivita__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_entita` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  `id_account` int(11) DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_entita` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_attivita___ibfk_1` FOREIGN KEY (`id_entita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_attivita___ibfk_1_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_attivita___ibfk_2` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `__etichette_anagrafica__`
--

DROP TABLE IF EXISTS `__etichette_anagrafica__`;
/*!50001 DROP VIEW IF EXISTS `__etichette_anagrafica__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__etichette_anagrafica__` (
  `id` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `denominazione_fiscale` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_analisi_immobiliare__`
--

DROP TABLE IF EXISTS `__report_analisi_immobiliare__`;
/*!50001 DROP VIEW IF EXISTS `__report_analisi_immobiliare__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_analisi_immobiliare__` (
  `id_agente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `notizie` tinyint NOT NULL,
  `sviluppi` tinyint NOT NULL,
  `valutazioni` tinyint NOT NULL,
  `incarichi` tinyint NOT NULL,
  `vendite` tinyint NOT NULL,
  `settimana` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `visioni` tinyint NOT NULL,
  `contatti` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_attivita__`
--

DROP TABLE IF EXISTS `__report_attivita__`;
/*!50001 DROP VIEW IF EXISTS `__report_attivita__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_attivita__` (
  `agente` tinyint NOT NULL,
  `attivita` tinyint NOT NULL,
  `settimana` tinyint NOT NULL,
  `anno` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `__report_attivita_assenze__`
--

DROP TABLE IF EXISTS `__report_attivita_assenze__`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__report_attivita_assenze__` (
  `id_attivita` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_assenza` date NOT NULL,
  UNIQUE KEY `unico` (`id_attivita`,`id_anagrafica`,`data_assenza`),
  KEY `id_attivita` (`id_attivita`),
  KEY `id_anagrafica` (`id_anagrafica`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `__report_attivita_immobiliare__`
--

DROP TABLE IF EXISTS `__report_attivita_immobiliare__`;
/*!50001 DROP VIEW IF EXISTS `__report_attivita_immobiliare__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_attivita_immobiliare__` (
  `id_agente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `visioni` tinyint NOT NULL,
  `contatti` tinyint NOT NULL,
  `settimana` tinyint NOT NULL,
  `anno` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_censimento_immobili__`
--

DROP TABLE IF EXISTS `__report_censimento_immobili__`;
/*!50001 DROP VIEW IF EXISTS `__report_censimento_immobili__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_censimento_immobili__` (
  `agente` tinyint NOT NULL,
  `immobili` tinyint NOT NULL,
  `settimana` tinyint NOT NULL,
  `anno` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_fatturati_totali_annui__`
--

DROP TABLE IF EXISTS `__report_fatturati_totali_annui__`;
/*!50001 DROP VIEW IF EXISTS `__report_fatturati_totali_annui__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_fatturati_totali_annui__` (
  `id_cliente` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `mandante` tinyint NOT NULL,
  `emittente` tinyint NOT NULL,
  `totale` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_fatturati_totali_mensili__`
--

DROP TABLE IF EXISTS `__report_fatturati_totali_mensili__`;
/*!50001 DROP VIEW IF EXISTS `__report_fatturati_totali_mensili__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_fatturati_totali_mensili__` (
  `anno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `mandante` tinyint NOT NULL,
  `totale` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_giacenza_mastri__`
--

DROP TABLE IF EXISTS `__report_giacenza_mastri__`;
/*!50001 DROP VIEW IF EXISTS `__report_giacenza_mastri__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_giacenza_mastri__` (
  `id` tinyint NOT NULL,
  `mastro` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `matricola` tinyint NOT NULL,
  `id_matricola` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `id_todo` tinyint NOT NULL,
  `id_destinatario` tinyint NOT NULL,
  `quantita_totale` tinyint NOT NULL,
  `importo_totale` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_giacenza_mastri_orari__`
--

DROP TABLE IF EXISTS `__report_giacenza_mastri_orari__`;
/*!50001 DROP VIEW IF EXISTS `__report_giacenza_mastri_orari__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_giacenza_mastri_orari__` (
  `id` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `ore` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_giornaliero_analisi_immobiliare__`
--

DROP TABLE IF EXISTS `__report_giornaliero_analisi_immobiliare__`;
/*!50001 DROP VIEW IF EXISTS `__report_giornaliero_analisi_immobiliare__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_giornaliero_analisi_immobiliare__` (
  `id_agente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `agenzia` tinyint NOT NULL,
  `notizie` tinyint NOT NULL,
  `sviluppi` tinyint NOT NULL,
  `valutazioni` tinyint NOT NULL,
  `incarichi` tinyint NOT NULL,
  `vendite` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `visioni` tinyint NOT NULL,
  `contatti` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_giornaliero_attivita_immobiliare__`
--

DROP TABLE IF EXISTS `__report_giornaliero_attivita_immobiliare__`;
/*!50001 DROP VIEW IF EXISTS `__report_giornaliero_attivita_immobiliare__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_giornaliero_attivita_immobiliare__` (
  `id_agente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `agenzia` tinyint NOT NULL,
  `visioni` tinyint NOT NULL,
  `contatti` tinyint NOT NULL,
  `giorno` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_giornaliero_immobiliare__`
--

DROP TABLE IF EXISTS `__report_giornaliero_immobiliare__`;
/*!50001 DROP VIEW IF EXISTS `__report_giornaliero_immobiliare__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_giornaliero_immobiliare__` (
  `id_agente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `agenzia` tinyint NOT NULL,
  `notizie` tinyint NOT NULL,
  `sviluppi` tinyint NOT NULL,
  `valutazioni` tinyint NOT NULL,
  `incarichi` tinyint NOT NULL,
  `vendite` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `visioni` tinyint NOT NULL,
  `contatti` tinyint NOT NULL,
  `immobili` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_giornaliero_incarichi_immobili_immobiliare__`
--

DROP TABLE IF EXISTS `__report_giornaliero_incarichi_immobili_immobiliare__`;
/*!50001 DROP VIEW IF EXISTS `__report_giornaliero_incarichi_immobili_immobiliare__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_giornaliero_incarichi_immobili_immobiliare__` (
  `id_agente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `agenzia` tinyint NOT NULL,
  `notizie` tinyint NOT NULL,
  `sviluppi` tinyint NOT NULL,
  `valutazioni` tinyint NOT NULL,
  `incarichi` tinyint NOT NULL,
  `vendite` tinyint NOT NULL,
  `giorno` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_giornaliero_inserimento_immobili__`
--

DROP TABLE IF EXISTS `__report_giornaliero_inserimento_immobili__`;
/*!50001 DROP VIEW IF EXISTS `__report_giornaliero_inserimento_immobili__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_giornaliero_inserimento_immobili__` (
  `id_agente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `agenzia` tinyint NOT NULL,
  `immobili` tinyint NOT NULL,
  `giorno` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_immagini_da_scalare__`
--

DROP TABLE IF EXISTS `__report_immagini_da_scalare__`;
/*!50001 DROP VIEW IF EXISTS `__report_immagini_da_scalare__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_immagini_da_scalare__` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_file` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `id_evento` tinyint NOT NULL,
  `id_categoria_eventi` tinyint NOT NULL,
  `id_notizia` tinyint NOT NULL,
  `id_categoria_notizie` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `id_zona` tinyint NOT NULL,
  `orientamento` tinyint NOT NULL,
  `path` tinyint NOT NULL,
  `path_alternativo` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_ruolo` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `taglio` tinyint NOT NULL,
  `timestamp_scalamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_immagini_scalate__`
--

DROP TABLE IF EXISTS `__report_immagini_scalate__`;
/*!50001 DROP VIEW IF EXISTS `__report_immagini_scalate__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_immagini_scalate__` (
  `scalate` tinyint NOT NULL,
  `da_scalare` tinyint NOT NULL,
  `totali` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_incarichi_immobili__`
--

DROP TABLE IF EXISTS `__report_incarichi_immobili__`;
/*!50001 DROP VIEW IF EXISTS `__report_incarichi_immobili__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_incarichi_immobili__` (
  `agente` tinyint NOT NULL,
  `notizie` tinyint NOT NULL,
  `settimana` tinyint NOT NULL,
  `anno` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_incarichi_immobili_immobiliare__`
--

DROP TABLE IF EXISTS `__report_incarichi_immobili_immobiliare__`;
/*!50001 DROP VIEW IF EXISTS `__report_incarichi_immobili_immobiliare__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_incarichi_immobili_immobiliare__` (
  `id_agente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `notizie` tinyint NOT NULL,
  `sviluppi` tinyint NOT NULL,
  `valutazioni` tinyint NOT NULL,
  `incarichi` tinyint NOT NULL,
  `vendite` tinyint NOT NULL,
  `settimana` tinyint NOT NULL,
  `anno` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_ingombri_prodotti__`
--

DROP TABLE IF EXISTS `__report_ingombri_prodotti__`;
/*!50001 DROP VIEW IF EXISTS `__report_ingombri_prodotti__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_ingombri_prodotti__` (
  `id` tinyint NOT NULL,
  `id_ingombro` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_lead_generation__`
--

DROP TABLE IF EXISTS `__report_lead_generation__`;
/*!50001 DROP VIEW IF EXISTS `__report_lead_generation__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_lead_generation__` (
  `agente` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `lead` tinyint NOT NULL,
  `settimana` tinyint NOT NULL,
  `anno` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_mastri__`
--

DROP TABLE IF EXISTS `__report_mastri__`;
/*!50001 DROP VIEW IF EXISTS `__report_mastri__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_mastri__` (
  `id` tinyint NOT NULL,
  `mastro` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `emittente` tinyint NOT NULL,
  `id_riga` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `quantita` tinyint NOT NULL,
  `importo` tinyint NOT NULL,
  `listino` tinyint NOT NULL,
  `data_lavorazione` tinyint NOT NULL,
  `id_destinatario` tinyint NOT NULL,
  `id_emittente` tinyint NOT NULL,
  `id_listino` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `id_todo` tinyint NOT NULL,
  `id_matricola` tinyint NOT NULL,
  `matricola` tinyint NOT NULL,
  `todo` tinyint NOT NULL,
  `progetto` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_mastri_orari__`
--

DROP TABLE IF EXISTS `__report_mastri_orari__`;
/*!50001 DROP VIEW IF EXISTS `__report_mastri_orari__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_mastri_orari__` (
  `id` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `id_attivita` tinyint NOT NULL,
  `nome_attivita` tinyint NOT NULL,
  `ore` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `id_todo` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `data` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_notizie_immobili__`
--

DROP TABLE IF EXISTS `__report_notizie_immobili__`;
/*!50001 DROP VIEW IF EXISTS `__report_notizie_immobili__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_notizie_immobili__` (
  `agente` tinyint NOT NULL,
  `notizie` tinyint NOT NULL,
  `settimana` tinyint NOT NULL,
  `anno` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_ore_busta__`
--

DROP TABLE IF EXISTS `__report_ore_busta__`;
/*!50001 DROP VIEW IF EXISTS `__report_ore_busta__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_ore_busta__` (
  `data` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `persona` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_tipologia_base` tinyint NOT NULL,
  `ore_somma` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `__report_ore_clienti__`
--

DROP TABLE IF EXISTS `__report_ore_clienti__`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__report_ore_clienti__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mese` int(11) NOT NULL,
  `anno` int(11) NOT NULL,
  `id_job` int(11) DEFAULT NULL,
  `id_cliente` int(11) NOT NULL,
  `ore_previste` decimal(5,2) DEFAULT NULL,
  `ore_fatte` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mese` (`mese`),
  KEY `anno` (`anno`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_job` (`id_job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `__report_ore_operatori__`
--

DROP TABLE IF EXISTS `__report_ore_operatori__`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__report_ore_operatori__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mese` int(11) NOT NULL,
  `anno` int(11) NOT NULL,
  `id_job` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `ore_contratto` decimal(5,2) DEFAULT NULL,
  `ore_fatte` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mese` (`mese`),
  KEY `anno` (`anno`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_job` (`id_job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `__report_ore_operatori_per_cliente__`
--

DROP TABLE IF EXISTS `__report_ore_operatori_per_cliente__`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__report_ore_operatori_per_cliente__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mese` int(11) NOT NULL,
  `anno` int(11) NOT NULL,
  `id_job` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `ore_contratto` decimal(5,2) DEFAULT NULL,
  `ore_fatte` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mese` (`mese`),
  KEY `anno` (`anno`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_job` (`id_job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `__report_ore_operatori_per_progetto__`
--

DROP TABLE IF EXISTS `__report_ore_operatori_per_progetto__`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__report_ore_operatori_per_progetto__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mese` int(11) NOT NULL,
  `anno` int(11) NOT NULL,
  `id_job` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `ore_contratto` decimal(5,2) DEFAULT NULL,
  `ore_fatte` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mese` (`mese`),
  KEY `anno` (`anno`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_job` (`id_job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `__report_ore_previste__`
--

DROP TABLE IF EXISTS `__report_ore_previste__`;
/*!50001 DROP VIEW IF EXISTS `__report_ore_previste__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_ore_previste__` (
  `anno_previsto` tinyint NOT NULL,
  `settimana_prevista` tinyint NOT NULL,
  `id_responsabile` tinyint NOT NULL,
  `ore` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_ore_previste_per_cliente__`
--

DROP TABLE IF EXISTS `__report_ore_previste_per_cliente__`;
/*!50001 DROP VIEW IF EXISTS `__report_ore_previste_per_cliente__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_ore_previste_per_cliente__` (
  `cliente` tinyint NOT NULL,
  `crm` tinyint NOT NULL,
  `totale_ore_previste` tinyint NOT NULL,
  `totale_ore_lavorate` tinyint NOT NULL,
  `totale_ore_da_fare` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `__report_ore_progetti__`
--

DROP TABLE IF EXISTS `__report_ore_progetti__`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__report_ore_progetti__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mese` int(11) NOT NULL,
  `anno` int(11) NOT NULL,
  `id_job` int(11) DEFAULT NULL,
  `id_progetto` char(32) NOT NULL,
  `ore_previste` decimal(5,2) DEFAULT NULL,
  `ore_fatte` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mese` (`mese`),
  KEY `anno` (`anno`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_job` (`id_job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `__report_ore_progetti_tipologie_mastri__`
--

DROP TABLE IF EXISTS `__report_ore_progetti_tipologie_mastri__`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__report_ore_progetti_tipologie_mastri__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mese` int(11) NOT NULL,
  `anno` int(11) NOT NULL,
  `id_job` int(11) DEFAULT NULL,
  `id_progetto` char(32) NOT NULL,
  `id_tipologia_attivita` int(11) DEFAULT NULL,
  `id_mastro` int(11) DEFAULT NULL,
  `ore_previste` decimal(5,2) DEFAULT NULL,
  `ore_fatte` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mese` (`mese`),
  KEY `anno` (`anno`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_job` (`id_job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `__report_ore_residue__`
--

DROP TABLE IF EXISTS `__report_ore_residue__`;
/*!50001 DROP VIEW IF EXISTS `__report_ore_residue__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_ore_residue__` (
  `id` tinyint NOT NULL,
  `ore_previste` tinyint NOT NULL,
  `ore_fatte` tinyint NOT NULL,
  `ore_residue` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `__report_progetti_assenze__`
--

DROP TABLE IF EXISTS `__report_progetti_assenze__`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__report_progetti_assenze__` (
  `id_progetto` char(32) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_assenza` date NOT NULL,
  UNIQUE KEY `unico` (`id_progetto`,`id_anagrafica`,`data_assenza`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_anagrafica` (`id_anagrafica`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `__report_progetti_sostituti__`
--

DROP TABLE IF EXISTS `__report_progetti_sostituti__`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__report_progetti_sostituti__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_progetto` char(32) NOT NULL,
  `data_scopertura` date NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `punteggio` int(11) DEFAULT NULL,
  `punti_sostituto` int(11) DEFAULT NULL,
  `punti_progetto` int(11) DEFAULT NULL,
  `punti_copertura` int(11) DEFAULT NULL,
  `punti_distanza` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_progetto`,`data_scopertura`,`id_anagrafica`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `punti_sostituto` (`punti_sostituto`),
  KEY `data_scopertura` (`data_scopertura`),
  KEY `punteggio` (`punteggio`),
  KEY `punti_progetto` (`punti_progetto`),
  KEY `punti_copertura` (`punti_copertura`),
  KEY `punti_distanza` (`punti_distanza`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `__report_promemoria__`
--

DROP TABLE IF EXISTS `__report_promemoria__`;
/*!50001 DROP VIEW IF EXISTS `__report_promemoria__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_promemoria__` (
  `agente` tinyint NOT NULL,
  `attivita` tinyint NOT NULL,
  `settimana` tinyint NOT NULL,
  `anno` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_righe_fatturati_totali_annui__`
--

DROP TABLE IF EXISTS `__report_righe_fatturati_totali_annui__`;
/*!50001 DROP VIEW IF EXISTS `__report_righe_fatturati_totali_annui__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_righe_fatturati_totali_annui__` (
  `id_cliente` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `mandante` tinyint NOT NULL,
  `emittente` tinyint NOT NULL,
  `totale` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_righe_fatturati_totali_mensili__`
--

DROP TABLE IF EXISTS `__report_righe_fatturati_totali_mensili__`;
/*!50001 DROP VIEW IF EXISTS `__report_righe_fatturati_totali_mensili__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_righe_fatturati_totali_mensili__` (
  `anno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `mandante` tinyint NOT NULL,
  `totale` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `__report_sostituzioni_attivita__`
--

DROP TABLE IF EXISTS `__report_sostituzioni_attivita__`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__report_sostituzioni_attivita__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_attivita` char(32) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `punteggio` int(11) DEFAULT NULL,
  `punti_sostituto` int(11) DEFAULT NULL,
  `punti_progetto` int(11) DEFAULT NULL,
  `punti_disponibilita` int(11) DEFAULT NULL,
  `punti_distanza` int(11) DEFAULT NULL,
  `se_scartato` int(1) DEFAULT NULL,
  `se_convocato` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_attivita`,`id_anagrafica`),
  KEY `id_attivita` (`id_attivita`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `punteggio` (`punteggio`),
  KEY `punti_sostituto` (`punti_sostituto`),
  KEY `punti_progetto` (`punti_progetto`),
  KEY `punti_disponibilita` (`punti_disponibilita`),
  KEY `punti_distanza` (`punti_distanza`),
  KEY `se_scartato` (`se_scartato`),
  KEY `se_convocato` (`se_convocato`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `__report_sviluppi_immobili__`
--

DROP TABLE IF EXISTS `__report_sviluppi_immobili__`;
/*!50001 DROP VIEW IF EXISTS `__report_sviluppi_immobili__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_sviluppi_immobili__` (
  `agente` tinyint NOT NULL,
  `sviluppi` tinyint NOT NULL,
  `settimana` tinyint NOT NULL,
  `anno` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `__report_volontari_pratiche__`
--

DROP TABLE IF EXISTS `__report_volontari_pratiche__`;
/*!50001 DROP VIEW IF EXISTS `__report_volontari_pratiche__`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `__report_volontari_pratiche__` (
  `sede` tinyint NOT NULL,
  `volontario` tinyint NOT NULL,
  `categoria` tinyint NOT NULL,
  `pratiche` tinyint NOT NULL,
  `pratiche di cui è responsabile` tinyint NOT NULL,
  `pratiche aperte` tinyint NOT NULL,
  `pratiche chiuse` tinyint NOT NULL,
  `pratiche aperte prima del 2019` tinyint NOT NULL,
  `pratiche aperte nel 2019` tinyint NOT NULL,
  `pratiche aperte nel 2020` tinyint NOT NULL,
  `pratiche aperte nel 2021` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_mail` int(11) DEFAULT NULL,
  `username` char(64) NOT NULL,
  `password` char(128) DEFAULT NULL,
  `se_attivo` int(1) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_login` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_cambio_password` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `se_attivo` (`se_attivo`),
  KEY `indice` (`id`,`id_anagrafica`,`username`,`password`,`se_attivo`,`token`),
  KEY `id_mail` (`id_mail`),
  CONSTRAINT `account_ibfk_1_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `account_ibfk_3_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `account_ibfk_4_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `account_gruppi`
--

DROP TABLE IF EXISTS `account_gruppi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_gruppi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_account` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  `se_amministratore` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `indice` (`id_account`,`id_gruppo`),
  KEY `id_account` (`id_account`),
  KEY `id_gruppo` (`id_gruppo`),
  CONSTRAINT `account_gruppi_ibfk_1` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_gruppi_ibfk_2_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `account_gruppi_attribuzione`
--

DROP TABLE IF EXISTS `account_gruppi_attribuzione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_gruppi_attribuzione` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_account` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  `entita` char(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `indice` (`id_account`,`id_gruppo`,`entita`),
  KEY `id_account` (`id_account`),
  KEY `id_gruppo` (`id_gruppo`),
  CONSTRAINT `account_gruppi_attribuzione_ibfk_1` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_gruppi_attribuzione_ibfk_2` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `account_gruppi_attribuzione_view`
--

DROP TABLE IF EXISTS `account_gruppi_attribuzione_view`;
/*!50001 DROP VIEW IF EXISTS `account_gruppi_attribuzione_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `account_gruppi_attribuzione_view` (
  `id` tinyint NOT NULL,
  `id_account` tinyint NOT NULL,
  `id_gruppo` tinyint NOT NULL,
  `entita` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `account_gruppi_view`
--

DROP TABLE IF EXISTS `account_gruppi_view`;
/*!50001 DROP VIEW IF EXISTS `account_gruppi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `account_gruppi_view` (
  `id` tinyint NOT NULL,
  `id_account` tinyint NOT NULL,
  `id_gruppo` tinyint NOT NULL,
  `se_amministratore` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `account_view`
--

DROP TABLE IF EXISTS `account_view`;
/*!50001 DROP VIEW IF EXISTS `account_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `account_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_mail` tinyint NOT NULL,
  `username` tinyint NOT NULL,
  `password` tinyint NOT NULL,
  `se_attivo` tinyint NOT NULL,
  `token` tinyint NOT NULL,
  `timestamp_login` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `timestamp_cambio_password` tinyint NOT NULL,
  `attivo` tinyint NOT NULL,
  `utente` tinyint NOT NULL,
  `gruppi` tinyint NOT NULL,
  `id_gruppi` tinyint NOT NULL,
  `gruppi_attribuzione` tinyint NOT NULL,
  `gruppo_sede` tinyint NOT NULL,
  `id_anagrafica_struttura` tinyint NOT NULL,
  `id_gruppi_attribuzione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `anagrafica`
--

DROP TABLE IF EXISTS `anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codice` char(32) DEFAULT NULL,
  `riferimento` char(32) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `cognome` char(255) DEFAULT NULL,
  `denominazione` char(255) DEFAULT NULL,
  `soprannome` char(128) DEFAULT NULL,
  `sesso` enum('M','F','-') NOT NULL DEFAULT '-',
  `stato_civile` enum('Celibe/Nubile','Coniugato/a','Divorziato/a','Separato/a','Vedovo/a') DEFAULT NULL,
  `id_orientamento_sessuale` int(11) DEFAULT NULL,
  `codice_fiscale` char(32) DEFAULT NULL,
  `partita_iva` char(32) DEFAULT NULL,
  `codice_sdi` char(32) DEFAULT NULL,
  `id_pec_sdi` int(11) DEFAULT NULL,
  `id_regime_fiscale` int(11) DEFAULT NULL,
  `note_amministrative` text,
  `luogo_nascita` char(128) DEFAULT NULL,
  `stato_nascita` char(128) DEFAULT NULL,
  `id_stato_nascita` int(11) DEFAULT NULL,
  `comune_nascita` int(11) DEFAULT NULL,
  `giorno_nascita` int(2) DEFAULT NULL,
  `mese_nascita` int(2) DEFAULT NULL,
  `anno_nascita` int(4) DEFAULT NULL,
  `id_diritto` int(11) DEFAULT NULL,
  `id_tipologia_crm` int(11) DEFAULT NULL,
  `id_agente` int(11) DEFAULT NULL,
  `id_responsabile_operativo` int(11) DEFAULT NULL,
  `note_commerciali` text,
  `condizioni_vendita` text,
  `condizioni_acquisto` text,
  `note` text,
  `data_cessazione` date DEFAULT NULL,
  `note_cessazione` text,
  `recapiti` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `se_importata` int(1) DEFAULT NULL,
  `se_stampa_privacy` int(1) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codice` (`codice`),
  UNIQUE KEY `persone_unica` (`nome`,`cognome`,`codice_fiscale`),
  UNIQUE KEY `aziende_unica` (`denominazione`,`partita_iva`,`codice_fiscale`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_tipologia_crm` (`id_tipologia_crm`),
  KEY `indice` (`id`,`nome`,`cognome`,`denominazione`),
  KEY `id_agente` (`id_agente`),
  KEY `id_pec_sdi` (`id_pec_sdi`),
  KEY `id_regime_fiscale` (`id_regime_fiscale`),
  KEY `id_orientamento_sessuale` (`id_orientamento_sessuale`),
  KEY `comune_nascita` (`comune_nascita`),
  KEY `id_diritto` (`id_diritto`),
  KEY `id_stato_nascita` (`id_stato_nascita`),
  KEY `riferimento` (`riferimento`),
  KEY `id_responsabile_operativo` (`id_responsabile_operativo`),
  CONSTRAINT `anagrafica_ibfk_1` FOREIGN KEY (`id_orientamento_sessuale`) REFERENCES `orientamenti_sessuali` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_10_nofollow` FOREIGN KEY (`id_responsabile_operativo`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_2` FOREIGN KEY (`id_stato_nascita`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_3_nofollow` FOREIGN KEY (`id_tipologia_crm`) REFERENCES `tipologie_crm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_4_nofollow` FOREIGN KEY (`id_pec_sdi`) REFERENCES `mail` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_5_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_6_nofollow` FOREIGN KEY (`id_agente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_7_nofollow` FOREIGN KEY (`id_regime_fiscale`) REFERENCES `regimi_fiscali` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `anagrafica_ibfk_8_nofollow` FOREIGN KEY (`comune_nascita`) REFERENCES `comuni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `anagrafica_ibfk_9_nofollow` FOREIGN KEY (`id_diritto`) REFERENCES `categorie_diritto` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `anagrafica_archiviati_view`
--

DROP TABLE IF EXISTS `anagrafica_archiviati_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_archiviati_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_archiviati_view` (
  `id` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `cognome` tinyint NOT NULL,
  `denominazione` tinyint NOT NULL,
  `soprannome` tinyint NOT NULL,
  `sesso` tinyint NOT NULL,
  `id_orientamento_sessuale` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `partita_iva` tinyint NOT NULL,
  `codice_sdi` tinyint NOT NULL,
  `id_pec_sdi` tinyint NOT NULL,
  `id_regime_fiscale` tinyint NOT NULL,
  `note_amministrative` tinyint NOT NULL,
  `luogo_nascita` tinyint NOT NULL,
  `stato_nascita` tinyint NOT NULL,
  `comune_nascita` tinyint NOT NULL,
  `giorno_nascita` tinyint NOT NULL,
  `mese_nascita` tinyint NOT NULL,
  `anno_nascita` tinyint NOT NULL,
  `id_diritto` tinyint NOT NULL,
  `id_tipologia_crm` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `note_commerciali` tinyint NOT NULL,
  `condizioni_vendita` tinyint NOT NULL,
  `condizioni_acquisto` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `data_cessazione` tinyint NOT NULL,
  `note_cessazione` tinyint NOT NULL,
  `recapiti` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `pec_sdi` tinyint NOT NULL,
  `sigla_stato` tinyint NOT NULL,
  `se_collaboratore` tinyint NOT NULL,
  `se_cliente` tinyint NOT NULL,
  `se_lead` tinyint NOT NULL,
  `se_prospect` tinyint NOT NULL,
  `se_mandante` tinyint NOT NULL,
  `se_fornitore` tinyint NOT NULL,
  `se_produttore` tinyint NOT NULL,
  `se_agente` tinyint NOT NULL,
  `se_interno` tinyint NOT NULL,
  `se_esterno` tinyint NOT NULL,
  `se_amministrazione` tinyint NOT NULL,
  `se_azienda_gestita` tinyint NOT NULL,
  `se_concorrente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `denominazione_fiscale` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `categorie` tinyint NOT NULL,
  `telefoni` tinyint NOT NULL,
  `mail` tinyint NOT NULL,
  `provincia` tinyint NOT NULL,
  `codice_regime_fiscale` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `anagrafica_categorie`
--

DROP TABLE IF EXISTS `anagrafica_categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica_categorie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_anagrafica` (`id_anagrafica`,`id_categoria`),
  KEY `id_categoria` (`id_categoria`),
  KEY `indice` (`id`,`id_anagrafica`,`id_categoria`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `anagrafica_categorie_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_categorie_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_categorie_ibfk_2_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `anagrafica_categorie_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `anagrafica_categorie_diritto`
--

DROP TABLE IF EXISTS `anagrafica_categorie_diritto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica_categorie_diritto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `id_diritto` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_anagrafica`,`id_diritto`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_diritto` (`id_diritto`),
  CONSTRAINT `anagrafica_categorie_diritto_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `anagrafica_categorie_diritto_ibfk_2` FOREIGN KEY (`id_diritto`) REFERENCES `categorie_diritto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `anagrafica_categorie_diritto_view`
--

DROP TABLE IF EXISTS `anagrafica_categorie_diritto_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_categorie_diritto_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_categorie_diritto_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_diritto` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `anagrafica_categorie_view`
--

DROP TABLE IF EXISTS `anagrafica_categorie_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_categorie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_categorie_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_categoria` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `anagrafica_certificazioni`
--

DROP TABLE IF EXISTS `anagrafica_certificazioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica_certificazioni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_certificazione` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_emittente` int(11) DEFAULT NULL,
  `data_emissione` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_certificazione` (`id_certificazione`),
  KEY `id_emittente` (`id_emittente`),
  KEY `data_scadenza` (`data_scadenza`),
  CONSTRAINT `anagrafica_certificazioni_ibfk_2` FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `anagrafica_certificazioni_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_certificazioni_ibfk_2_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `anagrafica_certificazioni_view`
--

DROP TABLE IF EXISTS `anagrafica_certificazioni_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_certificazioni_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_certificazioni_view` (
  `id` tinyint NOT NULL,
  `id_certificazione` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_emittente` tinyint NOT NULL,
  `data_emissione` tinyint NOT NULL,
  `data_scadenza` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `emittente` tinyint NOT NULL,
  `certificazione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `anagrafica_cittadinanze`
--

DROP TABLE IF EXISTS `anagrafica_cittadinanze`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica_cittadinanze` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `id_stato` int(11) NOT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_anagrafica`,`id_stato`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_stato` (`id_stato`),
  CONSTRAINT `anagrafica_cittadinanze_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_cittadinanze_ibfk_2` FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `anagrafica_cittadinanze_view`
--

DROP TABLE IF EXISTS `anagrafica_cittadinanze_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_cittadinanze_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_cittadinanze_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_stato` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `anagrafica_clienti_estesa_view`
--

DROP TABLE IF EXISTS `anagrafica_clienti_estesa_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_clienti_estesa_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_clienti_estesa_view` (
  `id` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `cognome` tinyint NOT NULL,
  `denominazione` tinyint NOT NULL,
  `soprannome` tinyint NOT NULL,
  `sesso` tinyint NOT NULL,
  `id_orientamento_sessuale` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `partita_iva` tinyint NOT NULL,
  `codice_sdi` tinyint NOT NULL,
  `id_pec_sdi` tinyint NOT NULL,
  `id_regime_fiscale` tinyint NOT NULL,
  `note_amministrative` tinyint NOT NULL,
  `luogo_nascita` tinyint NOT NULL,
  `stato_nascita` tinyint NOT NULL,
  `comune_nascita` tinyint NOT NULL,
  `giorno_nascita` tinyint NOT NULL,
  `mese_nascita` tinyint NOT NULL,
  `anno_nascita` tinyint NOT NULL,
  `id_diritto` tinyint NOT NULL,
  `id_tipologia_crm` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `note_commerciali` tinyint NOT NULL,
  `condizioni_vendita` tinyint NOT NULL,
  `condizioni_acquisto` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `data_cessazione` tinyint NOT NULL,
  `note_cessazione` tinyint NOT NULL,
  `recapiti` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `anagrafica_clienti_view`
--

DROP TABLE IF EXISTS `anagrafica_clienti_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_clienti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_clienti_view` (
  `id` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `cognome` tinyint NOT NULL,
  `denominazione` tinyint NOT NULL,
  `soprannome` tinyint NOT NULL,
  `sesso` tinyint NOT NULL,
  `id_orientamento_sessuale` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `partita_iva` tinyint NOT NULL,
  `codice_sdi` tinyint NOT NULL,
  `id_pec_sdi` tinyint NOT NULL,
  `id_regime_fiscale` tinyint NOT NULL,
  `note_amministrative` tinyint NOT NULL,
  `luogo_nascita` tinyint NOT NULL,
  `stato_nascita` tinyint NOT NULL,
  `comune_nascita` tinyint NOT NULL,
  `giorno_nascita` tinyint NOT NULL,
  `mese_nascita` tinyint NOT NULL,
  `anno_nascita` tinyint NOT NULL,
  `id_diritto` tinyint NOT NULL,
  `id_tipologia_crm` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `note_commerciali` tinyint NOT NULL,
  `condizioni_vendita` tinyint NOT NULL,
  `condizioni_acquisto` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `data_cessazione` tinyint NOT NULL,
  `note_cessazione` tinyint NOT NULL,
  `recapiti` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `anagrafica_condizioni_pagamento`
--

DROP TABLE IF EXISTS `anagrafica_condizioni_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica_condizioni_pagamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `id_condizione` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_anagrafica`,`id_condizione`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_condizione` (`id_condizione`),
  CONSTRAINT `anagrafica_condizioni_pagamento_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_condizioni_pagamento_ibfk_2` FOREIGN KEY (`id_condizione`) REFERENCES `condizioni_pagamento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `anagrafica_condizioni_pagamento_view`
--

DROP TABLE IF EXISTS `anagrafica_condizioni_pagamento_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_condizioni_pagamento_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_condizioni_pagamento_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_condizione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `anagrafica_indirizzi`
--

DROP TABLE IF EXISTS `anagrafica_indirizzi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica_indirizzi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_indirizzo` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `interno` char(8) DEFAULT NULL,
  `descrizione` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_anagrafica`,`id_indirizzo`,`id_tipologia`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_tipologia` (`id_tipologia`),
  CONSTRAINT `anagrafica_indirizzi_ibfk_1` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`),
  CONSTRAINT `anagrafica_indirizzi_ibfk_2` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_indirizzi_ibfk_3` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `anagrafica_indirizzi_view`
--

DROP TABLE IF EXISTS `anagrafica_indirizzi_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_indirizzi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_indirizzi_view` (
  `id` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `anagrafica_modalita_pagamento`
--

DROP TABLE IF EXISTS `anagrafica_modalita_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica_modalita_pagamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `id_modalita` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_anagrafica`,`id_modalita`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_modalita` (`id_modalita`),
  CONSTRAINT `anagrafica_modalita_pagamento_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_modalita_pagamento_ibfk_2` FOREIGN KEY (`id_modalita`) REFERENCES `modalita_pagamento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `anagrafica_modalita_pagamento_view`
--

DROP TABLE IF EXISTS `anagrafica_modalita_pagamento_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_modalita_pagamento_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_modalita_pagamento_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_modalita` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `anagrafica_provenienze`
--

DROP TABLE IF EXISTS `anagrafica_provenienze`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica_provenienze` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `id_provenienza` int(11) NOT NULL,
  `testo` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_anagrafica`,`id_provenienza`),
  KEY `id_provenienza` (`id_provenienza`),
  KEY `id_anagrafica` (`id_anagrafica`),
  CONSTRAINT `anagrafica_provenienze_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_provenienze_ibfk_2` FOREIGN KEY (`id_provenienza`) REFERENCES `provenienze_contatti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `anagrafica_provenienze_view`
--

DROP TABLE IF EXISTS `anagrafica_provenienze_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_provenienze_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_provenienze_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_provenienza` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `anagrafica_ruoli`
--

DROP TABLE IF EXISTS `anagrafica_ruoli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica_ruoli` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `specifica_ruolo` char(255) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_anagrafica` (`id_anagrafica`,`id_ruolo`),
  UNIQUE KEY `id_genitore_unico` (`id_genitore`,`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_genitore` (`id_genitore`),
  CONSTRAINT `anagrafica_ruoli_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_ruoli_ibfk_1_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `anagrafica_ruoli_ibfk_2_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `anagrafica_ruoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `anagrafica_ruoli_view`
--

DROP TABLE IF EXISTS `anagrafica_ruoli_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_ruoli_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_ruoli_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `id_ruolo` tinyint NOT NULL,
  `specifica_ruolo` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `etichetta` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `anagrafica_servizi_contatto`
--

DROP TABLE IF EXISTS `anagrafica_servizi_contatto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica_servizi_contatto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `id_servizio_contatto` int(11) NOT NULL,
  `testo` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_anagrafica`,`id_servizio_contatto`),
  KEY `id_servizio_contatto` (`id_servizio_contatto`),
  KEY `id_anagrafica` (`id_anagrafica`),
  CONSTRAINT `anagrafica_servizi_contatto_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_servizi_contatto_ibfk_2` FOREIGN KEY (`id_servizio_contatto`) REFERENCES `provenienze_contatti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `anagrafica_servizi_contatto_view`
--

DROP TABLE IF EXISTS `anagrafica_servizi_contatto_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_servizi_contatto_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_servizi_contatto_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_servizio_contatto` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `anagrafica_settori`
--

DROP TABLE IF EXISTS `anagrafica_settori`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica_settori` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `id_settore` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_anagrafica` (`id_anagrafica`,`id_settore`),
  KEY `id_settore` (`id_settore`),
  CONSTRAINT `anagrafica_settori_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_settori_ibfk_1_nofollow` FOREIGN KEY (`id_settore`) REFERENCES `settori` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `anagrafica_settori_view`
--

DROP TABLE IF EXISTS `anagrafica_settori_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_settori_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_settori_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_settore` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `anagrafica_view`
--

DROP TABLE IF EXISTS `anagrafica_view`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_view` (
  `id` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `riferimento` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `cognome` tinyint NOT NULL,
  `denominazione` tinyint NOT NULL,
  `soprannome` tinyint NOT NULL,
  `sesso` tinyint NOT NULL,
  `stato_civile` tinyint NOT NULL,
  `id_orientamento_sessuale` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `partita_iva` tinyint NOT NULL,
  `codice_sdi` tinyint NOT NULL,
  `id_pec_sdi` tinyint NOT NULL,
  `id_regime_fiscale` tinyint NOT NULL,
  `note_amministrative` tinyint NOT NULL,
  `luogo_nascita` tinyint NOT NULL,
  `stato_nascita` tinyint NOT NULL,
  `id_stato_nascita` tinyint NOT NULL,
  `comune_nascita` tinyint NOT NULL,
  `giorno_nascita` tinyint NOT NULL,
  `mese_nascita` tinyint NOT NULL,
  `anno_nascita` tinyint NOT NULL,
  `id_diritto` tinyint NOT NULL,
  `id_tipologia_crm` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `id_responsabile_operativo` tinyint NOT NULL,
  `note_commerciali` tinyint NOT NULL,
  `condizioni_vendita` tinyint NOT NULL,
  `condizioni_acquisto` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `data_cessazione` tinyint NOT NULL,
  `note_cessazione` tinyint NOT NULL,
  `recapiti` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `se_importata` tinyint NOT NULL,
  `se_stampa_privacy` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `pec_sdi` tinyint NOT NULL,
  `sigla_stato` tinyint NOT NULL,
  `cittadinanze` tinyint NOT NULL,
  `se_collaboratore` tinyint NOT NULL,
  `se_dipendente` tinyint NOT NULL,
  `se_interinale` tinyint NOT NULL,
  `se_cliente` tinyint NOT NULL,
  `se_lead` tinyint NOT NULL,
  `se_prospect` tinyint NOT NULL,
  `se_mandante` tinyint NOT NULL,
  `se_fornitore` tinyint NOT NULL,
  `se_produttore` tinyint NOT NULL,
  `se_agente` tinyint NOT NULL,
  `se_interno` tinyint NOT NULL,
  `se_esterno` tinyint NOT NULL,
  `se_amministrazione` tinyint NOT NULL,
  `se_azienda_gestita` tinyint NOT NULL,
  `se_concorrente` tinyint NOT NULL,
  `se_tutor` tinyint NOT NULL,
  `se_classe` tinyint NOT NULL,
  `se_docente` tinyint NOT NULL,
  `se_allievo` tinyint NOT NULL,
  `se_agenzia_interinale` tinyint NOT NULL,
  `se_referente` tinyint NOT NULL,
  `se_sostituto` tinyint NOT NULL,
  `se_squadra` tinyint NOT NULL,
  `se_produzione` tinyint NOT NULL,
  `se_emittente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `denominazione_fiscale` tinyint NOT NULL,
  `diritto` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `responsabile_operativo` tinyint NOT NULL,
  `categorie` tinyint NOT NULL,
  `telefoni` tinyint NOT NULL,
  `mail` tinyint NOT NULL,
  `specialita` tinyint NOT NULL,
  `provincia` tinyint NOT NULL,
  `codice_regime_fiscale` tinyint NOT NULL,
  `gruppo` tinyint NOT NULL,
  `cap` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `anagrafica_view_TEST`
--

DROP TABLE IF EXISTS `anagrafica_view_TEST`;
/*!50001 DROP VIEW IF EXISTS `anagrafica_view_TEST`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `anagrafica_view_TEST` (
  `id` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `cognome` tinyint NOT NULL,
  `denominazione` tinyint NOT NULL,
  `soprannome` tinyint NOT NULL,
  `sesso` tinyint NOT NULL,
  `id_orientamento_sessuale` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `partita_iva` tinyint NOT NULL,
  `codice_sdi` tinyint NOT NULL,
  `id_pec_sdi` tinyint NOT NULL,
  `id_regime_fiscale` tinyint NOT NULL,
  `note_amministrative` tinyint NOT NULL,
  `luogo_nascita` tinyint NOT NULL,
  `stato_nascita` tinyint NOT NULL,
  `id_stato_nascita` tinyint NOT NULL,
  `comune_nascita` tinyint NOT NULL,
  `giorno_nascita` tinyint NOT NULL,
  `mese_nascita` tinyint NOT NULL,
  `anno_nascita` tinyint NOT NULL,
  `id_diritto` tinyint NOT NULL,
  `id_tipologia_crm` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `note_commerciali` tinyint NOT NULL,
  `condizioni_vendita` tinyint NOT NULL,
  `condizioni_acquisto` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `data_cessazione` tinyint NOT NULL,
  `note_cessazione` tinyint NOT NULL,
  `recapiti` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `se_importata` tinyint NOT NULL,
  `se_stampa_privacy` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `denominazione_fiscale` tinyint NOT NULL,
  `telefoni` tinyint NOT NULL,
  `mail` tinyint NOT NULL,
  `categorie` tinyint NOT NULL,
  `se_collaboratore` tinyint NOT NULL,
  `se_dipendente` tinyint NOT NULL,
  `se_cliente` tinyint NOT NULL,
  `se_lead` tinyint NOT NULL,
  `se_prospect` tinyint NOT NULL,
  `se_mandante` tinyint NOT NULL,
  `se_fornitore` tinyint NOT NULL,
  `se_produttore` tinyint NOT NULL,
  `se_agente` tinyint NOT NULL,
  `se_interno` tinyint NOT NULL,
  `se_esterno` tinyint NOT NULL,
  `se_amministrazione` tinyint NOT NULL,
  `se_azienda_gestita` tinyint NOT NULL,
  `se_concorrente` tinyint NOT NULL,
  `se_tutor` tinyint NOT NULL,
  `se_classe` tinyint NOT NULL,
  `se_docente` tinyint NOT NULL,
  `se_allievo` tinyint NOT NULL,
  `provincia` tinyint NOT NULL,
  `cittadinanze` tinyint NOT NULL,
  `sigla_stato` tinyint NOT NULL,
  `pec_sdi` tinyint NOT NULL,
  `diritto` tinyint NOT NULL,
  `specialita` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `codice_regime_fiscale` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `anagrafica_view_static`
--

DROP TABLE IF EXISTS `anagrafica_view_static`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anagrafica_view_static` (
  `id` int(11) NOT NULL,
  `codice` char(32) DEFAULT NULL,
  `riferimento` char(32) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `cognome` char(255) DEFAULT NULL,
  `denominazione` char(255) DEFAULT NULL,
  `soprannome` char(128) DEFAULT NULL,
  `sesso` enum('M','F','-') NOT NULL DEFAULT '-',
  `stato_civile` enum('Celibe/Nubile','Coniugato/a','Divorziato/a','Separato/a','Vedovo/a') DEFAULT NULL,
  `id_orientamento_sessuale` int(11) DEFAULT NULL,
  `codice_fiscale` char(32) DEFAULT NULL,
  `partita_iva` char(32) DEFAULT NULL,
  `codice_sdi` char(32) DEFAULT NULL,
  `id_pec_sdi` int(11) DEFAULT NULL,
  `id_regime_fiscale` int(11) DEFAULT NULL,
  `note_amministrative` text,
  `luogo_nascita` char(128) DEFAULT NULL,
  `stato_nascita` char(128) DEFAULT NULL,
  `id_stato_nascita` int(11) DEFAULT NULL,
  `comune_nascita` int(11) DEFAULT NULL,
  `giorno_nascita` int(2) DEFAULT NULL,
  `mese_nascita` int(2) DEFAULT NULL,
  `anno_nascita` int(4) DEFAULT NULL,
  `id_diritto` int(11) DEFAULT NULL,
  `id_tipologia_crm` int(11) DEFAULT NULL,
  `id_agente` int(11) DEFAULT NULL,
  `id_responsabile_operativo` int(11) DEFAULT NULL,
  `note_commerciali` text,
  `condizioni_vendita` text,
  `condizioni_acquisto` text,
  `note` text,
  `data_cessazione` date DEFAULT NULL,
  `note_cessazione` text,
  `recapiti` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `se_importata` int(1) DEFAULT NULL,
  `se_stampa_privacy` int(1) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `pec_sdi` text,
  `sigla_stato` text,
  `cittadinanze` text,
  `se_collaboratore` int(1) DEFAULT NULL,
  `se_dipendente` int(1) DEFAULT NULL,
  `se_interinale` int(1) DEFAULT NULL,
  `se_cliente` int(1) DEFAULT NULL,
  `se_lead` int(1) DEFAULT NULL,
  `se_prospect` int(1) DEFAULT NULL,
  `se_mandante` int(1) DEFAULT NULL,
  `se_fornitore` int(1) DEFAULT NULL,
  `se_produttore` int(1) DEFAULT NULL,
  `se_agente` int(1) DEFAULT NULL,
  `se_interno` int(1) DEFAULT NULL,
  `se_esterno` int(1) DEFAULT NULL,
  `se_amministrazione` int(1) DEFAULT NULL,
  `se_azienda_gestita` int(1) DEFAULT NULL,
  `se_concorrente` int(1) DEFAULT NULL,
  `se_tutor` int(1) DEFAULT NULL,
  `se_classe` int(1) DEFAULT NULL,
  `se_docente` int(1) DEFAULT NULL,
  `se_allievo` int(1) DEFAULT NULL,
  `se_agenzia_interinale` int(1) DEFAULT NULL,
  `se_referente` int(1) DEFAULT NULL,
  `se_sostituto` int(1) DEFAULT NULL,
  `se_squadra` int(1) DEFAULT NULL,
  `se_produzione` int(1) DEFAULT NULL,
  `se_emittente` int(1) DEFAULT NULL,
  `__label__` char(255) DEFAULT NULL,
  `denominazione_fiscale` char(255) DEFAULT NULL,
  `diritto` char(255) DEFAULT NULL,
  `agente` char(255) DEFAULT NULL,
  `responsabile_operativo` char(255) DEFAULT NULL,
  `categorie` text,
  `telefoni` text,
  `mail` text,
  `specialita` text,
  `provincia` text,
  `codice_regime_fiscale` text,
  `gruppo` text,
  `cap` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cap` (`cap`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articoli`
--

DROP TABLE IF EXISTS `articoli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articoli` (
  `id` char(32) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  `nome` char(128) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_taglia` int(11) DEFAULT NULL,
  `id_colore` int(11) DEFAULT NULL,
  `id_udm` int(11) DEFAULT NULL,
  `id_reparto` int(11) DEFAULT NULL,
  `se_disponibile` int(1) DEFAULT '1',
  `quantita_disponibile` int(11) DEFAULT NULL,
  `codice_produttore` char(128) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_taglia` (`id_taglia`),
  KEY `id_colore` (`id_colore`),
  KEY `ordine` (`ordine`),
  KEY `id_udm` (`id_udm`),
  KEY `id_reparto` (`id_reparto`),
  CONSTRAINT `articoli_ibfk_1_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `articoli_ibfk_2` FOREIGN KEY (`id_taglia`) REFERENCES `taglie` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `articoli_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `articoli_ibfk_3` FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `articoli_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `articoli_ibfk_4` FOREIGN KEY (`id_reparto`) REFERENCES `reparti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `articoli_ibfk_4_nofollow` FOREIGN KEY (`id_udm`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articoli_caratteristiche`
--

DROP TABLE IF EXISTS `articoli_caratteristiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articoli_caratteristiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_articolo` char(32) NOT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `testo` text,
  `se_non_presente` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_articolo` (`id_articolo`,`id_caratteristica`),
  KEY `ordine` (`ordine`),
  KEY `indice` (`id`,`id_articolo`,`id_caratteristica`,`ordine`),
  KEY `id_caratteristica` (`id_caratteristica`),
  KEY `id_lingua` (`id_lingua`),
  CONSTRAINT `articoli_caratteristiche_ibfk_1` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `articoli_caratteristiche_ibfk_2` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `articoli_caratteristiche_view`
--

DROP TABLE IF EXISTS `articoli_caratteristiche_view`;
/*!50001 DROP VIEW IF EXISTS `articoli_caratteristiche_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `articoli_caratteristiche_view` (
  `id` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `id_caratteristica` tinyint NOT NULL,
  `id_lingua` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `se_non_presente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `caratteristica` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `articoli_view`
--

DROP TABLE IF EXISTS `articoli_view`;
/*!50001 DROP VIEW IF EXISTS `articoli_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `articoli_view` (
  `id` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `id_taglia` tinyint NOT NULL,
  `id_colore` tinyint NOT NULL,
  `id_udm` tinyint NOT NULL,
  `id_reparto` tinyint NOT NULL,
  `se_disponibile` tinyint NOT NULL,
  `quantita_disponibile` tinyint NOT NULL,
  `codice_produttore` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `it` tinyint NOT NULL,
  `tipologia_taglia` tinyint NOT NULL,
  `udm` tinyint NOT NULL,
  `se_ore` tinyint NOT NULL,
  `se_matricola` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `nome_articolo` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `assicurazioni_montaggio`
--

DROP TABLE IF EXISTS `assicurazioni_montaggio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assicurazioni_montaggio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `suggerimento` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`,`suggerimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assicurazioni_montaggio_prezzi`
--

DROP TABLE IF EXISTS `assicurazioni_montaggio_prezzi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assicurazioni_montaggio_prezzi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_assicurazione` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_assicurazione`),
  KEY `id_zona` (`id_zona`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_listino` (`id_listino`),
  KEY `id_valuta` (`id_valuta`),
  KEY `id_iva` (`id_iva`),
  CONSTRAINT `assicurazioni_montaggio_prezzi_ibfk_2` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assicurazioni_montaggio_prezzi_ibfk_3` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assicurazioni_montaggio_prezzi_ibfk_4` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `assicurazioni_montaggio_prezzi_ibfk_5` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `assicurazioni_montaggio_prezzi_ibfk_6` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `assicurazioni_montaggio_prezzi_ibfk_7` FOREIGN KEY (`id_assicurazione`) REFERENCES `assicurazioni_montaggio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assicurazioni_trasporto`
--

DROP TABLE IF EXISTS `assicurazioni_trasporto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assicurazioni_trasporto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `suggerimento` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`,`suggerimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assicurazioni_trasporto_prezzi`
--

DROP TABLE IF EXISTS `assicurazioni_trasporto_prezzi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assicurazioni_trasporto_prezzi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_assicurazione` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_assicurazione`),
  KEY `id_zona` (`id_zona`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_listino` (`id_listino`),
  KEY `id_valuta` (`id_valuta`),
  KEY `id_iva` (`id_iva`),
  CONSTRAINT `assicurazioni_trasporto_prezzi_ibfk_2` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assicurazioni_trasporto_prezzi_ibfk_3` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assicurazioni_trasporto_prezzi_ibfk_4` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `assicurazioni_trasporto_prezzi_ibfk_5` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `assicurazioni_trasporto_prezzi_ibfk_6` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `assicurazioni_trasporto_prezzi_ibfk_7` FOREIGN KEY (`id_assicurazione`) REFERENCES `assicurazioni_trasporto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attivita`
--

DROP TABLE IF EXISTS `attivita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attivita` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_tipologia_inps` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_mandante` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `latitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `latitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `referente` char(255) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `data_attivita` date DEFAULT NULL,
  `ora` time DEFAULT NULL,
  `ora_inizio` time DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `id_pratica` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_campagna` int(11) DEFAULT NULL,
  `id_task` int(11) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_tipologia_interesse` int(11) DEFAULT NULL,
  `id_tipologia_soddisfazione` int(11) DEFAULT NULL,
  `note_feedback` text,
  `id_immobile` int(11) DEFAULT NULL,
  `id_incarico` int(11) DEFAULT NULL,
  `id_richiesta` int(11) DEFAULT NULL,
  `id_incrocio_immobile` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `testo` text,
  `note_interne` text,
  `timestamp_scadenza` int(11) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `note_scadenza` text,
  `id_attivita_completamento` int(11) DEFAULT NULL,
  `ore` decimal(5,2) DEFAULT NULL,
  `id_esito` int(11) DEFAULT NULL,
  `id_account_editor` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `id_documenti_articoli` int(11) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `id_todo_articoli` int(11) DEFAULT NULL,
  `timestamp_calcolo_sostituti` int(11) DEFAULT NULL,
  `id_contratto` int(11) DEFAULT NULL,
  `se_master` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_task` (`id_task`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_mandante` (`id_mandante`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_incrocio_immobile` (`id_incrocio_immobile`),
  KEY `id_esito` (`id_esito`),
  KEY `id_immobile` (`id_immobile`),
  KEY `id_pratica` (`id_pratica`),
  KEY `id_incarico` (`id_incarico`),
  KEY `id_richiesta` (`id_richiesta`),
  KEY `id_campagna` (`id_campagna`),
  KEY `id_tipologia_soddisfazione` (`id_tipologia_soddisfazione`),
  KEY `id_tipologia_interesse` (`id_tipologia_interesse`),
  KEY `id_account_editor` (`id_account_editor`),
  KEY `id_luogo` (`id_luogo`),
  KEY `id_tipologia_inps` (`id_tipologia_inps`),
  KEY `id_todo` (`id_todo`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `token` (`token`),
  KEY `id_mastro_provenienza` (`id_mastro_provenienza`),
  KEY `id_mastro_destinazione` (`id_mastro_destinazione`),
  KEY `id_todo_articoli` (`id_todo_articoli`),
  KEY `timestamp_calcolo_sostituti` (`timestamp_calcolo_sostituti`),
  KEY `id_contratto` (`id_contratto`),
  KEY `id_documenti_articoli` (`id_documenti_articoli`),
  KEY `id_matricola` (`id_matricola`),
  KEY `se_master` (`se_master`),
  CONSTRAINT `attivita_ibfk_10_nofollow` FOREIGN KEY (`id_incarico`) REFERENCES `incarichi_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_11_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_12_nofollow` FOREIGN KEY (`id_task`) REFERENCES `task` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_13_nofollow` FOREIGN KEY (`id_richiesta`) REFERENCES `richieste_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_14_nofollow` FOREIGN KEY (`id_campagna`) REFERENCES `campagne` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_15_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_16_nofollow` FOREIGN KEY (`id_tipologia_inps`) REFERENCES `tipologie_attivita_inps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_17_nofollow` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `attivita_ibfk_18_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_19_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_1_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_attivita` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_20_nofollow` FOREIGN KEY (`id_todo_articoli`) REFERENCES `todo_articoli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_21_nofollow` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_22_nofollow` FOREIGN KEY (`id_documenti_articoli`) REFERENCES `documenti_articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_23_nofollow` FOREIGN KEY (`id_matricola`) REFERENCES `matricole` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_2_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_3` FOREIGN KEY (`id_esito`) REFERENCES `esiti_attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_3_nofollow` FOREIGN KEY (`id_mandante`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_4` FOREIGN KEY (`id_tipologia_interesse`) REFERENCES `tipologie_interesse` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_4_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_5` FOREIGN KEY (`id_tipologia_soddisfazione`) REFERENCES `tipologie_soddisfazione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_ibfk_5_nofollow` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_6` FOREIGN KEY (`id_incrocio_immobile`) REFERENCES `incroci_immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_6_nofollow` FOREIGN KEY (`id_pratica`) REFERENCES `pratiche` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_7` FOREIGN KEY (`id_account_editor`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_7_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_8` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_8_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_9_nofollow` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attivita_anagrafica`
--

DROP TABLE IF EXISTS `attivita_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attivita_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_attivita` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_attivita` (`id_attivita`),
  KEY `id_anagrafica` (`id_anagrafica`),
  CONSTRAINT `attivita_anagrafica_ibfk_1` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `attivita_anagrafica_ibfk_2` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `attivita_archiviate_view`
--

DROP TABLE IF EXISTS `attivita_archiviate_view`;
/*!50001 DROP VIEW IF EXISTS `attivita_archiviate_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `attivita_archiviate_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_tipologia_inps` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_mandante` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_luogo` tinyint NOT NULL,
  `referente` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `data` tinyint NOT NULL,
  `ora` tinyint NOT NULL,
  `ora_fine` tinyint NOT NULL,
  `id_pratica` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `id_campagna` tinyint NOT NULL,
  `id_task` tinyint NOT NULL,
  `id_todo` tinyint NOT NULL,
  `id_tipologia_interesse` tinyint NOT NULL,
  `id_tipologia_soddisfazione` tinyint NOT NULL,
  `note_feedback` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `id_incarico` tinyint NOT NULL,
  `id_richiesta` tinyint NOT NULL,
  `id_incrocio_immobile` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `timestamp_scadenza` tinyint NOT NULL,
  `note_scadenza` tinyint NOT NULL,
  `id_attivita_completamento` tinyint NOT NULL,
  `ore` tinyint NOT NULL,
  `id_esito` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `task` tinyint NOT NULL,
  `ore_previste_task` tinyint NOT NULL,
  `todo` tinyint NOT NULL,
  `ore_previste_todo` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `icona_html` tinyint NOT NULL,
  `icona_fa` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `mandante` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `attivita_categorie`
--

DROP TABLE IF EXISTS `attivita_categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attivita_categorie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_attivita` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_attivita`,`id_categoria`),
  KEY `id_categoria` (`id_categoria`),
  KEY `indice` (`id`,`id_attivita`,`id_categoria`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_attivita` (`id_attivita`),
  CONSTRAINT `attivita_categorie_ibfk_1` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `attivita_categorie_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_categorie_ibfk_2_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_attivita` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `attivita_categorie_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `attivita_categorie_view`
--

DROP TABLE IF EXISTS `attivita_categorie_view`;
/*!50001 DROP VIEW IF EXISTS `attivita_categorie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `attivita_categorie_view` (
  `id` tinyint NOT NULL,
  `id_attivita` tinyint NOT NULL,
  `id_categoria` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `attivita_scoperte_view`
--

DROP TABLE IF EXISTS `attivita_scoperte_view`;
/*!50001 DROP VIEW IF EXISTS `attivita_scoperte_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `attivita_scoperte_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_tipologia_inps` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_assente` tinyint NOT NULL,
  `assente` tinyint NOT NULL,
  `id_mandante` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_luogo` tinyint NOT NULL,
  `referente` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `data` tinyint NOT NULL,
  `data_attivita` tinyint NOT NULL,
  `ora` tinyint NOT NULL,
  `ora_inizio` tinyint NOT NULL,
  `ora_fine` tinyint NOT NULL,
  `data_programmazione` tinyint NOT NULL,
  `ora_inizio_programmazione` tinyint NOT NULL,
  `ora_fine_programmazione` tinyint NOT NULL,
  `id_pratica` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `id_campagna` tinyint NOT NULL,
  `id_task` tinyint NOT NULL,
  `id_todo` tinyint NOT NULL,
  `id_tipologia_interesse` tinyint NOT NULL,
  `id_tipologia_soddisfazione` tinyint NOT NULL,
  `note_feedback` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `id_incarico` tinyint NOT NULL,
  `id_richiesta` tinyint NOT NULL,
  `id_incrocio_immobile` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `timestamp_scadenza` tinyint NOT NULL,
  `data_scadenza` tinyint NOT NULL,
  `ora_scadenza` tinyint NOT NULL,
  `note_scadenza` tinyint NOT NULL,
  `id_attivita_completamento` tinyint NOT NULL,
  `ore` tinyint NOT NULL,
  `id_esito` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `task` tinyint NOT NULL,
  `ore_previste_task` tinyint NOT NULL,
  `todo` tinyint NOT NULL,
  `ore_previste_todo` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `tipologia_inps` tinyint NOT NULL,
  `icona_html` tinyint NOT NULL,
  `icona_fa` tinyint NOT NULL,
  `pratica` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `tipologia_attivita_immobiliare` tinyint NOT NULL,
  `mandante` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `attivita_view`
--

DROP TABLE IF EXISTS `attivita_view`;
/*!50001 DROP VIEW IF EXISTS `attivita_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `attivita_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `id_tipologia_inps` tinyint NOT NULL,
  `tipologia_inps` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `id_luogo` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `latitudine_ora_inizio` tinyint NOT NULL,
  `longitudine_ora_inizio` tinyint NOT NULL,
  `latitudine_ora_fine` tinyint NOT NULL,
  `longitudine_ora_fine` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `data_attivita` tinyint NOT NULL,
  `ora_inizio` tinyint NOT NULL,
  `ora_fine` tinyint NOT NULL,
  `token` tinyint NOT NULL,
  `data_programmazione` tinyint NOT NULL,
  `ora_inizio_programmazione` tinyint NOT NULL,
  `ora_fine_programmazione` tinyint NOT NULL,
  `id_pianificazione` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `referenti` tinyint NOT NULL,
  `id_campagna` tinyint NOT NULL,
  `id_todo` tinyint NOT NULL,
  `todo` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `id_incarico` tinyint NOT NULL,
  `id_richiesta` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `note_interne` tinyint NOT NULL,
  `categorie_progetto` tinyint NOT NULL,
  `data_scadenza` tinyint NOT NULL,
  `ora_scadenza` tinyint NOT NULL,
  `note_scadenza` tinyint NOT NULL,
  `ore` tinyint NOT NULL,
  `ore_previste` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `se_master` tinyint NOT NULL,
  `id_mastro_provenienza` tinyint NOT NULL,
  `mastro_provenienza` tinyint NOT NULL,
  `id_mastro_destinazione` tinyint NOT NULL,
  `mastro_destinazione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `attivita_view_static`
--

DROP TABLE IF EXISTS `attivita_view_static`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attivita_view_static` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `tipologia` char(64) DEFAULT NULL,
  `id_tipologia_inps` int(11) DEFAULT NULL,
  `tipologia_inps` char(255) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `anagrafica` varchar(320) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `cliente` varchar(320) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `indirizzo` text,
  `latitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `latitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `data_attivita` date DEFAULT NULL,
  `ora_inizio` time DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `progetto` char(255) DEFAULT NULL,
  `referenti` text,
  `id_campagna` int(11) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `todo` char(255) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_incarico` int(11) DEFAULT NULL,
  `id_richiesta` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `testo` text,
  `note_interne` int(11) DEFAULT NULL,
  `categorie_progetto` text,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `note_scadenza` text,
  `ore` decimal(5,2) DEFAULT NULL,
  `ore_previste` decimal(5,2) DEFAULT NULL,
  `giorno` int(2) DEFAULT NULL,
  `mese` int(2) DEFAULT NULL,
  `anno` int(4) DEFAULT NULL,
  `se_master` int(1) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `mastro_provenienza` char(64) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `mastro_destinazione` char(64) DEFAULT NULL,
  `__label__` varchar(320) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_immobile` (`id_immobile`),
  KEY `id_incarico` (`id_incarico`),
  KEY `id_richiesta` (`id_richiesta`),
  KEY `id_campagna` (`id_campagna`),
  KEY `id_luogo` (`id_luogo`),
  KEY `id_tipologia_inps` (`id_tipologia_inps`),
  KEY `id_todo` (`id_todo`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `token` (`token`),
  KEY `id_mastro_provenienza` (`id_mastro_provenienza`),
  KEY `id_mastro_destinazione` (`id_mastro_destinazione`),
  KEY `se_master` (`se_master`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `audio`
--

DROP TABLE IF EXISTS `audio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_file` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_evento` int(11) DEFAULT NULL,
  `id_categoria_eventi` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `codice_embed` char(255) DEFAULT NULL,
  `id_tipologia_embed` int(11) NOT NULL,
  `nome` char(32) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `target` char(255) DEFAULT NULL,
  `timestamp_scalamento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pagina_unico_embed` (`id_pagina`,`codice_embed`),
  UNIQUE KEY `pagina_unico_path` (`id_pagina`,`path`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_evento` (`id_evento`),
  KEY `id_file` (`id_file`),
  KEY `id_tipologia_embed` (`id_tipologia_embed`),
  KEY `id_categoria_eventi` (`id_categoria_eventi`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `codice_embed` (`codice_embed`),
  KEY `path` (`path`),
  CONSTRAINT `audio_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_10` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_10_nofollow` FOREIGN KEY (`id_tipologia_embed`) REFERENCES `tipologie_embed` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `audio_ibfk_11` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_12` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_2` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_3` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_4` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_5` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_6` FOREIGN KEY (`id_evento`) REFERENCES `eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_7` FOREIGN KEY (`id_categoria_eventi`) REFERENCES `categorie_eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_8` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_audio` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `audio_ibfk_8_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_9` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_9_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `audio_view`
--

DROP TABLE IF EXISTS `audio_view`;
/*!50001 DROP VIEW IF EXISTS `audio_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `audio_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_file` tinyint NOT NULL,
  `id_risorsa` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `id_notizia` tinyint NOT NULL,
  `id_categoria_notizie` tinyint NOT NULL,
  `id_evento` tinyint NOT NULL,
  `id_categoria_eventi` tinyint NOT NULL,
  `id_lingua` tinyint NOT NULL,
  `path` tinyint NOT NULL,
  `codice_embed` tinyint NOT NULL,
  `id_tipologia_embed` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_ruolo` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `target` tinyint NOT NULL,
  `timestamp_scalamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `campagne`
--

DROP TABLE IF EXISTS `campagne`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `campagne` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(128) NOT NULL,
  `testo` text,
  `id_account_chiusura` int(11) DEFAULT NULL,
  `timestamp_chiusura` int(11) DEFAULT NULL,
  `testo_chiusura` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_account_chiusura` (`id_account_chiusura`),
  CONSTRAINT `campagne_ibfk_1_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `campagne_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `campagne_ibfk_3_nofollow` FOREIGN KEY (`id_account_chiusura`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `campagne_view`
--

DROP TABLE IF EXISTS `campagne_view`;
/*!50001 DROP VIEW IF EXISTS `campagne_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `campagne_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `id_account_chiusura` tinyint NOT NULL,
  `timestamp_chiusura` tinyint NOT NULL,
  `testo_chiusura` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `caratteristiche_immobili`
--

DROP TABLE IF EXISTS `caratteristiche_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `caratteristiche_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(128) NOT NULL,
  `font_awesome` char(24) DEFAULT NULL,
  `html` char(8) DEFAULT NULL,
  `se_immobile` int(1) DEFAULT NULL,
  `se_indirizzo` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `caratteristiche_immobili_view`
--

DROP TABLE IF EXISTS `caratteristiche_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `caratteristiche_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `caratteristiche_immobili_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `font_awesome` tinyint NOT NULL,
  `html` tinyint NOT NULL,
  `se_immobile` tinyint NOT NULL,
  `se_indirizzo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `caratteristiche_prodotti`
--

DROP TABLE IF EXISTS `caratteristiche_prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `caratteristiche_prodotti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_prodotto` int(1) DEFAULT NULL,
  `se_articolo` int(1) DEFAULT NULL,
  `se_categoria` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `caratteristiche_prodotti_ibfk_1_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `caratteristiche_prodotti_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `caratteristiche_prodotti_view`
--

DROP TABLE IF EXISTS `caratteristiche_prodotti_view`;
/*!50001 DROP VIEW IF EXISTS `caratteristiche_prodotti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `caratteristiche_prodotti_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_prodotto` tinyint NOT NULL,
  `se_articolo` tinyint NOT NULL,
  `se_categoria` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `carrelli`
--

DROP TABLE IF EXISTS `carrelli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `carrelli` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session` char(255) DEFAULT NULL,
  `se_indirizzo_spedizione` int(1) DEFAULT NULL,
  `spedizione_nome` char(255) DEFAULT NULL,
  `spedizione_cognome` char(255) DEFAULT NULL,
  `spedizione_denominazione` char(255) DEFAULT NULL,
  `spedizione_indirizzo` char(255) DEFAULT NULL,
  `spedizione_cap` char(16) DEFAULT NULL,
  `spedizione_citta` char(255) DEFAULT NULL,
  `spedizione_id_provincia` int(11) DEFAULT NULL,
  `spedizione_id_stato` int(11) DEFAULT NULL,
  `spedizione_telefono` char(255) DEFAULT NULL,
  `spedizione_mail` char(255) DEFAULT NULL,
  `intestazione_nome` char(255) DEFAULT NULL,
  `intestazione_cognome` char(255) DEFAULT NULL,
  `intestazione_denominazione` char(255) DEFAULT NULL,
  `intestazione_id_anagrafica` int(11) DEFAULT NULL,
  `intestazione_indirizzo` char(255) DEFAULT NULL,
  `intestazione_cap` char(16) DEFAULT NULL,
  `intestazione_citta` char(255) DEFAULT NULL,
  `intestazione_id_provincia` int(11) DEFAULT NULL,
  `intestazione_id_stato` int(11) DEFAULT NULL,
  `intestazione_telefono` char(255) DEFAULT NULL,
  `intestazione_mail` char(255) DEFAULT NULL,
  `intestazione_codice_fiscale` char(255) DEFAULT NULL,
  `intestazione_partita_iva` char(255) DEFAULT NULL,
  `intestazione_sdi` char(32) DEFAULT NULL,
  `intestazione_pec` char(255) DEFAULT NULL,
  `id_listino` int(11) DEFAULT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_modalita_spedizione` int(11) DEFAULT NULL,
  `prezzo_lordo_spedizione` decimal(16,5) DEFAULT NULL,
  `id_tipologia_consegna` int(11) DEFAULT NULL,
  `prezzo_lordo_consegna` decimal(16,5) DEFAULT NULL,
  `id_assicurazione_trasporto` int(11) DEFAULT NULL,
  `prezzo_lordo_assicurazione_trasporto` decimal(16,5) DEFAULT NULL,
  `id_assicurazione_montaggio` int(11) DEFAULT NULL,
  `prezzo_lordo_assicurazione_montaggio` decimal(16,5) DEFAULT NULL,
  `id_garanzia` int(11) DEFAULT NULL,
  `prezzo_lordo_garanzia` decimal(16,5) DEFAULT NULL,
  `id_modalita_pagamento` int(11) DEFAULT NULL,
  `id_tipologia_documento_carrello` int(11) DEFAULT NULL,
  `prezzo_lordo_modalita_pagamento` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_acquisti` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_complessivo` decimal(16,5) DEFAULT NULL,
  `importo_iva_complessivo` decimal(16,5) DEFAULT NULL,
  `coupon` char(32) DEFAULT NULL,
  `importo_lordo_sconto` decimal(16,5) DEFAULT NULL,
  `note_cliente` text,
  `se_accettazione_privacy` int(1) DEFAULT NULL,
  `se_anonimo` int(1) DEFAULT NULL,
  `se_accettazione_evasione` int(1) DEFAULT NULL,
  `se_accettazione_marketing` int(1) DEFAULT NULL,
  `se_accettazione_condizioni_vendita` int(1) DEFAULT NULL,
  `timestamp_checkout` int(11) DEFAULT NULL,
  `session_checkout` char(255) DEFAULT NULL,
  `provider_pagamento` char(64) DEFAULT NULL,
  `timestamp_pagamento` int(11) DEFAULT NULL,
  `codice_pagamento` char(255) DEFAULT NULL,
  `importo_pagamento` decimal(16,5) DEFAULT NULL,
  `session_pagamento` char(255) DEFAULT NULL,
  `esito_pagamento` char(100) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `session` (`session`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_listino` (`id_listino`),
  KEY `id_tipologia_consegna` (`id_tipologia_consegna`),
  KEY `id_tipologia_assicurazione_spedizione` (`id_assicurazione_trasporto`),
  KEY `id_tipologia_assicurazione_montaggio` (`id_assicurazione_montaggio`),
  KEY `id_garanzia` (`id_garanzia`),
  KEY `id_modalita_pagamento` (`id_modalita_pagamento`),
  KEY `intestazione_id_provincia` (`intestazione_id_provincia`),
  KEY `spedizione_id_provincia` (`spedizione_id_provincia`),
  KEY `spedizione_id_stato` (`spedizione_id_stato`),
  KEY `intestazione_id_stato` (`intestazione_id_stato`),
  KEY `id_zona` (`id_zona`),
  KEY `id_tipologia_documento_carrello` (`id_tipologia_documento_carrello`),
  KEY `intestazione_id_anagrafica` (`intestazione_id_anagrafica`),
  KEY `id_modalita_spedizione` (`id_modalita_spedizione`),
  CONSTRAINT `carrelli_ibfk_10` FOREIGN KEY (`intestazione_id_provincia`) REFERENCES `provincie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `carrelli_ibfk_10_nofollow` FOREIGN KEY (`id_assicurazione_trasporto`) REFERENCES `assicurazioni_trasporto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `carrelli_ibfk_11` FOREIGN KEY (`intestazione_id_stato`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `carrelli_ibfk_11_nofollow` FOREIGN KEY (`id_assicurazione_montaggio`) REFERENCES `assicurazioni_montaggio` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `carrelli_ibfk_12` FOREIGN KEY (`id_tipologia_documento_carrello`) REFERENCES `tipologie_documenti_amministrativi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `carrelli_ibfk_13` FOREIGN KEY (`id_modalita_spedizione`) REFERENCES `modalita_spedizione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `carrelli_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `carrelli_ibfk_2` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `carrelli_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `carrelli_ibfk_3` FOREIGN KEY (`id_tipologia_consegna`) REFERENCES `modalita_consegna` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `carrelli_ibfk_6` FOREIGN KEY (`id_garanzia`) REFERENCES `garanzie_carrelli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `carrelli_ibfk_7` FOREIGN KEY (`id_modalita_pagamento`) REFERENCES `modalita_pagamento` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `carrelli_ibfk_8` FOREIGN KEY (`spedizione_id_provincia`) REFERENCES `provincie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `carrelli_ibfk_9` FOREIGN KEY (`spedizione_id_stato`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `carrelli_articoli`
--

DROP TABLE IF EXISTS `carrelli_articoli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `carrelli_articoli` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_carrello` int(11) NOT NULL,
  `id_articolo` char(32) NOT NULL,
  `id_ingombro` int(11) DEFAULT NULL,
  `ingombro_proporzionale` decimal(16,5) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `id_modalita_spedizione` int(11) DEFAULT NULL,
  `prezzo_lordo_modalita_spedizione` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_spedizione` decimal(16,5) DEFAULT NULL,
  `id_iva` int(11) NOT NULL,
  `prezzo_netto` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo` decimal(16,5) DEFAULT NULL,
  `quantita` decimal(9,3) NOT NULL,
  `prezzo_netto_totale` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_totale` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_complessivo` decimal(16,5) DEFAULT NULL,
  `importo_lordo_sconto` decimal(16,5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `articolo_unico` (`id_carrello`,`id_articolo`),
  KEY `id_carrello` (`id_carrello`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_tipologia_spedizione` (`id_modalita_spedizione`),
  KEY `id_iva` (`id_iva`),
  KEY `id_ingombro` (`id_ingombro`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `carrelli_articoli_ibfk_1` FOREIGN KEY (`id_carrello`) REFERENCES `carrelli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `carrelli_articoli_ibfk_2_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `carrelli_articoli_ibfk_3_nofollow` FOREIGN KEY (`id_modalita_spedizione`) REFERENCES `modalita_spedizione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `carrelli_articoli_ibfk_4_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `carrelli_articoli_view`
--

DROP TABLE IF EXISTS `carrelli_articoli_view`;
/*!50001 DROP VIEW IF EXISTS `carrelli_articoli_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `carrelli_articoli_view` (
  `id` tinyint NOT NULL,
  `id_carrello` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `quantita` tinyint NOT NULL,
  `spedizione` tinyint NOT NULL,
  `iva` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `carrelli_view`
--

DROP TABLE IF EXISTS `carrelli_view`;
/*!50001 DROP VIEW IF EXISTS `carrelli_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `carrelli_view` (
  `id` tinyint NOT NULL,
  `data_ora_apertura` tinyint NOT NULL,
  `prezzo_lordo_complessivo` tinyint NOT NULL,
  `intestazione_nome` tinyint NOT NULL,
  `intestazione_cognome` tinyint NOT NULL,
  `intestazione_indirizzo` tinyint NOT NULL,
  `intestazione_citta` tinyint NOT NULL,
  `intestazione_cap` tinyint NOT NULL,
  `intestazione_provincia` tinyint NOT NULL,
  `intestazione_telefono` tinyint NOT NULL,
  `intestazione_mail` tinyint NOT NULL,
  `ritiro` tinyint NOT NULL,
  `id_modalita_spedizione` tinyint NOT NULL,
  `pagamento` tinyint NOT NULL,
  `assicurazione_trasporto` tinyint NOT NULL,
  `garanzia` tinyint NOT NULL,
  `data_ora_pagamento` tinyint NOT NULL,
  `codice_pagamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cartellini`
--

DROP TABLE IF EXISTS `cartellini`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cartellini` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `data_attivita` date NOT NULL,
  `id_tipologia_inps` int(11) NOT NULL,
  `ore_previste` decimal(5,2) DEFAULT NULL,
  `ore_fatte` decimal(5,2) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`data_attivita`,`id_tipologia_inps`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `data_attivita` (`data_attivita`),
  KEY `id_tipologia_inps` (`id_tipologia_inps`),
  CONSTRAINT `cartellini_ibfk_1_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `cartellini_ibfk_2_nofollow` FOREIGN KEY (`id_tipologia_inps`) REFERENCES `tipologie_attivita_inps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `cartellini_view`
--

DROP TABLE IF EXISTS `cartellini_view`;
/*!50001 DROP VIEW IF EXISTS `cartellini_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `cartellini_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `data_attivita` tinyint NOT NULL,
  `id_tipologia_inps` tinyint NOT NULL,
  `ore_previste` tinyint NOT NULL,
  `ore_fatte` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `tipologia_inps` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `categorie_anagrafica`
--

DROP TABLE IF EXISTS `categorie_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorie_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `se_lead` int(1) DEFAULT NULL,
  `se_prospect` int(1) DEFAULT NULL,
  `se_cliente` int(1) DEFAULT NULL,
  `se_mandante` int(1) DEFAULT NULL,
  `se_fornitore` int(1) DEFAULT NULL,
  `se_produttore` int(1) DEFAULT NULL,
  `se_collaboratore` int(1) DEFAULT NULL,
  `se_dipendente` int(1) DEFAULT NULL,
  `se_interinale` int(1) DEFAULT NULL,
  `se_interno` int(1) DEFAULT NULL,
  `se_esterno` int(1) DEFAULT NULL,
  `se_agente` int(1) DEFAULT NULL,
  `se_concorrente` int(1) DEFAULT NULL,
  `se_rassegna_stampa` int(1) DEFAULT NULL,
  `se_azienda_gestita` int(1) DEFAULT NULL,
  `se_amministrazione` int(1) DEFAULT NULL,
  `se_notizie` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `se_docente` int(1) DEFAULT NULL,
  `se_tutor` int(1) DEFAULT NULL,
  `se_classe` int(1) DEFAULT NULL,
  `se_allievo` int(1) DEFAULT NULL,
  `se_agenzia_interinale` int(1) DEFAULT NULL,
  `se_referente` int(1) DEFAULT NULL,
  `se_sostituto` int(1) DEFAULT NULL,
  `se_squadra` int(1) DEFAULT NULL,
  `se_produzione` int(1) DEFAULT NULL,
  `se_emittente` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `se_rassegna_stampa` (`se_rassegna_stampa`),
  KEY `se_agente` (`se_agente`),
  KEY `se_mandante` (`se_mandante`),
  KEY `se_fornitore` (`se_fornitore`),
  KEY `se_collaboratore` (`se_collaboratore`),
  KEY `se_interno` (`se_interno`),
  KEY `se_esterno` (`se_esterno`),
  KEY `se_concorrente` (`se_concorrente`),
  KEY `se_interinale` (`se_interinale`),
  KEY `se_agenzia_interinale` (`se_agenzia_interinale`),
  KEY `se_dipendente` (`se_dipendente`),
  KEY `se_referente` (`se_referente`),
  KEY `se_sostituto` (`se_sostituto`),
  KEY `se_squadra` (`se_squadra`),
  KEY `se_produzione` (`se_produzione`),
  KEY `se_emittente` (`se_emittente`),
  CONSTRAINT `categorie_anagrafica_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_anagrafica_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_anagrafica_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `categorie_anagrafica_view`
--

DROP TABLE IF EXISTS `categorie_anagrafica_view`;
/*!50001 DROP VIEW IF EXISTS `categorie_anagrafica_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `categorie_anagrafica_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_lead` tinyint NOT NULL,
  `se_prospect` tinyint NOT NULL,
  `se_cliente` tinyint NOT NULL,
  `se_mandante` tinyint NOT NULL,
  `se_fornitore` tinyint NOT NULL,
  `se_produttore` tinyint NOT NULL,
  `se_collaboratore` tinyint NOT NULL,
  `se_dipendente` tinyint NOT NULL,
  `se_interinale` tinyint NOT NULL,
  `se_interno` tinyint NOT NULL,
  `se_esterno` tinyint NOT NULL,
  `se_agente` tinyint NOT NULL,
  `se_concorrente` tinyint NOT NULL,
  `se_rassegna_stampa` tinyint NOT NULL,
  `se_azienda_gestita` tinyint NOT NULL,
  `se_amministrazione` tinyint NOT NULL,
  `se_notizie` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `se_docente` tinyint NOT NULL,
  `se_tutor` tinyint NOT NULL,
  `se_classe` tinyint NOT NULL,
  `se_allievo` tinyint NOT NULL,
  `se_agenzia_interinale` tinyint NOT NULL,
  `se_referente` tinyint NOT NULL,
  `se_sostituto` tinyint NOT NULL,
  `se_squadra` tinyint NOT NULL,
  `se_produzione` tinyint NOT NULL,
  `se_emittente` tinyint NOT NULL,
  `membri` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `categorie_attivita`
--

DROP TABLE IF EXISTS `categorie_attivita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorie_attivita` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `categorie_attivita_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_attivita_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_attivita_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `categorie_attivita_view`
--

DROP TABLE IF EXISTS `categorie_attivita_view`;
/*!50001 DROP VIEW IF EXISTS `categorie_attivita_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `categorie_attivita_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `categorie_diritto`
--

DROP TABLE IF EXISTS `categorie_diritto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorie_diritto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(128) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`),
  KEY `id_genitore` (`id_genitore`),
  CONSTRAINT `categorie_diritto_ibfk_1` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_diritto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `categorie_diritto_view`
--

DROP TABLE IF EXISTS `categorie_diritto_view`;
/*!50001 DROP VIEW IF EXISTS `categorie_diritto_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `categorie_diritto_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `n_figli` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `categorie_eventi`
--

DROP TABLE IF EXISTS `categorie_eventi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorie_eventi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `id_tipologia_pubblicazione` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_pagina` (`id_pagina`),
  KEY `indice` (`id`,`id_genitore`,`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
  CONSTRAINT `categorie_eventi_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_eventi_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_eventi_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_eventi_ibfk_4_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_eventi_ibfk_5_nofollow` FOREIGN KEY (`id_tipologia_pubblicazione`) REFERENCES `tipologie_pubblicazione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `categorie_eventi_view`
--

DROP TABLE IF EXISTS `categorie_eventi_view`;
/*!50001 DROP VIEW IF EXISTS `categorie_eventi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `categorie_eventi_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_tipologia_pubblicazione` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `se_pubblicato` tinyint NOT NULL,
  `pubblicazione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `categorie_notizie`
--

DROP TABLE IF EXISTS `categorie_notizie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorie_notizie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `menu` char(64) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `id_tipologia_pubblicazione` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_pagina` (`id_pagina`),
  KEY `indice` (`id`,`id_genitore`,`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
  CONSTRAINT `categorie_notizie_ibfk_1` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_notizie_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_notizie_ibfk_2` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_notizie_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_notizie_ibfk_3_nofollow` FOREIGN KEY (`id_tipologia_pubblicazione`) REFERENCES `tipologie_pubblicazione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `categorie_notizie_view`
--

DROP TABLE IF EXISTS `categorie_notizie_view`;
/*!50001 DROP VIEW IF EXISTS `categorie_notizie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `categorie_notizie_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `menu` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_tipologia_pubblicazione` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `se_pubblicato` tinyint NOT NULL,
  `pubblicazione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `categorie_prodotti`
--

DROP TABLE IF EXISTS `categorie_prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorie_prodotti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(32) DEFAULT NULL,
  `menu` char(64) DEFAULT NULL,
  `se_sitemap` int(1) DEFAULT NULL,
  `se_cacheable` int(1) DEFAULT NULL,
  `note` text,
  `id_tipologia_pubblicazione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_pagina` (`id_pagina`),
  KEY `indice` (`id`,`id_genitore`,`nome`),
  KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_sito` (`id_sito`),
  CONSTRAINT `categorie_prodotti_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_prodotti_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_prodotti_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_prodotti_ibfk_4_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_prodotti_ibfk_5_nofollow` FOREIGN KEY (`id_tipologia_pubblicazione`) REFERENCES `tipologie_pubblicazione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categorie_prodotti_caratteristiche`
--

DROP TABLE IF EXISTS `categorie_prodotti_caratteristiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorie_prodotti_caratteristiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_categoria` int(11) NOT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `se_non_presente` int(1) DEFAULT NULL,
  `se_visibile` int(1) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `testo` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_categoria` (`id_categoria`,`id_caratteristica`),
  KEY `ordine` (`ordine`),
  KEY `indice` (`id`,`id_categoria`,`id_caratteristica`,`ordine`),
  KEY `id_caratteristica` (`id_caratteristica`),
  CONSTRAINT `categorie_prodotti_caratteristiche_ibfk_1` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_prodotti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `categorie_prodotti_caratteristiche_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `categorie_prodotti_caratteristiche_view`
--

DROP TABLE IF EXISTS `categorie_prodotti_caratteristiche_view`;
/*!50001 DROP VIEW IF EXISTS `categorie_prodotti_caratteristiche_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `categorie_prodotti_caratteristiche_view` (
  `id` tinyint NOT NULL,
  `id_categoria` tinyint NOT NULL,
  `id_caratteristica` tinyint NOT NULL,
  `se_non_presente` tinyint NOT NULL,
  `se_visibile` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `categorie_prodotti_view`
--

DROP TABLE IF EXISTS `categorie_prodotti_view`;
/*!50001 DROP VIEW IF EXISTS `categorie_prodotti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `categorie_prodotti_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_sito` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `template` tinyint NOT NULL,
  `schema_html` tinyint NOT NULL,
  `tema_css` tinyint NOT NULL,
  `menu` tinyint NOT NULL,
  `se_sitemap` tinyint NOT NULL,
  `se_cacheable` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_tipologia_pubblicazione` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `se_pubblicato` tinyint NOT NULL,
  `pubblicazione` tinyint NOT NULL,
  `numero_prodotti` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `categorie_progetti`
--

DROP TABLE IF EXISTS `categorie_progetti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorie_progetti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `se_ordinario` int(1) DEFAULT NULL,
  `se_straordinario` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `se_ordinario` (`se_ordinario`),
  KEY `se_straordinario` (`se_straordinario`),
  CONSTRAINT `categorie_progetti_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_progetti_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_progetti_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `categorie_progetti_view`
--

DROP TABLE IF EXISTS `categorie_progetti_view`;
/*!50001 DROP VIEW IF EXISTSmysqldump: Couldn't execute 'show create table `certificazioni_archiviati_view`': View '__glisweb__.certificazioni_archiviati_view' references invalid table(s) or column(s) or function(s) or definer/invoker of view lack rights to use them (1356)
 `categorie_progetti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `categorie_progetti_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_ordinario` tinyint NOT NULL,
  `se_straordinario` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `categorie_risorse`
--

DROP TABLE IF EXISTS `categorie_risorse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorie_risorse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `menu` char(64) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_pagina` (`id_pagina`),
  CONSTRAINT `categorie_risorse_ibfk_1` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_risorse` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `categorie_risorse_ibfk_2` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `categorie_risorse_view`
--

DROP TABLE IF EXISTS `categorie_risorse_view`;
/*!50001 DROP VIEW IF EXISTS `categorie_risorse_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `categorie_risorse_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `menu` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `certificazioni`
--

DROP TABLE IF EXISTS `certificazioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `certificazioni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`),
  KEY `id_tipologia` (`id_tipologia`),
  CONSTRAINT `certificazioni_ibfk_1_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_certificazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
