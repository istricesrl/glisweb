--
-- VISTE STATICHE
-- ==============
-- questo file contiene le query per la creazione delle tabelle per le view statiche
-- 
-- TODO documentare
--

-- | 080000000400

-- anagrafica_view_static
CREATE TABLE IF NOT EXISTS `anagrafica_view_static` (         --
  `id` int(11) PRIMARY KEY NOT NULL,                          --
  `id_tipologia` int(11) PRIMARY KEY NOT NULL,                --
  `tipologia` char(32) DEFAULT NULL,                          --
  `codice` char(32) DEFAULT NULL,                             --
  `riferimento` char(32) DEFAULT NULL,                        --
  `nome` char(64) DEFAULT NULL,                               --
  `cognome` char(255) DEFAULT NULL,                           --
  `denominazione` char(255) DEFAULT NULL,                     --
  `soprannome` char(128) DEFAULT NULL,                        --
  `sesso` char(1) DEFAULT NULL,                               --
  `codice_fiscale` char(32) DEFAULT NULL,                     --
  `partita_iva` char(32) DEFAULT NULL,                        --
  `id_ranking` int(11) DEFAULT NULL,                          --
  `ranking` char(128) DEFAULT NULL,                           --
  `recapiti` text,                                            --
  `id_stato` int(11) DEFAULT NULL,                            --
  `id_provincia` int(11) DEFAULT NULL,                        --
  `se_prospect` tinyint(1) DEFAULT NULL,                      --
  `se_lead` tinyint(1) DEFAULT NULL,                          --
  `se_cliente` tinyint(1) DEFAULT NULL,                       --
  `se_fornitore` tinyint(1) DEFAULT NULL,                     --
  `se_produttore` tinyint(1) DEFAULT NULL,                    --
  `se_collaboratore` tinyint(1) DEFAULT NULL,                 --
  `se_interno` tinyint(1) DEFAULT NULL,                       --
  `se_esterno` tinyint(1) DEFAULT NULL,                       --
  `se_commerciale` tinyint(1) DEFAULT NULL,                   --
  `se_concorrente` tinyint(1) DEFAULT NULL,                   --
  `se_gestita` tinyint(1) DEFAULT NULL,                       --
  `se_amministrazione` tinyint(1) DEFAULT NULL,               --
  `se_notizie` tinyint(1) DEFAULT NULL,                       --
  `categorie` text,                                           --
  `telefoni` text,                                            --
  `mail` text,                                                --
  `anno_nascita` char(32),                                    --
  `mese_nascita` char(32),                                    --
  `giorno_nascita` char(32),                                  --
  `data_nascita` char(32),                                    --
  `id_comune_nascita` int(11) DEFAULT NULL,                   --
  `data_archiviazione` date DEFAULT NULL,                     --
  `id_account_inserimento` int(11) DEFAULT NULL,              --
  `timestamp_inserimento` int(11) DEFAULT NULL,               --
  `id_account_aggiornamento` int(11) DEFAULT NULL,            --
  `timestamp_aggiornamento` int(11) DEFAULT NULL,             --
  `__label__` text,                                           --
  UNIQUE KEY `codice` (`codice`)                              --
) ENGINE=MyISAM DEFAULT CHARSET=utf8;                         --

-- | 080000001300

