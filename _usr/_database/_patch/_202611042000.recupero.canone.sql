-- 2026-11-04 — recupero del canone per i database creati prima del 04/10/2026
--
-- Dal canone del 04/10/2026 ( 622c1907a ) al 04/11 i file base sono andati avanti senza patch: 146 commit su
-- _010000/_030000/_060000, 12 con una patch datata. I marcatori 0N0000... stanno sotto il livello di qualunque
-- database gia' installato, quindi quei database non hanno mai ricevuto 28 tabelle e 274 colonne del canone, e
-- 91 viste di _090000999999.views.sql non ci si potevano creare. Misura del 04/11 su utensilerialughese, gimbe,
-- polmasi ( PROD ) e bernispa, stesse 87 cause su tutti: var/20261104-viste-canone-deploy/ nel deploy glisweb;
-- elenco delle colonne commit per commit di GLISDEV in var/20261104-colonne-canone/ nel deploy glisdev.
-- Decisa da Fabio il 04/11/2026 insieme alla guardia delle patch ( _src/_sh/_patch.guardia.sh ), che da qui in
-- avanti impedisce che il buco si riapra.
--
-- Cosa fa, generata dal canone ricostruito dai file base ( genera.py nella cartella della misura ):
-- - CREATE TABLE IF NOT EXISTS delle 28 tabelle nuove, senza vincoli, e poi un ALTER con tutte le loro colonne,
--   perche' cinque di loro su qualche deploy esistono gia' con la forma vecchia;
-- - ADD COLUMN IF NOT EXISTS delle colonne nuove nelle tabelle che c'erano, con i loro indici, un ALTER per
--   tabella; le colonne vanno in fondo, senza AFTER: dove manca la colonna precedente AFTER fermerebbe la coda,
--   e le statiche si popolano per nome ( refreshStaticView() );
-- - i vincoli, uno per blocco: con piu' ADD CONSTRAINT ... IF NOT EXISTS nello stesso ALTER, MariaDB 10.3
--   fallisce se uno viene saltato.
--
-- Cosa NON fa, e resta alla ricostruzione con travaso ( TODO di glisweb, database e patch ):
-- - le viste: dal 26/10/2026 una patch non le crea ( 300.database.md, le viste vivono nei file base ). Sulle
--   copie dei quattro database, dopo questa patch le viste del canone si creano tutte ( 0 non creabili ) e
--   ricaricando _090000999999.views.sql sono 279 su 279 identiche;
-- - modalita_pagamento.codice_sdi e ritenute.codice_sdi entrano nullabili invece che NOT NULL: su una tabella
--   piena il NOT NULL le riempirebbe di '' e la UNIQUE di ritenute fallirebbe;
-- - file, immagini e pianificazioni prendono le sole colonne: sui database vecchi hanno 57-64 indici, e il
--   limite di InnoDB e' 64;
-- - un vincolo il cui nome sul deploy e' gia' preso da un'altra colonna si salta in silenzio ( la numerazione
--   <tabella>_ibfk_N diverge fra deploy e standard, TODO di glisweb );
-- - i tipi delle colonne che c'erano, tranne funnel e tipologie_asset: su crmtrb esistono con id int( 11 ), e i
--   vincoli verso di loro non si creerebbero ( errno 150 ), quindi il loro ALTER porta id e chiavi a bigint ( 04/11
--   notte ); metadati.id_asset, int( 11 ) anche quella, la porta la fase 2 ( _202611042330 );
-- - le colonne rinominate e quelle ridefinite: la colonna nuova entra vuota accanto alla vecchia, i dati non si
--   spostano ( 35 nuove hanno nella stessa tabella una tolta dello stesso tipo, da guardare una per una ).
--
-- Collaudo sulle copie dello schema dei quattro database e sul canone ricostruito: nessun errore, due volte di
-- fila ( idempotente ); sul canone non cambia niente.

-- | 202611042000

