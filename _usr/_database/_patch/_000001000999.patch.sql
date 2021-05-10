--
-- TABELLE
-- questo file contiene le query per la creazione delle tabelle
--
-- INDICE DEGLI SCRIPT
-- 000001 -> tabelle
-- 000002 -> placeholder
-- 000003 -> indici
-- 000004 -> acl
-- 000005 -> dati
-- 000006 -> limiti
-- 000007 -> procedure
-- 000008 -> viste
-- 000009 -> report
-- 000010 -> statiche
-- 000011 -> trigger
--

--| 000001000001

-- account
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `account` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000002

-- account_gruppi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `account_gruppi` (
  `id` int(11) NOT NULL,
  `id_account` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  `se_amministratore` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--| 000001000003

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `account_gruppi_attribuzione` (
  `id` int(11) NOT NULL,
  `id_account` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  `entita` char(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000004

-- anagrafica
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `anagrafica` (	
  `id` int(11) NOT NULL,	
  `codice` char(32) DEFAULT NULL,
  `riferimento` char(32) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,	
  `nome` char(64) DEFAULT NULL,	
  `cognome` char(255) DEFAULT NULL,	
  `denominazione` char(255) DEFAULT NULL,	
  `soprannome` char(128) DEFAULT NULL,	
  `sesso` enum('M','F','-') NOT NULL DEFAULT '-',
  `stato_civile` char(128) DEFAULT NULL,
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
  `id_tipologia_crm` int(11) DEFAULT NULL,	
  `id_agente` int(11) DEFAULT NULL,	
  `note_commerciali` text,	
  `condizioni_vendita` text,	
  `condizioni_acquisto` text,	
  `note` text,	
  `data_cessazione` date DEFAULT NULL,	
  `note_cessazione` text,	
  `recapiti` text,	
  `se_importata` int(1) DEFAULT NULL,	
  `se_stampa_privacy` int(1) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000005

-- anagrafica_categorie
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `anagrafica_categorie` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000006

-- anagrafica_categorie_diritto
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `anagrafica_categorie_diritto` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_diritto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000007

-- anagrafica_categorie_cittadinanze
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `anagrafica_cittadinanze` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_stato` int(11) NOT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000008

-- anagrafica_condizioni_pagamento
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `anagrafica_condizioni_pagamento` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_condizione` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000009

-- anagrafica_indirizzi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `anagrafica_indirizzi` (
`id` int(11) NOT NULL,
  `id_indirizzo` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `interno` char(8) DEFAULT NULL,
  `descrizione` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000010

-- anagrafica_modalita_pagamento
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `anagrafica_modalita_pagamento` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_modalita_pagamento` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000011

-- anagrafica_provenienze
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `anagrafica_provenienze` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_provenienza` int(11) NOT NULL,
  `testo` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000012

-- anagrafica_ruoli
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `anagrafica_ruoli` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `specifica_ruolo` char(255) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000013

-- anagrafica_servizi_contatto
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `anagrafica_servizi_contatto` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_servizio_contatto` int(11) NOT NULL,
  `testo` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000014

-- anagrafica_settori
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `anagrafica_settori` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_settore` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000015

-- articoli
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `articoli` (
  `id` char(32) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  `nome` char(128) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_taglia` int(11) DEFAULT NULL,
  `id_colore` int(11) DEFAULT NULL,
  `id_udm` int(11) DEFAULT NULL,
  `se_disponibile` int(1) DEFAULT '1',
  `quantita_disponibile` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000016

-- articoli_caratteristiche
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `articoli_caratteristiche` (
`id` int(11) NOT NULL,
  `id_articolo` char(32) NOT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `testo` text,
  `se_non_presente` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000017

-- assicurazioni_montaggio
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `assicurazioni_montaggio` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `suggerimento` char(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--| FINE FILE
