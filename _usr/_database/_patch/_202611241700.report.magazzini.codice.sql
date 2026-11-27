-- 2026-11-24 — report di giacenza e movimenti dei magazzini: tabelle ripristinate e codici accanto agli id
--
-- I CREATE di __report_giacenza_magazzini__ ( dal 09/12/2023, e2c62ace9 ) e di __report_movimenti_magazzini__ ( dal
-- 12/02/2024, 3fe254262 ) sono spariti dallo schema standard nel riallineamento d975b4a15 del 02/03/2026, insieme alle
-- altre tabelle perse lì ( issue #608 e #609 ): i deploy installati prima le hanno, quelli installati dopo no, e i
-- popolatori di _mod/_0500.mastri/_src/_lib/_mysql.utils.add.php scrivono su una tabella che non c'è.
--
-- Il framework lavora con gli id, ma all'operatore va mostrato il codice: l'id di un articolo o di un prodotto non
-- coincide col suo codice e non dice niente a chi lo legge ( bernispa, voce 22 ). updateReportGiacenzaMagazzini() e
-- updateReportMovimentiMagazzini() scrivono ora anche articoli.codice e prodotti.codice.
--
-- Cosa fa: crea le due tabelle dove mancano, con lo schema di _100000999999.reports.sql; dove ci sono già aggiunge
-- `codice_articolo` ( char(32), come articoli.codice ) e `codice_prodotto` ( char(64), come prodotti.codice dalla patch
-- 202611201500 ), con i loro indici.
--
-- Dove una delle due e' una VISTA ( su utensilerialughese, 24/11/2026, il CREATE TABLE IF NOT EXISTS la saltava e
-- l'ALTER si fermava con ERRORE 1347 "is not of type 'BASE TABLE'" ) la vista si toglie e al suo posto si crea la
-- tabella, vuota: le righe tornano al successivo aggiornamento del report, come per i deploy che la tabella non
-- l'avevano. Il canone ( _100000999999.reports.sql ) le vuole tabelle.
--
-- Le sezioni sono state riordinate il 24/11/2026: la 1700 resta il CREATE di __report_giacenza_magazzini__ perche'
-- c'e' chi l'ha gia' registrata ( utensilerialughese ), e quel CREATE si ripete alla 1704 per il caso della vista
-- tolta alla 1702. Chi era gia' oltre la 1703 riesegue soltanto CREATE e ALTER, che sono idempotenti.
--
-- Cosa NON fa: non popola le righe esistenti e non tocca le colonne che i deploy hanno nel frattempo cambiato di tipo;
-- i codici compaiono al successivo aggiornamento del report.
--
-- IDEMPOTENTE.

-- | 202611241700

-- __report_giacenza_magazzini__
CREATE TABLE IF NOT EXISTS `__report_giacenza_magazzini__` (
  `id` varchar(56) NOT NULL,
  `id_mastro` int(11) DEFAULT NULL,
  `codice` text DEFAULT NULL,
  `nome` text DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `codice_articolo` char(32) DEFAULT NULL,
  `articolo` varchar(331) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `codice_prodotto` char(64) DEFAULT NULL,
  `prodotto` char(128) DEFAULT NULL,
  `codice_produttore` char(64) DEFAULT NULL,
  `categorie` text DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `matricola` char(128) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `carico` decimal(21,2) DEFAULT NULL,
  `scarico` decimal(21,2) DEFAULT NULL,
  `totale_proprio` decimal(21,2) DEFAULT NULL,
  `totale_figli` decimal(21,2) DEFAULT NULL,
  `totale` decimal(21,2) DEFAULT NULL,
  `peso` decimal(21,2) DEFAULT NULL,
  `sigla_udm_peso` char(8) DEFAULT NULL,
  `se_foglia` int(1) DEFAULT NULL,
  `note_aggiornamento` text NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `__label__` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`(1024)),
  KEY `id_articolo` (`id_articolo`),
  KEY `codice_articolo` (`codice_articolo`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `codice_prodotto` (`codice_prodotto`),
  KEY `id_matricola` (`id_matricola`),
  KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202611241701

-- la procedura che toglie una vista col nome di un report, e lascia stare la tabella se e' gia' una tabella;
-- il parametro ha la collation di information_schema, altrimenti sui DB utf8_unicode_ci il confronto da' errore 1267
CREATE OR REPLACE PROCEDURE `__patch_report_vista__`( IN nome VARCHAR(64) CHARSET utf8 COLLATE utf8_general_ci )
BEGIN

    IF EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = nome AND table_type = 'VIEW' ) THEN

        SET @report_vista_sql = CONCAT( 'DROP VIEW `', nome, '`' );
        PREPARE togli FROM @report_vista_sql;
        EXECUTE togli;
        DEALLOCATE PREPARE togli;

    END IF;

END;

-- | 202611241702

-- __report_giacenza_magazzini__: via la vista, se c'e'
CALL `__patch_report_vista__`( '__report_giacenza_magazzini__' );

-- | 202611241703

-- __report_movimenti_magazzini__: via la vista, se c'e'
CALL `__patch_report_vista__`( '__report_movimenti_magazzini__' );

-- | 202611241704

-- __report_giacenza_magazzini__
CREATE TABLE IF NOT EXISTS `__report_giacenza_magazzini__` (
  `id` varchar(56) NOT NULL,
  `id_mastro` int(11) DEFAULT NULL,
  `codice` text DEFAULT NULL,
  `nome` text DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `codice_articolo` char(32) DEFAULT NULL,
  `articolo` varchar(331) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `codice_prodotto` char(64) DEFAULT NULL,
  `prodotto` char(128) DEFAULT NULL,
  `codice_produttore` char(64) DEFAULT NULL,
  `categorie` text DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `matricola` char(128) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `carico` decimal(21,2) DEFAULT NULL,
  `scarico` decimal(21,2) DEFAULT NULL,
  `totale_proprio` decimal(21,2) DEFAULT NULL,
  `totale_figli` decimal(21,2) DEFAULT NULL,
  `totale` decimal(21,2) DEFAULT NULL,
  `peso` decimal(21,2) DEFAULT NULL,
  `sigla_udm_peso` char(8) DEFAULT NULL,
  `se_foglia` int(1) DEFAULT NULL,
  `note_aggiornamento` text NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `__label__` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`(1024)),
  KEY `id_articolo` (`id_articolo`),
  KEY `codice_articolo` (`codice_articolo`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `codice_prodotto` (`codice_prodotto`),
  KEY `id_matricola` (`id_matricola`),
  KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202611241705

-- __report_giacenza_magazzini__
ALTER TABLE `__report_giacenza_magazzini__`
	ADD COLUMN IF NOT EXISTS `codice_articolo` char(32) DEFAULT NULL AFTER `id_articolo`,
	ADD COLUMN IF NOT EXISTS `codice_prodotto` char(64) DEFAULT NULL AFTER `id_prodotto`,
	ADD KEY IF NOT EXISTS `codice_articolo` (`codice_articolo`),
	ADD KEY IF NOT EXISTS `codice_prodotto` (`codice_prodotto`);

-- | 202611241706

-- __report_movimenti_magazzini__
CREATE TABLE IF NOT EXISTS `__report_movimenti_magazzini__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` mediumint(9) DEFAULT NULL,
  `categorie` mediumtext DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `codice_prodotto` char(64) DEFAULT NULL,
  `prodotto` char(255) DEFAULT NULL,
  `codice_produttore` char(128) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `codice_articolo` char(32) DEFAULT NULL,
  `articolo` char(255) DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `matricola` char(128) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `tipologia` char(128) DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `documento` char(255) DEFAULT NULL,
  `numero` char(32) DEFAULT NULL,
  `sezionale` char(32) DEFAULT NULL,
  `emittente` char(255) DEFAULT NULL,
  `destinatario` char(255) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `codice_mastro_provenienza` char(255) DEFAULT NULL,
  `mastro_provenienza` char(255) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `codice_mastro_destinazione` char(255) DEFAULT NULL,
  `mastro_destinazione` char(255) DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `quantita_movimento` decimal(16,2) DEFAULT NULL,
  `udm_movimento` char(32) DEFAULT NULL,
  `note_aggiornamento` text DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `codice_articolo` (`codice_articolo`),
  KEY `codice_prodotto` (`codice_prodotto`),
  KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202611241707

-- __report_movimenti_magazzini__
ALTER TABLE `__report_movimenti_magazzini__`
	ADD COLUMN IF NOT EXISTS `codice_prodotto` char(64) DEFAULT NULL AFTER `id_prodotto`,
	ADD COLUMN IF NOT EXISTS `codice_articolo` char(32) DEFAULT NULL AFTER `id_articolo`,
	ADD KEY IF NOT EXISTS `codice_articolo` (`codice_articolo`),
	ADD KEY IF NOT EXISTS `codice_prodotto` (`codice_prodotto`);

-- | 202611241708

-- la procedura non serve piu'
DROP PROCEDURE IF EXISTS `__patch_report_vista__`;

-- | FINE FILE