-- anagrafica_organizzazioni
CREATE TABLE IF NOT EXISTS `anagrafica_organizzazioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_organizzazione` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`id_organizzazione`,`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_organizzazione` (`id_organizzazione`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_anagrafica`,`id_organizzazione`,`id_ruolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042001

-- attivita_asset
CREATE TABLE IF NOT EXISTS `attivita_asset` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_attivita` bigint(20) DEFAULT NULL,
  `id_asset` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_attivita`,`id_asset`),
  KEY `ordine` (`ordine`),
  KEY `id_attivita` (`id_attivita`),
  KEY `id_asset` (`id_asset`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_attivita`,`id_asset`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042002

-- categorie_conversazioni
CREATE TABLE IF NOT EXISTS `categorie_conversazioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  UNIQUE KEY `codice` (`codice`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042003

-- categorie_marchi
CREATE TABLE IF NOT EXISTS `categorie_marchi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` bigint(20) DEFAULT NULL,
  `id_pagina` bigint(20) DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `note_archiviazione` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  UNIQUE KEY `codice` (`codice`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `id_sito` (`id_sito`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`id_sito`,`id_pagina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042004

-- conversazioni_categorie
CREATE TABLE IF NOT EXISTS `conversazioni_categorie` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_conversazione` bigint(20) DEFAULT NULL,
  `id_categoria` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_conversazione`,`id_categoria`),
  KEY `ordine` (`ordine`),
  KEY `id_conversazione` (`id_conversazione`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_conversazione`,`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042005

-- edifici_anagrafica
CREATE TABLE IF NOT EXISTS `edifici_anagrafica` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_edificio` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_edificio`,`id_anagrafica`,`id_ruolo`),
  KEY `id_edificio` (`id_edificio`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_edificio`,`id_anagrafica`,`id_ruolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042006

-- formati_tipologie_corrispondenza
CREATE TABLE IF NOT EXISTS `formati_tipologie_corrispondenza` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `altezza_min` decimal(7,2) DEFAULT NULL,
  `larghezza_min` decimal(7,2) DEFAULT NULL,
  `spessore_min` decimal(7,2) DEFAULT NULL,
  `altezza_max` decimal(7,2) DEFAULT NULL,
  `larghezza_max` decimal(7,2) DEFAULT NULL,
  `spessore_max` decimal(7,2) DEFAULT NULL,
  `id_udm_dimensioni` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `nome` (`nome`),
  KEY `id_udm_dimensioni` (`id_udm_dimensioni`),
  KEY `indice` (`id`,`id_tipologia`,`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042007

-- funnel
CREATE TABLE IF NOT EXISTS `funnel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` char(255) DEFAULT NULL,
  `id_campagna` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_campagna` (`id_campagna`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`,`id_campagna`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042008

-- lotti
CREATE TABLE IF NOT EXISTS `lotti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `codice` char(32) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `id_produttore` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `data_produzione` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_articolo`,`codice`),
  KEY `codice` (`codice`),
  KEY `nome` (`nome`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_produttore` (`id_produttore`),
  KEY `data_scadenza` (`data_scadenza`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`codice`,`nome`,`id_articolo`,`id_produttore`,`data_scadenza`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042009

-- marchi_categorie
CREATE TABLE IF NOT EXISTS `marchi_categorie` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_marchio` bigint(20) DEFAULT NULL,
  `id_categoria` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_marchio`,`id_categoria`),
  KEY `id_marchio` (`id_marchio`),
  KEY `id_categoria` (`id_categoria`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_marchio`,`id_categoria`,`ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042010

-- messaggi_account
CREATE TABLE IF NOT EXISTS `messaggi_account` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `id_messaggio` bigint(20) DEFAULT NULL,
  `timestamp_lettura` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_messaggio`,`id_account`),
  KEY `ordine` (`ordine`),
  KEY `id_account` (`id_account`),
  KEY `id_messaggio` (`id_messaggio`),
  KEY `timestamp_lettura` (`timestamp_lettura`),
  KEY `indice` (`id`,`ordine`,`id_account`,`id_messaggio`,`timestamp_lettura`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042011

-- relazioni_step
CREATE TABLE IF NOT EXISTS `relazioni_step` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_step` bigint(20) DEFAULT NULL,
  `id_step_collegato` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_step`,`id_step_collegato`,`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_step` (`id_step`),
  KEY `id_step_collegato` (`id_step_collegato`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_step`,`id_step_collegato`,`id_ruolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042012

-- risorse_organizzazioni
CREATE TABLE IF NOT EXISTS `risorse_organizzazioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_risorsa` bigint(20) DEFAULT NULL,
  `id_organizzazione` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_risorsa`,`id_organizzazione`,`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_organizzazione` (`id_organizzazione`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_risorsa`,`id_organizzazione`,`id_ruolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042013

-- ruoli_certificazioni
CREATE TABLE IF NOT EXISTS `ruoli_certificazioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`,`id_genitore`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042014

-- ruoli_conversazioni
CREATE TABLE IF NOT EXISTS `ruoli_conversazioni` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`,`id_genitore`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042015

-- ruoli_pagamenti
CREATE TABLE IF NOT EXISTS `ruoli_pagamenti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_relazioni` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`,`id_genitore`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042016

-- ruoli_risorse
CREATE TABLE IF NOT EXISTS `ruoli_risorse` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_organizzazioni` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`,`id_genitore`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042017

-- ruoli_software
CREATE TABLE IF NOT EXISTS `ruoli_software` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_relazioni` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`,`id_genitore`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042018

-- ruoli_step
CREATE TABLE IF NOT EXISTS `ruoli_step` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_relazioni` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`,`id_genitore`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042019

-- sconti_categorie_prodotti
CREATE TABLE IF NOT EXISTS `sconti_categorie_prodotti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_sconto` bigint(20) DEFAULT NULL,
  `id_categoria` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_sconto`,`id_categoria`),
  KEY `ordine` (`ordine`),
  KEY `id_sconto` (`id_sconto`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_sconto`,`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042020

-- sconti_marchi
CREATE TABLE IF NOT EXISTS `sconti_marchi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_sconto` bigint(20) DEFAULT NULL,
  `id_marchio` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_sconto`,`id_marchio`),
  KEY `ordine` (`ordine`),
  KEY `id_sconto` (`id_sconto`),
  KEY `id_marchio` (`id_marchio`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_sconto`,`id_marchio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042021

-- sconti_prodotti
CREATE TABLE IF NOT EXISTS `sconti_prodotti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_sconto` bigint(20) DEFAULT NULL,
  `id_prodotto` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_sconto`,`id_prodotto`),
  KEY `ordine` (`ordine`),
  KEY `id_sconto` (`id_sconto`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_sconto`,`id_prodotto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042022

-- tipologie_asset
CREATE TABLE IF NOT EXISTS `tipologie_asset` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042023

-- tipologie_campagne
CREATE TABLE IF NOT EXISTS `tipologie_campagne` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042024

-- tipologie_vani
CREATE TABLE IF NOT EXISTS `tipologie_vani` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042025

-- vani
CREATE TABLE IF NOT EXISTS `vani` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_immobile` bigint(20) DEFAULT NULL,
  `superficie` decimal(16,2) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_immobile`,`nome`),
  UNIQUE KEY `codice` (`codice`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_immobile` (`id_immobile`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_immobile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042026

-- vani_anagrafica
CREATE TABLE IF NOT EXISTS `vani_anagrafica` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_vano` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_vano`,`id_anagrafica`,`id_ruolo`),
  KEY `id_vano` (`id_vano`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_vano`,`id_anagrafica`,`id_ruolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042027

-- vani_caratteristiche
CREATE TABLE IF NOT EXISTS `vani_caratteristiche` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_vano` bigint(20) DEFAULT NULL,
  `id_caratteristica` bigint(20) DEFAULT NULL,
  `id_lingua` bigint(20) DEFAULT NULL,
  `valore` text DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_assente` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_vano`,`id_caratteristica`,`id_lingua`),
  KEY `id_vano` (`id_vano`),
  KEY `id_caratteristica` (`id_caratteristica`),
  KEY `id_lingua` (`id_lingua`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_vano`,`id_caratteristica`,`id_lingua`,`se_assente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611042028

-- account: id_organizzazione
ALTER TABLE `account`
	ADD COLUMN IF NOT EXISTS `id_organizzazione` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_organizzazione` (`id_organizzazione`);

-- | 202611042029

-- anagrafica_organizzazioni: id_account_aggiornamento, id_account_inserimento, id_anagrafica, id_organizzazione, id_ruolo, note, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `anagrafica_organizzazioni`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_anagrafica` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_organizzazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_ruolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_anagrafica`,`id_organizzazione`,`id_ruolo`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_anagrafica` (`id_anagrafica`),
	ADD KEY IF NOT EXISTS `id_organizzazione` (`id_organizzazione`),
	ADD KEY IF NOT EXISTS `id_ruolo` (`id_ruolo`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_anagrafica`,`id_organizzazione`,`id_ruolo`);

-- | 202611042030

-- asset: id_condizione, id_genitore
ALTER TABLE `asset`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_condizione` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `id_condizione` (`id_condizione`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`id_tipologia`,`codice`);

-- | 202611042031

-- attivita: id_banner, id_pubblicazione, id_redirect
ALTER TABLE `attivita`
	ADD COLUMN IF NOT EXISTS `id_banner` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_pubblicazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_redirect` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_banner` (`id_banner`),
	ADD KEY IF NOT EXISTS `id_pubblicazione` (`id_pubblicazione`),
	ADD KEY IF NOT EXISTS `id_redirect` (`id_redirect`);

-- | 202611042032

-- attivita_asset: id_account_aggiornamento, id_account_inserimento, id_asset, id_attivita, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `attivita_asset`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_attivita` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_asset` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_attivita`,`id_asset`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_attivita` (`id_attivita`),
	ADD KEY IF NOT EXISTS `id_asset` (`id_asset`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_attivita`,`id_asset`);

-- | 202611042033

-- audio: id_categoria_marchi, id_immagine, id_vano, id_video
ALTER TABLE `audio`
	ADD COLUMN IF NOT EXISTS `id_categoria_marchi` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_video` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_immagine` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_vano` bigint(20) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica_vano` (`id_vano`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_categoria_marchi` (`id_categoria_marchi`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_video` (`id_video`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_immagine` (`id_immagine`,`id_ruolo`,`id_lingua`,`path`);

-- | 202611042034

-- badge: id_anagrafica
ALTER TABLE `badge`
	ADD COLUMN IF NOT EXISTS `id_anagrafica` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_anagrafica` (`id_anagrafica`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_anagrafica`,`id_contratto`,`rfid`);

-- | 202611042035

-- banner: altezza, id_affiliazione, larghezza
ALTER TABLE `banner`
	ADD COLUMN IF NOT EXISTS `id_affiliazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `larghezza` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `altezza` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_affiliazione` (`id_affiliazione`),
	ADD KEY IF NOT EXISTS `larghezza` (`larghezza`),
	ADD KEY IF NOT EXISTS `altezza` (`altezza`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_tipologia`,`ordine`,`nome`,`id_inserzionista`,`id_affiliazione`,`larghezza`,`altezza`);

-- | 202611042036

-- banner_zone: ordine
ALTER TABLE `banner_zone`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_banner`,`id_zona`);

-- | 202611042037

-- campagne: budget, codice, data_fine, data_inizio, id_genitore, id_tipologia, id_valuta, ordine, utm_campaign, utm_content, utm_id, utm_medium, utm_source, utm_term
ALTER TABLE `campagne`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_tipologia` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_valuta` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `budget` decimal(16,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `utm_id` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `utm_source` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `utm_medium` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `utm_campaign` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `utm_term` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `utm_content` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_inizio` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_fine` date DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_valuta` (`id_valuta`),
	ADD KEY IF NOT EXISTS `budget` (`budget`),
	ADD KEY IF NOT EXISTS `utm_campaign` (`utm_campaign`),
	ADD KEY IF NOT EXISTS `data_inizio` (`data_inizio`),
	ADD KEY IF NOT EXISTS `data_fine` (`data_fine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`codice`,`nome`,`id_valuta`,`budget`,`data_inizio`,`data_fine`);

-- | 202611042038

-- caratteristiche: codice, ordine, se_vani
ALTER TABLE `caratteristiche`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_vani` tinyint(1) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`se_prodotti`,`se_articoli`,`se_immobili`,`se_edifici`,`se_indirizzi`,`se_vani`);

-- | 202611042039

-- carrelli_articoli: ordine
ALTER TABLE `carrelli_articoli`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_carrello`,`id_articolo`,`destinatario_id_anagrafica`);

-- | 202611042040

-- carrelli_consensi: ordine
ALTER TABLE `carrelli_consensi`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_carrello`,`id_anagrafica`,`id_account`,`id_consenso`,`se_prestato`);

-- | 202611042041

-- categorie_anagrafica: se_annunci, se_contratti, se_didattica, se_immobili, se_logistica, se_organizzazioni, se_partner, se_progetti, se_relazioni, se_risorse
ALTER TABLE `categorie_anagrafica`
	ADD COLUMN IF NOT EXISTS `se_partner` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_logistica` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_annunci` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_contratti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_didattica` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_immobili` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_organizzazioni` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_progetti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_relazioni` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_risorse` tinyint(1) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `se_partner` (`se_partner`),
	ADD KEY IF NOT EXISTS `se_logistica` (`se_logistica`),
	ADD KEY IF NOT EXISTS `se_annunci` (`se_annunci`),
	ADD KEY IF NOT EXISTS `se_contratti` (`se_contratti`),
	ADD KEY IF NOT EXISTS `se_didattica` (`se_didattica`),
	ADD KEY IF NOT EXISTS `se_immobili` (`se_immobili`),
	ADD KEY IF NOT EXISTS `se_organizzazioni` (`se_organizzazioni`),
	ADD KEY IF NOT EXISTS `se_progetti` (`se_progetti`),
	ADD KEY IF NOT EXISTS `se_relazioni` (`se_relazioni`),
	ADD KEY IF NOT EXISTS `se_risorse` (`se_risorse`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`se_lead`,`se_prospect`,`se_cliente`,`se_fornitore`,`se_produttore`,`se_corriere`,`se_collaboratore`,`se_interno`,`se_esterno`,`se_concorrente`,`se_partner`);

-- | 202611042042

-- categorie_annunci: data_archiviazione, note_archiviazione
ALTER TABLE `categorie_annunci`
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL;

-- | 202611042043

-- categorie_conversazioni: codice, id_account_aggiornamento, id_account_inserimento, id_genitore, nome, note, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `categorie_conversazioni`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`),
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`);

-- | 202611042044

-- categorie_marchi: codice, data_archiviazione, id_account_aggiornamento, id_account_inserimento, id_genitore, id_pagina, id_sito, nome, note, note_archiviazione, ordine, schema_html, se_cacheable, se_sitemap, tema_css, template, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `categorie_marchi`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `template` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `schema_html` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `tema_css` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_sitemap` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_cacheable` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_sito` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_pagina` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`),
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_sito` (`id_sito`),
	ADD KEY IF NOT EXISTS `id_pagina` (`id_pagina`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`id_sito`,`id_pagina`);

-- | 202611042045

-- categorie_progetti: data_archiviazione, note_archiviazione
ALTER TABLE `categorie_progetti`
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL;

-- | 202611042046

-- categorie_risorse: data_archiviazione, note_archiviazione
ALTER TABLE `categorie_risorse`
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL;

-- | 202611042047

-- certificazioni: se_didattica
ALTER TABLE `certificazioni`
	ADD COLUMN IF NOT EXISTS `se_didattica` tinyint(1) DEFAULT NULL;

-- | 202611042048

-- classi_energetiche: hex
ALTER TABLE `classi_energetiche`
	ADD COLUMN IF NOT EXISTS `hex` char(8) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `indice` (`id`,`nome`,`ep_min`,`ep_max`,`hex`);

-- | 202611042049

-- comuni: data_archiviazione, id_successore, note_archiviazione
ALTER TABLE `comuni`
	ADD COLUMN IF NOT EXISTS `id_successore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_successore` (`id_successore`),
	ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`);

-- | 202611042050

-- condizioni: se_asset
ALTER TABLE `condizioni`
	ADD COLUMN IF NOT EXISTS `se_asset` tinyint(1) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `se_asset` (`se_asset`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`nome`,`se_asset`,`se_catalogo`,`se_immobili`);

-- | 202611042051

-- consensi_contatti: ordine, se_prestato, timestamp_consenso
ALTER TABLE `consensi_contatti`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_prestato` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_consenso` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `se_prestato` (`se_prestato`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_contatto`,`id_consenso`,`modulo`,`se_prestato`);

-- | 202611042052

-- contatti: id_account_archiviazione
ALTER TABLE `contatti`
	ADD COLUMN IF NOT EXISTS `id_account_archiviazione` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_account_archiviazione` (`id_account_archiviazione`);

-- | 202611042053

-- contenuti: id_categoria_marchi, id_vano
ALTER TABLE `contenuti`
	ADD COLUMN IF NOT EXISTS `id_categoria_marchi` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_vano` bigint(20) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica_categoria_marchi` (`id_categoria_marchi`,`id_lingua`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_vano` (`id_vano`,`id_lingua`);

-- | 202611042054

-- contratti: data_archiviazione, id_account_archiviazione, note_archiviazione
ALTER TABLE `contratti`
	ADD COLUMN IF NOT EXISTS `id_account_archiviazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_account_archiviazione` (`id_account_archiviazione`),
	ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_immobile`,`id_progetto`,`data_archiviazione`);

-- | 202611042055

-- conversazioni_account: ordine
ALTER TABLE `conversazioni_account`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_conversazione`,`id_account`,`id_ruolo`,`timestamp_lettura`,`timestamp_entrata`,`timestamp_uscita`);

-- | 202611042056

-- conversazioni_categorie: id_account_aggiornamento, id_account_inserimento, id_categoria, id_conversazione, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `conversazioni_categorie`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_conversazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_conversazione`,`id_categoria`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_conversazione` (`id_conversazione`),
	ADD KEY IF NOT EXISTS `id_categoria` (`id_categoria`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_conversazione`,`id_categoria`);

-- | 202611042057

-- corrispondenza: id_distinta_spedizione, id_udm_peso
ALTER TABLE `corrispondenza`
	ADD COLUMN IF NOT EXISTS `id_udm_peso` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_distinta_spedizione` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_udm_peso` (`id_udm_peso`),
	ADD KEY IF NOT EXISTS `id_distinta_spedizione` (`id_distinta_spedizione`);

-- | 202611042058

-- distinta: ordine
ALTER TABLE `distinta`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_articolo`,`id_componente`,`quantita`);

-- | 202611042059

-- documenti: id_account_archiviazione, id_carrelli_articoli
ALTER TABLE `documenti`
	ADD COLUMN IF NOT EXISTS `id_carrelli_articoli` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_archiviazione` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_carrelli_articoli` (`id_carrelli_articoli`),
	ADD KEY IF NOT EXISTS `id_account_archiviazione` (`id_account_archiviazione`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_tipologia`,`numero`,`sezionale`,`data`,`id_emittente`,`id_sede_emittente`,`id_destinatario`,`id_sede_destinatario`,`id_coupon`,`id_carrelli_articoli`);

-- | 202611042060

-- documenti_articoli: id_carrello, id_immobile, id_lotto
ALTER TABLE `documenti_articoli`
	ADD COLUMN IF NOT EXISTS `id_lotto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_carrello` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_immobile` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_lotto` (`id_lotto`),
	ADD KEY IF NOT EXISTS `id_carrello` (`id_carrello`),
	ADD KEY IF NOT EXISTS `id_immobile` (`id_immobile`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`id_tipologia_documento`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_todo`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_carrello`);

-- | 202611042061

-- documenti_casse_previdenziali: ordine, riferimento_amministrazione
ALTER TABLE `documenti_casse_previdenziali`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `riferimento_amministrazione` char(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_documento`,`id_cassa_previdenziale`,`aliquota`,`imponibile`,`importo`,`id_iva`,`se_ritenuta`);

-- | 202611042062

-- documenti_ritenute: ordine
ALTER TABLE `documenti_ritenute`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_documento`,`id_ritenuta`,`aliquota`,`causale_pagamento`,`importo`);

-- | 202611042063

-- edifici: id_genitore
ALTER TABLE `edifici`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`id_tipologia`,`codice`,`nome`,`id_indirizzo`);

-- | 202611042064

-- edifici_anagrafica: id_account_aggiornamento, id_account_inserimento, id_anagrafica, id_edificio, id_ruolo, note, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `edifici_anagrafica`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_edificio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_anagrafica` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_ruolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_edificio`,`id_anagrafica`,`id_ruolo`),
	ADD KEY IF NOT EXISTS `id_edificio` (`id_edificio`),
	ADD KEY IF NOT EXISTS `id_anagrafica` (`id_anagrafica`),
	ADD KEY IF NOT EXISTS `id_ruolo` (`id_ruolo`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_edificio`,`id_anagrafica`,`id_ruolo`);

-- | 202611042065

-- edifici_caratteristiche: id_lingua, se_assente, valore
ALTER TABLE `edifici_caratteristiche`
	ADD COLUMN IF NOT EXISTS `id_lingua` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `valore` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_assente` tinyint(1) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_edificio`,`id_caratteristica`,`id_lingua`),
	ADD KEY IF NOT EXISTS `id_lingua` (`id_lingua`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_edificio`,`id_caratteristica`,`id_lingua`,`se_assente`);

-- | 202611042066

-- file: id_audio, id_categoria_marchi, id_immagine, id_vano, id_video
ALTER TABLE `file`
	ADD COLUMN IF NOT EXISTS `id_categoria_marchi` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_audio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_video` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_immagine` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_vano` bigint(20) DEFAULT NULL;

-- | 202611042067

-- formati_tipologie_corrispondenza: altezza_max, altezza_min, id_account_aggiornamento, id_account_inserimento, id_tipologia, id_udm_dimensioni, larghezza_max, larghezza_min, nome, spessore_max, spessore_min, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `formati_tipologie_corrispondenza`
	ADD COLUMN IF NOT EXISTS `id_tipologia` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `altezza_min` decimal(7,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `larghezza_min` decimal(7,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `spessore_min` decimal(7,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `altezza_max` decimal(7,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `larghezza_max` decimal(7,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `spessore_max` decimal(7,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_udm_dimensioni` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`),
	ADD KEY IF NOT EXISTS `nome` (`nome`),
	ADD KEY IF NOT EXISTS `id_udm_dimensioni` (`id_udm_dimensioni`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_tipologia`,`nome`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 202611042068

-- funnel: id_account_aggiornamento, id_account_inserimento, id_campagna, nome, note, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `funnel`
	MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_campagna` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`),
	ADD KEY IF NOT EXISTS `id_campagna` (`id_campagna`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`nome`,`id_campagna`);

-- | 202611042069

-- iban: ordine
ALTER TABLE `iban`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_anagrafica`,`intestazione`,`iban`);

-- | 202611042070

-- immagini: id_audio, id_categoria_marchi, id_vano, tentativi, timestamp_elaborazione
ALTER TABLE `immagini`
	ADD COLUMN IF NOT EXISTS `id_categoria_marchi` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_audio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_vano` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `tentativi` int(11) DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `timestamp_elaborazione` int(11) DEFAULT NULL;

-- | 202611042071

-- immobili_caratteristiche: id_lingua, se_assente, valore
ALTER TABLE `immobili_caratteristiche`
	ADD COLUMN IF NOT EXISTS `id_lingua` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `valore` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_assente` tinyint(1) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_immobile`,`id_caratteristica`,`id_lingua`),
	ADD KEY IF NOT EXISTS `id_lingua` (`id_lingua`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_immobile`,`id_caratteristica`,`id_lingua`,`se_assente`);

-- | 202611042072

-- indirizzi_caratteristiche: id_lingua, se_assente, valore
ALTER TABLE `indirizzi_caratteristiche`
	ADD COLUMN IF NOT EXISTS `id_lingua` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `valore` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_assente` tinyint(1) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_indirizzo`,`id_caratteristica`,`id_lingua`),
	ADD KEY IF NOT EXISTS `id_lingua` (`id_lingua`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_indirizzo`,`id_caratteristica`,`id_lingua`,`se_assente`);

-- | 202611042073

-- iva: data_archiviazione, note_archiviazione
ALTER TABLE `iva`
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`codice`,`nome`,`aliquota`,`data_archiviazione`);

-- | 202611042074

-- liste: codice
ALTER TABLE `liste`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`codice`,`nome`);

-- | 202611042075

-- liste_mail: ordine
ALTER TABLE `liste_mail`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_lista`,`id_mail`);

-- | 202611042076

-- lotti: codice, data_produzione, data_scadenza, id_account_aggiornamento, id_account_inserimento, id_articolo, id_produttore, nome, note, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `lotti`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_articolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_produttore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_produzione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_scadenza` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_articolo`,`codice`),
	ADD KEY IF NOT EXISTS `codice` (`codice`),
	ADD KEY IF NOT EXISTS `nome` (`nome`),
	ADD KEY IF NOT EXISTS `id_articolo` (`id_articolo`),
	ADD KEY IF NOT EXISTS `id_produttore` (`id_produttore`),
	ADD KEY IF NOT EXISTS `data_scadenza` (`data_scadenza`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`codice`,`nome`,`id_articolo`,`id_produttore`,`data_scadenza`);

-- | 202611042077

-- luoghi: id_vano
ALTER TABLE `luoghi`
	ADD COLUMN IF NOT EXISTS `id_vano` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_vano` (`id_vano`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`id_tipologia`,`nome`,`id_indirizzo`,`id_edificio`,`id_immobile`,`id_vano`);

-- | 202611042078

-- macro: id_categoria_marchi, id_marchio
ALTER TABLE `macro`
	ADD COLUMN IF NOT EXISTS `id_marchio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_marchi` bigint(20) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica_marchio` (`id_marchio`,`macro`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_categoria_marchi` (`id_categoria_marchi`,`macro`);

-- | 202611042079

-- mail: ordine
ALTER TABLE `mail`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_anagrafica`,`id_ruolo`,`indirizzo`,`se_notifiche`,`se_pec`);

-- | 202611042080

-- mailing_liste: ordine
ALTER TABLE `mailing_liste`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_lista`,`id_mailing`);

-- | 202611042081

-- mailing_mail: id_mail_sent, ordine
ALTER TABLE `mailing_mail`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_mail_sent` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_mail_sent` (`id_mail_sent`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_mail`,`id_mailing`,`id_mail_out`,`id_mail_sent`,`token`);

-- | 202611042082

-- marchi: id_pagina, id_sito, schema_html, se_cacheable, se_sitemap, tema_css, template
ALTER TABLE `marchi`
	ADD COLUMN IF NOT EXISTS `template` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `schema_html` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `tema_css` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_sitemap` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_cacheable` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_sito` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_pagina` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_sito` (`id_sito`),
	ADD KEY IF NOT EXISTS `id_pagina` (`id_pagina`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`nome`,`id_produttore`,`id_sito`,`id_pagina`);

-- | 202611042083

-- marchi_categorie: id_account_aggiornamento, id_account_inserimento, id_categoria, id_marchio, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `marchi_categorie`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_marchio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_marchio`,`id_categoria`),
	ADD KEY IF NOT EXISTS `id_marchio` (`id_marchio`),
	ADD KEY IF NOT EXISTS `id_categoria` (`id_categoria`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_marchio`,`id_categoria`,`ordine`);

-- | 202611042084

-- mastri: data_archiviazione, id_edificio, id_immobile, id_indirizzo, id_vano, note_archiviazione
ALTER TABLE `mastri`
	ADD COLUMN IF NOT EXISTS `id_indirizzo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_edificio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_immobile` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_vano` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_indirizzo` (`id_indirizzo`),
	ADD KEY IF NOT EXISTS `id_edificio` (`id_edificio`),
	ADD KEY IF NOT EXISTS `id_immobile` (`id_immobile`),
	ADD KEY IF NOT EXISTS `id_vano` (`id_vano`);

-- | 202611042085

-- mastri_tipologie_veicoli: ordine
ALTER TABLE `mastri_tipologie_veicoli`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_mastro`,`id_tipologia`);

-- | 202611042086

-- matricole: id_condizione, id_lotto
ALTER TABLE `matricole`
	ADD COLUMN IF NOT EXISTS `id_lotto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_condizione` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_lotto` (`id_lotto`),
	ADD KEY IF NOT EXISTS `id_condizione` (`id_condizione`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`matricola`,`nome`,`id_articolo`,`id_lotto`,`id_marchio`,`id_produttore`);

-- | 202611042087

-- menu: id_annuncio, id_categoria_marchi, id_marchio, id_notizia, id_prodotto, id_progetto, id_risorsa
ALTER TABLE `menu`
	ADD COLUMN IF NOT EXISTS `id_prodotto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_marchio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_marchi` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_notizia` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_annuncio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_risorsa` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_progetto` bigint(20) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica_prodotto` (`id_prodotto`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_marchio` (`id_marchio`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_categoria_marchi` (`id_categoria_marchi`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_notizia` (`id_notizia`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_annuncio` (`id_annuncio`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_risorsa` (`id_risorsa`,`id_lingua`,`menu`,`nome`,`ancora`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_progetto` (`id_progetto`,`id_lingua`,`menu`,`nome`,`ancora`);

-- | 202611042088

-- messaggi: id_account
ALTER TABLE `messaggi`
	ADD COLUMN IF NOT EXISTS `id_account` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_account` (`id_account`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_conversazione`,`id_account`,`timestamp_invio`);

-- | 202611042089

-- messaggi_account: id_account, id_account_aggiornamento, id_account_inserimento, id_messaggio, ordine, timestamp_aggiornamento, timestamp_inserimento, timestamp_lettura
ALTER TABLE `messaggi_account`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_messaggio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_lettura` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_messaggio`,`id_account`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_account` (`id_account`),
	ADD KEY IF NOT EXISTS `id_messaggio` (`id_messaggio`),
	ADD KEY IF NOT EXISTS `timestamp_lettura` (`timestamp_lettura`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_account`,`id_messaggio`,`timestamp_lettura`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 202611042090

-- metadati: id_asset, id_categoria_marchi, id_marchio, id_vano
ALTER TABLE `metadati`
	ADD COLUMN IF NOT EXISTS `id_marchio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_marchi` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_asset` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_vano` bigint(20) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica_marchio` (`id_marchio`,`id_lingua`,`nome`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_categoria_marchi` (`id_categoria_marchi`,`id_lingua`,`nome`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_asset` (`id_asset`,`id_lingua`,`nome`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_vano` (`id_vano`,`id_lingua`,`nome`);

-- | 202611042091

-- modalita_pagamento: codice_sdi
ALTER TABLE `modalita_pagamento`
	ADD COLUMN IF NOT EXISTS `codice_sdi` char(32) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `codice_sdi` (`codice_sdi`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`nome`,`codice_sdi`);

-- | 202611042092

-- notizie: id_pagina
ALTER TABLE `notizie`
	ADD COLUMN IF NOT EXISTS `id_pagina` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_pagina` (`id_pagina`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_tipologia`,`nome`,`id_sito`,`id_pagina`);

-- | 202611042093

-- notizie_anagrafica: note
ALTER TABLE `notizie_anagrafica`
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL;

-- | 202611042094

-- pagine: codice, id_pagina_contenuti, ordine
ALTER TABLE `pagine`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_pagina_contenuti` bigint(20) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_pagina_contenuti` (`id_pagina_contenuti`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`id_sito`);

-- | 202611042095

-- pianificazioni: delay, iterazioni
ALTER TABLE `pianificazioni`
	ADD COLUMN IF NOT EXISTS `iterazioni` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `delay` int(11) DEFAULT NULL;

-- | 202611042096

-- progetti: uscite_previste
ALTER TABLE `progetti`
	ADD COLUMN IF NOT EXISTS `uscite_previste` decimal(16,2) DEFAULT NULL;

-- | 202611042097

-- progetti_certificazioni: id_ruolo
ALTER TABLE `progetti_certificazioni`
	ADD COLUMN IF NOT EXISTS `id_ruolo` bigint(20) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_progetto`,`id_certificazione`,`id_ruolo`),
	ADD KEY IF NOT EXISTS `id_ruolo` (`id_ruolo`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_progetto`,`id_certificazione`,`id_ruolo`);

-- | 202611042098

-- progetti_matricole: note
ALTER TABLE `progetti_matricole`
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL;

-- | 202611042099

-- provincie: data_archiviazione, id_successore, note_archiviazione
ALTER TABLE `provincie`
	ADD COLUMN IF NOT EXISTS `id_successore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_successore` (`id_successore`),
	ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`);

-- | 202611042100

-- pubblicazioni: id_categoria_marchi, id_sito, schema_html, se_cacheable, se_sitemap, spazio, tema_css, template
ALTER TABLE `pubblicazioni`
	ADD COLUMN IF NOT EXISTS `spazio` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_marchi` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_sito` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `template` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `schema_html` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `tema_css` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_sitemap` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_cacheable` tinyint(1) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `spazio` (`spazio`),
	ADD KEY IF NOT EXISTS `id_categoria_marchi` (`id_categoria_marchi`),
	ADD KEY IF NOT EXISTS `id_sito` (`id_sito`),
	ADD KEY IF NOT EXISTS `template` (`template`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_tipologia`,`ordine`,`id_sito`,`timestamp_inizio`,`timestamp_fine`);

-- | 202611042101

-- ranking: se_collaboratore, se_corriere, se_partner, se_produttore
ALTER TABLE `ranking`
	ADD COLUMN IF NOT EXISTS `se_produttore` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_corriere` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_collaboratore` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_partner` tinyint(1) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `se_produttore` (`se_produttore`),
	ADD KEY IF NOT EXISTS `se_corriere` (`se_corriere`),
	ADD KEY IF NOT EXISTS `se_collaboratore` (`se_collaboratore`),
	ADD KEY IF NOT EXISTS `se_partner` (`se_partner`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`nome`,`se_cliente`,`se_fornitore`,`se_produttore`,`se_corriere`,`se_collaboratore`,`se_partner`);

-- | 202611042102

-- recensioni: id_account, id_annuncio, id_categoria_annunci, id_categoria_marchi, id_categoria_progetti, id_categoria_risorse, id_marchio, id_progetto
ALTER TABLE `recensioni`
	ADD COLUMN IF NOT EXISTS `id_account` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_annuncio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_progetto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_marchio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_marchi` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_risorse` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_annunci` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_progetti` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_account` (`id_account`),
	ADD KEY IF NOT EXISTS `id_annuncio` (`id_annuncio`),
	ADD KEY IF NOT EXISTS `id_progetto` (`id_progetto`),
	ADD KEY IF NOT EXISTS `id_marchio` (`id_marchio`),
	ADD KEY IF NOT EXISTS `id_categoria_marchi` (`id_categoria_marchi`),
	ADD KEY IF NOT EXISTS `id_categoria_risorse` (`id_categoria_risorse`),
	ADD KEY IF NOT EXISTS `id_categoria_annunci` (`id_categoria_annunci`),
	ADD KEY IF NOT EXISTS `id_categoria_progetti` (`id_categoria_progetti`);

-- | 202611042103

-- regimi: codice_sdi
ALTER TABLE `regimi`
	ADD COLUMN IF NOT EXISTS `codice_sdi` char(32) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `codice_sdi` (`codice_sdi`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`nome`,`codice_sdi`);

-- | 202611042104

-- regioni: data_archiviazione, id_successore, note_archiviazione
ALTER TABLE `regioni`
	ADD COLUMN IF NOT EXISTS `id_successore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_successore` (`id_successore`),
	ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`);

-- | 202611042105

-- relazioni_anagrafica: note, ordine
ALTER TABLE `relazioni_anagrafica`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_anagrafica`,`id_anagrafica_collegata`,`id_ruolo`);

-- | 202611042106

-- relazioni_articoli: note, ordine
ALTER TABLE `relazioni_articoli`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_articolo`,`id_articolo_collegato`,`id_prodotto_collegato`,`id_ruolo`);

-- | 202611042107

-- relazioni_categorie_progetti: note, ordine
ALTER TABLE `relazioni_categorie_progetti`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_categoria`,`id_categoria_collegata`,`id_ruolo`);

-- | 202611042108

-- relazioni_documenti: note, ordine
ALTER TABLE `relazioni_documenti`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_documento`,`id_documento_collegato`,`id_ruolo`);

-- | 202611042109

-- relazioni_documenti_articoli: note, ordine
ALTER TABLE `relazioni_documenti_articoli`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_documenti_articolo`,`id_documenti_articolo_collegato`,`id_ruolo`);

-- | 202611042110

-- relazioni_pagamenti: id_ruolo, note, ordine
ALTER TABLE `relazioni_pagamenti`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_ruolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_pagamento`,`id_pagamento_collegato`,`id_ruolo`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_ruolo` (`id_ruolo`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_pagamento`,`id_pagamento_collegato`,`id_ruolo`);

-- | 202611042111

-- relazioni_prodotti: note, ordine
ALTER TABLE `relazioni_prodotti`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_prodotto`,`id_prodotto_collegato`,`id_articolo_collegato`,`id_ruolo`);

-- | 202611042112

-- relazioni_progetti: note, ordine
ALTER TABLE `relazioni_progetti`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_progetto`,`id_progetto_collegato`,`id_ruolo`);

-- | 202611042113

-- relazioni_software: id_ruolo, note, ordine
ALTER TABLE `relazioni_software`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_ruolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_software`,`id_software_collegato`,`id_ruolo`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_ruolo` (`id_ruolo`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_software`,`id_software_collegato`,`id_ruolo`);

-- | 202611042114

-- relazioni_step: id_account_aggiornamento, id_account_inserimento, id_ruolo, id_step, id_step_collegato, note, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `relazioni_step`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_step` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_step_collegato` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_ruolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_step`,`id_step_collegato`,`id_ruolo`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_step` (`id_step`),
	ADD KEY IF NOT EXISTS `id_step_collegato` (`id_step_collegato`),
	ADD KEY IF NOT EXISTS `id_ruolo` (`id_ruolo`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_step`,`id_step_collegato`,`id_ruolo`);

-- | 202611042115

-- risorse: data_archiviazione, id_pagina, note_archiviazione
ALTER TABLE `risorse`
	ADD COLUMN IF NOT EXISTS `id_pagina` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_pagina` (`id_pagina`),
	ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_testata`,`anno_pubblicazione`,`id_sito`,`id_pagina`,`data_archiviazione`);

-- | 202611042116

-- risorse_account: id_carrelli_articoli
ALTER TABLE `risorse_account`
	ADD COLUMN IF NOT EXISTS `id_carrelli_articoli` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_carrelli_articoli` (`id_carrelli_articoli`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_risorsa`,`id_account`,`id_carrelli_articoli`);

-- | 202611042117

-- risorse_anagrafica: note
ALTER TABLE `risorse_anagrafica`
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL;

-- | 202611042118

-- risorse_organizzazioni: id_account_aggiornamento, id_account_inserimento, id_organizzazione, id_risorsa, id_ruolo, note, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `risorse_organizzazioni`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_risorsa` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_organizzazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_ruolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_risorsa`,`id_organizzazione`,`id_ruolo`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_risorsa` (`id_risorsa`),
	ADD KEY IF NOT EXISTS `id_organizzazione` (`id_organizzazione`),
	ADD KEY IF NOT EXISTS `id_ruolo` (`id_ruolo`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_risorsa`,`id_organizzazione`,`id_ruolo`);

-- | 202611042119

-- ritenute: codice_sdi
ALTER TABLE `ritenute`
	ADD COLUMN IF NOT EXISTS `codice_sdi` char(32) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `codice_sdi` (`codice_sdi`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`nome`,`codice_sdi`);

-- | 202611042120

-- ruoli_anagrafica: se_sostituto
ALTER TABLE `ruoli_anagrafica`
	ADD COLUMN IF NOT EXISTS `se_sostituto` tinyint(1) DEFAULT NULL;

-- | 202611042121

-- ruoli_articoli: se_relazioni
ALTER TABLE `ruoli_articoli`
	ADD COLUMN IF NOT EXISTS `se_relazioni` tinyint(1) DEFAULT NULL;

-- | 202611042122

-- ruoli_audio: se_categorie_marchi, se_categorie_progetti, se_edifici, se_file, se_immagini, se_indirizzi, se_progetti, se_valutazioni, se_vani, se_video
ALTER TABLE `ruoli_audio`
	ADD COLUMN IF NOT EXISTS `se_indirizzi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_progetti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_file` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_marchi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_progetti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_edifici` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_valutazioni` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_video` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_immagini` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_vani` tinyint(1) DEFAULT NULL;

-- | 202611042123

-- ruoli_categorie_progetti: se_relazioni
ALTER TABLE `ruoli_categorie_progetti`
	ADD COLUMN IF NOT EXISTS `se_relazioni` tinyint(1) DEFAULT NULL;

-- | 202611042124

-- ruoli_certificazioni: font_awesome, html_entity, id_genitore, nome
ALTER TABLE `ruoli_certificazioni`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`,`id_genitore`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042125

-- ruoli_conversazioni: font_awesome, html_entity, id_genitore, nome
ALTER TABLE `ruoli_conversazioni`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`,`id_genitore`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042126

-- ruoli_file: se_anagrafica_certificazioni, se_annunci, se_attivita, se_audio, se_categorie_annunci, se_categorie_marchi, se_categorie_progetti, se_contratti, se_edifici, se_immagini, se_indirizzi, se_licenze, se_mailing, se_progetti, se_rinnovi, se_todo, se_valutazioni, se_valutazioni_certificazioni, se_vani, se_video
ALTER TABLE `ruoli_file`
	ADD COLUMN IF NOT EXISTS `se_annunci` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_indirizzi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_progetti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_contratti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_todo` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_mailing` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_marchi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_annunci` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_progetti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_edifici` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_valutazioni` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_licenze` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_anagrafica_certificazioni` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_rinnovi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_valutazioni_certificazioni` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_attivita` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_audio` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_video` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_immagini` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_vani` tinyint(1) DEFAULT NULL;

-- | 202611042127

-- ruoli_immagini: se_annunci, se_audio, se_banner, se_categorie_annunci, se_categorie_marchi, se_categorie_progetti, se_contatti, se_contratti, se_edifici, se_indirizzi, se_progetti, se_rinnovi, se_valutazioni, se_vani
ALTER TABLE `ruoli_immagini`
	ADD COLUMN IF NOT EXISTS `se_annunci` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_contatti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_indirizzi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_progetti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_contratti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_marchi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_annunci` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_progetti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_edifici` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_valutazioni` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_rinnovi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_banner` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_audio` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_vani` tinyint(1) DEFAULT NULL;

-- | 202611042128

-- ruoli_matricole: se_progetti, se_todo
ALTER TABLE `ruoli_matricole`
	ADD COLUMN IF NOT EXISTS `se_progetti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_todo` tinyint(1) DEFAULT NULL;

-- | 202611042129

-- ruoli_pagamenti: font_awesome, html_entity, id_genitore, nome, se_relazioni
ALTER TABLE `ruoli_pagamenti`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_relazioni` tinyint(1) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`,`id_genitore`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042130

-- ruoli_prodotti: se_relazioni
ALTER TABLE `ruoli_prodotti`
	ADD COLUMN IF NOT EXISTS `se_relazioni` tinyint(1) DEFAULT NULL;

-- | 202611042131

-- ruoli_progetti: se_relazioni
ALTER TABLE `ruoli_progetti`
	ADD COLUMN IF NOT EXISTS `se_relazioni` tinyint(1) DEFAULT NULL;

-- | 202611042132

-- ruoli_risorse: font_awesome, html_entity, id_genitore, nome, se_organizzazioni
ALTER TABLE `ruoli_risorse`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_organizzazioni` tinyint(1) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`,`id_genitore`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042133

-- ruoli_software: font_awesome, html_entity, id_genitore, nome, se_relazioni
ALTER TABLE `ruoli_software`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_relazioni` tinyint(1) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`,`id_genitore`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042134

-- ruoli_step: font_awesome, html_entity, id_genitore, nome, se_relazioni
ALTER TABLE `ruoli_step`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_relazioni` tinyint(1) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`,`id_genitore`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042135

-- ruoli_video: se_audio, se_categorie_marchi, se_categorie_progetti, se_edifici, se_file, se_immagini, se_indirizzi, se_progetti, se_valutazioni, se_vani
ALTER TABLE `ruoli_video`
	ADD COLUMN IF NOT EXISTS `se_file` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_marchi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_progetti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_progetti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_indirizzi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_edifici` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_valutazioni` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_audio` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_immagini` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_vani` tinyint(1) DEFAULT NULL;

-- | 202611042136

-- sconti_articoli: ordine
ALTER TABLE `sconti_articoli`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_sconto`,`id_articolo`);

-- | 202611042137

-- sconti_categorie_prodotti: id_account_aggiornamento, id_account_inserimento, id_categoria, id_sconto, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `sconti_categorie_prodotti`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_sconto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_sconto`,`id_categoria`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_sconto` (`id_sconto`),
	ADD KEY IF NOT EXISTS `id_categoria` (`id_categoria`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_sconto`,`id_categoria`);

-- | 202611042138

-- sconti_listini: ordine
ALTER TABLE `sconti_listini`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_sconto`,`id_listino`);

-- | 202611042139

-- sconti_marchi: id_account_aggiornamento, id_account_inserimento, id_marchio, id_sconto, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `sconti_marchi`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_sconto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_marchio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_sconto`,`id_marchio`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_sconto` (`id_sconto`),
	ADD KEY IF NOT EXISTS `id_marchio` (`id_marchio`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_sconto`,`id_marchio`);

-- | 202611042140

-- sconti_prodotti: id_account_aggiornamento, id_account_inserimento, id_prodotto, id_sconto, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `sconti_prodotti`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_sconto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_prodotto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_sconto`,`id_prodotto`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_sconto` (`id_sconto`),
	ADD KEY IF NOT EXISTS `id_prodotto` (`id_prodotto`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_sconto`,`id_prodotto`);

-- | 202611042141

-- software: id_prodotto
ALTER TABLE `software`
	ADD COLUMN IF NOT EXISTS `id_prodotto` bigint(20) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_prodotto` (`id_prodotto`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`codice`,`nome`,`id_prodotto`,`id_articolo`);

-- | 202611042142

-- stati: id_successore, note_archiviazione
ALTER TABLE `stati`
	ADD COLUMN IF NOT EXISTS `id_successore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note_archiviazione` text DEFAULT NULL,
	ADD KEY IF NOT EXISTS `id_successore` (`id_successore`);

-- | 202611042143

-- tipologie_asset: font_awesome, html_entity, id_account_aggiornamento, id_account_inserimento, id_genitore, nome, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `tipologie_asset`
	MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT,
	MODIFY COLUMN IF EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	MODIFY COLUMN IF EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	MODIFY COLUMN IF EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(64) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `nome` (`nome`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`ordine`,`nome`);

-- | 202611042144

-- tipologie_campagne: font_awesome, html_entity, id_account_aggiornamento, id_account_inserimento, id_genitore, nome, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `tipologie_campagne`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(64) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `nome` (`nome`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611042145

-- tipologie_documenti_articoli: se_dettaglio, se_evasione
ALTER TABLE `tipologie_documenti_articoli`
	ADD COLUMN IF NOT EXISTS `se_dettaglio` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_evasione` tinyint(1) DEFAULT NULL,
	ADD KEY IF NOT EXISTS `se_dettaglio` (`se_dettaglio`),
	ADD KEY IF NOT EXISTS `se_evasione` (`se_evasione`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`ordine`,`nome`,`sigla`,`se_raggruppamento`,`se_somma`,`se_alternativa`,`se_dettaglio`,`se_evasione`);

-- | 202611042146

-- tipologie_pubblicazioni: se_anteprima
ALTER TABLE `tipologie_pubblicazioni`
	ADD COLUMN IF NOT EXISTS `se_anteprima` tinyint(1) DEFAULT NULL;

-- | 202611042147

-- tipologie_vani: font_awesome, html_entity, id_account_aggiornamento, id_account_inserimento, id_genitore, nome, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `tipologie_vani`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(64) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`),
	ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `nome` (`nome`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`ordine`,`nome`);

-- | 202611042148

-- vani: codice, id_account_aggiornamento, id_account_inserimento, id_immobile, id_tipologia, nome, note, superficie, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `vani`
	ADD COLUMN IF NOT EXISTS `id_tipologia` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_immobile` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `superficie` decimal(16,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_immobile`,`nome`),
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`),
	ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`),
	ADD KEY IF NOT EXISTS `id_immobile` (`id_immobile`),
	ADD KEY IF NOT EXISTS `nome` (`nome`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_immobile`);

