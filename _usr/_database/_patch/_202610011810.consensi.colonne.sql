-- 2026-10-01 — consensi: codice NOT NULL e id AUTO_INCREMENT, come nei file di base
--
-- COSA SI VEDEVA. Nei file di base consensi.codice e' NOT NULL, ma _202609301700.consensi.sql lo aggiunge facoltativo
-- ai deploy che non l'avevano, e consensi.id non aveva AUTO_INCREMENT da nessuna parte ( _202609301900.id.numerici.sql
-- lo lascia fuori apposta ): un consenso aggiunto dal pannello senza id e senza codice non entrava, o entrava senza il
-- codice con cui il framework lo cerca.
--
-- COSA FA, solo dove consensi.id e' numerico ( dove e' ancora testuale lo dice la nota e non tocca niente ):
--
-- -# alle righe senza codice ne da' uno ricavato dal nome ( maiuscolo, con _ al posto di spazi e simboli, come
--    INVIO_COMUNICAZIONI_MARKETING ), o CONSENSO_<id> se manca anche il nome; se il codice c'e' gia', o lo ricava
--    anche una riga con id piu' basso, gli aggiunge _<id> ( il codice ricavato si ferma a 40 caratteri, perche' l'id
--    in coda stia nei 64 della colonna );
-- -# porta codice a NOT NULL, se non restano righe senza codice;
-- -# mette AUTO_INCREMENT su id, col tipo che ha, con NO_AUTO_VALUE_ON_ZERO perche' una riga con id 0 ( i dati del
--    26/03 che _202609301700 non ha potuto spostare ) resti 0 e non prenda un id nuovo lasciando orfane le righe che
--    la citano.
--
-- Le ALTER girano con foreign_key_checks a 0: id e' citato dalle chiavi esterne di consensi_moduli,
-- anagrafica_consensi, carrelli_consensi e delle altre, e il tipo non cambia. Quello che non fa va in @consensi_note,
-- restituita in fondo.
--
-- IDEMPOTENTE: una seconda esecuzione trova le colonne gia' allineate e non fa niente.

-- | 202610011810

CREATE OR REPLACE PROCEDURE `__patch_consensi_colonne__`()
BEGIN

    DECLARE errore INT DEFAULT 0;
    DECLARE messaggio TEXT CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE v_tipo VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE v_colonna VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE v_extra VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE v_nullo VARCHAR(8) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE v_vuote INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
            SET errore = 1;
        END;

    SET @consensi_note = NULL;

    SELECT DATA_TYPE, COLUMN_TYPE, EXTRA INTO v_tipo, v_colonna, v_extra FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'consensi' AND COLUMN_NAME = 'id' LIMIT 1;
    SELECT IS_NULLABLE INTO v_nullo FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'consensi' AND COLUMN_NAME = 'codice' LIMIT 1;

    IF v_tipo IS NULL OR v_nullo IS NULL THEN
        SET @consensi_note = 'consensi: manca la tabella o la colonna codice, lasciata com''era';
    ELSEIF v_tipo NOT IN ( 'int', 'bigint', 'mediumint', 'smallint', 'tinyint' ) THEN
        SET @consensi_note = CONCAT( 'consensi: id e'' ancora ', v_tipo, ', lasciata com''era ( va prima _202609301900.id.numerici.sql )' );
    ELSE

        -- i codici che mancano, dal nome; se il codice c'e' gia', o lo prende anche una riga con id piu' basso, in
        -- coda va l'id ( in una tabella di lavoro, perche' l'UPDATE non puo' leggere la tabella che scrive )
        DROP TABLE IF EXISTS `__consensi_codici__`;
        CREATE TABLE `__consensi_codici__` ( `id` bigint(20) NOT NULL PRIMARY KEY, `codice` char(64) NOT NULL, KEY `codice` (`codice`) )
            ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
        INSERT INTO `__consensi_codici__` ( `id`, `codice` )
            SELECT `id`, LEFT( COALESCE(
                NULLIF( TRIM( BOTH '_' FROM UPPER( REGEXP_REPLACE( `nome`, '[^A-Za-z0-9]+', '_' ) ) ), '' ),
                CONCAT( 'CONSENSO_', `id` ) ), 40 )
            FROM `consensi` WHERE `codice` IS NULL OR `codice` = '';
        UPDATE `consensi` AS c INNER JOIN `__consensi_codici__` AS n ON n.`id` = c.`id`
            SET c.`codice` = IF(
                EXISTS ( SELECT 1 FROM ( SELECT `codice` FROM `consensi` WHERE `codice` <> '' ) AS e
                    WHERE CONVERT( e.`codice` USING utf8 ) COLLATE utf8_general_ci = n.`codice` )
                OR EXISTS ( SELECT 1 FROM `__consensi_codici__` AS m WHERE m.`codice` = n.`codice` AND m.`id` < n.`id` ),
                CONCAT( n.`codice`, '_', n.`id` ), n.`codice` );
        DROP TABLE IF EXISTS `__consensi_codici__`;

        SELECT count(*) INTO v_vuote FROM `consensi` WHERE `codice` IS NULL OR `codice` = '';

        SET @consensi_controlli = @@foreign_key_checks;
        SET @consensi_modo = @@sql_mode;
        SET foreign_key_checks = 0;

        IF v_nullo = 'YES' THEN
            IF v_vuote > 0 THEN
                SET @consensi_note = CONCAT_WS( '\n', @consensi_note, CONCAT( 'consensi.codice: ', v_vuote, ' righe ancora senza codice, la colonna resta facoltativa' ) );
            ELSE
                SET errore = 0;
                ALTER TABLE `consensi` MODIFY `codice` char(64) NOT NULL;
                IF errore = 1 THEN
                    SET @consensi_note = CONCAT_WS( '\n', @consensi_note, CONCAT( 'consensi.codice: ', messaggio ) );
                END IF;
            END IF;
        END IF;

        IF v_extra NOT LIKE '%auto_increment%' THEN
            SET errore = 0;
            SET sql_mode = CONCAT_WS( ',', NULLIF( @@sql_mode, '' ), 'NO_AUTO_VALUE_ON_ZERO' );
            SET @consensi_sql = CONCAT( 'ALTER TABLE `consensi` MODIFY `id` ', v_colonna, ' NOT NULL AUTO_INCREMENT' );
            PREPARE metti FROM @consensi_sql;
            EXECUTE metti;
            DEALLOCATE PREPARE metti;
            SET sql_mode = @consensi_modo;
            IF errore = 1 THEN
                SET @consensi_note = CONCAT_WS( '\n', @consensi_note, CONCAT( 'consensi.id: ', messaggio ) );
            END IF;
        END IF;

        SET foreign_key_checks = @consensi_controlli;

    END IF;

END;

-- | 202610011811

CALL `__patch_consensi_colonne__`();

-- | 202610011812

DROP PROCEDURE IF EXISTS `__patch_consensi_colonne__`;

-- | 202610011813

SELECT @consensi_note AS nota;

-- | FINE FILE
