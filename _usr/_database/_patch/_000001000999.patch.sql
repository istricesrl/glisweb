--
-- TABELLE
-- questo file contiene le query per la creazione delle tabelle; si noti che non devono essere inseriti qui i valori
-- di auto increment, mentre vanno specificati per tabella il CHARSET ma non il COLLATE.
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

--| 000001000018

-- assicurazioni_montaggio_prezzi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `assicurazioni_montaggio_prezzi` (
`id` int(11) NOT NULL,
  `id_assicurazione` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000019

-- assicurazioni_trasporto
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `assicurazioni_trasporto` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `suggerimento` char(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000020

-- assicurazioni_trasporto_prezzi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `assicurazioni_trasporto_prezzi` (
`id` int(11) NOT NULL,
  `id_assicurazione` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000021

-- attivita
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `attivita` (
`id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_tipologia_inps` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_mandante` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000022

-- attivita_anagrafica
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `attivita_anagrafica` (
`id` int(11) NOT NULL,
  `id_attivita` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000023

-- attivita_categorie
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `attivita_categorie` (
`id` int(11) NOT NULL,
  `id_attivita` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000024

-- audio
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `audio` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--| FINE FILE
