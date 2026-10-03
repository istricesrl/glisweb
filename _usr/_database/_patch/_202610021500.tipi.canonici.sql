-- 2026-10-02 — i tipi del canone: id e id_* bigint(20), se_* tinyint(1)
--
-- Contesto: il canone ( _usr/_docs/_read/300.database.md, "id e codici" e "campi" ) vuole id e ogni colonna che lo
-- cita bigint(20), e i flag se_* tinyint(1). I file di base lo fanno, i deploy no: misurato il 02/10/2026, crmfia,
-- gimbe, polmasi e lughese hanno fra 1.167 e 1.432 colonne id/id_* ancora int(11) contro 243-386 bigint(20) ( le
-- tabelle installate prima che i file di base passassero a bigint, e quelle aggiunte dopo ), bernispa ne ha 2.
-- Con i tipi mescolati una chiave esterna fra una tabella vecchia e una nuova non si può creare ( errno 150 ):
-- _202609301100.chiavi.esterne.sql le salta con "tipi diversi", e le patch successive hanno dovuto dare alla
-- colonna nuova il tipo della madre invece di quello del canone. Questa patch toglie la causa.
--
-- COSA FA. Per ogni tabella vera ( non le viste ) del database:
--
-- -# id, id_* e le colonne che citano un id ( *_id_*: destinatario_id_comune, fatturazione_id_modalita_pagamento )
--    int, mediumint o smallint diventano bigint(20), tenendo NULL / NOT NULL, default, AUTO_INCREMENT e commento; vale
--    per tutte le tabelle, anche quelle dei moduli e dei progetti, perché lo schema è uno; le *_id_* sono entrate il
--    03/10/2026: lasciate int, restavano legate da una chiave esterna a una madre bigint, e InnoDB con una chiave così
--    smette di caricare tutte le chiavi della tabella ( carrelli di polmasi );
-- -# se_* int diventano tinyint(1), con lo stesso default;
-- -# recensioni.id_categoria_prodotti, id_categoria_notizie e id_notizia, che i file di base dichiaravano char(32)
--    per errore, diventano bigint(20) solo se contengono soltanto numeri: '' diventa NULL, e se c'è anche un solo
--    valore non numerico la colonna resta com'è e lo si scrive nella nota.
--
-- Una ALTER per tabella, con tutte le colonne insieme, perché MariaDB ricopia la tabella a ogni ALTER che cambia un
-- tipo: su una tabella grande è il costo di questa patch, e conviene applicarla fuori orario. La ALTER gira con
-- foreign_key_checks a 0, che permette di cambiare il tipo di una colonna referenziata: madre e figlie cambiano
-- tutte, e alla fine i vincoli collegano di nuovo colonne dello stesso tipo ( provato il 02/10/2026 su MariaDB
-- 10.3.39: il vincolo resta e continua a impedire la cancellazione della madre ).
--
-- MySQL 8 invece rifiuta di cambiare il tipo di una colonna che sta in una chiave esterna anche con foreign_key_checks
-- a 0 ( errore 3780, visto il 03/10/2026 sulla copia della PROD di gimbe su Azure: la patch convertiva quasi niente ).
-- Dal 03/10/2026 quindi, su entrambi i server, le chiavi esterne che toccano una colonna da convertire si tolgono prima del giro
-- e si rimettono identiche dopo ( nome, colonne, madre, regole ), una ALTER per tabella; quelle che non rientrano
-- finiscono nella nota. Le si legge da information_schema una volta sola, in tabelle temporanee, perché interrogarlo
-- tabella per tabella su un server con molti database costa troppo.
--
-- La procedura riceve un filtro LIKE sui nomi delle tabelle ( '%' per tutte ), che serve a provarla su tabelle
-- usa-e-getta. Non restituisce righe dalla CALL ( vedi _202609301100.chiavi.esterne.sql ): l'esito è in
-- @tipi_canonici_tabelle, @tipi_canonici_colonne e @tipi_canonici_note, che il blocco dopo restituisce.
--
-- IDEMPOTENTE: una seconda esecuzione non trova colonne da convertire e non fa niente.

-- | 202610021500