-- | 202611042149

-- vani_anagrafica: id_account_aggiornamento, id_account_inserimento, id_anagrafica, id_ruolo, id_vano, note, ordine, timestamp_aggiornamento, timestamp_inserimento
ALTER TABLE `vani_anagrafica`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_vano` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_anagrafica` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_ruolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_vano`,`id_anagrafica`,`id_ruolo`),
	ADD KEY IF NOT EXISTS `id_vano` (`id_vano`),
	ADD KEY IF NOT EXISTS `id_anagrafica` (`id_anagrafica`),
	ADD KEY IF NOT EXISTS `id_ruolo` (`id_ruolo`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_vano`,`id_anagrafica`,`id_ruolo`);

-- | 202611042150

-- vani_caratteristiche: id_account_aggiornamento, id_account_inserimento, id_caratteristica, id_lingua, id_vano, note, ordine, se_assente, timestamp_aggiornamento, timestamp_inserimento, valore
ALTER TABLE `vani_caratteristiche`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_vano` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_caratteristica` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_lingua` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `valore` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_assente` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_vano`,`id_caratteristica`,`id_lingua`),
	ADD KEY IF NOT EXISTS `id_vano` (`id_vano`),
	ADD KEY IF NOT EXISTS `id_caratteristica` (`id_caratteristica`),
	ADD KEY IF NOT EXISTS `id_lingua` (`id_lingua`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY IF NOT EXISTS `indice` (`id`,`ordine`,`id_vano`,`id_caratteristica`,`id_lingua`,`se_assente`);

-- | 202611042151

-- video: id_audio, id_categoria_marchi, id_immagine, id_vano
ALTER TABLE `video`
	ADD COLUMN IF NOT EXISTS `id_categoria_marchi` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_audio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_immagine` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_vano` bigint(20) DEFAULT NULL,
	ADD UNIQUE KEY IF NOT EXISTS `unica_audio` (`id_audio`,`id_ruolo`,`id_lingua`,`path`),
	ADD UNIQUE KEY IF NOT EXISTS `unica_immagine` (`id_immagine`,`id_ruolo`,`id_lingua`,`path`),
	ADD KEY IF NOT EXISTS `id_vano` (`id_vano`),
	ADD KEY IF NOT EXISTS `id_categoria_marchi` (`id_categoria_marchi`);

-- | 202611042152

-- anagrafica_organizzazioni, vincolo
ALTER TABLE `anagrafica_organizzazioni` ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042153

-- anagrafica_organizzazioni, vincolo
ALTER TABLE `anagrafica_organizzazioni` ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_organizzazione`) REFERENCES `organizzazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042154

-- anagrafica_organizzazioni, vincolo
ALTER TABLE `anagrafica_organizzazioni` ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042155

-- anagrafica_organizzazioni, vincolo
ALTER TABLE `anagrafica_organizzazioni` ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042156

-- anagrafica_organizzazioni, vincolo
ALTER TABLE `anagrafica_organizzazioni` ADD CONSTRAINT `anagrafica_organizzazioni_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042157

