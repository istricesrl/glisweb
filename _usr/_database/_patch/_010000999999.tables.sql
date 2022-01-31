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
  `ordine` int(11) DEFAULT NULL,
  `se_amministratore` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000300

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
-- verifica: 2021-05-20 17:05 Fabio Mosti
CREATE TABLE IF NOT EXISTS `account_gruppi_attribuzione` (
  `id` int(11) NOT NULL,
  `id_account` int(11) NOT NULL,
  `id_gruppo` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `entita` char(64) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000400

-- anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:30 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `riferimento` char(32) DEFAULT NULL,
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
  `id_regime` int(11) DEFAULT NULL,
  `note_amministrative` text,
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
  `note_commerciali` text,
  `condizioni_vendita` text,
  `condizioni_acquisto` text,
  `note` text,
  `data_archiviazione` date DEFAULT NULL,
  `note_archiviazione` text,
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
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000700

-- anagrafica_cittadinanze
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_cittadinanze` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_stato` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000000900

-- anagrafica_indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-05-21 16:30 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_indirizzi` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_indirizzo` int(11) NOT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `interno` char(8) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000001200

-- anagrafica_settori
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:38 Fabio Mosti
CREATE TABLE IF NOT EXISTS `anagrafica_settori` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_settore` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  `se_assente` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000001800

-- attivita
-- tipologia: tabella gestita
-- verifica: 2021-05-25 17:14 Fabio Mosti
CREATE TABLE IF NOT EXISTS `attivita` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
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
  `id_anagrafica_programmazione` int(11) DEFAULT NULL,
  `note_programmazione` text,
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
  `testo` text,
  `id_progetto` char(32) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
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
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000002900

-- caratteristiche_prodotti
-- tipologia: tabella gestita
-- verifica: 2021-05-28 18:22 Fabio Mosti
CREATE TABLE IF NOT EXISTS `caratteristiche_prodotti` (
  `id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `font_awesome` char(24) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `se_categoria` int(1) DEFAULT NULL,
  `se_prodotto` int(1) DEFAULT NULL,
  `se_articolo` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
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
  `note` text,
  `se_lead` int(1) DEFAULT NULL,
  `se_prospect` int(1) DEFAULT NULL,
  `se_cliente` int(1) DEFAULT NULL,
  `se_fornitore` int(1) DEFAULT NULL,
  `se_produttore` int(1) DEFAULT NULL,
  `se_collaboratore` int(1) DEFAULT NULL,
  `se_interno` int(1) DEFAULT NULL,
  `se_esterno` int(1) DEFAULT NULL,
  `se_agente` int(1) DEFAULT NULL,
  `se_concorrente` int(1) DEFAULT NULL,
  `se_gestita` int(1) DEFAULT NULL,
  `se_amministrazione` int(1) DEFAULT NULL,
  `se_produzione` int(1) DEFAULT NULL,
  `se_notizie` int(1) DEFAULT NULL,
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
  `note` text,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` int(1) DEFAULT NULL,
  `se_cacheable` int(1) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
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
  `note` text,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` int(1) DEFAULT NULL,
  `se_cacheable` int(1) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
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
  `note` text,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` int(1) DEFAULT NULL,
  `se_cacheable` int(1) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `se_ordinario` int(1) DEFAULT NULL,
  `se_straordinario` int(1) DEFAULT NULL,
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
  `note` text,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `se_sitemap` int(1) DEFAULT NULL,
  `se_cacheable` int(1) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000004800

-- chiavi
-- tipologia: tabella gestita
-- verifica: 2021-11-15 12:04 Chiara GDL
CREATE TABLE IF NOT EXISTS `chiavi` (
  `id` int(11) NOT NULL,
  `id_licenza` int(11) DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `codice` char(32) COLLATE utf8_general_ci DEFAULT NULL,
  `seriale` char(32) COLLATE utf8_general_ci DEFAULT NULL,
  `nome` char(32) COLLATE utf8_general_ci NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000005100

-- colori
-- tipologia: tabella standard
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
-- tipologia: tabella standard
-- verifica: 2021-06-03 19:53 Fabio Mosti
CREATE TABLE IF NOT EXISTS `comuni` (
  `id` int(11) NOT NULL,
  `id_provincia` int(11) NOT NULL,
  `nome` varchar(254) NOT NULL,
  `codice_istat` char(12) DEFAULT NULL,
  `codice_catasto` char(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000006200

-- condizioni_pagamento
-- tipologia: tabella standard
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `condizioni_pagamento` (
`id` int(11) NOT NULL,
  `codice` char(5) NOT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000006700

-- contatti
-- tipologia: tabella gestita
-- verifica: 2021-06-03 21:33 Fabio Mosti
CREATE TABLE IF NOT EXISTS `contatti` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_inviante` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `json` text DEFAULT NULL,
  `timestamp_contatto` int(11) DEFAULT NULL,
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
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_template` int(11) DEFAULT NULL,
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

--| 010000007100

-- continenti
-- tipologia: tabella di supporto
-- verifica: 2021-06-09 11:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `continenti` (
  `id` int(11) NOT NULL,
  `codice` char(2) COLLATE utf8_general_ci DEFAULT NULL,
  `nome` char(32) COLLATE utf8_general_ci NOT NULL
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
  `id_categoria` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000008400

-- coupon_listini
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:37 Fabio Mosti
CREATE TABLE IF NOT EXISTS `coupon_listini` (
  `id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000008600

-- coupon_marchi
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `coupon_marchi` (
  `id` int(11) NOT NULL,
  `id_coupon` char(32) NOT NULL,
  `id_marchio` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000008800

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

--| 010000009800

-- documenti
-- tipologia: tabella gestita
-- verifica: 2022-01-07 14:25 chiara gdl
CREATE TABLE IF NOT EXISTS `documenti` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `numero` int(11) NOT NULL,
  `sezionale` char(32) DEFAULT NULL,
  `data` date NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_emittente` int(11) NOT NULL,
  `id_sede_emittente` int(11) DEFAULT NULL,
  `id_destinatario` int(11) NOT NULL,
  `id_sede_destinatario` int(11) DEFAULT NULL,
  `id_condizione_pagamento` int(11) DEFAULT NULL,
  `codice_archivium` char(64) DEFAULT NULL ,
  `codice_sdi` char(64) DEFAULT NULL,
  `timestamp_invio` int DEFAULT NULL,
  `progressivo_invio` char(5) DEFAULT NULL,
  `id_coupon` char(32) DEFAULT NULL,
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
  `id_matricola` int(11) DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `id_listino` int(11) DEFAULT NULL,
  `importo_netto_totale` decimal(9,2) NOT NULL,
  `nome` text,
  `specifiche` char(255) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000012800

-- embed
-- tipologia: tabella standard
-- verifica: 2021-06-29 16:56 Fabio Mosti
CREATE TABLE IF NOT EXISTS `embed` (
  `id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_audio` int(1) DEFAULT NULL,
  `se_video` int(1) DEFAULT NULL
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
  `id_template` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_mail_out` int(11) DEFAULT NULL,
  `id_mail_sent` int(11) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `url` char(255) DEFAULT NULL,
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
  `id_organizzazione` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- NOTE
-- questa tabella contiene i gruppi aggiuntivi del framework

--| 010000015400

-- iban
-- tipologia: tabella gestita
-- verifica: 2021-09-22 11:55 Fabio Mosti
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

--| 010000015600

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
  `id_lingua` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `orientamento` enum('L','P') DEFAULT NULL,
  `taglio` char(64) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `path` char(255) NOT NULL,
  `path_alternativo` char(255) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_scalamento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000015800

-- indirizzi
-- tipologia: tabella gestita
-- verifica: 2021-09-23 15:21 Fabio Mosti
CREATE TABLE IF NOT EXISTS `indirizzi` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_comune` int(11) NOT NULL,
  `localita` char(128) CHARACTER SET utf8 DEFAULT NULL,
  `indirizzo` char(128) CHARACTER SET utf8 NOT NULL,
  `civico` char(16) CHARACTER SET utf8 DEFAULT NULL,
  `cap` char(11) CHARACTER SET utf8 DEFAULT NULL,
  `note` text CHARACTER SET utf8,
  `latitudine` decimal(11,7) DEFAULT NULL,
  `longitudine` decimal(11,7) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_geolocalizzazione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000016000

-- iva
-- tipologia: tabella standard
-- verifica: 2021-09-23 16:52 Fabio Mosti
CREATE TABLE IF NOT EXISTS `iva` (
  `id` int(11) NOT NULL,
  `aliquota` decimal(5,2) NOT NULL,
  `nome` char(64) NOT NULL,
  `descrizione` text,
  `codice` char(8) DEFAULT NULL,
  `timestamp_archiviazione` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000016200

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
  `workspace` text,
  `token` char(254) DEFAULT NULL,
  `se_foreground` int(1) DEFAULT NULL,
  `timestamp_esecuzione` int(11) DEFAULT NULL,
  `timestamp_completamento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000016600

-- licenze
-- tipologia: tabella standard
-- verifica: 2021-11-15 12:41 Fabio Mosti
CREATE TABLE IF NOT EXISTS `licenze` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_rivenditore` int(11) DEFAULT NULL,
  `codice` char(254) DEFAULT NULL,
  `postazioni` int(11) NOT NULL,
  `nome` char(32) DEFAULT NULL,
  `note` char(254) DEFAULT NULL,
  `testo` text,
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

--| 010000016700

-- licenze_software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 15:30 Chiara GDL
CREATE TABLE IF NOT EXISTS `licenze_software` (
  `id` int(11) NOT NULL,
  `id_licenza` int(11) NOT NULL,
  `id_software` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000016800

-- lingue
-- tipologia: tabella standard
-- verifica: 2021-09-24 17:41 Fabio Mosti
CREATE TABLE IF NOT EXISTS `lingue` (
  `id` int(11) NOT NULL,
  `nome` char(128) COLLATE utf8_general_ci NOT NULL,
  `note` char(128) COLLATE utf8_general_ci DEFAULT NULL,
  `iso6391alpha2` char(36) COLLATE utf8_general_ci DEFAULT NULL,
  `iso6393alpha3` char(36) COLLATE utf8_general_ci DEFAULT NULL,
  `ietf` char(36) COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000017200

-- listini
-- tipologia: tabella assistita
-- verifica: 2021-09-24 17:49 Fabio Mosti
CREATE TABLE IF NOT EXISTS `listini` (
  `id` int(11) NOT NULL,
  `id_valuta` int(11) NOT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000017400

-- listini_clienti
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:12 Fabio Mosti
CREATE TABLE IF NOT EXISTS `listini_clienti` (
  `id` int(11) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000018000

-- luoghi
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:39 Fabio Mosti
CREATE TABLE IF NOT EXISTS `luoghi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `nome` char(255) COLLATE utf8_general_ci NOT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000018200

-- macro
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:55 Fabio Mosti
CREATE TABLE IF NOT EXISTS `macro` (
  `id` int(11) NOT NULL,
  `id_pagina` int(11) NOT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_notizia` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_risorsa` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `macro` char(64) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000018600

-- mail
-- tipologia: tabella gestita
-- verifica: 2021-09-27 18:31 Fabio Mosti
CREATE TABLE IF NOT EXISTS `mail` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `indirizzo` char(128) NOT NULL,
  `note` char(128) DEFAULT NULL,
  `se_notifiche` tinyint(1) DEFAULT NULL,
  `se_pec` tinyint(1) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000018800

-- mail_out
-- tipolgia: tabella gestita
-- verifica: 2021-09-28 15:10 Fabio Mosti
CREATE TABLE IF NOT EXISTS `mail_out` (
  `id` int(11) NOT NULL,
  `id_mail` int(11) DEFAULT NULL,
  `id_mailing` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_composizione` int(11) NOT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `destinatari_cc` text,
  `destinatari_bcc` text,
  `oggetto` char(254) NOT NULL,
  `corpo` text NOT NULL,
  `allegati` text,
  `headers` text,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int(11) DEFAULT '0',
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000018900

-- mail_sent
-- tipolgia: tabella gestita
-- verifica: 2021-09-28 15:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `mail_sent` (
  `id` int(11) NOT NULL,
  `id_mail` int(11) DEFAULT NULL,
  `id_mailing` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_composizione` int(11) NOT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `destinatari_cc` text,
  `destinatari_bcc` text,
  `oggetto` char(254) NOT NULL,
  `corpo` text NOT NULL,
  `allegati` text,
  `headers` text,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int(11) DEFAULT '0',
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000020200

-- marchi
-- tipologia: tabella gestita
-- verifica: 2021-09-28 17:59 Fabio Mosti
CREATE TABLE IF NOT EXISTS `marchi` (
  `id` int(11) NOT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000020600

-- mastri
-- tipologia: tabella gestita
-- verifica: 2021-09-29 11:33 Fabio Mosti
CREATE TABLE IF NOT EXISTS `mastri` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_tipologia` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000021000

-- matricole
-- tipologia: tabella gestita
-- verifica: 2021-12-28 16:20 Chiara GDL
CREATE TABLE `matricole` (
  `id` int NOT NULL,
  `id_marchio` int DEFAULT NULL,
  `id_produttore` int DEFAULT NULL,
  `serial_number` char(128) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000021600

-- menu
-- tipologia: tabella gestita
-- verifica: 2021-10-01 09:32 Fabio Mosti
CREATE TABLE IF NOT EXISTS `menu` (
  `id` int(11) NOT NULL,
  `id_lingua` int(11) NOT NULL,
  `id_pagina` int(11) NOT NULL,
  `id_categoria_prodotti` int(11) DEFAULT NULL,
  `id_categoria_notizie` int(11) DEFAULT NULL,
  `id_categoria_risorse` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `menu` char(32) NOT NULL,
  `nome` char(128) NOT NULL,
  `target` char(16) DEFAULT NULL,
  `sottopagine` char(32) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000021800

-- metadati
-- tipologia: tabella gestita
-- verifica: 2021-10-01 10:02 Fabio Mosti
CREATE TABLE IF NOT EXISTS `metadati` (
  `id` int(11) NOT NULL,
  `id_lingua` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
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
  `nome` char(32) DEFAULT NULL,
  `testo` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000021900

-- modalita_pagamento
-- tipologia: tabella standard
-- verifica: 2022-01-18 12:06 Chiara GDL
CREATE TABLE IF NOT EXISTS `modalita_pagamento` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `provider` char(64) DEFAULT NULL,
  `codice` char(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000022000

-- notizie
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:06 Fabio Mosti
CREATE TABLE IF NOT EXISTS `notizie` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000022200

-- notizie_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:32 Fabio Mosti
CREATE TABLE IF NOT EXISTS `notizie_categorie` (
  `id` int(11) NOT NULL,
  `id_notizia` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000022800

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
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000023100

-- pagamenti
-- tipologia: tabella gestita
-- verifica: 2021-11-12 16:00 Chiara GDL
CREATE TABLE IF NOT EXISTS `pagamenti` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_modalita_pagamento` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `note_pagamento` text,
  `id_documento` int(11) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `id_iban` int(11) DEFAULT NULL,
  `importo_netto_totale` decimal(9,2) NOT NULL,
  `id_iva` int(11) DEFAULT NULL,
  `id_listino` int(11) DEFAULT NULL,
	`timestamp_scadenza` int(11) DEFAULT NULL,
  `timestamp_pagamento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000023200

-- pagine
-- tipologia: tabella gestita
-- verifica: 2021-10-04 11:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `pagine` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_sito` int(11) NOT NULL DEFAULT '1',
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(32) DEFAULT NULL,
  `id_contenuti` int(11) DEFAULT NULL,
  `se_sitemap` int(1) DEFAULT NULL,
  `se_cacheable` int(1) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000023600

-- periodicita
-- tipologia: tabella di supporto
-- verifica: 2021-10-05 17:57 Fabio Mosti
CREATE TABLE IF NOT EXISTS `periodicita` (
  `id` int(11) NOT NULL,
  `nome` char(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000023800

-- pianificazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-05 17:16 Fabio Mosti
CREATE TABLE IF NOT EXISTS `pianificazioni` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_todo` int(11) DEFAULT NULL,
  `id_attivita` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `id_periodicita` int(11) NOT NULL,
  `cadenza` int(11) DEFAULT NULL,
  `se_lunedi` int(1) DEFAULT NULL,
  `se_martedi` int(1) DEFAULT NULL,
  `se_mercoledi` int(1) DEFAULT NULL,
  `se_giovedi` int(1) DEFAULT NULL,
  `se_venerdi` int(1) DEFAULT NULL,
  `se_sabato` int(1) DEFAULT NULL,
  `se_domenica` int(1) DEFAULT NULL,
  `schema_ripetizione` int(11) DEFAULT NULL,
  `data_elaborazione` date DEFAULT NULL,
  `giorni_estensione` int(11) DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `workspace` text,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000024000

-- popup
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:09 Fabio Mosti
CREATE TABLE IF NOT EXISTS `popup` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `nome` char(128) NOT NULL,
  `note` text,
  `html_id` char(128) DEFAULT NULL,
  `html_class` char(128) DEFAULT NULL,
  `html_class_attivazione` char(128) DEFAULT NULL,
  `n_scroll` int(11) DEFAULT NULL,
  `n_secondi` int(11) DEFAULT NULL,
  `template` char(128) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `se_ovunque` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000024200

-- popup_pagine
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:09 Fabio Mosti
CREATE TABLE IF NOT EXISTS `popup_pagine` (
  `id` int(11) NOT NULL,
  `id_pagina` int(11) NOT NULL,
  `id_popup` int(11) NOT NULL,
  `se_presente` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000025000

-- prezzi
-- tipologia: tabella gestita
-- verifica: 2021-10-04 16:53 Fabio Mosti
CREATE TABLE IF NOT EXISTS `prezzi` (
  `id` int(11) NOT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000026000

-- prodotti
-- tipologia: tabella gestita
-- verifica: 2021-10-04 18:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `prodotti` (	
  `id` char(32) NOT NULL,	
  `id_tipologia` int(11) NOT NULL,	
  `nome` char(128) NOT NULL,	
  `note` text,	
  `note_codifica` text,	
  `id_marchio` int(11) DEFAULT NULL,	
  `id_produttore` int(11) DEFAULT NULL,	
  `codice_produttore` char(64) DEFAULT NULL,	
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000026200

-- prodotti_caratteristiche
-- tipologia: tabella gestita
-- verifica: 2021-10-04 19:48 Fabio Mosti
CREATE TABLE IF NOT EXISTS `prodotti_caratteristiche` (
  `id` int(11) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  `id_caratteristica` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `note` text,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000026400

-- prodotti_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-04 19:03 Fabio Mosti
CREATE TABLE IF NOT EXISTS `prodotti_categorie` (
  `id` int(11) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000027000

-- progetti
-- tipologia: tabella gestita
-- verifica: 2021-10-08 13:52 Fabio Mosti
CREATE TABLE IF NOT EXISTS `progetti` (
  `id` char(32) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `entrate_previste` decimal(16,2) DEFAULT NULL,
  `ore_previste` decimal(16,2) DEFAULT NULL,
  `costi_previsti` decimal(16,2) DEFAULT NULL,
  `note_previsioni` text,
  `entrate_accettazione` decimal(16,2) DEFAULT NULL,
  `data_accettazione` DATE DEFAULT NULL,
  `note_accettazione` text,
  `data_chiusura` DATE DEFAULT NULL,
  `note_chiusura` text,
  `entrate_totali` decimal(16,2) DEFAULT NULL,
  `ore_totali` decimal(16,2) DEFAULT NULL,
  `uscite_totali` decimal(16,2) DEFAULT NULL,
  `note_totali` text,
  `data_archiviazione` DATE DEFAULT NULL,
  `note_archiviazione` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000027200

-- progetti_anagrafica
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:58 Fabio Mosti
CREATE TABLE IF NOT EXISTS `progetti_anagrafica` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `se_sostituto` int(1) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000027400

-- progetti_categorie
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:58 Fabio Mosti
CREATE TABLE IF NOT EXISTS `progetti_categorie` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000028000

-- provincie
-- tipologia: tabella di supporto
-- verifica: 2021-10-08 16:20 Fabio Mosti
CREATE TABLE IF NOT EXISTS `provincie` (
  `id` int(11) NOT NULL,
  `id_regione` int(11) NOT NULL,
  `nome` varchar(254) NOT NULL,
  `sigla` char(8) DEFAULT NULL,
  `codice_istat` char(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000028400

-- pubblicazioni
-- tipologia: tabella gestita
-- verifica: 2021-10-08 16:38 Fabio Mosti
CREATE TABLE IF NOT EXISTS `pubblicazioni` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
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
  `note` char(254) DEFAULT NULL,
  `timestamp_inizio` int(11) DEFAULT NULL,
  `timestamp_fine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000028600

-- ranking
-- tipologia: tabella assistita
-- verifica: 2021-10-12 12:12 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ranking` (
  `id` int(11) NOT NULL,
  `nome` varchar(254) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000029400

-- redirect
-- tipologia: tabella gestita
-- verifica: 2021-10-08 18:00 Fabio Mosti
CREATE TABLE IF NOT EXISTS `redirect` (
  `id` int(11) NOT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `codice` int(11) NOT NULL,
  `sorgente` char(255) NOT NULL,
  `destinazione` char(255) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000029800

-- regimi
-- tipologia: tabella standard
-- verifica: 2021-10-09 15:02 Fabio Mosti
CREATE TABLE IF NOT EXISTS `regimi` (
  `id` int(11) NOT NULL,
  `nome` char(32) NOT NULL,
  `codice` char(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000030200

-- regioni
-- tipologia: tabella standard
-- verifica: 2021-10-09 15:22 Fabio Mosti
CREATE TABLE IF NOT EXISTS `regioni` (
  `id` int(11) NOT NULL,
  `id_stato` int(11) NOT NULL,
  `nome` char(32) NOT NULL,
  `codice_istat` char(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000030400

-- relazioni_documenti
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `relazioni_documenti` (
`id` int(11) NOT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `id_documento_collegato` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000030410

-- relazioni_documenti_articoli
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `relazioni_documenti_articoli` (
`id` int(11) NOT NULL,
  `id_documenti_articolo` int(11) DEFAULT NULL,
  `id_documenti_articolo_collegato` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000030440

-- relazioni_pagamenti
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `relazioni_pagamenti` (
`id` int(11) NOT NULL,
  `id_pagamento` int(11) DEFAULT NULL,
  `id_pagamento_collegato` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000030490

-- relazioni_progetti
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `relazioni_progetti` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_progetto_collegato` char(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000030500

-- relazioni_software
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE TABLE IF NOT EXISTS `relazioni_software` (
  `id` int(11) NOT NULL,
  `id_software` int(11) DEFAULT NULL,
  `id_software_collegato` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000030800

-- reparti
-- tipologia: tabella assistita
-- verifica: 2021-10-09 15:34 Fabio Mosti
CREATE TABLE IF NOT EXISTS `reparti` (
  `id` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL,
  `id_settore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `note` text,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000032000

-- risorse
-- tipologia: tabella gestita
-- verifica: 2021-10-09 15:49 Fabio Mosti
CREATE TABLE IF NOT EXISTS `risorse` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `codice` char(6) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `note` text,
  `id_testata` int(11) DEFAULT NULL,
  `giorno_pubblicazione` int(2) DEFAULT NULL,
  `mese_pubblicazione` int(2) DEFAULT NULL,
  `anno_pubblicazione` int(4) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000032200

-- risorse_anagrafica
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 16:07 Fabio Mosti
CREATE TABLE IF NOT EXISTS `risorse_anagrafica` (
  `id` int(11) NOT NULL,
  `id_risorsa` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_ruolo` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000032400

-- risorse_categorie
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 17:46 Fabio Mosti
CREATE TABLE IF NOT EXISTS `risorse_categorie` (
  `id` int(11) NOT NULL,
  `id_risorsa` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000034000

-- ruoli_anagrafica
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:21 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_anagrafica` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_organizzazioni` int(1) DEFAULT NULL,
  `se_risorse` int(1) DEFAULT NULL,
  `se_progetti` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000034200

-- ruoli_audio
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:26 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_audio` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` int(1) DEFAULT NULL,
  `se_pagine` int(1) DEFAULT NULL,
  `se_prodotti` int(1) DEFAULT NULL,
  `se_articoli` int(1) DEFAULT NULL,
  `se_categorie_prodotti` int(1) DEFAULT NULL,
  `se_notizie` int(1) DEFAULT NULL,
  `se_categorie_notizie` int(1) DEFAULT NULL,
  `se_risorse` int(1) DEFAULT NULL,
  `se_categorie_risorse` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000034400

-- ruoli_file
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 18:13 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_file` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` int(1) DEFAULT NULL,
  `se_pagine` int(1) DEFAULT NULL,
  `se_template` int(1) DEFAULT NULL,
  `se_prodotti` int(1) DEFAULT NULL,
  `se_articoli` int(1) DEFAULT NULL,
  `se_categorie_prodotti` int(1) DEFAULT NULL,
  `se_notizie` int(1) DEFAULT NULL,
  `se_categorie_notizie` int(1) DEFAULT NULL,
  `se_risorse` int(1) DEFAULT NULL,
  `se_categorie_risorse` int(1) DEFAULT NULL,
  `se_mail` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000034600

-- ruoli_immagini
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 18:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_immagini` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine_scalamento` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` int(1) DEFAULT NULL,
  `se_pagine` int(1) DEFAULT NULL,
  `se_prodotti` int(1) DEFAULT NULL,
  `se_articoli` int(1) DEFAULT NULL,
  `se_categorie_prodotti` int(1) DEFAULT NULL,
  `se_notizie` int(1) DEFAULT NULL,
  `se_categorie_notizie` int(1) DEFAULT NULL,
  `se_risorse` int(1) DEFAULT NULL,
  `se_categorie_risorse` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000034800

-- ruoli_indirizzi
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_indirizzi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_sede_legale` int(1) DEFAULT NULL,
  `se_sede_operativa` int(1) DEFAULT NULL,
  `se_residenza` int(1) DEFAULT NULL,
  `se_domicilio` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000035000

-- ruoli_prodotti
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_prodotti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000035200

-- ruoli_video
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 10:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `ruoli_video` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` int(1) DEFAULT NULL,
  `se_pagine` int(1) DEFAULT NULL,
  `se_prodotti` int(1) DEFAULT NULL,
  `se_articoli` int(1) DEFAULT NULL,
  `se_categorie_prodotti` int(1) DEFAULT NULL,
  `se_notizie` int(1) DEFAULT NULL,
  `se_categorie_notizie` int(1) DEFAULT NULL,
  `se_risorse` int(1) DEFAULT NULL,
  `se_categorie_risorse` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000037000

-- settori
-- tipologia: tabella gestita
-- verifica: 2021-10-12 10:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `settori` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) NOT NULL,
  `soprannome` char(64) NULL,
  `ateco` char(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000041000

-- sms_out
-- tipolgia: tabella gestita
-- verifica: 2021-10-12 11:51 Fabio Mosti
CREATE TABLE IF NOT EXISTS `sms_out` (
  `id` int(11) NOT NULL,
  `id_telefono` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_composizione` int(11) NOT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `corpo` text NOT NULL,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int(11) DEFAULT '0',
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000041200

-- sms_sent
-- tipolgia: tabella gestita
-- verifica: 2021-10-12 11:51 Fabio Mosti
CREATE TABLE IF NOT EXISTS `sms_sent` (
  `id` int(11) NOT NULL,
  `id_telefono` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_composizione` int(11) NOT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `corpo` text NOT NULL,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int(11) DEFAULT '0',
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000041400

-- software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 10:39 Chiara GDL
CREATE TABLE IF NOT EXISTS `software` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `json` text DEFAULT NULL, 
  `nome` char(128) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000042000

-- stati
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 15:06 Fabio Mosti
CREATE TABLE IF NOT EXISTS `stati` (
  `id` int(11) NOT NULL,
  `id_continente` int(11) DEFAULT NULL,
  `nome` char(128) NOT NULL,
  `note` char(128) DEFAULT NULL,
  `iso31661alpha2` char(2) DEFAULT NULL,
  `iso31661alpha3` char(3) DEFAULT NULL,
  `codice_istat` char(4) DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000042200

-- stati_lingue
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 15:24 Fabio Mosti
CREATE TABLE IF NOT EXISTS `stati_lingue` (
  `id` int(11) NOT NULL,
  `id_stato` int(11) NOT NULL,
  `id_lingua` int(11) NOT NULL,
  `ordine` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000043000

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

--| 010000043600

-- telefoni
-- tipologia: tabella gestita
-- verifica: 2021-10-12 15:58 Fabio Mosti
CREATE TABLE `telefoni` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `numero` char(32) NOT NULL,
  `note` text,
  `se_notifiche` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000044000

-- template
-- tipologia: tabella gestita
-- verifica: 2021-10-15 12:32 Fabio Mosti
CREATE TABLE IF NOT EXISTS `template` (
  `id` int(11) NOT NULL,
  `ruolo` char(32) NOT NULL,
  `nome` char(128) NOT NULL,
  `tipo` char(32) NOT NULL,
  `note` text,
  `latenza_invio` int(11) DEFAULT NULL,
  `se_mail` int(1) DEFAULT NULL,
  `se_sms` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000045000

-- testate
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:56 Fabio Mosti
CREATE TABLE IF NOT EXISTS `testate` (
  `id` int(11) NOT NULL,
  `nome` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--| 010000050000

-- tipologie_anagrafica
-- tipologia: tabella standard
-- verifica: 2021-10-15 16:15 Fabio Mosti
-- NOTA rendere gestita
CREATE TABLE IF NOT EXISTS `tipologie_anagrafica` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_persona_fisica` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000050400

-- tipologie_attivita
-- tipologia: tabella gestita
-- verifica: 2021-10-15 16:38 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_attivita` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` int(1) DEFAULT NULL,
  `se_agenda` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000050600

-- tipologie_chiavi
-- tipologia: tabella gestita
-- verifica: 2021-11-15 11:00 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_chiavi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000050800

-- tipologie_contatti
-- tipologia: tabella gestita
-- verifica: 2021-10-15 16:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_contatti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000052600

-- tipologie_documenti
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:00 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_documenti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(8) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_fattura` int(1) DEFAULT NULL,
  `se_nota_credito` int(1) DEFAULT NULL,
  `se_trasporto` int(1) DEFAULT NULL,
  `se_pro_forma` int(1) DEFAULT NULL,
  `se_offerta` int(1) DEFAULT NULL,
  `se_ordine` int(1) DEFAULT NULL,
  `se_ricevuta` int(1) DEFAULT NULL,
  `stampa_xml` char(255) DEFAULT NULL,
  `stampa_pdf` char(255) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000053000

-- tipologie_indirizzi
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:29 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_indirizzi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000053200

-- tipologie_licenze
-- tipologia: tabella gestita
-- verifica: 2021-11-15 11:00 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_licenze` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000053400

-- tipologie_mastri
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:30 Fabio Mosti
CREATE TABLE `tipologie_mastri` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_magazzino` int DEFAULT NULL,
  `se_conto` int DEFAULT NULL,
  `se_registro` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL
) ENGINE=InnoDB;

--| 010000053800

-- tipologie_notizie
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:31 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_notizie` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000054000

-- tipologie_pagamenti
-- tipologia: tabella gestita
-- verifica: 2021-11-15 11:00 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_pagamenti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000054200

-- tipologie_popup
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:32 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_popup` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000054600

-- tipologie_prodotti
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:34 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_prodotti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_colori` tinyint(1) DEFAULT NULL,
  `se_taglie` tinyint(1) DEFAULT NULL,
  `se_dimensioni` tinyint(1) DEFAULT NULL,
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

--| 010000055000

-- tipologie_progetti
-- tipologia: tabella gestita
-- verifica: 2021-10-15 17:40 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_progetti` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_contratto` tinyint(1) DEFAULT NULL,
  `se_pacchetto` tinyint(1) DEFAULT NULL,
  `se_progetto` tinyint(1) DEFAULT NULL,
  `se_consuntivo` tinyint(1) DEFAULT NULL,
  `se_forfait` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000055400

-- tipologie_pubblicazioni
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:43 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_pubblicazioni` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_bozza` int(1) DEFAULT NULL,
  `se_pubblicato` int(1) DEFAULT NULL,
  `se_evidenza` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000055800

-- tipologie_risorse
-- tipologia: tabella di supporto
-- verifica: 2021-10-15 17:45 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_risorse` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000056200

-- tipologie_telefoni
-- tipologia: tabella assistita
-- verifica: 2021-10-15 17:46 Fabio Mosti
-- NOTA rendere gestita
CREATE TABLE `tipologie_telefoni` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000056600

-- tipologie_todo
-- tipologia: tabella gestita
-- verifica: 2021-10-15 17:47 Fabio Mosti
CREATE TABLE IF NOT EXISTS `tipologie_todo` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000056800

-- tipologie_url
-- tipologia: tabella gestita
-- verifica: 2021-11-09 12:40 Chiara GDL
CREATE TABLE IF NOT EXISTS `tipologie_url` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000060000

-- todo
-- tipologia: tabella gestita
-- verifica: 2021-10-19 12:56 Fabio Mosti
CREATE TABLE IF NOT EXISTS `todo` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `note_scadenza` text,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `anno_programmazione` year(4) DEFAULT NULL,
  `settimana_programmazione` int(11) DEFAULT NULL,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `note_programmazione` text,
  `data_chiusura` date DEFAULT NULL,
  `note_chiusura` text,
  `nome` char(255) NOT NULL,
  `testo` text,
  `id_contatto` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `note_pianificazione` text,
  `data_archiviazione` DATE DEFAULT NULL,
  `note_archiviazione` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000062000

-- udm
-- tipologia: tabella di supporto
-- verifica: 2021-10-19 12:59 Fabio Mosti
CREATE TABLE IF NOT EXISTS `udm` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `conversione` float DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `sigla` char(8) DEFAULT NULL,
  `note` text,
  `se_lunghezza` int(1) DEFAULT NULL,
  `se_peso` int(1) DEFAULT NULL,
  `se_quantita` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000062600

-- url
-- tipologia: tabella gestita
-- verifica: 2021-11-09 11:25 Fabio Mosti
CREATE TABLE IF NOT EXISTS `url` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `url` char(255) NOT NULL,
  `nome` char(128) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000063000

-- valute
-- tipologia: tabella di supporto
-- verifica: 2021-10-19 13:16 Fabio Mosti
CREATE TABLE IF NOT EXISTS `valute` (
  `id` int(11) NOT NULL,
  `iso4217` char(3) COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) COLLATE utf8_general_ci NOT NULL,
  `utf8` char(1) COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 010000065000

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

--| FINE FILE
