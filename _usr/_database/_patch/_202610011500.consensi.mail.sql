-- 2026-10-01 — il consenso alle comunicazioni anche sul singolo indirizzo mail
--
-- COSA SI VEDEVA. La newsletter ( _mod/_ML000.mailing ) iscrive dal sito pubblico indirizzi che non hanno
-- un'anagrafica, e il link di disiscrizione arriva a un indirizzo, non a una persona: anagrafica_consensi poteva
-- tenere il consenso solo sull'anagrafica, quindi un iscritto senza anagrafica non aveva dove registrare ne' il
-- consenso ne' la revoca, e chi si toglieva rientrava alla prima lista ripopolata.
--
-- COSA FA. Aggiunge anagrafica_consensi.id_mail, facoltativo: una riga di consenso sta sull'anagrafica oppure sul
-- singolo indirizzo. Chiave unica ( id_mail, id_consenso ) gemella di quella su ( id_anagrafica, id_consenso ),
-- vincolo verso mail ( CASCADE, come quello verso anagrafica ), e la colonna nella vista.
--
-- IDEMPOTENTE. ADD COLUMN IF NOT EXISTS e ADD KEY IF NOT EXISTS; il vincolo si toglie con DROP FOREIGN KEY IF EXISTS e
-- si rimette uguale; la vista e' CREATE OR REPLACE.

-- | 202610011500

ALTER TABLE `anagrafica_consensi`
	ADD COLUMN IF NOT EXISTS `id_mail` bigint(20) DEFAULT NULL AFTER `id_anagrafica`,
	ADD UNIQUE KEY IF NOT EXISTS `unica_mail` (`id_mail`, `id_consenso`),
	ADD KEY IF NOT EXISTS `id_mail` (`id_mail`);

-- | 202610011501

-- la procedura toglie il vincolo se c'e', porta la colonna al tipo dell'id che cita e rimette il vincolo: sui deploy
-- installati prima di marzo gli id delle tabelle storiche sono spesso int( 11 ), e la chiave da una colonna bigint( 20 )
-- fallisce con 1005 errno 150 ( segnalato da utensilerialughese il 01/10/2026 )
CREATE OR REPLACE PROCEDURE `__patch_consensi_mail__`()
BEGIN

    DECLARE tipo_id VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE tipo_colonna VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;

    -- anagrafica_consensi_ibfk_04
    ALTER TABLE `anagrafica_consensi` DROP FOREIGN KEY IF EXISTS `anagrafica_consensi_ibfk_04`;
    SELECT COLUMN_TYPE INTO tipo_id FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mail' AND COLUMN_NAME = 'id';
    SELECT COLUMN_TYPE INTO tipo_colonna FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'anagrafica_consensi' AND COLUMN_NAME = 'id_mail';
    IF tipo_id IS NOT NULL AND tipo_colonna IS NOT NULL AND tipo_id != tipo_colonna THEN
        SET @sql = CONCAT( 'ALTER TABLE `anagrafica_consensi` MODIFY `id_mail` ', tipo_id, ' DEFAULT NULL' );
        PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
    END IF;
    ALTER TABLE `anagrafica_consensi`
        ADD CONSTRAINT `anagrafica_consensi_ibfk_04` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

END;

-- | 202610011502

CALL `__patch_consensi_mail__`();

-- | 202610011503

CREATE OR REPLACE VIEW `anagrafica_consensi_view` AS
	SELECT
		anagrafica_consensi.id,
		anagrafica_consensi.id_account,
		anagrafica_consensi.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		anagrafica_consensi.id_mail,
		mail.indirizzo AS mail,
		anagrafica_consensi.id_consenso,
		anagrafica_consensi.se_prestato,
		anagrafica_consensi.timestamp_consenso,
		anagrafica_consensi.id_account_inserimento,
		anagrafica_consensi.id_account_aggiornamento,
		concat( 'consenso per ', anagrafica_consensi.id_consenso, ' di ', coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), mail.indirizzo, '' ) ) AS __label__
	FROM anagrafica_consensi
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_consensi.id_anagrafica
		LEFT JOIN mail ON mail.id = anagrafica_consensi.id_mail
;

-- | 202610011504

DROP PROCEDURE IF EXISTS `__patch_consensi_mail__`;

-- | FINE FILE