-- attivita_asset, vincolo
ALTER TABLE `attivita_asset` ADD CONSTRAINT `attivita_asset_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042158

-- attivita_asset, vincolo
ALTER TABLE `attivita_asset` ADD CONSTRAINT `attivita_asset_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_asset`) REFERENCES `asset` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042159

-- attivita_asset, vincolo
ALTER TABLE `attivita_asset` ADD CONSTRAINT `attivita_asset_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042160

-- attivita_asset, vincolo
ALTER TABLE `attivita_asset` ADD CONSTRAINT `attivita_asset_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042161

-- categorie_conversazioni, vincolo
ALTER TABLE `categorie_conversazioni` ADD CONSTRAINT `categorie_conversazioni_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `categorie_conversazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042162

-- categorie_conversazioni, vincolo
ALTER TABLE `categorie_conversazioni` ADD CONSTRAINT `categorie_conversazioni_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042163

-- categorie_conversazioni, vincolo
ALTER TABLE `categorie_conversazioni` ADD CONSTRAINT `categorie_conversazioni_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042164

-- categorie_marchi, vincolo
ALTER TABLE `categorie_marchi` ADD CONSTRAINT `categorie_marchi_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `categorie_marchi` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042165

-- categorie_marchi, vincolo
ALTER TABLE `categorie_marchi` ADD CONSTRAINT `categorie_marchi_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042166

-- categorie_marchi, vincolo
ALTER TABLE `categorie_marchi` ADD CONSTRAINT `categorie_marchi_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042167

