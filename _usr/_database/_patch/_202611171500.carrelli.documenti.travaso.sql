-- 2026-11-17 — carrelli: il documento del carrello passa in carrelli_documenti
--
-- Nel canone carrelli non ha piu' id_documento: il legame fra carrello e documento sta in carrelli_documenti. La
-- pagamenti_view del file base leggeva ancora carrelli.id_documento, e un database costruito da zero si fermava alla
-- 090000023100 con 1054 Unknown column 'carrelli.id_documento' ( segnalato da extremumgdr il 17/11/2026, upgrade DEV
-- su database vuoto ). La vista ora legge carrelli_documenti; sui deploy creati prima del canone la colonna c'e'
-- ancora, coi dati, e il ricaricamento della vista li perderebbe se non passassero di la'.
--
-- Cosa fa: copia carrelli.id_documento in carrelli_documenti dove la coppia carrello-documento manca. Con la
-- procedura che prova e annota ( il modello e' la 202611042330 ): sui database creati dal canone la colonna non c'e',
-- e l'INSERT che fallisce lo dice nella nota invece di fermare la coda.
--
-- Cosa NON fa ( punto 12 ): il DROP di carrelli.id_documento e di carrelli_ibfk_16_nofollow.
--
-- IDEMPOTENTE.

-- | 202611171500

-- la procedura che prova un'istruzione e, se fallisce, lo annota invece di fermare la coda
CREATE OR REPLACE PROCEDURE `__patch_carrelli_documenti_travaso__`( IN istruzione LONGTEXT, IN oggetto VARCHAR(64) )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    SET @carrelli_documenti_travaso_sql = istruzione;
    PREPARE prova FROM @carrelli_documenti_travaso_sql;
    IF messaggio IS NULL THEN
        EXECUTE prova;
        DEALLOCATE PREPARE prova;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @carrelli_documenti_travaso_note = CONCAT_WS( '\n', @carrelli_documenti_travaso_note, CONCAT( oggetto, ': ', messaggio ) );
    END IF;

END;

-- | 202611171501

-- carrelli.id_documento -> carrelli_documenti
CALL `__patch_carrelli_documenti_travaso__`( 'INSERT INTO `carrelli_documenti` ( `id_carrello`, `id_documento` ) SELECT `carrelli`.`id`, `carrelli`.`id_documento` FROM `carrelli` INNER JOIN `documenti` ON `documenti`.`id` = `carrelli`.`id_documento` LEFT JOIN `carrelli_documenti` AS `cd` ON `cd`.`id_carrello` = `carrelli`.`id` AND `cd`.`id_documento` = `carrelli`.`id_documento` WHERE `cd`.`id` IS NULL', 'carrelli.id_documento' );

-- | 202611171502

DROP PROCEDURE IF EXISTS `__patch_carrelli_documenti_travaso__`;

-- | FINE FILE
