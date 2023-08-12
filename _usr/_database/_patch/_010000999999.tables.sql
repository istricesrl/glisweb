--
-- TABELLE
-- questo file contiene le query per la creazione delle tabelle; si noti che non devono essere inseriti qui i valori
-- di auto increment, mentre vanno specificati per tabella il CHARSET ma non il COLLATE.
--
-- INDICE DEGLI SCRIPT
-- 01 -> tabelle
-- 02 -> placeholder
-- 03 -> indici
-- 04 -> acl
-- 05 -> dati
-- 06 -> limiti
-- 07 -> procedure
-- 08 -> viste
-- 09 -> report
-- 10 -> statiche
-- 11 -> trigger
--
-- CRITERI DI VERIFICA
-- una tabella si può marcare come verificata dopo aver controllato le seguenti cose:
-- - non è deprecata (se lo è, eliminarla)
-- - le colonne corrispondono al database master
-- - l'ordine delle colonne rispetta l'ordine master
-- - le colonne deprecate vanno eliminate
-- - le colonne sono correttamente documentate, in ordine, nel relativo file dox
-- - non viene riportato il valore di AUTO INCREMENT
--

-- | 010000000100

-- account
-- tipologia: tabella gestita
-- verifica: 2021-05-20 13:57 Fabio Mosti
CREATE TABLE IF NOT EXISTS `account` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_mail` int(11) DEFAULT NULL,
  `id_affiliazione` int(11) DEFAULT NULL,
  `username` char(64) DEFAULT NULL,
  `password` char(128) DEFAULT NULL,
  `se_attivo` tinyint(1) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_login` int(11) DEFAULT NULL,
  `timestamp_cambio_password` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000200