-- categorie_marchi, vincolo
ALTER TABLE `categorie_marchi` ADD CONSTRAINT `categorie_marchi_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042168

-- conversazioni_categorie, vincolo
ALTER TABLE `conversazioni_categorie` ADD CONSTRAINT `conversazioni_categorie_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_conversazione`) REFERENCES `conversazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042169

-- conversazioni_categorie, vincolo
ALTER TABLE `conversazioni_categorie` ADD CONSTRAINT `conversazioni_categorie_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_categoria`) REFERENCES `categorie_conversazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042170

-- conversazioni_categorie, vincolo
ALTER TABLE `conversazioni_categorie` ADD CONSTRAINT `conversazioni_categorie_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042171

-- conversazioni_categorie, vincolo
ALTER TABLE `conversazioni_categorie` ADD CONSTRAINT `conversazioni_categorie_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042172

-- edifici_anagrafica, vincolo
ALTER TABLE `edifici_anagrafica` ADD CONSTRAINT `edifici_anagrafica_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042173

-- edifici_anagrafica, vincolo
ALTER TABLE `edifici_anagrafica` ADD CONSTRAINT `edifici_anagrafica_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042174

-- edifici_anagrafica, vincolo
ALTER TABLE `edifici_anagrafica` ADD CONSTRAINT `edifici_anagrafica_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042175

