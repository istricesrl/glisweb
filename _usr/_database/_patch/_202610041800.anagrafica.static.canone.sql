-- 2026-10-04 — anagrafica_view_static come il canone
--
-- su gimbe la statica era nata da una CREATE ... SELECT e aveva i tipi dedotti dai dati ( id_stato e id_provincia
-- binary(0), sesso enum, date di nascita int, mail mediumtext ): 14 tipi fuori canone. Si ricostruisce dalla vista
-- come in _202610041700, su tutti i DB, cosi' la statica e' la stessa ovunque e perde le righe che la vista non ha
-- piu'. Provata il 04/10 su tabelle zz_ in gimbe, bernispa e polmasi prod: tutte le righe entrano.

-- | 202610041800

DROP TABLE IF EXISTS `anagrafica_view_static__nuova`;

-- | 202610041801

CREATE TABLE `anagrafica_view_static__nuova` (
  `id` bigint(20) PRIMARY KEY NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
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
  `id_ranking` bigint(20) DEFAULT NULL,
  `ranking` char(128) DEFAULT NULL,
  `recapiti` text,
  `id_stato` bigint(20) DEFAULT NULL,
  `id_provincia` bigint(20) DEFAULT NULL,
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
  `id_comune_nascita` bigint(20) DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text,
  UNIQUE KEY `codice` (`codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202610041802

INSERT INTO `anagrafica_view_static__nuova` SELECT * FROM `anagrafica_view`;

-- | 202610041803

RENAME TABLE `anagrafica_view_static` TO `anagrafica_view_static__vecchia`, `anagrafica_view_static__nuova` TO `anagrafica_view_static`;

-- | 202610041804

DROP TABLE `anagrafica_view_static__vecchia`;

-- | FINE
