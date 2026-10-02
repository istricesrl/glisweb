-- 2026-10-03 — ultimi residui visti sui deploy dev
--
-- - attivita_view_static.codice: l'indice delle tabelle statiche sta in _080000999999.static.sql, che la 3400 non
--   legge, e a quattro deploy mancava;
-- - todo_view_static.anno_programmazione e' int(4) ( gimbe aveva year(4) );
-- - mail_sent.id e' AUTO_INCREMENT ( gimbe non lo aveva ): la chiave di file.id_mail_sent blocca il MODIFY anche se il
--   tipo non cambia, quindi si spengono i controlli delle chiavi per quel blocco.
-- IDEMPOTENTE.

-- | 202610023810

ALTER TABLE `attivita_view_static` ADD KEY IF NOT EXISTS `codice` (`codice`);

-- | 202610023811

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

-- | 202610023812

SET @allarga_note = NULL;

-- | 202610023813

CALL `__patch_allarga__`( 'todo_view_static', 'anno_programmazione', 'int(4) DEFAULT NULL', 'c.DATA_TYPE = ''year''' );

-- | 202610023814

SET SESSION foreign_key_checks = 0;

-- | 202610023815

CALL `__patch_allarga__`( 'mail_sent', 'id', 'bigint(20) NOT NULL AUTO_INCREMENT', 'c.EXTRA NOT LIKE ''%auto_increment%''' );

-- | 202610023816

SET SESSION foreign_key_checks = 1;

-- | 202610023817

SELECT @allarga_note AS nota;

-- | 202610023818

DROP PROCEDURE IF EXISTS `__patch_allarga__`;

-- | FINE
