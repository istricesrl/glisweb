-- 2026-10-03 — regola di Fabio: la colonna codice, dove c'e', va sempre indicizzata. Nel canone ne mancavano 15
-- ( aggiunte in _030000999999.indexes.sql ); qui il giro e' generico: ogni tabella base del database con una colonna
-- codice che non apre nessun indice prende KEY `codice` ( o `indice_codice` se il nome e' gia' usato da un indice
-- composto ), comprese le tabelle custom dei deploy. Le colonne text/blob si saltano ( servirebbe un prefisso ) e finiscono
-- in @codice_note, come gli errori. Un'istruzione per blocco. IDEMPOTENTE.

-- | 202610033950

CREATE OR REPLACE PROCEDURE `__patch_indice_codice__`()
BEGIN
    DECLARE fatto INT DEFAULT 0;
    DECLARE errore INT DEFAULT 0;
    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE v_tabella CHAR(64);
    DECLARE v_nome CHAR(64);
    DECLARE v_tipo CHAR(64);
    DECLARE tabelle CURSOR FOR
        SELECT c.TABLE_NAME,
            IF( EXISTS ( SELECT 1 FROM information_schema.STATISTICS AS n WHERE n.TABLE_SCHEMA = c.TABLE_SCHEMA AND n.TABLE_NAME = c.TABLE_NAME AND n.INDEX_NAME = 'codice' ), 'indice_codice', 'codice' ),
            c.DATA_TYPE
        FROM information_schema.COLUMNS AS c
        INNER JOIN information_schema.TABLES AS t ON t.TABLE_SCHEMA = c.TABLE_SCHEMA AND t.TABLE_NAME = c.TABLE_NAME AND t.TABLE_TYPE = 'BASE TABLE'
        WHERE c.TABLE_SCHEMA = database() AND c.COLUMN_NAME = 'codice'
        AND NOT EXISTS ( SELECT 1 FROM information_schema.STATISTICS AS s WHERE s.TABLE_SCHEMA = c.TABLE_SCHEMA AND s.TABLE_NAME = c.TABLE_NAME AND s.COLUMN_NAME = 'codice' AND s.SEQ_IN_INDEX = 1 );
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fatto = 1;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
            SET errore = 1;
        END;
    OPEN tabelle;
    giro: LOOP
        FETCH tabelle INTO v_tabella, v_nome, v_tipo;
        IF fatto = 1 THEN
            LEAVE giro;
        END IF;
        IF v_tipo IN ( 'text', 'tinytext', 'mediumtext', 'longtext', 'blob', 'tinyblob', 'mediumblob', 'longblob', 'json' ) THEN
            SET @codice_note = CONCAT_WS( '\n', @codice_note, CONCAT( v_tabella, '.codice: saltata, tipo ', v_tipo ) );
        ELSE
            SET errore = 0;
            SET @codice_sql = CONCAT( 'ALTER TABLE `', v_tabella, '` ADD KEY `', v_nome, '` (`codice`)' );
            PREPARE fai FROM @codice_sql;
            EXECUTE fai;
            DEALLOCATE PREPARE fai;
            SET @codice_note = CONCAT_WS( '\n', @codice_note, CONCAT( v_tabella, '.codice: ',
                IF( errore = 1, CONCAT( 'NON indicizzata, ', messaggio ), CONCAT( 'KEY ', v_nome ) ) ) );
        END IF;
    END LOOP;
    CLOSE tabelle;
END;

-- | 202610033951

CALL `__patch_indice_codice__`();

-- | 202610033952

DROP PROCEDURE IF EXISTS `__patch_indice_codice__`;

-- | FINE
