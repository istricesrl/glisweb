-- 2026-09-30 — dichiarazioni d'intento degli esportatori abituali
--
-- COSA SI VEDEVA. Le righe con natura N3.5 ( non imponibili a seguito di dichiarazione d'intento ) vanno accompagnate, nella
-- fattura elettronica, dal protocollo e dalla data della dichiarazione ( AltriDatiGestionali con TipoDato INTENTO ): il
-- framework non aveva dove registrarle.
--
-- COSA FA. Crea la tabella dichiarazioni_intento, figlia dell'anagrafica del cliente ( il vincolo verso anagrafica si
-- segue, cosi' le dichiarazioni compaiono nella scheda ), con indici, vincoli e vista.
--
-- IDEMPOTENTE. CREATE TABLE IF NOT EXISTS, indici con IF NOT EXISTS, vincoli tolti con DROP FOREIGN KEY IF EXISTS e rimessi,
-- vista con CREATE OR REPLACE.

-- | 202609302358

CREATE TABLE IF NOT EXISTS `dichiarazioni_intento` (             --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_anagrafica` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'esportatore abituale che ha emesso la dichiarazione
  `protocollo` char(32) DEFAULT NULL,                         -- protocollo di ricezione telematica ( 17 cifre, trattino, 6 cifre )
  `data_protocollo` date DEFAULT NULL,                        -- data della ricevuta telematica
  `anno` int(4) DEFAULT NULL,                                 -- anno a cui si riferisce la dichiarazione
  `data_inizio` date DEFAULT NULL,                            -- inizio del periodo di validita', se la dichiarazione ne indica uno
  `data_fine` date DEFAULT NULL,                              -- fine del periodo di validita'
  `importo` decimal(16,2) DEFAULT NULL,                       -- importo fino a concorrenza del quale vale la dichiarazione
  `note` text DEFAULT NULL,                                   -- note
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito la dichiarazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato la dichiarazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 202609302359

ALTER TABLE `dichiarazioni_intento`
	ADD PRIMARY KEY IF NOT EXISTS (`id`),
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_anagrafica`,`protocollo`),
	ADD KEY IF NOT EXISTS `id_anagrafica` (`id_anagrafica`),
	ADD KEY IF NOT EXISTS `data_protocollo` (`data_protocollo`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 202610010000

ALTER TABLE `dichiarazioni_intento` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

-- | 202610010001

-- la procedura toglie il vincolo se c'e', porta la colonna al tipo dell'id che cita e rimette il vincolo: sui deploy
-- installati prima di marzo gli id delle tabelle storiche sono spesso int( 11 ), e la chiave da una colonna bigint( 20 )
-- fallisce con 1005 errno 150 ( segnalato da utensilerialughese il 01/10/2026 )
CREATE OR REPLACE PROCEDURE `__patch_dichiarazioni_intento__`()
BEGIN

    DECLARE tipo_id VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE tipo_colonna VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;

    -- dichiarazioni_intento_ibfk_01
    ALTER TABLE `dichiarazioni_intento` DROP FOREIGN KEY IF EXISTS `dichiarazioni_intento_ibfk_01`;
    SELECT COLUMN_TYPE INTO tipo_id FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'anagrafica' AND COLUMN_NAME = 'id';
    SELECT COLUMN_TYPE INTO tipo_colonna FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'dichiarazioni_intento' AND COLUMN_NAME = 'id_anagrafica';
    IF tipo_id IS NOT NULL AND tipo_colonna IS NOT NULL AND tipo_id != tipo_colonna THEN
        SET @sql = CONCAT( 'ALTER TABLE `dichiarazioni_intento` MODIFY `id_anagrafica` ', tipo_id, ' DEFAULT NULL' );
        PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
    END IF;
    ALTER TABLE `dichiarazioni_intento`
        ADD CONSTRAINT `dichiarazioni_intento_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

    -- dichiarazioni_intento_ibfk_98_nofollow
    ALTER TABLE `dichiarazioni_intento` DROP FOREIGN KEY IF EXISTS `dichiarazioni_intento_ibfk_98_nofollow`;
    SELECT COLUMN_TYPE INTO tipo_id FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'account' AND COLUMN_NAME = 'id';
    SELECT COLUMN_TYPE INTO tipo_colonna FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'dichiarazioni_intento' AND COLUMN_NAME = 'id_account_inserimento';
    IF tipo_id IS NOT NULL AND tipo_colonna IS NOT NULL AND tipo_id != tipo_colonna THEN
        SET @sql = CONCAT( 'ALTER TABLE `dichiarazioni_intento` MODIFY `id_account_inserimento` ', tipo_id, ' DEFAULT NULL' );
        PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
    END IF;
    ALTER TABLE `dichiarazioni_intento`
        ADD CONSTRAINT `dichiarazioni_intento_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

    -- dichiarazioni_intento_ibfk_99_nofollow
    ALTER TABLE `dichiarazioni_intento` DROP FOREIGN KEY IF EXISTS `dichiarazioni_intento_ibfk_99_nofollow`;
    SELECT COLUMN_TYPE INTO tipo_id FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'account' AND COLUMN_NAME = 'id';
    SELECT COLUMN_TYPE INTO tipo_colonna FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'dichiarazioni_intento' AND COLUMN_NAME = 'id_account_aggiornamento';
    IF tipo_id IS NOT NULL AND tipo_colonna IS NOT NULL AND tipo_id != tipo_colonna THEN
        SET @sql = CONCAT( 'ALTER TABLE `dichiarazioni_intento` MODIFY `id_account_aggiornamento` ', tipo_id, ' DEFAULT NULL' );
        PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
    END IF;
    ALTER TABLE `dichiarazioni_intento`
        ADD CONSTRAINT `dichiarazioni_intento_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

END;

-- | 202610010002

CALL `__patch_dichiarazioni_intento__`();

-- | 202610010003

CREATE OR REPLACE VIEW `dichiarazioni_intento_view` AS
	SELECT
		dichiarazioni_intento.id,
		dichiarazioni_intento.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		dichiarazioni_intento.protocollo,
		dichiarazioni_intento.data_protocollo,
		dichiarazioni_intento.anno,
		dichiarazioni_intento.data_inizio,
		dichiarazioni_intento.data_fine,
		dichiarazioni_intento.importo,
		dichiarazioni_intento.id_account_inserimento,
		dichiarazioni_intento.id_account_aggiornamento,
		concat_ws( ' ', dichiarazioni_intento.protocollo, 'del', dichiarazioni_intento.data_protocollo ) AS __label__
	FROM dichiarazioni_intento
		LEFT JOIN anagrafica AS a1 ON a1.id = dichiarazioni_intento.id_anagrafica
;

-- | 202610010004

DROP PROCEDURE IF EXISTS `__patch_dichiarazioni_intento__`;

-- | 202610010005

-- quella di _202609302355.anagrafica.rea.rappresentante.sql, che nel suo file non ha un id libero dopo la CALL
DROP PROCEDURE IF EXISTS `__patch_rappresentante_fiscale__`;

-- | FINE FILE
