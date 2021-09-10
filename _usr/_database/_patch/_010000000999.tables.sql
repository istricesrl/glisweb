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

--| 010000000100

-- account
-- tipologia: tabella gestita
-- verifica: 2021-05-20 13:57 Fabio Mosti
CREATE TABLE IF NOT EXISTS `account` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_mail` int(11) DEFAULT NULL,
  `username` char(64) NOT NULL,
  `password` char(128) DEFAULT NULL,
  `se_attivo` int(1) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_login` int(11) DEFAULT NULL,
  `timestamp_cambio_password` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000200

-- account_gruppi
-- tipologia: tabella gestita
-- verifica: 2021-05-20 15:56 Fabio Mosti
CREATE TABLE IF NOT EXISTS `account_gruppi` (
  `id` int(11) NOT NULL,
  `id_account` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  `se_amministratore` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000300

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
-- verifica: 2021-05-20 17:05 Fabio Mosti
CREATE TABLE IF NOT EXISTS `account_gruppi_attribuzione` (
  `id` int(11) NOT NULL,
  `id_account` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  `entita` char(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000400

-- anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:30 Fabio Mosti
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
  `codice_fiscale` char(32) DEFAULT NULL,
  `partita_iva` char(32) DEFAULT NULL,
  `codice_sdi` char(32) DEFAULT NULL,
  `id_pec_sdi` int(11) DEFAULT NULL,
  `id_regime_fiscale` int(11) DEFAULT NULL,
  `note_amministrative` text,
  `luogo_nascita` char(128) DEFAULT NULL,
  `stato_nascita` char(128) DEFAULT NULL,
  `id_stato_nascita` int(11) DEFAULT NULL,
  `comune_nascita` char(128) DEFAULT NULL,
  `id_comune_nascita` int(11) DEFAULT NULL,
  `giorno_nascita` int(2) DEFAULT NULL,
  `mese_nascita` int(2) DEFAULT NULL,
  `anno_nascita` int(4) DEFAULT NULL,
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
  `se_importata` int(1) DEFAULT NULL,
  `se_stampa_privacy` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000500

-- anagrafica_categorie
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:30 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_categorie` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000600

-- anagrafica_categorie_diritto
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:30 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_categorie_diritto` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `se_specialita` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000700

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_cittadinanze` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_stato` int(11) NOT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000800

-- anagrafica_condizioni_pagamento
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:59 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_condizioni_pagamento` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_condizione` int(11) NOT NULL,
  `note` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000900

-- anagrafica_indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-05-21 16:30 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_indirizzi` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_indirizzo` int(11) NOT NULL,
  `interno` char(8) DEFAULT NULL,
  `note` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000001000

-- anagrafica_modalita_pagamento
-- tipologia: tabella gestita
-- verifica: 2021-05-22 16:23 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_modalita_pagamento` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_modalita` int(11) NOT NULL,
  `note` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000001100

-- anagrafica_ruoli
-- tipologia: tabella gestita
-- verifica: 2021-05-23 14:39 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_ruoli` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000001200

-- anagrafica_settori
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:38 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_settori` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_settore` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- NOTA servirebbe un campo ordine oppure un campo per indicare in qualche modo il peso relativo del settore per l'anagrafica?

--| 010000001300

-- articoli
-- tipologia: tabella gestita
-- verifica: 2021-05-25 10:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `articoli` (
  `id` char(32) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `ean` char(32) DEFAULT NULL,
  `isbn` char(32) DEFAULT NULL,
  `id_reparto` int(11) DEFAULT NULL,
  `id_taglia` int(11) DEFAULT NULL,
  `id_colore` int(11) DEFAULT NULL,
  `larghezza` int(11) DEFAULT NULL,
  `lunghezza` int(11) DEFAULT NULL,
  `altezza` int(11) DEFAULT NULL,
  `peso` int(11) DEFAULT NULL,
  `volume` int(11) DEFAULT NULL,
  `capacita` int(11) DEFAULT NULL,
  `durata` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000001600

-- articoli_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-05-25 11:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `articoli_caratteristiche` (
  `id` int(11) NOT NULL,
  `id_articolo` char(32) NOT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `valore` decimal(5,2) DEFAULT NULL,
  `note` text,
  `se_assente` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000001800

-- attivita
-- tipologia: tabella gestita
-- verifica: 2021-05-25 17:14 Fabio Mosti
CREATE TABLE IF NOT EXISTS `attivita` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_tipologia_inps` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `referenti` char(255) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `note_scadenza` text,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `note_programmazione` text,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `data_attivita` date DEFAULT NULL,
  `ora_inizio` time DEFAULT NULL,
  `latitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `latitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `ore` decimal(5,2) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `testo` text,
  `id_progetto` char(32) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_campagna` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_richiesta` int(11) DEFAULT NULL,
  `id_todo_articoli` int(11) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `token` char(128) NOT NULL,
  `timestamp_calcolo_sostituti` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000002100

-- audio
-- tipologia: tabella gestita
-- verifica: 2021-05-28 15:39 Fabio Mosti
CREATE TABLE IF NOT EXISTS `audio` (
  `id` int(11) NOT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `codice_embed` char(255) DEFAULT NULL,
  `id_tipologia_embed` int(11) NOT NULL,
  `nome` char(64) DEFAULT NULL,
  `target` char(255) DEFAULT NULL,
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
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000002500

-- campagne
-- tipologia: tabella gestita
-- verifica: 2021-05-28 17:41 Fabio Mosti
CREATE TABLE IF NOT EXISTS `campagne` (
  `id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `note` text,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `timestamp_chiusura` int(11) DEFAULT NULL,
  `note_chiusura` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000002700

-- caratteristiche_immobili
-- tipologia: tabella di supporto
-- verifica: 2021-05-28 18:22 Fabio Mosti
CREATE TABLE IF NOT EXISTS `caratteristiche_immobili` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `font_awesome` char(24) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `se_indirizzo` int(1) DEFAULT NULL,
  `se_immobile` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000002900

-- caratteristiche_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-05-28 18:22 Fabio Mosti
CREATE TABLE IF NOT EXISTS `caratteristiche_prodotti` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `font_awesome` char(24) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `se_categoria` int(1) DEFAULT NULL,
  `se_prodotto` int(1) DEFAULT NULL,
  `se_articolo` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000003100

-- categorie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-05-28 19:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_anagrafica` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
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
  `se_produzione` int(1) DEFAULT NULL,
  `se_notizie` int(1) DEFAULT NULL,
  `se_docente` int(1) DEFAULT NULL,
  `se_tutor` int(1) DEFAULT NULL,
  `se_classe` int(1) DEFAULT NULL,
  `se_allievo` int(1) DEFAULT NULL,
  `se_agenzia_interinale` int(1) DEFAULT NULL,
  `se_referente` int(1) DEFAULT NULL,
  `se_sostituto` int(1) DEFAULT NULL,
  `se_squadra` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000003300

-- categorie_diritto
-- tipologia: tabella assistita
-- verifica: 2021-05-31 14:34 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_diritto` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` varchar(128) NOT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000003500

-- categorie_eventi
-- tipologia: tabella gestita
-- verifica: 2021-06-01 18:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_eventi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000003700

-- categorie_notizie
-- tipologia: tabella gestita
-- verifica: 2021-06-01 18:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_notizie` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000003900

-- categorie_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-01 19:43 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_prodotti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000004100

-- categorie_prodotti_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-06-02 19:12 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_prodotti_caratteristiche` (
  `id` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `note` text,
  `se_assente` int(1) DEFAULT NULL,
  `se_visibile` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000004300

-- categorie_progetti
-- tipologia: tabella gestita
-- verifica: 2021-06-02 19:40 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_progetti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000004500

-- categorie_risorse
-- tipologia: tabella gestita
-- verifica: 2021-06-02 20:04 Fabio Mosti
CREATE TABLE IF NOT EXISTS `categorie_risorse` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000004700

-- classi_energetiche
-- tipologia: tabella di supporto
-- verifica: 2021-06-02 20:35 Fabio Mosti
CREATE TABLE IF NOT EXISTS `classi_energetiche` (
  `id` int(11) NOT NULL,
  `nome` char(8) NOT NULL,
  `ep_min` int(11) DEFAULT NULL,
  `ep_max` int(11) DEFAULT NULL,
  `id_colore` int(11) DEFAULT NULL,
  `se_immobili` int(1) DEFAULT NULL,
  `se_prodotti` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000005100

-- colori
-- tipologia: tabella di supporto
-- verifica: 2021-06-02 22:22 Fabio Mosti
CREATE TABLE IF NOT EXISTS `colori` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(16) NOT NULL,
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

--| 010000005300

-- comuni
-- tipologia: tabella di supporto
-- verifica: 2021-06-03 19:53 Fabio Mosti
CREATE TABLE IF NOT EXISTS `comuni` (
  `id` int(11) NOT NULL,
  `id_provincia` int(11) NOT NULL,
  `nome` varchar(254) NOT NULL,
  `codice_istat` char(12) DEFAULT NULL,
  `codice_catasto` char(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000005900

-- condizioni_immobili
-- tipologia: tabella di supporto
-- CREATE TABLE IF NOT EXISTS `condizioni_immobili` (
--   `id` int(11) NOT NULL,
--   `nome` char(32) NOT NULL
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000005900

-- condizioni_pagamento

--| 010000006700

-- contatti
-- tipologia: tabella gestita
-- verifica: 2021-06-03 21:33 Fabio Mosti
CREATE TABLE IF NOT EXISTS `contatti` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_campagna` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_inviante` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `json` text DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000006900

-- contenuti
-- tipologia: tabella gestita
-- verifica: 2021-06-04 17:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `contenuti` (
  `id` int(11) NOT NULL,
  `id_lingua` int(11) NOT NULL,
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
  `id_immobile` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_rassegna_stampa` int(11) DEFAULT NULL,
  `id_evento` int(11) DEFAULT NULL,
  `id_categoria_eventi` int(11) DEFAULT NULL,
  `id_data` int(11) DEFAULT NULL,
  `id_template_mail` int(11) DEFAULT NULL,
  `id_mailing` int(11) DEFAULT NULL,
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
  `abstract` text,
  `testo` text,
  `applicazioni` text,
  `specifiche` text,
  `label_menu` char(255) DEFAULT NULL,
  `mittente_nome` char(128) DEFAULT NULL,
  `mittente_mail` char(128) DEFAULT NULL,
  `destinatario_nome` char(128) DEFAULT NULL,
  `destinatario_mail` char(128) DEFAULT NULL,
  `destinatario_cc_nome` char(128) DEFAULT NULL,
  `destinatario_cc_mail` char(128) DEFAULT NULL,
  `destinatario_ccn_nome` char(128) DEFAULT NULL,
  `destinatario_ccn_mail` char(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000007100

-- continenti
-- tipologia: tabella di supporto
-- verifica: 2021-06-09 11:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `continenti` (
  `id` int(11) NOT NULL,
  `codice` char(2) COLLATE utf8_general_ci DEFAULT NULL,
  `nome` char(32) COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000007600

-- contratti
-- tipologia: tabella gestita
-- verifica: 2021-06-09 12:33 Fabio Mosti
CREATE TABLE IF NOT EXISTS `contratti` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_azienda` int(11) NOT NULL,
  `id_agenzia` int(11) NOT NULL,
  `data_stipula` date DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `data_inizio_rapporto` date DEFAULT NULL,
  `data_fine_rapporto` date DEFAULT NULL,
  `id_livello` int(11) DEFAULT NULL,
  `id_qualifica` int(11) DEFAULT NULL,
  `id_tipologia_durata` int(11) DEFAULT NULL,
  `id_tipologia_orario` int(11) DEFAULT NULL,
  `ore_settimanali` DECIMAL(5,2) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000007700

-- correlazioni_articoli
-- tipologia: tabella assistita
-- verifica: 2021-05-25 18:07 Fabio Mosti
CREATE TABLE IF NOT EXISTS `correlazioni_articoli` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_articolo` int(11) DEFAULT NULL,
  `id_prodotto_correlato` int(11) DEFAULT NULL,
  `id_articolo_correlato` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_upselling` int(1) DEFAULT NULL,
  `se_crosselling` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000007800

-- costi_contratti
-- tipologia: tabella gestita
-- verifica: 2021-06-09 12:38 Fabio Mosti
CREATE TABLE IF NOT EXISTS `costi_contratti` (
  `id` int(11) NOT NULL,
  `id_contratto` int(11) NOT NULL,
  `id_tipologia_inps_attivita` INT NOT NULL,
  `costo_orario` decimal(16,5) DEFAULT NULL,
  `note` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000008000

-- coupon
-- tipologia: tabella gestita
-- verifica: 2021-06-29 15:50 Fabio Mosti
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

--| 010000008200

-- coupon_categorie_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:06 Fabio Mosti
CREATE TABLE IF NOT EXISTS `coupon_categorie_prodotti` (
  `id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_categoria` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000008400

-- coupon_listini
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:37 Fabio Mosti
CREATE TABLE IF NOT EXISTS `coupon_listini` (
  `id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_listino` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000008600

-- coupon_marchi
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `coupon_marchi` (
  `id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_marchio` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000008800

-- coupon_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:56 Fabio Mosti
CREATE TABLE IF NOT EXISTS `coupon_prodotti` (
  `id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_prodotto` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000009000

-- coupon_stagioni
-- tipologia: tabella gestita
-- verifica: 2021-06-29 17:02 Fabio Mosti
CREATE TABLE IF NOT EXISTS `coupon_stagioni` (
  `id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_stagione` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000009200

-- cron
-- tipologia: tabella assistita
-- verifica: 2021-06-30 11:23 Fabio Mosti
CREATE TABLE `cron` (
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
  `token` char(254) DEFAULT NULL,
  `timestamp_esecuzione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000009400

-- date
-- tipologia: tabella gestita
-- verifica: 2021-06-30 11:15 Fabio Mosti
CREATE TABLE IF NOT EXISTS `date` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_evento` int(11) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `timestamp_inizio` int(11) DEFAULT NULL,
  `timestamp_fine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000009800

-- documenti
-- tipologia: tabella gestita
-- verifica: 2021-08-06 15:55 Fabio Mosti
CREATE TABLE IF NOT EXISTS `documenti` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `numero` int(11) NOT NULL,
  `data` date NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_emittente` int(11) NOT NULL,
  `id_sede_emittente` int(11) DEFAULT NULL,
  `id_destinatario` int(11) NOT NULL,
  `id_sede_destinatario` int(11) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000010000

-- documenti_articoli
-- tipologia: tabella gestita
-- verifica: 2021-09-10 11:57 Fabio Mosti
CREATE TABLE IF NOT EXISTS `documenti_articoli` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `data` date NOT NULL,
  `id_destinatario` int(11) DEFAULT NULL,
  `id_emittente` int(11) DEFAULT NULL,
  `id_reparto` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_attivita` int(11) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `id_udm` int(11) DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `id_listino` int(11) DEFAULT NULL,
  `id_valuta` int(11) DEFAULT NULL,
  `importo_netto_totale` decimal(9,2) NOT NULL,
  `id_iva` int(11) DEFAULT NULL,
  `nome` text,
  `specifiche` char(255) DEFAULT NULL,
  `testo` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000015000

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
  `id_template_mail` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `path` char(255) NOT NULL,
  `url` text,
  `nome` char(255) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000015200

-- gruppi
-- tipologia: tabella gestita
-- verifica: 2021-09-10 17:58 Fabio Mosti
CREATE TABLE IF NOT EXISTS `gruppi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_struttura` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- NOTE
-- questa tabella contiene i gruppi aggiuntivi del framework

--| 010000000077

-- iban
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `iban` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `intestazione` char(255) DEFAULT NULL,
  `iban` char(27) NOT NULL,
  `note` text NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000078

-- immagini
-- tipologia: tabella gestita
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
  `id_evento` int(11) DEFAULT NULL,
  `id_categoria_eventi` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_testata` int(11) DEFAULT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000079

-- immagini_anagrafica
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `immagini_anagrafica` (
`id` int(11) NOT NULL,
  `id_immagine` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_ruolo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000080

-- immobili
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `immobili` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000081

-- immobili_anagrafica
-- tiplogia: tabella gestita
CREATE TABLE IF NOT EXISTS `immobili_anagrafica` (
`id` int(11) NOT NULL,
  `id_immobile` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_ruolo` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000082

-- immobili_caratteristiche
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `immobili_caratteristiche` (
`id` int(11) NOT NULL,
  `id_immobile` int(11) NOT NULL,
  `id_caratteristica` int(11) NOT NULL,
  `specifiche` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000083

-- incarichi_immobili
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `incarichi_immobili` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000084

-- incroci_immobili
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `incroci_immobili` (
`id` int(11) NOT NULL,
  `id_incarico` int(11) NOT NULL,
  `id_richiesta` int(11) NOT NULL,
  `note_incrocio` text,
  `id_esito` int(11) DEFAULT NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL,
  `note_archiviazione` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000085

-- indirizzi
-- tipologia: tabella gestita

CREATE TABLE IF NOT EXISTS `indirizzi` (
`id` int(11) NOT NULL,
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
  `id_account_editor` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000086

-- indirizzi_caratteristiche
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `indirizzi_caratteristiche` (
`id` int(11) NOT NULL,
  `id_indirizzo` int(11) NOT NULL,
  `id_caratteristica` int(11) NOT NULL,
  `specifiche` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000087

-- iva
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `iva` (
`id` int(11) NOT NULL,
  `aliquota` decimal(5,2) NOT NULL,
  `nome` char(64) NOT NULL,
  `descrizione` text,
  `codice` char(8) DEFAULT NULL,
  `se_ecommerce` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000088

-- job
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `job` (
`id` int(11) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `job` char(255) NOT NULL,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `totale` int(11) DEFAULT NULL,
  `corrente` int(11) DEFAULT NULL,
  `iterazioni` int(11) DEFAULT NULL,
  `delay` int(11) DEFAULT NULL,
  `workspace` text,
  `timestamp_esecuzione` int(11) DEFAULT NULL,
  `timestamp_completamento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000089

-- lingue
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `lingue` (
`id` int(11) NOT NULL,
  `nome` char(128) COLLATE utf8_general_ci NOT NULL,
  `note` char(128) COLLATE utf8_general_ci DEFAULT NULL,
  `iso6391alpha2` char(36) COLLATE utf8_general_ci DEFAULT NULL,
  `iso6393alpha3` char(36) COLLATE utf8_general_ci DEFAULT NULL,
  `ietf` char(36) COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000090

-- liste_mailing
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `liste_mailing` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `descrizione` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000091

-- listini
-- tipologia: tabella assistita
CREATE TABLE IF NOT EXISTS `listini` (
`id` int(11) NOT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `id_valuta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000092

-- listini_clienti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `listini_clienti` (
`id` int(11) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000093

-- luoghi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `luoghi` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(255) COLLATE utf8_general_ci NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000094

-- macro
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `macro` (
`id` int(11) NOT NULL,
  `id_pagina` int(11) NOT NULL,
  `macro` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000095

-- mail
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `mail` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `se_notifiche` tinyint(1) DEFAULT NULL,
  `se_pec` tinyint(1) DEFAULT NULL,
  `indirizzo` char(128) NOT NULL,
  `descrizione` char(128) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000096

-- mail_liste_mailing
-- tipolgia: tabella gestita
CREATE TABLE IF NOT EXISTS `mail_liste_mailing` (
`id` int(11) NOT NULL,
  `id_mail` int(11) NOT NULL,
  `id_lista` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000097

-- mail_out
-- tipolgia: tabella gestita
CREATE TABLE IF NOT EXISTS `mail_out` (
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000098

-- mail_sent
-- tipolgia: tabella gestita
CREATE TABLE IF NOT EXISTS `mail_sent` (
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000099

-- mailing
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `mailing` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `note` text,
  `id_job` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000100

-- mailing_liste
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `mailing_liste` (
`id` int(11) NOT NULL,
  `id_mailing` int(11) NOT NULL,
  `id_lista` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000101

-- mailing_mail
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `mailing_mail` (
`id` int(11) NOT NULL,
  `id_mail` int(11) NOT NULL,
  `id_mailing` int(11) NOT NULL,
  `id_mail_coda` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000102

-- mastri
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `mastri` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `note` text,
  `se_commerciale` int(1) DEFAULT NULL,
  `se_produzione` int(1) DEFAULT NULL,
  `se_amministrazione` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000103

-- marchi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `marchi` (
`id` int(11) NOT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000104

-- matricole
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `matricole` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `testo` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000105

-- menu
CREATE TABLE IF NOT EXISTS `menu` (
`id` int(11) NOT NULL,
  `id_pagina` int(11) NOT NULL,
  `id_lingua` int(11) NOT NULL,
  `menu` char(32) NOT NULL,
  `nome` char(128) NOT NULL,
  `target` char(16) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `sottopagine` char(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000106

-- metadati
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `metadati` (
`id` int(11) NOT NULL,
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
  `testo` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000107

-- modalita_consegna
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `modalita_consegna` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `suggerimento` char(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000108

-- modalita_consegna_prezzi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `modalita_consegna_prezzi` (
`id` int(11) NOT NULL,
  `id_modalita` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000109

-- modalita_pagamento
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `modalita_pagamento` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `suggerimento` char(255) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `importo_min` decimal(16,5) DEFAULT NULL,
  `importo_max` decimal(16,5) DEFAULT NULL,
  `percentuale_acconto` DECIMAL(5,2) NULL DEFAULT NULL,
  `se_contanti` int(1) DEFAULT NULL,
  `provider` char(64) DEFAULT NULL,
  `codice` char(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000110

-- modalita_pagamento_prezzi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `modalita_pagamento_prezzi` (
`id` int(11) NOT NULL,
  `id_modalita` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `prezzo_relativo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000111

-- modalita_spedizione
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `modalita_spedizione` (
`id` int(11) NOT NULL,
  `nome` char(255) COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000112

-- modalita_spedizione_prezzi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `modalita_spedizione_prezzi` (
`id` int(11) NOT NULL,
  `id_modalita` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000113

-- motivazioni_tari_anagrafica
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `motivazioni_tari_anagrafica` (
`id` int(11) NOT NULL,
  `id_tari_anagrafica` int(11) NOT NULL,
  `id_motivazione` int(11) NOT NULL,
  `riga_provenienza` text,
  `dettagli_provenienza` text NOT NULL,
  `path` text NOT NULL,
  `riga` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000114

-- notizie
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `notizie` (
`id` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000115

-- notizie_categorie
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `notizie_categorie` (
`id` int(11) NOT NULL,
  `id_notizia` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000116

-- notizie_categorie_prodotti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `notizie_categorie_prodotti` (
`id` int(11) NOT NULL,
  `id_notizia` int(11) NOT NULL,
  `id_categoria_prodotti` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000117

-- notizie_immobili
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `notizie_immobili` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000118

-- notizie_prodotti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `notizie_prodotti` (
`id` int(11) NOT NULL,
  `id_notizia` int(11) NOT NULL,
  `id_prodotto` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000119

-- orari_contratti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `orari_contratti` (
`id` int(11) NOT NULL,
  `id_contratto` int(11) NOT NULL,
  `turno` INT NULL DEFAULT '1',
  `id_giorno` int(11) NOT NULL,
  `ora_inizio` time DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `id_costo` int(11) NOT NULL,
  `se_lavoro` INT(1) NULL DEFAULT '1', 
  `se_disponibile` INT(1) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000120

-- orientamenti_sessuali
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `orientamenti_sessuali` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000121

-- pagine
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `pagine` (
`id` int(11) NOT NULL,
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
  `id_account_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000122

-- pagine_gruppi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `pagine_gruppi` (
`id` int(11) NOT NULL,
  `id_pagina` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000123

-- patrocini_pratiche
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `patrocini_pratiche` (
`id` int(11) NOT NULL,
  `id_pratica` int(11) NOT NULL,
  `numero` char(32) NOT NULL,
  `se_liquidato` int(1) DEFAULT NULL,
  `se_fatturato` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000124

-- pause_progetti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `pause_progetti` (
`id` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `data_inizio` date NOT NULL,
  `data_fine` date NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000125

-- periodi_variazioni_attivita
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `periodi_variazioni_attivita` (
`id` int(11) NOT NULL,
  `id_variazione` int(11) NOT NULL,
  `data_inizio` date NOT NULL,
  `data_fine` date NOT NULL,
  `ora_inizio` time DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `timestamp_elaborazione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000126

-- pianificazioni
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `pianificazioni` (
`id` int(11) NOT NULL,
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
  `giorni_rinnovo` int(11) DEFAULT NULL,
  `note` text,
  `workspace` text,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000127

-- popup
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `popup` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000128

-- popup_pagine`
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `popup_pagine` (
`id` int(11) NOT NULL,
  `id_pagina` int(11) NOT NULL,
  `id_popup` int(11) NOT NULL,
  `se_presente` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000129

-- pratiche
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `pratiche` (
`id` int(11) NOT NULL,
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
  `timestamp_chiusura` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000130

-- pratiche_assistiti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `pratiche_assistiti` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_pratica` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000131

-- pratiche_avvocati
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `pratiche_avvocati` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_pratica` int(11) NOT NULL,
  `se_responsabile` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000132

-- pratiche_servizi_contatto
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `pratiche_servizi_contatto` (
`id` int(11) NOT NULL,
  `id_pratica` int(11) NOT NULL,
  `id_servizio_contatto` int(11) NOT NULL,
  `testo` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000133

-- prezzi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `prezzi` (
`id` int(11) NOT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) DEFAULT NULL,
  `id_iva` int(11) NOT NULL,
  `id_udm` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000134

-- priorita
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `priorita` (
  `id` int(11) NOT NULL,
  `nome` char(32) COLLATE utf8_general_ci NOT NULL,
  `ordine` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000135

-- prodotti
-- tipologia: tabella gestita
	CREATE TABLE IF NOT EXISTS `prodotti` (	
  `id` char(32) NOT NULL,	
  `id_tipologia` int(11) NOT NULL,	
  `nome` char(128) NOT NULL,	
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
  `id_tipologia_pubblicazione` int(11) NOT NULL,	
  `se_disponibile` int(1) NULL DEFAULT '1',	
  `timestamp_pubblicazione` int(11) DEFAULT NULL,	
  `timestamp_archiviazione` int(11) DEFAULT NULL,	
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000136

-- prodotti_categorie
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `prodotti_categorie` (
`id` int(11) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_principale` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000137

-- prodotti_modalita_spedizione
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `prodotti_modalita_spedizione` (
`id` int(11) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  `id_modalita` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000138

-- prodotti_caratteristiche
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `prodotti_caratteristiche` (
`id` int(11) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `testo` text,
  `se_non_presente` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000139

-- prodotti_stagioni
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `prodotti_stagioni` (
`id` int(11) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  `id_stagione` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000140

-- progetti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `progetti` (
  `id` char(32) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `testo` text,
  `id_pianificazione` int(11) DEFAULT NULL,
  `ranking` char(32) DEFAULT NULL,
  `id_account_accettazione` int(11) DEFAULT NULL,
  `data_accettazione` DATE DEFAULT NULL,
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
  `se_lavoro_weekend` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000141

-- progetti_anagrafica
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `progetti_anagrafica` (
`id` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `se_sostituto` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000142

-- provenienze_contatti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `provenienze_contatti` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_contatto` int(11) DEFAULT NULL,
  `se_segnalato` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000143

-- provincie
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `provincie` (
`id` int(11) NOT NULL,
  `id_regione` int(11) NOT NULL,
  `nome` varchar(254) NOT NULL,
  `sigla` char(8) DEFAULT NULL,
  `codice_istat` char(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000144

-- pubblicazione
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `pubblicazione` (
`id` int(11) NOT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `id_tipologia` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_popup` int(11) DEFAULT NULL,
  `template` char(32) DEFAULT NULL,
  `schema_html` char(32) DEFAULT NULL,
  `tema_css` char(32) DEFAULT NULL,
  `se_sitemap` int(1) DEFAULT NULL,
  `se_cacheable` int(1) DEFAULT NULL,
  `note` char(254) DEFAULT NULL,
  `timestamp_pubblicazione` int(11) DEFAULT NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000145

-- rassegna_stampa
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `rassegna_stampa` (
`id` int(11) NOT NULL,
  `data` date DEFAULT NULL,
  `id_testata` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `nome` char(255) COLLATE utf8_general_ci DEFAULT NULL,
  `testo` text COLLATE utf8_general_ci,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--| 010000000146

-- rassegna_stampa_anagrafica
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `rassegna_stampa_anagrafica` (
`id` int(11) NOT NULL,
  `id_rassegna_stampa` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_ruolo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000147

-- rassegna_stampa_eventi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `rassegna_stampa_eventi` (
`id` int(11) NOT NULL,
  `id_rassegna_stampa` int(11) NOT NULL,
  `id_evento` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000148

-- recensioni
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `recensioni` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000149

-- redirect
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `redirect` (
`id` int(11) NOT NULL,
  `codice` int(11) NOT NULL,
  `sorgente` char(255) NOT NULL,
  `destinazione` char(255) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000150

-- regimi_fiscali
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `regimi_fiscali` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL,
  `codice` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000151

-- regioni
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `regioni` (
`id` int(11) NOT NULL,
  `id_stato` int(11) NOT NULL,
  `nome` char(32) NOT NULL,
  `codice_istat` char(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000152

-- richieste_immobili
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `richieste_immobili` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000153

-- richieste_immobili_caratteristiche
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `richieste_immobili_caratteristiche` (
`id` int(11) NOT NULL,
  `id_richiesta` int(11) NOT NULL,
  `id_caratteristica` int(11) NOT NULL,
  `specifiche` text,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000154

-- richieste_immobili_classi_energetiche
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `richieste_immobili_classi_energetiche` (
`id` int(11) NOT NULL,
  `id_richiesta` int(11) NOT NULL,
  `id_classe` int(11) NOT NULL,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000155

-- richieste_immobili_condizioni
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `richieste_immobili_condizioni` (
`id` int(11) NOT NULL,
  `id_richiesta` int(11) NOT NULL,
  `id_condizione` int(11) NOT NULL,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000156

-- richieste_immobili_disponibilita
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `richieste_immobili_disponibilita` (
`id` int(11) NOT NULL,
  `id_richiesta` int(11) NOT NULL,
  `id_disponibilita` int(11) NOT NULL,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000157

-- richieste_immobili_tipologie
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `richieste_immobili_tipologie` (
`id` int(11) NOT NULL,
  `id_richiesta` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000158

-- richieste_immobili_tipologie_edifici
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `richieste_immobili_tipologie_edifici` (
`id` int(11) NOT NULL,
  `id_richiesta` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000159

-- richieste_immobili_tipologie_incarichi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `richieste_immobili_tipologie_incarichi` (
`id` int(11) NOT NULL,
  `id_richiesta` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `id_tipologia_founding` int(11) DEFAULT NULL,
  `prezzo_min` decimal(15,2) DEFAULT NULL,
  `prezzo_max` decimal(15,2) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000160

-- richieste_immobili_zone
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `richieste_immobili_zone` (
`id` int(11) NOT NULL,
  `id_richiesta` int(11) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `se_non_desiderata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000161

-- righe_documenti_amministrativi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `righe_documenti_amministrativi` (
`id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_emittente` int(11) DEFAULT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_riferimento` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_pratica` int(11) DEFAULT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000162

-- righe_fatturati
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `righe_fatturati` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000163

-- risorse
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `risorse` (
`id` int(11) NOT NULL,
  `codice` char(6) DEFAULT NULL,
  `data_pubblicazione` date DEFAULT NULL,
  `id_testata` int(11) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000164

-- risorse_anagrafica
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `risorse_anagrafica` (
`id` int(11) NOT NULL,
  `id_risorsa` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000165

-- risorse_categorie
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `risorse_categorie` (
`id` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_risorsa` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000166

-- ruoli_anagrafica
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `ruoli_anagrafica` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000167

-- ruoli_audio
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `ruoli_audio` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_anagrafica` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000168

-- ruoli_eventi
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `ruoli_eventi` (
  `id` int(11) NOT NULL,
  `nome` char(128) COLLATE utf8_general_ci NOT NULL,
  `locandina` char(128) COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000169

-- ruoli_file
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `ruoli_file` (
`id` int(11) NOT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `se_anagrafica` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000170

-- ruoli_immagini
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `ruoli_immagini` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_contenuti` int(1) DEFAULT NULL,
  `se_anagrafica` int(1) DEFAULT NULL,
  `se_immobili` int(1) DEFAULT NULL,
  `se_catalogo` int(1) DEFAULT NULL,
  `se_prodotti` int(1) DEFAULT NULL,
  `ordine_scalamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000171

-- ruoli_immagini_anagrafica
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `ruoli_immagini_anagrafica` (
`id` int(11) NOT NULL,
  `nome` char(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000172

-- ruoli_immobili_anagrafica
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `ruoli_immobili_anagrafica` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000173

-- ruoli_progetti
-- tipologia: tabella assistita
CREATE TABLE IF NOT EXISTS `ruoli_progetti` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000174

-- ruoli_prodotti_categorie
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `ruoli_prodotti_categorie` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL,
  `se_bestseller` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000175

-- ruoli_rassegna_stampa
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `ruoli_rassegna_stampa` (
  `id` int(11) NOT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000176

-- ruoli_video
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `ruoli_video` (
  `id` int(11) NOT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `se_anagrafica` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000177

-- scadenze
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `scadenze` (
`id` int(11) NOT NULL,
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
  `id_account_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000178

-- settori
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `settori` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ateco` char(32) DEFAULT NULL,
  `nome` char(128) NOT NULL,
  `soprannome` char(64) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000179

-- sms_out
-- tipolgia: tabella gestita
CREATE TABLE IF NOT EXISTS `sms_out` (
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
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000180

-- sms_sent
-- tipolgia: tabella gestita
CREATE TABLE IF NOT EXISTS `sms_sent` (
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
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000181

-- sostituzioni_attivita
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `sostituzioni_attivita` (
`id` int(11) NOT NULL,
  `id_attivita` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_richiesta` date NOT NULL,
  `data_accettazione` date DEFAULT NULL,
  `data_rifiuto` date DEFAULT NULL,
  `data_scarto` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000182

-- sostituzioni_progetti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `sostituzioni_progetti` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_scopertura` date NOT NULL,
  `data_scarto` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000183

-- stagioni_prodotti
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `stagioni_prodotti` (
	`id` int(11) NOT NULL,
	`nome` char(64) NOT NULL,
	`new` INT(1) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000184

-- stati
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `stati` (
`id` int(11) NOT NULL,
  `id_continente` int(11) DEFAULT NULL,
  `iso31661alpha2` char(2) DEFAULT NULL,
  `iso31661alpha3` char(3) DEFAULT NULL,
  `nome` char(128) NOT NULL,
  `note` char(128) DEFAULT NULL,
  `codice_istat` char(4) DEFAULT NULL,
  `data_cessazione` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000185

-- stati_lingue
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `stati_lingue` (
  `id_stato` int(11) NOT NULL,
  `id_lingua` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000186

-- taglie
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `taglie` (
`id` int(11) NOT NULL,
  `it` char(8) NOT NULL,
  `eu` char(8) DEFAULT NULL,
  `us` char(8) DEFAULT NULL,
  `uk` char(8) DEFAULT NULL,
  `fr` char(8) DEFAULT NULL,
  `international` char(8) DEFAULT NULL,
  `jeans` char(8) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `cm` char(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000187

-- tari_anagrafica
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tari_anagrafica` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000188

-- task
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `task` (
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

--| 010000000189

-- telefoni
-- tipologia: tabella gestita
CREATE TABLE `telefoni` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `se_notifiche` tinyint(1) DEFAULT NULL,
  `numero` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `descrizione` char(128) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000190

-- template_mail
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `template_mail` (
`id` int(11) NOT NULL,
  `ruolo` char(32) NOT NULL,
  `nome` char(128) NOT NULL,
  `type` char(32) NOT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000191

-- testate
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `testate` (
`id` int(11) NOT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000192

-- tipologie_anagrafica
-- tipologia: tabella assistita
CREATE TABLE IF NOT EXISTS `tipologie_anagrafica` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000193

-- tipologie_attivita
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tipologie_attivita` (
`id` int(11) NOT NULL,
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
  `se_forfait` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000194

-- tipologie_attivta_inps
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_attivita_inps` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `codice` char(32) DEFAULT NULL,
  `se_quadratura` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000XXX

-- tipologie_caratteristiche_prodotti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tipologie_caratteristiche_prodotti` (
`id` int(11) NOT NULL,
  `nome` char(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000195

-- tipologie_conteggio_attivita
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tipologie_conteggio_attivita` (
`id` int(11) NOT NULL,
  `nome` char(128) NOT NULL,
  `se_standard` int(1) DEFAULT NULL,
  `se_extra` int(1) DEFAULT NULL,
  `se_gratuita` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000196

-- tipologie_crm
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tipologie_crm` (
`id` int(11) NOT NULL,
  `nome` char(32) COLLATE utf8_general_ci NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000197

-- tipologie_contatti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tipologie_contatti` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL,
  `se_segnalazione` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000198

-- tipologie_contratti
-- tipologia: tabella assistita
CREATE TABLE IF NOT EXISTS `tipologie_contratti` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000199

-- tipologie_date
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tipologie_date` (
`id` int(11) NOT NULL,
  `nome` char(255) COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000200

-- tipologie_documenti
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_documenti` (
`id` int(11) NOT NULL,
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
  `stampa_pdf` char(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000201

-- tipologie_documenti_amministrativi
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_documenti_amministrativi` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `codice` char(8) DEFAULT NULL,
  `se_fattura` int(1) DEFAULT NULL,
  `se_nota_credito` int(1) DEFAULT NULL,
  `se_trasporto` int(1) DEFAULT NULL,
  `se_pro_forma` int(1) DEFAULT NULL,
  `se_offerta` int(1) DEFAULT NULL,
  `se_ordine` int(1) DEFAULT NULL,
  `se_ricevuta` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000202

-- tipologie_durate_inps
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_durate_inps` (
  `id` char(32) NOT NULL,
  `nome` char(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000203

-- tipologie_edifici
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_edifici` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000204

-- tipologie_embed
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_embed` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_video` int(1) DEFAULT NULL,
  `se_audio` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000205

-- tipologie_eventi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tipologie_eventi` (
`id` int(11) NOT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) NOT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000206

-- tipologie_founding
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_founding` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000207

-- tipologie_immobili
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_immobili` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL,
  `se_residenziale` int(1) DEFAULT NULL,
  `se_industriale` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000208

-- tipologie_incarichi_immobili
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_incarichi_immobili` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000209

-- tipologie_indirizzi
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_indirizzi` (
`id` int(11) NOT NULL,
  `nome` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `se_sede` int(1) DEFAULT NULL,
  `se_operativa` int(1) DEFAULT NULL,
  `se_abitazione` int(1) DEFAULT NULL,
  `html` char(16) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000210
	
-- tipologie_interesse
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_interesse` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000211

-- tipologie_mastri
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_mastri` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000212

-- tipologie_motivazioni_tari
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_motivazioni_tari` (
  `id` int(11) NOT NULL,
  `nome` char(40) NOT NULL,
  `soprannome` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000213

-- tipologie_notizie
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_notizie` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000214

-- tipologie_orari_inps
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_orari_inps` (
  `id` char(32) NOT NULL,
  `nome` char(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000215

-- tipologie_popup
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_popup` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000216

-- tipologie_pratiche
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_pratiche` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000217

-- tipologie_prodotti
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_prodotti` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_colori` tinyint(1) DEFAULT NULL,
  `se_taglie` tinyint(1) DEFAULT NULL,
  `se_dimensioni` tinyint(1) DEFAULT NULL,
  `se_imballo` tinyint(1) DEFAULT NULL,
  `se_stagioni` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000218

-- tipologie_progetti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tipologie_progetti` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_scalare` int(1) DEFAULT NULL,
  `se_commessa` int(1) DEFAULT NULL,
  `se_chiamata` int(1) DEFAULT NULL,
  `se_contratto` int(1) DEFAULT NULL,
  `se_forfait` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000219

-- tipologie_pubblicazione
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_pubblicazione` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_bozza` int(11) DEFAULT NULL,
  `se_pubblicato` int(1) DEFAULT NULL,
  `se_evidenza` int(1) DEFAULT NULL,
  `se_newsletter` int(1) DEFAULT NULL,
  `se_secondario` int(1) DEFAULT NULL,
  `se_incroci` int(1) DEFAULT NULL,
  `se_suggerito` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000220

-- tipologie_qualifiche_inps
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_qualifiche_inps` (
  `id` char(32) NOT NULL,
  `nome` char(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000221

-- tipologie_rassegna_stampa
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tipologie_rassegna_stampa` (
`id` int(11) NOT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000222

-- tipologie_risorse
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_risorse` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `ordine` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000223

-- tipologie_soddisfazione
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_soddisfazione` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- tipologie_taglie
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tipologie_taglie` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000224

-- tipologie_task
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tipologie_task` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_pianificata` tinyint(1) DEFAULT NULL,
  `se_richiesta` tinyint(1) DEFAULT NULL,
  `se_imprevista` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000225

-- tipologie_telefoni
-- tipologia: tabella di supporto
CREATE TABLE `tipologie_telefoni` (
  `id` int(11) NOT NULL,
  `nome` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `html` char(16) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000226

-- tipologie_todo
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `tipologie_todo` (
`id` int(11) NOT NULL,
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
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000227

-- tipologie_udm
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_udm` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

--| 010000000228

-- tipologie_vani
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_vani` (
`id` int(11) NOT NULL,
  `nome` char(32) NOT NULL,
  `se_camera` int(1) DEFAULT NULL,
  `se_cucina` int(1) DEFAULT NULL,
  `se_bagno` int(1) DEFAULT NULL,
  `se_commerciale` int(1) DEFAULT NULL,
  `percentuale_commerciale` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000229

-- tipologie_variazioni_attivita
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `tipologie_variazioni_attivita` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000230

-- todo
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `todo` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_priorita` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
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
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000231

-- todo_categorie
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `todo_categorie` (
`id` int(11) NOT NULL,
  `id_todo` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000232

-- transcodifica_clienti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `transcodifica_clienti` (
`id` int(11) NOT NULL,
  `id_mandante` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_cliente_mandante` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000233

-- turni
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `turni` (
`id` int(11) NOT NULL,
  `turno` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_contratto` int(11) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000234

-- udm
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `udm` (
`id` int(11) NOT NULL,
  `id_udm` int(11) DEFAULT NULL,
  `id_tipologia` int(11) NOT NULL,
  `conversione` float DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `soprannone` char(32) DEFAULT NULL,
  `sigla` char(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000235

-- valute
-- tipologia: tabella di supporto
CREATE TABLE IF NOT EXISTS `valute` (
`id` int(11) NOT NULL,
  `iso4217` char(3) COLLATE utf8_general_ci NOT NULL,
  `html` char(8) COLLATE utf8_general_ci NOT NULL,
  `utf8` char(1) COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000236

-- vani_immobili
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `vani_immobili` (
`id` int(11) NOT NULL,
  `id_immobile` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `nome` char(64) DEFAULT NULL,
  `larghezza` decimal(5,2) DEFAULT NULL,
  `lunghezza` decimal(5,2) DEFAULT NULL,
  `altezza` decimal(5,2) DEFAULT NULL,
  `percentuale_commerciale_custom` decimal(5,2) DEFAULT NULL,
  `mq_commerciali` decimal(5,2) DEFAULT NULL,
  `mq_calpestabili` decimal(5,2) DEFAULT NULL,
  `mq_modificatore` decimal(15,2) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000237

-- variazioni_attivita
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `variazioni_attivita` (
`id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_tipologia_inps` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_richiesta` date NOT NULL,
  `data_approvazione` date DEFAULT NULL,
  `data_rifiuto` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000238

-- variazioni_prezzi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `variazioni_prezzi` (
`id` int(11) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `timestamp_inizio` int(11) DEFAULT NULL,
  `timestamp_fine` int(11) DEFAULT NULL,
  `sconto_percentuale` decimal(5,2) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `sconto_fisso` decimal(15,2) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000239

-- variazioni_prezzi_listini
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `variazioni_prezzi_listini` (
	`id` int(11) NOT NULL,
	`id_variazione_prezzo` int(11) NOT NULL,
	`id_listino` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000240

-- variazioni_prezzi_prodotti
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `variazioni_prezzi_prodotti` (
`id` int(11) NOT NULL,
  `id_variazione_prezzo` int(11) NOT NULL,
  `id_prodotto` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000241

-- variazioni_prezzi_categorie
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `variazioni_prezzi_categorie` (
	`id` int(11) NOT NULL,
  `id_variazione_prezzo` int(11) NOT NULL,
  `id_categoria_prodotti` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000242

-- variazioni_prezzi_stagioni
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `variazioni_prezzi_stagioni` (
	`id` int(11) NOT NULL,
	`id_variazione_prezzo` int(11) NOT NULL,
	`id_stagione` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000243

-- variazioni_prezzi_marchi
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `variazioni_prezzi_marchi` (
	`id` int(11) NOT NULL,
	`id_variazione_prezzo` int(11) NOT NULL,
	`id_marchio` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000244

-- video
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `video` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_file` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_evento` int(11) DEFAULT NULL,
  `id_categoria_eventi` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `codice_embed` char(255) DEFAULT NULL,
  `id_tipologia_embed` int(11) NOT NULL,
  `ratio` char(8) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `target` char(255) DEFAULT NULL,
  `timestamp_scalamento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000245

-- zone
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `zone` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000246

-- zone_cap
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `zone_cap` (
`id` int(11) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `cap` char(8) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000247

-- zone_caratteristiche
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `zone_caratteristiche` (
  `id` int(11) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `id_caratteristica` int(11) NOT NULL,
  `specifiche` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000248

-- zone_listini
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `zone_listini` (
`id` int(11) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000249

-- zone_prezzi_spedizione
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `zone_prezzi_spedizione` (
`id` int(11) NOT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `id_ingombro` int(11) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `prezzo_max` decimal(7,2) DEFAULT NULL,
  `id_listino` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000250

-- zone_provincie
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `zone_provincie` (
`id` int(11) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `id_provincia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000251

-- zone_stati
-- tipologia: tabella gestita
CREATE TABLE IF NOT EXISTS `zone_stati` (
`id` int(11) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `id_stato` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| FINE FILE
