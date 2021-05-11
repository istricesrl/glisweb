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

-- anagrafica_cittadinanze
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
  `id_tipologia` int(11) NOT NULL,
  `id_inviante` int(11) DEFAULT NULL,
  `id_campagna` int(11) DEFAULT NULL,
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

--| 000001000025

-- campagne
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `campagne` (
`id` int(11) NOT NULL,
  `nome` char(128) NOT NULL,
  `testo` text,
  `id_account_chiusura` int(11) DEFAULT NULL,
  `timestamp_chiusura` int(11) DEFAULT NULL,
  `testo_chiusura` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--| 000001000026

-- caratteristiche_articoli
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `caratteristiche_articoli` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000027

-- caratteristiche_immobili
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `caratteristiche_immobili` (
`id` int(11) NOT NULL,
  `nome` char(128) NOT NULL,
  `font_awesome` char(24) DEFAULT NULL,
  `html` char(8) DEFAULT NULL,
  `se_immobile` int(1) DEFAULT NULL,
  `se_indirizzo` int(1) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

--| 000001000028

-- caratteristiche_prodotti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `caratteristiche_prodotti` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000029

-- carrelli
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `carrelli` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000030

-- carrelli_articoli
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `carrelli_articoli` (
`id` int(11) NOT NULL,
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
  `importo_lordo_sconto` decimal(16,5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000031

-- categorie_anagrafica
-- tipologia: tabella assistita
CREATE TABLE IF NOT EXISTS `categorie_anagrafica` (
`id` int(11) NOT NULL,
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
  `se_squadra` int(1) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

--| 000001000032

-- categorie_attivita
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `categorie_attivita` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000033

-- categorie_diritto
-- tipologia: tabella assistita
CREATE TABLE IF NOT EXISTS `categorie_diritto` (
`id` int(11) NOT NULL,
  `nome` varchar(128) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000034

-- categorie_documenti
-- tipologia: tabella assistita

--| 000001000035

-- categorie_eventi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `categorie_eventi` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `id_tipologia_pubblicazione` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000036

-- categorie_notizie
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `categorie_notizie` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `menu` char(64) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `id_tipologia_pubblicazione` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000037

-- categorie_prodotti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `categorie_prodotti` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `menu` char(64) DEFAULT NULL,
  `id_tipologia_pubblicazione` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000038

-- categorie_prodotti_caratteristiche
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `categorie_prodotti_caratteristiche` (
`id` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `se_non_presente` int(1) DEFAULT NULL,
  `se_visibile` int(1) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `testo` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000039

-- categorie_risorse
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `categorie_risorse` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `menu` char(64) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000040

-- classi_energetiche_immobili
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `classi_energetiche_immobili` (
`id` int(11) NOT NULL,
  `nome` char(8) NOT NULL,
  `ep_min` int(11) DEFAULT NULL,
  `ep_max` int(11) DEFAULT NULL,
  `rgb` char(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000041

-- colori
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `colori` (
`id` int(11) NOT NULL,
  `nome` char(16) NOT NULL,
  `hex` char(8) DEFAULT NULL,
  `r` int(3) DEFAULT NULL,
  `g` int(3) DEFAULT NULL,
  `b` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000042

-- comuni
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `comuni` (
`id` int(11) NOT NULL,
  `id_provincia` int(11) NOT NULL,
  `nome` varchar(254) NOT NULL,
  `codice_istat` char(12) DEFAULT NULL,
  `codice_catasto` char(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000043

-- condizioni_immobili
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `condizioni_immobili` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--| 000001000044

-- contatti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `contatti` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `json` text NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_segnalatore` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000045

-- contenuti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `contenuti` (
`id` int(11) NOT NULL,
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
  `destinatario_ccn_mail` char(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000046

-- continenti
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `continenti` (
`id` int(11) NOT NULL,
  `codice` char(2) COLLATE utf8_general_ci DEFAULT NULL,
  `nome` char(32) COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000047

-- contratti`
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `contratti` (
`id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_agenzia` int(11) NOT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `data_inizio_rapporto` date DEFAULT NULL,
  `data_fine_rapporto` date DEFAULT NULL,
  `livello` char(64) DEFAULT NULL,
  `id_tipologia_qualifica` char(32) DEFAULT NULL,
  `id_tipologia_durata` char(32) DEFAULT NULL,
  `id_tipologia_orario` char(32) DEFAULT NULL,
  `ore_settimanali` DECIMAL(5,2) DEFAULT NULL,
  `note` text,
  `percentuale_part_time` decimal(6,3) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000048

-- costi_contratti`
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `costi_contratti` (
`id` int(11) NOT NULL,
  `id_contratto` int(11) NOT NULL,
  `id_tipologia` INT NOT NULL,
  `note` text,
  `costo_orario` decimal(16,5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000049

-- coupon
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `coupon` (
  `id` char(32) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `timestamp_inizio` int(11) DEFAULT NULL,
  `timestamp_fine` int(11) DEFAULT NULL,
  `sconto_percentuale` decimal(5,2) DEFAULT NULL,
  `sconto_fisso` decimal(15,2) DEFAULT NULL,
  `se_multiuso` int(1) NULL DEFAULT '1',
  `se_globale` int(1) NULL DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000050

-- coupon_categorie_prodotti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `coupon_categorie_prodotti` (
`id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_categoria_prodotti` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000051

-- coupon_listini
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `coupon_listini` (
`id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_listino` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000052

-- coupon_marchi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `coupon_marchi` (
`id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_marchio` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000053

-- coupon_prodotti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `coupon_prodotti` (
`id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_prodotto` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000054

-- coupon_stagioni
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `coupon_stagioni` (
`id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_stagione` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000055

-- cron
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `cron` (
`id` int(11) NOT NULL,
  `minuto` int(11) DEFAULT NULL,
  `ora` int(11) DEFAULT NULL,
  `giorno_del_mese` int(11) DEFAULT NULL,
  `mese` int(11) DEFAULT NULL,
  `giorno_della_settimana` int(11) DEFAULT NULL,
  `settimana` int(11) DEFAULT NULL,
  `task` char(255) NOT NULL,
  `iterazioni` int(11) DEFAULT NULL,
  `delay` int(11) DEFAULT NULL,
  `timestamp_esecuzione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000056

-- cron_log
-- tipologia: tabella gestita
CREATE TABLE `cron_log` (
  `id` int(11) NOT NULL,
  `id_cron` int(11) NOT NULL,
  `testo` text,
  `timestamp_esecuzione` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000057

-- date
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `date` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000058

-- disponibilita_immobili
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `disponibilita_immobili` (
	`id` int(11) NOT NULL,
 	`nome` char(32) NOT NULL,
 	`se_disponibile` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000059

-- documenti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `documenti` (
`id` int(11) NOT NULL,
  `numero` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `data` date NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_destinatario` int(11) NOT NULL,
  `id_sede_destinatario` int(11) DEFAULT NULL,
  `id_emittente` int(11) NOT NULL,
  `id_sede_emittente` int(11) DEFAULT NULL,
  `note_interne` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000060

-- documenti_amministrativi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `documenti_amministrativi` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 000001000061

-- documenti_articoli
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `documenti_articoli` (
`id` int(11) NOT NULL,
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
  `specifiche` char(255) DEFAULT NULL,
  `testo` text,
  `path` char(255) DEFAULT NULL,
  `se_rimborso` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--| FINE FILE