CREATE OR REPLACE PROCEDURE `__patch_tipi_canonici__`( IN filtro VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci )
BEGIN

    DECLARE fine INT DEFAULT 0;
    DECLARE errore INT DEFAULT 0;
    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE v_tabella CHAR(64) CHARACTER SET utf8;
    DECLARE v_modifiche, v_numero, v_i, v_chiavi_tabelle INT DEFAULT 0;

    DECLARE lista CURSOR FOR
        SELECT DISTINCT c.TABLE_NAME
        FROM information_schema.COLUMNS AS c
        INNER JOIN information_schema.TABLES AS t
            ON t.TABLE_SCHEMA = c.TABLE_SCHEMA AND t.TABLE_NAME = c.TABLE_NAME AND t.TABLE_TYPE = 'BASE TABLE'
        WHERE c.TABLE_SCHEMA = database() AND c.TABLE_NAME LIKE filtro AND c.EXTRA NOT LIKE '%GENERATED%'
          AND (
                ( ( c.COLUMN_NAME = 'id' OR c.COLUMN_NAME LIKE 'id\_%' OR c.COLUMN_NAME LIKE '%\_id\_%' ) AND c.DATA_TYPE IN ( 'int', 'mediumint', 'smallint' ) )
             OR ( c.COLUMN_NAME LIKE 'se\_%' AND c.DATA_TYPE IN ( 'int', 'mediumint', 'smallint', 'bigint' ) )
             OR ( c.TABLE_NAME = 'recensioni' AND c.COLUMN_NAME IN ( 'id_categoria_prodotti', 'id_categoria_notizie', 'id_notizia' ) AND c.DATA_TYPE = 'char' )
          )
        ORDER BY c.TABLE_NAME;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fine = 1;

    SET @tipi_canonici_controlli = @@foreign_key_checks;
    SET @tipi_canonici_tabelle = 0, @tipi_canonici_colonne = 0, @tipi_canonici_note = NULL;
    SET SESSION group_concat_max_len = 1048576;

    -- le colonne di recensioni da lasciare char, perché hanno valori non numerici
    DROP TEMPORARY TABLE IF EXISTS `__tipi_canonici_salta__`;
    CREATE TEMPORARY TABLE `__tipi_canonici_salta__` ( `colonna` CHAR(64) CHARACTER SET utf8 PRIMARY KEY );

    -- recensioni: le colonne char diventano numeriche solo se i valori lo sono già
    IF 'recensioni' LIKE filtro THEN
        BEGIN
            DECLARE v_colonna CHAR(64) CHARACTER SET utf8;
            DECLARE fine_r INT DEFAULT 0;
            DECLARE colonne_r CURSOR FOR
                SELECT COLUMN_NAME FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'recensioni' AND DATA_TYPE = 'char'
                  AND COLUMN_NAME IN ( 'id_categoria_prodotti', 'id_categoria_notizie', 'id_notizia' );
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET fine_r = 1;
            OPEN colonne_r;
            ciclo_r: LOOP
                FETCH colonne_r INTO v_colonna;
                IF fine_r = 1 THEN LEAVE ciclo_r; END IF;
                SET @tipi_canonici_sql = CONCAT( 'SELECT count(*) INTO @tipi_canonici_conto FROM `recensioni` WHERE `', v_colonna,
                    '` IS NOT NULL AND `', v_colonna, '` <> '''' AND `', v_colonna, '` NOT REGEXP ''^[0-9]+$''' );
                PREPARE conta FROM @tipi_canonici_sql; EXECUTE conta; DEALLOCATE PREPARE conta;
                IF @tipi_canonici_conto > 0 THEN
                    INSERT INTO `__tipi_canonici_salta__` VALUES ( v_colonna );
                    SET @tipi_canonici_note = CONCAT_WS( '\n', @tipi_canonici_note,
                        CONCAT( 'recensioni.', v_colonna, ': ', @tipi_canonici_conto, ' valori non numerici, colonna lasciata char' ) );
                ELSE
                    SET @tipi_canonici_sql = CONCAT( 'UPDATE `recensioni` SET `', v_colonna, '` = NULL WHERE `', v_colonna, '` = ''''' );
                    PREPARE vuoti FROM @tipi_canonici_sql; EXECUTE vuoti; DEALLOCATE PREPARE vuoti;
                END IF;
            END LOOP;
            CLOSE colonne_r;
        END;
    END IF;

    -- le chiavi esterne che toccano una colonna da convertire ( figlia o madre ): si tolgono prima, si rimettono dopo
    DROP TEMPORARY TABLE IF EXISTS `__tipi_canonici_int__`;
    CREATE TEMPORARY TABLE `__tipi_canonici_int__` (
        `tabella` CHAR(64) CHARACTER SET utf8 NOT NULL, `colonna` CHAR(64) CHARACTER SET utf8 NOT NULL, PRIMARY KEY ( `tabella`, `colonna` ) );
    INSERT INTO `__tipi_canonici_int__`
        SELECT c.TABLE_NAME, c.COLUMN_NAME FROM information_schema.COLUMNS AS c
        WHERE c.TABLE_SCHEMA = database() AND c.DATA_TYPE IN ( 'int', 'mediumint', 'smallint' )
          AND ( c.COLUMN_NAME = 'id' OR c.COLUMN_NAME LIKE 'id\_%' OR c.COLUMN_NAME LIKE '%\_id\_%' );

    DROP TEMPORARY TABLE IF EXISTS `__tipi_canonici_kcu__`;
    CREATE TEMPORARY TABLE `__tipi_canonici_kcu__` (
        `tabella` CHAR(64) CHARACTER SET utf8 NOT NULL, `vincolo` CHAR(64) CHARACTER SET utf8 NOT NULL, `posizione` INT NOT NULL,
        `colonna` CHAR(64) CHARACTER SET utf8 NOT NULL, `madre` CHAR(64) CHARACTER SET utf8 NOT NULL,
        `colonna_madre` CHAR(64) CHARACTER SET utf8 NOT NULL, PRIMARY KEY ( `tabella`, `vincolo`, `posizione` ) );
    INSERT INTO `__tipi_canonici_kcu__`
        SELECT k.TABLE_NAME, k.CONSTRAINT_NAME, k.ORDINAL_POSITION, k.COLUMN_NAME, k.REFERENCED_TABLE_NAME, k.REFERENCED_COLUMN_NAME
        FROM information_schema.KEY_COLUMN_USAGE AS k
        WHERE k.TABLE_SCHEMA = database() AND k.REFERENCED_TABLE_NAME IS NOT NULL
          AND ( k.TABLE_NAME LIKE filtro OR k.REFERENCED_TABLE_NAME LIKE filtro );

    DROP TEMPORARY TABLE IF EXISTS `__tipi_canonici_regole__`;
    CREATE TEMPORARY TABLE `__tipi_canonici_regole__` (
        `tabella` CHAR(64) CHARACTER SET utf8 NOT NULL, `vincolo` CHAR(64) CHARACTER SET utf8 NOT NULL,
        `cancellazione` CHAR(16) CHARACTER SET utf8 NOT NULL, `aggiornamento` CHAR(16) CHARACTER SET utf8 NOT NULL,
        PRIMARY KEY ( `tabella`, `vincolo` ) );
    INSERT INTO `__tipi_canonici_regole__`
        SELECT r.TABLE_NAME, r.CONSTRAINT_NAME, r.DELETE_RULE, r.UPDATE_RULE
        FROM information_schema.REFERENTIAL_CONSTRAINTS AS r
        WHERE r.CONSTRAINT_SCHEMA = database();

    -- una riga per chiave: la clausola che la toglie e quella che la rimette uguale
    DROP TEMPORARY TABLE IF EXISTS `__tipi_canonici_chiave__`;
    CREATE TEMPORARY TABLE `__tipi_canonici_chiave__` (
        `tabella` CHAR(64) CHARACTER SET utf8 NOT NULL, `vincolo` CHAR(64) CHARACTER SET utf8 NOT NULL,
        `togli` TEXT CHARACTER SET utf8 NOT NULL, `metti` TEXT CHARACTER SET utf8 NOT NULL, PRIMARY KEY ( `tabella`, `vincolo` ) );
    INSERT INTO `__tipi_canonici_chiave__`
        SELECT k.`tabella`, k.`vincolo`,
            CONCAT( 'DROP FOREIGN KEY `', k.`vincolo`, '`' ),
            CONCAT( 'ADD CONSTRAINT `', k.`vincolo`, '` FOREIGN KEY ( ',
                GROUP_CONCAT( CONCAT( '`', k.`colonna`, '`' ) ORDER BY k.`posizione` SEPARATOR ', ' ), ' ) REFERENCES `', MAX( k.`madre` ), '` ( ',
                GROUP_CONCAT( CONCAT( '`', k.`colonna_madre`, '`' ) ORDER BY k.`posizione` SEPARATOR ', ' ), ' ) ON DELETE ',
                MAX( r.`cancellazione` ), ' ON UPDATE ', MAX( r.`aggiornamento` ) )
        FROM `__tipi_canonici_kcu__` AS k
        INNER JOIN `__tipi_canonici_regole__` AS r ON r.`tabella` = k.`tabella` AND r.`vincolo` = k.`vincolo`
        LEFT JOIN `__tipi_canonici_int__` AS f ON f.`tabella` = k.`tabella` AND f.`colonna` = k.`colonna`
        LEFT JOIN `__tipi_canonici_int__` AS m ON m.`tabella` = k.`madre` AND m.`colonna` = k.`colonna_madre`
        GROUP BY k.`tabella`, k.`vincolo`
        HAVING count( f.`colonna` ) + count( m.`colonna` ) > 0;

    -- una riga per tabella, con tutte le sue chiavi in una ALTER
    DROP TEMPORARY TABLE IF EXISTS `__tipi_canonici_fk__`;
    CREATE TEMPORARY TABLE `__tipi_canonici_fk__` (
        `numero` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `tabella` CHAR(64) CHARACTER SET utf8 NOT NULL,
        `togli` MEDIUMTEXT CHARACTER SET utf8 NOT NULL, `metti` MEDIUMTEXT CHARACTER SET utf8 NOT NULL,
        `chiavi` INT NOT NULL, `tolte` INT NOT NULL DEFAULT 0 );
    INSERT INTO `__tipi_canonici_fk__` ( `tabella`, `togli`, `metti`, `chiavi` )
        SELECT `tabella`, CONCAT( 'ALTER TABLE `', `tabella`, '` ', GROUP_CONCAT( `togli` ORDER BY `vincolo` SEPARATOR ', ' ) ),
            CONCAT( 'ALTER TABLE `', `tabella`, '` ', GROUP_CONCAT( `metti` ORDER BY `vincolo` SEPARATOR ', ' ) ), count(*)
        FROM `__tipi_canonici_chiave__`
        GROUP BY `tabella`
        ORDER BY `tabella`;

    SET v_chiavi_tabelle = ( SELECT count(*) FROM `__tipi_canonici_fk__` );
    SET @tipi_canonici_chiavi_tolte = 0, @tipi_canonici_chiavi_rimesse = 0;

    -- tolgo le chiavi, tabella per tabella
    SET v_i = 1;
    WHILE v_i <= v_chiavi_tabelle DO
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                BEGIN
                    GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                    SET errore = 1;
                END;
            SET errore = 0;
            SELECT `togli`, `tabella` INTO @tipi_canonici_sql, v_tabella FROM `__tipi_canonici_fk__` WHERE `numero` = v_i;
            SET foreign_key_checks = 0;
            PREPARE togli FROM @tipi_canonici_sql;
            EXECUTE togli;
            DEALLOCATE PREPARE togli;
            SET foreign_key_checks = @tipi_canonici_controlli;
            IF errore = 1 THEN
                SET @tipi_canonici_note = CONCAT_WS( '\n', @tipi_canonici_note, LEFT( CONCAT( v_tabella, ', chiavi non tolte: ', messaggio ), 255 ) );
            ELSE
                UPDATE `__tipi_canonici_fk__` SET `tolte` = 1 WHERE `numero` = v_i;
                SET @tipi_canonici_chiavi_tolte = @tipi_canonici_chiavi_tolte + ( SELECT `chiavi` FROM `__tipi_canonici_fk__` WHERE `numero` = v_i );
            END IF;
        END;
        SET v_i = v_i + 1;
    END WHILE;

    OPEN lista;

    ciclo: LOOP

        FETCH lista INTO v_tabella;
        IF fine = 1 THEN
            LEAVE ciclo;
        END IF;

        SET @tipi_canonici_sql = NULL, v_numero = 0;
        SELECT
            CONCAT( 'ALTER TABLE `', v_tabella, '` ', GROUP_CONCAT(
                CONCAT( 'MODIFY `', c.COLUMN_NAME, '` ',
                    IF( c.COLUMN_NAME LIKE 'se\_%', 'tinyint(1)', 'bigint(20)' ),
                    IF( c.IS_NULLABLE = 'NO', ' NOT NULL', ' NULL' ),
                    IF( c.COLUMN_DEFAULT IS NULL OR c.COLUMN_DEFAULT = 'NULL',
                        IF( c.IS_NULLABLE = 'YES', ' DEFAULT NULL', '' ),
                        CONCAT( ' DEFAULT ', c.COLUMN_DEFAULT ) ),
                    IF( c.EXTRA LIKE '%auto_increment%', ' AUTO_INCREMENT', '' ),
                    IF( c.COLUMN_COMMENT <> '', CONCAT( ' COMMENT ', QUOTE( c.COLUMN_COMMENT ) ), '' )
                ) ORDER BY c.ORDINAL_POSITION SEPARATOR ', ' ) ),
            count(*)
        INTO @tipi_canonici_sql, v_numero
        FROM information_schema.COLUMNS AS c
        WHERE c.TABLE_SCHEMA = database() AND c.TABLE_NAME = v_tabella AND c.EXTRA NOT LIKE '%GENERATED%'
          AND (
                ( ( c.COLUMN_NAME = 'id' OR c.COLUMN_NAME LIKE 'id\_%' OR c.COLUMN_NAME LIKE '%\_id\_%' ) AND c.DATA_TYPE IN ( 'int', 'mediumint', 'smallint' ) )
             OR ( c.COLUMN_NAME LIKE 'se\_%' AND c.DATA_TYPE IN ( 'int', 'mediumint', 'smallint', 'bigint' ) )
             OR ( c.TABLE_NAME = 'recensioni' AND c.DATA_TYPE = 'char'
                  AND c.COLUMN_NAME IN ( 'id_categoria_prodotti', 'id_categoria_notizie', 'id_notizia' )
                  AND c.COLUMN_NAME NOT IN ( SELECT `colonna` FROM `__tipi_canonici_salta__` ) )
          );

        -- fine si alza anche quando la SELECT qui sopra non trova niente
        SET fine = 0;

        IF v_numero > 0 THEN
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                    BEGIN
                        GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                        SET errore = 1;
                    END;
                SET errore = 0;
                SET foreign_key_checks = 0;
                PREPARE modifica FROM @tipi_canonici_sql;
                EXECUTE modifica;
                DEALLOCATE PREPARE modifica;
                SET foreign_key_checks = @tipi_canonici_controlli;
                IF errore = 1 THEN
                    SET @tipi_canonici_note = CONCAT_WS( '\n', @tipi_canonici_note, LEFT( CONCAT( v_tabella, ': ', messaggio ), 255 ) );
                ELSE
                    SET @tipi_canonici_tabelle = @tipi_canonici_tabelle + 1, @tipi_canonici_colonne = @tipi_canonici_colonne + v_numero;
                END IF;
            END;
        END IF;

    END LOOP;

    CLOSE lista;

    -- rimetto le chiavi tolte, identiche; quelle che non rientrano vanno nella nota
    SET v_i = 1;
    WHILE v_i <= v_chiavi_tabelle DO
        IF ( SELECT `tolte` FROM `__tipi_canonici_fk__` WHERE `numero` = v_i ) = 1 THEN
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                    BEGIN
                        GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                        SET errore = 1;
                    END;
                SET errore = 0;
                SELECT `metti`, `tabella` INTO @tipi_canonici_sql, v_tabella FROM `__tipi_canonici_fk__` WHERE `numero` = v_i;
                SET foreign_key_checks = 0;
                PREPARE metti FROM @tipi_canonici_sql;
                EXECUTE metti;
                DEALLOCATE PREPARE metti;
                SET foreign_key_checks = @tipi_canonici_controlli;
                IF errore = 1 THEN
                    SET @tipi_canonici_note = CONCAT_WS( '\n', @tipi_canonici_note, LEFT( CONCAT( v_tabella, ', chiavi NON rimesse: ', messaggio, ' | ', @tipi_canonici_sql ), 1000 ) );
                ELSE
                    SET @tipi_canonici_chiavi_rimesse = @tipi_canonici_chiavi_rimesse + ( SELECT `chiavi` FROM `__tipi_canonici_fk__` WHERE `numero` = v_i );
                END IF;
            END;
        END IF;
        SET v_i = v_i + 1;
    END WHILE;

    DROP TEMPORARY TABLE IF EXISTS `__tipi_canonici_salta__`;
    DROP TEMPORARY TABLE IF EXISTS `__tipi_canonici_int__`;
    DROP TEMPORARY TABLE IF EXISTS `__tipi_canonici_kcu__`;
    DROP TEMPORARY TABLE IF EXISTS `__tipi_canonici_regole__`;
    DROP TEMPORARY TABLE IF EXISTS `__tipi_canonici_chiave__`;
    DROP TEMPORARY TABLE IF EXISTS `__tipi_canonici_fk__`;
    SET foreign_key_checks = @tipi_canonici_controlli;

END;

-- | 202610021501

-- si esegue su tutte le tabelle
CALL `__patch_tipi_canonici__`( '%' );

-- | 202610021502

-- cosa è stato convertito, e cosa no: lo legge chi applica la patch a mano
SELECT @tipi_canonici_tabelle AS tabelle, @tipi_canonici_colonne AS colonne,
    @tipi_canonici_chiavi_tolte AS chiavi_tolte, @tipi_canonici_chiavi_rimesse AS chiavi_rimesse, @tipi_canonici_note AS nota;

-- | 202610021503

-- si libera la procedura
DROP PROCEDURE IF EXISTS `__patch_tipi_canonici__`;

-- | FINE
