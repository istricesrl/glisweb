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
  `se_prospect` int(1) DEFAULT NULL,
  `se_lead` int(1) DEFAULT NULL,
  `se_cliente` int(1) DEFAULT NULL,
  `se_fornitore` int(1) DEFAULT NULL,
  `se_produttore` int(1) DEFAULT NULL,
  `se_collaboratore` int(1) DEFAULT NULL,
  `se_interno` int(1) DEFAULT NULL,
  `se_esterno` int(1) DEFAULT NULL,
  `se_commerciale` int(1) DEFAULT NULL,
  `se_concorrente` int(1) DEFAULT NULL,
  `se_gestita` int(1) DEFAULT NULL,
  `se_amministrazione` int(1) DEFAULT NULL,
  `se_notizie` int(1) DEFAULT NULL,
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
  `__label__` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- | 080000001800

-- attivita_view_static
-- tipologia: tabella gestita
-- verifica: 2021-05-28 13:12 Fabio Mosti
CREATE TABLE `attivita_view_static` (
  `id` int(11) PRIMARY KEY NOT NULL,
  `id_tipologia` int DEFAULT NULL,
  `tipologia` char(64) DEFAULT NULL,
  `id_cliente` int DEFAULT NULL,
  `cliente` char(255) DEFAULT NULL,
  `id_contatto`	int(11) DEFAULT NULL,
  `contatto`	char(255) DEFAULT NULL,	
  `id_indirizzo` int DEFAULT NULL,
  `indirizzo` text,
  `id_luogo` int DEFAULT NULL,
  `luogo` char(255) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `id_anagrafica_programmazione` int DEFAULT NULL,
  `anagrafica_programmazione` char(255) DEFAULT NULL,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `data_attivita` date DEFAULT NULL,
  `giorno_attivita` int DEFAULT NULL,
  `mese_attivita` int DEFAULT NULL,
  `anno_attivita` int DEFAULT NULL,
  `ora_inizio` time DEFAULT NULL,
  `latitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `latitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `anagrafica` char(255) DEFAULT NULL,
  `ore` decimal(5,2) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_documento` int DEFAULT NULL,
  `documento` char(255) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `progetto` char(255) DEFAULT NULL,
  `id_matricola` int DEFAULT NULL,
  `id_immobile` int DEFAULT NULL,
  `id_pianificazione`	int(11) DEFAULT NULL,
  `id_todo` int DEFAULT NULL,
  `todo` char(255) DEFAULT NULL,
  `id_mastro_provenienza` int DEFAULT NULL,
  `mastro_provenienza` char(64) DEFAULT NULL,
  `id_mastro_destinazione` int DEFAULT NULL,
  `mastro_destinazione` char(64) DEFAULT NULL,
  `codice_archivium` char(128) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
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
  `id_tipologia` int DEFAULT NULL,
  `tipologia` char(64) DEFAULT NULL,
  `se_agenda` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `anagrafica` char(255) DEFAULT NULL,
  `id_cliente` int DEFAULT NULL,
  `cliente` char(255) DEFAULT NULL,
  `id_indirizzo` int DEFAULT NULL,
  `indirizzo` char(255) DEFAULT NULL,
  `id_luogo` int DEFAULT NULL,
  `luogo` char(255) DEFAULT NULL,
  `timestamp_apertura` int DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `anno_programmazione` year DEFAULT NULL,
  `settimana_programmazione` int DEFAULT NULL,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `data_chiusura` char(21) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_contatto` int DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_pianificazione` int DEFAULT NULL,
  `id_immobile` int DEFAULT NULL,
  `data_archiviazione` char(32) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `__label__` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- | FINE FILE
