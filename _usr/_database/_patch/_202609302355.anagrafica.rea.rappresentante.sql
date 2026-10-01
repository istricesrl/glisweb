-- 2026-09-30 — iscrizione al REA e rappresentante fiscale nell'anagrafica
--
-- COSA SI VEDEVA. La fattura elettronica non poteva scrivere IscrizioneREA ( obbligatoria per le società iscritte al
-- registro delle imprese ) ne' RappresentanteFiscale ( per il cedente non residente che opera tramite un rappresentante in
-- Italia ): l'anagrafica non aveva dove tenere quei dati.
--
-- COSA FA. Aggiunge ad anagrafica l'ufficio e il numero REA, il capitale sociale, socio unico e stato di liquidazione, e
-- la chiave esterna verso l'anagrafica del rappresentante fiscale, con indice e vincolo ( _nofollow, SET NULL ).
--
-- IDEMPOTENTE. ADD COLUMN IF NOT EXISTS e ADD KEY IF NOT EXISTS; il vincolo si toglie con DROP FOREIGN KEY IF EXISTS e si
-- rimette uguale.

-- | 202609302355

ALTER TABLE `anagrafica`
	ADD COLUMN IF NOT EXISTS `rea_ufficio` char(2) DEFAULT NULL AFTER `id_regime`,
	ADD COLUMN IF NOT EXISTS `rea_numero` char(20) DEFAULT NULL AFTER `rea_ufficio`,
	ADD COLUMN IF NOT EXISTS `capitale_sociale` decimal(16,2) DEFAULT NULL AFTER `rea_numero`,
	ADD COLUMN IF NOT EXISTS `socio_unico` enum('SU','SM') DEFAULT NULL AFTER `capitale_sociale`,
	ADD COLUMN IF NOT EXISTS `stato_liquidazione` enum('LS','LN') DEFAULT NULL AFTER `socio_unico`,
	ADD COLUMN IF NOT EXISTS `id_rappresentante_fiscale` bigint(20) DEFAULT NULL AFTER `stato_liquidazione`,
	ADD KEY IF NOT EXISTS `id_rappresentante_fiscale` (`id_rappresentante_fiscale`);

-- | 202609302356

-- la procedura toglie il vincolo se c'e', porta la colonna al tipo dell'id che cita e rimette il vincolo: sui deploy
-- installati prima di marzo gli id delle tabelle storiche sono spesso int( 11 ), e la chiave da una colonna bigint( 20 )
-- fallisce con 1005 errno 150 ( segnalato da utensilerialughese il 01/10/2026 )
CREATE OR REPLACE PROCEDURE `__patch_rappresentante_fiscale__`()
BEGIN

    DECLARE tipo_id VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE tipo_colonna VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;

    -- anagrafica_ibfk_10_nofollow
    ALTER TABLE `anagrafica` DROP FOREIGN KEY IF EXISTS `anagrafica_ibfk_10_nofollow`;
    SELECT COLUMN_TYPE INTO tipo_id FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'anagrafica' AND COLUMN_NAME = 'id';
    SELECT COLUMN_TYPE INTO tipo_colonna FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'anagrafica' AND COLUMN_NAME = 'id_rappresentante_fiscale';
    IF tipo_id IS NOT NULL AND tipo_colonna IS NOT NULL AND tipo_id != tipo_colonna THEN
        SET @sql = CONCAT( 'ALTER TABLE `anagrafica` MODIFY `id_rappresentante_fiscale` ', tipo_id, ' DEFAULT NULL' );
        PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
    END IF;
    ALTER TABLE `anagrafica`
        ADD CONSTRAINT `anagrafica_ibfk_10_nofollow` FOREIGN KEY (`id_rappresentante_fiscale`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

END;

-- | 202609302357

-- la procedura si toglie in _202609302358.dichiarazioni.intento.sql ( blocco 202610010005 ): qui non resta un id libero
CALL `__patch_rappresentante_fiscale__`();

-- | FINE FILE
