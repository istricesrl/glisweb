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
  `id` bigint(20) PRIMARY KEY NOT NULL,                          --
  `id_tipologia` bigint(20) DEFAULT NULL,                         --
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
  `id_ranking` bigint(20) DEFAULT NULL,                          --
  `ranking` char(128) DEFAULT NULL,                           --
  `recapiti` text,                                            --
  `id_stato` bigint(20) DEFAULT NULL,                            --
  `id_provincia` bigint(20) DEFAULT NULL,                        --
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
  `id_comune_nascita` bigint(20) DEFAULT NULL,                   --
  `data_archiviazione` date DEFAULT NULL,                     --
  `id_account_inserimento` bigint(20) DEFAULT NULL,              --
  `timestamp_inserimento` int(11) DEFAULT NULL,               --
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            --
  `timestamp_aggiornamento` int(11) DEFAULT NULL,             --
  `__label__` text,                                           --
  UNIQUE KEY `codice` (`codice`)                              --
) ENGINE=MyISAM DEFAULT CHARSET=utf8;                         --

-- | 080000001300

-- articoli_view_static
CREATE TABLE IF NOT EXISTS `articoli_view_static` (
  `id` bigint(20) PRIMARY KEY NOT NULL,
  `codice` char(32) DEFAULT NULL,                             --
  `id_prodotto` char(32) DEFAULT NULL,
  `prodotto` char(255) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `ean` char(32) DEFAULT NULL,
  `isbn` char(32) DEFAULT NULL,
  `id_reparto` bigint(20) DEFAULT NULL,
  `id_taglia` bigint(20) DEFAULT NULL,
  `id_colore` bigint(20) DEFAULT NULL,
  `id_periodicita` bigint(20) DEFAULT NULL,
  `periodicita` char(32) DEFAULT NULL,
  `id_tipologia_rinnovo` bigint(20) DEFAULT NULL,
  `tipologia_rinnovo` char(32) DEFAULT NULL,
  `larghezza` decimal(7,2) DEFAULT NULL,
  `lunghezza` decimal(7,2) DEFAULT NULL,
  `altezza` decimal(7,2) DEFAULT NULL,
  `id_udm_dimensioni` bigint(20) DEFAULT NULL,
  `udm_dimensioni` char(32) DEFAULT NULL,
  `peso` decimal(7,2) DEFAULT NULL,
  `id_udm_peso` bigint(20) DEFAULT NULL,
  `udm_peso` char(32) DEFAULT NULL,
  `volume` decimal(7,2) DEFAULT NULL,
  `id_udm_volume` bigint(20) DEFAULT NULL,
  `udm_volume` char(32) DEFAULT NULL,
  `capacita` decimal(7,2) DEFAULT NULL,
  `id_udm_capacita` bigint(20) DEFAULT NULL,
  `udm_capacita` char(32) DEFAULT NULL,
  `durata` decimal(7,2) DEFAULT NULL,
  `id_udm_durata` bigint(20) DEFAULT NULL,
  `udm_durata` char(32) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `id_categorie` char(255) DEFAULT NULL,
  `categorie` char(255) DEFAULT NULL,
  `prezzi` char(255) DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,                     --
  `id_account_inserimento` bigint(20) DEFAULT NULL,              --
  `timestamp_inserimento` int(11) DEFAULT NULL,               --
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            --
  `timestamp_aggiornamento` int(11) DEFAULT NULL,             --
  `__label__` text,                                           --
  UNIQUE KEY `codice` (`codice`)                              --
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- | 080000001800

-- attivita_view_static
CREATE TABLE `attivita_view_static` (                         --
  `id` bigint(20) PRIMARY KEY NOT NULL,                          --
  `id_tipologia` bigint(20) DEFAULT NULL,                        --
  `tipologia` char(64) DEFAULT NULL,                          --
  `codice` char(64) DEFAULT NULL,                             --
  `id_cliente` bigint(20) DEFAULT NULL,                          --
  `codice_cliente` char(64) DEFAULT NULL,                     --
  `cliente` char(255) DEFAULT NULL,                           --
  `id_contatto`	bigint(20) DEFAULT NULL,                         --
  `contatto`	char(255) DEFAULT NULL,	                      --
  `id_indirizzo` bigint(20) DEFAULT NULL,                        --
  `indirizzo` text,                                           --
  `id_luogo` bigint(20) DEFAULT NULL,                            --
  `luogo` char(255) DEFAULT NULL,                             --
  `id_messaggio` bigint(20) DEFAULT NULL,                        --
  `id_oggetto` bigint(20) DEFAULT NULL,                          --
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
  `id_anagrafica_programmazione` bigint(20) DEFAULT NULL,        --
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
  `id_anagrafica` bigint(20) DEFAULT NULL,                       --
  `anagrafica` char(255) DEFAULT NULL,                        --
  `id_account` bigint(20) DEFAULT NULL,                          --
  `id_asset` bigint(20) DEFAULT NULL,                            --
  `asset` char(255) DEFAULT NULL,                             --
  `ore` decimal(5,2) DEFAULT NULL,                            --
  `id_articolo` char(32) DEFAULT NULL,                        --
  `quantita_prevista` decimal(9,2) DEFAULT NULL,              --
  `nome` char(255) DEFAULT NULL,                              --
  `id_documento` bigint(20) DEFAULT NULL,                        --
  `documento` char(255) DEFAULT NULL,                         --
  `id_corrispondenza` bigint(20) DEFAULT NULL,                   --
  `corrispondenza` char(255) DEFAULT NULL,                    --
  `id_progetto` char(32) DEFAULT NULL,                        --
  `progetto` char(255) DEFAULT NULL,                          --
  `id_contratto` bigint(20) DEFAULT NULL,                        --
  `contratto` char(255) DEFAULT NULL,                         --
  `discipline` char(255) DEFAULT NULL,                        --
  `id_matricola` bigint(20) DEFAULT NULL,                        --
  `id_immobile` bigint(20) DEFAULT NULL,                         --
  `id_step` bigint(20) DEFAULT NULL,                             --
  `step` char(255) DEFAULT NULL,                              --
  `id_pianificazione`	bigint(20) DEFAULT NULL,                 --
  `id_todo` bigint(20) DEFAULT NULL,                             --
  `todo` char(255) DEFAULT NULL,                              --
  `id_mastro_provenienza` bigint(20) DEFAULT NULL,               --
  `mastro_provenienza` char(64) DEFAULT NULL,                 --
  `id_mastro_destinazione` bigint(20) DEFAULT NULL,              --
  `mastro_destinazione` char(64) DEFAULT NULL,                --
  `codice_archivium` char(128) DEFAULT NULL,                  --
  `token` char(128) DEFAULT NULL,                             --
  `id_account_inserimento` bigint(20) DEFAULT NULL,              --
  `timestamp_inserimento` int(11) DEFAULT NULL,               --
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            --
  `timestamp_aggiornamento` int(11) DEFAULT NULL,             --
  `data_archiviazione` date DEFAULT NULL,                     --
  `__label__` text,                                           --
  UNIQUE KEY `codice` (`codice`)                              --
) ENGINE=MyISAM DEFAULT CHARSET=utf8;                         --

-- | 080000002300

-- offerte_attive_view_static
--
-- offerte_attive_view costa: ha nel WHERE anagrafica_check_gestita( a1.id ), una funzione chiamata
-- riga per riga su tutti i documenti. Misurata su 12.705 documenti l'08/09/2026: 13,5 secondi con
-- la funzione, 0,1 senza, e la condizione non ne scarta nemmeno uno. Materializzando la vista quel
-- costo si paga una riga per volta, quando l'offerta si salva, invece che tutto intero a ogni
-- apertura dell'elenco.
--
-- Le colonne sono quelle della vista, piu' timestamp_inserimento e timestamp_aggiornamento come
-- nelle altre statiche: la vista non le espone, e' il task di popolazione a scriverle
-- ( _mod/_0400.documenti/_src/_api/_task/_offerte.attive.view.static.popolazione.php ), che le usa
-- per sapere quali righe sono rimaste indietro.
CREATE TABLE IF NOT EXISTS `offerte_attive_view_static` (     --
  `id` bigint(20) PRIMARY KEY NOT NULL,                       --
  `id_tipologia` bigint(20) DEFAULT NULL,                     --
  `tipologia` char(255) DEFAULT NULL,                         --
  `codice` char(64) DEFAULT NULL,                             --
  `numero` char(32) DEFAULT NULL,                             --
  `sezionale` char(32) DEFAULT NULL,                          --
  `data` date DEFAULT NULL,                                   --
  `nome` char(255) DEFAULT NULL,                              --
  `id_emittente` bigint(20) DEFAULT NULL,                     --
  `emittente` varchar(320) DEFAULT NULL,                      --
  `id_destinatario` bigint(20) DEFAULT NULL,                  --
  `destinatario` varchar(320) DEFAULT NULL,                   --
  `id_mastro_provenienza` bigint(20) DEFAULT NULL,            --
  `mastro_provenienza` char(64) DEFAULT NULL,                 --
  `id_mastro_destinazione` bigint(20) DEFAULT NULL,           --
  `mastro_destinazione` char(64) DEFAULT NULL,                --
  `id_causale` bigint(20) DEFAULT NULL,                       --
  `porto` enum('franco','assegnato','-') DEFAULT NULL,        --
  `id_trasportatore` bigint(20) DEFAULT NULL,                 --
  `id_account_inserimento` bigint(20) DEFAULT NULL,           --
  `timestamp_inserimento` int(11) DEFAULT NULL,               --
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         --
  `timestamp_aggiornamento` int(11) DEFAULT NULL,             --
  `__label__` text,                                           --
  UNIQUE KEY `codice` (`codice`),                             --
  KEY `data` (`data`)                                         --
) ENGINE=MyISAM DEFAULT CHARSET=utf8;                         --

-- | FINE FILE

-- | 080000999020

-- todo_view_static
-- Materializzazione di todo_view. Le colonne devono restare le stesse della vista, nello stesso
-- ordine: refreshStaticView() ci scrive dentro e le due firme vanno tenute insieme.
CREATE TABLE IF NOT EXISTS `todo_view_static` (
  `id` bigint(20) NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `tipologia` char(64) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `se_agenda` tinyint(1) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `anagrafica` char(255) DEFAULT NULL,
  `id_cliente` bigint(20) DEFAULT NULL,
  `cliente` char(255) DEFAULT NULL,
  `id_indirizzo` bigint(20) DEFAULT NULL,
  `indirizzo` char(255) DEFAULT NULL,
  `id_luogo` bigint(20) DEFAULT NULL,
  `luogo` char(255) DEFAULT NULL,
  `timestamp_apertura` int(11) DEFAULT NULL,
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
  `id_contatto` bigint(20) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `progetto` char(255) DEFAULT NULL,
  `discipline` char(255) DEFAULT NULL,
  `id_documento` bigint(20) DEFAULT NULL,
  `documento` char(255) DEFAULT NULL,
  `id_documenti_articoli` bigint(20) DEFAULT NULL,
  `documenti_articoli` char(255) DEFAULT NULL,
  `id_istruzione` bigint(20) DEFAULT NULL,
  `istruzione` char(255) DEFAULT NULL,
  `id_pianificazione` bigint(20) DEFAULT NULL,
  `id_immobile` bigint(20) DEFAULT NULL,
  `data_archiviazione` char(32) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `__label__` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

