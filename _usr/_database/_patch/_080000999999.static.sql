--
-- VISTE STATICHE
-- questo file contiene le query per la creazione delle tabelle per le view statiche
--
-- CRITERI DI VERIFICA
-- una definizione di view statica si può dire verificata se:
-- - le colonne rispecchiano esattamente in ordine le colonne della relativa view
--

-- | 080000000400

-- anagrafica_view_static
-- tipologia: tabella gestita
-- verifica: 2021-05-20 18:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_view_static` (
  `id` int(11) PRIMARY KEY NOT NULL,
  `tipologia` char(32) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `riferimento` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `cognome` char(255) DEFAULT NULL,
  `denominazione` char(255) DEFAULT NULL,
  `soprannome` char(128) DEFAULT NULL,
  `sesso` char(1) DEFAULT NULL,
  `codice_fiscale` char(32) DEFAULT NULL,
  `partita_iva` char(32) DEFAULT NULL,
  `ranking` char(128) DEFAULT NULL,
  `recapiti` text,
  `id_stato` int(11) DEFAULT NULL,
  `id_provincia` int(11) DEFAULT NULL,
  `se_prospect` tinyint(1) DEFAULT NULL,
  `se_lead` tinyint(1) DEFAULT NULL,
  `se_cliente` tinyint(1) DEFAULT NULL,
  `se_fornitore` tinyint(1) DEFAULT NULL,
  `se_produttore` tinyint(1) DEFAULT NULL,
  `se_collaboratore` tinyint(1) DEFAULT NULL,
  `se_interno` tinyint(1) DEFAULT NULL,
  `se_esterno` tinyint(1) DEFAULT NULL,
  `se_commerciale` tinyint(1) DEFAULT NULL,
  `se_concorrente` tinyint(1) DEFAULT NULL,
  `se_gestita` tinyint(1) DEFAULT NULL,
  `se_amministrazione` tinyint(1) DEFAULT NULL,
  `se_notizie` tinyint(1) DEFAULT NULL,
  `categorie` text,
  `telefoni` text,
  `mail` text,
  `anno_nascita` char(32),
  `mese_nascita` char(32),
  `giorno_nascita` char(32),
  `data_nascita` char(32),
  `id_comune_nascita` int(11) DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text,
  UNIQUE KEY `codice` (`codice`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- | 080000000411

-- anagrafica_archiviati_view_static
-- tipologia: tabella gestita
-- verifica: 2021-05-20 18:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_archiviati_view_static` (
  `id` int(11) PRIMARY KEY NOT NULL,
  `tipologia` char(32) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `riferimento` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `cognome` char(255) DEFAULT NULL,
  `denominazione` char(255) DEFAULT NULL,
  `soprannome` char(128) DEFAULT NULL,
  `sesso` char(1) DEFAULT NULL,
  `codice_fiscale` char(32) DEFAULT NULL,
  `partita_iva` char(32) DEFAULT NULL,
  `ranking` char(128) DEFAULT NULL,
  `recapiti` text,
  `id_stato` int(11) DEFAULT NULL,
  `id_provincia` int(11) DEFAULT NULL,
  `se_prospect` tinyint(1) DEFAULT NULL,
  `se_lead` tinyint(1) DEFAULT NULL,
  `se_cliente` tinyint(1) DEFAULT NULL,
  `se_fornitore` tinyint(1) DEFAULT NULL,
  `se_produttore` tinyint(1) DEFAULT NULL,
  `se_collaboratore` tinyint(1) DEFAULT NULL,
  `se_interno` tinyint(1) DEFAULT NULL,
  `se_esterno` tinyint(1) DEFAULT NULL,
  `se_commerciale` tinyint(1) DEFAULT NULL,
  `se_concorrente` tinyint(1) DEFAULT NULL,
  `se_gestita` tinyint(1) DEFAULT NULL,
  `se_amministrazione` tinyint(1) DEFAULT NULL,
  `se_notizie` tinyint(1) DEFAULT NULL,
  `categorie` text,
  `telefoni` text,
  `mail` text,
  `anno_nascita` char(32),
  `mese_nascita` char(32),
  `giorno_nascita` char(32),
  `data_nascita` char(32),
  `id_comune_nascita` int(11) DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text,
  UNIQUE KEY `codice` (`codice`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- | 080000000412

-- anagrafica_attivi_view_static
-- tipologia: tabella gestita
-- verifica: 2021-05-20 18:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_attivi_view_static` (
  `id` int(11) PRIMARY KEY NOT NULL,
  `tipologia` char(32) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `riferimento` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `cognome` char(255) DEFAULT NULL,
  `denominazione` char(255) DEFAULT NULL,
  `soprannome` char(128) DEFAULT NULL,
  `sesso` char(1) DEFAULT NULL,
  `codice_fiscale` char(32) DEFAULT NULL,
  `partita_iva` char(32) DEFAULT NULL,
  `ranking` char(128) DEFAULT NULL,
  `recapiti` text,
  `id_stato` int(11) DEFAULT NULL,
  `id_provincia` int(11) DEFAULT NULL,
  `se_prospect` tinyint(1) DEFAULT NULL,
  `se_lead` tinyint(1) DEFAULT NULL,
  `se_cliente` tinyint(1) DEFAULT NULL,
  `se_fornitore` tinyint(1) DEFAULT NULL,
  `se_produttore` tinyint(1) DEFAULT NULL,
  `se_collaboratore` tinyint(1) DEFAULT NULL,
  `se_interno` tinyint(1) DEFAULT NULL,
  `se_esterno` tinyint(1) DEFAULT NULL,
  `se_commerciale` tinyint(1) DEFAULT NULL,
  `se_concorrente` tinyint(1) DEFAULT NULL,
  `se_gestita` tinyint(1) DEFAULT NULL,
  `se_amministrazione` tinyint(1) DEFAULT NULL,
  `se_notizie` tinyint(1) DEFAULT NULL,
  `categorie` text,
  `telefoni` text,
  `mail` text,
  `anno_nascita` char(32),
  `mese_nascita` char(32),
  `giorno_nascita` char(32),
  `data_nascita` char(32),
  `id_comune_nascita` int(11) DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text,
  UNIQUE KEY `codice` (`codice`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- | 080000001800

-- attivita_view_static
-- tipologia: tabella gestita
-- verifica: 2021-05-28 13:12 Fabio Mosti
CREATE TABLE `attivita_view_static` (
  `id` int(11) PRIMARY KEY NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `tipologia` char(64) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `codice_cliente` char(64) DEFAULT NULL,
  `cliente` char(255) DEFAULT NULL,
  `id_contatto`	int(11) DEFAULT NULL,
  `contatto`	char(255) DEFAULT NULL,	
  `id_indirizzo` int(11) DEFAULT NULL,
  `indirizzo` text,
  `id_luogo` int(11) DEFAULT NULL,
  `luogo` char(255) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `id_anagrafica_programmazione` int(11) DEFAULT NULL,
  `anagrafica_programmazione` char(255) DEFAULT NULL,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `data_attivita` date DEFAULT NULL,
  `giorno_attivita` int(2) DEFAULT NULL,
  `mese_attivita` int(2) DEFAULT NULL,
  `anno_attivita` int(4) DEFAULT NULL,
  `ora_inizio` time DEFAULT NULL,
  `latitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `latitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `anagrafica` char(255) DEFAULT NULL,
  `ore` decimal(5,2) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `documento` char(255) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `progetto` char(255) DEFAULT NULL,
  `discipline` char(255) DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_step` int(11) DEFAULT NULL,
  `step` char(255) DEFAULT NULL,
  `id_pianificazione`	int(11) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `todo` char(255) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `mastro_provenienza` char(64) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `mastro_destinazione` char(64) DEFAULT NULL,
  `codice_archivium` char(128) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- | 080000007800

-- corsi_view_static
CREATE TABLE `corsi_view_static` (
  `id` char(32) PRIMARY KEY NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `tipologia` text DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `cliente` varchar(320) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_periodo` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `entrate_previste` decimal(16,2) DEFAULT NULL,
  `ore_previste` decimal(16,2) DEFAULT NULL,
  `costi_previsti` decimal(16,2) DEFAULT NULL,
  `entrate_accettazione` decimal(16,2) DEFAULT NULL,
  `data_accettazione` date DEFAULT NULL,
  `data_chiusura` date DEFAULT NULL,
  `stato` varchar(8) DEFAULT NULL,
  `entrate_totali` decimal(16,2) DEFAULT NULL,
  `uscite_totali` decimal(16,2) DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `categorie` mediumtext DEFAULT NULL,
  `fasce` mediumtext DEFAULT NULL,
  `discipline` mediumtext DEFAULT NULL,
  `livelli` mediumtext DEFAULT NULL,
  -- `giorni` mediumtext DEFAULT NULL,
  -- `orari` mediumtext DEFAULT NULL,
  -- `giorni_orari` mediumtext DEFAULT NULL,
  -- `luoghi` mediumtext DEFAULT NULL,
  -- `giorni_orari_luoghi` mediumtext DEFAULT NULL,
  `posti_disponibili` mediumtext DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- | 080000015900

-- iscrizioni_view_static
CREATE TABLE `iscrizioni_view_static` (
  `id` int(11) PRIMARY KEY NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `tipologia` char(64) DEFAULT NULL,
  `istituti` mediumtext DEFAULT NULL,
  `iscritti` mediumtext DEFAULT NULL,
  `fasce` mediumtext DEFAULT NULL,
  `discipline` mediumtext DEFAULT NULL,
  `livelli` mediumtext DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `progetto` char(255) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- | 080000060000

-- todo_view_static
-- tipologia: tabella gestita
-- verifica: 2021-05-28 13:12 Fabio Mosti
CREATE TABLE `todo_view_static` (
  `id` int(11) PRIMARY KEY NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `tipologia` char(64) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `se_agenda` tinyint(1) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `anagrafica` char(255) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `cliente` char(255) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `indirizzo` char(255) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
  `luogo` char(255) DEFAULT NULL,
  `timestamp_apertura` int DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `anno_programmazione` int(4) DEFAULT NULL,
  `settimana_programmazione` int(4) DEFAULT NULL,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `data_chiusura` char(21) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_contatto` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `progetto` char(255) DEFAULT NULL,
  `discipline` char(255) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `data_archiviazione` char(32) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- | FINE FILE