-- edifici_anagrafica, vincolo
ALTER TABLE `edifici_anagrafica` ADD CONSTRAINT `edifici_anagrafica_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042176

-- edifici_anagrafica, vincolo
ALTER TABLE `edifici_anagrafica` ADD CONSTRAINT `edifici_anagrafica_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042177

-- formati_tipologie_corrispondenza, vincolo
ALTER TABLE `formati_tipologie_corrispondenza` ADD CONSTRAINT `formati_tipologie_corrispondenza_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_tipologia`) REFERENCES `tipologie_corrispondenza` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042178

-- formati_tipologie_corrispondenza, vincolo
ALTER TABLE `formati_tipologie_corrispondenza` ADD CONSTRAINT `formati_tipologie_corrispondenza_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_udm_dimensioni`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042179

-- formati_tipologie_corrispondenza, vincolo
ALTER TABLE `formati_tipologie_corrispondenza` ADD CONSTRAINT `formati_tipologie_corrispondenza_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042180

-- formati_tipologie_corrispondenza, vincolo
ALTER TABLE `formati_tipologie_corrispondenza` ADD CONSTRAINT `formati_tipologie_corrispondenza_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042181

-- funnel, vincolo
ALTER TABLE `funnel` ADD CONSTRAINT `funnel_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_campagna`) REFERENCES `campagne` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042182

-- funnel, vincolo
ALTER TABLE `funnel` ADD CONSTRAINT `funnel_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042183

-- funnel, vincolo
ALTER TABLE `funnel` ADD CONSTRAINT `funnel_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042184

-- lotti, vincolo
ALTER TABLE `lotti` ADD CONSTRAINT `lotti_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042185

-- lotti, vincolo
ALTER TABLE `lotti` ADD CONSTRAINT `lotti_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_produttore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042186

-- lotti, vincolo
ALTER TABLE `lotti` ADD CONSTRAINT `lotti_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042187

-- lotti, vincolo
ALTER TABLE `lotti` ADD CONSTRAINT `lotti_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042188

-- marchi_categorie, vincolo
ALTER TABLE `marchi_categorie` ADD CONSTRAINT `marchi_categorie_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042189

-- marchi_categorie, vincolo
ALTER TABLE `marchi_categorie` ADD CONSTRAINT `marchi_categorie_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_categoria`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042190

-- marchi_categorie, vincolo
ALTER TABLE `marchi_categorie` ADD CONSTRAINT `marchi_categorie_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042191

-- marchi_categorie, vincolo
ALTER TABLE `marchi_categorie` ADD CONSTRAINT `marchi_categorie_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042192

-- messaggi_account, vincolo
ALTER TABLE `messaggi_account` ADD CONSTRAINT `messaggi_account_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042193

-- messaggi_account, vincolo
ALTER TABLE `messaggi_account` ADD CONSTRAINT `messaggi_account_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_messaggio`) REFERENCES `messaggi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042194

-- messaggi_account, vincolo
ALTER TABLE `messaggi_account` ADD CONSTRAINT `messaggi_account_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042195

-- messaggi_account, vincolo
ALTER TABLE `messaggi_account` ADD CONSTRAINT `messaggi_account_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042196

-- relazioni_step, vincolo
ALTER TABLE `relazioni_step` ADD CONSTRAINT `relazioni_step_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_step`) REFERENCES `step` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042197

-- relazioni_step, vincolo
ALTER TABLE `relazioni_step` ADD CONSTRAINT `relazioni_step_ibfk_02` FOREIGN KEY IF NOT EXISTS (`id_step_collegato`) REFERENCES `step` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042198

-- relazioni_step, vincolo
ALTER TABLE `relazioni_step` ADD CONSTRAINT `relazioni_step_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_ruolo`) REFERENCES `ruoli_step` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042199

-- relazioni_step, vincolo
ALTER TABLE `relazioni_step` ADD CONSTRAINT `relazioni_step_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042200

-- relazioni_step, vincolo
ALTER TABLE `relazioni_step` ADD CONSTRAINT `relazioni_step_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042201

-- risorse_organizzazioni, vincolo
ALTER TABLE `risorse_organizzazioni` ADD CONSTRAINT `risorse_organizzazioni_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042202

