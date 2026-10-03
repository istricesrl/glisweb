-- 2026-10-03 — residui del canone trovati da GIMBE sul banco MySQL 8.4 ( copia di Azure ) con canone-vivo:
-- - mailing.promemoria_id_tipologia e promemoria_id_anagrafica_programmazione sono bigint(20): sono id, e la 1500 col criterio
--   %\_id\_% le converte; il canone le diceva int(11) ( corretto anche _010000999999.tables.sql );
-- - metadati_articoli, metadati_prodotti, recensioni, relazioni_articoli: id AUTO_INCREMENT come dice il canone
--   ( _030000999999.indexes.sql ), a gimbe mancava; come per mail_sent nella 3810 si spengono i controlli delle chiavi.
-- Stesso giro della 3810: __patch_allarga__ tocca solo le colonne che soddisfano la condizione. Un'istruzione per blocco.
-- IDEMPOTENTE.

-- | 202610033910


CREATE OR REPLACE PROCEDURE `__patch_allarga__`( p_tabella CHAR(64), p_colonna CHAR(64), p_tipo VARCHAR(255), p_quando TEXT )
BEGIN
    -- p_quando: condizione su information_schema.COLUMNS ( alias c ) per cui la colonna va cambiata
    DECLARE errore INT DEFAULT 0;
    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
            SET errore = 1;
        END;
    SET @allarga_da_fare = 0;
    SET @allarga_sql = CONCAT( 'SELECT count(*) INTO @allarga_da_fare FROM information_schema.COLUMNS AS c ',
        'WHERE c.TABLE_SCHEMA = database() AND c.TABLE_NAME = ''', p_tabella, ''' AND c.COLUMN_NAME = ''', p_colonna, ''' AND ( ', p_quando, ' )' );
    PREPARE fai FROM @allarga_sql;
    EXECUTE fai;
    DEALLOCATE PREPARE fai;
    IF @allarga_da_fare > 0 THEN
        SET @allarga_sql = CONCAT( 'ALTER TABLE `', p_tabella, '` MODIFY `', p_colonna, '` ', p_tipo );
        PREPARE fai FROM @allarga_sql;
        EXECUTE fai;
        DEALLOCATE PREPARE fai;
        SET @allarga_note = CONCAT_WS( '\n', @allarga_note, CONCAT( p_tabella, '.', p_colonna, ': ',
            IF( errore = 1, CONCAT( 'NON cambiata, ', messaggio ), CONCAT( 'ora ', p_tipo ) ) ) );
    END IF;
END;

-- | 202610033911

CALL `__patch_allarga__`( 'mailing', 'promemoria_id_tipologia', 'bigint(20) DEFAULT NULL', 'c.DATA_TYPE IN ( ''int'', ''mediumint'', ''smallint'' )' );

-- | 202610033912

CALL `__patch_allarga__`( 'mailing', 'promemoria_id_anagrafica_programmazione', 'bigint(20) DEFAULT NULL', 'c.DATA_TYPE IN ( ''int'', ''mediumint'', ''smallint'' )' );

-- | 202610033913

SET SESSION foreign_key_checks = 0;

-- | 202610033914

CALL `__patch_allarga__`( 'metadati_articoli', 'id', 'bigint(20) NOT NULL AUTO_INCREMENT', 'c.EXTRA NOT LIKE ''%auto_increment%''' );

-- | 202610033915

CALL `__patch_allarga__`( 'metadati_prodotti', 'id', 'bigint(20) NOT NULL AUTO_INCREMENT', 'c.EXTRA NOT LIKE ''%auto_increment%''' );

-- | 202610033916

CALL `__patch_allarga__`( 'recensioni', 'id', 'bigint(20) NOT NULL AUTO_INCREMENT', 'c.EXTRA NOT LIKE ''%auto_increment%''' );

-- | 202610033917

CALL `__patch_allarga__`( 'relazioni_articoli', 'id', 'bigint(20) NOT NULL AUTO_INCREMENT', 'c.EXTRA NOT LIKE ''%auto_increment%''' );

-- | 202610033918

SET SESSION foreign_key_checks = 1;

-- | 202610033919

DROP PROCEDURE IF EXISTS `__patch_allarga__`;

-- | FINE