-- account_gruppi
-- tipologia: tabella gestita
-- verifica: 2021-05-20 15:56 Fabio Mosti
CREATE TABLE IF NOT EXISTS `account_gruppi` (
  `id` int(11) NOT NULL,
  `id_account` int(11) DEFAULT NULL,
  `id_gruppo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_amministratore` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000300

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
-- verifica: 2021-05-20 17:05 Fabio Mosti
CREATE TABLE IF NOT EXISTS `account_gruppi_attribuzione` (
  `id` int(11) NOT NULL,
  `id_account` int(11) DEFAULT NULL,
  `id_gruppo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `entita` char(64) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000400

-- anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:30 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `riferimento` char(255) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `cognome` char(255) DEFAULT NULL,
  `denominazione` char(255) DEFAULT NULL,
  `soprannome` char(128) DEFAULT NULL,
  `sesso` enum('M','F','-') DEFAULT NULL,
  `stato_civile` char(128) DEFAULT NULL,
  `codice_fiscale` char(32) DEFAULT NULL,
  `partita_iva` char(32) DEFAULT NULL,
  `codice_sdi` char(32) DEFAULT NULL,
  `id_pec_sdi` int(11) DEFAULT NULL,
  `codice_ipa` char(32) DEFAULT NULL,
  `codice_archivium` char(16) DEFAULT NULL,
  `id_regime` int(11) DEFAULT NULL,
  `note_amministrative` text DEFAULT NULL,
  `note_collaborazione` text DEFAULT NULL,
  `luogo_nascita` char(128) DEFAULT NULL,
  `stato_nascita` char(128) DEFAULT NULL,
  `id_stato_nascita` int(11) DEFAULT NULL,
  `comune_nascita` char(128) DEFAULT NULL,
  `id_comune_nascita` int(11) DEFAULT NULL,
  `giorno_nascita` int(2) DEFAULT NULL,
  `mese_nascita` int(2) DEFAULT NULL,
  `anno_nascita` int(4) DEFAULT NULL,
  `id_ranking` int(11) DEFAULT NULL,
  `id_agente` int(11) DEFAULT NULL,
  `id_responsabile_operativo` int(11) DEFAULT NULL,
  `note_commerciali` text DEFAULT NULL,
  `condizioni_vendita` text DEFAULT NULL,
  `condizioni_acquisto` text DEFAULT NULL,
  `note` text DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `note_archiviazione` text DEFAULT NULL,
  `recapiti` text DEFAULT NULL,
  `se_importata` tinyint(1) DEFAULT NULL,
  `se_stampa_privacy` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000500

-- anagrafica_categorie
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:30 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_categorie` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000600

-- anagrafica_certificazioni
-- tipologia: tabella gestita
-- verifica: 2022-02-03 11:12 Chiara GDL
CREATE TABLE `anagrafica_certificazioni` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_certificazione` int(11) DEFAULT NULL,
  `id_emittente` int(11) DEFAULT NULL,
  `nome` char(1) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `data_emissione` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000700

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_cittadinanze` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_stato` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000800

-- anagrafica_consensi
-- tipologia: tabella gestita
-- verifica: 2022-08-23 11:12 Chiara GDL
CREATE TABLE `anagrafica_consensi` (
  `id` int(11) NOT NULL,
  `id_account` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_consenso` char(64) DEFAULT NULL,
  `se_prestato` tinyint(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_consenso` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000900

-- anagrafica_indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-05-21 16:30 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_indirizzi` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `interno` char(8) DEFAULT NULL,
  `indirizzo` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000000940

-- anagrafica_progetti
CREATE TABLE IF NOT EXISTS `anagrafica_progetti` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_attesa` tinyint(1) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `note_inserimento` text NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `note_aggiornamento` text NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  `id_account_archiviazione` int(11) DEFAULT NULL,
  `note_archiviazione` text NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000001200

-- anagrafica_settori
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:38 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_settori` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_settore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000001300

-- articoli
-- tipologia: tabella gestita
-- verifica: 2021-05-25 10:45 Fabio Mosti
CREATE TABLE `articoli` (
  `id` char(32) NOT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `ean` char(32) DEFAULT NULL,
  `isbn` char(32) DEFAULT NULL,
  `id_reparto` int(11) DEFAULT NULL,
  `id_taglia` int(11) DEFAULT NULL,
  `id_colore` int(11) DEFAULT NULL,
  `id_periodicita` int(11) DEFAULT NULL,
  `id_tipologia_rinnovo` int(11) DEFAULT NULL,
  `larghezza` decimal(7,2) DEFAULT NULL,
  `lunghezza` decimal(7,2) DEFAULT NULL,
  `altezza` decimal(7,2) DEFAULT NULL,
  `id_udm_dimensioni` int(11) DEFAULT NULL,
  `peso` decimal(7,2) DEFAULT NULL,
  `id_udm_peso` int(11) DEFAULT NULL,
  `volume` decimal(7,2) DEFAULT NULL,
  `id_udm_volume` int(11) DEFAULT NULL,
  `capacita` decimal(7,2) DEFAULT NULL,
  `id_udm_capacita` int(11) DEFAULT NULL,
  `durata` decimal(7,2) DEFAULT NULL,
  `id_udm_durata` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000001600

-- articoli_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-05-25 11:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `articoli_caratteristiche` (
  `id` int(11) NOT NULL,
  `id_articolo` char(32) NOT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `valore` decimal(5,2) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_assente` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000001800

-- attivita
-- tipologia: tabella gestita
-- verifica: 2021-05-25 17:14 Fabio Mosti
CREATE TABLE IF NOT EXISTS `attivita` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_contatto` int(11) DEFAULT NULL,
  `referenti` char(255) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `note_scadenza` text DEFAULT NULL,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `id_anagrafica_programmazione` int(11) DEFAULT NULL,
  `note_programmazione` text DEFAULT NULL,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `data_attivita` date DEFAULT NULL,
  `ora_inizio` time DEFAULT NULL,
  `latitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `latitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `ore` decimal(5,2) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `note_cliente` text DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL, 
  `codice_archivium` char(32) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_calcolo_sostituti` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002100

-- audio
-- tipologia: tabella gestita
-- verifica: 2021-05-28 15:39 Fabio Mosti
CREATE TABLE IF NOT EXISTS `audio` (
  `id` int(11) NOT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `id_embed` int(11) DEFAULT NULL,
  `codice_embed` char(128) DEFAULT NULL,
  `embed_custom` char(128) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `target` char(255) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_file` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_categoria_progetti` INT(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_edificio` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002250

-- badge
-- tipologia: tabella gestita
CREATE TABLE `badge` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) NULL,
  `id_contratto` int(11) NULL,
  `codice` char(32) NULL,
  `rfid` char(32) NULL,
  `nome` char(255) NULL,
  `note` text NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002300

-- banner
-- tipologia: tabella gestita
-- verifica: 2022-07-20 17:22 Chiara GDL
CREATE TABLE IF NOT EXISTS `banner` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_inserzionista` int(11) DEFAULT NULL,
  `altezza_modulo` int(11) DEFAULT NULL,
  `larghezza_modulo` int(11) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002400

-- banner_azioni
-- tipologia: tabella gestita
-- verifica: 2022-07-21 10:22 Chiara GDL
CREATE TABLE IF NOT EXISTS `banner_azioni` (
  `id` int(11) NOT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_banner` int(11) DEFAULT NULL,
  `azione` enum('visualizzazione','click') DEFAULT NULL,
  `timestamp_azione` int(11) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002500

-- banner_pagine
-- tipologia: tabella gestita
-- verifica: 2022-07-21 10:22 Chiara GDL
CREATE TABLE IF NOT EXISTS `banner_pagine` (
  `id` int(11) NOT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_banner` int(11) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002600

-- banner_zone
-- tipologia: tabella gestita
-- verifica: 2022-08-04 10:22 Chiara GDL
CREATE TABLE IF NOT EXISTS `banner_zone` (
  `id` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_banner` int(11) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002800

-- caratteristiche_immobili
-- tipologia: tabella gestita
-- verifica: 2022-05-02 17:22 Chiara GDL
CREATE TABLE IF NOT EXISTS `caratteristiche_immobili` (
  `id` int(11) NOT NULL,
  `nome` char(128) DEFAULT NULL,
  `font_awesome` char(24) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `se_indirizzo` tinyint(1) DEFAULT NULL,
  `se_edificio` tinyint(1) DEFAULT NULL,
  `se_immobile` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000002900

-- caratteristiche_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-05-28 18:22 Fabio Mosti
CREATE TABLE IF NOT EXISTS `caratteristiche_prodotti` (
  `id` int(11) NOT NULL,
  `nome` char(64) DEFAULT NULL,
  `font_awesome` char(24) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `se_categoria` tinyint(1) DEFAULT NULL,
  `se_prodotto` tinyint(1) DEFAULT NULL,
  `se_articolo` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000003000

-- carrelli
-- tipologia: tabella gestita
-- verifica: 2022-07-12 14:45 Chiara GDL
CREATE TABLE `carrelli` (
  `id` int(11) NOT NULL,
  `session` char(32) DEFAULT NULL,
  `destinatario_nome` char(255) DEFAULT NULL,
  `destinatario_cognome` char(255) DEFAULT NULL,
  `destinatario_denominazione` char(255) DEFAULT NULL,
  `destinatario_id_tipologia_anagrafica` INT(11) DEFAULT NULL,
  `destinatario_id_anagrafica` int(11) DEFAULT NULL,
  `destinatario_id_account` int(11) DEFAULT NULL,
  `destinatario_indirizzo` char(255) DEFAULT NULL,
  `destinatario_cap` char(16) DEFAULT NULL,
  `destinatario_citta` char(255) DEFAULT NULL,
  `destinatario_id_provincia` int(11) DEFAULT NULL,
  `destinatario_id_stato` int(11) DEFAULT NULL,
  `destinatario_telefono` char(255) DEFAULT NULL,
  `destinatario_mail` char(255) DEFAULT NULL,
  `destinatario_codice_fiscale` char(255) DEFAULT NULL,
  `destinatario_partita_iva` char(255) DEFAULT NULL,
  `intestazione_nome` char(255) DEFAULT NULL,
  `intestazione_cognome` char(255) DEFAULT NULL,
  `intestazione_denominazione` char(255) DEFAULT NULL,
  `intestazione_id_tipologia_anagrafica` INT(11) DEFAULT NULL,
  `intestazione_id_anagrafica` int(11) DEFAULT NULL,
  `intestazione_id_account` int(11) DEFAULT NULL,
  `intestazione_indirizzo` char(255) DEFAULT NULL,
  `intestazione_cap` char(16) DEFAULT NULL,
  `intestazione_citta` char(255) DEFAULT NULL,
  `intestazione_id_comune` int(11) DEFAULT NULL,
  `intestazione_id_provincia` int(11) DEFAULT NULL,
  `intestazione_id_stato` int(11) DEFAULT NULL,
  `intestazione_telefono` char(255) DEFAULT NULL,
  `intestazione_mail` char(255) DEFAULT NULL,
  `intestazione_codice_fiscale` char(255) DEFAULT NULL,
  `intestazione_partita_iva` char(255) DEFAULT NULL,
  `intestazione_sdi` char(32) DEFAULT NULL,
  `intestazione_pec` char(255) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `id_listino` int(11) DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `fatturazione_id_tipologia_documento` int(11) DEFAULT NULL,
  `fatturazione_sezionale` char(16) DEFAULT NULL,
  `fatturazione_strategia` enum('SINGOLA','MULTIPLA') DEFAULT NULL,
  `prezzo_netto_totale` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_totale` decimal(16,5) DEFAULT NULL,
  `id_coupon` char(32) DEFAULT NULL,
  `codice_coupon` char(32) DEFAULT NULL,
  `sconto_percentuale_coupon` decimal(16,5) DEFAULT NULL,
  `sconto_valore_coupon` decimal(16,5) DEFAULT NULL,
  `sconto_percentuale` decimal(16,5) DEFAULT NULL,
  `sconto_valore` decimal(16,5) DEFAULT NULL,
  `prezzo_netto_finale` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_finale` decimal(16,5) DEFAULT NULL,
  `provider_checkout` char(128) DEFAULT NULL,
  `timestamp_checkout` int(11) DEFAULT NULL,
  `provider_pagamento` char(64) DEFAULT NULL,
  `timestamp_pagamento` int(11) DEFAULT NULL,
  `codice_pagamento` char(128) DEFAULT NULL,
  `ordine_pagamento` char(128) DEFAULT NULL,
  `status_pagamento` char(128) DEFAULT NULL,
  `importo_pagamento` decimal(16,5) DEFAULT NULL,
  `utm_id` char(128) DEFAULT NULL,
  `utm_source` char(128) DEFAULT NULL,
  `utm_medium` char(128) DEFAULT NULL,
  `utm_campaign` char(128) DEFAULT NULL,
  `utm_term` char(128) DEFAULT NULL,
  `utm_content` char(128) DEFAULT NULL,
  `id_reseller` int(11) DEFAULT NULL,
  `id_affiliato` int(11) DEFAULT NULL,
  `id_affiliazione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000003050

-- carrelli_articoli
-- tipologia: tabella gestita
-- verifica: 2022-07-12 14:45 Chiara GDL
CREATE TABLE `carrelli_articoli` (
  `id` int(11) NOT NULL,
  `id_carrello` int(11) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_iva` int(11) DEFAULT NULL,
  `id_pagamento` int(11) DEFAULT NULL,
  `destinatario_id_anagrafica` int(11) DEFAULT NULL,
  `id_rinnovo` int(11) DEFAULT NULL,
  `prezzo_netto_unitario` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_unitario` decimal(16,5) DEFAULT NULL,
  `quantita` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `prezzo_netto_totale` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_totale` decimal(16,5) DEFAULT NULL,
  `sconto_percentuale` decimal(16,5) DEFAULT NULL,
  `sconto_valore` decimal(16,5) DEFAULT NULL,
  `prezzo_netto_finale` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_finale` decimal(16,5) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000003060

-- carrelli_consensi
-- tipologia: tabella gestita
-- verifica: 2022-08-23 11:12 Chiara GDL
CREATE TABLE `carrelli_consensi` (
  `id` int(11) NOT NULL,
  `id_account` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_carrello` int(11) DEFAULT NULL,
  `id_consenso` char(64) DEFAULT NULL,
  `se_prestato` tinyint(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_consenso` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000003070

-- carrelli_documenti
-- tipologia: tabella gestita
-- verifica: 2022-08-22 11:45 Chiara GDL
CREATE TABLE IF NOT EXISTS `carrelli_documenti` (
  `id` int(11) NOT NULL,
  `id_carrello` int(11) DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000003100

-- categorie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-05-28 19:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_anagrafica` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_lead` tinyint(1) DEFAULT NULL,
  `se_prospect` tinyint(1) DEFAULT NULL,
  `se_cliente` tinyint(1) DEFAULT NULL,
  `se_fornitore` tinyint(1) DEFAULT NULL,
  `se_produttore` tinyint(1) DEFAULT NULL,
  `se_collaboratore` tinyint(1) DEFAULT NULL,
  `se_interno` tinyint(1) DEFAULT NULL,
  `se_esterno` tinyint(1) DEFAULT NULL,
  `se_concorrente` tinyint(1) DEFAULT NULL,
  `se_gestita` tinyint(1) DEFAULT NULL,
  `se_amministrazione` tinyint(1) DEFAULT NULL,
  `se_produzione` tinyint(1) DEFAULT NULL,
  `se_commerciale` tinyint(1) DEFAULT NULL,
  `se_notizie` tinyint(1) DEFAULT NULL,
  `se_corriere` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000003700

-- categorie_notizie
-- tipologia: tabella gestita
-- verifica: 2021-06-01 18:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_notizie` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000003900

-- categorie_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-01 19:43 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_prodotti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000004300

-- categorie_progetti
-- tipologia: tabella gestita
-- verifica: 2021-06-02 19:40 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_progetti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `se_ordinario` tinyint(1) DEFAULT NULL,
  `se_straordinario` tinyint(1) DEFAULT NULL,
  `se_disciplina` tinyint(1) DEFAULT NULL,
  `se_classe` tinyint(1) DEFAULT NULL,  
  `se_fascia` tinyint(1) DEFAULT NULL, 
  `se_periodo` tinyint(1) DEFAULT NULL, 
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000004500

-- categorie_risorse
-- tipologia: tabella gestita
-- verifica: 2021-06-02 20:04 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_risorse` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000004600

-- causali
-- tipologia: tabella gestita
-- verifica: 2022-04-26 11:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `causali` (
  `id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_trasporto` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000004700

-- certificazioni
-- tipologia: tabella assistita
-- verifica: 2022-02-03 11:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `certificazioni` (
  `id` int(11) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000004800

-- chiavi
-- tipologia: tabella gestita
-- verifica: 2021-11-15 12:04 Chiara GDL
CREATE TABLE IF NOT EXISTS `chiavi` (
  `id` int(11) NOT NULL,
  `id_licenza` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `seriale` char(32) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000005000

-- classi_energetiche
-- tipologia: tabella standard
-- verifica: 2022-04-28 22:22 Chiara GDL
CREATE TABLE IF NOT EXISTS `classi_energetiche` (
  `id` int(11) NOT NULL,
  `nome` char(8) DEFAULT NULL,
  `ep_min` int(11) DEFAULT NULL,
  `ep_max` int(11) DEFAULT NULL,
  `rgb` char(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000005050

-- colli
-- tipologia: tabella gestita
-- verifica: 2022-05-04 22:22 Chiara GDL
CREATE TABLE `colli` (
  `id` int(11) NOT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `larghezza` decimal(7,2) DEFAULT NULL,
  `lunghezza` decimal(7,2) DEFAULT NULL,
  `altezza` decimal(7,2) DEFAULT NULL,
  `id_udm_dimensioni` int(11) DEFAULT NULL,
  `peso` decimal(7,2) DEFAULT NULL,
  `id_udm_peso` int(11) DEFAULT NULL,
  `volume` decimal(7,2) DEFAULT NULL,
  `id_udm_volume` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000005100

-- colori
-- tipologia: tabella standard
-- verifica: 2021-06-02 22:22 Fabio Mosti
CREATE TABLE IF NOT EXISTS `colori` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(16) DEFAULT NULL,
  `hex` char(8) DEFAULT NULL,
  `r` int(3) DEFAULT NULL,
  `g` int(3) DEFAULT NULL,
  `b` int(3) DEFAULT NULL,
  `ral` char(16) DEFAULT NULL,
  `pantone` char(8) DEFAULT NULL,
  `c` decimal(5,2) DEFAULT NULL,
  `m` decimal(5,2) DEFAULT NULL,
  `y` decimal(5,2) DEFAULT NULL,
  `k` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000005300

-- comuni
-- tipologia: tabella standard
-- verifica: 2021-06-03 19:53 Fabio Mosti
CREATE TABLE IF NOT EXISTS `comuni` (
  `id` int(11) NOT NULL,
  `id_provincia` int(11) DEFAULT NULL,
  `nome` varchar(254) DEFAULT NULL,
  `codice_istat` char(12) DEFAULT NULL,
  `codice_catasto` char(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000006000

-- condizioni
-- tipologia: tabella standard
-- verifica: 2022-04-28 16:12 Chiara GDL
CREATE TABLE `condizioni` (
  `id` int(11) NOT NULL,
  `nome` char(32) DEFAULT NULL,
  `se_catalogo` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000006200

-- condizioni_pagamento
-- tipologia: tabella standard
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `condizioni_pagamento` (
  `id` int(11) NOT NULL,
  `codice` char(5) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000006400

-- consensi
-- tipologia: tabella gestita
-- verifica: 2022-08-23 11:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `consensi` (
  `id` char(64) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000006500

-- consensi_moduli
-- tipologia: tabella assistita
-- verifica: 2022-08-23 11:12 Chiara GDL
CREATE TABLE `consensi_moduli` (
  `id` int(11) NOT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_consenso` char(64) DEFAULT NULL,
  `modulo` char(32) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `azione` char(32) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `informativa` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `pagina` char(32) DEFAULT NULL,
  `se_richiesto` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000006700

-- contatti
-- tipologia: tabella gestita
-- verifica: 2021-06-03 21:33 Fabio Mosti
CREATE TABLE IF NOT EXISTS `contatti` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_inviante` int(11) DEFAULT NULL,
  `id_ranking` int(11) DEFAULT NULL,
  `utm_id` char(128) DEFAULT NULL,
  `utm_source` char(128) DEFAULT NULL,
  `utm_medium` char(128) DEFAULT NULL,
  `utm_campaign` char(128) DEFAULT NULL,
  `utm_term` char(128) DEFAULT NULL,
  `utm_content` char(128) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `json` text DEFAULT NULL,
  `timestamp_contatto` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000006900

-- contenuti
-- tipologia: tabella gestita
-- verifica: 2021-06-04 17:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `contenuti` (
  `id` int(11) NOT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_caratteristica_prodotti` int(11) DEFAULT NULL,
  `id_marchio` int(11) DEFAULT NULL,
  `id_file` int(11) DEFAULT NULL,
  `id_immagine` int(11) DEFAULT NULL,
  `id_video` int(11) DEFAULT NULL,
  `id_audio` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_popup` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_edificio` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_template` int(11) DEFAULT NULL,
  `id_mailing` int(11) DEFAULT NULL,
  `id_colore` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_categoria_progetti` int(11) DEFAULT NULL,
  `id_banner` int(11) DEFAULT NULL,
  `path_custom` char(255) DEFAULT NULL,
  `url_custom` char(255) DEFAULT NULL,
  `rewrite_custom` char(255) DEFAULT NULL,
  `title` char(255) DEFAULT NULL,
  `keywords` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `alt` char(255) DEFAULT NULL,
  `og_title` char(255) DEFAULT NULL,
  `og_type` char(255) DEFAULT NULL,
  `og_image` char(255) DEFAULT NULL,
  `og_audio` char(255) DEFAULT NULL,
  `og_video` char(255) DEFAULT NULL,
  `og_determiner` char(255) DEFAULT NULL,
  `og_description` char(255) DEFAULT NULL,
  `cappello` text DEFAULT NULL,
  `h1` char(255) DEFAULT NULL,
  `h2` char(255) DEFAULT NULL,
  `h3` char(255) DEFAULT NULL,
  `abstract` text DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `applicazioni` text DEFAULT NULL,
  `specifiche` text DEFAULT NULL,
  `label_menu` char(255) DEFAULT NULL,
  `mittente_nome` char(128) DEFAULT NULL,
  `mittente_numero` char(128) DEFAULT NULL,
  `mittente_mail` char(128) DEFAULT NULL,
  `destinatario_nome` char(128) DEFAULT NULL,
  `destinatario_numero` char(128) DEFAULT NULL,
  `destinatario_mail` char(128) DEFAULT NULL,
  `destinatario_cc_nome` char(128) DEFAULT NULL,
  `destinatario_cc_mail` char(128) DEFAULT NULL,
  `destinatario_ccn_nome` char(128) DEFAULT NULL,
  `destinatario_ccn_mail` char(128) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000007100

-- continenti
-- tipologia: tabella standard
-- verifica: 2021-06-09 11:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `continenti` (
  `id` int(11) NOT NULL,
  `codice` char(2) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000007200

-- contratti
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
CREATE TABLE `contratti` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `codice_affiliazione` char(32) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_categoria_progetti` int(11) DEFAULT NULL,
  `id_badge` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `note_cliente` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000007300

-- contratti_anagrafica
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
CREATE TABLE IF NOT EXISTS `contratti_anagrafica` (
  `id` int(11) NOT NULL,
  `id_contratto` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000007400

-- contratti_progetti
CREATE TABLE IF NOT EXISTS `contratti_progetti` (
  `id` int(11) NOT NULL,
  `id_contratto` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `note_inserimento` text NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `note_aggiornamento` text NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  `id_account_archiviazione` int(11) DEFAULT NULL,
  `note_archiviazione` text NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000007500

-- conversazioni
-- tipologia: tabella gestita
-- verifica: 2022-08-31 11:50 Chiara GDL
CREATE TABLE IF NOT EXISTS `conversazioni` (
  `id` int(11) NOT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `timestamp_chiusura` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000007600

-- conversazioni_account
-- tipologia: tabella gestita
-- verifica: 2022-08-31 11:50 Chiara GDL
CREATE TABLE IF NOT EXISTS `conversazioni_account` (
  `id` int(11) NOT NULL,
  `id_conversazione` int(11) DEFAULT NULL,
  `id_account` int(11) DEFAULT NULL,
  `timestamp_entrata` int(11) DEFAULT NULL,
  `timestamp_uscita` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000008000

-- coupon
-- tipologia: tabella gestita
-- verifica: 2021-06-29 15:50 Fabio Mosti
CREATE TABLE IF NOT EXISTS `coupon` (
  `id` char(32) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inizio` int(11) DEFAULT NULL,
  `timestamp_fine` int(11) DEFAULT NULL,
  `sconto_percentuale` decimal(5,2) DEFAULT NULL,
  `sconto_fisso` decimal(15,2) DEFAULT NULL,
  `se_multiuso` tinyint(1) DEFAULT NULL,
  `se_globale` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000008200

-- coupon_categorie_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:06 Fabio Mosti
CREATE TABLE IF NOT EXISTS `coupon_categorie_prodotti` (
  `id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000008400

-- coupon_listini
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:37 Fabio Mosti
CREATE TABLE IF NOT EXISTS `coupon_listini` (
  `id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_listino` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000008600

-- coupon_marchi
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `coupon_marchi` (
  `id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_marchio` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000008800

-- coupon_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:56 Fabio Mosti
CREATE TABLE IF NOT EXISTS `coupon_prodotti` (
  `id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000008900

-- crediti
-- tipologia: tabella gestita
-- verifica: 2022-07-15 11:56 Chiara GDL
CREATE TABLE IF NOT EXISTS `crediti` (
  `id` int(11) NOT NULL,
  `id_documenti_articolo` int(11) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `id_account_destinatario` int(11) DEFAULT NULL,
  `id_account_emittente` int(11) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000009000

-- disponibilita
-- tipologia: tabella standard
-- verifica: 2022-04-28 16:12 Chiara GDL
CREATE TABLE `disponibilita` (
  `id` int(11) NOT NULL,
  `nome` char(32) DEFAULT NULL,
  `se_catalogo` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000009800

-- documenti
-- tipologia: tabella gestita
-- verifica: 2022-01-07 14:25 chiara gdl
CREATE TABLE IF NOT EXISTS `documenti` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `numero` char(32) DEFAULT NULL,
  `sezionale` char(32) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_emittente` int(11) DEFAULT NULL,
  `id_sede_emittente` int(11) DEFAULT NULL,
  `id_destinatario` int(11) DEFAULT NULL,
  `id_sede_destinatario` int(11) DEFAULT NULL,
  `id_condizione_pagamento` int(11) DEFAULT NULL,
  `esigibilita`	enum('I','D','S') DEFAULT NULL,
  `codice_archivium` char(64) DEFAULT NULL ,
  `codice_sdi` char(64) DEFAULT NULL,
  `cig` char(16) DEFAULT NULL,
  `cup` char(16) DEFAULT NULL,
  `riferimento` char(255) DEFAULT NULL, 
  `timestamp_invio` int(11) DEFAULT NULL,
  `progressivo_invio` char(5) DEFAULT NULL,
  `id_coupon` char(32) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `porto` enum('franco','assegnato','-') DEFAULT NULL,
  `id_causale` int(11) DEFAULT NULL,
  `id_trasportatore` int(11) DEFAULT NULL,
  `id_carrello` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `xml` longtext DEFAULT NULL,
  `note` text DEFAULT NULL,
  `note_cliente` text DEFAULT NULL,
  `note_invio` text DEFAULT NULL,
  `timestamp_chiusura` int(11) DEFAULT NULL,
  `note_chiusura` text DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000010000

-- documenti_articoli
-- tipologia: tabella gestita
-- verifica: 2021-09-10 11:57 Fabio Mosti
CREATE TABLE IF NOT EXISTS `documenti_articoli` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `id_destinatario` int(11) DEFAULT NULL,
  `id_emittente` int(11) DEFAULT NULL,
  `id_reparto` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_attivita` int(11) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_collo` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `id_udm` int(11) DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `id_rinnovo` int(11) DEFAULT NULL,
  `id_carrelli_articoli` int(11) DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `id_listino` int(11) DEFAULT NULL,
  `costo_netto_totale` decimal(16,2) DEFAULT NULL,
  `importo_netto_totale` decimal(16,2) DEFAULT NULL,
  `importo_lordo_totale` decimal(16,2) DEFAULT NULL,
  `sconto_percentuale` decimal(9,2) DEFAULT NULL,
  `sconto_valore` decimal(9,2) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `specifiche` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000012000

-- edifici
-- tipologia: tabella gestita
-- verifica: 2022-04-27 16:56 Chiara GDL
CREATE TABLE IF NOT EXISTS `edifici` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `piani` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000012050

-- edifici_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2022-04-27 16:56 Chiara GDL
CREATE TABLE IF NOT EXISTS `edifici_caratteristiche` (
  `id` int(11) NOT NULL,
  `id_edificio` int(11) DEFAULT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000012800

-- embed
-- tipologia: tabella standard
-- verifica: 2021-06-29 16:56 Fabio Mosti
CREATE TABLE IF NOT EXISTS `embed` (
  `id` int(11) NOT NULL,
  `nome` char(64) DEFAULT NULL,
  `se_audio` tinyint(1) DEFAULT NULL,
  `se_video` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015000

-- file
-- tipologia: tabella gestita
-- verifica: 2021-09-10 16:05 Fabio Mosti
CREATE TABLE IF NOT EXISTS `file` (
  `id` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_template` int(11) DEFAULT NULL,
  `id_mailing` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_mail_out` int(11) DEFAULT NULL,
  `id_mail_sent` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_categoria_progetti` int(11) DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_edificio` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_contratto` int(11) DEFAULT NULL,
  `id_valutazione` int(11) DEFAULT NULL, 
  `id_rinnovo` int(11) DEFAULT NULL,
  `id_anagrafica_certificazioni` int(11) DEFAULT NULL,
  `id_valutazione_certificazioni` int(11) DEFAULT NULL,
  `id_licenza` int(11) DEFAULT NULL,
  `id_attivita` int(11) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `url` char(255) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015200

-- gruppi
-- tipologia: tabella gestita
-- verifica: 2021-09-10 17:58 Fabio Mosti
CREATE TABLE IF NOT EXISTS `gruppi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_organizzazione` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- NOTE
-- questa tabella contiene i gruppi aggiuntivi del framework

-- | 010000015400

-- iban
-- tipologia: tabella gestita
-- verifica: 2021-09-22 11:55 Fabio Mosti
CREATE TABLE IF NOT EXISTS `iban` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `intestazione` char(255) DEFAULT NULL,
  `iban` char(27) NOT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015600

-- immagini
-- tipologia: tabella gestita
-- verifica: 2021-09-22 12:20 Fabio Mosti
CREATE TABLE IF NOT EXISTS `immagini` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_file` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_edificio` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_contratto` int(11) DEFAULT NULL,
  `id_valutazione` int(11) DEFAULT NULL,
  `id_rinnovo` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_categoria_progetti` int(11) DEFAULT NULL,
  `id_banner` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `orientamento` enum('L','P') DEFAULT NULL,
  `taglio` char(64) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `path_alternativo` char(255) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_scalamento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015700

-- immobili
-- tipologia: tabella gestita
-- verifica: 2022-04-27 12:20 Chiara GDL
CREATE TABLE IF NOT EXISTS `immobili` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_edificio` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `scala` char(32) DEFAULT NULL,
  `piano` char(64) DEFAULT NULL,
  `interno` char(8) DEFAULT NULL,
  `campanello` char(128) DEFAULT NULL,
  `catasto_foglio` char(255) DEFAULT NULL,
  `catasto_particella` char(255) DEFAULT NULL,
  `catasto_sub` char(255) DEFAULT NULL,
  `catasto_categoria` char(255) DEFAULT NULL,
  `catasto_classe` char(255) DEFAULT NULL,
  `catasto_consistenza` char(255) DEFAULT NULL,
  `catasto_superficie` char(255) DEFAULT NULL,
  `catasto_rendita` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015710

-- immobili_anagrafica
-- tipologia: tabella gestita
-- verifica: 2022-04-28 12:20 Chiara GDL
CREATE TABLE IF NOT EXISTS `immobili_anagrafica` (
  `id` int(11) NOT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015750

-- immobili_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2022-04-28 12:20 Chiara GDL
CREATE TABLE IF NOT EXISTS `immobili_caratteristiche` (
  `id` int(11) NOT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015800

-- indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-09-23 15:21 Fabio Mosti
CREATE TABLE IF NOT EXISTS `indirizzi` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_comune` int(11) DEFAULT NULL,
  `localita` char(128) DEFAULT NULL,
  `indirizzo` char(128) DEFAULT NULL,
  `civico` char(16) DEFAULT NULL,
  `cap` char(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `latitudine` decimal(11,7) DEFAULT NULL,
  `longitudine` decimal(11,7) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_geolocalizzazione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000015850

-- indirizzi_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2022-05-03 15:21 Chiara GDL
CREATE TABLE IF NOT EXISTS `indirizzi_caratteristiche` (
  `id` int(11) NOT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000016000

-- iva
-- tipologia: tabella standard
-- verifica: 2021-09-23 16:52 Fabio Mosti
CREATE TABLE IF NOT EXISTS `iva` (
  `id` int(11) NOT NULL,
  `aliquota` decimal(5,2) NOT NULL,
  `nome` char(64) DEFAULT NULL,
  `descrizione` text DEFAULT NULL,
  `codice` char(8) DEFAULT NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000016200

-- job
-- tipologia: tabella gestita
-- verifica: 2021-09-24 17:41 Fabio Mosti
CREATE TABLE IF NOT EXISTS `job` (
  `id` int(11) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `job` char(255) NOT NULL,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `totale` int(11) DEFAULT NULL,
  `corrente` int(11) DEFAULT NULL,
  `iterazioni` int(11) DEFAULT NULL,
  `delay` int(11) DEFAULT NULL,
  `workspace` longtext DEFAULT NULL,
  `token` char(254) DEFAULT NULL,
  `se_foreground` tinyint(1) DEFAULT NULL,
  `timestamp_esecuzione` int(11) DEFAULT NULL,
  `timestamp_completamento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000016600

-- licenze
-- tipologia: tabella gestita
-- verifica: 2021-11-15 12:41 Fabio Mosti
CREATE TABLE IF NOT EXISTS `licenze` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_rivenditore` int(11) DEFAULT NULL,
  `codice` char(254) DEFAULT NULL,
  `postazioni` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `note` char(254) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `giorni_validita` int(11) DEFAULT NULL,
  `giorni_rinnovo` int(11) DEFAULT NULL,
  `timestamp_distribuzione` int(11) DEFAULT NULL,
  `timestamp_inizio` int(11) DEFAULT NULL,
  `timestamp_fine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000016700

-- licenze_software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 15:30 Chiara GDL
CREATE TABLE IF NOT EXISTS `licenze_software` (
  `id` int(11) NOT NULL,
  `id_licenza` int(11) DEFAULT NULL,
  `id_software` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000016800

-- lingue
-- tipologia: tabella standard
-- verifica: 2021-09-24 17:41 Fabio Mosti
CREATE TABLE IF NOT EXISTS `lingue` (
  `id` int(11) NOT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` char(128) DEFAULT NULL,
  `iso6391alpha2` char(36) DEFAULT NULL,
  `iso6393alpha3` char(36) DEFAULT NULL,
  `ietf` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000017000

-- liste
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE TABLE `liste` (
  `id` int(11) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000017100

-- liste_mail
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE TABLE `liste_mail` (
  `id` int(11) NOT NULL,
  `id_lista` int(11) DEFAULT NULL,
  `id_mail` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000017200

-- listini
-- tipologia: tabella assistita
-- verifica: 2021-09-24 17:49 Fabio Mosti
CREATE TABLE IF NOT EXISTS `listini` (
  `id` int(11) NOT NULL,
  `id_valuta` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000017400

-- listini_clienti
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:12 Fabio Mosti
CREATE TABLE IF NOT EXISTS `listini_clienti` (
  `id` int(11) NOT NULL,
  `id_listino` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000018000

-- luoghi
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:39 Fabio Mosti
CREATE TABLE IF NOT EXISTS `luoghi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_edificio` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `url` char(255) DEFAULT NULL, 
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000018200

-- macro
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:55 Fabio Mosti
CREATE TABLE IF NOT EXISTS `macro` (
  `id` int(11) NOT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_categoria_progetti` INT(11) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL, 
  `ordine` int(11) DEFAULT NULL,
  `macro` char(255) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000018600

-- mail
-- tipologia: tabella gestita
-- verifica: 2021-09-27 18:31 Fabio Mosti
CREATE TABLE IF NOT EXISTS `mail` (
  `id` int(11) NOT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `indirizzo` char(128) DEFAULT NULL,
  `note` char(128) DEFAULT NULL,
  `se_notifiche` tinyint(1) DEFAULT NULL,
  `se_pec` tinyint(1) DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000018800

-- mail_out
-- tipolgia: tabella gestita
-- verifica: 2021-09-28 15:10 Fabio Mosti
CREATE TABLE IF NOT EXISTS `mail_out` (
  `id` int(11) NOT NULL,
  `id_mail` int(11) DEFAULT NULL,
  `id_mailing` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_composizione` int(11) DEFAULT NULL,
  `mittente` char(254) DEFAULT NULL,
  `destinatari` text DEFAULT NULL,
  `destinatari_cc` text DEFAULT NULL,
  `destinatari_bcc` text DEFAULT NULL,
  `oggetto` char(254) DEFAULT NULL,
  `corpo` text DEFAULT NULL,
  `allegati` text DEFAULT NULL,
  `headers` text DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int(11) DEFAULT 0,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000018900

-- mail_sent
-- tipolgia: tabella gestita
-- verifica: 2021-09-28 15:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `mail_sent` (
  `id` int(11) NOT NULL,
  `id_mail` int(11) DEFAULT NULL,
  `id_mailing` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_composizione` int(11) DEFAULT NULL,
  `mittente` char(254) DEFAULT NULL,
  `destinatari` text DEFAULT NULL,
  `destinatari_cc` text DEFAULT NULL,
  `destinatari_bcc` text DEFAULT NULL,
  `oggetto` char(254) DEFAULT NULL,
  `corpo` text DEFAULT NULL,
  `allegati` text DEFAULT NULL,
  `headers` text DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int(11) DEFAULT 0,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000019000

-- mailing
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE TABLE IF NOT EXISTS `mailing` (
  `id` int(11) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000019050

-- mailing_liste
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE TABLE `mailing_liste` (
  `id` int(11) NOT NULL,
  `id_mailing` int(11) DEFAULT NULL,
  `id_lista` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000019100

-- mailing_mail
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE TABLE `mailing_mail` (
  `id` int(11) NOT NULL,
  `id_mailing` int(11) DEFAULT NULL,
  `id_mail` int(11) DEFAULT NULL,
  `id_mail_out` int(11) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_generazione` int(11) DEFAULT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000020200

-- marchi
-- tipologia: tabella gestita
-- verifica: 2021-09-28 17:59 Fabio Mosti
CREATE TABLE IF NOT EXISTS `marchi` (
  `id` int(11) NOT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000020600

-- mastri
-- tipologia: tabella gestita
-- verifica: 2021-09-29 11:33 Fabio Mosti
CREATE TABLE IF NOT EXISTS `mastri` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica_indirizzi` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_account` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000021000

-- matricole
-- tipologia: tabella gestita
-- verifica: 2021-12-28 16:20 Chiara GDL
CREATE TABLE `matricole` (
  `id` int(11) NOT NULL,
  `id_marchio` int(11) DEFAULT NULL,
  `id_produttore` int(11) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `matricola` char(128) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000021600

-- menu
-- tipologia: tabella gestita
-- verifica: 2021-10-01 09:32 Fabio Mosti
CREATE TABLE IF NOT EXISTS `menu` (
  `id` int(11) NOT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_categoria_progetti` int(11) DEFAULT NULL, 
  `ordine` int(11) DEFAULT NULL,
  `menu` char(32) NOT NULL,
  `nome` char(128) DEFAULT NULL,
  `target` char(16) DEFAULT NULL,
  `ancora` char(64) DEFAULT NULL,
  `sottopagine` char(32) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000021700

-- messaggi
-- tipologia: tabella gestita
-- verifica: 2022-04-26 17:32 Chiara GDL
CREATE TABLE IF NOT EXISTS `messaggi` (
  `id` int(11) NOT NULL,
  `id_conversazione` int(11) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `timestamp_lettura` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000021800

-- metadati
-- tipologia: tabella gestita
-- verifica: 2021-10-01 10:02 Fabio Mosti
CREATE TABLE IF NOT EXISTS `metadati` (
  `id` int(11) NOT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_account` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_immagine` int(11) DEFAULT NULL,
  `id_video` int(11) DEFAULT NULL,
  `id_audio` int(11) DEFAULT NULL,
  `id_file` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_categoria_progetti` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_edificio` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_contratto` int(11) DEFAULT NULL, 
  `id_valutazione` int(11) DEFAULT NULL,
  `id_rinnovo` int(11) DEFAULT NULL,
  `id_tipologia_attivita` int(11) DEFAULT NULL,
  `id_banner` int(11) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `id_tipologia_todo` int(11) DEFAULT NULL,
  `id_tipologia_contratti` int(11) DEFAULT NULL,
  `id_carrello` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000021900

-- modalita_pagamento
-- tipologia: tabella standard
-- verifica: 2022-01-18 12:06 Chiara GDL
CREATE TABLE IF NOT EXISTS `modalita_pagamento` (
`id` int(11) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `provider` char(64) DEFAULT NULL,
  `codice` char(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000022000

-- notizie
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:06 Fabio Mosti
CREATE TABLE IF NOT EXISTS `notizie` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000022200

-- notizie_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:32 Fabio Mosti
CREATE TABLE IF NOT EXISTS `notizie_categorie` (
  `id` int(11) NOT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000022800

-- organizzazioni
-- tipologia: tabella gestita
-- verifica: 2021-05-23 14:39 Fabio Mosti
CREATE TABLE IF NOT EXISTS `organizzazioni` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000023100

-- pagamenti
-- tipologia: tabella gestita
-- verifica: 2021-11-12 16:00 Chiara GDL
CREATE TABLE IF NOT EXISTS `pagamenti` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_modalita_pagamento` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `note_pagamento` text DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `id_creditore` int(11) DEFAULT NULL,
  `id_debitore` int(11) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `id_iban` int(11) DEFAULT NULL,
  `importo_lordo_totale` decimal(9,2) DEFAULT NULL,
  `id_listino` int(11) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL, 
  `timestamp_pagamento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000023200

-- pagine
-- tipologia: tabella gestita
-- verifica: 2021-10-04 11:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `pagine` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(32) DEFAULT NULL,
  `id_contenuti` int(11) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000023500

-- periodi
-- tipologia: tabella di supporto
-- verifica: 2022-05-24 12:57 Chiara GDL
CREATE TABLE IF NOT EXISTS `periodi` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000023600

-- periodicita
-- tipologia: tabella di supporto
-- verifica: 2021-10-05 17:57 Fabio Mosti
CREATE TABLE IF NOT EXISTS `periodicita` (
  `id` int(11) NOT NULL,
  `nome` char(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000023800

-- pianificazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-05 17:16 Fabio Mosti
CREATE TABLE IF NOT EXISTS `pianificazioni` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_attivita` int(11) DEFAULT NULL,
  `id_contratto` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_periodicita` int(11) DEFAULT NULL,
  `cadenza` int(11) DEFAULT NULL,
  `se_lunedi` tinyint(1) DEFAULT NULL,
  `se_martedi` tinyint(1) DEFAULT NULL,
  `se_mercoledi` tinyint(1) DEFAULT NULL,
  `se_giovedi` tinyint(1) DEFAULT NULL,
  `se_venerdi` tinyint(1) DEFAULT NULL,
  `se_sabato` tinyint(1) DEFAULT NULL,
  `se_domenica` tinyint(1) DEFAULT NULL,
  `schema_ripetizione` int(11) DEFAULT NULL,
  `data_avvio` date DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_elaborazione` date DEFAULT NULL,
  `timestamp_elaborazione` int(11) DEFAULT NULL,
  `data_ultimo_oggetto`  date DEFAULT NULL,
  `giorni_elaborazione` int(11) DEFAULT NULL,
  `giorni_estensione` int(11) DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `entita`	enum('todo','attivita','rinnovi','documenti','documenti_articoli','pagamenti') DEFAULT NULL,
  `model_id_anagrafica` int(11) DEFAULT NULL,
  `model_id_anagrafica_programmazione` int(11) DEFAULT NULL,
  `model_id_articolo` char(32) DEFAULT NULL,
  `model_id_attivita` int(11) DEFAULT NULL,
  `model_id_causale` int(11) DEFAULT NULL,
  `model_id_cliente` int(11) DEFAULT NULL,
  `model_id_collo` int(11) DEFAULT NULL,
  `model_id_condizione_pagamento` int(11) DEFAULT NULL,
  `model_id_contatto` int(11) DEFAULT NULL,
  `model_id_coupon` char(32) DEFAULT NULL,
  `model_id_destinatario` int(11) DEFAULT NULL,
  `model_id_documento` int(11) DEFAULT NULL, 
  `model_id_emittente` int(11) DEFAULT NULL,
  `model_id_genitore` int(11) DEFAULT NULL,
  `model_id_iban` int(11) DEFAULT NULL,
  `model_id_indirizzo` int(11) DEFAULT NULL,
  `model_id_immobile` int(11) DEFAULT NULL,
  `model_id_licenza` int(11) DEFAULT NULL,
  `model_id_listino` int(11) DEFAULT NULL,
  `model_id_luogo` int(11) DEFAULT NULL,
  `model_id_mastro_destinazione` int(11) DEFAULT NULL,
  `model_id_mastro_provenienza` int(11) DEFAULT NULL,
  `model_id_matricola` int(11) DEFAULT NULL,
  `model_id_modalita_pagamento` int(11) DEFAULT NULL,
  `model_id_prodotto` char(32) DEFAULT NULL,
  `model_id_progetto` char(32) DEFAULT NULL,
  `model_id_reparto` int(11) DEFAULT NULL,
  `model_id_sede_destinatario` int(11) DEFAULT NULL,
  `model_id_sede_emittente` int(11) DEFAULT NULL,
  `model_id_tipologia` int(11) DEFAULT NULL,
  `model_id_todo` int(11) DEFAULT NULL,
  `model_id_trasportatore` int(11) DEFAULT NULL,
  `model_id_udm` int(11) DEFAULT NULL,
  `model_anno_programmazione` year(4) DEFAULT NULL,
  `model_codice` char(64) DEFAULT NULL,
  `model_data` date DEFAULT NULL,
  `model_data_fine` date DEFAULT NULL,
  `model_data_inizio` date DEFAULT NULL,
  `model_data_programmazione` date DEFAULT NULL,
  `model_esigibilita`	enum('I','D','S') DEFAULT NULL,      
  `model_importo_netto_totale` char(32) DEFAULT NULL,
  `model_importo_lordo_totale` char(32) DEFAULT NULL,
  `model_nome` char(255) DEFAULT NULL,
  `model_note` text DEFAULT NULL,
  `model_note_cliente` text DEFAULT NULL,
  `model_note_programmazione` text DEFAULT NULL,
  `model_numero` char(32) DEFAULT NULL,
  `model_ora_inizio_programmazione` time DEFAULT NULL,
  `model_ora_fine_programmazione` time DEFAULT NULL,
  `model_ore_programmazione` decimal(5,2) DEFAULT NULL,
  `model_porto` enum('franco','assegnato','-') DEFAULT NULL,
  `model_quantita` decimal(9,2) DEFAULT NULL,
  `model_riferimento` char(255) DEFAULT NULL, 
  `model_sconto_percentuale` decimal(9,2) DEFAULT NULL,
  `model_sconto_valore` decimal(9,2) DEFAULT NULL,
  `model_se_automatico` int(1) DEFAULT NULL,
  `model_sezionale` char(32) DEFAULT NULL,
  `model_settimana_programmazione` int(11) DEFAULT NULL,
  `model_specifiche` char(255) DEFAULT NULL,
  `model_data_scadenza` date DEFAULT NULL,
  `model_timestamp_scadenza` int(11) DEFAULT NULL,
  `offset_giorni` int(11) DEFAULT NULL,
  `offset_fine_mese` int(1) DEFAULT NULL,
  `workspace` longtext DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000024000

-- popup
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:09 Fabio Mosti
CREATE TABLE IF NOT EXISTS `popup` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `html_id` char(128) DEFAULT NULL,
  `html_class` char(128) DEFAULT NULL,
  `html_class_attivazione` char(128) DEFAULT NULL,
  `n_scroll` int(11) DEFAULT NULL,
  `n_secondi` int(11) DEFAULT NULL,
  `template` char(128) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `se_ovunque` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000024200

-- popup_pagine
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:09 Fabio Mosti
CREATE TABLE IF NOT EXISTS `popup_pagine` (
  `id` int(11) NOT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_popup` int(11) DEFAULT NULL,
  `se_presente` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000025000

-- prezzi
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:53 Fabio Mosti
CREATE TABLE IF NOT EXISTS `prezzi` (
  `id` int(11) NOT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int(11) DEFAULT NULL,
  `id_iva` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000026000

-- prodotti
-- tipologia: tabella gestita
-- verifica: 2021-10-04 18:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `prodotti` (	
  `id` char(32) NOT NULL,	
  `id_tipologia` int(11) DEFAULT NULL,	
  `nome` char(128) DEFAULT NULL,	
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,	
  `note_codifica` text DEFAULT NULL,	
  `id_marchio` int(11) DEFAULT NULL,	
  `id_produttore` int(11) DEFAULT NULL,	
  `codice_produttore` char(64) DEFAULT NULL,	
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000026200

-- prodotti_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-10-04 19:48 Fabio Mosti
CREATE TABLE IF NOT EXISTS `prodotti_caratteristiche` (
  `id` int(11) NOT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000026400

-- prodotti_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-04 19:03 Fabio Mosti
CREATE TABLE IF NOT EXISTS `prodotti_categorie` (
  `id` int(11) NOT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000027000

-- progetti
-- tipologia: tabella gestita
-- verifica: 2021-10-08 13:52 Fabio Mosti
CREATE TABLE IF NOT EXISTS `progetti` (
  `id` char(32) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_ranking` int(11) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_periodo` int(11) DEFAULT NULL, 
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,	
  `entrate_previste` decimal(16,2) DEFAULT NULL,
  `ore_previste` decimal(16,2) DEFAULT NULL,
  `costi_previsti` decimal(16,2) DEFAULT NULL,
  `note_previsioni` text DEFAULT NULL,
  `entrate_accettazione` decimal(16,2) DEFAULT NULL,
  `data_accettazione` date DEFAULT NULL,
  `note_accettazione` text DEFAULT NULL,
  `data_apertura` date DEFAULT NULL,
  `note_apertura` text DEFAULT NULL,
  `data_chiusura` date DEFAULT NULL,
  `note_chiusura` text DEFAULT NULL,
  `entrate_totali` decimal(16,2) DEFAULT NULL,
  `ore_totali` decimal(16,2) DEFAULT NULL,
  `uscite_totali` decimal(16,2) DEFAULT NULL,
  `note_totali` text DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `note_archiviazione` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000027200

-- progetti_anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:58 Fabio Mosti
CREATE TABLE IF NOT EXISTS `progetti_anagrafica` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_sostituto` tinyint(1) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000027300

-- progetti_articoli
-- tipologia: tabella gestita
-- verifica: 2021-04-14 14:58 Chiara GDL
CREATE TABLE IF NOT EXISTS `progetti_articoli` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000027400

-- progetti_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:58 Fabio Mosti
CREATE TABLE IF NOT EXISTS `progetti_categorie` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | 010000027600

-- progetti_certificazioni
-- tipologia: tabella gestita
-- verifica: 2022-02-03 11:12 Chiara GDL
CREATE TABLE `progetti_certificazioni` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_certificazione` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_richiesta` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000027800

-- progetti_matricole
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:58 Fabio Mosti
CREATE TABLE IF NOT EXISTS `progetti_matricole` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000028000

-- provincie
-- tipologia: tabella di supporto
-- verifica: 2021-10-08 16:20 Fabio Mosti
CREATE TABLE IF NOT EXISTS `provincie` (
  `id` int(11) NOT NULL,
  `id_regione` int(11) DEFAULT NULL,
  `nome` varchar(254) DEFAULT NULL,
  `sigla` char(8) DEFAULT NULL,
  `codice_istat` char(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000028400

-- pubblicazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-08 16:38 Fabio Mosti
CREATE TABLE IF NOT EXISTS `pubblicazioni` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_popup` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL, 
  `id_categoria_progetti` INT(11) DEFAULT NULL, 
  `id_banner` INT(11) DEFAULT NULL, 
  `note` char(254) DEFAULT NULL,
  `timestamp_inizio` int(11) DEFAULT NULL,
  `timestamp_fine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000028600

-- ranking
-- tipologia: tabella assistita
-- verifica: 2021-10-12 12:12 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ranking` (
  `id` int(11) NOT NULL,
  `nome` varchar(254) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_cliente` tinyint(1) DEFAULT NULL,
  `se_fornitore` tinyint(1) DEFAULT NULL,
  `se_progetti` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000028900

-- recensioni
CREATE TABLE `recensioni` (
  `id` int(11) NOT NULL,
  `id_lingua` int(11) NOT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `autore` char(128) DEFAULT NULL,
  `valutazione` int(11) DEFAULT NULL,
  `titolo` char(255) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `se_approvata` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000029400

-- redirect
-- tipologia: tabella gestita
-- verifica: 2021-10-08 18:00 Fabio Mosti
CREATE TABLE IF NOT EXISTS `redirect` (
  `id` int(11) NOT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `codice` int(11) DEFAULT NULL,
  `sorgente` char(255) DEFAULT NULL,
  `destinazione` char(255) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000029460

-- redirect_azioni

CREATE TABLE `redirect_azioni` (
  `id` int(11) NOT NULL ,
  `id_redirect` int(11) DEFAULT NULL,
  `referral` text DEFAULT NULL,
  `azione` enum('redirect') DEFAULT NULL,
  `timestamp_azione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000029800

-- regimi
-- tipologia: tabella standard
-- verifica: 2021-10-09 15:02 Fabio Mosti
CREATE TABLE IF NOT EXISTS `regimi` (
  `id` int(11) NOT NULL,
  `nome` char(32) DEFAULT NULL,
  `codice` char(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000030200

-- regioni
-- tipologia: tabella standard
-- verifica: 2021-10-09 15:22 Fabio Mosti
CREATE TABLE IF NOT EXISTS `regioni` (
  `id` int(11) NOT NULL,
  `id_stato` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `codice_istat` char(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000030300

-- relazioni_anagrafica
-- tipologia: tabella relazione
-- verifica: 2022-02-03 11:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `relazioni_anagrafica` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `id_anagrafica_collegata` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000030400

-- relazioni_documenti
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `relazioni_documenti` (
  `id` int(11) NOT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `id_documento_collegato` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000030410

-- relazioni_documenti_articoli
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `relazioni_documenti_articoli` (
  `id` int(11) NOT NULL,
  `id_documenti_articolo` int(11) DEFAULT NULL,
  `id_documenti_articolo_collegato` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000030440

-- relazioni_pagamenti
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `relazioni_pagamenti` (
  `id` int(11) NOT NULL,
  `id_pagamento` int(11) DEFAULT NULL,
  `id_pagamento_collegato` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000030490

-- relazioni_progetti
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `relazioni_progetti` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `id_progetto_collegato` char(32) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000030500

-- relazioni_software
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `relazioni_software` (
  `id` int(11) NOT NULL,
  `id_software` int(11) DEFAULT NULL,
  `id_software_collegato` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000030800

-- reparti
-- tipologia: tabella assistita
-- verifica: 2021-10-09 15:34 Fabio Mosti
CREATE TABLE IF NOT EXISTS `reparti` (
  `id` int(11) NOT NULL,
  `id_iva` int(11) DEFAULT NULL,
  `id_settore` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000031500

-- rinnovi
-- tipologia: tabella gestita
-- verifica: 2022-02-21 12:59 Chiara GDL
CREATE TABLE IF NOT EXISTS `rinnovi` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_contratto` int(11) DEFAULT NULL,
  `id_licenza` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_tipologia_contratto` int(11) DEFAULT NULL,
  `id_categoria_progetti` int(11) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL, 
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `codice` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_automatico` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000031550

-- rinnovi_documenti_articoli
-- tipologia: tabella gestita
-- verifica: 2022-03-08 15:59 Chiara GDL
CREATE TABLE IF NOT EXISTS `rinnovi_documenti_articoli` (
`id` int(11) NOT NULL,
  `id_rinnovo` int(11) DEFAULT NULL,
  `id_documenti_articolo` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000032000

-- risorse
-- tipologia: tabella gestita
-- verifica: 2021-10-09 15:49 Fabio Mosti
CREATE TABLE IF NOT EXISTS `risorse` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `codice` char(16) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` tinyint(1) DEFAULT NULL,
  `se_cacheable` tinyint(1) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `id_testata` int(11) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `giorno_pubblicazione` int(2) DEFAULT NULL,
  `mese_pubblicazione` int(2) DEFAULT NULL,
  `anno_pubblicazione` int(4) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000032100

-- risorse_account
-- tipologia: tabella di supporto
-- verifica: 2022-08-02 12:07 Chiara GDL
CREATE TABLE IF NOT EXISTS `risorse_account` (
  `id` int(11) NOT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_account` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000032200

-- risorse_anagrafica
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 16:07 Fabio Mosti
CREATE TABLE IF NOT EXISTS `risorse_anagrafica` (
  `id` int(11) NOT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000032400

-- risorse_categorie
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 17:46 Fabio Mosti
CREATE TABLE IF NOT EXISTS `risorse_categorie` (
  `id` int(11) NOT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034000

-- ruoli_anagrafica
-- tipologia: tabella standard
-- verifica: 2021-10-09 18:21 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_anagrafica` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_produzione` tinyint(1) DEFAULT NULL,
  `se_didattica` tinyint(1) DEFAULT NULL,
  `se_organizzazioni` tinyint(1) DEFAULT NULL,
  `se_relazioni` tinyint(1) DEFAULT NULL,
  `se_risorse` tinyint(1) DEFAULT NULL,
  `se_progetti` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL,
  `se_contratti` tinyint(1) DEFAULT NULL,
  `se_proponente` tinyint(1) DEFAULT NULL,
  `se_contraente` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034100

-- ruoli_articoli
-- tipologia: tabella standard
-- verifica: 2022-04-09 16:21 Chiara GDL
CREATE TABLE IF NOT EXISTS `ruoli_articoli` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_progetti` tinyint(1) DEFAULT NULL,
  `se_risorse` tinyint(1) DEFAULT NULL,
  `se_acquisto` tinyint(1) DEFAULT NULL,
  `se_rinnovo` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034200

-- ruoli_audio
-- tipologia: tabella standard
-- verifica: 2021-10-09 18:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_audio` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` tinyint(1) DEFAULT NULL,
  `se_pagine` tinyint(1) DEFAULT NULL,
  `se_prodotti` tinyint(1) DEFAULT NULL,
  `se_articoli` tinyint(1) DEFAULT NULL,
  `se_categorie_prodotti` tinyint(1) DEFAULT NULL,
  `se_notizie` tinyint(1) DEFAULT NULL,
  `se_categorie_notizie` tinyint(1) DEFAULT NULL,
  `se_risorse` tinyint(1) DEFAULT NULL,
  `se_categorie_risorse` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034300

-- ruoli_documenti
-- tipologia: tabella standard
-- verifica: 2022-06-09 16:21 Chiara GDL
CREATE TABLE IF NOT EXISTS `ruoli_documenti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_xml` tinyint(1) DEFAULT NULL,
  `se_documenti` tinyint(1) DEFAULT NULL,
  `se_documenti_articoli` tinyint(1) DEFAULT NULL,
  `se_relazioni` tinyint(1) DEFAULT NULL,
  `se_conferma` tinyint(1) DEFAULT NULL,
  `se_consuntivo` tinyint(1) DEFAULT NULL,
  `se_evasione` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034400

-- ruoli_file
-- tipologia: tabella standard
-- verifica: 2021-10-11 18:13 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_file` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` tinyint(1) DEFAULT NULL,
  `se_pagine` tinyint(1) DEFAULT NULL,
  `se_template` tinyint(1) DEFAULT NULL,
  `se_prodotti` tinyint(1) DEFAULT NULL,
  `se_articoli` tinyint(1) DEFAULT NULL,
  `se_categorie_prodotti` tinyint(1) DEFAULT NULL,
  `se_notizie` tinyint(1) DEFAULT NULL,
  `se_categorie_notizie` tinyint(1) DEFAULT NULL,
  `se_risorse` tinyint(1) DEFAULT NULL,
  `se_categorie_risorse` tinyint(1) DEFAULT NULL,
  `se_mail` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL,
  `se_documenti` tinyint(1) DEFAULT NULL 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034600

-- ruoli_immagini
-- tipologia: tabella standard
-- verifica: 2021-10-11 18:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_immagini` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine_scalamento` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` tinyint(1) DEFAULT NULL,
  `se_pagine` tinyint(1) DEFAULT NULL,
  `se_prodotti` tinyint(1) DEFAULT NULL,
  `se_articoli` tinyint(1) DEFAULT NULL,
  `se_categorie_prodotti` tinyint(1) DEFAULT NULL,
  `se_notizie` tinyint(1) DEFAULT NULL,
  `se_categorie_notizie` tinyint(1) DEFAULT NULL,
  `se_risorse` tinyint(1) DEFAULT NULL,
  `se_categorie_risorse` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034800

-- ruoli_indirizzi
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_indirizzi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_sede_legale` tinyint(1) DEFAULT NULL,
  `se_sede_operativa` tinyint(1) DEFAULT NULL,
  `se_residenza` tinyint(1) DEFAULT NULL,
  `se_domicilio` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034850

-- ruoli_mail
-- tipologia: tabella standard
CREATE TABLE IF NOT EXISTS `ruoli_mail` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_xml` tinyint(1) DEFAULT NULL,
  `se_commerciale` tinyint(1) DEFAULT NULL,
  `se_produzione` tinyint(1) DEFAULT NULL,
  `se_amministrazione` tinyint(1) DEFAULT NULL,
  `se_acquisti` tinyint(1) DEFAULT NULL,
  `se_ordini` tinyint(1) DEFAULT NULL,
  `se_helpdesk` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000034900

-- ruoli_matricole
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_matricole` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000035000

-- ruoli_prodotti
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_prodotti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000035100

-- ruoli_progetti
-- tipologia: tabella standard
-- verifica: 2022-04-20 10:45 chiara GDL
CREATE TABLE IF NOT EXISTS `ruoli_progetti` (
  `id` int(11) NOT NULL,
  `nome` char(128) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_sottoprogetto` tinyint(1) DEFAULT NULL,
  `se_proseguimento` tinyint(1) DEFAULT NULL,
  `se_sostituto` tinyint(1) DEFAULT NULL,
  `se_attesa` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000035200

-- ruoli_video
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_video` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` tinyint(1) DEFAULT NULL,
  `se_pagine` tinyint(1) DEFAULT NULL,
  `se_prodotti` tinyint(1) DEFAULT NULL,
  `se_articoli` tinyint(1) DEFAULT NULL,
  `se_categorie_prodotti` tinyint(1) DEFAULT NULL,
  `se_notizie` tinyint(1) DEFAULT NULL,
  `se_categorie_notizie` tinyint(1) DEFAULT NULL,
  `se_risorse` tinyint(1) DEFAULT NULL,
  `se_categorie_risorse` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000037000

-- settori
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `settori` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `soprannome` char(64) DEFAULT NULL,
  `ateco` char(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000041000

-- sms_out
-- tipolgia: tabella gestita
-- verifica: 2021-10-12 11:51 Fabio Mosti
CREATE TABLE IF NOT EXISTS `sms_out` (
  `id` int(11) NOT NULL,
  `id_telefono` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_composizione` int(11) DEFAULT NULL,
  `mittente` char(254) DEFAULT NULL,
  `destinatari` text DEFAULT NULL,
  `corpo` text DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int(11) DEFAULT 0,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000041200

-- sms_sent
-- tipolgia: tabella gestita
-- verifica: 2021-10-12 11:51 Fabio Mosti
CREATE TABLE IF NOT EXISTS `sms_sent` (
  `id` int(11) NOT NULL,
  `id_telefono` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_composizione` int(11) DEFAULT NULL,
  `mittente` char(254) DEFAULT NULL,
  `destinatari` text DEFAULT NULL,
  `corpo` text DEFAULT NULL,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int(11) DEFAULT 0,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000041400

-- software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 10:39 Chiara GDL
CREATE TABLE IF NOT EXISTS `software` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `json` text DEFAULT NULL, 
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000042000

-- stati
-- tipologia: tabella standard
-- verifica: 2021-10-12 15:06 Fabio Mosti
CREATE TABLE IF NOT EXISTS `stati` (
  `id` int(11) NOT NULL,
  `id_continente` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` char(128) DEFAULT NULL,
  `iso31661alpha2` char(2) DEFAULT NULL,
  `iso31661alpha3` char(3) DEFAULT NULL,
  `codice_istat` char(4) DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000042200

-- stati_lingue
-- tipologia: tabella standard
-- verifica: 2021-10-12 15:24 Fabio Mosti
CREATE TABLE IF NOT EXISTS `stati_lingue` (
  `id` int(11) NOT NULL,
  `id_stato` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000043000

-- task
-- tipologia: tabella assistita
-- verifica: 2021-10-12 15:58 Fabio Mosti
CREATE TABLE IF NOT EXISTS `task` (
  `id` int(11) NOT NULL,
  `minuto` int(11) DEFAULT NULL,
  `ora` int(11) DEFAULT NULL,
  `giorno_del_mese` int(11) DEFAULT NULL,
  `mese` int(11) DEFAULT NULL,
  `giorno_della_settimana` int(11) DEFAULT NULL,
  `settimana` int(11) DEFAULT NULL,
  `task` char(255) DEFAULT NULL,
  `iterazioni` int(11) DEFAULT NULL,
  `delay` int(11) DEFAULT NULL,
  `token` char(254) DEFAULT NULL,
  `timestamp_esecuzione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000043600

-- telefoni
-- tipologia: tabella gestita
-- verifica: 2021-10-12 15:58 Fabio Mosti
CREATE TABLE `telefoni` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `numero` char(32) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_notifiche` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000044000

-- template
-- tipologia: tabella gestita
-- verifica: 2021-10-15 12:32 Fabio Mosti
CREATE TABLE IF NOT EXISTS `template` (
  `id` int(11) NOT NULL,
  `ruolo` char(32) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `tipo` char(32) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `latenza_invio` int(11) DEFAULT NULL,
  `se_mail` tinyint(1) DEFAULT NULL,
  `se_sms` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000045000

-- testate
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:56 Fabio Mosti
CREATE TABLE IF NOT EXISTS `testate` (
  `id` int(11) NOT NULL,
  `nome` char(128) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- | 010000050000

-- tipologie_anagrafica
-- tipologia: tabella standard
-- verifica: 2021-10-15 16:15 Fabio Mosti
-- NOTA rendere gestita
CREATE TABLE IF NOT EXISTS `tipologie_anagrafica` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `sigla` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_persona_fisica` tinyint(1) DEFAULT NULL,
  `se_persona_giuridica` tinyint(1) DEFAULT NULL,
  `se_pubblica_amministrazione` tinyint(1) DEFAULT NULL,
  `se_ecommerce` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050400

-- tipologie_attivita
-- tipologia: tabella gestita
-- verifica: 2021-10-15 16:38 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_attivita` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(8) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` tinyint(1) DEFAULT NULL,
  `se_agenda` tinyint(1) DEFAULT NULL,
  `se_sistema` tinyint(1) DEFAULT NULL,
  `se_cartellini` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050450

-- tipologie_badge
-- tipologia: tabella assistita
-- verifica: 2022-07-20 17:22 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_badge` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050500

-- tipologie_banner
-- tipologia: tabella assistita
-- verifica: 2022-07-20 17:22 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_banner` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050600

-- tipologie_chiavi
-- tipologia: tabella gestita
-- verifica: 2021-11-15 11:00 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_chiavi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050800

-- tipologie_contatti
-- tipologia: tabella gestita
-- verifica: 2021-10-15 16:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_contatti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000050900

-- tipologie_contratti
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:47 Chiara GDL
CREATE TABLE `tipologie_contratti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_categoria_progetti` int(11) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_tesseramento` tinyint(1) DEFAULT NULL,
  `se_abbonamento` tinyint(1) DEFAULT NULL,
  `se_iscrizione` tinyint(1) DEFAULT NULL,
  `se_immobili` tinyint(1) DEFAULT NULL,
  `se_acquisto` tinyint(1) DEFAULT NULL,
  `se_locazione` tinyint(1) DEFAULT NULL,
  `se_libero` tinyint(1) DEFAULT NULL,
	`se_prenotazione` tinyint(1) DEFAULT NULL, 
	`se_scalare` tinyint(1) DEFAULT NULL,
  `se_affiliazione` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000052600

-- tipologie_documenti
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:00 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_documenti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(8) DEFAULT NULL,
  `numerazione` char(1) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `sigla` char(16) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_fattura` tinyint(1) DEFAULT NULL,
  `se_nota_credito` tinyint(1) DEFAULT NULL,
  `se_nota_debito` tinyint(1) DEFAULT NULL,
  `se_trasporto` tinyint(1) DEFAULT NULL,
  `se_pro_forma` tinyint(1) DEFAULT NULL,
  `se_offerta` tinyint(1) DEFAULT NULL,
  `se_ordine` tinyint(1) DEFAULT NULL,
  `se_ricevuta` tinyint(1) DEFAULT NULL,
  `se_ecommerce` tinyint(1) DEFAULT NULL,
  `stampa_xml` char(255) DEFAULT NULL,
  `stampa_pdf` char(255) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000052800

-- tipologie_edifici
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
CREATE TABLE `tipologie_edifici` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000052900

-- tipologie_immobili
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
CREATE TABLE `tipologie_immobili` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_residenziale` tinyint(1) DEFAULT NULL,
  `se_industriale` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000053000

-- tipologie_indirizzi
-- tipologia: tabella assistita
-- verifica: 2021-10-15 17:29 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_indirizzi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000053200

-- tipologie_licenze
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:00 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_licenze` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000053300

-- tipologie_luoghi
-- tipologia: tabella assistita
-- verifica: 2022-02-21 15:30 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_luoghi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000053400

-- tipologie_mastri
-- tipologia: tabella assistita
-- verifica: 2021-10-15 17:30 Fabio Mosti
CREATE TABLE `tipologie_mastri` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_magazzino` tinyint(1) DEFAULT NULL,
  `se_conto` tinyint(1) DEFAULT NULL,
  `se_registro` tinyint(1) DEFAULT NULL,
  `se_credito` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000053800

-- tipologie_notizie
-- tipologia: tabella assistita
-- verifica: 2021-10-15 17:31 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_notizie` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000054000

-- tipologie_pagamenti
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:00 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_pagamenti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000054100

-- tipologie_periodi
-- tipologia: tabella gestita
-- verifica: 2022-05-24 11:00 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_periodi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(8) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_corsi` tinyint(1) DEFAULT NULL,
  `se_tesseramenti` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000054200

-- tipologie_popup
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:32 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_popup` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000054600

-- tipologie_prodotti
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:34 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_prodotti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_colori` tinyint(1) DEFAULT NULL,
  `se_taglie` tinyint(1) DEFAULT NULL,
  `se_periodicita` tinyint(1) DEFAULT NULL,
  `se_tipologia_rinnovo` tinyint(1) DEFAULT NULL,
  `se_dimensioni` tinyint(1) DEFAULT NULL,
  `se_volume` tinyint(1) DEFAULT NULL,
  `se_capacita` tinyint(1) DEFAULT NULL,
  `se_massa` tinyint(1) DEFAULT NULL,
  `se_imballo` tinyint(1) DEFAULT NULL,
  `se_spedizione` tinyint(1) DEFAULT NULL,
  `se_trasporto` tinyint(1) DEFAULT NULL,
  `se_prodotto` tinyint(1) DEFAULT NULL,
  `se_servizio` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000055000

-- tipologie_progetti
-- tipologia: tabella gestita
-- verifica: 2021-10-15 17:40 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_progetti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_produzione` tinyint(1) DEFAULT NULL,
  `se_contratto` tinyint(1) DEFAULT NULL,
  `se_pacchetto` tinyint(1) DEFAULT NULL,
  `se_progetto` tinyint(1) DEFAULT NULL,
  `se_consuntivo` tinyint(1) DEFAULT NULL,
  `se_forfait` tinyint(1) DEFAULT NULL,
  `se_didattica` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000055400

-- tipologie_pubblicazioni
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:43 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_pubblicazioni` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_bozza` tinyint(1) DEFAULT NULL,
  `se_pubblicato` tinyint(1) DEFAULT NULL,
  `se_evidenza` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000055700

-- tipologie_rinnovi
-- tipologia: tabella di supporto
-- verifica: 2022-04-29 17:45 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_rinnovi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_tesseramenti` tinyint(1) DEFAULT NULL,
  `se_iscrizioni` tinyint(1) DEFAULT NULL,
  `se_abbonamenti` tinyint(1) DEFAULT NULL,
  `se_licenze` tinyint(1) DEFAULT NULL,
  `se_contratti` tinyint(1) DEFAULT NULL,
  `se_progetti` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000055800

-- tipologie_risorse
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_risorse` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000056200

-- tipologie_telefoni
-- tipologia: tabella assistita
-- verifica: 2021-10-15 17:46 Fabio Mosti
-- NOTA rendere gestita
CREATE TABLE `tipologie_telefoni` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000056600

-- tipologie_todo
-- tipologia: tabella gestita
-- verifica: 2021-10-15 17:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_todo` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_agenda` tinyint(1) DEFAULT NULL,
  `se_ticket` tinyint(1) DEFAULT NULL,
  `se_ordinaria` tinyint(1) DEFAULT NULL,
  `se_straordinaria` tinyint(1) DEFAULT NULL,
  `se_commerciale` tinyint(1) DEFAULT NULL,
  `se_produzione` tinyint(1) DEFAULT NULL,
  `se_amministrazione` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000056800

-- tipologie_url
-- tipologia: tabella gestita
-- verifica: 2021-11-09 12:40 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_url` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000056900

-- tipologie_zone
-- tipologia: tabella gestita
-- verifica: 2022-06-16 16:40 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_zone` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000060000

-- todo
-- tipologia: tabella gestita
-- verifica: 2021-10-19 12:56 Fabio Mosti
CREATE TABLE IF NOT EXISTS `todo` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `note_scadenza` text DEFAULT NULL,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `anno_programmazione` year(4) DEFAULT NULL,
  `settimana_programmazione` int(11) DEFAULT NULL,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `note_programmazione` text DEFAULT NULL,
  `data_chiusura` date DEFAULT NULL,
  `note_chiusura` text DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `testo` text DEFAULT NULL,
  `id_contatto` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `note_pianificazione` text DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `note_archiviazione` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000060100

-- todo_matricole
-- tipologia: tabella gestita
-- verifica: 2022-04-27 14:58 Chiara GDL
CREATE TABLE IF NOT EXISTS `todo_matricole` (
  `id` int(11) NOT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000062000

-- udm
-- tipologia: tabella standard
-- verifica: 2021-10-19 12:59 Fabio Mosti
CREATE TABLE IF NOT EXISTS `udm` (
  `id` int(11) NOT NULL,
  `id_base` int(11) DEFAULT NULL,
  `conversione` float DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `sigla` char(8) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_lunghezza` tinyint(1) DEFAULT NULL,
  `se_volume` tinyint(1) DEFAULT NULL,
  `se_massa` tinyint(1) DEFAULT NULL,
  `se_tempo` tinyint(1) DEFAULT NULL,
  `se_quantita` tinyint(1) DEFAULT NULL,
  `se_area` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000062600

-- url
-- tipologia: tabella gestita
-- verifica: 2021-11-09 11:25 Fabio Mosti
CREATE TABLE IF NOT EXISTS `url` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `url` char(255) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000062900

-- valutazioni
-- tipologia: tabella gestita
-- verifica: 2022-04-28 Chiara GDL
CREATE TABLE `valutazioni` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `mq_commerciali` decimal(15,2) DEFAULT NULL,
  `mq_calpestabili` decimal(15,2) DEFAULT NULL,
  `id_condizione` int(11) DEFAULT NULL,
  `id_disponibilita` int(11) DEFAULT NULL,
  `id_classe_energetica` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_valutazione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000062950

-- valutazioni_certificazioni
-- tipologia: tabella gestita
-- verifica: 2022-05-23 Chiara GDL
CREATE TABLE `valutazioni_certificazioni` (
  `id` int(11) NOT NULL,
  `id_valutazione` int(11) DEFAULT NULL,
  `id_certificazione` int(11) DEFAULT NULL,
  `id_emittente` int(11) DEFAULT NULL,
  `nome` char(1) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `data_emissione` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000063000

-- valute
-- tipologia: tabella di supporto
-- verifica: 2021-10-19 13:16 Fabio Mosti
CREATE TABLE IF NOT EXISTS `valute` (
  `id` int(11) NOT NULL,
  `iso4217` char(3) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `utf8` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000065000

-- video
-- tipologia: tabella gestita
-- verifica: 2021-10-19 15:16 Fabio Mosti
CREATE TABLE IF NOT EXISTS `video` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_file` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_categoria_progetti` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_edificio` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_valutazione` int(11) DEFAULT NULL, 
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `id_embed` int(11) DEFAULT NULL,
  `codice_embed` char(128) DEFAULT NULL,
  `embed_custom` char(128) DEFAULT NULL,
  `target` char(255) DEFAULT NULL,
  `orientamento` enum('L','P') DEFAULT NULL,
  `ratio` char(8) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000100000

-- zone
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
CREATE TABLE IF NOT EXISTS `zone` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000100100

-- zone_cap
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
CREATE TABLE IF NOT EXISTS `zone_cap` (
  `id` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `cap` char(8) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000100200

-- zone_indirizzi
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
CREATE TABLE IF NOT EXISTS `zone_indirizzi` (
  `id` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,  
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000100300

-- zone_provincie
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
CREATE TABLE IF NOT EXISTS `zone_provincie` (
`id` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_provincia` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 010000100400

-- zone_stati
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
CREATE TABLE IF NOT EXISTS `zone_stati` (
  `id` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_stato` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | FINE FILE
