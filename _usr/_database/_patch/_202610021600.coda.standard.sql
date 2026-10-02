-- 2026-10-02 — la coda standard in fondo a ogni tabella
--
-- Contesto: il canone ( _usr/_docs/_read/300.database.md, "campi per le timestamp" ) vuole che ogni tabella che
-- non sia di sistema finisca con id_account_inserimento, timestamp_inserimento, id_account_aggiornamento,
-- timestamp_aggiornamento, in quest'ordine. Nei file di base 42 tabelle non l'avevano ( 31 standard, come iva,
-- lingue, stati, udm, e 11 gestite o assistite ) e 28 l'avevano con timestamp e account invertiti o con altre
-- colonne dopo; i file di base sono stati corretti nello stesso giro, qui si porta la correzione ai deploy.
--
-- COSA FA. Per ogni tabella vera del database, tranne quelle di sistema ( __*__ ) e le viste statiche
-- ( *_view_static, che sono copie delle viste ), se le quattro colonne non sono già le ultime e in quell'ordine:
-- aggiunge quelle che mancano e sposta in fondo quelle che ci sono, tenendone tipo, NULL, default e commento, con
-- una sola ALTER. Vale anche per le tabelle dei moduli e dei progetti: lo schema è uno.
--
-- Le chiavi 98 e 99 e gli indici delle due id_account_* non sono qui: li aggiunge la patch delle chiavi esterne,
-- che controlla prima tipi e righe orfane. Spostare una colonna ricopia la tabella: va lanciata fuori orario.
--
-- La procedura riceve un filtro LIKE sui nomi delle tabelle ( '%' per tutte ), per provarla su tabelle
-- usa-e-getta. L'esito è in @coda_tabelle e @coda_note, che il blocco dopo la CALL restituisce.
--
-- IDEMPOTENTE: una seconda esecuzione trova le code già in fondo e non fa niente.

-- | 202610021600

CREATE OR REPLACE PROCEDURE `__patch_coda_standard__`( IN filtro VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci )
BEGIN

    DECLARE fine INT DEFAULT 0;
    DECLARE errore INT DEFAULT 0;
    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE v_tabella CHAR(64) CHARACTER SET utf8;
    DECLARE v_ultima CHAR(64) CHARACTER SET utf8;
    DECLARE v_attuale TEXT CHARACTER SET utf8;
    DECLARE v_alter TEXT CHARACTER SET utf8;
    DECLARE v_dopo CHAR(64) CHARACTER SET utf8;
    DECLARE v_colonna CHAR(64) CHARACTER SET utf8;
    DECLARE v_definizione TEXT CHARACTER SET utf8;
    DECLARE v_i INT;

    DECLARE lista CURSOR FOR
        SELECT t.TABLE_NAME
        FROM information_schema.TABLES AS t
        WHERE t.TABLE_SCHEMA = database() AND t.TABLE_TYPE = 'BASE TABLE' AND t.TABLE_NAME LIKE filtro
          AND t.TABLE_NAME NOT LIKE '\_\_%' AND t.TABLE_NAME NOT LIKE '%\_view\_static'
        ORDER BY t.TABLE_NAME;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fine = 1;

    SET @coda_tabelle = 0, @coda_note = NULL;
    SET SESSION group_concat_max_len = 1048576;

    OPEN lista;

    ciclo: LOOP

        FETCH lista INTO v_tabella;
        IF fine = 1 THEN
            LEAVE ciclo;
        END IF;

        -- le ultime quattro colonne, nell'ordine in cui sono
        SELECT GROUP_CONCAT( x.COLUMN_NAME ORDER BY x.ORDINAL_POSITION SEPARATOR ',' ) INTO v_attuale
            FROM (
                SELECT COLUMN_NAME, ORDINAL_POSITION FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella
                ORDER BY ORDINAL_POSITION DESC LIMIT 4
            ) AS x;

        -- l'ultima colonna che non fa parte della coda: la coda va subito dopo
        SELECT COLUMN_NAME INTO v_ultima FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella
              AND COLUMN_NAME NOT IN ( 'id_account_inserimento', 'timestamp_inserimento', 'id_account_aggiornamento', 'timestamp_aggiornamento' )
            ORDER BY ORDINAL_POSITION DESC LIMIT 1;

        SET fine = 0;

        IF v_attuale <> 'id_account_inserimento,timestamp_inserimento,id_account_aggiornamento,timestamp_aggiornamento' THEN

            SET v_alter = NULL, v_dopo = v_ultima, v_i = 1;
            WHILE v_i <= 4 DO
                SET v_colonna = ELT( v_i, 'id_account_inserimento', 'timestamp_inserimento', 'id_account_aggiornamento', 'timestamp_aggiornamento' );
                SET v_definizione = NULL;
                SELECT CONCAT( 'MODIFY `', COLUMN_NAME, '` ', COLUMN_TYPE,
                        IF( IS_NULLABLE = 'NO', ' NOT NULL', ' NULL' ),
                        IF( COLUMN_DEFAULT IS NULL OR COLUMN_DEFAULT = 'NULL',
                            IF( IS_NULLABLE = 'YES', ' DEFAULT NULL', '' ),
                            CONCAT( ' DEFAULT ', COLUMN_DEFAULT ) ),
                        IF( COLUMN_COMMENT <> '', CONCAT( ' COMMENT ', QUOTE( COLUMN_COMMENT ) ), '' ) )
                    INTO v_definizione
                    FROM information_schema.COLUMNS
                    WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna;
                SET fine = 0;
                IF v_definizione IS NULL THEN
                    SET v_definizione = CONCAT( 'ADD COLUMN `', v_colonna, '` ',
                        IF( v_colonna LIKE 'id\_%', 'bigint(20)', 'int(11)' ), ' DEFAULT NULL' );
                END IF;
                SET v_alter = CONCAT_WS( ', ', v_alter, CONCAT( v_definizione, ' AFTER `', v_dopo, '`' ) );
                SET v_dopo = v_colonna, v_i = v_i + 1;
            END WHILE;

            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                    BEGIN
                        GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                        SET errore = 1;
                    END;
                SET errore = 0;
                SET @coda_sql = CONCAT( 'ALTER TABLE `', v_tabella, '` ', v_alter );
                PREPARE modifica FROM @coda_sql;
                EXECUTE modifica;
                DEALLOCATE PREPARE modifica;
                IF errore = 1 THEN
                    SET @coda_note = CONCAT_WS( '\n', @coda_note, LEFT( CONCAT( v_tabella, ': ', messaggio ), 255 ) );
                ELSE
                    SET @coda_tabelle = @coda_tabelle + 1;
                END IF;
            END;

        END IF;

    END LOOP;

    CLOSE lista;

END;

-- | 202610021601

-- si esegue su tutte le tabelle
CALL `__patch_coda_standard__`( '%' );

-- | 202610021602

-- quante tabelle sono state sistemate, e quali no: lo legge chi applica la patch a mano
SELECT @coda_tabelle AS tabelle, @coda_note AS nota;

-- | 202610021603

-- si libera la procedura
DROP PROCEDURE IF EXISTS `__patch_coda_standard__`;

-- | FINE