-- risorse_organizzazioni, vincolo
ALTER TABLE `risorse_organizzazioni` ADD CONSTRAINT `risorse_organizzazioni_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_organizzazione`) REFERENCES `organizzazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042203

-- risorse_organizzazioni, vincolo
ALTER TABLE `risorse_organizzazioni` ADD CONSTRAINT `risorse_organizzazioni_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_ruolo`) REFERENCES `ruoli_risorse` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042204

-- risorse_organizzazioni, vincolo
ALTER TABLE `risorse_organizzazioni` ADD CONSTRAINT `risorse_organizzazioni_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042205

-- risorse_organizzazioni, vincolo
ALTER TABLE `risorse_organizzazioni` ADD CONSTRAINT `risorse_organizzazioni_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042206

-- ruoli_certificazioni, vincolo
ALTER TABLE `ruoli_certificazioni` ADD CONSTRAINT `ruoli_certificazioni_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `ruoli_certificazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042207

-- ruoli_conversazioni, vincolo
ALTER TABLE `ruoli_conversazioni` ADD CONSTRAINT `ruoli_conversazioni_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `ruoli_conversazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042208

-- ruoli_pagamenti, vincolo
ALTER TABLE `ruoli_pagamenti` ADD CONSTRAINT `ruoli_pagamenti_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `ruoli_pagamenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042209

-- ruoli_risorse, vincolo
ALTER TABLE `ruoli_risorse` ADD CONSTRAINT `ruoli_risorse_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `ruoli_risorse` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042210

-- ruoli_software, vincolo
ALTER TABLE `ruoli_software` ADD CONSTRAINT `ruoli_software_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `ruoli_software` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042211

-- ruoli_step, vincolo
ALTER TABLE `ruoli_step` ADD CONSTRAINT `ruoli_step_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `ruoli_step` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042212

-- sconti_categorie_prodotti, vincolo
ALTER TABLE `sconti_categorie_prodotti` ADD CONSTRAINT `sconti_categorie_prodotti_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_sconto`) REFERENCES `sconti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042213

-- sconti_categorie_prodotti, vincolo
ALTER TABLE `sconti_categorie_prodotti` ADD CONSTRAINT `sconti_categorie_prodotti_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042214

-- sconti_categorie_prodotti, vincolo
ALTER TABLE `sconti_categorie_prodotti` ADD CONSTRAINT `sconti_categorie_prodotti_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042215

-- sconti_categorie_prodotti, vincolo
ALTER TABLE `sconti_categorie_prodotti` ADD CONSTRAINT `sconti_categorie_prodotti_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042216

-- sconti_marchi, vincolo
ALTER TABLE `sconti_marchi` ADD CONSTRAINT `sconti_marchi_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_sconto`) REFERENCES `sconti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042217

-- sconti_marchi, vincolo
ALTER TABLE `sconti_marchi` ADD CONSTRAINT `sconti_marchi_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042218

-- sconti_marchi, vincolo
ALTER TABLE `sconti_marchi` ADD CONSTRAINT `sconti_marchi_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042219

-- sconti_marchi, vincolo
ALTER TABLE `sconti_marchi` ADD CONSTRAINT `sconti_marchi_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042220

-- sconti_prodotti, vincolo
ALTER TABLE `sconti_prodotti` ADD CONSTRAINT `sconti_prodotti_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_sconto`) REFERENCES `sconti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042221

-- sconti_prodotti, vincolo
ALTER TABLE `sconti_prodotti` ADD CONSTRAINT `sconti_prodotti_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042222

-- sconti_prodotti, vincolo
ALTER TABLE `sconti_prodotti` ADD CONSTRAINT `sconti_prodotti_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042223

-- sconti_prodotti, vincolo
ALTER TABLE `sconti_prodotti` ADD CONSTRAINT `sconti_prodotti_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042224

-- tipologie_asset, vincolo
ALTER TABLE `tipologie_asset` ADD CONSTRAINT `tipologie_asset_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `tipologie_asset` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042225

-- tipologie_asset, vincolo
ALTER TABLE `tipologie_asset` ADD CONSTRAINT `tipologie_asset_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042226

-- tipologie_asset, vincolo
ALTER TABLE `tipologie_asset` ADD CONSTRAINT `tipologie_asset_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042227

-- tipologie_campagne, vincolo
ALTER TABLE `tipologie_campagne` ADD CONSTRAINT `tipologie_campagne_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `tipologie_campagne` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042228

-- tipologie_campagne, vincolo
ALTER TABLE `tipologie_campagne` ADD CONSTRAINT `tipologie_campagne_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042229

-- tipologie_campagne, vincolo
ALTER TABLE `tipologie_campagne` ADD CONSTRAINT `tipologie_campagne_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042230

-- tipologie_vani, vincolo
ALTER TABLE `tipologie_vani` ADD CONSTRAINT `tipologie_vani_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `tipologie_vani` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042231

-- tipologie_vani, vincolo
ALTER TABLE `tipologie_vani` ADD CONSTRAINT `tipologie_vani_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042232

-- tipologie_vani, vincolo
ALTER TABLE `tipologie_vani` ADD CONSTRAINT `tipologie_vani_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042233

-- vani, vincolo
ALTER TABLE `vani` ADD CONSTRAINT `vani_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042234

-- vani, vincolo
ALTER TABLE `vani` ADD CONSTRAINT `vani_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_tipologia`) REFERENCES `tipologie_vani` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042235

-- vani, vincolo
ALTER TABLE `vani` ADD CONSTRAINT `vani_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042236

-- vani, vincolo
ALTER TABLE `vani` ADD CONSTRAINT `vani_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042237

-- vani_anagrafica, vincolo
ALTER TABLE `vani_anagrafica` ADD CONSTRAINT `vani_anagrafica_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_vano`) REFERENCES `vani` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042238

-- vani_anagrafica, vincolo
ALTER TABLE `vani_anagrafica` ADD CONSTRAINT `vani_anagrafica_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042239

-- vani_anagrafica, vincolo
ALTER TABLE `vani_anagrafica` ADD CONSTRAINT `vani_anagrafica_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042240

-- vani_anagrafica, vincolo
ALTER TABLE `vani_anagrafica` ADD CONSTRAINT `vani_anagrafica_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042241

-- vani_anagrafica, vincolo
ALTER TABLE `vani_anagrafica` ADD CONSTRAINT `vani_anagrafica_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042242

-- vani_caratteristiche, vincolo
ALTER TABLE `vani_caratteristiche` ADD CONSTRAINT `vani_caratteristiche_ibfk_01` FOREIGN KEY IF NOT EXISTS (`id_vano`) REFERENCES `vani` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042243

-- vani_caratteristiche, vincolo
ALTER TABLE `vani_caratteristiche` ADD CONSTRAINT `vani_caratteristiche_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042244

-- vani_caratteristiche, vincolo
ALTER TABLE `vani_caratteristiche` ADD CONSTRAINT `vani_caratteristiche_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042245

-- vani_caratteristiche, vincolo
ALTER TABLE `vani_caratteristiche` ADD CONSTRAINT `vani_caratteristiche_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042246

-- vani_caratteristiche, vincolo
ALTER TABLE `vani_caratteristiche` ADD CONSTRAINT `vani_caratteristiche_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042247

-- account, vincolo
ALTER TABLE `account` ADD CONSTRAINT `account_ibfk_05_nofollow` FOREIGN KEY IF NOT EXISTS (`id_organizzazione`) REFERENCES `organizzazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042248

-- asset, vincolo
ALTER TABLE `asset` ADD CONSTRAINT `asset_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `asset` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042249

-- asset, vincolo
ALTER TABLE `asset` ADD CONSTRAINT `asset_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_condizione`) REFERENCES `condizioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042250

-- attivita, vincolo
ALTER TABLE `attivita` ADD CONSTRAINT `attivita_ibfk_28_nofollow` FOREIGN KEY IF NOT EXISTS (`id_banner`) REFERENCES `banner` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042251

-- attivita, vincolo
ALTER TABLE `attivita` ADD CONSTRAINT `attivita_ibfk_29_nofollow` FOREIGN KEY IF NOT EXISTS (`id_pubblicazione`) REFERENCES `pubblicazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042252

-- attivita, vincolo
ALTER TABLE `attivita` ADD CONSTRAINT `attivita_ibfk_30_nofollow` FOREIGN KEY IF NOT EXISTS (`id_redirect`) REFERENCES `redirect` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042253

