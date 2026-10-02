-- 2026-10-02 — altri tre tipi del canone, visti su bernispa e polmasi dev
--
-- - articoli_view_static.prezzi e' text ( su bernispa c'e' un valore di 963 caratteri, il canone diceva char(255) );
-- - carrelli_articoli.destinatario_id_tipologia_anagrafica e' bigint(20): il canone la diceva INT(11), contro la regola
--   per cui ogni colonna che cita un id ha il tipo di id; le colonne destinatario_id_* la 1500 non le prendeva;
-- - redirect.se_query_string e' tinyint(1) come gia' nel canone ( su polmasi era char(255) ): si converte solo se i
--   valori sono 0, 1 o vuoti.
-- Stessa procedura della _202610023700.canone.allarga.sql. IDEMPOTENTE.

-- | 202610023800

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

-- | 202610023801

SET @allarga_note = NULL;

-- | 202610023802

CALL `__patch_allarga__`( 'articoli_view_static', 'prezzi', 'text DEFAULT NULL', 'c.DATA_TYPE IN ( ''char'', ''varchar'', ''tinytext'' )' );

-- | 202610023803

CALL `__patch_allarga__`( 'carrelli_articoli', 'destinatario_id_tipologia_anagrafica', 'bigint(20) DEFAULT NULL', 'c.DATA_TYPE IN ( ''int'', ''smallint'', ''mediumint'', ''tinyint'' )' );

-- | 202610023804

UPDATE `redirect` SET `se_query_string` = NULL WHERE LENGTH( `se_query_string` ) = 0;

-- | 202610023805

CALL `__patch_allarga__`( 'redirect', 'se_query_string', 'tinyint(1) DEFAULT NULL',
    'c.DATA_TYPE IN ( ''char'', ''varchar'' ) AND NOT EXISTS ( SELECT 1 FROM `redirect` WHERE `se_query_string` NOT IN ( ''0'', ''1'' ) )' );

-- | 202610023806

SELECT @allarga_note AS nota;

-- | 202610023807

DROP PROCEDURE IF EXISTS `__patch_allarga__`;

-- | FINE