-- articoli_view_static
CREATE TABLE IF NOT EXISTS `articoli_view_static` (
  `id` int(11) PRIMARY KEY NOT NULL,
  `codice` char(32) DEFAULT NULL,                             --
  `id_prodotto` char(32) DEFAULT NULL,
  `prodotto` char(255) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `ean` char(32) DEFAULT NULL,
  `isbn` char(32) DEFAULT NULL,
  `id_reparto` int(11) DEFAULT NULL,
  `id_taglia` int(11) DEFAULT NULL,
  `id_colore` int(11) DEFAULT NULL,
  `id_periodicita` int(11) DEFAULT NULL,
  `periodicita` char(32) DEFAULT NULL,
  `id_tipologia_rinnovo` int(11) DEFAULT NULL,
  `tipologia_rinnovo` char(32) DEFAULT NULL,
  `larghezza` decimal(7,2) DEFAULT NULL,
  `lunghezza` decimal(7,2) DEFAULT NULL,
  `altezza` decimal(7,2) DEFAULT NULL,
  `id_udm_dimensioni` int(11) DEFAULT NULL,
  `udm_dimensioni` char(32) DEFAULT NULL,
  `peso` decimal(7,2) DEFAULT NULL,
  `id_udm_peso` int(11) DEFAULT NULL,
  `udm_peso` char(32) DEFAULT NULL,
  `volume` decimal(7,2) DEFAULT NULL,
  `id_udm_volume` int(11) DEFAULT NULL,
  `udm_volume` char(32) DEFAULT NULL,
  `capacita` decimal(7,2) DEFAULT NULL,
  `id_udm_capacita` int(11) DEFAULT NULL,
  `udm_capacita` char(32) DEFAULT NULL,
  `durata` decimal(7,2) DEFAULT NULL,
  `id_udm_durata` int(11) DEFAULT NULL,
  `udm_durata` char(32) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `id_categorie` char(255) DEFAULT NULL,
  `categorie` char(255) DEFAULT NULL,
  `prezzi` char(255) DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,                     --
  `id_account_inserimento` int(11) DEFAULT NULL,              --
  `timestamp_inserimento` int(11) DEFAULT NULL,               --
  `id_account_aggiornamento` int(11) DEFAULT NULL,            --
  `timestamp_aggiornamento` int(11) DEFAULT NULL,             --
  `__label__` text,                                           --
  UNIQUE KEY `codice` (`codice`)                              --
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- | 080000001800

-- attivita_view_static
CREATE TABLE `attivita_view_static` (                         --
  `id` int(11) PRIMARY KEY NOT NULL,                          --
  `id_tipologia` int(11) DEFAULT NULL,                        --
  `tipologia` char(64) DEFAULT NULL,                          --
  `codice` char(64) DEFAULT NULL,                             --
  `id_cliente` int(11) DEFAULT NULL,                          --
  `codice_cliente` char(64) DEFAULT NULL,                     --
  `cliente` char(255) DEFAULT NULL,                           --
  `id_contatto`	int(11) DEFAULT NULL,                         --
  `contatto`	char(255) DEFAULT NULL,	                      --
  `id_indirizzo` int(11) DEFAULT NULL,                        --
  `indirizzo` text,                                           --
  `id_luogo` int(11) DEFAULT NULL,                            --
  `luogo` char(255) DEFAULT NULL,                             --
  `id_messaggio` int(11) DEFAULT NULL,                        --
  `id_oggetto` int(11) DEFAULT NULL,                          --
  `oggetto` char(255) DEFAULT NULL,                           --
  `data_riferimento` date DEFAULT NULL,                       --
  `ora_inizio_riferimento` time DEFAULT NULL,                 --
  `ora_fine_riferimento` time DEFAULT NULL,                   --
  `anagrafica_riferimento` char(255) DEFAULT NULL,            --
  `data_scadenza` date DEFAULT NULL,                          --
  `ora_scadenza` time DEFAULT NULL,                           --
  `data_programmazione` date DEFAULT NULL,                    --
  `ora_inizio_programmazione` time DEFAULT NULL,              --
  `ora_fine_programmazione` time DEFAULT NULL,                --
  `id_anagrafica_programmazione` int(11) DEFAULT NULL,        --
  `anagrafica_programmazione` char(255) DEFAULT NULL,         --
  `ore_programmazione` decimal(5,2) DEFAULT NULL,             --
  `se_confermata` int(1) DEFAULT NULL,                        --
  `data_attivita` date DEFAULT NULL,                          --
  `giorno_attivita` int(2) DEFAULT NULL,                      --
  `mese_attivita` int(2) DEFAULT NULL,                        --
  `anno_attivita` int(4) DEFAULT NULL,                        --
  `ora_inizio` time DEFAULT NULL,                             --
  `latitudine_ora_inizio` decimal(11,7) DEFAULT NULL,         --
  `longitudine_ora_inizio` decimal(11,7) DEFAULT NULL,        --
  `data_fine` date DEFAULT NULL,                              --
  `ora_fine` time DEFAULT NULL,                               --
  `latitudine_ora_fine` decimal(11,7) DEFAULT NULL,           --
  `longitudine_ora_fine` decimal(11,7) DEFAULT NULL,          --
  `id_anagrafica` int(11) DEFAULT NULL,                       --
  `anagrafica` char(255) DEFAULT NULL,                        --
  `id_account` int(11) DEFAULT NULL,                          --
  `id_asset` int(11) DEFAULT NULL,                            --
  `asset` char(255) DEFAULT NULL,                             --
  `ore` decimal(5,2) DEFAULT NULL,                            --
  `id_articolo` char(32) DEFAULT NULL,                        --
  `quantita_prevista` decimal(9,2) DEFAULT NULL,              --
  `nome` char(255) DEFAULT NULL,                              --
  `id_documento` int(11) DEFAULT NULL,                        --
  `documento` char(255) DEFAULT NULL,                         --
  `id_corrispondenza` int(11) DEFAULT NULL,                   --
  `corrispondenza` char(255) DEFAULT NULL,                    --
  `id_progetto` char(32) DEFAULT NULL,                        --
  `progetto` char(255) DEFAULT NULL,                          --
  `id_contratto` int(11) DEFAULT NULL,                        --
  `contratto` char(255) DEFAULT NULL,                         --
  `discipline` char(255) DEFAULT NULL,                        --
  `id_matricola` int(11) DEFAULT NULL,                        --
  `id_immobile` int(11) DEFAULT NULL,                         --
  `id_step` int(11) DEFAULT NULL,                             --
  `step` char(255) DEFAULT NULL,                              --
  `id_pianificazione`	int(11) DEFAULT NULL,                 --
  `id_todo` int(11) DEFAULT NULL,                             --
  `todo` char(255) DEFAULT NULL,                              --
  `id_mastro_provenienza` int(11) DEFAULT NULL,               --
  `mastro_provenienza` char(64) DEFAULT NULL,                 --
  `id_mastro_destinazione` int(11) DEFAULT NULL,              --
  `mastro_destinazione` char(64) DEFAULT NULL,                --
  `codice_archivium` char(128) DEFAULT NULL,                  --
  `token` char(128) DEFAULT NULL,                             --
  `id_account_inserimento` int(11) DEFAULT NULL,              --
  `timestamp_inserimento` int(11) DEFAULT NULL,               --
  `id_account_aggiornamento` int(11) DEFAULT NULL,            --
  `timestamp_aggiornamento` int(11) DEFAULT NULL,             --
  `data_archiviazione` date DEFAULT NULL,                     --
  `__label__` text,                                           --
  UNIQUE KEY `codice` (`codice`)                              --
) ENGINE=MyISAM DEFAULT CHARSET=utf8;                         --

-- | FINE FILE