-- audio, vincolo
ALTER TABLE `audio` ADD CONSTRAINT `audio_ibfk_13` FOREIGN KEY IF NOT EXISTS (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042254

-- audio, vincolo
ALTER TABLE `audio` ADD CONSTRAINT `audio_ibfk_22` FOREIGN KEY IF NOT EXISTS (`id_video`) REFERENCES `video` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042255

-- audio, vincolo
ALTER TABLE `audio` ADD CONSTRAINT `audio_ibfk_23` FOREIGN KEY IF NOT EXISTS (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042256

-- audio, vincolo
ALTER TABLE `audio` ADD CONSTRAINT `audio_ibfk_24` FOREIGN KEY IF NOT EXISTS (`id_vano`) REFERENCES `vani` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042257

-- badge, vincolo
ALTER TABLE `badge` ADD CONSTRAINT `badge_ibfk_02` FOREIGN KEY IF NOT EXISTS (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042258

-- banner, vincolo
ALTER TABLE `banner` ADD CONSTRAINT `banner_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_affiliazione`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042259

-- campagne, vincolo
ALTER TABLE `campagne` ADD CONSTRAINT `campagne_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `campagne` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042260

-- campagne, vincolo
ALTER TABLE `campagne` ADD CONSTRAINT `campagne_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_tipologia`) REFERENCES `tipologie_campagne` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042261

-- campagne, vincolo
ALTER TABLE `campagne` ADD CONSTRAINT `campagne_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_valuta`) REFERENCES `valute` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042262

-- comuni, vincolo
ALTER TABLE `comuni` ADD CONSTRAINT `comuni_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_successore`) REFERENCES `comuni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042263

-- contatti, vincolo
ALTER TABLE `contatti` ADD CONSTRAINT `contatti_ibfk_97_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_archiviazione`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042264

-- contenuti, vincolo
ALTER TABLE `contenuti` ADD CONSTRAINT `contenuti_ibfk_08` FOREIGN KEY IF NOT EXISTS (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042265

-- contenuti, vincolo
ALTER TABLE `contenuti` ADD CONSTRAINT `contenuti_ibfk_30` FOREIGN KEY IF NOT EXISTS (`id_vano`) REFERENCES `vani` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042266

-- contratti, vincolo
ALTER TABLE `contratti` ADD CONSTRAINT `contratti_ibfk_97_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_archiviazione`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042267

-- corrispondenza, vincolo
ALTER TABLE `corrispondenza` ADD CONSTRAINT `corrispondenza_ibfk_12_nofollow` FOREIGN KEY IF NOT EXISTS (`id_udm_peso`) REFERENCES `udm` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042268

-- documenti, vincolo
ALTER TABLE `documenti` ADD CONSTRAINT `documenti_ibfk_19_nofollow` FOREIGN KEY IF NOT EXISTS (`id_carrelli_articoli`) REFERENCES `carrelli_articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042269

-- documenti, vincolo
ALTER TABLE `documenti` ADD CONSTRAINT `documenti_ibfk_97_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_archiviazione`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042270

-- documenti_articoli, vincolo
ALTER TABLE `documenti_articoli` ADD CONSTRAINT `documenti_articoli_ibfk_24_nofollow` FOREIGN KEY IF NOT EXISTS (`id_carrello`) REFERENCES `carrelli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042271

-- documenti_articoli, vincolo
ALTER TABLE `documenti_articoli` ADD CONSTRAINT `documenti_articoli_ibfk_25_nofollow` FOREIGN KEY IF NOT EXISTS (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042272

-- documenti_articoli, vincolo
ALTER TABLE `documenti_articoli` ADD CONSTRAINT `documenti_articoli_ibfk_26_nofollow` FOREIGN KEY IF NOT EXISTS (`id_lotto`) REFERENCES `lotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042273

-- edifici, vincolo
ALTER TABLE `edifici` ADD CONSTRAINT `edifici_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_genitore`) REFERENCES `edifici` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042274

-- edifici_caratteristiche, vincolo
ALTER TABLE `edifici_caratteristiche` ADD CONSTRAINT `edifici_caratteristiche_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042275

-- immobili_caratteristiche, vincolo
ALTER TABLE `immobili_caratteristiche` ADD CONSTRAINT `immobili_caratteristiche_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042276

-- indirizzi_caratteristiche, vincolo
ALTER TABLE `indirizzi_caratteristiche` ADD CONSTRAINT `indirizzi_caratteristiche_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042277

-- luoghi, vincolo
ALTER TABLE `luoghi` ADD CONSTRAINT `luoghi_ibfk_06_nofollow` FOREIGN KEY IF NOT EXISTS (`id_vano`) REFERENCES `vani` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042278

-- macro, vincolo
ALTER TABLE `macro` ADD CONSTRAINT `macro_ibfk_05` FOREIGN KEY IF NOT EXISTS (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042279

-- macro, vincolo
ALTER TABLE `macro` ADD CONSTRAINT `macro_ibfk_06` FOREIGN KEY IF NOT EXISTS (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042280

-- mailing_mail, vincolo
ALTER TABLE `mailing_mail` ADD CONSTRAINT `mailing_mail_ibfk_04_nofollow` FOREIGN KEY IF NOT EXISTS (`id_mail_sent`) REFERENCES `mail_sent` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042281

-- marchi, vincolo
ALTER TABLE `marchi` ADD CONSTRAINT `marchi_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042282

-- mastri, vincolo
ALTER TABLE `mastri` ADD CONSTRAINT `mastri_ibfk_07_nofollow` FOREIGN KEY IF NOT EXISTS (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042283

-- mastri, vincolo
ALTER TABLE `mastri` ADD CONSTRAINT `mastri_ibfk_08_nofollow` FOREIGN KEY IF NOT EXISTS (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042284

-- mastri, vincolo
ALTER TABLE `mastri` ADD CONSTRAINT `mastri_ibfk_09_nofollow` FOREIGN KEY IF NOT EXISTS (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042285

-- mastri, vincolo
ALTER TABLE `mastri` ADD CONSTRAINT `mastri_ibfk_10_nofollow` FOREIGN KEY IF NOT EXISTS (`id_vano`) REFERENCES `vani` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042286

-- matricole, vincolo
ALTER TABLE `matricole` ADD CONSTRAINT `matricole_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_lotto`) REFERENCES `lotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042287

-- matricole, vincolo
ALTER TABLE `matricole` ADD CONSTRAINT `matricole_ibfk_05_nofollow` FOREIGN KEY IF NOT EXISTS (`id_condizione`) REFERENCES `condizioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042288

-- menu, vincolo
ALTER TABLE `menu` ADD CONSTRAINT `menu_ibfk_02` FOREIGN KEY IF NOT EXISTS (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042289

-- menu, vincolo
ALTER TABLE `menu` ADD CONSTRAINT `menu_ibfk_04` FOREIGN KEY IF NOT EXISTS (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042290

-- menu, vincolo
ALTER TABLE `menu` ADD CONSTRAINT `menu_ibfk_05` FOREIGN KEY IF NOT EXISTS (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042291

-- menu, vincolo
ALTER TABLE `menu` ADD CONSTRAINT `menu_ibfk_06` FOREIGN KEY IF NOT EXISTS (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042292

-- menu, vincolo
ALTER TABLE `menu` ADD CONSTRAINT `menu_ibfk_07` FOREIGN KEY IF NOT EXISTS (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042293

-- menu, vincolo
ALTER TABLE `menu` ADD CONSTRAINT `menu_ibfk_10` FOREIGN KEY IF NOT EXISTS (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042294

-- menu, vincolo
ALTER TABLE `menu` ADD CONSTRAINT `menu_ibfk_12` FOREIGN KEY IF NOT EXISTS (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042295

-- messaggi, vincolo
ALTER TABLE `messaggi` ADD CONSTRAINT `messaggi_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042296

-- metadati, vincolo
ALTER TABLE `metadati` ADD CONSTRAINT `metadati_ibfk_08` FOREIGN KEY IF NOT EXISTS (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042297

-- metadati, vincolo
ALTER TABLE `metadati` ADD CONSTRAINT `metadati_ibfk_09` FOREIGN KEY IF NOT EXISTS (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042298

-- metadati, vincolo
ALTER TABLE `metadati` ADD CONSTRAINT `metadati_ibfk_22` FOREIGN KEY IF NOT EXISTS (`id_asset`) REFERENCES `asset` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042299

-- metadati, vincolo
ALTER TABLE `metadati` ADD CONSTRAINT `metadati_ibfk_28` FOREIGN KEY IF NOT EXISTS (`id_vano`) REFERENCES `vani` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042300

-- notizie, vincolo
ALTER TABLE `notizie` ADD CONSTRAINT `notizie_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042301

-- pagine, vincolo
ALTER TABLE `pagine` ADD CONSTRAINT `pagine_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_pagina_contenuti`) REFERENCES `pagine` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042302

-- progetti_certificazioni, vincolo
ALTER TABLE `progetti_certificazioni` ADD CONSTRAINT `progetti_certificazioni_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_ruolo`) REFERENCES `ruoli_certificazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042303

-- provincie, vincolo
ALTER TABLE `provincie` ADD CONSTRAINT `provincie_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_successore`) REFERENCES `provincie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042304

-- pubblicazioni, vincolo
ALTER TABLE `pubblicazioni` ADD CONSTRAINT `pubblicazioni_ibfk_09` FOREIGN KEY IF NOT EXISTS (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042305

-- recensioni, vincolo
ALTER TABLE `recensioni` ADD CONSTRAINT `recensioni_ibfk_01_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042306

-- recensioni, vincolo
ALTER TABLE `recensioni` ADD CONSTRAINT `recensioni_ibfk_02` FOREIGN KEY IF NOT EXISTS (`id_annuncio`) REFERENCES `annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042307

-- recensioni, vincolo
ALTER TABLE `recensioni` ADD CONSTRAINT `recensioni_ibfk_06` FOREIGN KEY IF NOT EXISTS (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042308

-- recensioni, vincolo
ALTER TABLE `recensioni` ADD CONSTRAINT `recensioni_ibfk_09` FOREIGN KEY IF NOT EXISTS (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042309

-- recensioni, vincolo
ALTER TABLE `recensioni` ADD CONSTRAINT `recensioni_ibfk_10` FOREIGN KEY IF NOT EXISTS (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042310

-- recensioni, vincolo
ALTER TABLE `recensioni` ADD CONSTRAINT `recensioni_ibfk_12` FOREIGN KEY IF NOT EXISTS (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042311

-- recensioni, vincolo
ALTER TABLE `recensioni` ADD CONSTRAINT `recensioni_ibfk_15` FOREIGN KEY IF NOT EXISTS (`id_categoria_annunci`) REFERENCES `categorie_annunci` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042312

-- recensioni, vincolo
ALTER TABLE `recensioni` ADD CONSTRAINT `recensioni_ibfk_16` FOREIGN KEY IF NOT EXISTS (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042313

-- regioni, vincolo
ALTER TABLE `regioni` ADD CONSTRAINT `regioni_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_successore`) REFERENCES `regioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042314

-- relazioni_pagamenti, vincolo
ALTER TABLE `relazioni_pagamenti` ADD CONSTRAINT `relazioni_pagamenti_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_ruolo`) REFERENCES `ruoli_pagamenti` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042315

-- relazioni_software, vincolo
ALTER TABLE `relazioni_software` ADD CONSTRAINT `relazioni_software_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_ruolo`) REFERENCES `ruoli_software` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | 202611042316

-- risorse, vincolo
ALTER TABLE `risorse` ADD CONSTRAINT `risorse_ibfk_05_nofollow` FOREIGN KEY IF NOT EXISTS (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042317

-- risorse_account, vincolo
ALTER TABLE `risorse_account` ADD CONSTRAINT `risorse_account_ibfk_03_nofollow` FOREIGN KEY IF NOT EXISTS (`id_carrelli_articoli`) REFERENCES `carrelli_articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042318

-- software, vincolo
ALTER TABLE `software` ADD CONSTRAINT `software_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042319

-- stati, vincolo
ALTER TABLE `stati` ADD CONSTRAINT `stati_ibfk_02_nofollow` FOREIGN KEY IF NOT EXISTS (`id_successore`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611042320

-- video, vincolo
ALTER TABLE `video` ADD CONSTRAINT `video_ibfk_23` FOREIGN KEY IF NOT EXISTS (`id_audio`) REFERENCES `audio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042321

-- video, vincolo
ALTER TABLE `video` ADD CONSTRAINT `video_ibfk_24` FOREIGN KEY IF NOT EXISTS (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042322

-- video, vincolo
ALTER TABLE `video` ADD CONSTRAINT `video_ibfk_25` FOREIGN KEY IF NOT EXISTS (`id_vano`) REFERENCES `vani` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202611042323

-- video, vincolo
ALTER TABLE `video` ADD CONSTRAINT `video_ibfk_26` FOREIGN KEY IF NOT EXISTS (`id_categoria_marchi`) REFERENCES `categorie_marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | FINE
