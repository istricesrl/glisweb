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
  CONSTRAINT `anagrafica_certificazioni_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_certificazioni_ibfk_2` FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
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
  `id_tipologia_certificazione` tinyint NOT NULL,
  `tipologia_certificazione` tinyint NOT NULL,
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
  `se_prodotto` tinyint NOT NULL,
  `se_servizio` tinyint NOT NULL,
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
  `ore_programmazione` int(11) DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `note_programmazione` text,
  `id_pratica` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_campagna` int(11) DEFAULT NULL,
  `id_task` int(11) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_tipologia_interesse` int(11) DEFAULT NULL,
  `id_tipologia_soddisfazione` int(11) DEFAULT NULL,
  `id_anagrafica_feedback` int(11) DEFAULT NULL,
  `timestamp_feedback` int(11) DEFAULT NULL,
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
  KEY `id_anagrafica_feedback` (`id_anagrafica_feedback`),
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
  CONSTRAINT `attivita_ibfk_24_nofollow` FOREIGN KEY (`id_anagrafica_feedback`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_2_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_3` FOREIGN KEY (`id_esito`) REFERENCES `esiti_attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_3_nofollow` FOREIGN KEY (`id_mandante`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_4_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
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
  `id_anagrafica` tinyint NOT NULL,
  `id_assente` tinyint NOT NULL,
  `assente` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `data_programmazione` tinyint NOT NULL,
  `ora_inizio_programmazione` tinyint NOT NULL,
  `ora_fine_programmazione` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `todo` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `richieste` tinyint NOT NULL,
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
  `note_programmazione` tinyint NOT NULL,
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
  `se_ordinario` tinyint NOT NULL,
  `se_straordinario` tinyint NOT NULL,
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
  `note_programmazione` text,
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
  `se_ordinario` int(1) DEFAULT NULL,
  `se_straordinario` int(1) DEFAULT NULL,
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
  KEY `se_master` (`se_master`),
  KEY `se_ordinario` (`se_ordinario`),
  KEY `se_straordinario` (`se_straordinario`)
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
  `n_contatti` tinyint NOT NULL,
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
  `se_ordinario` int(1) DEFAULT NULL,
  `se_straordinario` int(1) DEFAULT NULL,
  `se_produzione` int(1) DEFAULT NULL,
  `se_ticket` int(1) DEFAULT NULL,
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
  KEY `se_produzione` (`se_produzione`),
  KEY `se_ticket` (`se_ticket`),
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
  `se_ordinario` tinyint NOT NULL,
  `se_straordinario` tinyint NOT NULL,
  `se_produzione` tinyint NOT NULL,
  `se_ticket` tinyint NOT NULL,
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
  `id_sito` int(11) DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(32) DEFAULT NULL,
  `se_sitemap` int(1) DEFAULT NULL,
  `se_cacheable` int(1) DEFAULT NULL,
  `note` text,
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
  KEY `id_sito` (`id_sito`),
  CONSTRAINT `categorie_notizie_ibfk_1` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_notizie_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_notizie_ibfk_2` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_notizie_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
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
  `id_sito` tinyint NOT NULL,
  `template` tinyint NOT NULL,
  `schema_html` tinyint NOT NULL,
  `tema_css` tinyint NOT NULL,
  `se_sitemap` tinyint NOT NULL,
  `se_cacheable` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
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
/*!50001 DROP VIEW IF EXISTS `categorie_progetti_view`*/;
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

--
-- Temporary table structure for view `certificazioni_view`
--

DROP TABLE IF EXISTS `certificazioni_view`;
/*!50001 DROP VIEW IF EXISTS `certificazioni_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `certificazioni_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `classi_energetiche_immobili`
--

DROP TABLE IF EXISTS `classi_energetiche_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classi_energetiche_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(8) NOT NULL,
  `ep_min` int(11) DEFAULT NULL,
  `ep_max` int(11) DEFAULT NULL,
  `rgb` char(8) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `classi_energetiche_immobili_view`
--

DROP TABLE IF EXISTS `classi_energetiche_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `classi_energetiche_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `classi_energetiche_immobili_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `ep_min` tinyint NOT NULL,
  `ep_max` tinyint NOT NULL,
  `rgb` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `codici_tracking`
--

DROP TABLE IF EXISTS `codici_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `codici_tracking` (
  `id` char(64) NOT NULL,
  `nome` int(11) NOT NULL,
  `note` int(11) NOT NULL,
  `id_campagna` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_campagna` (`id_campagna`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `codici_tracking_ibfk_1_nofollow` FOREIGN KEY (`id_campagna`) REFERENCES `campagne` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `codici_tracking_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `codici_tracking_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `codici_tracking_view`
--

DROP TABLE IF EXISTS `codici_tracking_view`;
/*!50001 DROP VIEW IF EXISTS `codici_tracking_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `codici_tracking_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_campagna` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `colori`
--

DROP TABLE IF EXISTS `colori`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colori` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(16) NOT NULL,
  `hex` char(8) DEFAULT NULL,
  `r` int(3) DEFAULT NULL,
  `g` int(3) DEFAULT NULL,
  `b` int(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `colori_view`
--

DROP TABLE IF EXISTS `colori_view`;
/*!50001 DROP VIEW IF EXISTS `colori_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `colori_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `hex` tinyint NOT NULL,
  `r` tinyint NOT NULL,
  `g` tinyint NOT NULL,
  `b` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `comuni`
--

DROP TABLE IF EXISTS `comuni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comuni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_provincia` int(11) NOT NULL,
  `nome` varchar(254) NOT NULL,
  `codice_istat` char(12) DEFAULT NULL,
  `codice_catasto` char(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codice_istat` (`codice_istat`),
  UNIQUE KEY `codice_catasto` (`codice_catasto`),
  KEY `id_provincia` (`id_provincia`),
  KEY `indice` (`id`,`id_provincia`,`nome`),
  CONSTRAINT `comuni_ibfk_2_nofollow` FOREIGN KEY (`id_provincia`) REFERENCES `provincie` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `comuni_view`
--

DROP TABLE IF EXISTS `comuni_view`;
/*!50001 DROP VIEW IF EXISTS `comuni_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `comuni_view` (
  `id` tinyint NOT NULL,
  `id_provincia` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `codice_istat` tinyint NOT NULL,
  `codice_catasto` tinyint NOT NULL,
  `provincia` tinyint NOT NULL,
  `id_regione` tinyint NOT NULL,
  `regione` tinyint NOT NULL,
  `id_stato` tinyint NOT NULL,
  `stato` tinyint NOT NULL,
  `id_continente` tinyint NOT NULL,
  `continente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `condizioni_immobili`
--

DROP TABLE IF EXISTS `condizioni_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `condizioni_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `condizioni_immobili_view`
--

DROP TABLE IF EXISTS `condizioni_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `condizioni_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `condizioni_immobili_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `condizioni_pagamento`
--

DROP TABLE IF EXISTS `condizioni_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `condizioni_pagamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `descrizione` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `condizioni_pagamento_view`
--

DROP TABLE IF EXISTS `condizioni_pagamento_view`;
/*!50001 DROP VIEW IF EXISTS `condizioni_pagamento_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `condizioni_pagamento_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `contatti`
--

DROP TABLE IF EXISTS `contatti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contatti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `data_contatto` date DEFAULT NULL,
  `ora_contatto` time DEFAULT NULL,
  `json` text,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_segnalatore` int(11) DEFAULT NULL,
  `id_campagna` int(11) DEFAULT NULL,
  `note` text,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_segnalatore` (`id_segnalatore`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_coount_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_campagna` (`id_campagna`),
  CONSTRAINT `contatti_ibfk_1` FOREIGN KEY (`id_segnalatore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contatti_ibfk_1_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contatti_ibfk_2` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_contatti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contatti_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contatti_ibfk_3` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contatti_ibfk_6` FOREIGN KEY (`id_campagna`) REFERENCES `campagne` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `contatti_view`
--

DROP TABLE IF EXISTS `contatti_view`;
/*!50001 DROP VIEW IF EXISTS `contatti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `contatti_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `data_contatto` tinyint NOT NULL,
  `ora_contatto` tinyint NOT NULL,
  `json` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_segnalatore` tinyint NOT NULL,
  `id_campagna` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `segnalatore` tinyint NOT NULL,
  `campagna` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `contenuti`
--

DROP TABLE IF EXISTS `contenuti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contenuti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_caratteristica_prodotti` int(11) DEFAULT NULL,
  `id_marchio` int(11) DEFAULT NULL,
  `id_immagine` int(11) DEFAULT NULL,
  `id_file` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_popup` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_incarico` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_rassegna_stampa` int(11) DEFAULT NULL,
  `id_evento` int(11) DEFAULT NULL,
  `id_categoria_eventi` int(11) DEFAULT NULL,
  `id_video` int(11) DEFAULT NULL,
  `id_audio` int(11) DEFAULT NULL,
  `id_data` int(11) DEFAULT NULL,
  `id_template_mail` int(11) DEFAULT NULL,
  `id_mailing` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_lingua` int(11) NOT NULL,
  `id_colore` int(11) DEFAULT NULL,
  `path_custom` char(255) DEFAULT NULL,
  `url_custom` char(255) DEFAULT NULL,
  `rewrite_custom` char(255) DEFAULT NULL,
  `title` char(255) DEFAULT NULL,
  `keywords` text,
  `description` text,
  `alt` char(255) DEFAULT NULL,
  `og_title` char(255) DEFAULT NULL,
  `og_type` char(255) DEFAULT NULL,
  `og_image` char(255) DEFAULT NULL,
  `og_audio` char(255) DEFAULT NULL,
  `og_video` char(255) DEFAULT NULL,
  `og_determiner` char(255) DEFAULT NULL,
  `og_description` char(255) DEFAULT NULL,
  `cappello` text,
  `h1` char(255) DEFAULT NULL,
  `h2` char(255) DEFAULT NULL,
  `h3` char(255) DEFAULT NULL,
  `label_menu` char(255) DEFAULT NULL,
  `abstract` text,
  `testo` text,
  `applicazioni` text,
  `specifiche` text,
  `mittente_nome` char(128) DEFAULT NULL,
  `mittente_mail` char(128) DEFAULT NULL,
  `destinatario_nome` char(128) DEFAULT NULL,
  `destinatario_mail` char(128) DEFAULT NULL,
  `destinatario_cc_nome` char(128) DEFAULT NULL,
  `destinatario_cc_mail` char(128) DEFAULT NULL,
  `destinatario_ccn_nome` char(128) DEFAULT NULL,
  `destinatario_ccn_mail` char(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_prodotto_unico` (`id_prodotto`,`id_lingua`),
  UNIQUE KEY `id_categoria_prodotti_unico` (`id_categoria_prodotti`,`id_lingua`),
  UNIQUE KEY `id_eventi_unico` (`id_evento`,`id_lingua`),
  UNIQUE KEY `id_categoria_eventi_unico` (`id_categoria_eventi`,`id_lingua`),
  UNIQUE KEY `id_immagine_unico` (`id_immagine`,`id_lingua`),
  UNIQUE KEY `id_file_unico` (`id_file`,`id_lingua`),
  UNIQUE KEY `id_pagina_unico` (`id_pagina`,`id_lingua`),
  UNIQUE KEY `id_rassegna_stampa_unico` (`id_rassegna_stampa`,`id_lingua`),
  UNIQUE KEY `id_video_unico` (`id_video`,`id_lingua`),
  UNIQUE KEY `id_audio_unico` (`id_audio`,`id_lingua`),
  UNIQUE KEY `id_articolo_unico` (`id_articolo`,`id_lingua`),
  UNIQUE KEY `id_marchio_unico` (`id_marchio`,`id_lingua`),
  UNIQUE KEY `id_caratteristica_prodotti_unico` (`id_caratteristica_prodotti`,`id_lingua`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_evento` (`id_evento`),
  KEY `id_categoria_eventi` (`id_categoria_eventi`),
  KEY `id_data` (`id_data`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_rassegna_stampa` (`id_rassegna_stampa`),
  KEY `id_immagine` (`id_immagine`),
  KEY `id_video` (`id_video`),
  KEY `id_audio` (`id_audio`),
  KEY `id_file` (`id_file`),
  KEY `id_template_mail` (`id_template_mail`),
  KEY `id_mailing` (`id_mailing`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_immobile` (`id_immobile`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_zona` (`id_zona`),
  KEY `id_incarico` (`id_incarico`),
  KEY `id_colore` (`id_colore`),
  KEY `id_caratteristica_prodotti` (`id_caratteristica_prodotti`),
  KEY `id_popup` (`id_popup`),
  KEY `id_marchio` (`id_marchio`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  CONSTRAINT `contenuti_ibfk_1` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_10` FOREIGN KEY (`id_categoria_eventi`) REFERENCES `categorie_eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_11` FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_12` FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_13` FOREIGN KEY (`id_template_mail`) REFERENCES `template_mail` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_14` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_15` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_16` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_17` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_18` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_19` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_2` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_20` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_21` FOREIGN KEY (`id_incarico`) REFERENCES `incarichi_immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_22` FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_23` FOREIGN KEY (`id_caratteristica_prodotti`) REFERENCES `caratteristiche_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_24` FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_25` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_26` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_27` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_28` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_3` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_4_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `contenuti_ibfk_5` FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_6` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_7` FOREIGN KEY (`id_rassegna_stampa`) REFERENCES `rassegna_stampa` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_8` FOREIGN KEY (`id_evento`) REFERENCES `eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_9` FOREIGN KEY (`id_data`) REFERENCES `date` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `contenuti_view`
--

DROP TABLE IF EXISTS `contenuti_view`;
/*!50001 DROP VIEW IF EXISTS `contenuti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `contenuti_view` (
  `id` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_popup` tinyint NOT NULL,
  `id_immagine` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `id_marchio` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `id_notizia` tinyint NOT NULL,
  `id_categoria_notizie` tinyint NOT NULL,
  `id_evento` tinyint NOT NULL,
  `id_categoria_eventi` tinyint NOT NULL,
  `id_file` tinyint NOT NULL,
  `id_risorsa` tinyint NOT NULL,
  `id_audio` tinyint NOT NULL,
  `id_video` tinyint NOT NULL,
  `id_lingua` tinyint NOT NULL,
  `title` tinyint NOT NULL,
  `keywords` tinyint NOT NULL,
  `h1` tinyint NOT NULL,
  `h2` tinyint NOT NULL,
  `h3` tinyint NOT NULL,
  `abstract` tinyint NOT NULL,
  `cappello` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `alt` tinyint NOT NULL,
  `og_title` tinyint NOT NULL,
  `og_type` tinyint NOT NULL,
  `og_image` tinyint NOT NULL,
  `og_audio` tinyint NOT NULL,
  `og_video` tinyint NOT NULL,
  `og_determiner` tinyint NOT NULL,
  `og_description` tinyint NOT NULL,
  `path_custom` tinyint NOT NULL,
  `url_custom` tinyint NOT NULL,
  `rewrite_custom` tinyint NOT NULL,
  `specifiche` tinyint NOT NULL,
  `label_menu` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `continenti`
--

DROP TABLE IF EXISTS `continenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `continenti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codice` char(2) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `indice` (`id`,`codice`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `continenti_view`
--

DROP TABLE IF EXISTS `continenti_view`;
/*!50001 DROP VIEW IF EXISTS `continenti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `continenti_view` (
  `id` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `contratti`
--

DROP TABLE IF EXISTS `contratti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contratti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_agenzia` int(11) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `data_inizio_rapporto` date DEFAULT NULL,
  `data_fine_rapporto` date DEFAULT NULL,
  `livello` char(64) DEFAULT NULL,
  `id_tipologia_qualifica` char(32) DEFAULT NULL,
  `id_tipologia_durata` char(32) DEFAULT NULL,
  `id_tipologia_orario` char(32) DEFAULT NULL,
  `ore_settimanali` decimal(5,2) DEFAULT NULL,
  `proroghe` int(11) DEFAULT NULL,
  `note` text,
  `percentuale_part_time` decimal(6,3) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_tipologia_qualifica` (`id_tipologia_qualifica`),
  KEY `id_tipologia_durata` (`id_tipologia_durata`),
  KEY `id_tipologia_orario` (`id_tipologia_orario`),
  KEY `id_agenzia` (`id_agenzia`),
  CONSTRAINT `contratti_ibfk_1` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_contratti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `contratti_ibfk_2` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `contratti_ibfk_3` FOREIGN KEY (`id_tipologia_qualifica`) REFERENCES `tipologie_qualifiche_inps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `contratti_ibfk_4` FOREIGN KEY (`id_tipologia_durata`) REFERENCES `tipologie_durate_inps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `contratti_ibfk_5` FOREIGN KEY (`id_tipologia_orario`) REFERENCES `tipologie_orari_inps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `contratti_ibfk_6` FOREIGN KEY (`id_agenzia`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `contratti_archiviati_view`
--

DROP TABLE IF EXISTS `contratti_archiviati_view`;
/*!50001 DROP VIEW IF EXISTS `contratti_archiviati_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `contratti_archiviati_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `data_inizio_rapporto` tinyint NOT NULL,
  `data_fine_rapporto` tinyint NOT NULL,
  `livello` tinyint NOT NULL,
  `id_tipologia_qualifica` tinyint NOT NULL,
  `id_tipologia_durata` tinyint NOT NULL,
  `id_tipologia_orario` tinyint NOT NULL,
  `ore_settimanali` tinyint NOT NULL,
  `proroghe` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `percentuale_part_time` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `agenzia` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `tipologia_qualifica` tinyint NOT NULL,
  `tipologia_durata` tinyint NOT NULL,
  `tipologia_orario` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `contratti_completa_view`
--

DROP TABLE IF EXISTS `contratti_completa_view`;
/*!50001 DROP VIEW IF EXISTS `contratti_completa_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `contratti_completa_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `data_inizio_rapporto` tinyint NOT NULL,
  `data_fine_rapporto` tinyint NOT NULL,
  `livello` tinyint NOT NULL,
  `id_tipologia_qualifica` tinyint NOT NULL,
  `id_tipologia_durata` tinyint NOT NULL,
  `id_tipologia_orario` tinyint NOT NULL,
  `ore_settimanali` tinyint NOT NULL,
  `proroghe` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `percentuale_part_time` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `agenzia` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `tipologia_qualifica` tinyint NOT NULL,
  `tipologia_durata` tinyint NOT NULL,
  `tipologia_orario` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `contratti_view`
--

DROP TABLE IF EXISTS `contratti_view`;
/*!50001 DROP VIEW IF EXISTS `contratti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `contratti_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `data_inizio_rapporto` tinyint NOT NULL,
  `data_fine_rapporto` tinyint NOT NULL,
  `livello` tinyint NOT NULL,
  `id_tipologia_qualifica` tinyint NOT NULL,
  `id_tipologia_durata` tinyint NOT NULL,
  `id_tipologia_orario` tinyint NOT NULL,
  `ore_settimanali` tinyint NOT NULL,
  `proroghe` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `percentuale_part_time` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `agenzia` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `tipologia_qualifica` tinyint NOT NULL,
  `tipologia_durata` tinyint NOT NULL,
  `tipologia_orario` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `costi_contratti`
--

DROP TABLE IF EXISTS `costi_contratti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `costi_contratti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_contratto` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `note` text,
  `costo_orario` decimal(16,5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_contratto`,`id_tipologia`),
  KEY `id_contratto` (`id_contratto`),
  KEY `id_tipologia` (`id_tipologia`),
  CONSTRAINT `costi_contratti_ibfk_1` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `costi_contratti_ibfk_2` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_attivita_inps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `costi_contratti_view`
--

DROP TABLE IF EXISTS `costi_contratti_view`;
/*!50001 DROP VIEW IF EXISTS `costi_contratti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `costi_contratti_view` (
  `id` tinyint NOT NULL,
  `id_contratto` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `costo_orario` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `coupon`
--

DROP TABLE IF EXISTS `coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coupon` (
  `id` char(32) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `timestamp_inizio` int(11) DEFAULT NULL,
  `timestamp_fine` int(11) DEFAULT NULL,
  `sconto_percentuale` decimal(5,2) DEFAULT NULL,
  `sconto_fisso` decimal(15,2) DEFAULT NULL,
  `se_multiuso` int(1) DEFAULT '1',
  `se_globale` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `coupon_categorie_prodotti`
--

DROP TABLE IF EXISTS `coupon_categorie_prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coupon_categorie_prodotti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_coupon` char(32) NOT NULL,
  `id_categoria_prodotti` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  CONSTRAINT `coupon_categorie_prodotti_ibfk_1` FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_categorie_prodotti_ibfk_2` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `coupon_categorie_prodotti_view`
--

DROP TABLE IF EXISTS `coupon_categorie_prodotti_view`;
/*!50001 DROP VIEW IF EXISTS `coupon_categorie_prodotti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `coupon_categorie_prodotti_view` (
  `id` tinyint NOT NULL,
  `id_coupon` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `nome_coupon` tinyint NOT NULL,
  `inizio_validita` tinyint NOT NULL,
  `fine_validita` tinyint NOT NULL,
  `sconto_percentuale` tinyint NOT NULL,
  `sconto_fisso` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `coupon_listini`
--

DROP TABLE IF EXISTS `coupon_listini`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coupon_listini` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_coupon` char(32) NOT NULL,
  `id_listino` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_listino` (`id_listino`),
  CONSTRAINT `coupon_listini_ibfk_1` FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_listini_ibfk_2` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `coupon_marchi`
--

DROP TABLE IF EXISTS `coupon_marchi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coupon_marchi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_coupon` char(32) NOT NULL,
  `id_marchio` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_marchio` (`id_marchio`),
  CONSTRAINT `coupon_marchi_ibfk_1` FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_marchi_ibfk_2` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `coupon_prodotti`
--

DROP TABLE IF EXISTS `coupon_prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coupon_prodotti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_coupon` char(32) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_prodotto` (`id_prodotto`),
  CONSTRAINT `coupon_prodotti_ibfk_1` FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_prodotti_ibfk_2` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `coupon_stagioni`
--

DROP TABLE IF EXISTS `coupon_stagioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coupon_stagioni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_coupon` char(32) NOT NULL,
  `id_stagione` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_stagione` (`id_stagione`),
  CONSTRAINT `coupon_stagioni_ibfk_1` FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_stagioni_ibfk_2` FOREIGN KEY (`id_stagione`) REFERENCES `stagioni_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `coupon_view`
--

DROP TABLE IF EXISTS `coupon_view`;
/*!50001 DROP VIEW IF EXISTS `coupon_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `coupon_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `timestamp_inizio` tinyint NOT NULL,
  `timestamp_fine` tinyint NOT NULL,
  `sconto_percentuale` tinyint NOT NULL,
  `sconto_fisso` tinyint NOT NULL,
  `se_multiuso` tinyint NOT NULL,
  `se_globale` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `inizio_validita` tinyint NOT NULL,
  `fine_validita` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cron`
--

DROP TABLE IF EXISTS `cron`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cron` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `minuto` int(11) DEFAULT NULL,
  `ora` int(11) DEFAULT NULL,
  `giorno_del_mese` int(11) DEFAULT NULL,
  `mese` int(11) DEFAULT NULL,
  `giorno_della_settimana` int(11) DEFAULT NULL,
  `settimana` int(11) DEFAULT NULL,
  `task` char(255) NOT NULL,
  `iterazioni` int(11) DEFAULT NULL,
  `delay` int(11) DEFAULT NULL,
  `token` char(254) DEFAULT NULL,
  `timestamp_esecuzione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `indice` (`id`,`minuto`,`ora`,`giorno_del_mese`,`mese`,`giorno_della_settimana`,`settimana`,`task`,`iterazioni`,`timestamp_esecuzione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `token` (`token`),
  CONSTRAINT `cron_ibfk_1` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `cron_ibfk_2` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cron_log`
--

DROP TABLE IF EXISTS `cron_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cron_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_cron` int(11) NOT NULL,
  `testo` text,
  `timestamp_esecuzione` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_cron` (`id_cron`),
  KEY `indice` (`id`,`id_cron`,`timestamp_esecuzione`),
  CONSTRAINT `cron_log_ibfk_1_nofollow` FOREIGN KEY (`id_cron`) REFERENCES `cron` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `cron_log_view`
--

DROP TABLE IF EXISTS `cron_log_view`;
/*!50001 DROP VIEW IF EXISTS `cron_log_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `cron_log_view` (
  `id` tinyint NOT NULL,
  `id_cron` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `timestamp_esecuzione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `cron_view`
--

DROP TABLE IF EXISTS `cron_view`;
/*!50001 DROP VIEW IF EXISTS `cron_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `cron_view` (
  `id` tinyint NOT NULL,
  `minuto` tinyint NOT NULL,
  `ora` tinyint NOT NULL,
  `giorno_del_mese` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `giorno_della_settimana` tinyint NOT NULL,
  `settimana` tinyint NOT NULL,
  `task` tinyint NOT NULL,
  `iterazioni` tinyint NOT NULL,
  `delay` tinyint NOT NULL,
  `token` tinyint NOT NULL,
  `timestamp_esecuzione` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `date`
--

DROP TABLE IF EXISTS `date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `date` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_evento` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_tipologia_pubblicazione` int(11) DEFAULT NULL,
  `timestamp_inizio` int(11) DEFAULT NULL,
  `timestamp_fine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_evento` (`id_evento`),
  KEY `id_luogo` (`id_luogo`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
  CONSTRAINT `date_ibfk_1` FOREIGN KEY (`id_evento`) REFERENCES `eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `date_ibfk_2` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `date_ibfk_2_no` FOREIGN KEY (`id_tipologia_pubblicazione`) REFERENCES `tipologie_pubblicazione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `date_ibfk_2_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `date_ibfk_3_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_date` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `date_ibfk_4_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `date_ibfk_5_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `date_view`
--

DROP TABLE IF EXISTS `date_view`;
/*!50001 DROP VIEW IF EXISTS `date_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `date_view` (
  `id` tinyint NOT NULL,
  `id_evento` tinyint NOT NULL,
  `id_notizia` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_luogo` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_tipologia_pubblicazione` tinyint NOT NULL,
  `timestamp_inizio` tinyint NOT NULL,
  `timestamp_fine` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `luogo` tinyint NOT NULL,
  `evento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `disponibilita_immobili`
--

DROP TABLE IF EXISTS `disponibilita_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `disponibilita_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  `se_disponibile` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `disponibilita_immobili_view`
--

DROP TABLE IF EXISTS `disponibilita_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `disponibilita_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `disponibilita_immobili_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_disponibile` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `documenti`
--

DROP TABLE IF EXISTS `documenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `documenti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero` int(11) NOT NULL,
  `sezionale` char(6) DEFAULT NULL,
  `id_tipologia` int(11) NOT NULL,
  `id_contatto` int(11) DEFAULT NULL,
  `data` date NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_destinatario` int(11) DEFAULT NULL,
  `id_sede_destinatario` int(11) DEFAULT NULL,
  `id_emittente` int(11) NOT NULL,
  `id_sede_emittente` int(11) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `coupon` char(32) DEFAULT NULL,
  `note_interne` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_chiusura` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`numero`,`id_tipologia`,`data`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_destinatario` (`id_destinatario`),
  KEY `id_sede_destinatario` (`id_sede_destinatario`),
  KEY `id_emittente` (`id_emittente`),
  KEY `id_sede_emittente` (`id_sede_emittente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_todo` (`id_todo`),
  KEY `id_contatto` (`id_contatto`),
  KEY `coupon` (`coupon`),
  KEY `sezionale` (`sezionale`),
  CONSTRAINT `documenti_ibfk_10_nofollow` FOREIGN KEY (`coupon`) REFERENCES `coupon` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_ibfk_1_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_documenti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_ibfk_2_nofollow` FOREIGN KEY (`id_destinatario`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_ibfk_3_nofollow` FOREIGN KEY (`id_sede_destinatario`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_ibfk_4_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_ibfk_5_nofollow` FOREIGN KEY (`id_sede_emittente`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_ibfk_6_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_ibfk_7_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_ibfk_8_nofollow` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_ibfk_9_nofollow` FOREIGN KEY (`id_contatto`) REFERENCES `contatti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `documenti_amministrativi`
--

DROP TABLE IF EXISTS `documenti_amministrativi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `documenti_amministrativi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipologia` int(11) NOT NULL,
  `numero` int(11) NOT NULL,
  `revisione` char(8) DEFAULT NULL,
  `sezione` char(16) DEFAULT NULL,
  `data` date NOT NULL,
  `progressivo_invio` char(8) DEFAULT NULL,
  `id_emittente` int(11) NOT NULL,
  `id_sede_emittente` int(11) DEFAULT NULL,
  `id_referente_emittente` int(11) DEFAULT NULL,
  `id_agente_emittente` int(11) DEFAULT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_esigibilita` int(11) DEFAULT NULL,
  `id_sede_cliente` int(11) DEFAULT NULL,
  `id_referente_cliente` int(11) DEFAULT NULL,
  `id_fornitore` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `causale` char(255) DEFAULT NULL,
  `note_cliente` text,
  `note_interne` text,
  `note_pagamento` text,
  `note_reso` text,
  `note_consegna` text,
  `note_imballo` text,
  `data_fine_validita` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codice_univoco_unico` (`id_emittente`,`progressivo_invio`),
  KEY `id_emittente` (`id_emittente`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_sede_emittente` (`id_sede_emittente`),
  KEY `id_sede_cliente` (`id_sede_cliente`),
  KEY `id_fornitore` (`id_fornitore`),
  KEY `id_referente_emittente` (`id_referente_emittente`),
  KEY `id_referente_cliente` (`id_referente_cliente`),
  KEY `id_agente_emittente` (`id_agente_emittente`),
  KEY `id_esigibilita` (`id_esigibilita`),
  CONSTRAINT `documenti_amministrativi_ibfk_1` FOREIGN KEY (`id_esigibilita`) REFERENCES `esigibilita_iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_amministrativi_ibfk_10_nofollow` FOREIGN KEY (`id_referente_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_amministrativi_ibfk_11_nofollow` FOREIGN KEY (`id_agente_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_amministrativi_ibfk_1_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_amministrativi_ibfk_2_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_amministrativi_ibfk_3_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_amministrativi_ibfk_4_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_amministrativi_ibfk_5_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_documenti_amministrativi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_amministrativi_ibfk_6_nofollow` FOREIGN KEY (`id_sede_emittente`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_amministrativi_ibfk_7_nofollow` FOREIGN KEY (`id_sede_cliente`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_amministrativi_ibfk_8_nofollow` FOREIGN KEY (`id_fornitore`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_amministrativi_ibfk_9_nofollow` FOREIGN KEY (`id_referente_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `documenti_amministrativi_view`
--

DROP TABLE IF EXISTS `documenti_amministrativi_view`;
/*!50001 DROP VIEW IF EXISTS `documenti_amministrativi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `documenti_amministrativi_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `numero` tinyint NOT NULL,
  `revisione` tinyint NOT NULL,
  `sezione` tinyint NOT NULL,
  `data` tinyint NOT NULL,
  `progressivo_invio` tinyint NOT NULL,
  `id_emittente` tinyint NOT NULL,
  `id_sede_emittente` tinyint NOT NULL,
  `id_referente_emittente` tinyint NOT NULL,
  `id_agente_emittente` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_esigibilita` tinyint NOT NULL,
  `id_sede_cliente` tinyint NOT NULL,
  `id_referente_cliente` tinyint NOT NULL,
  `id_fornitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `causale` tinyint NOT NULL,
  `note_cliente` tinyint NOT NULL,
  `note_interne` tinyint NOT NULL,
  `note_pagamento` tinyint NOT NULL,
  `note_reso` tinyint NOT NULL,
  `note_consegna` tinyint NOT NULL,
  `note_imballo` tinyint NOT NULL,
  `data_fine_validita` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `codice_tipologia` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `documenti_articoli`
--

DROP TABLE IF EXISTS `documenti_articoli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `documenti_articoli` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `id_destinatario` int(11) DEFAULT NULL,
  `id_emittente` int(11) DEFAULT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_attivita` int(11) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `id_udm` int(11) DEFAULT NULL,
  `id_reparto` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `data_lavorazione` date NOT NULL,
  `data_fatturabile` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `id_listino` int(11) DEFAULT NULL,
  `id_valuta` int(11) DEFAULT NULL,
  `id_modalita_pagamento` int(11) DEFAULT NULL,
  `importo_netto_totale` decimal(9,2) NOT NULL DEFAULT '0.00',
  `importo_netto_totale_non_scontato` decimal(9,2) DEFAULT NULL,
  `id_iva` int(11) DEFAULT NULL,
  `nome` text,
  `specifiche` char(255) DEFAULT NULL,
  `matricola` int(11) DEFAULT NULL,
  `testo` text,
  `path` char(255) DEFAULT NULL,
  `se_rimborso` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_documento` (`id_documento`),
  KEY `id_emittente` (`id_emittente`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_todo` (`id_todo`),
  KEY `id_attivita` (`id_attivita`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_udm` (`id_udm`),
  KEY `id_listino` (`id_listino`),
  KEY `id_valuta` (`id_valuta`),
  KEY `id_modalita_pagamento` (`id_modalita_pagamento`),
  KEY `id_iva` (`id_iva`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_destinatario` (`id_destinatario`),
  KEY `id_mastro_provenienza` (`id_mastro_provenienza`),
  KEY `id_mastro_destinazione` (`id_mastro_destinazione`),
  KEY `id_reparto` (`id_reparto`),
  KEY `matricola` (`matricola`),
  CONSTRAINT `documenti_articoli_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_articoli_ibfk_11` FOREIGN KEY (`id_genitore`) REFERENCES `documenti_articoli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_articoli_ibfk_12_nofollow` FOREIGN KEY (`id_destinatario`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_articoli_ibfk_13_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_articoli_ibfk_15` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_documenti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_articoli_ibfk_18` FOREIGN KEY (`id_modalita_pagamento`) REFERENCES `modalita_pagamento` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_articoli_ibfk_19` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_articoli_ibfk_1_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_articoli_ibfk_20` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_articoli_ibfk_21` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_articoli_ibfk_22` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_articoli_ibfk_23` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `documenti_articoli_ibfk_24` FOREIGN KEY (`id_udm`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_articoli_ibfk_25` FOREIGN KEY (`id_reparto`) REFERENCES `reparti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_articoli_ibfk_25_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_articoli_ibfk_26_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_articoli_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_articoli_ibfk_7_nofollow` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_articoli_ibfk_8_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `documenti_articoli_ibfk_9_nofollow` FOREIGN KEY (`matricola`) REFERENCES `matricole` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `documenti_articoli_view`
--

DROP TABLE IF EXISTS `documenti_articoli_view`;
/*!50001 DROP VIEW IF EXISTS `documenti_articoli_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `documenti_articoli_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_documento` tinyint NOT NULL,
  `id_destinatario` tinyint NOT NULL,
  `id_emittente` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `id_todo` tinyint NOT NULL,
  `id_attivita` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `id_mastro_provenienza` tinyint NOT NULL,
  `id_mastro_destinazione` tinyint NOT NULL,
  `id_udm` tinyint NOT NULL,
  `id_reparto` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `quantita` tinyint NOT NULL,
  `data_lavorazione` tinyint NOT NULL,
  `data_fatturabile` tinyint NOT NULL,
  `data_scadenza` tinyint NOT NULL,
  `id_listino` tinyint NOT NULL,
  `id_valuta` tinyint NOT NULL,
  `id_modalita_pagamento` tinyint NOT NULL,
  `importo_netto_totale` tinyint NOT NULL,
  `importo_netto_totale_non_scontato` tinyint NOT NULL,
  `id_iva` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `specifiche` tinyint NOT NULL,
  `matricola` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `path` tinyint NOT NULL,
  `se_rimborso` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `codice_tipologia` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `emittente` tinyint NOT NULL,
  `documento` tinyint NOT NULL,
  `reparto` tinyint NOT NULL,
  `articolo` tinyint NOT NULL,
  `udm` tinyint NOT NULL,
  `iva` tinyint NOT NULL,
  `aliquota_iva` tinyint NOT NULL,
  `label_matricola` tinyint NOT NULL,
  `mastro_carico` tinyint NOT NULL,
  `mastro_scarico` tinyint NOT NULL,
  `totale_riga` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `documenti_view`
--

DROP TABLE IF EXISTS `documenti_view`;
/*!50001 DROP VIEW IF EXISTS `documenti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `documenti_view` (
  `id` tinyint NOT NULL,
  `numero` tinyint NOT NULL,
  `sezionale` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_contatto` tinyint NOT NULL,
  `data` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_destinatario` tinyint NOT NULL,
  `id_sede_destinatario` tinyint NOT NULL,
  `id_emittente` tinyint NOT NULL,
  `id_sede_emittente` tinyint NOT NULL,
  `id_todo` tinyint NOT NULL,
  `coupon` tinyint NOT NULL,
  `note_interne` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `timestamp_chiusura` tinyint NOT NULL,
  `codice_tipologia` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `emittente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `totale` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `esigibilita_iva`
--

DROP TABLE IF EXISTS `esigibilita_iva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `esigibilita_iva` (
  `id` int(11) NOT NULL,
  `nome` char(32) NOT NULL,
  `codice` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `esigibilita_iva_view`
--

DROP TABLE IF EXISTS `esigibilita_iva_view`;
/*!50001 DROP VIEW IF EXISTS `esigibilita_iva_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `esigibilita_iva_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `esiti_attivita`
--

DROP TABLE IF EXISTS `esiti_attivita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `esiti_attivita` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) DEFAULT NULL,
  `se_positivo` int(1) DEFAULT NULL,
  `se_richiede_azione` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `esiti_attivita_view`
--

DROP TABLE IF EXISTS `esiti_attivita_view`;
/*!50001 DROP VIEW IF EXISTS `esiti_attivita_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `esiti_attivita_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_positivo` tinyint NOT NULL,
  `se_richiede_azione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `esiti_incarichi_immobili`
--

DROP TABLE IF EXISTS `esiti_incarichi_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `esiti_incarichi_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) DEFAULT NULL,
  `se_positivo` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `esiti_incarichi_immobili_view`
--

DROP TABLE IF EXISTS `esiti_incarichi_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `esiti_incarichi_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `esiti_incarichi_immobili_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_positivo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `esiti_incroci_immobili`
--

DROP TABLE IF EXISTS `esiti_incroci_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `esiti_incroci_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) DEFAULT NULL,
  `se_positivo` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `esiti_incroci_immobili_view`
--

DROP TABLE IF EXISTS `esiti_incroci_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `esiti_incroci_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `esiti_incroci_immobili_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_positivo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `esiti_notizie_immobili`
--

DROP TABLE IF EXISTS `esiti_notizie_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `esiti_notizie_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) DEFAULT NULL,
  `se_positivo` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `esiti_notizie_immobili_view`
--

DROP TABLE IF EXISTS `esiti_notizie_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `esiti_notizie_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `esiti_notizie_immobili_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_positivo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `esiti_pratiche`
--

DROP TABLE IF EXISTS `esiti_pratiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `esiti_pratiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) DEFAULT NULL,
  `se_positivo` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `esiti_pratiche_view`
--

DROP TABLE IF EXISTS `esiti_pratiche_view`;
/*!50001 DROP VIEW IF EXISTS `esiti_pratiche_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `esiti_pratiche_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_positivo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `esiti_richieste_immobili`
--

DROP TABLE IF EXISTS `esiti_richieste_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `esiti_richieste_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) DEFAULT NULL,
  `se_positivo` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `esiti_richieste_immobili_view`
--

DROP TABLE IF EXISTS `esiti_richieste_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `esiti_richieste_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `esiti_richieste_immobili_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_positivo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `eventi`
--

DROP TABLE IF EXISTS `eventi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipologia` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `testo` text,
  `se_repertorio` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `eventi_ibfk_3_nofollow` (`id_tipologia`),
  CONSTRAINT `eventi_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `eventi_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `eventi_ibfk_3_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_eventi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eventi_anagrafica`
--

DROP TABLE IF EXISTS `eventi_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventi_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_evento` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_ruolo` int(11) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_evento` (`id_evento`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_anagrafica` (`id_anagrafica`),
  CONSTRAINT `eventi_anagrafica_ibfk_1` FOREIGN KEY (`id_evento`) REFERENCES `eventi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `eventi_anagrafica_ibfk_2_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `eventi_anagrafica_ibfk_3_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_eventi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `eventi_anagrafica_view`
--

DROP TABLE IF EXISTS `eventi_anagrafica_view`;
/*!50001 DROP VIEW IF EXISTS `eventi_anagrafica_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `eventi_anagrafica_view` (
  `id` tinyint NOT NULL,
  `id_evento` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_ruolo` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `eventi_categorie`
--

DROP TABLE IF EXISTS `eventi_categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventi_categorie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_evento` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_tipologia_pubblicazione` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_evento` (`id_evento`,`id_categoria`),
  KEY `id_categoria` (`id_categoria`),
  KEY `indice` (`id`,`id_evento`,`id_categoria`),
  KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
  CONSTRAINT `eventi_categorie_ibfk_1` FOREIGN KEY (`id_evento`) REFERENCES `eventi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `eventi_categorie_ibfk_1_nofollow` FOREIGN KEY (`id_tipologia_pubblicazione`) REFERENCES `tipologie_pubblicazione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `eventi_categorie_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_eventi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `eventi_view`
--

DROP TABLE IF EXISTS `eventi_view`;
/*!50001 DROP VIEW IF EXISTS `eventi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `eventi_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `se_repertorio` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `fasce_orarie_contratti`
--

DROP TABLE IF EXISTS `fasce_orarie_contratti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fasce_orarie_contratti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_contratto` int(11) NOT NULL,
  `turno` int(11) DEFAULT '1',
  `id_giorno` int(11) NOT NULL,
  `ora_inizio` time NOT NULL,
  `ora_fine` time NOT NULL,
  `id_tipologia_inps` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_contratto` (`id_contratto`),
  KEY `turno` (`turno`),
  KEY `id_giorno` (`id_giorno`),
  KEY `ora_inizio` (`ora_inizio`),
  KEY `ora_fine` (`ora_fine`),
  KEY `id_tipologia_inps` (`id_tipologia_inps`),
  CONSTRAINT `fasce_orarie_contratti_ibfk_1` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fasce_orarie_contratti_ibfk_1_nofollow` FOREIGN KEY (`id_tipologia_inps`) REFERENCES `tipologie_attivita_inps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `fasce_orarie_contratti_view`
--

DROP TABLE IF EXISTS `fasce_orarie_contratti_view`;
/*!50001 DROP VIEW IF EXISTS `fasce_orarie_contratti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `fasce_orarie_contratti_view` (
  `id` tinyint NOT NULL,
  `id_contratto` tinyint NOT NULL,
  `turno` tinyint NOT NULL,
  `id_giorno` tinyint NOT NULL,
  `ora_inizio` tinyint NOT NULL,
  `ora_fine` tinyint NOT NULL,
  `id_tipologia_inps` tinyint NOT NULL,
  `tipologia_inps` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `fasi_strategie`
--

DROP TABLE IF EXISTS `fasi_strategie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fasi_strategie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) NOT NULL,
  `nome` int(11) NOT NULL,
  `id_strategia` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`ordine`,`nome`,`id_strategia`),
  KEY `id_strategia` (`id_strategia`),
  KEY `nome` (`nome`),
  CONSTRAINT `fasi_strategie_ibfk_1` FOREIGN KEY (`id_strategia`) REFERENCES `strategie` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `fasi_strategie_view`
--

DROP TABLE IF EXISTS `fasi_strategie_view`;
/*!50001 DROP VIEW IF EXISTS `fasi_strategie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `fasi_strategie_view` (
  `id` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_strategia` tinyint NOT NULL,
  `strategia` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `fatturati`
--

DROP TABLE IF EXISTS `fatturati`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fatturati` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(128) DEFAULT NULL,
  `id_emittente` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_agente` int(11) DEFAULT NULL,
  `id_mandante` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `mese` int(11) NOT NULL,
  `anno` year(4) NOT NULL,
  `importo` decimal(21,2) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fatturato_unico` (`id_cliente`,`id_mandante`,`mese`,`anno`),
  KEY `id_emittente` (`id_emittente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `fatturati_view`
--

DROP TABLE IF EXISTS `fatturati_view`;
/*!50001 DROP VIEW IF EXISTS `fatturati_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `fatturati_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_emittente` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `id_mandante` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `importo` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `nome_mese` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `emittente` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `mandante` tinyint NOT NULL,
  `provvigione_azienda` tinyint NOT NULL,
  `provvigione_agente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `fatture_view`
--

DROP TABLE IF EXISTS `fatture_view`;
/*!50001 DROP VIEW IF EXISTS `fatture_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `fatture_view` (
  `id` tinyint NOT NULL,
  `emittente` tinyint NOT NULL,
  `data` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `numero` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_emittente` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `scadenze` tinyint NOT NULL,
  `pagato` tinyint NOT NULL,
  `totale` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `file`
--

DROP TABLE IF EXISTS `file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_task` int(11) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_rassegna_stampa` int(11) DEFAULT NULL,
  `id_evento` int(11) DEFAULT NULL,
  `id_categoria_eventi` int(11) DEFAULT NULL,
  `id_template_mail` int(11) DEFAULT NULL,
  `id_mailing` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_pratica` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `path` char(255) NOT NULL,
  `url` text,
  `nome` char(255) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `data_emissione` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `id_anagrafica_certificazioni` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prodotto_unico` (`id_prodotto`,`id_ruolo`,`path`),
  UNIQUE KEY `categoria_prodotti_unico` (`id_categoria_prodotti`,`id_ruolo`,`path`),
  UNIQUE KEY `anagrafica_unico` (`id_anagrafica`,`id_ruolo`,`path`),
  UNIQUE KEY `pagina_unico` (`id_pagina`,`id_ruolo`,`path`),
  UNIQUE KEY `task_unico` (`id_task`,`id_ruolo`,`path`),
  UNIQUE KEY `rassegna_stampa_unico` (`id_rassegna_stampa`,`id_ruolo`,`path`),
  UNIQUE KEY `evento_unico` (`id_evento`,`id_ruolo`,`path`),
  UNIQUE KEY `categoria_eventi_unico` (`id_categoria_eventi`,`id_ruolo`,`path`),
  UNIQUE KEY `pratica_unico` (`id_pratica`,`id_ruolo`,`path`),
  KEY `path` (`path`),
  KEY `id_task` (`id_task`),
  KEY `indice` (`id`,`id_task`,`nome`,`path`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_rassegna_stampa` (`id_rassegna_stampa`),
  KEY `id_evento` (`id_evento`),
  KEY `id_categoria_eventi` (`id_categoria_eventi`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_template_mail` (`id_template_mail`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_mailing` (`id_mailing`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_pratica` (`id_pratica`),
  KEY `id_todo` (`id_todo`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `data_scadenza` (`data_scadenza`),
  KEY `data_emissione` (`data_emissione`),
  KEY `id_anagrafica_certificazioni` (`id_anagrafica_certificazioni`),
  CONSTRAINT `file_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_10` FOREIGN KEY (`id_template_mail`) REFERENCES `template_mail` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_11` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_11_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_12` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_13` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_14` FOREIGN KEY (`id_pratica`) REFERENCES `pratiche` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_15` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_16` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_17` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_18` FOREIGN KEY (`id_anagrafica_certificazioni`) REFERENCES `anagrafica_certificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_2` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_3` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_4` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_5` FOREIGN KEY (`id_task`) REFERENCES `task` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_6_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_file` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `file_ibfk_7` FOREIGN KEY (`id_rassegna_stampa`) REFERENCES `rassegna_stampa` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_8` FOREIGN KEY (`id_evento`) REFERENCES `eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_9` FOREIGN KEY (`id_categoria_eventi`) REFERENCES `categorie_eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `file_view`
--

DROP TABLE IF EXISTS `file_view`;
/*!50001 DROP VIEW IF EXISTS `file_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `file_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_task` tinyint NOT NULL,
  `id_todo` tinyint NOT NULL,
  `id_rassegna_stampa` tinyint NOT NULL,
  `id_evento` tinyint NOT NULL,
  `id_categoria_eventi` tinyint NOT NULL,
  `id_template_mail` tinyint NOT NULL,
  `id_mailing` tinyint NOT NULL,
  `id_notizia` tinyint NOT NULL,
  `id_categoria_notizie` tinyint NOT NULL,
  `id_pratica` tinyint NOT NULL,
  `id_risorsa` tinyint NOT NULL,
  `id_categoria_risorse` tinyint NOT NULL,
  `id_lingua` tinyint NOT NULL,
  `path` tinyint NOT NULL,
  `url` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_ruolo` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_emissione` tinyint NOT NULL,
  `data_scadenza` tinyint NOT NULL,
  `id_anagrafica_certificazioni` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `garanzie_carrelli`
--

DROP TABLE IF EXISTS `garanzie_carrelli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `garanzie_carrelli` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `suggerimento` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`,`suggerimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `garanzie_carrelli_prezzi`
--

DROP TABLE IF EXISTS `garanzie_carrelli_prezzi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `garanzie_carrelli_prezzi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_garanzia` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `prezzo_relativo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_garanzia`),
  KEY `id_zona` (`id_zona`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_listino` (`id_listino`),
  KEY `id_valuta` (`id_valuta`),
  KEY `id_iva` (`id_iva`),
  CONSTRAINT `garanzie_carrelli_prezzi_ibfk_2` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `garanzie_carrelli_prezzi_ibfk_3` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `garanzie_carrelli_prezzi_ibfk_4` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `garanzie_carrelli_prezzi_ibfk_5` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `garanzie_carrelli_prezzi_ibfk_6` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `garanzie_carrelli_prezzi_ibfk_7` FOREIGN KEY (`id_garanzia`) REFERENCES `garanzie_carrelli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gruppi`
--

DROP TABLE IF EXISTS `gruppi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gruppi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_struttura` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_struttura` (`id_struttura`),
  CONSTRAINT `gruppi_ibfk_1` FOREIGN KEY (`id_genitore`) REFERENCES `gruppi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `gruppi_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `gruppi_ibfk_2` FOREIGN KEY (`id_struttura`) REFERENCES `anagrafica_ruoli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `gruppi_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `gruppi_view`
--

DROP TABLE IF EXISTS `gruppi_view`;
/*!50001 DROP VIEW IF EXISTS `gruppi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `gruppi_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `iban`
--

DROP TABLE IF EXISTS `iban`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iban` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `intestazione` char(255) DEFAULT NULL,
  `iban` char(27) NOT NULL,
  `note` text NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_anagrafica` (`id_anagrafica`),
  CONSTRAINT `iban_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `iban_view`
--

DROP TABLE IF EXISTS `iban_view`;
/*!50001 DROP VIEW IF EXISTS `iban_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `iban_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `intestazione` tinyint NOT NULL,
  `iban` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `immagini`
--

DROP TABLE IF EXISTS `immagini`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `immagini` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_file` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_evento` int(11) DEFAULT NULL,
  `id_categoria_eventi` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_testata` int(11) DEFAULT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_anagrafica_certificazioni` int(11) DEFAULT NULL,
  `orientamento` enum('L','P') DEFAULT NULL,
  `path` char(255) NOT NULL,
  `path_alternativo` char(255) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `anno` year(4) DEFAULT NULL,
  `taglio` char(64) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_scalamento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `anagrafica_unico` (`id_anagrafica`,`id_ruolo`,`path`),
  UNIQUE KEY `pagina_unico` (`id_pagina`,`id_ruolo`,`path`),
  UNIQUE KEY `file_unico` (`id_file`,`id_ruolo`,`path`),
  UNIQUE KEY `prodotto_unico` (`id_prodotto`,`id_ruolo`,`path`),
  UNIQUE KEY `categoria_prodotti_unico` (`id_categoria_prodotti`,`id_ruolo`,`path`),
  UNIQUE KEY `evento_unico` (`id_evento`,`id_ruolo`,`path`),
  UNIQUE KEY `categoria_eventi_unico` (`id_categoria_eventi`,`id_ruolo`,`path`),
  KEY `path` (`path`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_file` (`id_file`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_evento` (`id_evento`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_categoria_eventi` (`id_categoria_eventi`),
  KEY `indice` (`id`,`path`,`nome`,`id_ruolo`,`ordine`,`anno`,`id_anagrafica`,`id_pagina`,`id_prodotto`,`id_categoria_prodotti`,`id_evento`,`id_categoria_eventi`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_immobile` (`id_immobile`),
  KEY `id_zona` (`id_zona`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_testata` (`id_testata`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_anagrafica_certificazioni` (`id_anagrafica_certificazioni`),
  CONSTRAINT `immagini_ibfk_1` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_10` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_11` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_12` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_13` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_14` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_15` FOREIGN KEY (`id_testata`) REFERENCES `testate` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_16` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_17` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_18` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_19` FOREIGN KEY (`id_anagrafica_certificazioni`) REFERENCES `anagrafica_certificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_2` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_3` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_4_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_immagini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_5` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_6` FOREIGN KEY (`id_evento`) REFERENCES `eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_7` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_8` FOREIGN KEY (`id_categoria_eventi`) REFERENCES `categorie_eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_9` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `immagini_anagrafica`
--

DROP TABLE IF EXISTS `immagini_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `immagini_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_immagine` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_ruolo` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_rassegna_stampa` (`id_immagine`),
  CONSTRAINT `immagini_anagrafica_ibfk_1` FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `immagini_anagrafica_ibfk_2` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `immagini_anagrafica_ibfk_3` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_immagini_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `immagini_view`
--

DROP TABLE IF EXISTS `immagini_view`;
/*!50001 DROP VIEW IF EXISTS `immagini_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `immagini_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_file` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `id_risorsa` tinyint NOT NULL,
  `id_categoria_risorse` tinyint NOT NULL,
  `id_evento` tinyint NOT NULL,
  `id_categoria_eventi` tinyint NOT NULL,
  `id_notizia` tinyint NOT NULL,
  `id_categoria_notizie` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `id_testata` tinyint NOT NULL,
  `id_zona` tinyint NOT NULL,
  `id_lingua` tinyint NOT NULL,
  `id_anagrafica_certificazioni` tinyint NOT NULL,
  `orientamento` tinyint NOT NULL,
  `path` tinyint NOT NULL,
  `path_alternativo` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_ruolo` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `taglio` tinyint NOT NULL,
  `token` tinyint NOT NULL,
  `timestamp_scalamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `ruolo` tinyint NOT NULL,
  `associato` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `immobili`
--

DROP TABLE IF EXISTS `immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) NOT NULL,
  `indirizzo_sostituzione` char(64) DEFAULT NULL,
  `scala` char(32) DEFAULT NULL,
  `interno` char(8) NOT NULL,
  `piano` char(64) NOT NULL,
  `campanello` char(128) DEFAULT NULL,
  `livelli` int(11) DEFAULT NULL,
  `mq_commerciali` decimal(15,2) DEFAULT NULL,
  `mq_calpestabili` decimal(15,2) DEFAULT NULL,
  `mq_modificatore` decimal(15,2) DEFAULT NULL,
  `prezzo_mq` decimal(15,2) DEFAULT NULL,
  `prezzo_valutazione` decimal(15,2) DEFAULT NULL,
  `percentuale_incremento_commerciale` decimal(15,2) DEFAULT NULL,
  `id_condizione` int(11) DEFAULT NULL,
  `id_disponibilita` int(11) DEFAULT NULL,
  `id_classe_energetica` int(11) DEFAULT NULL,
  `spese_annue` decimal(15,2) DEFAULT NULL,
  `note_censimento` text,
  `note_struttura` text,
  `id_account_editor` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_condizione` (`id_condizione`),
  KEY `id_disponibilita` (`id_disponibilita`),
  KEY `id_classe_energetica` (`id_classe_energetica`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_account_editor` (`id_account_editor`),
  CONSTRAINT `immobili_ibfk_1` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immobili_ibfk_1_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `immobili_ibfk_2` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immobili_ibfk_3` FOREIGN KEY (`id_account_editor`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immobili_ibfk_3_nofollow` FOREIGN KEY (`id_condizione`) REFERENCES `condizioni_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `immobili_ibfk_4_nofollow` FOREIGN KEY (`id_disponibilita`) REFERENCES `disponibilita_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `immobili_ibfk_5_nofollow` FOREIGN KEY (`id_classe_energetica`) REFERENCES `classi_energetiche_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `immobili_ifbk_3_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `immobili_anagrafica`
--

DROP TABLE IF EXISTS `immobili_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `immobili_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_immobile` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_ruolo` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_immobile` (`id_immobile`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `immobili_anagrafica_ibfk_1` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `immobili_anagrafica_ibfk_2` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `immobili_anagrafica_ibfk_3` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_immobili_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `immobili_anagrafica_ibfk_4` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immobili_anagrafica_ibfk_5` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `immobili_caratteristiche`
--

DROP TABLE IF EXISTS `immobili_caratteristiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `immobili_caratteristiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_immobile` int(11) NOT NULL,
  `id_caratteristica` int(11) NOT NULL,
  `specifiche` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_immobile`,`id_caratteristica`),
  KEY `id_immobile` (`id_immobile`),
  KEY `id_caratteristica` (`id_caratteristica`),
  CONSTRAINT `immobili_caratteristiche_ibfk_1` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `immobili_caratteristiche_ibfk_2` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `immobili_caratteristiche_view`
--

DROP TABLE IF EXISTS `immobili_caratteristiche_view`;
/*!50001 DROP VIEW IF EXISTS `immobili_caratteristiche_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `immobili_caratteristiche_view` (
  `id` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `id_caratteristica` tinyint NOT NULL,
  `specifiche` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `immobili_incarichi_view`
--

DROP TABLE IF EXISTS `immobili_incarichi_view`;
/*!50001 DROP VIEW IF EXISTS `immobili_incarichi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `immobili_incarichi_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `indirizzo_sostituzione` tinyint NOT NULL,
  `scala` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `piano` tinyint NOT NULL,
  `campanello` tinyint NOT NULL,
  `livelli` tinyint NOT NULL,
  `mq_commerciali` tinyint NOT NULL,
  `mq_calpestabili` tinyint NOT NULL,
  `mq_modificatore` tinyint NOT NULL,
  `prezzo_mq` tinyint NOT NULL,
  `prezzo_valutazione` tinyint NOT NULL,
  `percentuale_incremento_commerciale` tinyint NOT NULL,
  `id_condizione` tinyint NOT NULL,
  `id_disponibilita` tinyint NOT NULL,
  `id_classe_energetica` tinyint NOT NULL,
  `spese_annue` tinyint NOT NULL,
  `note_censimento` tinyint NOT NULL,
  `note_struttura` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `cap` tinyint NOT NULL,
  `localita` tinyint NOT NULL,
  `immagini` tinyint NOT NULL,
  `no_immagini` tinyint NOT NULL,
  `testi` tinyint NOT NULL,
  `no_testi` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `immobili_notizie_view`
--

DROP TABLE IF EXISTS `immobili_notizie_view`;
/*!50001 DROP VIEW IF EXISTS `immobili_notizie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `immobili_notizie_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `indirizzo_sostituzione` tinyint NOT NULL,
  `scala` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `piano` tinyint NOT NULL,
  `campanello` tinyint NOT NULL,
  `livelli` tinyint NOT NULL,
  `mq_commerciali` tinyint NOT NULL,
  `mq_calpestabili` tinyint NOT NULL,
  `mq_modificatore` tinyint NOT NULL,
  `prezzo_mq` tinyint NOT NULL,
  `prezzo_valutazione` tinyint NOT NULL,
  `percentuale_incremento_commerciale` tinyint NOT NULL,
  `id_condizione` tinyint NOT NULL,
  `id_disponibilita` tinyint NOT NULL,
  `id_classe_energetica` tinyint NOT NULL,
  `spese_annue` tinyint NOT NULL,
  `note_censimento` tinyint NOT NULL,
  `note_struttura` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `cap` tinyint NOT NULL,
  `localita` tinyint NOT NULL,
  `latitudine` tinyint NOT NULL,
  `longitudine` tinyint NOT NULL,
  `immagini` tinyint NOT NULL,
  `no_immagini` tinyint NOT NULL,
  `testi` tinyint NOT NULL,
  `no_testi` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `immobili_sviluppi_view`
--

DROP TABLE IF EXISTS `immobili_sviluppi_view`;
/*!50001 DROP VIEW IF EXISTS `immobili_sviluppi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `immobili_sviluppi_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `indirizzo_sostituzione` tinyint NOT NULL,
  `scala` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `piano` tinyint NOT NULL,
  `campanello` tinyint NOT NULL,
  `livelli` tinyint NOT NULL,
  `mq_commerciali` tinyint NOT NULL,
  `mq_calpestabili` tinyint NOT NULL,
  `mq_modificatore` tinyint NOT NULL,
  `prezzo_mq` tinyint NOT NULL,
  `prezzo_valutazione` tinyint NOT NULL,
  `percentuale_incremento_commerciale` tinyint NOT NULL,
  `id_condizione` tinyint NOT NULL,
  `id_disponibilita` tinyint NOT NULL,
  `id_classe_energetica` tinyint NOT NULL,
  `spese_annue` tinyint NOT NULL,
  `note_censimento` tinyint NOT NULL,
  `note_struttura` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `cap` tinyint NOT NULL,
  `localita` tinyint NOT NULL,
  `latitudine` tinyint NOT NULL,
  `longitudine` tinyint NOT NULL,
  `immagini` tinyint NOT NULL,
  `no_immagini` tinyint NOT NULL,
  `testi` tinyint NOT NULL,
  `no_testi` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `immobili_view`
--

DROP TABLE IF EXISTS `immobili_view`;
/*!50001 DROP VIEW IF EXISTS `immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `immobili_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `indirizzo_sostituzione` tinyint NOT NULL,
  `scala` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `piano` tinyint NOT NULL,
  `campanello` tinyint NOT NULL,
  `livelli` tinyint NOT NULL,
  `mq_commerciali` tinyint NOT NULL,
  `mq_calpestabili` tinyint NOT NULL,
  `mq_modificatore` tinyint NOT NULL,
  `prezzo_mq` tinyint NOT NULL,
  `prezzo_valutazione` tinyint NOT NULL,
  `percentuale_incremento_commerciale` tinyint NOT NULL,
  `id_condizione` tinyint NOT NULL,
  `id_disponibilita` tinyint NOT NULL,
  `id_classe_energetica` tinyint NOT NULL,
  `spese_annue` tinyint NOT NULL,
  `note_censimento` tinyint NOT NULL,
  `note_struttura` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `cap` tinyint NOT NULL,
  `localita` tinyint NOT NULL,
  `immagini` tinyint NOT NULL,
  `no_immagini` tinyint NOT NULL,
  `testi` tinyint NOT NULL,
  `no_testi` tinyint NOT NULL,
  `ultimo_contatto` tinyint NOT NULL,
  `n_attivita` tinyint NOT NULL,
  `n_contatti` tinyint NOT NULL,
  `incarichi` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `condizione` tinyint NOT NULL,
  `disponibilita` tinyint NOT NULL,
  `__short_label__` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `immobiliare_censimento_view`
--

DROP TABLE IF EXISTS `immobiliare_censimento_view`;
/*!50001 DROP VIEW IF EXISTS `immobiliare_censimento_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `immobiliare_censimento_view` (
  `indirizzo` tinyint NOT NULL,
  `civico` tinyint NOT NULL,
  `cap` tinyint NOT NULL,
  `localita` tinyint NOT NULL,
  `id_comune` tinyint NOT NULL,
  `comune` tinyint NOT NULL,
  `provincia` tinyint NOT NULL,
  `id` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `piano` tinyint NOT NULL,
  `scala` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `data_inserimento` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `immagini` tinyint NOT NULL,
  `no_immagini` tinyint NOT NULL,
  `testi` tinyint NOT NULL,
  `no_testi` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `incarichi_immobili`
--

DROP TABLE IF EXISTS `incarichi_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `incarichi_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `riferimento` char(16) DEFAULT NULL,
  `id_immobile` int(11) NOT NULL,
  `indirizzo_sostituzione` char(255) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_agenzia` int(11) DEFAULT NULL,
  `id_agente` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `data_notizia` date DEFAULT NULL,
  `data_sviluppo` date DEFAULT NULL,
  `data_valutazione` date DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `prezzo_richiesto` decimal(15,2) DEFAULT NULL,
  `prezzo_mq` decimal(15,2) DEFAULT NULL,
  `prezzo_valutazione` decimal(15,2) DEFAULT NULL,
  `prezzo_incarico` decimal(15,2) DEFAULT NULL,
  `percentuale_intervallo` decimal(15,2) DEFAULT NULL,
  `prezzo_prefisso` char(32) DEFAULT NULL,
  `prezzo` decimal(15,2) DEFAULT NULL,
  `prezzo_suffisso` char(32) DEFAULT NULL,
  `prezzo_sostituzione` char(64) DEFAULT NULL,
  `note` text,
  `timestamp_incrocio` int(11) DEFAULT NULL,
  `id_esito_incarico` int(11) DEFAULT NULL,
  `id_esito_notizia` int(11) DEFAULT NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  `note_archiviazione` text,
  `id_account_editor` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `incarico_unico` (`id_immobile`,`id_agenzia`,`data_inizio`),
  KEY `id_agenzia` (`id_agenzia`),
  KEY `id_immobile` (`id_immobile`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_esito` (`id_esito_incarico`),
  KEY `id_agente` (`id_agente`),
  KEY `id_esito_incarico` (`id_esito_incarico`),
  KEY `id_esito_notizia` (`id_esito_notizia`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_account_editor` (`id_account_editor`),
  CONSTRAINT `incarichi_immobili_fbk1` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`),
  CONSTRAINT `incarichi_immobili_fbk2_nofollow` FOREIGN KEY (`id_agenzia`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `incarichi_immobili_ibfk_1` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_incarichi_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `incarichi_immobili_ibfk_2` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `incarichi_immobili_ibfk_22` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `incarichi_immobili_ibfk_23` FOREIGN KEY (`id_account_editor`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `incarichi_immobili_ibfk_3` FOREIGN KEY (`id_esito_incarico`) REFERENCES `esiti_incarichi_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `incarichi_immobili_ibfk_4` FOREIGN KEY (`id_esito_notizia`) REFERENCES `esiti_notizie_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `incarichi_immobili_ibfk_5` FOREIGN KEY (`id_agente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `incarichi_immobili_ibfk_6` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `incarichi_immobili_ibfk_7` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `incarichi_immobili_aperti_view`
--

DROP TABLE IF EXISTS `incarichi_immobili_aperti_view`;
/*!50001 DROP VIEW IF EXISTS `incarichi_immobili_aperti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `incarichi_immobili_aperti_view` (
  `id` tinyint NOT NULL,
  `riferimento` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `indirizzo_sostituzione` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `data_notizia` tinyint NOT NULL,
  `data_sviluppo` tinyint NOT NULL,
  `data_valutazione` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `prezzo_richiesto` tinyint NOT NULL,
  `prezzo_mq` tinyint NOT NULL,
  `prezzo_valutazione` tinyint NOT NULL,
  `prezzo_incarico` tinyint NOT NULL,
  `percentuale_intervallo` tinyint NOT NULL,
  `prezzo_prefisso` tinyint NOT NULL,
  `prezzo` tinyint NOT NULL,
  `prezzo_suffisso` tinyint NOT NULL,
  `prezzo_sostituzione` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `timestamp_incrocio` tinyint NOT NULL,
  `id_esito_incarico` tinyint NOT NULL,
  `id_esito_notizia` tinyint NOT NULL,
  `timestamp_archiviazione` tinyint NOT NULL,
  `note_archiviazione` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_archiviazione` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `scala` tinyint NOT NULL,
  `piano` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `incarichi_immobili_archivio_view`
--

DROP TABLE IF EXISTS `incarichi_immobili_archivio_view`;
/*!50001 DROP VIEW IF EXISTS `incarichi_immobili_archivio_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `incarichi_immobili_archivio_view` (
  `id` tinyint NOT NULL,
  `riferimento` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `indirizzo_sostituzione` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `data_notizia` tinyint NOT NULL,
  `data_sviluppo` tinyint NOT NULL,
  `data_valutazione` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `prezzo_richiesto` tinyint NOT NULL,
  `prezzo_mq` tinyint NOT NULL,
  `prezzo_valutazione` tinyint NOT NULL,
  `prezzo_incarico` tinyint NOT NULL,
  `percentuale_intervallo` tinyint NOT NULL,
  `prezzo_prefisso` tinyint NOT NULL,
  `prezzo` tinyint NOT NULL,
  `prezzo_suffisso` tinyint NOT NULL,
  `prezzo_sostituzione` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `timestamp_incrocio` tinyint NOT NULL,
  `id_esito_incarico` tinyint NOT NULL,
  `id_esito_notizia` tinyint NOT NULL,
  `timestamp_archiviazione` tinyint NOT NULL,
  `note_archiviazione` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_archiviazione` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `scala` tinyint NOT NULL,
  `piano` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `incarichi_immobili_view`
--

DROP TABLE IF EXISTS `incarichi_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `incarichi_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `incarichi_immobili_view` (
  `id` tinyint NOT NULL,
  `riferimento` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `indirizzo_sostituzione` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `data_notizia` tinyint NOT NULL,
  `data_sviluppo` tinyint NOT NULL,
  `data_valutazione` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `prezzo_richiesto` tinyint NOT NULL,
  `prezzo_mq` tinyint NOT NULL,
  `prezzo_valutazione` tinyint NOT NULL,
  `prezzo_incarico` tinyint NOT NULL,
  `percentuale_intervallo` tinyint NOT NULL,
  `prezzo_prefisso` tinyint NOT NULL,
  `prezzo` tinyint NOT NULL,
  `prezzo_suffisso` tinyint NOT NULL,
  `prezzo_sostituzione` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `timestamp_incrocio` tinyint NOT NULL,
  `id_esito_incarico` tinyint NOT NULL,
  `id_esito_notizia` tinyint NOT NULL,
  `timestamp_archiviazione` tinyint NOT NULL,
  `note_archiviazione` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_archiviazione` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `scala` tinyint NOT NULL,
  `piano` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `incroci_immobili`
--

DROP TABLE IF EXISTS `incroci_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `incroci_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_incarico` int(11) NOT NULL,
  `id_richiesta` int(11) NOT NULL,
  `note_incrocio` text,
  `id_esito` int(11) DEFAULT NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  `note_archiviazione` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_incarico`,`id_richiesta`),
  KEY `id_incarico` (`id_incarico`),
  KEY `id_richiesta` (`id_richiesta`),
  KEY `id_esito` (`id_esito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `incroci_immobili_view`
--

DROP TABLE IF EXISTS `incroci_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `incroci_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `incroci_immobili_view` (
  `id` tinyint NOT NULL,
  `id_incarico` tinyint NOT NULL,
  `id_richiesta` tinyint NOT NULL,
  `note_incrocio` tinyint NOT NULL,
  `id_esito` tinyint NOT NULL,
  `timestamp_archiviazione` tinyint NOT NULL,
  `note_archiviazione` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `riferimento` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `immobile` tinyint NOT NULL,
  `tipologia_immobile` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `zona` tinyint NOT NULL,
  `prezzo` tinyint NOT NULL,
  `tipo_incarico` tinyint NOT NULL,
  `tipologia_edificio` tinyint NOT NULL,
  `telefoni` tinyint NOT NULL,
  `mail` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `indirizzi`
--

DROP TABLE IF EXISTS `indirizzi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `indirizzi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_tipologia_edificio` int(11) DEFAULT NULL,
  `id_condizione` int(11) DEFAULT NULL,
  `id_agente` int(11) DEFAULT NULL,
  `piani` int(11) DEFAULT NULL,
  `descrizione` char(128) CHARACTER SET utf8 DEFAULT NULL,
  `indirizzo` char(128) CHARACTER SET utf8 NOT NULL,
  `civico` char(16) CHARACTER SET utf8 DEFAULT NULL,
  `cap` char(11) CHARACTER SET utf8 DEFAULT NULL,
  `localita` char(128) CHARACTER SET utf8 DEFAULT NULL,
  `id_comune` int(11) NOT NULL,
  `latitudine` decimal(11,7) DEFAULT NULL,
  `longitudine` decimal(11,7) DEFAULT NULL,
  `timestamp_geocode` int(11) DEFAULT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `note` text CHARACTER SET utf8,
  `token` char(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_account_editor` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_comune` (`id_comune`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_zona` (`id_zona`),
  KEY `id_tipologia_edificio` (`id_tipologia_edificio`),
  KEY `id_condizione` (`id_condizione`),
  KEY `id_agente` (`id_agente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_account_editor` (`id_account_editor`),
  KEY `token` (`token`),
  KEY `timestamp_geocode` (`timestamp_geocode`),
  KEY `latitudine` (`latitudine`),
  KEY `longitudine` (`longitudine`),
  KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`),
  CONSTRAINT `indirizzi_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `indirizzi_ibfk_1_nofollow` FOREIGN KEY (`id_comune`) REFERENCES `comuni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `indirizzi_ibfk_2_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `indirizzi_ibfk_3_nofollow` FOREIGN KEY (`id_tipologia_edificio`) REFERENCES `tipologie_edifici` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `indirizzi_ibfk_4_nofollow` FOREIGN KEY (`id_condizione`) REFERENCES `condizioni_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `indirizzi_ibfk_5_nofollow` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `indirizzi_ibfk_6_nofollow` FOREIGN KEY (`id_agente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `indirizzi_ibfk_7_nofollow` FOREIGN KEY (`id_account_editor`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `indirizzi_ibfk_8_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `indirizzi_ibfk_9_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `indirizzi_caratteristiche`
--

DROP TABLE IF EXISTS `indirizzi_caratteristiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `indirizzi_caratteristiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_indirizzo` int(11) NOT NULL,
  `id_caratteristica` int(11) NOT NULL,
  `specifiche` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_indirizzo`,`id_caratteristica`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_caratteristica` (`id_caratteristica`),
  CONSTRAINT `indirizzi_caratteristiche_ibfk_1` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `indirizzi_caratteristiche_ibfk_2` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `indirizzi_caratteristiche_view`
--

DROP TABLE IF EXISTS `indirizzi_caratteristiche_view`;
/*!50001 DROP VIEW IF EXISTS `indirizzi_caratteristiche_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `indirizzi_caratteristiche_view` (
  `id` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `id_caratteristica` tinyint NOT NULL,
  `specifiche` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `indirizzi_view`
--

DROP TABLE IF EXISTS `indirizzi_view`;
/*!50001 DROP VIEW IF EXISTS `indirizzi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `indirizzi_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_tipologia_edificio` tinyint NOT NULL,
  `id_condizione` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `piani` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `civico` tinyint NOT NULL,
  `cap` tinyint NOT NULL,
  `localita` tinyint NOT NULL,
  `id_comune` tinyint NOT NULL,
  `latitudine` tinyint NOT NULL,
  `longitudine` tinyint NOT NULL,
  `timestamp_geocode` tinyint NOT NULL,
  `id_zona` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `id_provincia` tinyint NOT NULL,
  `sigla` tinyint NOT NULL,
  `comune` tinyint NOT NULL,
  `sigla_stato` tinyint NOT NULL,
  `se_sede` tinyint NOT NULL,
  `data_inserimento` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `immagini` tinyint NOT NULL,
  `no_immagini` tinyint NOT NULL,
  `testi` tinyint NOT NULL,
  `no_testi` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ingombri`
--

DROP TABLE IF EXISTS `ingombri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ingombri` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `min` decimal(7,3) NOT NULL,
  `max` decimal(7,3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `min` (`min`),
  KEY `max` (`max`),
  KEY `indice` (`id`,`nome`,`min`,`max`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `ingombri_view`
--

DROP TABLE IF EXISTS `ingombri_view`;
/*!50001 DROP VIEW IF EXISTS `ingombri_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ingombri_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `min` tinyint NOT NULL,
  `max` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `iva`
--

DROP TABLE IF EXISTS `iva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iva` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquota` decimal(5,2) NOT NULL,
  `nome` char(64) NOT NULL,
  `descrizione` text,
  `codice` char(8) DEFAULT NULL,
  `se_ecommerce` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aliquota` (`aliquota`),
  KEY `indice` (`id`,`aliquota`,`nome`,`codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `iva_view`
--

DROP TABLE IF EXISTS `iva_view`;
/*!50001 DROP VIEW IF EXISTS `iva_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `iva_view` (
  `id` tinyint NOT NULL,
  `aliquota` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `se_ecommerce` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `job`
--

DROP TABLE IF EXISTS `job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) DEFAULT NULL,
  `job` char(255) NOT NULL,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `totale` int(11) DEFAULT NULL,
  `corrente` int(11) DEFAULT NULL,
  `iterazioni` int(11) DEFAULT NULL,
  `delay` int(11) DEFAULT NULL,
  `workspace` text,
  `token` char(254) DEFAULT NULL,
  `se_foreground` int(1) DEFAULT NULL,
  `timestamp_esecuzione` int(11) DEFAULT NULL,
  `timestamp_completamento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `token` (`token`),
  KEY `se_foreground` (`se_foreground`),
  KEY `timestamp_apertura` (`timestamp_apertura`),
  KEY `timestamp_esecuzione` (`timestamp_esecuzione`),
  KEY `timestamp_completamento` (`timestamp_completamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `job_tari_view`
--

DROP TABLE IF EXISTS `job_tari_view`;
/*!50001 DROP VIEW IF EXISTS `job_tari_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `job_tari_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `job` tinyint NOT NULL,
  `timestamp_apertura` tinyint NOT NULL,
  `totale` tinyint NOT NULL,
  `corrente` tinyint NOT NULL,
  `iterazioni` tinyint NOT NULL,
  `workspace` tinyint NOT NULL,
  `timestamp_esecuzione` tinyint NOT NULL,
  `timestamp_completamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_ora_inserimento` tinyint NOT NULL,
  `data_ora_completamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `job_view`
--

DROP TABLE IF EXISTS `job_view`;
/*!50001 DROP VIEW IF EXISTS `job_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `job_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `job` tinyint NOT NULL,
  `timestamp_apertura` tinyint NOT NULL,
  `totale` tinyint NOT NULL,
  `corrente` tinyint NOT NULL,
  `iterazioni` tinyint NOT NULL,
  `delay` tinyint NOT NULL,
  `workspace` tinyint NOT NULL,
  `token` tinyint NOT NULL,
  `se_foreground` tinyint NOT NULL,
  `timestamp_esecuzione` tinyint NOT NULL,
  `timestamp_completamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `avanzamento` tinyint NOT NULL,
  `data_ora_apertura` tinyint NOT NULL,
  `data_ora_esecuzione` tinyint NOT NULL,
  `data_ora_completamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `lingue`
--

DROP TABLE IF EXISTS `lingue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lingue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(128) NOT NULL,
  `note` char(128) DEFAULT NULL,
  `iso6391alpha2` char(36) DEFAULT NULL,
  `iso6393alpha3` char(36) DEFAULT NULL,
  `ietf` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  UNIQUE KEY `iso6391alpha2` (`iso6391alpha2`),
  UNIQUE KEY `iso6393alpha3` (`iso6393alpha3`),
  UNIQUE KEY `ietf` (`ietf`),
  KEY `indice` (`id`,`nome`,`note`,`ietf`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `lingue_view`
--

DROP TABLE IF EXISTS `lingue_view`;
/*!50001 DROP VIEW IF EXISTS `lingue_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `lingue_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `iso6391alpha2` tinyint NOT NULL,
  `iso6393alpha3` tinyint NOT NULL,
  `ietf` tinyint NOT NULL,
  `stati` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `liste_mailing`
--

DROP TABLE IF EXISTS `liste_mailing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `liste_mailing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `descrizione` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `liste_mailing_view`
--

DROP TABLE IF EXISTS `liste_mailing_view`;
/*!50001 DROP VIEW IF EXISTS `liste_mailing_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `liste_mailing_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `iscritti` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `listini`
--

DROP TABLE IF EXISTS `listini`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listini` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `id_valuta` (`id_valuta`),
  KEY `indice` (`id`,`nome`,`id_valuta`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `listini_ibfk_1_nofollow` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `listini_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `listini_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `listini_clienti`
--

DROP TABLE IF EXISTS `listini_clienti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listini_clienti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_listino` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_listino` (`id_listino`,`id_cliente`),
  KEY `id_cliente` (`id_cliente`),
  CONSTRAINT `listini_clienti_ibfk_1` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `listini_clienti_ibfk_2` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `listini_gruppi`
--

DROP TABLE IF EXISTS `listini_gruppi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listini_gruppi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_listino` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_listino` (`id_listino`),
  KEY `id_gruppo` (`id_gruppo`),
  CONSTRAINT `listini_gruppi_ibfk_1` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `listini_gruppi_ibfk_2` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `listini_gruppi_view`
--

DROP TABLE IF EXISTS `listini_gruppi_view`;
/*!50001 DROP VIEW IF EXISTS `listini_gruppi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `listini_gruppi_view` (
  `id` tinyint NOT NULL,
  `id_listino` tinyint NOT NULL,
  `id_gruppo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `listini_view`
--

DROP TABLE IF EXISTS `listini_view`;
/*!50001 DROP VIEW IF EXISTS `listini_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `listini_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_valuta` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `luoghi`
--

DROP TABLE IF EXISTS `luoghi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `luoghi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `luoghi_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `luoghi_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `luoghi_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `luoghi_view`
--

DROP TABLE IF EXISTS `luoghi_view`;
/*!50001 DROP VIEW IF EXISTS `luoghi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `luoghi_view` (
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
-- Table structure for table `macro`
--

DROP TABLE IF EXISTS `macro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `macro` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pagina` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `macro` char(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_pagina` (`id_pagina`,`macro`),
  KEY `id_gruppo` (`macro`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  CONSTRAINT `macro_ibfk_1` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `macro_ibfk_2` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `macro_ibfk_3` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `macro_ibfk_4` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `macro_view`
--

DROP TABLE IF EXISTS `macro_view`;
/*!50001 DROP VIEW IF EXISTS `macro_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `macro_view` (
  `id` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `macro` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `mail`
--

DROP TABLE IF EXISTS `mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `se_notifiche` tinyint(1) DEFAULT NULL,
  `se_pec` tinyint(1) DEFAULT NULL,
  `indirizzo` char(128) NOT NULL,
  `descrizione` char(128) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`indirizzo`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `mail_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mail_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mail_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mail_liste_mailing`
--

DROP TABLE IF EXISTS `mail_liste_mailing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_liste_mailing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_mail` int(11) NOT NULL,
  `id_lista` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_mail` (`id_mail`,`id_lista`),
  KEY `id_lista` (`id_lista`),
  CONSTRAINT `mail_liste_mailing_ibfk_1_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mail_liste_mailing_ibfk_2_nofollow` FOREIGN KEY (`id_lista`) REFERENCES `liste_mailing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mail_out`
--

DROP TABLE IF EXISTS `mail_out`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_out` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp_composizione` int(11) NOT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `destinatari_cc` text,
  `destinatari_bcc` text,
  `oggetto` char(254) NOT NULL,
  `corpo` text NOT NULL,
  `allegati` text,
  `headers` text,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `id_newsletter` int(11) DEFAULT NULL,
  `id_email` int(11) DEFAULT NULL,
  `tentativi` int(11) DEFAULT '0',
  `token` char(128) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `timestamp_composizione` (`timestamp_composizione`),
  KEY `timestamp_invio` (`timestamp_invio`),
  KEY `id_newsletter` (`id_newsletter`),
  KEY `id_email` (`id_email`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`timestamp_composizione`,`timestamp_invio`,`id_newsletter`,`id_email`),
  KEY `token` (`token`),
  CONSTRAINT `mail_out_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mail_out_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `mail_out_view`
--

DROP TABLE IF EXISTS `mail_out_view`;
/*!50001 DROP VIEW IF EXISTS `mail_out_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `mail_out_view` (
  `id` tinyint NOT NULL,
  `timestamp_composizione` tinyint NOT NULL,
  `timestamp_invio` tinyint NOT NULL,
  `server` tinyint NOT NULL,
  `mittente` tinyint NOT NULL,
  `destinatari` tinyint NOT NULL,
  `destinatari_cc` tinyint NOT NULL,
  `destinatari_bcc` tinyint NOT NULL,
  `oggetto` tinyint NOT NULL,
  `corpo` tinyint NOT NULL,
  `allegati` tinyint NOT NULL,
  `headers` tinyint NOT NULL,
  `host` tinyint NOT NULL,
  `port` tinyint NOT NULL,
  `user` tinyint NOT NULL,
  `password` tinyint NOT NULL,
  `id_newsletter` tinyint NOT NULL,
  `id_email` tinyint NOT NULL,
  `tentativi` tinyint NOT NULL,
  `token` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_ora_invio` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `mail_sent`
--

DROP TABLE IF EXISTS `mail_sent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_sent` (
  `id` int(11) NOT NULL,
  `timestamp_composizione` int(11) NOT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `destinatari_cc` text,
  `destinatari_bcc` text,
  `oggetto` char(254) NOT NULL,
  `corpo` text NOT NULL,
  `allegati` text,
  `headers` text,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `id_newsletter` int(11) DEFAULT NULL,
  `id_email` int(11) DEFAULT NULL,
  `tentativi` int(11) DEFAULT '0',
  `token` char(128) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `timestamp_composizione` (`timestamp_composizione`),
  KEY `timestamp_invio` (`timestamp_invio`),
  KEY `id_newsletter` (`id_newsletter`),
  KEY `id_email` (`id_email`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`timestamp_composizione`,`timestamp_invio`,`id_newsletter`,`id_email`),
  KEY `token` (`token`),
  CONSTRAINT `mail_sent_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mail_sent_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `mail_sent_view`
--

DROP TABLE IF EXISTS `mail_sent_view`;
/*!50001 DROP VIEW IF EXISTS `mail_sent_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `mail_sent_view` (
  `id` tinyint NOT NULL,
  `timestamp_composizione` tinyint NOT NULL,
  `timestamp_invio` tinyint NOT NULL,
  `server` tinyint NOT NULL,
  `mittente` tinyint NOT NULL,
  `destinatari` tinyint NOT NULL,
  `destinatari_cc` tinyint NOT NULL,
  `destinatari_bcc` tinyint NOT NULL,
  `oggetto` tinyint NOT NULL,
  `corpo` tinyint NOT NULL,
  `allegati` tinyint NOT NULL,
  `headers` tinyint NOT NULL,
  `host` tinyint NOT NULL,
  `port` tinyint NOT NULL,
  `user` tinyint NOT NULL,
  `password` tinyint NOT NULL,
  `id_newsletter` tinyint NOT NULL,
  `id_email` tinyint NOT NULL,
  `tentativi` tinyint NOT NULL,
  `token` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_ora_invio` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `mail_view`
--

DROP TABLE IF EXISTS `mail_view`;
/*!50001 DROP VIEW IF EXISTS `mail_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `mail_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `se_notifiche` tinyint NOT NULL,
  `se_pec` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `mailing`
--

DROP TABLE IF EXISTS `mailing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `note` text,
  `id_job` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_job` (`id_job`),
  CONSTRAINT `mailing_ibfk_1_nofollow` FOREIGN KEY (`id_job`) REFERENCES `job` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mailing_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mailing_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mailing_liste`
--

DROP TABLE IF EXISTS `mailing_liste`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailing_liste` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_mailing` int(11) NOT NULL,
  `id_lista` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_mailing` (`id_mailing`,`id_lista`),
  KEY `id_lista` (`id_lista`),
  CONSTRAINT `mailing_liste_ibfk_1` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mailing_liste_ibfk_2_nofollow` FOREIGN KEY (`id_lista`) REFERENCES `liste_mailing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `mailing_liste_view`
--

DROP TABLE IF EXISTS `mailing_liste_view`;
/*!50001 DROP VIEW IF EXISTS `mailing_liste_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `mailing_liste_view` (
  `id` tinyint NOT NULL,
  `id_mailing` tinyint NOT NULL,
  `id_lista` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `mailing_mail`
--

DROP TABLE IF EXISTS `mailing_mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailing_mail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_mail` int(11) NOT NULL,
  `id_mailing` int(11) NOT NULL,
  `id_mail_coda` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_mail` (`id_mail`,`id_mailing`),
  KEY `id_mail_coda` (`id_mail_coda`),
  KEY `id_mailing` (`id_mailing`),
  CONSTRAINT `mailing_mail_ibfk_1_nofollow` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mailing_mail_ibfk_2_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `mailing_mail_view`
--

DROP TABLE IF EXISTS `mailing_mail_view`;
/*!50001 DROP VIEW IF EXISTS `mailing_mail_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `mailing_mail_view` (
  `id` tinyint NOT NULL,
  `id_mail` tinyint NOT NULL,
  `id_mailing` tinyint NOT NULL,
  `id_mail_coda` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `mailing_view`
--

DROP TABLE IF EXISTS `mailing_view`;
/*!50001 DROP VIEW IF EXISTS `mailing_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `mailing_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `timestamp_invio` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_job` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `marchi`
--

DROP TABLE IF EXISTS `marchi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marchi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  UNIQUE KEY `indice` (`id`,`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `marchi_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `marchi_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `marchi_view`
--

DROP TABLE IF EXISTS `marchi_view`;
/*!50001 DROP VIEW IF EXISTS `marchi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `marchi_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `mastri`
--

DROP TABLE IF EXISTS `mastri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mastri` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `note` text,
  `se_commerciale` int(1) DEFAULT NULL,
  `se_produzione` int(1) DEFAULT NULL,
  `se_amministrazione` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_genitore` (`id_genitore`),
  CONSTRAINT `mastri_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mastri_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mastri_ibfk_3_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `mastri_ibfk_4_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `mastri_view`
--

DROP TABLE IF EXISTS `mastri_view`;
/*!50001 DROP VIEW IF EXISTS `mastri_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `mastri_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `se_commerciale` tinyint NOT NULL,
  `se_produzione` tinyint NOT NULL,
  `se_amministrazione` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `matricole`
--

DROP TABLE IF EXISTS `matricole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matricole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_marchio` int(11) DEFAULT NULL,
  `id_produttore` int(11) DEFAULT NULL,
  `serial_number` char(128) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `testo` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `serial_number` (`serial_number`),
  KEY `id_marchio` (`id_marchio`),
  KEY `id_produttore` (`id_produttore`),
  CONSTRAINT `matricole_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `matricole_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `matricole_ibfk_3_nofollow` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `matricole_ibfk_4_nofollow` FOREIGN KEY (`id_produttore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `matricole_view`
--

DROP TABLE IF EXISTS `matricole_view`;
/*!50001 DROP VIEW IF EXISTS `matricole_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `matricole_view` (
  `id` tinyint NOT NULL,
  `id_marchio` tinyint NOT NULL,
  `id_produttore` tinyint NOT NULL,
  `serial_number` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pagina` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_lingua` int(11) NOT NULL,
  `menu` char(32) NOT NULL,
  `nome` char(128) NOT NULL,
  `ancora` char(128) DEFAULT NULL,
  `target` char(16) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `sottopagine` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_pagina_unico` (`id_pagina`,`id_lingua`,`menu`,`ancora`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_2_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `menu_ibfk_3` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_4` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_5` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_6` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_7` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `menu_view`
--

DROP TABLE IF EXISTS `menu_view`;
/*!50001 DROP VIEW IF EXISTS `menu_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `menu_view` (
  `id` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `id_notizia` tinyint NOT NULL,
  `id_categoria_notizie` tinyint NOT NULL,
  `id_lingua` tinyint NOT NULL,
  `menu` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `ancora` tinyint NOT NULL,
  `target` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `sottopagine` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `metadati`
--

DROP TABLE IF EXISTS `metadati`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `metadati` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_immagine` int(11) DEFAULT NULL,
  `id_video` int(11) DEFAULT NULL,
  `id_file` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_evento` int(11) DEFAULT NULL,
  `id_categoria_eventi` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_mailing` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `testo` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prodotto_unico` (`id_prodotto`,`nome`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_immagine` (`id_immagine`),
  KEY `id_file` (`id_file`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_evento` (`id_evento`),
  KEY `id_categoria_eventi` (`id_categoria_eventi`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_mailing` (`id_mailing`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_video` (`id_video`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `id_risorsa` (`id_risorsa`),
  CONSTRAINT `metadati_ibfk_1` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_10` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_11` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_12` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_13` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_14` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_15` FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_1_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `metadati_ibfk_2` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_3` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_4` FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_5` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_6` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_7` FOREIGN KEY (`id_evento`) REFERENCES `eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_8` FOREIGN KEY (`id_categoria_eventi`) REFERENCES `categorie_eventi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_9` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `metadati_view`
--

DROP TABLE IF EXISTS `metadati_view`;
/*!50001 DROP VIEW IF EXISTS `metadati_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `metadati_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `id_risorsa` tinyint NOT NULL,
  `id_categoria_risorse` tinyint NOT NULL,
  `id_immagine` tinyint NOT NULL,
  `id_video` tinyint NOT NULL,
  `id_file` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_evento` tinyint NOT NULL,
  `id_categoria_eventi` tinyint NOT NULL,
  `id_notizia` tinyint NOT NULL,
  `id_categoria_notizie` tinyint NOT NULL,
  `id_mailing` tinyint NOT NULL,
  `id_lingua` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `ietf` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `modalita_consegna`
--

DROP TABLE IF EXISTS `modalita_consegna`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modalita_consegna` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `suggerimento` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`,`suggerimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modalita_consegna_prezzi`
--

DROP TABLE IF EXISTS `modalita_consegna_prezzi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modalita_consegna_prezzi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_modalita` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_modalita`),
  KEY `id_zona` (`id_zona`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_listino` (`id_listino`),
  KEY `id_valuta` (`id_valuta`),
  KEY `id_iva` (`id_iva`),
  CONSTRAINT `modalita_consegna_prezzi_ibfk_2` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `modalita_consegna_prezzi_ibfk_3` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `modalita_consegna_prezzi_ibfk_4` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `modalita_consegna_prezzi_ibfk_5` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `modalita_consegna_prezzi_ibfk_6` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `modalita_consegna_prezzi_ibfk_7` FOREIGN KEY (`id_modalita`) REFERENCES `modalita_consegna` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modalita_pagamento`
--

DROP TABLE IF EXISTS `modalita_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modalita_pagamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `suggerimento` char(255) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `importo_min` decimal(16,5) DEFAULT NULL,
  `importo_max` decimal(16,5) DEFAULT NULL,
  `percentuale_acconto` decimal(5,2) DEFAULT NULL,
  `se_contanti` int(1) DEFAULT NULL,
  `provider` char(64) DEFAULT NULL,
  `codice` char(8) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`,`suggerimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modalita_pagamento_prezzi`
--

DROP TABLE IF EXISTS `modalita_pagamento_prezzi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modalita_pagamento_prezzi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_modalita` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `prezzo_relativo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_modalita`),
  KEY `id_zona` (`id_zona`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_listino` (`id_listino`),
  KEY `id_valuta` (`id_valuta`),
  KEY `id_iva` (`id_iva`),
  CONSTRAINT `modalita_pagamento_prezzi_ibfk_1` FOREIGN KEY (`id_modalita`) REFERENCES `modalita_pagamento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `modalita_pagamento_prezzi_ibfk_2` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `modalita_pagamento_prezzi_ibfk_3` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `modalita_pagamento_prezzi_ibfk_4` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `modalita_pagamento_prezzi_ibfk_5` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `modalita_pagamento_prezzi_ibfk_6` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `modalita_pagamento_view`
--

DROP TABLE IF EXISTS `modalita_pagamento_view`;
/*!50001 DROP VIEW IF EXISTS `modalita_pagamento_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `modalita_pagamento_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `suggerimento` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `importo_min` tinyint NOT NULL,
  `importo_max` tinyint NOT NULL,
  `percentuale_acconto` tinyint NOT NULL,
  `se_contanti` tinyint NOT NULL,
  `provider` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `modalita_spedizione`
--

DROP TABLE IF EXISTS `modalita_spedizione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modalita_spedizione` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modalita_spedizione_prezzi`
--

DROP TABLE IF EXISTS `modalita_spedizione_prezzi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modalita_spedizione_prezzi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_modalita` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_modalita` (`id_modalita`),
  KEY `id_zona` (`id_zona`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_listino` (`id_listino`),
  KEY `id_valuta` (`id_valuta`),
  KEY `id_iva` (`id_iva`),
  KEY `id_prodotto` (`id_prodotto`),
  CONSTRAINT `modalita_spedizione_prezzi_ibfk_1_nofollow` FOREIGN KEY (`id_modalita`) REFERENCES `modalita_spedizione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `modalita_spedizione_prezzi_ibfk_2` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `modalita_spedizione_prezzi_ibfk_3_nofollow` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `modalita_spedizione_prezzi_ibfk_4` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `modalita_spedizione_prezzi_ibfk_5_nofollow` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `modalita_spedizione_prezzi_ibfk_6_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `modalita_spedizione_prezzi_ibfk_7_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `modalita_spedizione_view`
--

DROP TABLE IF EXISTS `modalita_spedizione_view`;
/*!50001 DROP VIEW IF EXISTS `modalita_spedizione_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `modalita_spedizione_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `motivazioni_tari_anagrafica`
--

DROP TABLE IF EXISTS `motivazioni_tari_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `motivazioni_tari_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tari_anagrafica` int(11) NOT NULL,
  `id_motivazione` int(11) NOT NULL,
  `riga_provenienza` text,
  `dettagli_provenienza` text NOT NULL,
  `path` text NOT NULL,
  `riga` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `motivazione_unico` (`id_tari_anagrafica`,`id_motivazione`),
  KEY `id_tari_anagrafica` (`id_tari_anagrafica`),
  KEY `id_motivazione` (`id_motivazione`),
  CONSTRAINT `motivazioni_tari_anagrafica_ibfk_1` FOREIGN KEY (`id_tari_anagrafica`) REFERENCES `tari_anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `motivazioni_tari_anagrafica_ibfk_2` FOREIGN KEY (`id_motivazione`) REFERENCES `tipologie_motivazioni_tari` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `motivazioni_tari_anagrafica_view`
--

DROP TABLE IF EXISTS `motivazioni_tari_anagrafica_view`;
/*!50001 DROP VIEW IF EXISTS `motivazioni_tari_anagrafica_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `motivazioni_tari_anagrafica_view` (
  `id` tinyint NOT NULL,
  `id_tari_anagrafica` tinyint NOT NULL,
  `id_motivazione` tinyint NOT NULL,
  `riga_provenienza` tinyint NOT NULL,
  `dettagli_provenienza` tinyint NOT NULL,
  `path` tinyint NOT NULL,
  `riga` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `note_pro_forma_view`
--

DROP TABLE IF EXISTS `note_pro_forma_view`;
/*!50001 DROP VIEW IF EXISTS `note_pro_forma_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `note_pro_forma_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `numero` tinyint NOT NULL,
  `revisione` tinyint NOT NULL,
  `sezione` tinyint NOT NULL,
  `data` tinyint NOT NULL,
  `progressivo_invio` tinyint NOT NULL,
  `id_emittente` tinyint NOT NULL,
  `id_sede_emittente` tinyint NOT NULL,
  `id_referente_emittente` tinyint NOT NULL,
  `id_agente_emittente` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_esigibilita` tinyint NOT NULL,
  `id_sede_cliente` tinyint NOT NULL,
  `id_referente_cliente` tinyint NOT NULL,
  `id_fornitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `causale` tinyint NOT NULL,
  `note_cliente` tinyint NOT NULL,
  `note_interne` tinyint NOT NULL,
  `note_pagamento` tinyint NOT NULL,
  `note_reso` tinyint NOT NULL,
  `note_consegna` tinyint NOT NULL,
  `note_imballo` tinyint NOT NULL,
  `data_fine_validita` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `notizie`
--

DROP TABLE IF EXISTS `notizie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notizie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipologia` int(11) NOT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(32) DEFAULT NULL,
  `se_sitemap` int(1) DEFAULT NULL,
  `se_cacheable` int(1) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_tipologia` (`id_tipologia`),
  CONSTRAINT `notizie_ibfk_1` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_notizie` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `notizie_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `notizie_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notizie_categorie`
--

DROP TABLE IF EXISTS `notizie_categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notizie_categorie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_notizia` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_evento` (`id_notizia`,`id_categoria`),
  KEY `id_categoria` (`id_categoria`),
  KEY `indice` (`id`,`id_notizia`,`id_categoria`),
  CONSTRAINT `notizie_categorie_ibfk_1` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notizie_categorie_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notizie_categorie_prodotti`
--

DROP TABLE IF EXISTS `notizie_categorie_prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notizie_categorie_prodotti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_notizia` int(11) NOT NULL,
  `id_categoria_prodotti` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  CONSTRAINT `notizie_categorie_prodotti_ibfk_1` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notizie_categorie_prodotti_ibfk_2` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `notizie_categorie_prodotti_view`
--

DROP TABLE IF EXISTS `notizie_categorie_prodotti_view`;
/*!50001 DROP VIEW IF EXISTS `notizie_categorie_prodotti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `notizie_categorie_prodotti_view` (
  `id` tinyint NOT NULL,
  `id_notizia` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `notizie_categorie_view`
--

DROP TABLE IF EXISTS `notizie_categorie_view`;
/*!50001 DROP VIEW IF EXISTS `notizie_categorie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `notizie_categorie_view` (
  `id` tinyint NOT NULL,
  `id_notizia` tinyint NOT NULL,
  `id_categoria` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `notizie_immobili`
--

DROP TABLE IF EXISTS `notizie_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notizie_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_immobile` int(11) NOT NULL,
  `id_agenzia` int(11) DEFAULT NULL,
  `id_agente` int(11) NOT NULL,
  `data_notizia` date DEFAULT NULL,
  `data_alert` date DEFAULT NULL,
  `testo` text NOT NULL,
  `id_esito` int(11) DEFAULT NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  `note_archiviazione` text NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_immobile` (`id_immobile`),
  KEY `id_agenzia` (`id_agenzia`),
  KEY `id_agente` (`id_agente`),
  KEY `data_alert` (`data_alert`),
  KEY `id_esito` (`id_esito`),
  CONSTRAINT `notizie_immobili_ibfk_1` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notizie_immobili_ibfk_2` FOREIGN KEY (`id_agenzia`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notizie_immobili_ibfk_3` FOREIGN KEY (`id_agente`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notizie_immobili_ibfk_4` FOREIGN KEY (`id_esito`) REFERENCES `esiti_notizie_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `notizie_immobili_archiviate_view`
--

DROP TABLE IF EXISTS `notizie_immobili_archiviate_view`;
/*!50001 DROP VIEW IF EXISTS `notizie_immobili_archiviate_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `notizie_immobili_archiviate_view` (
  `id` tinyint NOT NULL,
  `riferimento` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `indirizzo_sostituzione` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `data_notizia` tinyint NOT NULL,
  `data_sviluppo` tinyint NOT NULL,
  `data_valutazione` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `prezzo_richiesto` tinyint NOT NULL,
  `prezzo_mq` tinyint NOT NULL,
  `prezzo_valutazione` tinyint NOT NULL,
  `prezzo_incarico` tinyint NOT NULL,
  `percentuale_intervallo` tinyint NOT NULL,
  `prezzo_prefisso` tinyint NOT NULL,
  `prezzo` tinyint NOT NULL,
  `prezzo_suffisso` tinyint NOT NULL,
  `prezzo_sostituzione` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `timestamp_incrocio` tinyint NOT NULL,
  `id_esito_incarico` tinyint NOT NULL,
  `id_esito_notizia` tinyint NOT NULL,
  `timestamp_archiviazione` tinyint NOT NULL,
  `note_archiviazione` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_archiviazione` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `latitudine` tinyint NOT NULL,
  `longitudine` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `scala` tinyint NOT NULL,
  `piano` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `notizie_immobili_view`
--

DROP TABLE IF EXISTS `notizie_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `notizie_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `notizie_immobili_view` (
  `id` tinyint NOT NULL,
  `riferimento` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `indirizzo_sostituzione` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `data_notizia` tinyint NOT NULL,
  `data_sviluppo` tinyint NOT NULL,
  `data_valutazione` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `prezzo_richiesto` tinyint NOT NULL,
  `prezzo_mq` tinyint NOT NULL,
  `prezzo_valutazione` tinyint NOT NULL,
  `prezzo_incarico` tinyint NOT NULL,
  `percentuale_intervallo` tinyint NOT NULL,
  `prezzo_prefisso` tinyint NOT NULL,
  `prezzo` tinyint NOT NULL,
  `prezzo_suffisso` tinyint NOT NULL,
  `prezzo_sostituzione` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `timestamp_incrocio` tinyint NOT NULL,
  `id_esito_incarico` tinyint NOT NULL,
  `id_esito_notizia` tinyint NOT NULL,
  `timestamp_archiviazione` tinyint NOT NULL,
  `note_archiviazione` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_archiviazione` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `latitudine` tinyint NOT NULL,
  `longitudine` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `scala` tinyint NOT NULL,
  `piano` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `notizie_prodotti`
--

DROP TABLE IF EXISTS `notizie_prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notizie_prodotti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_notizia` int(11) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_prodotto` (`id_prodotto`),
  CONSTRAINT `notizie_prodotti_ibfk_1` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notizie_prodotti_ibfk_2` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `notizie_prodotti_view`
--

DROP TABLE IF EXISTS `notizie_prodotti_view`;
/*!50001 DROP VIEW IF EXISTS `notizie_prodotti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `notizie_prodotti_view` (
  `id` tinyint NOT NULL,
  `id_notizia` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `notizie_view`
--

DROP TABLE IF EXISTS `notizie_view`;
/*!50001 DROP VIEW IF EXISTS `notizie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `notizie_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_sito` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `title` tinyint NOT NULL,
  `abstract` tinyint NOT NULL,
  `categorie` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `obiettivi`
--

DROP TABLE IF EXISTS `obiettivi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obiettivi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` int(11) NOT NULL,
  `data_inizio` int(11) DEFAULT NULL,
  `data_fine` int(11) DEFAULT NULL,
  `sorgente` int(11) NOT NULL,
  `obiettivo` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `id_fase_strategia` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_fase_strategia` (`id_fase_strategia`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `obiettivi_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `obiettivi_ibfk_2` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `obiettivi_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `obiettivi_ibfk_3` FOREIGN KEY (`id_fase_strategia`) REFERENCES `fasi_strategie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `obiettivi_ibfk_3_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `obiettivi_anagrafica`
--

DROP TABLE IF EXISTS `obiettivi_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obiettivi_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_obiettivo` int(11) NOT NULL,
  `nome_colonna` char(64) NOT NULL,
  `valore_colonna` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_obiettivo`,`nome_colonna`,`valore_colonna`),
  KEY `id_obiettivo` (`id_obiettivo`),
  CONSTRAINT `obiettivi_anagrafica_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `obiettivi_anagrafica_view`
--

DROP TABLE IF EXISTS `obiettivi_anagrafica_view`;
/*!50001 DROP VIEW IF EXISTS `obiettivi_anagrafica_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `obiettivi_anagrafica_view` (
  `id` tinyint NOT NULL,
  `id_obiettivo` tinyint NOT NULL,
  `nome_colonna` tinyint NOT NULL,
  `valore_colonna` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `obiettivi_articoli`
--

DROP TABLE IF EXISTS `obiettivi_articoli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obiettivi_articoli` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_obiettivo` int(11) NOT NULL,
  `nome_colonna` char(64) NOT NULL,
  `valore_colonna` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_obiettivo`,`nome_colonna`,`valore_colonna`),
  KEY `id_obiettivo` (`id_obiettivo`),
  CONSTRAINT `obiettivi_articoli_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `obiettivi_articoli_view`
--

DROP TABLE IF EXISTS `obiettivi_articoli_view`;
/*!50001 DROP VIEW IF EXISTS `obiettivi_articoli_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `obiettivi_articoli_view` (
  `id` tinyint NOT NULL,
  `id_obiettivo` tinyint NOT NULL,
  `nome_colonna` tinyint NOT NULL,
  `valore_colonna` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `obiettivi_categorie_prodotti`
--

DROP TABLE IF EXISTS `obiettivi_categorie_prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obiettivi_categorie_prodotti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_obiettivo` int(11) NOT NULL,
  `nome_colonna` char(64) NOT NULL,
  `valore_colonna` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_obiettivo`,`nome_colonna`,`valore_colonna`),
  KEY `id_obiettivo` (`id_obiettivo`),
  CONSTRAINT `obiettivi_categorie_prodotti_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `obiettivi_categorie_prodotti_view`
--

DROP TABLE IF EXISTS `obiettivi_categorie_prodotti_view`;
/*!50001 DROP VIEW IF EXISTS `obiettivi_categorie_prodotti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `obiettivi_categorie_prodotti_view` (
  `id` tinyint NOT NULL,
  `id_obiettivo` tinyint NOT NULL,
  `nome_colonna` tinyint NOT NULL,
  `valore_colonna` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `obiettivi_prodotti`
--

DROP TABLE IF EXISTS `obiettivi_prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obiettivi_prodotti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_obiettivo` int(11) NOT NULL,
  `nome_colonna` char(64) NOT NULL,
  `valore_colonna` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_obiettivo`,`nome_colonna`,`valore_colonna`),
  KEY `id_obiettivo` (`id_obiettivo`),
  CONSTRAINT `obiettivi_prodotti_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `obiettivi_prodotti_view`
--

DROP TABLE IF EXISTS `obiettivi_prodotti_view`;
/*!50001 DROP VIEW IF EXISTS `obiettivi_prodotti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `obiettivi_prodotti_view` (
  `id` tinyint NOT NULL,
  `id_obiettivo` tinyint NOT NULL,
  `nome_colonna` tinyint NOT NULL,
  `valore_colonna` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `obiettivi_tipologie_attivita`
--

DROP TABLE IF EXISTS `obiettivi_tipologie_attivita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obiettivi_tipologie_attivita` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_obiettivo` int(11) NOT NULL,
  `nome_colonna` char(64) NOT NULL,
  `valore_colonna` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_obiettivo`,`nome_colonna`,`valore_colonna`),
  KEY `id_obiettivo` (`id_obiettivo`),
  CONSTRAINT `obiettivi_tipologie_attivita_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `obiettivi_tipologie_attivita_view`
--

DROP TABLE IF EXISTS `obiettivi_tipologie_attivita_view`;
/*!50001 DROP VIEW IF EXISTS `obiettivi_tipologie_attivita_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `obiettivi_tipologie_attivita_view` (
  `id` tinyint NOT NULL,
  `id_obiettivo` tinyint NOT NULL,
  `nome_colonna` tinyint NOT NULL,
  `valore_colonna` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `obiettivi_tipologie_documenti`
--

DROP TABLE IF EXISTS `obiettivi_tipologie_documenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obiettivi_tipologie_documenti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_obiettivo` int(11) NOT NULL,
  `nome_colonna` char(64) NOT NULL,
  `valore_colonna` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_obiettivo`,`nome_colonna`,`valore_colonna`),
  KEY `id_obiettivo` (`id_obiettivo`),
  CONSTRAINT `obiettivi_tipologie_documenti_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `obiettivi_tipologie_documenti_view`
--

DROP TABLE IF EXISTS `obiettivi_tipologie_documenti_view`;
/*!50001 DROP VIEW IF EXISTS `obiettivi_tipologie_documenti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `obiettivi_tipologie_documenti_view` (
  `id` tinyint NOT NULL,
  `id_obiettivo` tinyint NOT NULL,
  `nome_colonna` tinyint NOT NULL,
  `valore_colonna` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `obiettivi_tipologie_progetti`
--

DROP TABLE IF EXISTS `obiettivi_tipologie_progetti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obiettivi_tipologie_progetti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_obiettivo` int(11) NOT NULL,
  `nome_colonna` char(64) NOT NULL,
  `valore_colonna` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_obiettivo`,`nome_colonna`,`valore_colonna`),
  KEY `id_obiettivo` (`id_obiettivo`),
  CONSTRAINT `obiettivi_tipologie_progetti_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `obiettivi_tipologie_progetti_view`
--

DROP TABLE IF EXISTS `obiettivi_tipologie_progetti_view`;
/*!50001 DROP VIEW IF EXISTS `obiettivi_tipologie_progetti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `obiettivi_tipologie_progetti_view` (
  `id` tinyint NOT NULL,
  `id_obiettivo` tinyint NOT NULL,
  `nome_colonna` tinyint NOT NULL,
  `valore_colonna` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `obiettivi_tracking`
--

DROP TABLE IF EXISTS `obiettivi_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `obiettivi_tracking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_obiettivo` int(11) NOT NULL,
  `nome_colonna` char(64) NOT NULL,
  `valore_colonna` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_obiettivo`,`nome_colonna`,`valore_colonna`),
  KEY `id_obiettivo` (`id_obiettivo`),
  CONSTRAINT `obiettivi_tracking_ibfk_1` FOREIGN KEY (`id_obiettivo`) REFERENCES `obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `obiettivi_tracking_view`
--

DROP TABLE IF EXISTS `obiettivi_tracking_view`;
/*!50001 DROP VIEW IF EXISTS `obiettivi_tracking_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `obiettivi_tracking_view` (
  `id` tinyint NOT NULL,
  `id_obiettivo` tinyint NOT NULL,
  `nome_colonna` tinyint NOT NULL,
  `valore_colonna` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `obiettivi_view`
--

DROP TABLE IF EXISTS `obiettivi_view`;
/*!50001 DROP VIEW IF EXISTS `obiettivi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `obiettivi_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `sorgente` tinyint NOT NULL,
  `obiettivo` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_fase_strategia` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `fase` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `offerte_view`
--

DROP TABLE IF EXISTS `offerte_view`;
/*!50001 DROP VIEW IF EXISTS `offerte_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `offerte_view` (
  `id` tinyint NOT NULL,
  `data` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `numero` tinyint NOT NULL,
  `causale` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `orari_contratti`
--

DROP TABLE IF EXISTS `orari_contratti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orari_contratti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_contratto` int(11) NOT NULL,
  `turno` int(11) DEFAULT '1',
  `id_giorno` int(11) DEFAULT NULL,
  `ora_inizio` time DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `id_costo` int(11) NOT NULL,
  `se_lavoro` int(1) DEFAULT '1',
  `se_disponibile` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico_lavoro` (`id_contratto`,`turno`,`id_giorno`,`ora_inizio`,`ora_fine`,`se_lavoro`),
  UNIQUE KEY `unico_disponibile` (`id_contratto`,`turno`,`id_giorno`,`ora_inizio`,`ora_fine`,`se_disponibile`),
  KEY `id_contratto` (`id_contratto`),
  KEY `id_costo` (`id_costo`),
  KEY `se_lavoro` (`se_lavoro`),
  KEY `se_disponibile` (`se_disponibile`),
  KEY `turno` (`turno`),
  CONSTRAINT `orari_contratti_ibfk_1` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `orari_contratti_ibfk_2` FOREIGN KEY (`id_costo`) REFERENCES `costi_contratti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `orari_contratti_view`
--

DROP TABLE IF EXISTS `orari_contratti_view`;
/*!50001 DROP VIEW IF EXISTS `orari_contratti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `orari_contratti_view` (
  `id` tinyint NOT NULL,
  `id_contratto` tinyint NOT NULL,
  `turno` tinyint NOT NULL,
  `id_giorno` tinyint NOT NULL,
  `ora_inizio` tinyint NOT NULL,
  `ora_fine` tinyint NOT NULL,
  `id_costo` tinyint NOT NULL,
  `se_lavoro` tinyint NOT NULL,
  `se_disponibile` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `orientamenti_sessuali`
--

DROP TABLE IF EXISTS `orientamenti_sessuali`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orientamenti_sessuali` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `orientamenti_sessuali_view`
--

DROP TABLE IF EXISTS `orientamenti_sessuali_view`;
/*!50001 DROP VIEW IF EXISTS `orientamenti_sessuali_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `orientamenti_sessuali_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pagine`
--

DROP TABLE IF EXISTS `pagine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pagine` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `id_sito` int(11) NOT NULL DEFAULT '1',
  `nome` char(255) DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(32) DEFAULT NULL,
  `id_contenuti` int(11) DEFAULT NULL,
  `id_tipologia_pubblicazione` int(11) DEFAULT NULL,
  `se_sitemap` int(1) DEFAULT NULL,
  `se_cacheable` int(1) DEFAULT NULL,
  `note` text,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_contenuti` (`id_contenuti`),
  CONSTRAINT `pagine_ibfk_1` FOREIGN KEY (`id_contenuti`) REFERENCES `contenuti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pagine_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `pagine` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `pagine_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `pagine_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `pagine_ibfk_4_nofollow` FOREIGN KEY (`id_tipologia_pubblicazione`) REFERENCES `tipologie_pubblicazione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pagine_gruppi`
--

DROP TABLE IF EXISTS `pagine_gruppi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pagine_gruppi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pagina` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_gruppo` (`id_gruppo`),
  CONSTRAINT `pagine_gruppi_ibfk_1` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pagine_gruppi_ibfk_2` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `pagine_gruppi_view`
--

DROP TABLE IF EXISTS `pagine_gruppi_view`;
/*!50001 DROP VIEW IF EXISTS `pagine_gruppi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pagine_gruppi_view` (
  `id` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_gruppo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pagine_macro`
--

DROP TABLE IF EXISTS `pagine_macro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pagine_macro` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pagina` int(11) NOT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `macro` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_pagina` (`id_pagina`,`macro`),
  KEY `id_gruppo` (`macro`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  CONSTRAINT `pagine_macro_ibfk_1` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pagine_macro_ibfk_2` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `pagine_macro_view`
--

DROP TABLE IF EXISTS `pagine_macro_view`;
/*!50001 DROP VIEW IF EXISTS `pagine_macro_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pagine_macro_view` (
  `id` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `macro` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pagine_menu`
--

DROP TABLE IF EXISTS `pagine_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pagine_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pagina` int(11) NOT NULL,
  `id_lingua` int(11) NOT NULL,
  `menu` char(32) NOT NULL,
  `nome` char(128) NOT NULL,
  `target` char(16) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `sottopagine` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_pagina_unico` (`id_pagina`,`id_lingua`,`menu`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_lingua` (`id_lingua`),
  CONSTRAINT `pagine_menu_ibfk_1` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pagine_menu_ibfk_2_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `pagine_menu_view`
--

DROP TABLE IF EXISTS `pagine_menu_view`;
/*!50001 DROP VIEW IF EXISTS `pagine_menu_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pagine_menu_view` (
  `id` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_lingua` tinyint NOT NULL,
  `menu` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `target` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `sottopagine` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `pagine_view`
--

DROP TABLE IF EXISTS `pagine_view`;
/*!50001 DROP VIEW IF EXISTS `pagine_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pagine_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `id_sito` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `template` tinyint NOT NULL,
  `schema_html` tinyint NOT NULL,
  `tema_css` tinyint NOT NULL,
  `id_contenuti` tinyint NOT NULL,
  `id_tipologia_pubblicazione` tinyint NOT NULL,
  `se_sitemap` tinyint NOT NULL,
  `se_cacheable` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `tipologia_pubblicazione` tinyint NOT NULL,
  `se_bozza` tinyint NOT NULL,
  `se_pubblicato` tinyint NOT NULL,
  `gruppi` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `patrocini_pratiche`
--

DROP TABLE IF EXISTS `patrocini_pratiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patrocini_pratiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pratica` int(11) NOT NULL,
  `numero` char(32) NOT NULL,
  `se_liquidato` int(1) DEFAULT NULL,
  `data_liquidazione` date DEFAULT NULL,
  `se_fatturato` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_pratica` (`id_pratica`),
  CONSTRAINT `patrocini_pratiche_ibfk_1` FOREIGN KEY (`id_pratica`) REFERENCES `pratiche` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `patrocini_pratiche_view`
--

DROP TABLE IF EXISTS `patrocini_pratiche_view`;
/*!50001 DROP VIEW IF EXISTS `patrocini_pratiche_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `patrocini_pratiche_view` (
  `id` tinyint NOT NULL,
  `id_pratica` tinyint NOT NULL,
  `numero` tinyint NOT NULL,
  `se_liquidato` tinyint NOT NULL,
  `data_liquidazione` tinyint NOT NULL,
  `se_fatturato` tinyint NOT NULL,
  `pratica` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pause_progetti`
--

DROP TABLE IF EXISTS `pause_progetti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pause_progetti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_progetto` char(32) NOT NULL,
  `data_inizio` date NOT NULL,
  `data_fine` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_progetto`,`data_inizio`,`data_fine`),
  KEY `id_progetto` (`id_progetto`),
  CONSTRAINT `pause_progetti_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `pause_progetti_view`
--

DROP TABLE IF EXISTS `pause_progetti_view`;
/*!50001 DROP VIEW IF EXISTS `pause_progetti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pause_progetti_view` (
  `id` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `periodi_variazioni_attivita`
--

DROP TABLE IF EXISTS `periodi_variazioni_attivita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `periodi_variazioni_attivita` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_variazione` int(11) NOT NULL,
  `data_inizio` date NOT NULL,
  `data_fine` date NOT NULL,
  `ora_inizio` time DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_creazione_cartellino` int(11) DEFAULT NULL,
  `timestamp_controllo_attivita` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_variazione`,`data_inizio`,`data_fine`,`ora_inizio`,`ora_fine`),
  KEY `id_variazione` (`id_variazione`),
  KEY `timestamp_creazione_cartellino` (`timestamp_creazione_cartellino`),
  KEY `timestamp_controllo_attivita` (`timestamp_controllo_attivita`),
  KEY `token` (`token`),
  KEY `data_inizio` (`data_inizio`),
  KEY `data_fine` (`data_fine`),
  CONSTRAINT `periodi_variazioni_attivita_ibfk_1` FOREIGN KEY (`id_variazione`) REFERENCES `variazioni_attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `periodi_variazioni_attivita_view`
--

DROP TABLE IF EXISTS `periodi_variazioni_attivita_view`;
/*!50001 DROP VIEW IF EXISTS `periodi_variazioni_attivita_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `periodi_variazioni_attivita_view` (
  `id_anagrafica` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `approvata` tinyint NOT NULL,
  `id` tinyint NOT NULL,
  `id_variazione` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `ora_inizio` tinyint NOT NULL,
  `ora_fine` tinyint NOT NULL,
  `token` tinyint NOT NULL,
  `timestamp_creazione_cartellino` tinyint NOT NULL,
  `timestamp_controllo_attivita` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pianificazioni`
--

DROP TABLE IF EXISTS `pianificazioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pianificazioni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entita` char(255) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_turno` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `periodicita` int(11) NOT NULL,
  `cadenza` int(11) DEFAULT NULL,
  `se_lunedi` int(1) DEFAULT NULL,
  `se_martedi` int(1) DEFAULT NULL,
  `se_mercoledi` int(1) DEFAULT NULL,
  `se_giovedi` int(1) DEFAULT NULL,
  `se_venerdi` int(1) DEFAULT NULL,
  `se_sabato` int(1) DEFAULT NULL,
  `se_domenica` int(1) DEFAULT NULL,
  `ripetizione_mese` int(11) DEFAULT NULL,
  `ripetizione_anno` int(11) DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `data_ultimo_oggetto` date DEFAULT NULL,
  `data_inizio_pulizia` date DEFAULT NULL,
  `giorni_rinnovo` int(11) DEFAULT NULL,
  `note` text,
  `workspace` text,
  `token` char(128) DEFAULT NULL,
  `timestamp_estensione` int(11) DEFAULT NULL,
  `timestamp_popolazione` int(11) DEFAULT NULL,
  `se_ripopolare` int(1) DEFAULT NULL,
  `se_fermare` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_turno` (`id_turno`),
  UNIQUE KEY `id_todo` (`id_todo`),
  UNIQUE KEY `id_progetto` (`id_progetto`),
  KEY `nome` (`nome`),
  KEY `token` (`token`),
  KEY `timestamp_estensione` (`timestamp_estensione`),
  KEY `timestamp_popolazione` (`timestamp_popolazione`),
  KEY `data_fine` (`data_fine`),
  KEY `data_ultimo_oggetto` (`data_ultimo_oggetto`),
  KEY `se_ripopolare` (`se_ripopolare`),
  KEY `data_inizio_pulizia` (`data_inizio_pulizia`),
  KEY `se_fermare` (`se_fermare`),
  CONSTRAINT `pianificazioni_ibfk_3` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `pianificazioni_ibfk_4` FOREIGN KEY (`id_turno`) REFERENCES `turni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pianificazioni_ibfk_5` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `pianificazioni_view`
--

DROP TABLE IF EXISTS `pianificazioni_view`;
/*!50001 DROP VIEW IF EXISTS `pianificazioni_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pianificazioni_view` (
  `id` tinyint NOT NULL,
  `entita` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_todo` tinyint NOT NULL,
  `id_turno` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `periodicita` tinyint NOT NULL,
  `cadenza` tinyint NOT NULL,
  `se_lunedi` tinyint NOT NULL,
  `se_martedi` tinyint NOT NULL,
  `se_mercoledi` tinyint NOT NULL,
  `se_giovedi` tinyint NOT NULL,
  `se_venerdi` tinyint NOT NULL,
  `se_sabato` tinyint NOT NULL,
  `se_domenica` tinyint NOT NULL,
  `ripetizione_mese` tinyint NOT NULL,
  `ripetizione_anno` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `data_ultimo_oggetto` tinyint NOT NULL,
  `data_inizio_pulizia` tinyint NOT NULL,
  `giorni_rinnovo` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `workspace` tinyint NOT NULL,
  `token` tinyint NOT NULL,
  `timestamp_estensione` tinyint NOT NULL,
  `timestamp_popolazione` tinyint NOT NULL,
  `se_ripopolare` tinyint NOT NULL,
  `se_fermare` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `popup`
--

DROP TABLE IF EXISTS `popup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `popup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `id_html` char(128) DEFAULT NULL,
  `classi_html` char(128) DEFAULT NULL,
  `note` text,
  `id_tipologia` int(11) NOT NULL,
  `id_tipologia_pubblicazione` int(11) DEFAULT NULL,
  `n_scroll` int(11) DEFAULT NULL,
  `n_secondi` int(11) DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `classe_attivazione` char(128) DEFAULT NULL,
  `se_ovunque` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
  CONSTRAINT `popup_ibfk_1` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_popup` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `popup_ibfk_2` FOREIGN KEY (`id_tipologia_pubblicazione`) REFERENCES `tipologie_pubblicazione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `popup_pagine`
--

DROP TABLE IF EXISTS `popup_pagine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `popup_pagine` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pagina` int(11) NOT NULL,
  `id_popup` int(11) NOT NULL,
  `se_presente` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_pagina`,`id_popup`),
  KEY `id_popup` (`id_popup`),
  KEY `id_pagina` (`id_pagina`),
  CONSTRAINT `popup_pagine_ibfk_1` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `popup_pagine_ibfk_2` FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `popup_pagine_view`
--

DROP TABLE IF EXISTS `popup_pagine_view`;
/*!50001 DROP VIEW IF EXISTS `popup_pagine_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `popup_pagine_view` (
  `id` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_popup` tinyint NOT NULL,
  `se_presente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `popup_view`
--

DROP TABLE IF EXISTS `popup_view`;
/*!50001 DROP VIEW IF EXISTS `popup_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `popup_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_html` tinyint NOT NULL,
  `classi_html` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_tipologia_pubblicazione` tinyint NOT NULL,
  `n_scroll` tinyint NOT NULL,
  `n_secondi` tinyint NOT NULL,
  `template` tinyint NOT NULL,
  `schema_html` tinyint NOT NULL,
  `classe_attivazione` tinyint NOT NULL,
  `se_ovunque` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `tipologia_pubblicazione` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pratiche`
--

DROP TABLE IF EXISTS `pratiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pratiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero` char(16) NOT NULL,
  `numero_ruolo` char(32) DEFAULT NULL,
  `data_apertura` date NOT NULL,
  `data_chiusura` date DEFAULT NULL,
  `id_sede_apertura` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_categoria_diritto` int(11) DEFAULT NULL,
  `id_provenienza` int(11) DEFAULT NULL,
  `note_segnalazione` char(64) DEFAULT NULL,
  `descrizione` text,
  `controparte` char(128) DEFAULT NULL,
  `se_patrocinio` int(1) DEFAULT NULL,
  `se_accompagnamento` int(1) DEFAULT NULL,
  `note_chiusura` text,
  `ore_stimate` decimal(10,2) DEFAULT NULL,
  `id_esito` int(11) DEFAULT NULL,
  `se_richiesta_liquidazione` int(1) DEFAULT NULL,
  `se_richiesto_rimborso` int(1) DEFAULT NULL,
  `id_account_editor` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `se_importata` int(1) DEFAULT NULL,
  `id_account_chiusura` int(11) DEFAULT NULL,
  `timestamp_chiusura` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`numero`,`data_apertura`,`id_sede_apertura`),
  KEY `numero` (`numero`),
  KEY `id_provenienza` (`id_provenienza`),
  KEY `id_sede_apertura` (`id_sede_apertura`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_categoria_diritto` (`id_categoria_diritto`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_account_chiusura` (`id_account_chiusura`),
  KEY `id_esito` (`id_esito`),
  KEY `id_esito_2` (`id_esito`),
  KEY `id_account_editor` (`id_account_editor`),
  CONSTRAINT `pratiche_ibfk_1` FOREIGN KEY (`id_sede_apertura`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `pratiche_ibfk_1_nofollow` FOREIGN KEY (`id_account_editor`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pratiche_ibfk_2` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_pratiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pratiche_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pratiche_ibfk_3` FOREIGN KEY (`id_categoria_diritto`) REFERENCES `categorie_diritto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pratiche_ibfk_3_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pratiche_ibfk_4` FOREIGN KEY (`id_provenienza`) REFERENCES `provenienze_contatti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pratiche_ibfk_4_nofollow` FOREIGN KEY (`id_account_chiusura`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pratiche_ibfk_8` FOREIGN KEY (`id_esito`) REFERENCES `esiti_pratiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `pratiche_all_view`
--

DROP TABLE IF EXISTS `pratiche_all_view`;
/*!50001 DROP VIEW IF EXISTS `pratiche_all_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pratiche_all_view` (
  `id` tinyint NOT NULL,
  `numero` tinyint NOT NULL,
  `numero_ruolo` tinyint NOT NULL,
  `data_apertura` tinyint NOT NULL,
  `data_chiusura` tinyint NOT NULL,
  `id_sede_apertura` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_categoria_diritto` tinyint NOT NULL,
  `id_provenienza` tinyint NOT NULL,
  `note_segnalazione` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `controparte` tinyint NOT NULL,
  `se_patrocinio` tinyint NOT NULL,
  `se_accompagnamento` tinyint NOT NULL,
  `note_chiusura` tinyint NOT NULL,
  `ore_stimate` tinyint NOT NULL,
  `id_esito` tinyint NOT NULL,
  `se_richiesta_liquidazione` tinyint NOT NULL,
  `se_richiesto_rimborso` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `se_importata` tinyint NOT NULL,
  `id_account_chiusura` tinyint NOT NULL,
  `timestamp_chiusura` tinyint NOT NULL,
  `importata` tinyint NOT NULL,
  `se_chiusa` tinyint NOT NULL,
  `id_responsabile` tinyint NOT NULL,
  `id_volontario` tinyint NOT NULL,
  `lista_volontari` tinyint NOT NULL,
  `lista_assistiti` tinyint NOT NULL,
  `responsabile` tinyint NOT NULL,
  `__short_label__` tinyint NOT NULL,
  `diritto` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `esito` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `pratiche_aperte_view`
--

DROP TABLE IF EXISTS `pratiche_aperte_view`;
/*!50001 DROP VIEW IF EXISTS `pratiche_aperte_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pratiche_aperte_view` (
  `id` tinyint NOT NULL,
  `numero` tinyint NOT NULL,
  `numero_ruolo` tinyint NOT NULL,
  `data_apertura` tinyint NOT NULL,
  `data_chiusura` tinyint NOT NULL,
  `id_sede_apertura` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_categoria_diritto` tinyint NOT NULL,
  `id_provenienza` tinyint NOT NULL,
  `note_segnalazione` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `controparte` tinyint NOT NULL,
  `se_patrocinio` tinyint NOT NULL,
  `se_accompagnamento` tinyint NOT NULL,
  `note_chiusura` tinyint NOT NULL,
  `ore_stimate` tinyint NOT NULL,
  `id_esito` tinyint NOT NULL,
  `se_richiesta_liquidazione` tinyint NOT NULL,
  `se_richiesto_rimborso` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `se_importata` tinyint NOT NULL,
  `id_account_chiusura` tinyint NOT NULL,
  `timestamp_chiusura` tinyint NOT NULL,
  `importata` tinyint NOT NULL,
  `id_responsabile` tinyint NOT NULL,
  `id_volontario` tinyint NOT NULL,
  `lista_volontari` tinyint NOT NULL,
  `lista_assistiti` tinyint NOT NULL,
  `responsabile` tinyint NOT NULL,
  `__short_label__` tinyint NOT NULL,
  `diritto` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `pratiche_archivio_view`
--

DROP TABLE IF EXISTS `pratiche_archivio_view`;
/*!50001 DROP VIEW IF EXISTS `pratiche_archivio_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pratiche_archivio_view` (
  `id` tinyint NOT NULL,
  `numero` tinyint NOT NULL,
  `numero_ruolo` tinyint NOT NULL,
  `data_apertura` tinyint NOT NULL,
  `data_chiusura` tinyint NOT NULL,
  `id_sede_apertura` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_categoria_diritto` tinyint NOT NULL,
  `id_provenienza` tinyint NOT NULL,
  `note_segnalazione` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `controparte` tinyint NOT NULL,
  `se_patrocinio` tinyint NOT NULL,
  `se_accompagnamento` tinyint NOT NULL,
  `note_chiusura` tinyint NOT NULL,
  `ore_stimate` tinyint NOT NULL,
  `id_esito` tinyint NOT NULL,
  `se_richiesta_liquidazione` tinyint NOT NULL,
  `se_richiesto_rimborso` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `se_importata` tinyint NOT NULL,
  `id_account_chiusura` tinyint NOT NULL,
  `timestamp_chiusura` tinyint NOT NULL,
  `importata` tinyint NOT NULL,
  `id_responsabile` tinyint NOT NULL,
  `id_volontario` tinyint NOT NULL,
  `lista_volontari` tinyint NOT NULL,
  `lista_assistiti` tinyint NOT NULL,
  `responsabile` tinyint NOT NULL,
  `__short_label__` tinyint NOT NULL,
  `diritto` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pratiche_assistiti`
--

DROP TABLE IF EXISTS `pratiche_assistiti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pratiche_assistiti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `id_pratica` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_pratica` (`id_pratica`),
  KEY `unico` (`id_anagrafica`,`id_pratica`),
  KEY `id_anagrafica` (`id_anagrafica`),
  CONSTRAINT `pratiche_assistiti_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pratiche_assistiti_ibfk_2` FOREIGN KEY (`id_pratica`) REFERENCES `pratiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `pratiche_assistiti_view`
--

DROP TABLE IF EXISTS `pratiche_assistiti_view`;
/*!50001 DROP VIEW IF EXISTS `pratiche_assistiti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pratiche_assistiti_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_pratica` tinyint NOT NULL,
  `data_apertura` tinyint NOT NULL,
  `data_chiusura` tinyint NOT NULL,
  `responsabile` tinyint NOT NULL,
  `diritto` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `__short_label__` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pratiche_avvocati`
--

DROP TABLE IF EXISTS `pratiche_avvocati`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pratiche_avvocati` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `id_pratica` int(11) NOT NULL,
  `se_responsabile` int(1) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_anagrafica`,`id_pratica`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_pratica` (`id_pratica`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `pratiche_avvocati_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pratiche_avvocati_ibfk_2` FOREIGN KEY (`id_pratica`) REFERENCES `pratiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pratiche_avvocati_ibfk_3_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pratiche_avvocati_ibfk_4_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `pratiche_avvocati_view`
--

DROP TABLE IF EXISTS `pratiche_avvocati_view`;
/*!50001 DROP VIEW IF EXISTS `pratiche_avvocati_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pratiche_avvocati_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_pratica` tinyint NOT NULL,
  `se_responsabile` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `__short_label__` tinyint NOT NULL,
  `lista_assistiti` tinyint NOT NULL,
  `data_apertura` tinyint NOT NULL,
  `data_chiusura` tinyint NOT NULL,
  `diritto` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pratiche_servizi_contatto`
--

DROP TABLE IF EXISTS `pratiche_servizi_contatto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pratiche_servizi_contatto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pratica` int(11) NOT NULL,
  `id_servizio_contatto` int(11) NOT NULL,
  `testo` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_pratica`,`id_servizio_contatto`),
  KEY `id_servizio_contatto` (`id_servizio_contatto`),
  KEY `id_pratica` (`id_pratica`),
  CONSTRAINT `pratiche_servizi_contatto_ibfk_1` FOREIGN KEY (`id_pratica`) REFERENCES `pratiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pratiche_servizi_contatto_ibfk_2` FOREIGN KEY (`id_servizio_contatto`) REFERENCES `provenienze_contatti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `pratiche_servizi_contatto_view`
--

DROP TABLE IF EXISTS `pratiche_servizi_contatto_view`;
/*!50001 DROP VIEW IF EXISTS `pratiche_servizi_contatto_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pratiche_servizi_contatto_view` (
  `id` tinyint NOT NULL,
  `id_pratica` tinyint NOT NULL,
  `id_servizio_contatto` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `pratiche_view`
--

DROP TABLE IF EXISTS `pratiche_view`;
/*!50001 DROP VIEW IF EXISTS `pratiche_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pratiche_view` (
  `id` tinyint NOT NULL,
  `numero` tinyint NOT NULL,
  `numero_ruolo` tinyint NOT NULL,
  `data_apertura` tinyint NOT NULL,
  `data_chiusura` tinyint NOT NULL,
  `id_sede_apertura` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_categoria_diritto` tinyint NOT NULL,
  `id_provenienza` tinyint NOT NULL,
  `note_segnalazione` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `controparte` tinyint NOT NULL,
  `se_patrocinio` tinyint NOT NULL,
  `se_accompagnamento` tinyint NOT NULL,
  `note_chiusura` tinyint NOT NULL,
  `ore_stimate` tinyint NOT NULL,
  `id_esito` tinyint NOT NULL,
  `se_richiesta_liquidazione` tinyint NOT NULL,
  `se_richiesto_rimborso` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `se_importata` tinyint NOT NULL,
  `id_account_chiusura` tinyint NOT NULL,
  `timestamp_chiusura` tinyint NOT NULL,
  `__short_label__` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `prezzi`
--

DROP TABLE IF EXISTS `prezzi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prezzi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) DEFAULT NULL,
  `id_iva` int(11) NOT NULL,
  `id_udm` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prodotto_unico` (`id_prodotto`,`id_listino`,`id_iva`,`id_valuta`) USING BTREE,
  UNIQUE KEY `articolo_unico` (`id_articolo`,`id_listino`,`id_iva`,`id_valuta`) USING BTREE,
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_iva` (`id_iva`),
  KEY `id_valuta` (`id_valuta`),
  KEY `indice` (`id`,`id_prodotto`,`prezzo`,`id_listino`,`id_iva`,`id_valuta`),
  KEY `id_udm` (`id_udm`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_listino` (`id_listino`),
  CONSTRAINT `prezzi_ibfk_1` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `prezzi_ibfk_1_nofollow` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `prezzi_ibfk_2` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `prezzi_ibfk_2_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `prezzi_ibfk_3_nofollow` FOREIGN KEY (`id_udm`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `prezzi_ibfk_4` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `prezzi_view`
--

DROP TABLE IF EXISTS `prezzi_view`;
/*!50001 DROP VIEW IF EXISTS `prezzi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `prezzi_view` (
  `id` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `prezzo` tinyint NOT NULL,
  `id_listino` tinyint NOT NULL,
  `id_valuta` tinyint NOT NULL,
  `id_iva` tinyint NOT NULL,
  `id_udm` tinyint NOT NULL,
  `listino` tinyint NOT NULL,
  `iva` tinyint NOT NULL,
  `prezzo_netto` tinyint NOT NULL,
  `aliquota_iva` tinyint NOT NULL,
  `prezzo_lordo` tinyint NOT NULL,
  `valuta_html` tinyint NOT NULL,
  `valuta_utf8` tinyint NOT NULL,
  `valuta_iso4217` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `priorita`
--

DROP TABLE IF EXISTS `priorita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `priorita` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `priorita_view`
--

DROP TABLE IF EXISTS `priorita_view`;
/*!50001 DROP VIEW IF EXISTS `priorita_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `priorita_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `prodotti`
--

DROP TABLE IF EXISTS `prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prodotti` (
  `id` char(32) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `nome` char(128) NOT NULL,
  `se_sitemap` int(1) DEFAULT NULL,
  `se_cacheable` int(1) DEFAULT NULL,
  `descrizione` text,
  `ordine` int(11) DEFAULT NULL,
  `codifica` text,
  `id_udm` int(11) DEFAULT NULL,
  `id_ingombro` int(11) DEFAULT NULL,
  `ingombro_proporzionale` decimal(16,5) DEFAULT NULL,
  `larghezza_prodotto` decimal(9,3) DEFAULT NULL,
  `lunghezza_prodotto` decimal(9,3) DEFAULT NULL,
  `altezza_prodotto` decimal(9,3) DEFAULT NULL,
  `id_produttore` int(11) DEFAULT NULL,
  `codice_produttore` char(64) DEFAULT NULL,
  `id_fornitore` int(11) DEFAULT NULL,
  `id_marchio` int(11) DEFAULT NULL,
  `id_tipologia_pubblicazione` int(11) DEFAULT NULL,
  `se_disponibile` int(1) DEFAULT '1',
  `se_matricola` int(1) DEFAULT NULL,
  `se_ore` int(1) DEFAULT NULL,
  `timestamp_pubblicazione` int(11) DEFAULT NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_udm` (`id_udm`),
  KEY `id_ingombro` (`id_ingombro`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_tipologia_pubblicazione` (`id_tipologia_pubblicazione`),
  KEY `id_produttore` (`id_produttore`),
  KEY `id_marchio` (`id_marchio`),
  KEY `id_fornitore` (`id_fornitore`),
  KEY `ordine` (`ordine`),
  CONSTRAINT `prodotti_ibfk_1_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_prodotti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `prodotti_ibfk_2_nofollow` FOREIGN KEY (`id_udm`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `prodotti_ibfk_3_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `prodotti_ibfk_4_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `prodotti_ibfk_5_nofollow` FOREIGN KEY (`id_tipologia_pubblicazione`) REFERENCES `tipologie_pubblicazione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `prodotti_ibfk_6_nofollow` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `prodotti_ibfk_7_nofollow` FOREIGN KEY (`id_produttore`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `prodotti_ibfk_8_nofollow` FOREIGN KEY (`id_ingombro`) REFERENCES `ingombri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `prodotti_ibfk_9_nofollow` FOREIGN KEY (`id_fornitore`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prodotti_caratteristiche`
--

DROP TABLE IF EXISTS `prodotti_caratteristiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prodotti_caratteristiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_lingua` int(11) DEFAULT NULL,
  `id_prodotto` char(32) NOT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `testo` text,
  `se_non_presente` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_prodotto` (`id_prodotto`,`id_caratteristica`),
  KEY `ordine` (`ordine`),
  KEY `indice` (`id`,`id_prodotto`,`id_caratteristica`,`ordine`),
  KEY `id_caratteristica` (`id_caratteristica`),
  KEY `id_lingua` (`id_lingua`),
  CONSTRAINT `prodotti_caratteristiche_ibfk_1` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_caratteristiche_ibfk_2` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `prodotti_caratteristiche_view`
--

DROP TABLE IF EXISTS `prodotti_caratteristiche_view`;
/*!50001 DROP VIEW IF EXISTS `prodotti_caratteristiche_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `prodotti_caratteristiche_view` (
  `id` tinyint NOT NULL,
  `id_lingua` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_caratteristica` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `se_non_presente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `caratteristica` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `prodotti_categorie`
--

DROP TABLE IF EXISTS `prodotti_categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prodotti_categorie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_prodotto` char(32) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_principale` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_prodotto` (`id_prodotto`,`id_categoria`),
  KEY `id_categoria` (`id_categoria`),
  KEY `ordine` (`ordine`),
  KEY `se_principale` (`se_principale`),
  KEY `indice` (`id`,`id_prodotto`,`id_categoria`,`ordine`,`se_principale`),
  KEY `id_ruolo` (`id_ruolo`),
  CONSTRAINT `prodotti_categorie_ibfk_1` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_categorie_ibfk_2_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_categorie_ibfk_3_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_prodotti_categorie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `prodotti_categorie_view`
--

DROP TABLE IF EXISTS `prodotti_categorie_view`;
/*!50001 DROP VIEW IF EXISTS `prodotti_categorie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `prodotti_categorie_view` (
  `id` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_categoria` tinyint NOT NULL,
  `id_ruolo` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `se_principale` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `prodotto` tinyint NOT NULL,
  `pubblicazione` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `prodotti_modalita_spedizione`
--

DROP TABLE IF EXISTS `prodotti_modalita_spedizione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prodotti_modalita_spedizione` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_prodotto` char(32) NOT NULL,
  `id_modalita` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_prodotto`,`id_modalita`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_modalita` (`id_modalita`),
  KEY `indice` (`id`,`id_prodotto`,`id_modalita`),
  CONSTRAINT `prodotti_modalita_spedizione_ibfk_1` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_modalita_spedizione_ibfk_2_nofollow` FOREIGN KEY (`id_modalita`) REFERENCES `modalita_spedizione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prodotti_stagioni`
--

DROP TABLE IF EXISTS `prodotti_stagioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prodotti_stagioni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_prodotto` char(32) NOT NULL,
  `id_stagione` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_stagione` (`id_stagione`),
  CONSTRAINT `prodotti_stagioni_ibfk_1_nofollow` FOREIGN KEY (`id_stagione`) REFERENCES `stagioni_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_stagioni_ibfk_2` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `prodotti_stagioni_view`
--

DROP TABLE IF EXISTS `prodotti_stagioni_view`;
/*!50001 DROP VIEW IF EXISTS `prodotti_stagioni_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `prodotti_stagioni_view` (
  `id` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_stagione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `prodotti_view`
--

DROP TABLE IF EXISTS `prodotti_view`;
/*!50001 DROP VIEW IF EXISTS `prodotti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `prodotti_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `codifica` tinyint NOT NULL,
  `id_udm` tinyint NOT NULL,
  `id_ingombro` tinyint NOT NULL,
  `ingombro_proporzionale` tinyint NOT NULL,
  `larghezza_prodotto` tinyint NOT NULL,
  `lunghezza_prodotto` tinyint NOT NULL,
  `altezza_prodotto` tinyint NOT NULL,
  `id_produttore` tinyint NOT NULL,
  `codice_produttore` tinyint NOT NULL,
  `id_fornitore` tinyint NOT NULL,
  `id_marchio` tinyint NOT NULL,
  `id_tipologia_pubblicazione` tinyint NOT NULL,
  `se_disponibile` tinyint NOT NULL,
  `se_matricola` tinyint NOT NULL,
  `se_ore` tinyint NOT NULL,
  `timestamp_pubblicazione` tinyint NOT NULL,
  `timestamp_archiviazione` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `se_pubblicato` tinyint NOT NULL,
  `tipologia_pubblicazione` tinyint NOT NULL,
  `categorie` tinyint NOT NULL,
  `produttore` tinyint NOT NULL,
  `marchio` tinyint NOT NULL,
  `se_prodotto` tinyint NOT NULL,
  `se_servizio` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `progetti`
--

DROP TABLE IF EXISTS `progetti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `progetti` (
  `id` char(32) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `testo` text,
  `id_pianificazione` int(11) DEFAULT NULL,
  `ranking` char(32) DEFAULT NULL,
  `id_account_accettazione` int(11) DEFAULT NULL,
  `data_accettazione` date DEFAULT NULL,
  `timestamp_accettazione` int(11) DEFAULT NULL,
  `fatturato_accettazione` decimal(16,2) DEFAULT NULL,
  `testo_accettazione` text,
  `fatturato_previsto` decimal(16,2) DEFAULT NULL,
  `ore_previste` decimal(16,2) DEFAULT NULL,
  `costi_previsti` decimal(16,2) DEFAULT NULL,
  `testo_previsioni` text,
  `id_account_chiusura` int(11) DEFAULT NULL,
  `timestamp_chiusura` int(11) DEFAULT NULL,
  `testo_chiusura` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `se_lavoro_festivo` int(1) DEFAULT NULL,
  `se_lavoro_weekend` int(1) DEFAULT NULL,
  `id_mastro_attivita_default` int(11) DEFAULT NULL,
  `id_mastro_magazzino_lavoro_default` int(11) DEFAULT NULL,
  `id_mastro_magazzino_vendita_default` int(11) DEFAULT NULL,
  `se_cancellare` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_account_chiusura` (`id_account_chiusura`),
  KEY `id_account_accettazione` (`id_account_accettazione`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `ranking` (`ranking`),
  KEY `se_lavoro_festivo` (`se_lavoro_festivo`),
  KEY `se_lavoro_weekend` (`se_lavoro_weekend`),
  KEY `data_accettazione` (`data_accettazione`),
  KEY `id_pianificazione` (`id_pianificazione`),
  KEY `id_mastro_attivita_default` (`id_mastro_attivita_default`),
  KEY `se_cancellare` (`se_cancellare`),
  KEY `id_mastro_magazzino_lavoro_default` (`id_mastro_magazzino_lavoro_default`),
  KEY `id_mastro_magazzino_vendita_default` (`id_mastro_magazzino_vendita_default`),
  CONSTRAINT `progetti_ibfk_1_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `progetti_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `progetti_ibfk_32_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `progetti_ibfk_33_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `progetti_ibfk_34_nofollow` FOREIGN KEY (`id_mastro_attivita_default`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `progetti_ibfk_35_nofollow` FOREIGN KEY (`id_mastro_magazzino_lavoro_default`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `progetti_ibfk_36_nofollow` FOREIGN KEY (`id_mastro_magazzino_vendita_default`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `progetti_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `progetti_ibfk_4_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `progetti_ibfk_5_nofollow` FOREIGN KEY (`id_account_chiusura`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `progetti_ibfk_6_nofollow` FOREIGN KEY (`id_account_accettazione`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `progetti_anagrafica`
--

DROP TABLE IF EXISTS `progetti_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `progetti_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_progetto` char(32) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `se_sostituto` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `se_sostituto` (`se_sostituto`),
  CONSTRAINT `progetti_anagrafica_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `progetti_anagrafica_ibfk_1_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `progetti_anagrafica_ibfk_2_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `progetti_anagrafica_view`
--

DROP TABLE IF EXISTS `progetti_anagrafica_view`;
/*!50001 DROP VIEW IF EXISTS `progetti_anagrafica_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `progetti_anagrafica_view` (
  `id` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_ruolo` tinyint NOT NULL,
  `se_sostituto` tinyint NOT NULL,
  `ruolo` tinyint NOT NULL,
  `se_responsabile_qualita` tinyint NOT NULL,
  `se_responsabile_acquisti` tinyint NOT NULL,
  `se_coordinatore` tinyint NOT NULL,
  `se_responsabile_amministrativo` tinyint NOT NULL,
  `se_responsabile_servizi` tinyint NOT NULL,
  `se_operativo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `progetti_categorie`
--

DROP TABLE IF EXISTS `progetti_categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `progetti_categorie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_progetto` char(32) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_progetto`,`id_categoria`),
  KEY `id_categoria` (`id_categoria`),
  KEY `indice` (`id`,`id_progetto`,`id_categoria`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_progetto` (`id_progetto`),
  CONSTRAINT `progetti_categorie_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `progetti_categorie_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `progetti_categorie_ibfk_2_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `progetti_categorie_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `progetti_categorie_view`
--

DROP TABLE IF EXISTS `progetti_categorie_view`;
/*!50001 DROP VIEW IF EXISTS `progetti_categorie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `progetti_categorie_view` (
  `id` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `id_categoria` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `progetti_certificazioni`
--

DROP TABLE IF EXISTS `progetti_certificazioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `progetti_certificazioni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_certificazione` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_certificazione`,`id_progetto`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_certificazione` (`id_certificazione`),
  CONSTRAINT `progetti_certificazioni_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `progetti_certificazioni_ibfk_2` FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `progetti_certificazioni_view`
--

DROP TABLE IF EXISTS `progetti_certificazioni_view`;
/*!50001 DROP VIEW IF EXISTS `progetti_certificazioni_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `progetti_certificazioni_view` (
  `id` tinyint NOT NULL,
  `id_certificazione` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `certificazione` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `progetti_commerciale_view`
--

DROP TABLE IF EXISTS `progetti_commerciale_view`;
/*!50001 DROP VIEW IF EXISTS `progetti_commerciale_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `progetti_commerciale_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `id_pianificazione` tinyint NOT NULL,
  `ranking` tinyint NOT NULL,
  `id_account_accettazione` tinyint NOT NULL,
  `data_accettazione` tinyint NOT NULL,
  `timestamp_accettazione` tinyint NOT NULL,
  `fatturato_accettazione` tinyint NOT NULL,
  `testo_accettazione` tinyint NOT NULL,
  `fatturato_previsto` tinyint NOT NULL,
  `ore_previste` tinyint NOT NULL,
  `costi_previsti` tinyint NOT NULL,
  `testo_previsioni` tinyint NOT NULL,
  `id_account_chiusura` tinyint NOT NULL,
  `timestamp_chiusura` tinyint NOT NULL,
  `testo_chiusura` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `se_lavoro_festivo` tinyint NOT NULL,
  `se_lavoro_weekend` tinyint NOT NULL,
  `id_mastro_attivita_default` tinyint NOT NULL,
  `se_cancellare` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `categorie` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `chiuso` tinyint NOT NULL,
  `mastro_attivita_default` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `progetti_eliminare_view`
--

DROP TABLE IF EXISTS `progetti_eliminare_view`;
/*!50001 DROP VIEW IF EXISTS `progetti_eliminare_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `progetti_eliminare_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `id_pianificazione` tinyint NOT NULL,
  `ranking` tinyint NOT NULL,
  `id_account_accettazione` tinyint NOT NULL,
  `data_accettazione` tinyint NOT NULL,
  `timestamp_accettazione` tinyint NOT NULL,
  `fatturato_accettazione` tinyint NOT NULL,
  `testo_accettazione` tinyint NOT NULL,
  `fatturato_previsto` tinyint NOT NULL,
  `ore_previste` tinyint NOT NULL,
  `costi_previsti` tinyint NOT NULL,
  `testo_previsioni` tinyint NOT NULL,
  `id_account_chiusura` tinyint NOT NULL,
  `timestamp_chiusura` tinyint NOT NULL,
  `testo_chiusura` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `se_lavoro_festivo` tinyint NOT NULL,
  `se_lavoro_weekend` tinyint NOT NULL,
  `id_mastro_attivita_default` tinyint NOT NULL,
  `se_cancellare` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `se_ordinario` tinyint NOT NULL,
  `se_straordinario` tinyint NOT NULL,
  `categorie` tinyint NOT NULL,
  `chiuso` tinyint NOT NULL,
  `mastro_attivita_default` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `progetti_produzione_view`
--

DROP TABLE IF EXISTS `progetti_produzione_view`;
/*!50001 DROP VIEW IF EXISTS `progetti_produzione_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `progetti_produzione_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `id_pianificazione` tinyint NOT NULL,
  `ranking` tinyint NOT NULL,
  `id_account_accettazione` tinyint NOT NULL,
  `data_accettazione` tinyint NOT NULL,
  `timestamp_accettazione` tinyint NOT NULL,
  `fatturato_accettazione` tinyint NOT NULL,
  `testo_accettazione` tinyint NOT NULL,
  `fatturato_previsto` tinyint NOT NULL,
  `ore_previste` tinyint NOT NULL,
  `costi_previsti` tinyint NOT NULL,
  `testo_previsioni` tinyint NOT NULL,
  `id_account_chiusura` tinyint NOT NULL,
  `timestamp_chiusura` tinyint NOT NULL,
  `testo_chiusura` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `se_lavoro_festivo` tinyint NOT NULL,
  `se_lavoro_weekend` tinyint NOT NULL,
  `id_mastro_attivita_default` tinyint NOT NULL,
  `se_cancellare` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `se_ordinario` tinyint NOT NULL,
  `se_straordinario` tinyint NOT NULL,
  `categorie` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `chiuso` tinyint NOT NULL,
  `mastro_attivita_default` tinyint NOT NULL,
  `attivo` tinyint NOT NULL,
  `task_aperti` tinyint NOT NULL,
  `task_chiusi` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `progetti_scoperti_view`
--

DROP TABLE IF EXISTS `progetti_scoperti_view`;
/*!50001 DROP VIEW IF EXISTS `progetti_scoperti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `progetti_scoperti_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `id_pianificazione` tinyint NOT NULL,
  `ranking` tinyint NOT NULL,
  `id_account_accettazione` tinyint NOT NULL,
  `data_accettazione` tinyint NOT NULL,
  `timestamp_accettazione` tinyint NOT NULL,
  `fatturato_accettazione` tinyint NOT NULL,
  `testo_accettazione` tinyint NOT NULL,
  `fatturato_previsto` tinyint NOT NULL,
  `ore_previste` tinyint NOT NULL,
  `costi_previsti` tinyint NOT NULL,
  `testo_previsioni` tinyint NOT NULL,
  `id_account_chiusura` tinyint NOT NULL,
  `timestamp_chiusura` tinyint NOT NULL,
  `testo_chiusura` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `se_lavoro_festivo` tinyint NOT NULL,
  `se_lavoro_weekend` tinyint NOT NULL,
  `id_mastro_attivita_default` tinyint NOT NULL,
  `se_cancellare` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `se_ordinario` tinyint NOT NULL,
  `se_straordinario` tinyint NOT NULL,
  `categorie` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `mastro_attivita_default` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `data_scopertura` tinyint NOT NULL,
  `assenti` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `progetti_view`
--

DROP TABLE IF EXISTS `progetti_view`;
/*!50001 DROP VIEW IF EXISTS `progetti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `progetti_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `id_pianificazione` tinyint NOT NULL,
  `ranking` tinyint NOT NULL,
  `id_account_accettazione` tinyint NOT NULL,
  `data_accettazione` tinyint NOT NULL,
  `timestamp_accettazione` tinyint NOT NULL,
  `fatturato_accettazione` tinyint NOT NULL,
  `testo_accettazione` tinyint NOT NULL,
  `fatturato_previsto` tinyint NOT NULL,
  `ore_previste` tinyint NOT NULL,
  `costi_previsti` tinyint NOT NULL,
  `testo_previsioni` tinyint NOT NULL,
  `id_account_chiusura` tinyint NOT NULL,
  `timestamp_chiusura` tinyint NOT NULL,
  `testo_chiusura` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `se_lavoro_festivo` tinyint NOT NULL,
  `se_lavoro_weekend` tinyint NOT NULL,
  `id_mastro_attivita_default` tinyint NOT NULL,
  `se_cancellare` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `se_ordinario` tinyint NOT NULL,
  `se_straordinario` tinyint NOT NULL,
  `categorie` tinyint NOT NULL,
  `chiuso` tinyint NOT NULL,
  `mastro_attivita_default` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `provenienze_contatti`
--

DROP TABLE IF EXISTS `provenienze_contatti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `provenienze_contatti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_contatto` int(11) DEFAULT NULL,
  `se_segnalato` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `provenienze_contatti_view`
--

DROP TABLE IF EXISTS `provenienze_contatti_view`;
/*!50001 DROP VIEW IF EXISTS `provenienze_contatti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `provenienze_contatti_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_contatto` tinyint NOT NULL,
  `se_segnalato` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `provincie`
--

DROP TABLE IF EXISTS `provincie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `provincie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_regione` int(11) NOT NULL,
  `nome` varchar(254) NOT NULL,
  `sigla` char(8) DEFAULT NULL,
  `codice_istat` char(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sigla` (`sigla`),
  KEY `id_regione` (`id_regione`),
  KEY `indice` (`id`,`id_regione`,`nome`,`sigla`),
  CONSTRAINT `provincie_ibfk_3_nofollow` FOREIGN KEY (`id_regione`) REFERENCES `regioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `provincie_view`
--

DROP TABLE IF EXISTS `provincie_view`;
/*!50001 DROP VIEW IF EXISTS `provincie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `provincie_view` (
  `id` tinyint NOT NULL,
  `id_regione` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `sigla` tinyint NOT NULL,
  `codice_istat` tinyint NOT NULL,
  `regione` tinyint NOT NULL,
  `id_stato` tinyint NOT NULL,
  `stato` tinyint NOT NULL,
  `id_continente` tinyint NOT NULL,
  `continente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pubblicazione`
--

DROP TABLE IF EXISTS `pubblicazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pubblicazione` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_sito` int(11) DEFAULT NULL,
  `id_tipologia` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_popup` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `template` char(32) DEFAULT NULL,
  `schema_html` char(32) DEFAULT NULL,
  `tema_css` char(32) DEFAULT NULL,
  `se_sitemap` int(1) DEFAULT NULL,
  `se_cacheable` int(1) DEFAULT NULL,
  `note` char(254) DEFAULT NULL,
  `timestamp_pubblicazione` int(11) DEFAULT NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_sito` (`id_sito`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_popup` (`id_popup`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  CONSTRAINT `pubblicazione_ibfk_1` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_pubblicazione` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `pubblicazione_ibfk_10` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazione_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `pubblicazione` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pubblicazione_ibfk_2` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazione_ibfk_3` FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazione_ibfk_4` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazione_ibfk_5` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazione_ibfk_6` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazione_ibfk_9` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `pubblicazione_view`
--

DROP TABLE IF EXISTS `pubblicazione_view`;
/*!50001 DROP VIEW IF EXISTS `pubblicazione_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `pubblicazione_view` (
  `id` tinyint NOT NULL,
  `id_sito` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `id_categoria_prodotti` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `id_popup` tinyint NOT NULL,
  `id_categoria_notizie` tinyint NOT NULL,
  `id_notizia` tinyint NOT NULL,
  `template` tinyint NOT NULL,
  `schema_html` tinyint NOT NULL,
  `tema_css` tinyint NOT NULL,
  `se_sitemap` tinyint NOT NULL,
  `se_cacheable` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `timestamp_pubblicazione` tinyint NOT NULL,
  `timestamp_archiviazione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rassegna_stampa`
--

DROP TABLE IF EXISTS `rassegna_stampa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rassegna_stampa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` date DEFAULT NULL,
  `id_testata` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `testo` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_testata` (`id_testata`),
  KEY `id_tipologia` (`id_tipologia`),
  CONSTRAINT `rassegna_stampa_ibfk_1` FOREIGN KEY (`id_testata`) REFERENCES `testate` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rassegna_stampa_ibfk_2` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_rassegna_stampa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rassegna_stampa_anagrafica`
--

DROP TABLE IF EXISTS `rassegna_stampa_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rassegna_stampa_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_rassegna_stampa` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_ruolo` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_rassegna_stampa` (`id_rassegna_stampa`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  CONSTRAINT `rassegna_stampa_anagrafica_ibfk_1` FOREIGN KEY (`id_rassegna_stampa`) REFERENCES `rassegna_stampa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rassegna_stampa_anagrafica_ibfk_2_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rassegna_stampa_anagrafica_ibfk_3_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_rassegna_stampa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rassegna_stampa_eventi`
--

DROP TABLE IF EXISTS `rassegna_stampa_eventi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rassegna_stampa_eventi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_rassegna_stampa` int(11) NOT NULL,
  `id_evento` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_rassegna_stampa_2` (`id_rassegna_stampa`,`id_evento`),
  KEY `id_rassegna_stampa` (`id_rassegna_stampa`),
  KEY `id_evento` (`id_evento`),
  KEY `indice` (`id`,`id_rassegna_stampa`,`id_evento`),
  CONSTRAINT `rassegna_stampa_eventi_ibfk_1` FOREIGN KEY (`id_rassegna_stampa`) REFERENCES `rassegna_stampa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rassegna_stampa_eventi_ibfk_2` FOREIGN KEY (`id_evento`) REFERENCES `eventi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `rassegna_stampa_view`
--

DROP TABLE IF EXISTS `rassegna_stampa_view`;
/*!50001 DROP VIEW IF EXISTS `rassegna_stampa_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rassegna_stampa_view` (
  `id` tinyint NOT NULL,
  `data` tinyint NOT NULL,
  `id_testata` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `eventi` tinyint NOT NULL,
  `autori` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `recensioni`
--

DROP TABLE IF EXISTS `recensioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recensioni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_lingua` int(11) NOT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `autore` char(128) NOT NULL,
  `valutazione` int(11) NOT NULL,
  `titolo` char(255) DEFAULT NULL,
  `testo` text,
  `se_approvata` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_lingua`,`id_prodotto`,`autore`,`valutazione`,`se_approvata`),
  KEY `id_pagina` (`id_pagina`),
  CONSTRAINT `recensioni_ibfk_1` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `recensioni_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `recensioni_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `recensioni_ibfk_3_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `recensioni_ibfk_4_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `recensioni_view`
--

DROP TABLE IF EXISTS `recensioni_view`;
/*!50001 DROP VIEW IF EXISTS `recensioni_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `recensioni_view` (
  `id` tinyint NOT NULL,
  `id_lingua` tinyint NOT NULL,
  `id_prodotto` tinyint NOT NULL,
  `id_pagina` tinyint NOT NULL,
  `autore` tinyint NOT NULL,
  `valutazione` tinyint NOT NULL,
  `titolo` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `se_approvata` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_ora_recensione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `redirect`
--

DROP TABLE IF EXISTS `redirect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `redirect` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codice` int(11) NOT NULL,
  `sorgente` char(255) NOT NULL,
  `destinazione` char(255) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sorgente` (`sorgente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `redirect_view`
--

DROP TABLE IF EXISTS `redirect_view`;
/*!50001 DROP VIEW IF EXISTS `redirect_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `redirect_view` (
  `id` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `sorgente` tinyint NOT NULL,
  `destinazione` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `refresh_view_statiche`
--

DROP TABLE IF EXISTS `refresh_view_statiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `refresh_view_statiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entita` char(64) NOT NULL,
  `note` text,
  `timestamp_prenotazione` int(11) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `entita` (`entita`),
  KEY `timestamp_prenotazione` (`timestamp_prenotazione`),
  KEY `token` (`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regimi_fiscali`
--

DROP TABLE IF EXISTS `regimi_fiscali`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `regimi_fiscali` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  `codice` char(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `indice` (`id`,`nome`,`codice`),
  KEY `codice` (`codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `regimi_fiscali_view`
--

DROP TABLE IF EXISTS `regimi_fiscali_view`;
/*!50001 DROP VIEW IF EXISTS `regimi_fiscali_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `regimi_fiscali_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `regioni`
--

DROP TABLE IF EXISTS `regioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `regioni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_stato` int(11) NOT NULL,
  `nome` char(32) NOT NULL,
  `codice_istat` char(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codice_istat` (`codice_istat`),
  KEY `id_stato` (`id_stato`),
  CONSTRAINT `regioni_ibfk_2_nofollow` FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `regioni_view`
--

DROP TABLE IF EXISTS `regioni_view`;
/*!50001 DROP VIEW IF EXISTS `regioni_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `regioni_view` (
  `id` tinyint NOT NULL,
  `id_stato` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `codice_istat` tinyint NOT NULL,
  `stato` tinyint NOT NULL,
  `id_continente` tinyint NOT NULL,
  `continente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `reparti`
--

DROP TABLE IF EXISTS `reparti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reparti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_iva` int(11) NOT NULL,
  `id_settore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_iva` (`id_iva`),
  KEY `id_settore` (`id_settore`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `reparti_ibfk_1` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `reparti_ibfk_1_nofollow` FOREIGN KEY (`id_settore`) REFERENCES `settori` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `reparti_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `reparti_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `reparti_view`
--

DROP TABLE IF EXISTS `reparti_view`;
/*!50001 DROP VIEW IF EXISTS `reparti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `reparti_view` (
  `id` tinyint NOT NULL,
  `id_iva` tinyint NOT NULL,
  `id_settore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `aliquota_iva` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `richieste_immobili`
--

DROP TABLE IF EXISTS `richieste_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `richieste_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) NOT NULL,
  `id_agente` int(11) DEFAULT NULL,
  `piano_min` int(11) DEFAULT NULL,
  `piano_max` int(11) DEFAULT NULL,
  `mq_min` decimal(5,2) DEFAULT NULL,
  `mq_max` decimal(5,2) DEFAULT NULL,
  `cucine_min` int(11) DEFAULT NULL,
  `cucine_max` int(11) DEFAULT NULL,
  `bagni_min` int(11) DEFAULT NULL,
  `bagni_max` int(11) DEFAULT NULL,
  `camere_min` int(11) DEFAULT NULL,
  `camere_max` int(11) DEFAULT NULL,
  `spese_min` decimal(15,2) DEFAULT NULL,
  `spese_max` decimal(15,2) DEFAULT NULL,
  `note_richiesta` text,
  `note_interne` text,
  `timestamp_incrocio` int(11) DEFAULT NULL,
  `id_esito` int(11) DEFAULT NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  `note_archiviazione` text,
  `id_account_editor` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_esito` (`id_esito`),
  KEY `id_agente` (`id_agente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_account_editor` (`id_account_editor`),
  CONSTRAINT `richieste_immobili_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `richieste_immobili_ibfk_2` FOREIGN KEY (`id_esito`) REFERENCES `esiti_richieste_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `richieste_immobili_ibfk_4` FOREIGN KEY (`id_agente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `richieste_immobili_ibfk_6` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `richieste_immobili_ibfk_7` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `richieste_immobili_ibfk_8` FOREIGN KEY (`id_account_editor`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `richieste_immobili_archivio_view`
--

DROP TABLE IF EXISTS `richieste_immobili_archivio_view`;
/*!50001 DROP VIEW IF EXISTS `richieste_immobili_archivio_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `richieste_immobili_archivio_view` (
  `id` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `piano_min` tinyint NOT NULL,
  `piano_max` tinyint NOT NULL,
  `mq_min` tinyint NOT NULL,
  `mq_max` tinyint NOT NULL,
  `cucine_min` tinyint NOT NULL,
  `cucine_max` tinyint NOT NULL,
  `bagni_min` tinyint NOT NULL,
  `bagni_max` tinyint NOT NULL,
  `camere_min` tinyint NOT NULL,
  `camere_max` tinyint NOT NULL,
  `spese_min` tinyint NOT NULL,
  `spese_max` tinyint NOT NULL,
  `note_richiesta` tinyint NOT NULL,
  `note_interne` tinyint NOT NULL,
  `timestamp_incrocio` tinyint NOT NULL,
  `id_esito` tinyint NOT NULL,
  `timestamp_archiviazione` tinyint NOT NULL,
  `note_archiviazione` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_archiviazione` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `tipologia_incarico` tinyint NOT NULL,
  `tipologia_immobile` tinyint NOT NULL,
  `zona` tinyint NOT NULL,
  `mail` tinyint NOT NULL,
  `telefoni` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `richieste_immobili_caratteristiche`
--

DROP TABLE IF EXISTS `richieste_immobili_caratteristiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `richieste_immobili_caratteristiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_richiesta` int(11) NOT NULL,
  `id_caratteristica` int(11) NOT NULL,
  `specifiche` text,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_richiesta`,`id_caratteristica`),
  KEY `id_caratteristica` (`id_caratteristica`),
  KEY `id_richiesta` (`id_richiesta`),
  CONSTRAINT `richieste_immobili_caratteristiche_ibfk_1` FOREIGN KEY (`id_richiesta`) REFERENCES `richieste_immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `richieste_immobili_caratteristiche_ibfk_2` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `richieste_immobili_caratteristiche_view`
--

DROP TABLE IF EXISTS `richieste_immobili_caratteristiche_view`;
/*!50001 DROP VIEW IF EXISTS `richieste_immobili_caratteristiche_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `richieste_immobili_caratteristiche_view` (
  `id` tinyint NOT NULL,
  `id_richiesta` tinyint NOT NULL,
  `id_caratteristica` tinyint NOT NULL,
  `specifiche` tinyint NOT NULL,
  `se_non_desiderata` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `richieste_immobili_classi_energetiche`
--

DROP TABLE IF EXISTS `richieste_immobili_classi_energetiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `richieste_immobili_classi_energetiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_richiesta` int(11) NOT NULL,
  `id_classe` int(11) NOT NULL,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_richiesta`,`id_classe`),
  KEY `id_richiesta` (`id_richiesta`),
  KEY `id_classe` (`id_classe`),
  CONSTRAINT `richieste_immobili_classi_energetiche_ibfk_1` FOREIGN KEY (`id_richiesta`) REFERENCES `richieste_immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `richieste_immobili_classi_energetiche_ibfk_2` FOREIGN KEY (`id_classe`) REFERENCES `classi_energetiche_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `richieste_immobili_classi_energetiche_view`
--

DROP TABLE IF EXISTS `richieste_immobili_classi_energetiche_view`;
/*!50001 DROP VIEW IF EXISTS `richieste_immobili_classi_energetiche_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `richieste_immobili_classi_energetiche_view` (
  `id` tinyint NOT NULL,
  `id_richiesta` tinyint NOT NULL,
  `id_classe` tinyint NOT NULL,
  `se_non_desiderata` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `richieste_immobili_condizioni`
--

DROP TABLE IF EXISTS `richieste_immobili_condizioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `richieste_immobili_condizioni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_richiesta` int(11) NOT NULL,
  `id_condizione` int(11) NOT NULL,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_richiesta`,`id_condizione`),
  KEY `id_richiesta` (`id_richiesta`),
  KEY `id_condizione` (`id_condizione`),
  CONSTRAINT `richieste_immobili_condizioni_ibfk_1` FOREIGN KEY (`id_richiesta`) REFERENCES `richieste_immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `richieste_immobili_condizioni_ibfk_2` FOREIGN KEY (`id_condizione`) REFERENCES `condizioni_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `richieste_immobili_condizioni_view`
--

DROP TABLE IF EXISTS `richieste_immobili_condizioni_view`;
/*!50001 DROP VIEW IF EXISTS `richieste_immobili_condizioni_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `richieste_immobili_condizioni_view` (
  `id` tinyint NOT NULL,
  `id_richiesta` tinyint NOT NULL,
  `id_condizione` tinyint NOT NULL,
  `se_non_desiderata` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `richieste_immobili_disponibilita`
--

DROP TABLE IF EXISTS `richieste_immobili_disponibilita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `richieste_immobili_disponibilita` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_richiesta` int(11) NOT NULL,
  `id_disponibilita` int(11) NOT NULL,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_richiesta`,`id_disponibilita`),
  KEY `id_richiesta` (`id_richiesta`),
  KEY `id_disponibilita` (`id_disponibilita`),
  CONSTRAINT `richieste_immobili_disponibilita_ibfk_1` FOREIGN KEY (`id_richiesta`) REFERENCES `richieste_immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `richieste_immobili_disponibilita_ibfk_2` FOREIGN KEY (`id_disponibilita`) REFERENCES `disponibilita_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `richieste_immobili_disponibilita_view`
--

DROP TABLE IF EXISTS `richieste_immobili_disponibilita_view`;
/*!50001 DROP VIEW IF EXISTS `richieste_immobili_disponibilita_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `richieste_immobili_disponibilita_view` (
  `id` tinyint NOT NULL,
  `id_richiesta` tinyint NOT NULL,
  `id_disponibilita` tinyint NOT NULL,
  `se_non_desiderata` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `richieste_immobili_tipologie`
--

DROP TABLE IF EXISTS `richieste_immobili_tipologie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `richieste_immobili_tipologie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_richiesta` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_richiesta`,`id_tipologia`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_richiesta` (`id_richiesta`),
  CONSTRAINT `richieste_immobili_tipologie_ibfk_1` FOREIGN KEY (`id_richiesta`) REFERENCES `richieste_immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `richieste_immobili_tipologie_ibfk_2` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `richieste_immobili_tipologie_edifici`
--

DROP TABLE IF EXISTS `richieste_immobili_tipologie_edifici`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `richieste_immobili_tipologie_edifici` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_richiesta` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_richiesta`,`id_tipologia`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_richiesta` (`id_richiesta`),
  CONSTRAINT `richieste_immobili_tipologie_edifici_ibfk_1` FOREIGN KEY (`id_richiesta`) REFERENCES `richieste_immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `richieste_immobili_tipologie_edifici_ibfk_2` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_edifici` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `richieste_immobili_tipologie_edifici_view`
--

DROP TABLE IF EXISTS `richieste_immobili_tipologie_edifici_view`;
/*!50001 DROP VIEW IF EXISTS `richieste_immobili_tipologie_edifici_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `richieste_immobili_tipologie_edifici_view` (
  `id` tinyint NOT NULL,
  `id_richiesta` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `se_non_desiderata` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `richieste_immobili_tipologie_incarichi`
--

DROP TABLE IF EXISTS `richieste_immobili_tipologie_incarichi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `richieste_immobili_tipologie_incarichi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_richiesta` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `id_tipologia_founding` int(11) DEFAULT NULL,
  `prezzo_min` decimal(15,2) DEFAULT NULL,
  `prezzo_max` decimal(15,2) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_richiesta`,`id_tipologia`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_richiesta` (`id_richiesta`),
  KEY `id_tipologia_founding` (`id_tipologia_founding`),
  CONSTRAINT `richieste_immobili_tipologie_incarichi_ibfk_1` FOREIGN KEY (`id_richiesta`) REFERENCES `richieste_immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `richieste_immobili_tipologie_incarichi_ibfk_2` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_incarichi_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `richieste_immobili_tipologie_incarichi_ibfk_3` FOREIGN KEY (`id_tipologia_founding`) REFERENCES `tipologie_founding` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `richieste_immobili_tipologie_incarichi_view`
--

DROP TABLE IF EXISTS `richieste_immobili_tipologie_incarichi_view`;
/*!50001 DROP VIEW IF EXISTS `richieste_immobili_tipologie_incarichi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `richieste_immobili_tipologie_incarichi_view` (
  `id` tinyint NOT NULL,
  `id_richiesta` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_tipologia_founding` tinyint NOT NULL,
  `prezzo_min` tinyint NOT NULL,
  `prezzo_max` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `richieste_immobili_tipologie_view`
--

DROP TABLE IF EXISTS `richieste_immobili_tipologie_view`;
/*!50001 DROP VIEW IF EXISTS `richieste_immobili_tipologie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `richieste_immobili_tipologie_view` (
  `id` tinyint NOT NULL,
  `id_richiesta` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `se_non_desiderata` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `richieste_immobili_view`
--

DROP TABLE IF EXISTS `richieste_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `richieste_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `richieste_immobili_view` (
  `id` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `piano_min` tinyint NOT NULL,
  `piano_max` tinyint NOT NULL,
  `mq_min` tinyint NOT NULL,
  `mq_max` tinyint NOT NULL,
  `cucine_min` tinyint NOT NULL,
  `cucine_max` tinyint NOT NULL,
  `bagni_min` tinyint NOT NULL,
  `bagni_max` tinyint NOT NULL,
  `camere_min` tinyint NOT NULL,
  `camere_max` tinyint NOT NULL,
  `spese_min` tinyint NOT NULL,
  `spese_max` tinyint NOT NULL,
  `note_richiesta` tinyint NOT NULL,
  `note_interne` tinyint NOT NULL,
  `timestamp_incrocio` tinyint NOT NULL,
  `id_esito` tinyint NOT NULL,
  `timestamp_archiviazione` tinyint NOT NULL,
  `note_archiviazione` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_archiviazione` tinyint NOT NULL,
  `data_inserimento` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `locali` tinyint NOT NULL,
  `tipologia_incarico` tinyint NOT NULL,
  `tipologia_immobile` tinyint NOT NULL,
  `zona` tinyint NOT NULL,
  `mail` tinyint NOT NULL,
  `telefoni` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `incroci` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `richieste_immobili_zone`
--

DROP TABLE IF EXISTS `richieste_immobili_zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `richieste_immobili_zone` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_richiesta` int(11) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_richiesta`,`id_zona`),
  KEY `id_zona` (`id_zona`),
  KEY `id_richiesta` (`id_richiesta`),
  CONSTRAINT `richieste_immobili_zone_ibfk_1` FOREIGN KEY (`id_richiesta`) REFERENCES `richieste_immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `richieste_immobili_zone_ibfk_2` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `richieste_immobili_zone_view`
--

DROP TABLE IF EXISTS `richieste_immobili_zone_view`;
/*!50001 DROP VIEW IF EXISTS `richieste_immobili_zone_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `richieste_immobili_zone_view` (
  `id` tinyint NOT NULL,
  `id_richiesta` tinyint NOT NULL,
  `id_zona` tinyint NOT NULL,
  `se_non_desiderata` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `righe_documenti_amministrativi`
--

DROP TABLE IF EXISTS `righe_documenti_amministrativi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `righe_documenti_amministrativi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_emittente` int(11) DEFAULT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_riferimento` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_pratica` int(11) DEFAULT NULL,
  `id_task` int(11) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_attivita` int(11) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_udm` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `data_lavorazione` date NOT NULL,
  `data_fatturabile` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `id_listino` int(11) DEFAULT NULL,
  `id_valuta` int(11) DEFAULT NULL,
  `id_modalita_pagamento` int(11) DEFAULT NULL,
  `importo_netto_totale` decimal(9,2) NOT NULL,
  `importo_netto_totale_non_scontato` decimal(9,2) DEFAULT NULL,
  `id_iva` int(11) DEFAULT NULL,
  `nome` text,
  `testo` text,
  `path` char(255) DEFAULT NULL,
  `se_rimborso` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_task` (`id_task`),
  KEY `id_attivita` (`id_attivita`),
  KEY `id_udm` (`id_udm`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_valuta` (`id_valuta`),
  KEY `id_iva` (`id_iva`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_emittente` (`id_emittente`),
  KEY `id_listino` (`id_listino`),
  KEY `id_riferimento` (`id_riferimento`),
  KEY `id_documento` (`id_documento`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_pratica` (`id_pratica`),
  KEY `id_todo` (`id_todo`),
  KEY `id_modalita_pagamento` (`id_modalita_pagamento`),
  CONSTRAINT `righe_documenti_amministrativi_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_11` FOREIGN KEY (`id_genitore`) REFERENCES `righe_documenti_amministrativi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_12_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_13_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_14` FOREIGN KEY (`id_riferimento`) REFERENCES `righe_documenti_amministrativi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_15` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_righe_documenti_amministrativi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_16` FOREIGN KEY (`id_pratica`) REFERENCES `pratiche` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_17` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_18` FOREIGN KEY (`id_modalita_pagamento`) REFERENCES `modalita_pagamento` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_1_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_2` FOREIGN KEY (`id_documento`) REFERENCES `documenti_amministrativi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_3` FOREIGN KEY (`id_task`) REFERENCES `task` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_4` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_5_nofollow` FOREIGN KEY (`id_udm`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_6` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_7_nofollow` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_8_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `righe_documenti_amministrativi_ibfk_9_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `righe_documenti_amministrativi_view`
--

DROP TABLE IF EXISTS `righe_documenti_amministrativi_view`;
/*!50001 DROP VIEW IF EXISTS `righe_documenti_amministrativi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `righe_documenti_amministrativi_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_documento` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_emittente` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `id_riferimento` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `id_pratica` tinyint NOT NULL,
  `id_task` tinyint NOT NULL,
  `id_todo` tinyint NOT NULL,
  `id_attivita` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `id_udm` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `quantita` tinyint NOT NULL,
  `data_lavorazione` tinyint NOT NULL,
  `data_fatturabile` tinyint NOT NULL,
  `data_scadenza` tinyint NOT NULL,
  `id_listino` tinyint NOT NULL,
  `id_valuta` tinyint NOT NULL,
  `id_modalita_pagamento` tinyint NOT NULL,
  `importo_netto_totale` tinyint NOT NULL,
  `importo_netto_totale_non_scontato` tinyint NOT NULL,
  `id_iva` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `path` tinyint NOT NULL,
  `se_rimborso` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `numero_aggregate` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `righe_fatturati`
--

DROP TABLE IF EXISTS `righe_fatturati`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `righe_fatturati` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_fatturato` int(11) DEFAULT NULL,
  `id_emittente` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_agente` int(11) NOT NULL,
  `id_mandante` int(11) NOT NULL,
  `mese` int(11) NOT NULL,
  `anno` year(4) NOT NULL,
  `riferimento_fattura` char(32) NOT NULL DEFAULT '-',
  `imponibile` decimal(21,2) NOT NULL,
  `imponibile_provvigionale` decimal(21,2) DEFAULT NULL,
  `provvigione_azienda` decimal(21,2) DEFAULT NULL,
  `provvigione_agente` decimal(21,2) DEFAULT NULL,
  `se_importato` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`anno`,`mese`,`id_mandante`,`id_cliente`,`id_agente`,`id_emittente`,`riferimento_fattura`,`imponibile`),
  KEY `id_fatturato` (`id_fatturato`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `righe_fatturati_view`
--

DROP TABLE IF EXISTS `righe_fatturati_view`;
/*!50001 DROP VIEW IF EXISTS `righe_fatturati_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `righe_fatturati_view` (
  `id` tinyint NOT NULL,
  `id_fatturato` tinyint NOT NULL,
  `id_emittente` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `id_mandante` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `riferimento_fattura` tinyint NOT NULL,
  `imponibile` tinyint NOT NULL,
  `imponibile_provvigionale` tinyint NOT NULL,
  `provvigione_azienda` tinyint NOT NULL,
  `provvigione_agente` tinyint NOT NULL,
  `se_importato` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `emittente` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `mandante` tinyint NOT NULL,
  `nome_mese` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `righe_fatture_view`
--

DROP TABLE IF EXISTS `righe_fatture_view`;
/*!50001 DROP VIEW IF EXISTS `righe_fatture_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `righe_fatture_view` (
  `id` tinyint NOT NULL,
  `data_fatturabile` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `quantita` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_emittente` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `id_documento` tinyint NOT NULL,
  `id_riferimento` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `id_udm` tinyint NOT NULL,
  `data_lavorazione` tinyint NOT NULL,
  `importo_netto_totale` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `emittente` tinyint NOT NULL,
  `fattura` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `udm` tinyint NOT NULL,
  `articolo` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `righe_note_pro_forma_view`
--

DROP TABLE IF EXISTS `righe_note_pro_forma_view`;
/*!50001 DROP VIEW IF EXISTS `righe_note_pro_forma_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `righe_note_pro_forma_view` (
  `id` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_documento` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_emittente` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `id_riferimento` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `id_pratica` tinyint NOT NULL,
  `id_task` tinyint NOT NULL,
  `id_attivita` tinyint NOT NULL,
  `id_articolo` tinyint NOT NULL,
  `id_udm` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `quantita` tinyint NOT NULL,
  `data_lavorazione` tinyint NOT NULL,
  `data_fatturabile` tinyint NOT NULL,
  `data_scadenza` tinyint NOT NULL,
  `id_listino` tinyint NOT NULL,
  `id_valuta` tinyint NOT NULL,
  `importo_netto_totale` tinyint NOT NULL,
  `importo_netto_totale_non_scontato` tinyint NOT NULL,
  `id_iva` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `path` tinyint NOT NULL,
  `se_rimborso` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `importo_netto_totale_label` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `emittente` tinyint NOT NULL,
  `articolo` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `nota_pro_forma` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `udm` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `righe_offerte_view`
--

DROP TABLE IF EXISTS `righe_offerte_view`;
/*!50001 DROP VIEW IF EXISTS `righe_offerte_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `righe_offerte_view` (
  `id` tinyint NOT NULL,
  `data_fatturabile` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `importo_netto_totale` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `offerta` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `risorse`
--

DROP TABLE IF EXISTS `risorse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `risorse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codice` char(6) DEFAULT NULL,
  `data_pubblicazione` date DEFAULT NULL,
  `id_testata` int(11) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_testata` (`id_testata`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `risorse_ibfk_1` FOREIGN KEY (`id_testata`) REFERENCES `testate` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `risorse_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_risorse` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `risorse_ibfk_3` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_risorse` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `risorse_ibfk_4` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `risorse_ibfk_5` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `risorse_anagrafica`
--

DROP TABLE IF EXISTS `risorse_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `risorse_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_risorsa` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_risorsa`,`id_anagrafica`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_risorsa` (`id_risorsa`),
  CONSTRAINT `risorse_anagrafica_ibfk_1` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risorse_anagrafica_ibfk_2` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `risorse_anagrafica_view`
--

DROP TABLE IF EXISTS `risorse_anagrafica_view`;
/*!50001 DROP VIEW IF EXISTS `risorse_anagrafica_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `risorse_anagrafica_view` (
  `id` tinyint NOT NULL,
  `id_risorsa` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `risorse_categorie`
--

DROP TABLE IF EXISTS `risorse_categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `risorse_categorie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_categoria` int(11) NOT NULL,
  `id_risorsa` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_risorsa` (`id_risorsa`),
  CONSTRAINT `risorse_categorie_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risorse_categorie_ibfk_2` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `risorse_categorie_view`
--

DROP TABLE IF EXISTS `risorse_categorie_view`;
/*!50001 DROP VIEW IF EXISTS `risorse_categorie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `risorse_categorie_view` (
  `id` tinyint NOT NULL,
  `id_categoria` tinyint NOT NULL,
  `id_risorsa` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `risorse_view`
--

DROP TABLE IF EXISTS `risorse_view`;
/*!50001 DROP VIEW IF EXISTS `risorse_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `risorse_view` (
  `id` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `id_testata` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_categoria` tinyint NOT NULL,
  `data_pubblicazione` tinyint NOT NULL,
  `testata` tinyint NOT NULL,
  `id_lingua` tinyint NOT NULL,
  `titolo` tinyint NOT NULL,
  `autori` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ruoli_anagrafica`
--

DROP TABLE IF EXISTS `ruoli_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruoli_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `id_genitore` (`id_genitore`),
  CONSTRAINT `ruoli_anagrafica_ibfk_1` FOREIGN KEY (`id_genitore`) REFERENCES `anagrafica_ruoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `ruoli_anagrafica_view`
--

DROP TABLE IF EXISTS `ruoli_anagrafica_view`;
/*!50001 DROP VIEW IF EXISTS `ruoli_anagrafica_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ruoli_anagrafica_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ruoli_audio`
--

DROP TABLE IF EXISTS `ruoli_audio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruoli_audio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_anagrafica` int(1) DEFAULT NULL,
  `se_contenuti` int(1) DEFAULT NULL,
  `se_categorie_prodotti` int(1) DEFAULT NULL,
  `se_prodotti` int(1) DEFAULT NULL,
  `se_articoli` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `ruoli_audio_view`
--

DROP TABLE IF EXISTS `ruoli_audio_view`;
/*!50001 DROP VIEW IF EXISTS `ruoli_audio_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ruoli_audio_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_anagrafica` tinyint NOT NULL,
  `se_contenuti` tinyint NOT NULL,
  `se_categorie_prodotti` tinyint NOT NULL,
  `se_prodotti` tinyint NOT NULL,
  `se_articoli` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ruoli_eventi`
--

DROP TABLE IF EXISTS `ruoli_eventi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruoli_eventi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(128) NOT NULL,
  `locandina` char(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `ruoli_eventi_view`
--

DROP TABLE IF EXISTS `ruoli_eventi_view`;
/*!50001 DROP VIEW IF EXISTS `ruoli_eventi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ruoli_eventi_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `locandina` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ruoli_file`
--

DROP TABLE IF EXISTS `ruoli_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruoli_file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_anagrafica` int(1) DEFAULT NULL,
  `se_contenuti` int(1) DEFAULT NULL,
  `se_categorie_prodotti` int(1) DEFAULT NULL,
  `se_mail` int(1) DEFAULT NULL,
  `se_prodotti` int(1) DEFAULT NULL,
  `se_articoli` int(11) DEFAULT NULL,
  `se_certificazioni` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`),
  KEY `se_certificazioni` (`se_certificazioni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `ruoli_file_view`
--

DROP TABLE IF EXISTS `ruoli_file_view`;
/*!50001 DROP VIEW IF EXISTS `ruoli_file_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ruoli_file_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_anagrafica` tinyint NOT NULL,
  `se_contenuti` tinyint NOT NULL,
  `se_categorie_prodotti` tinyint NOT NULL,
  `se_mail` tinyint NOT NULL,
  `se_prodotti` tinyint NOT NULL,
  `se_articoli` tinyint NOT NULL,
  `se_certificazioni` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ruoli_immagini`
--

DROP TABLE IF EXISTS `ruoli_immagini`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruoli_immagini` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_contenuti` int(1) DEFAULT NULL,
  `se_anagrafica` int(1) DEFAULT NULL,
  `se_immobili` int(1) DEFAULT NULL,
  `se_catalogo` int(1) DEFAULT NULL,
  `se_prodotti` int(1) DEFAULT NULL,
  `ordine_scalamento` int(11) DEFAULT NULL,
  `se_categorie_prodotti` int(1) DEFAULT NULL,
  `se_articoli` int(11) DEFAULT NULL,
  `se_certificazioni` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`,`ordine_scalamento`),
  KEY `se_certificazioni` (`se_certificazioni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ruoli_immagini_anagrafica`
--

DROP TABLE IF EXISTS `ruoli_immagini_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruoli_immagini_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `ruoli_immagini_anagrafica_view`
--

DROP TABLE IF EXISTS `ruoli_immagini_anagrafica_view`;
/*!50001 DROP VIEW IF EXISTS `ruoli_immagini_anagrafica_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ruoli_immagini_anagrafica_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `ruoli_immagini_view`
--

DROP TABLE IF EXISTS `ruoli_immagini_view`;
/*!50001 DROP VIEW IF EXISTS `ruoli_immagini_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ruoli_immagini_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_contenuti` tinyint NOT NULL,
  `se_anagrafica` tinyint NOT NULL,
  `se_immobili` tinyint NOT NULL,
  `se_catalogo` tinyint NOT NULL,
  `se_prodotti` tinyint NOT NULL,
  `ordine_scalamento` tinyint NOT NULL,
  `se_categorie_prodotti` tinyint NOT NULL,
  `se_articoli` tinyint NOT NULL,
  `se_certificazioni` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ruoli_immobili_anagrafica`
--

DROP TABLE IF EXISTS `ruoli_immobili_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruoli_immobili_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `ruoli_immobili_anagrafica_view`
--

DROP TABLE IF EXISTS `ruoli_immobili_anagrafica_view`;
/*!50001 DROP VIEW IF EXISTS `ruoli_immobili_anagrafica_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ruoli_immobili_anagrafica_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ruoli_prodotti_categorie`
--

DROP TABLE IF EXISTS `ruoli_prodotti_categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruoli_prodotti_categorie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  `se_bestseller` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `ruoli_prodotti_categorie_view`
--

DROP TABLE IF EXISTS `ruoli_prodotti_categorie_view`;
/*!50001 DROP VIEW IF EXISTS `ruoli_prodotti_categorie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ruoli_prodotti_categorie_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_bestseller` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ruoli_progetti`
--

DROP TABLE IF EXISTS `ruoli_progetti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruoli_progetti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) NOT NULL,
  `se_responsabile_qualita` int(1) DEFAULT NULL,
  `se_responsabile_acquisti` int(1) DEFAULT NULL,
  `se_coordinatore` int(1) DEFAULT NULL,
  `se_responsabile_amministrativo` int(1) DEFAULT NULL,
  `se_responsabile_servizi` int(1) DEFAULT NULL,
  `se_operativo` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_responsabile_qualita` (`se_responsabile_qualita`),
  KEY `se_coordinatore` (`se_coordinatore`),
  KEY `se_responsabile_amministrativo` (`se_responsabile_amministrativo`),
  KEY `se_responsabile_servizi` (`se_responsabile_servizi`),
  KEY `se_operativo` (`se_operativo`),
  KEY `se_responsabile_acquisti` (`se_responsabile_acquisti`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `ruoli_progetti_view`
--

DROP TABLE IF EXISTS `ruoli_progetti_view`;
/*!50001 DROP VIEW IF EXISTS `ruoli_progetti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ruoli_progetti_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_responsabile_qualita` tinyint NOT NULL,
  `se_responsabile_acquisti` tinyint NOT NULL,
  `se_coordinatore` tinyint NOT NULL,
  `se_responsabile_amministrativo` tinyint NOT NULL,
  `se_responsabile_servizi` tinyint NOT NULL,
  `se_operativo` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ruoli_rassegna_stampa`
--

DROP TABLE IF EXISTS `ruoli_rassegna_stampa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruoli_rassegna_stampa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `ruoli_rassegna_stampa_view`
--

DROP TABLE IF EXISTS `ruoli_rassegna_stampa_view`;
/*!50001 DROP VIEW IF EXISTS `ruoli_rassegna_stampa_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ruoli_rassegna_stampa_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ruoli_video`
--

DROP TABLE IF EXISTS `ruoli_video`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruoli_video` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_anagrafica` int(1) DEFAULT NULL,
  `se_contenuti` int(1) DEFAULT NULL,
  `se_categorie_prodotti` int(1) DEFAULT NULL,
  `se_prodotti` int(1) DEFAULT NULL,
  `se_articoli` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `ruoli_video_view`
--

DROP TABLE IF EXISTS `ruoli_video_view`;
/*!50001 DROP VIEW IF EXISTS `ruoli_video_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ruoli_video_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_anagrafica` tinyint NOT NULL,
  `se_contenuti` tinyint NOT NULL,
  `se_categorie_prodotti` tinyint NOT NULL,
  `se_prodotti` tinyint NOT NULL,
  `se_articoli` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `scadenze`
--

DROP TABLE IF EXISTS `scadenze`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scadenze` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_documento` int(11) DEFAULT NULL,
  `id_pratica` int(11) DEFAULT NULL,
  `data` date NOT NULL,
  `id_modalita_pagamento` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `importo_lordo_totale` decimal(9,2) DEFAULT NULL,
  `se_pagato` int(1) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `scadenza_documento_unico` (`id_documento`,`data`,`id_modalita_pagamento`),
  KEY `id_modalita_pagamento` (`id_modalita_pagamento`),
  KEY `id_documento` (`id_documento`),
  KEY `id_pratica` (`id_pratica`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `scadenze_ibfk_1` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `scadenze_ibfk_1_nofollow` FOREIGN KEY (`id_modalita_pagamento`) REFERENCES `modalita_pagamento` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `scadenze_ibfk_2` FOREIGN KEY (`id_pratica`) REFERENCES `pratiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `scadenze_ibfk_2_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `scadenze_ibfk_3_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `scadenze_view`
--

DROP TABLE IF EXISTS `scadenze_view`;
/*!50001 DROP VIEW IF EXISTS `scadenze_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `scadenze_view` (
  `id` tinyint NOT NULL,
  `id_documento` tinyint NOT NULL,
  `id_pratica` tinyint NOT NULL,
  `data` tinyint NOT NULL,
  `id_modalita_pagamento` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `importo_lordo_totale` tinyint NOT NULL,
  `se_pagato` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `settori`
--

DROP TABLE IF EXISTS `settori`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settori` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `ateco` char(32) DEFAULT NULL,
  `nome` char(128) NOT NULL,
  `soprannome` char(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ateco` (`ateco`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id` (`id`,`id_genitore`,`nome`),
  CONSTRAINT `settori_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `settori` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `settori_view`
--

DROP TABLE IF EXISTS `settori_view`;
/*!50001 DROP VIEW IF EXISTS `settori_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `settori_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `sms_out`
--

DROP TABLE IF EXISTS `sms_out`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sms_out` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp_composizione` int(11) NOT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `corpo` text NOT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `id_newsletter` int(11) DEFAULT NULL,
  `id_telefono` int(11) DEFAULT NULL,
  `token` char(254) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `timestamp_composizione` (`timestamp_composizione`),
  KEY `timestamp_invio` (`timestamp_invio`),
  KEY `id_newsletter` (`id_newsletter`),
  KEY `id_telefono` (`id_telefono`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`timestamp_composizione`,`timestamp_invio`,`id_newsletter`,`id_telefono`),
  KEY `token` (`token`),
  CONSTRAINT `sms_out_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `sms_out_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `sms_out_view`
--

DROP TABLE IF EXISTS `sms_out_view`;
/*!50001 DROP VIEW IF EXISTS `sms_out_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `sms_out_view` (
  `id` tinyint NOT NULL,
  `timestamp_composizione` tinyint NOT NULL,
  `timestamp_invio` tinyint NOT NULL,
  `server` tinyint NOT NULL,
  `mittente` tinyint NOT NULL,
  `destinatari` tinyint NOT NULL,
  `corpo` tinyint NOT NULL,
  `host` tinyint NOT NULL,
  `port` tinyint NOT NULL,
  `user` tinyint NOT NULL,
  `password` tinyint NOT NULL,
  `id_newsletter` tinyint NOT NULL,
  `id_telefono` tinyint NOT NULL,
  `token` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_ora_invio` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `sms_sent`
--

DROP TABLE IF EXISTS `sms_sent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sms_sent` (
  `id` int(11) NOT NULL,
  `timestamp_composizione` int(11) NOT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `corpo` text NOT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `id_newsletter` int(11) DEFAULT NULL,
  `id_telefono` int(11) DEFAULT NULL,
  `token` char(254) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `timestamp_composizione` (`timestamp_composizione`),
  KEY `timestamp_invio` (`timestamp_invio`),
  KEY `id_newsletter` (`id_newsletter`),
  KEY `id_telefono` (`id_telefono`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`timestamp_composizione`,`timestamp_invio`,`id_newsletter`,`id_telefono`),
  KEY `token` (`token`),
  CONSTRAINT `sms_sent_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `sms_sent_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `sms_sent_view`
--

DROP TABLE IF EXISTS `sms_sent_view`;
/*!50001 DROP VIEW IF EXISTS `sms_sent_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `sms_sent_view` (
  `id` tinyint NOT NULL,
  `timestamp_composizione` tinyint NOT NULL,
  `timestamp_invio` tinyint NOT NULL,
  `server` tinyint NOT NULL,
  `mittente` tinyint NOT NULL,
  `destinatari` tinyint NOT NULL,
  `corpo` tinyint NOT NULL,
  `host` tinyint NOT NULL,
  `port` tinyint NOT NULL,
  `user` tinyint NOT NULL,
  `password` tinyint NOT NULL,
  `id_newsletter` tinyint NOT NULL,
  `id_telefono` tinyint NOT NULL,
  `token` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_ora_invio` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `sostituzioni_attivita`
--

DROP TABLE IF EXISTS `sostituzioni_attivita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sostituzioni_attivita` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_attivita` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_richiesta` date NOT NULL,
  `data_accettazione` date DEFAULT NULL,
  `data_rifiuto` date DEFAULT NULL,
  `data_scarto` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_attivita`,`id_anagrafica`,`data_richiesta`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_attivita` (`id_attivita`),
  KEY `data_scarto` (`data_scarto`),
  CONSTRAINT `sostituzioni_attivita_ibfk_1_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sostituzioni_attivita_ibfk_2_nofollow` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `sostituzioni_attivita_view`
--

DROP TABLE IF EXISTS `sostituzioni_attivita_view`;
/*!50001 DROP VIEW IF EXISTS `sostituzioni_attivita_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `sostituzioni_attivita_view` (
  `id` tinyint NOT NULL,
  `id_attivita` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `data_richiesta` tinyint NOT NULL,
  `data_accettazione` tinyint NOT NULL,
  `data_rifiuto` tinyint NOT NULL,
  `data_scarto` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `attivita` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `data_programmazione` tinyint NOT NULL,
  `accettata` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `sostituzioni_progetti`
--

DROP TABLE IF EXISTS `sostituzioni_progetti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sostituzioni_progetti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_progetto` char(32) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_scopertura` date NOT NULL,
  `data_scarto` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_progetto`,`id_anagrafica`,`data_scopertura`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_anagrafica` (`id_anagrafica`),
  CONSTRAINT `sostituzioni_progetti_ibfk_1_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sostituzioni_progetti_ibfk_2_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `sostituzioni_progetti_view`
--

DROP TABLE IF EXISTS `sostituzioni_progetti_view`;
/*!50001 DROP VIEW IF EXISTS `sostituzioni_progetti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `sostituzioni_progetti_view` (
  `id` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `data_scopertura` tinyint NOT NULL,
  `data_scarto` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `stagioni_prodotti`
--

DROP TABLE IF EXISTS `stagioni_prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stagioni_prodotti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `new` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `stagioni_prodotti_view`
--

DROP TABLE IF EXISTS `stagioni_prodotti_view`;
/*!50001 DROP VIEW IF EXISTS `stagioni_prodotti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `stagioni_prodotti_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `new` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `stati`
--

DROP TABLE IF EXISTS `stati`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stati` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_continente` int(11) DEFAULT NULL,
  `iso31661alpha2` char(2) DEFAULT NULL,
  `iso31661alpha3` char(3) DEFAULT NULL,
  `nome` char(128) NOT NULL,
  `note` char(128) DEFAULT NULL,
  `codice_istat` char(4) DEFAULT NULL,
  `data_cessazione` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_continente` (`id_continente`),
  KEY `indice` (`id`,`id_continente`,`iso31661alpha2`,`iso31661alpha3`,`nome`),
  CONSTRAINT `stati_ibfk_1_nofollow` FOREIGN KEY (`id_continente`) REFERENCES `continenti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stati_lingue`
--

DROP TABLE IF EXISTS `stati_lingue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stati_lingue` (
  `id_stato` int(11) NOT NULL,
  `id_lingua` int(11) NOT NULL,
  PRIMARY KEY (`id_stato`,`id_lingua`),
  KEY `id_lingua` (`id_lingua`),
  CONSTRAINT `stati_lingue_ibfk_1_nofollow` FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `stati_lingue_ibfk_2_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `stati_view`
--

DROP TABLE IF EXISTS `stati_view`;
/*!50001 DROP VIEW IF EXISTS `stati_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `stati_view` (
  `id` tinyint NOT NULL,
  `id_continente` tinyint NOT NULL,
  `iso31661alpha2` tinyint NOT NULL,
  `iso31661alpha3` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `codice_istat` tinyint NOT NULL,
  `data_cessazione` tinyint NOT NULL,
  `continente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `strategie`
--

DROP TABLE IF EXISTS `strategie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `strategie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(128) NOT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `obiettivo` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `strategie_ibfk_1` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_obiettivi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `strategie_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `strategie_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `strategie_view`
--

DROP TABLE IF EXISTS `strategie_view`;
/*!50001 DROP VIEW IF EXISTS `strategie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `strategie_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `obiettivo` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `sviluppi_immobili_archivio_view`
--

DROP TABLE IF EXISTS `sviluppi_immobili_archivio_view`;
/*!50001 DROP VIEW IF EXISTS `sviluppi_immobili_archivio_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `sviluppi_immobili_archivio_view` (
  `id` tinyint NOT NULL,
  `riferimento` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `indirizzo_sostituzione` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `data_notizia` tinyint NOT NULL,
  `data_sviluppo` tinyint NOT NULL,
  `data_valutazione` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `prezzo_richiesto` tinyint NOT NULL,
  `prezzo_mq` tinyint NOT NULL,
  `prezzo_valutazione` tinyint NOT NULL,
  `prezzo_incarico` tinyint NOT NULL,
  `percentuale_intervallo` tinyint NOT NULL,
  `prezzo_prefisso` tinyint NOT NULL,
  `prezzo` tinyint NOT NULL,
  `prezzo_suffisso` tinyint NOT NULL,
  `prezzo_sostituzione` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `timestamp_incrocio` tinyint NOT NULL,
  `id_esito_incarico` tinyint NOT NULL,
  `id_esito_notizia` tinyint NOT NULL,
  `timestamp_archiviazione` tinyint NOT NULL,
  `note_archiviazione` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_archiviazione` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `latitudine` tinyint NOT NULL,
  `longitudine` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `scala` tinyint NOT NULL,
  `piano` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `sviluppi_immobili_view`
--

DROP TABLE IF EXISTS `sviluppi_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `sviluppi_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `sviluppi_immobili_view` (
  `id` tinyint NOT NULL,
  `riferimento` tinyint NOT NULL,
  `id_immobile` tinyint NOT NULL,
  `indirizzo_sostituzione` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `id_agenzia` tinyint NOT NULL,
  `id_agente` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `data_notizia` tinyint NOT NULL,
  `data_sviluppo` tinyint NOT NULL,
  `data_valutazione` tinyint NOT NULL,
  `data_inizio` tinyint NOT NULL,
  `data_fine` tinyint NOT NULL,
  `prezzo_richiesto` tinyint NOT NULL,
  `prezzo_mq` tinyint NOT NULL,
  `prezzo_valutazione` tinyint NOT NULL,
  `prezzo_incarico` tinyint NOT NULL,
  `percentuale_intervallo` tinyint NOT NULL,
  `prezzo_prefisso` tinyint NOT NULL,
  `prezzo` tinyint NOT NULL,
  `prezzo_suffisso` tinyint NOT NULL,
  `prezzo_sostituzione` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `timestamp_incrocio` tinyint NOT NULL,
  `id_esito_incarico` tinyint NOT NULL,
  `id_esito_notizia` tinyint NOT NULL,
  `timestamp_archiviazione` tinyint NOT NULL,
  `note_archiviazione` tinyint NOT NULL,
  `id_account_editor` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `data_archiviazione` tinyint NOT NULL,
  `indirizzo` tinyint NOT NULL,
  `latitudine` tinyint NOT NULL,
  `longitudine` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `scala` tinyint NOT NULL,
  `piano` tinyint NOT NULL,
  `interno` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `agente` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `taglie`
--

DROP TABLE IF EXISTS `taglie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taglie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `it` char(8) NOT NULL,
  `eu` char(8) DEFAULT NULL,
  `us` char(8) DEFAULT NULL,
  `uk` char(8) DEFAULT NULL,
  `fr` char(8) DEFAULT NULL,
  `international` char(8) DEFAULT NULL,
  `jeans` char(8) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `cm` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `taglia_unica` (`it`,`us`,`uk`,`fr`),
  KEY `id_tipologia` (`id_tipologia`),
  CONSTRAINT `taglie_ibfk_1` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_taglie` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `taglie_view`
--

DROP TABLE IF EXISTS `taglie_view`;
/*!50001 DROP VIEW IF EXISTS `taglie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `taglie_view` (
  `id` tinyint NOT NULL,
  `it` tinyint NOT NULL,
  `eu` tinyint NOT NULL,
  `us` tinyint NOT NULL,
  `uk` tinyint NOT NULL,
  `fr` tinyint NOT NULL,
  `international` tinyint NOT NULL,
  `jeans` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `cm` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tari_anagrafica`
--

DROP TABLE IF EXISTS `tari_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tari_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `anno` year(4) NOT NULL,
  `se_verificato` int(1) DEFAULT NULL,
  `data_verifica` date DEFAULT NULL,
  `id_operatore_verifica` int(11) DEFAULT NULL,
  `note_verifica` text,
  `se_gestito` int(1) DEFAULT NULL,
  `data_gestione` date DEFAULT NULL,
  `id_operatore_gestione` int(11) DEFAULT NULL,
  `note_gestione` text,
  `se_convocato` int(1) DEFAULT NULL,
  `data_convocazione` date DEFAULT NULL,
  `id_operatore_convocazione` int(11) DEFAULT NULL,
  `note_convocazione` text,
  `se_confermato` int(1) DEFAULT NULL,
  `data_conferma` date DEFAULT NULL,
  `id_operatore_conferma` int(11) DEFAULT NULL,
  `note_conferma` text,
  `data_aggiornamento` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `anagrafica_unico` (`id_anagrafica`,`anno`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_operatore_conferma` (`id_operatore_conferma`),
  KEY `id_operatore_gestione` (`id_operatore_gestione`),
  KEY `id_operatore_verifica` (`id_operatore_verifica`),
  KEY `id_operatore_convocazione` (`id_operatore_convocazione`),
  CONSTRAINT `tari_anagrafica_ibfk_1` FOREIGN KEY (`id_operatore_verifica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tari_anagrafica_ibfk_1_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tari_anagrafica_ibfk_2` FOREIGN KEY (`id_operatore_gestione`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tari_anagrafica_ibfk_3` FOREIGN KEY (`id_operatore_convocazione`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tari_anagrafica_ibfk_4` FOREIGN KEY (`id_operatore_conferma`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tari_anagrafica_archiviati_view`
--

DROP TABLE IF EXISTS `tari_anagrafica_archiviati_view`;
/*!50001 DROP VIEW IF EXISTS `tari_anagrafica_archiviati_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tari_anagrafica_archiviati_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `se_verificato` tinyint NOT NULL,
  `data_verifica` tinyint NOT NULL,
  `id_operatore_verifica` tinyint NOT NULL,
  `note_verifica` tinyint NOT NULL,
  `se_gestito` tinyint NOT NULL,
  `data_gestione` tinyint NOT NULL,
  `id_operatore_gestione` tinyint NOT NULL,
  `note_gestione` tinyint NOT NULL,
  `se_convocato` tinyint NOT NULL,
  `data_convocazione` tinyint NOT NULL,
  `id_operatore_convocazione` tinyint NOT NULL,
  `note_convocazione` tinyint NOT NULL,
  `se_confermato` tinyint NOT NULL,
  `data_conferma` tinyint NOT NULL,
  `id_operatore_conferma` tinyint NOT NULL,
  `note_conferma` tinyint NOT NULL,
  `data_aggiornamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `motivazioni` tinyint NOT NULL,
  `peso` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `tari_anagrafica_convocati_view`
--

DROP TABLE IF EXISTS `tari_anagrafica_convocati_view`;
/*!50001 DROP VIEW IF EXISTS `tari_anagrafica_convocati_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tari_anagrafica_convocati_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `se_verificato` tinyint NOT NULL,
  `data_verifica` tinyint NOT NULL,
  `id_operatore_verifica` tinyint NOT NULL,
  `note_verifica` tinyint NOT NULL,
  `se_gestito` tinyint NOT NULL,
  `data_gestione` tinyint NOT NULL,
  `id_operatore_gestione` tinyint NOT NULL,
  `note_gestione` tinyint NOT NULL,
  `se_convocato` tinyint NOT NULL,
  `data_convocazione` tinyint NOT NULL,
  `id_operatore_convocazione` tinyint NOT NULL,
  `note_convocazione` tinyint NOT NULL,
  `se_confermato` tinyint NOT NULL,
  `data_conferma` tinyint NOT NULL,
  `id_operatore_conferma` tinyint NOT NULL,
  `note_conferma` tinyint NOT NULL,
  `data_aggiornamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `motivazioni` tinyint NOT NULL,
  `peso` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `tari_anagrafica_da_convocare_view`
--

DROP TABLE IF EXISTS `tari_anagrafica_da_convocare_view`;
/*!50001 DROP VIEW IF EXISTS `tari_anagrafica_da_convocare_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tari_anagrafica_da_convocare_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `se_verificato` tinyint NOT NULL,
  `data_verifica` tinyint NOT NULL,
  `id_operatore_verifica` tinyint NOT NULL,
  `note_verifica` tinyint NOT NULL,
  `se_gestito` tinyint NOT NULL,
  `data_gestione` tinyint NOT NULL,
  `id_operatore_gestione` tinyint NOT NULL,
  `note_gestione` tinyint NOT NULL,
  `se_convocato` tinyint NOT NULL,
  `data_convocazione` tinyint NOT NULL,
  `id_operatore_convocazione` tinyint NOT NULL,
  `note_convocazione` tinyint NOT NULL,
  `se_confermato` tinyint NOT NULL,
  `data_conferma` tinyint NOT NULL,
  `id_operatore_conferma` tinyint NOT NULL,
  `note_conferma` tinyint NOT NULL,
  `data_aggiornamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `motivazioni` tinyint NOT NULL,
  `peso` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `tari_anagrafica_da_gestire_view`
--

DROP TABLE IF EXISTS `tari_anagrafica_da_gestire_view`;
/*!50001 DROP VIEW IF EXISTS `tari_anagrafica_da_gestire_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tari_anagrafica_da_gestire_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `se_verificato` tinyint NOT NULL,
  `data_verifica` tinyint NOT NULL,
  `id_operatore_verifica` tinyint NOT NULL,
  `note_verifica` tinyint NOT NULL,
  `se_gestito` tinyint NOT NULL,
  `data_gestione` tinyint NOT NULL,
  `id_operatore_gestione` tinyint NOT NULL,
  `note_gestione` tinyint NOT NULL,
  `se_convocato` tinyint NOT NULL,
  `data_convocazione` tinyint NOT NULL,
  `id_operatore_convocazione` tinyint NOT NULL,
  `note_convocazione` tinyint NOT NULL,
  `se_confermato` tinyint NOT NULL,
  `data_conferma` tinyint NOT NULL,
  `id_operatore_conferma` tinyint NOT NULL,
  `note_conferma` tinyint NOT NULL,
  `data_aggiornamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `motivazioni` tinyint NOT NULL,
  `peso` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `tari_anagrafica_da_verificare_view`
--

DROP TABLE IF EXISTS `tari_anagrafica_da_verificare_view`;
/*!50001 DROP VIEW IF EXISTS `tari_anagrafica_da_verificare_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tari_anagrafica_da_verificare_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `se_verificato` tinyint NOT NULL,
  `data_verifica` tinyint NOT NULL,
  `id_operatore_verifica` tinyint NOT NULL,
  `note_verifica` tinyint NOT NULL,
  `se_gestito` tinyint NOT NULL,
  `data_gestione` tinyint NOT NULL,
  `id_operatore_gestione` tinyint NOT NULL,
  `note_gestione` tinyint NOT NULL,
  `se_convocato` tinyint NOT NULL,
  `data_convocazione` tinyint NOT NULL,
  `id_operatore_convocazione` tinyint NOT NULL,
  `note_convocazione` tinyint NOT NULL,
  `se_confermato` tinyint NOT NULL,
  `data_conferma` tinyint NOT NULL,
  `id_operatore_conferma` tinyint NOT NULL,
  `note_conferma` tinyint NOT NULL,
  `data_aggiornamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `motivazioni` tinyint NOT NULL,
  `peso` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `tari_anagrafica_esportazione_view`
--

DROP TABLE IF EXISTS `tari_anagrafica_esportazione_view`;
/*!50001 DROP VIEW IF EXISTS `tari_anagrafica_esportazione_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tari_anagrafica_esportazione_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `se_verificato` tinyint NOT NULL,
  `data_verifica` tinyint NOT NULL,
  `id_operatore_verifica` tinyint NOT NULL,
  `note_verifica` tinyint NOT NULL,
  `se_gestito` tinyint NOT NULL,
  `data_gestione` tinyint NOT NULL,
  `id_operatore_gestione` tinyint NOT NULL,
  `note_gestione` tinyint NOT NULL,
  `se_convocato` tinyint NOT NULL,
  `data_convocazione` tinyint NOT NULL,
  `id_operatore_convocazione` tinyint NOT NULL,
  `note_convocazione` tinyint NOT NULL,
  `se_confermato` tinyint NOT NULL,
  `data_conferma` tinyint NOT NULL,
  `id_operatore_conferma` tinyint NOT NULL,
  `note_conferma` tinyint NOT NULL,
  `data_aggiornamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `motivazioni` tinyint NOT NULL,
  `peso` tinyint NOT NULL,
  `id_motivazione` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `riga_provenienza` tinyint NOT NULL,
  `nome` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `tari_anagrafica_ruolo_tari_view`
--

DROP TABLE IF EXISTS `tari_anagrafica_ruolo_tari_view`;
/*!50001 DROP VIEW IF EXISTS `tari_anagrafica_ruolo_tari_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tari_anagrafica_ruolo_tari_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `se_verificato` tinyint NOT NULL,
  `data_verifica` tinyint NOT NULL,
  `id_operatore_verifica` tinyint NOT NULL,
  `note_verifica` tinyint NOT NULL,
  `se_gestito` tinyint NOT NULL,
  `data_gestione` tinyint NOT NULL,
  `id_operatore_gestione` tinyint NOT NULL,
  `note_gestione` tinyint NOT NULL,
  `se_convocato` tinyint NOT NULL,
  `data_convocazione` tinyint NOT NULL,
  `id_operatore_convocazione` tinyint NOT NULL,
  `note_convocazione` tinyint NOT NULL,
  `se_confermato` tinyint NOT NULL,
  `data_conferma` tinyint NOT NULL,
  `id_operatore_conferma` tinyint NOT NULL,
  `note_conferma` tinyint NOT NULL,
  `data_aggiornamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `motivazioni` tinyint NOT NULL,
  `peso` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `tari_anagrafica_view`
--

DROP TABLE IF EXISTS `tari_anagrafica_view`;
/*!50001 DROP VIEW IF EXISTS `tari_anagrafica_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tari_anagrafica_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `se_verificato` tinyint NOT NULL,
  `data_verifica` tinyint NOT NULL,
  `id_operatore_verifica` tinyint NOT NULL,
  `note_verifica` tinyint NOT NULL,
  `se_gestito` tinyint NOT NULL,
  `data_gestione` tinyint NOT NULL,
  `id_operatore_gestione` tinyint NOT NULL,
  `note_gestione` tinyint NOT NULL,
  `se_convocato` tinyint NOT NULL,
  `data_convocazione` tinyint NOT NULL,
  `id_operatore_convocazione` tinyint NOT NULL,
  `note_convocazione` tinyint NOT NULL,
  `se_confermato` tinyint NOT NULL,
  `data_conferma` tinyint NOT NULL,
  `id_operatore_conferma` tinyint NOT NULL,
  `note_conferma` tinyint NOT NULL,
  `data_aggiornamento` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `codice_fiscale` tinyint NOT NULL,
  `anagrafica` tinyint NOT NULL,
  `__label__` tinyint NOT NULL,
  `motivazioni` tinyint NOT NULL,
  `peso` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_priorita` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `testo` text,
  `ore_previste` decimal(5,2) DEFAULT NULL,
  `testo_ore_previste` text,
  `anno_previsto` year(4) DEFAULT NULL,
  `settimana_prevista` int(11) DEFAULT NULL,
  `testo_pianificazione` text,
  `id_responsabile` int(11) DEFAULT NULL,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `timestamp_pianificazione` int(11) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `timestamp_revisione` int(11) DEFAULT NULL,
  `note_revisione` text,
  `timestamp_completamento` int(11) DEFAULT NULL,
  `testo_completamento` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) NOT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_priorita` (`id_priorita`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_responsabile` (`id_responsabile`),
  KEY `id_luogo` (`id_luogo`),
  CONSTRAINT `task_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `task_ibfk_1_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `task_ibfk_2_nofollow` FOREIGN KEY (`id_priorita`) REFERENCES `priorita` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `task_ibfk_3_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_task` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `task_ibfk_4_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `task_ibfk_5_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `task_ibfk_6_nofollow` FOREIGN KEY (`id_responsabile`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `task_ibfk_7_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `task_ibfk_8_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `task_view`
--

DROP TABLE IF EXISTS `task_view`;
/*!50001 DROP VIEW IF EXISTS `task_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `task_view` (
  `id` tinyint NOT NULL,
  `data_ora_apertura` tinyint NOT NULL,
  `data_ora_pianificazione` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `mese` tinyint NOT NULL,
  `anno` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `luogo` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `crm` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `priorita` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_luogo` tinyint NOT NULL,
  `id_priorita` tinyint NOT NULL,
  `ore_previste` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `anno_previsto` tinyint NOT NULL,
  `settimana_prevista` tinyint NOT NULL,
  `timestamp_pianificazione` tinyint NOT NULL,
  `pianificazione` tinyint NOT NULL,
  `ore_lavorate` tinyint NOT NULL,
  `ore_residue` tinyint NOT NULL,
  `id_responsabile` tinyint NOT NULL,
  `responsabile` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `avanzamento` tinyint NOT NULL,
  `progresso` tinyint NOT NULL,
  `timestamp_completamento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `timestamp_revisione` tinyint NOT NULL,
  `data_ora_completamento` tinyint NOT NULL,
  `completato` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `telefoni`
--

DROP TABLE IF EXISTS `telefoni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `telefoni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int(11) NOT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `se_notifiche` tinyint(1) DEFAULT NULL,
  `numero` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `descrizione` char(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id_anagrafica`,`numero`,`id_tipologia`),
  KEY `numero` (`numero`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_indirizzo` (`id_indirizzo`),
  CONSTRAINT `telefoni_ibfk_1` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `telefoni_ibfk_1_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_telefoni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `telefoni_ibfk_2_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `telefoni_view`
--

DROP TABLE IF EXISTS `telefoni_view`;
/*!50001 DROP VIEW IF EXISTS `telefoni_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `telefoni_view` (
  `id` tinyint NOT NULL,
  `id_anagrafica` tinyint NOT NULL,
  `id_indirizzo` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `se_notifiche` tinyint NOT NULL,
  `numero` tinyint NOT NULL,
  `descrizione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `template_mail`
--

DROP TABLE IF EXISTS `template_mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `template_mail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ruolo` char(32) NOT NULL,
  `nome` char(128) NOT NULL,
  `type` char(32) NOT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `template_mail_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `template_mail_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `template_mail_view`
--

DROP TABLE IF EXISTS `template_mail_view`;
/*!50001 DROP VIEW IF EXISTS `template_mail_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `template_mail_view` (
  `id` tinyint NOT NULL,
  `ruolo` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `type` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test` (
  `id` int(11) NOT NULL,
  `nome` char(64) DEFAULT NULL,
  `codice` char(16) DEFAULT NULL,
  `mail` char(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_patch`
--

DROP TABLE IF EXISTS `test_patch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_patch` (
  `id` int(11) NOT NULL,
  `patch` char(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `testate`
--

DROP TABLE IF EXISTS `testate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `testate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `testate_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `testate_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `testate_view`
--

DROP TABLE IF EXISTS `testate_view`;
/*!50001 DROP VIEW IF EXISTS `testate_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `testate_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `ticket_archivio_view`
--

DROP TABLE IF EXISTS `ticket_archivio_view`;
/*!50001 DROP VIEW IF EXISTS `ticket_archivio_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ticket_archivio_view` (
  `id` tinyint NOT NULL,
  `data_ora_apertura` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `id_priorita` tinyint NOT NULL,
  `priorita` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `data_apertura` tinyint NOT NULL,
  `id_responsabile` tinyint NOT NULL,
  `responsabile` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `timestamp_completamento` tinyint NOT NULL,
  `testo_completamento` tinyint NOT NULL,
  `data_ora_completamento` tinyint NOT NULL,
  `completato` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `ticket_lavoro_view`
--

DROP TABLE IF EXISTS `ticket_lavoro_view`;
/*!50001 DROP VIEW IF EXISTS `ticket_lavoro_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ticket_lavoro_view` (
  `id` tinyint NOT NULL,
  `data_ora_apertura` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `id_priorita` tinyint NOT NULL,
  `priorita` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `data_apertura` tinyint NOT NULL,
  `id_responsabile` tinyint NOT NULL,
  `responsabile` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `timestamp_completamento` tinyint NOT NULL,
  `testo_completamento` tinyint NOT NULL,
  `data_ora_completamento` tinyint NOT NULL,
  `completato` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `ticket_view`
--

DROP TABLE IF EXISTS `ticket_view`;
/*!50001 DROP VIEW IF EXISTS `ticket_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ticket_view` (
  `id` tinyint NOT NULL,
  `data_ora_apertura` tinyint NOT NULL,
  `id_cliente` tinyint NOT NULL,
  `cliente` tinyint NOT NULL,
  `id_progetto` tinyint NOT NULL,
  `progetto` tinyint NOT NULL,
  `id_tipologia` tinyint NOT NULL,
  `tipologia` tinyint NOT NULL,
  `id_priorita` tinyint NOT NULL,
  `priorita` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `data_apertura` tinyint NOT NULL,
  `id_responsabile` tinyint NOT NULL,
  `responsabile` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `timestamp_completamento` tinyint NOT NULL,
  `testo_completamento` tinyint NOT NULL,
  `data_ora_completamento` tinyint NOT NULL,
  `completato` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_anagrafica`
--

DROP TABLE IF EXISTS `tipologie_anagrafica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_anagrafica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  CONSTRAINT `tipologie_anagrafica_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_anagrafica_view`
--

DROP TABLE IF EXISTS `tipologie_anagrafica_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_anagrafica_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_anagrafica_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_attivita`
--

DROP TABLE IF EXISTS `tipologie_attivita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_attivita` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` int(1) DEFAULT NULL,
  `se_censimento_immobili` int(1) DEFAULT NULL,
  `se_notizie_immobili` int(1) DEFAULT NULL,
  `se_richieste_immobili` int(1) DEFAULT NULL,
  `se_dashboard_agenda` int(1) DEFAULT NULL,
  `se_pratiche` int(1) DEFAULT NULL,
  `se_commerciale` int(1) DEFAULT NULL,
  `se_produzione` int(1) DEFAULT NULL,
  `se_amministrazione` int(1) DEFAULT NULL,
  `se_contratto` int(1) DEFAULT NULL,
  `se_chiamata` int(1) DEFAULT NULL,
  `se_scalare` int(1) DEFAULT NULL,
  `se_commessa` int(1) DEFAULT NULL,
  `se_forfait` int(1) DEFAULT NULL,
  `se_ticket` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  UNIQUE KEY `indice` (`id`,`id_genitore`,`nome`,`html`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_scalare` (`se_scalare`),
  KEY `se_commessa` (`se_commessa`),
  KEY `se_forfait` (`se_forfait`),
  KEY `se_contratto` (`se_contratto`),
  KEY `se_chiamata` (`se_chiamata`),
  KEY `se_ticket` (`se_ticket`),
  CONSTRAINT `tipologie_attivita_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tipologie_attivita_inps`
--

DROP TABLE IF EXISTS `tipologie_attivita_inps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_attivita_inps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `codice` char(32) DEFAULT NULL,
  `se_quadratura` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico` (`id`,`id_genitore`,`nome`),
  UNIQUE KEY `codice` (`codice`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_quadratura` (`se_quadratura`),
  CONSTRAINT `tipologie_attivita_inps_ibfk_1_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_attivita_inps` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_attivita_inps_view`
--

DROP TABLE IF EXISTS `tipologie_attivita_inps_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_attivita_inps_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_attivita_inps_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `se_quadratura` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `tipologie_attivita_view`
--

DROP TABLE IF EXISTS `tipologie_attivita_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_attivita_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_attivita_view` (
  `id` tinyint NOT NULL,
  `id_genitore` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `html` tinyint NOT NULL,
  `font_awesome` tinyint NOT NULL,
  `se_anagrafica` tinyint NOT NULL,
  `se_censimento_immobili` tinyint NOT NULL,
  `se_notizie_immobili` tinyint NOT NULL,
  `se_richieste_immobili` tinyint NOT NULL,
  `se_dashboard_agenda` tinyint NOT NULL,
  `se_pratiche` tinyint NOT NULL,
  `se_commerciale` tinyint NOT NULL,
  `se_produzione` tinyint NOT NULL,
  `se_amministrazione` tinyint NOT NULL,
  `se_contratto` tinyint NOT NULL,
  `se_chiamata` tinyint NOT NULL,
  `se_scalare` tinyint NOT NULL,
  `se_commessa` tinyint NOT NULL,
  `se_forfait` tinyint NOT NULL,
  `se_ticket` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_certificazioni`
--

DROP TABLE IF EXISTS `tipologie_certificazioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_certificazioni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_certificazioni_view`
--

DROP TABLE IF EXISTS `tipologie_certificazioni_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_certificazioni_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_certificazioni_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_contatti`
--

DROP TABLE IF EXISTS `tipologie_contatti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_contatti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  `se_segnalazione` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_contatti_view`
--

DROP TABLE IF EXISTS `tipologie_contatti_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_contatti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_contatti_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_segnalazione` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_conteggio_attivita`
--

DROP TABLE IF EXISTS `tipologie_conteggio_attivita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_conteggio_attivita` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(128) NOT NULL,
  `se_standard` int(1) DEFAULT NULL,
  `se_extra` int(1) DEFAULT NULL,
  `se_gratuita` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`,`se_standard`,`se_extra`,`se_gratuita`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_conteggio_attivita_view`
--

DROP TABLE IF EXISTS `tipologie_conteggio_attivita_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_conteggio_attivita_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_conteggio_attivita_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_standard` tinyint NOT NULL,
  `se_extra` tinyint NOT NULL,
  `se_gratuita` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_contratti`
--

DROP TABLE IF EXISTS `tipologie_contratti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_contratti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_contratti_view`
--

DROP TABLE IF EXISTS `tipologie_contratti_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_contratti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_contratti_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_crm`
--

DROP TABLE IF EXISTS `tipologie_crm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_crm` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`,`ordine`) USING BTREE,
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `ordine` (`ordine`),
  CONSTRAINT `tipologie_crm_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_crm_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_crm_view`
--

DROP TABLE IF EXISTS `tipologie_crm_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_crm_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_crm_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `note` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `membri` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_date`
--

DROP TABLE IF EXISTS `tipologie_date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_date` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_date_view`
--

DROP TABLE IF EXISTS `tipologie_date_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_date_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_date_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_documenti`
--

DROP TABLE IF EXISTS `tipologie_documenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_documenti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `codice` char(8) DEFAULT NULL,
  `se_fattura` int(1) DEFAULT NULL,
  `se_nota_credito` int(1) DEFAULT NULL,
  `se_trasporto` int(1) DEFAULT NULL,
  `se_pro_forma` int(1) DEFAULT NULL,
  `se_offerta` int(1) DEFAULT NULL,
  `se_ordine` int(1) DEFAULT NULL,
  `se_ricevuta` int(1) DEFAULT NULL,
  `stampa_xml` char(255) DEFAULT NULL,
  `stampa_pdf` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tipologie_documenti_amministrativi`
--

DROP TABLE IF EXISTS `tipologie_documenti_amministrativi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_documenti_amministrativi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `codice` char(8) DEFAULT NULL,
  `se_fattura` int(1) DEFAULT NULL,
  `se_nota_credito` int(1) DEFAULT NULL,
  `se_trasporto` int(1) DEFAULT NULL,
  `se_pro_forma` int(1) DEFAULT NULL,
  `se_offerta` int(1) DEFAULT NULL,
  `se_ordine` int(1) DEFAULT NULL,
  `se_ricevuta` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_documenti_amministrativi_view`
--

DROP TABLE IF EXISTS `tipologie_documenti_amministrativi_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_documenti_amministrativi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_documenti_amministrativi_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `se_fattura` tinyint NOT NULL,
  `se_nota_credito` tinyint NOT NULL,
  `se_trasporto` tinyint NOT NULL,
  `se_pro_forma` tinyint NOT NULL,
  `se_offerta` tinyint NOT NULL,
  `se_ordine` tinyint NOT NULL,
  `se_ricevuta` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `tipologie_documenti_view`
--

DROP TABLE IF EXISTS `tipologie_documenti_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_documenti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_documenti_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `codice` tinyint NOT NULL,
  `se_fattura` tinyint NOT NULL,
  `se_nota_credito` tinyint NOT NULL,
  `se_trasporto` tinyint NOT NULL,
  `se_pro_forma` tinyint NOT NULL,
  `se_offerta` tinyint NOT NULL,
  `se_ordine` tinyint NOT NULL,
  `se_ricevuta` tinyint NOT NULL,
  `stampa_xml` tinyint NOT NULL,
  `stampa_pdf` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_durate_inps`
--

DROP TABLE IF EXISTS `tipologie_durate_inps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_durate_inps` (
  `id` char(32) NOT NULL,
  `nome` char(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_durate_inps_view`
--

DROP TABLE IF EXISTS `tipologie_durate_inps_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_durate_inps_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_durate_inps_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_edifici`
--

DROP TABLE IF EXISTS `tipologie_edifici`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_edifici` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_edifici_view`
--

DROP TABLE IF EXISTS `tipologie_edifici_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_edifici_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_edifici_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_embed`
--

DROP TABLE IF EXISTS `tipologie_embed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_embed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_video` int(1) DEFAULT NULL,
  `se_audio` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_embed_view`
--

DROP TABLE IF EXISTS `tipologie_embed_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_embed_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_embed_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_video` tinyint NOT NULL,
  `se_audio` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_eventi`
--

DROP TABLE IF EXISTS `tipologie_eventi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_eventi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) NOT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  CONSTRAINT `tipologie_eventi_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_eventi_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_eventi_view`
--

DROP TABLE IF EXISTS `tipologie_eventi_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_eventi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_eventi_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_founding`
--

DROP TABLE IF EXISTS `tipologie_founding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_founding` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_founding_view`
--

DROP TABLE IF EXISTS `tipologie_founding_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_founding_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_founding_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_immobili`
--

DROP TABLE IF EXISTS `tipologie_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  `se_residenziale` int(1) DEFAULT NULL,
  `se_industriale` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_immobili_view`
--

DROP TABLE IF EXISTS `tipologie_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_immobili_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_residenziale` tinyint NOT NULL,
  `se_industriale` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_incarichi_immobili`
--

DROP TABLE IF EXISTS `tipologie_incarichi_immobili`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_incarichi_immobili` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_incarichi_immobili_view`
--

DROP TABLE IF EXISTS `tipologie_incarichi_immobili_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_incarichi_immobili_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_incarichi_immobili_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_indirizzi`
--

DROP TABLE IF EXISTS `tipologie_indirizzi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_indirizzi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `se_sede` int(1) DEFAULT NULL,
  `se_operativa` int(1) DEFAULT NULL,
  `se_abitazione` int(1) DEFAULT NULL,
  `se_domicilio` int(1) DEFAULT NULL,
  `html` char(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`nome`,`se_sede`,`se_operativa`,`se_abitazione`,`se_domicilio`,`html`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_indirizzi_view`
--

DROP TABLE IF EXISTS `tipologie_indirizzi_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_indirizzi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_indirizzi_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_sede` tinyint NOT NULL,
  `se_operativa` tinyint NOT NULL,
  `se_abitazione` tinyint NOT NULL,
  `se_domicilio` tinyint NOT NULL,
  `html` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_interesse`
--

DROP TABLE IF EXISTS `tipologie_interesse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_interesse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_interesse_view`
--

DROP TABLE IF EXISTS `tipologie_interesse_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_interesse_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_interesse_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_mastri`
--

DROP TABLE IF EXISTS `tipologie_mastri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_mastri` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_mastri_view`
--

DROP TABLE IF EXISTS `tipologie_mastri_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_mastri_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_mastri_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_motivazioni_tari`
--

DROP TABLE IF EXISTS `tipologie_motivazioni_tari`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_motivazioni_tari` (
  `id` int(11) NOT NULL,
  `nome` char(40) NOT NULL,
  `soprannome` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_motivazioni_tari_view`
--

DROP TABLE IF EXISTS `tipologie_motivazioni_tari_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_motivazioni_tari_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_motivazioni_tari_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `soprannome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_notizie`
--

DROP TABLE IF EXISTS `tipologie_notizie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_notizie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_notizie_view`
--

DROP TABLE IF EXISTS `tipologie_notizie_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_notizie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_notizie_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_obiettivi`
--

DROP TABLE IF EXISTS `tipologie_obiettivi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_obiettivi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_obiettivi_view`
--

DROP TABLE IF EXISTS `tipologie_obiettivi_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_obiettivi_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_obiettivi_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_orari_inps`
--

DROP TABLE IF EXISTS `tipologie_orari_inps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_orari_inps` (
  `id` char(32) NOT NULL,
  `nome` char(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_orari_inps_view`
--

DROP TABLE IF EXISTS `tipologie_orari_inps_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_orari_inps_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_orari_inps_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_popup`
--

DROP TABLE IF EXISTS `tipologie_popup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_popup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_popup_view`
--

DROP TABLE IF EXISTS `tipologie_popup_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_popup_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_popup_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_pratiche`
--

DROP TABLE IF EXISTS `tipologie_pratiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_pratiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_pratiche_view`
--

DROP TABLE IF EXISTS `tipologie_pratiche_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_pratiche_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_pratiche_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_prodotti`
--

DROP TABLE IF EXISTS `tipologie_prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_prodotti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_colori` tinyint(1) DEFAULT NULL,
  `se_taglie` tinyint(1) DEFAULT NULL,
  `se_dimensioni` tinyint(1) DEFAULT NULL,
  `se_imballo` tinyint(1) DEFAULT NULL,
  `se_stagioni` int(1) DEFAULT NULL,
  `se_servizio` int(1) DEFAULT NULL,
  `se_prodotto` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `id` (`id`,`nome`,`se_colori`,`se_taglie`,`se_dimensioni`,`se_imballo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_prodotti_view`
--

DROP TABLE IF EXISTS `tipologie_prodotti_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_prodotti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_prodotti_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_progetti`
--

DROP TABLE IF EXISTS `tipologie_progetti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_progetti` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_scalare` int(1) DEFAULT NULL,
  `se_commessa` int(1) DEFAULT NULL,
  `se_chiamata` int(1) DEFAULT NULL,
  `se_contratto` int(1) DEFAULT NULL,
  `se_forfait` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `se_scalare` (`se_scalare`),
  KEY `se_commessa` (`se_commessa`),
  KEY `se_chiamata` (`se_chiamata`),
  KEY `se_contratto` (`se_contratto`),
  KEY `se_forfait` (`se_forfait`),
  KEY `indice` (`id`,`nome`,`se_scalare`,`se_commessa`,`se_chiamata`,`se_contratto`,`se_forfait`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_progetti_view`
--

DROP TABLE IF EXISTS `tipologie_progetti_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_progetti_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_progetti_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_scalare` tinyint NOT NULL,
  `se_commessa` tinyint NOT NULL,
  `se_chiamata` tinyint NOT NULL,
  `se_contratto` tinyint NOT NULL,
  `se_forfait` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_pubblicazione`
--

DROP TABLE IF EXISTS `tipologie_pubblicazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_pubblicazione` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_bozza` int(11) DEFAULT NULL,
  `se_pubblicato` int(1) DEFAULT NULL,
  `se_evidenza` int(1) DEFAULT NULL,
  `se_newsletter` int(1) DEFAULT NULL,
  `se_secondario` int(1) DEFAULT NULL,
  `se_incroci` int(1) DEFAULT NULL,
  `se_suggerito` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`,`ordine`) USING BTREE,
  KEY `se_pubblicato` (`se_pubblicato`),
  KEY `se_newsletter` (`se_newsletter`),
  KEY `ordine` (`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_pubblicazione_view`
--

DROP TABLE IF EXISTS `tipologie_pubblicazione_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_pubblicazione_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_pubblicazione_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `se_bozza` tinyint NOT NULL,
  `se_pubblicato` tinyint NOT NULL,
  `se_evidenza` tinyint NOT NULL,
  `se_newsletter` tinyint NOT NULL,
  `se_secondario` tinyint NOT NULL,
  `se_incroci` tinyint NOT NULL,
  `se_suggerito` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_qualifiche_inps`
--

DROP TABLE IF EXISTS `tipologie_qualifiche_inps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_qualifiche_inps` (
  `id` char(32) NOT NULL,
  `nome` char(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_qualifiche_inps_view`
--

DROP TABLE IF EXISTS `tipologie_qualifiche_inps_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_qualifiche_inps_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_qualifiche_inps_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_rassegna_stampa`
--

DROP TABLE IF EXISTS `tipologie_rassegna_stampa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_rassegna_stampa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  CONSTRAINT `tipologie_rassegna_stampa_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_rassegna_stampa_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_rassegna_stampa_view`
--

DROP TABLE IF EXISTS `tipologie_rassegna_stampa_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_rassegna_stampa_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_rassegna_stampa_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_righe_documenti_amministrativi`
--

DROP TABLE IF EXISTS `tipologie_righe_documenti_amministrativi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_righe_documenti_amministrativi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_fattura` int(1) DEFAULT NULL,
  `se_pro_forma` int(1) DEFAULT NULL,
  `se_pratica` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tipologie_risorse`
--

DROP TABLE IF EXISTS `tipologie_risorse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_risorse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_risorse_view`
--

DROP TABLE IF EXISTS `tipologie_risorse_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_risorse_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_risorse_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `ordine` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_soddisfazione`
--

DROP TABLE IF EXISTS `tipologie_soddisfazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_soddisfazione` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_soddisfazione_view`
--

DROP TABLE IF EXISTS `tipologie_soddisfazione_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_soddisfazione_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_soddisfazione_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_taglie`
--

DROP TABLE IF EXISTS `tipologie_taglie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_taglie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_taglie_view`
--

DROP TABLE IF EXISTS `tipologie_taglie_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_taglie_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_taglie_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_task`
--

DROP TABLE IF EXISTS `tipologie_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_pianificata` tinyint(1) DEFAULT NULL,
  `se_richiesta` tinyint(1) DEFAULT NULL,
  `se_imprevista` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`,`se_pianificata`,`se_richiesta`,`se_imprevista`),
  CONSTRAINT `tipologie_task_ibfk_1_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_task_ibfk_2_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_task_view`
--

DROP TABLE IF EXISTS `tipologie_task_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_task_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_task_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_telefoni`
--

DROP TABLE IF EXISTS `tipologie_telefoni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_telefoni` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `html` char(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_telefoni_view`
--

DROP TABLE IF EXISTS `tipologie_telefoni_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_telefoni_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_telefoni_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `html` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_todo`
--

DROP TABLE IF EXISTS `tipologie_todo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_todo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_pianificata` int(1) DEFAULT NULL,
  `se_richiesta` int(1) DEFAULT NULL,
  `se_imprevista` int(1) DEFAULT NULL,
  `se_contratto` int(1) DEFAULT NULL,
  `se_chiamata` int(1) DEFAULT NULL,
  `se_scalare` int(1) DEFAULT NULL,
  `se_commessa` int(1) DEFAULT NULL,
  `se_forfait` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `se_chiamata` (`se_chiamata`),
  KEY `indice` (`id`,`nome`,`se_pianificata`,`se_richiesta`,`se_imprevista`,`se_contratto`,`se_chiamata`),
  KEY `se_contratto` (`se_contratto`),
  KEY `se_scalare` (`se_scalare`),
  KEY `se_commessa` (`se_commessa`),
  KEY `se_forfait` (`se_forfait`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_todo_view`
--

DROP TABLE IF EXISTS `tipologie_todo_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_todo_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_todo_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_pianificata` tinyint NOT NULL,
  `se_richiesta` tinyint NOT NULL,
  `se_imprevista` tinyint NOT NULL,
  `se_contratto` tinyint NOT NULL,
  `se_chiamata` tinyint NOT NULL,
  `se_scalare` tinyint NOT NULL,
  `se_commessa` tinyint NOT NULL,
  `se_forfait` tinyint NOT NULL,
  `id_account_inserimento` tinyint NOT NULL,
  `timestamp_inserimento` tinyint NOT NULL,
  `id_account_aggiornamento` tinyint NOT NULL,
  `timestamp_aggiornamento` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_udm`
--

DROP TABLE IF EXISTS `tipologie_udm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_udm` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_udm_view`
--

DROP TABLE IF EXISTS `tipologie_udm_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_udm_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_udm_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_vani`
--

DROP TABLE IF EXISTS `tipologie_vani`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_vani` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  `se_camera` int(1) DEFAULT NULL,
  `se_cucina` int(1) DEFAULT NULL,
  `se_bagno` int(1) DEFAULT NULL,
  `se_commerciale` int(1) DEFAULT NULL,
  `percentuale_commerciale` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_vani_view`
--

DROP TABLE IF EXISTS `tipologie_vani_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_vani_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_vani_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `se_camera` tinyint NOT NULL,
  `se_cucina` tinyint NOT NULL,
  `se_bagno` tinyint NOT NULL,
  `se_commerciale` tinyint NOT NULL,
  `percentuale_commerciale` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie_variazioni_attivita`
--

DROP TABLE IF EXISTS `tipologie_variazioni_attivita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipologie_variazioni_attivita` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `tipologie_variazioni_attivita_view`
--

DROP TABLE IF EXISTS `tipologie_variazioni_attivita_view`;
/*!50001 DROP VIEW IF EXISTS `tipologie_variazioni_attivita_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `tipologie_variazioni_attivita_view` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `__label__` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `todo`
--

DROP TABLE IF EXISTS `todo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `todo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` char(255) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_priorita` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_contatto` int(11) DEFAULT NULL,
  `testo` text,
  `ore_previste` decimal(5,2) DEFAULT NULL,
  `testo_ore_previste` text,
  `anno_previsto` year(4) DEFAULT NULL,
  `settimana_prevista` int(11) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `testo_pianificazione` text,
  `id_responsabile` int(11) DEFAULT NULL,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `timestamp_pianificazione` int(11) DEFAULT NULL,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `anno_programmazione` year(4) DEFAULT NULL,
  `settimana_programmazione` int(11) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `timestamp_revisione` int(11) DEFAULT NULL,
  `note_revisione` text,
  `timestamp_completamento` int(11) DEFAULT NULL,
  `testo_completamento` text,
  `timestamp_feedback` int(11) DEFAULT NULL,
  `id_anagrafica_feedback` int(11) DEFAULT NULL,
  `note_feedback` text,
  `interesse_feedback` int(11) DEFAULT NULL,
  `raccomandazione_feedback` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_mastro_attivita_default` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_priorita` (`id_priorita`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_responsabile` (`id_responsabile`),
  KEY `id_luogo` (`id_luogo`),
  KEY `id_pianificazione` (`id_pianificazione`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `data_programmazione` (`data_programmazione`),
  KEY `id_mastro_attivita_default` (`id_mastro_attimysqldump: Couldn't execute 'show create table `todo_archivio_view`': View '__glisweb__.todo_archivio_view' references invalid table(s) or column(s) or function(s) or definer/invoker of view lack rights to use them (1356)
vita_default`),
  KEY `id_contatto` (`id_contatto`),
  KEY `id_anagrafica_feedback` (`id_anagrafica_feedback`),
  CONSTRAINT `todo_ibfk_10_nofollow` FOREIGN KEY (`id_contatto`) REFERENCES `contatti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `todo_ibfk_15_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `todo_ibfk_16_nofollow` FOREIGN KEY (`id_mastro_attivita_default`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `todo_ibfk_17_nofollow` FOREIGN KEY (`id_anagrafica_feedback`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `todo_ibfk_1_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `todo_ibfk_2_nofollow` FOREIGN KEY (`id_priorita`) REFERENCES `priorita` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `todo_ibfk_3` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `todo_ibfk_3_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_attivita` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `todo_ibfk_4_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `todo_ibfk_5_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `todo_ibfk_6_nofollow` FOREIGN KEY (`id_responsabile`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `todo_ibfk_7_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `todo_ibfk_8_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `todo_ibfk_9_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
