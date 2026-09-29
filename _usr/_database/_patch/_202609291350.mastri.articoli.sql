-- 2026-09-29 — mastri_articoli, la tabella delle collocazioni degli articoli nei mastri
--
-- Contesto: la tabella e' uscita dai file di base nel riallineamento del 02/03/2026 ( d975b4a15 ), mentre
-- il modulo _0500.mastri e il sottoscorta continuavano a usarla. Lo schema e' quello di bernispa, dove
-- il sottoscorta e' nato ( migrazioni 2026082704 e 2026090801 ), portato a bigint come i file di base.
--
-- Dove la tabella c'e' gia' si aggiungono le sole colonne delle soglie; id_udm lo aggiunge
-- _202609291400.report.sottoscorta.sql, che viene subito dopo. Di proposito niente chiavi esterne
-- ( i file di base non ne dichiarano per i mastri ) e niente UNIQUE ( id_mastro, id_articolo ): su
-- bernispa la si e' potuta creare solo dopo aver fuso le righe doppie, e una DELETE su una tabella di
-- esercizio non si porta in un patch che gira dappertutto. La chiave primaria, dove manca, la
-- aggiunge _202609291500.chiavi.primarie.sql.
--
-- IDEMPOTENTE ( CREATE TABLE IF NOT EXISTS, ADD COLUMN IF NOT EXISTS ).

-- | 202609291350

-- mastri_articoli
CREATE TABLE IF NOT EXISTS `mastri_articoli` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(64) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `id_mastro` bigint(20) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `scorta_minima` decimal(21,2) DEFAULT NULL,
  `scorta_massima` decimal(21,2) DEFAULT NULL,
  `id_udm` bigint(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_mastro` (`id_mastro`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_udm` (`id_udm`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_mastro`,`id_articolo`,`scorta_minima`,`scorta_massima`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291351

-- le soglie, dove la tabella c'era gia' senza
ALTER TABLE `mastri_articoli`
	ADD COLUMN IF NOT EXISTS `scorta_minima` decimal(21,2) DEFAULT NULL AFTER `id_articolo`,
	ADD COLUMN IF NOT EXISTS `scorta_massima` decimal(21,2) DEFAULT NULL AFTER `scorta_minima`;

-- | FINE FILE
