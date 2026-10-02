-- 2026-10-02 — le due chiavi esterne di audio che i file di base tenevano commentate
--
-- COSA SI VEDEVA. Nel commit 1ccd0213a del 25/09/2026 audio e' stata rimessa nello schema sul modello di video, ma
-- audio_ibfk_08 ( id_categoria_risorse -> categorie_risorse ) e audio_ibfk_21 ( id_valutazione -> valutazioni ) sono
-- rimaste commentate, senza una ragione scritta, mentre su video, immagini e file le stesse sono attive. Per questo
-- _202610021700.chiavi.esterne.canone.sql non le porta.
--
-- COSA FA. Le aggiunge con la stessa procedura di _202610021700 ( e di _202609301100 ): solo se sulla colonna non
-- c'e' gia' un vincolo, i tipi coincidono e non ci sono righe orfane; altrimenti lo scrive nella nota finale.
--
-- IDEMPOTENTE.

-- | 202610022900

-- la lista di lavoro: una riga per vincolo, con l'esito che la procedura scrive accanto
CREATE TABLE IF NOT EXISTS `__patch_chiavi_audio__` (
  `tabella` char(64) NOT NULL,
  `vincolo` char(64) NOT NULL,
  `colonna` char(64) NOT NULL,
  `riferimento` char(64) NOT NULL,
  `cancellazione` char(16) NOT NULL,
  `aggiornamento` char(16) NOT NULL,
  `condizione` char(128) DEFAULT NULL,
  `vecchio_nome` varchar(64) DEFAULT NULL,
  `vecchia_cancellazione` char(16) DEFAULT NULL,
  `vecchio_aggiornamento` char(16) DEFAULT NULL,
  `esito` char(255) DEFAULT NULL,
  PRIMARY KEY (`tabella`,`vincolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202610022901

-- i vincoli del canone, parte 1 di 1
INSERT IGNORE INTO `__patch_chiavi_audio__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione` ) VALUES
( 'audio', 'audio_ibfk_08', 'id_categoria_risorse', 'categorie_risorse', 'SET NULL', 'SET NULL', NULL ),
( 'audio', 'audio_ibfk_21', 'id_valutazione', 'valutazioni', 'SET NULL', 'SET NULL', NULL );

-- | 202610022902

-- la procedura che scorre la lista e aggiunge i vincoli che si possono aggiungere ( la stessa di _202609301100 )
CREATE OR REPLACE PROCEDURE `__patch_chiavi_audio__`()
BEGIN

    DECLARE fine INT DEFAULT 0;
    DECLARE errore INT DEFAULT 0;
    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE v_tabella, v_vincolo, v_colonna, v_riferimento CHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_cancellazione, v_aggiornamento CHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_condizione CHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_tipo_figlia, v_tipo_padre, v_nullabile CHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_esito CHAR(255) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_indice TEXT DEFAULT NULL;
    DECLARE v_vecchio_nome VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_vecchia_cancellazione, v_vecchio_aggiornamento CHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_da_correggere VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;

    DECLARE lista CURSOR FOR
        SELECT `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `condizione`,
            `vecchio_nome`, `vecchia_cancellazione`, `vecchio_aggiornamento`
        FROM `__patch_chiavi_audio__`
        WHERE `esito` IS NULL
        ORDER BY `tabella`, `vincolo`;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fine = 1;

    SET @chiavi_audio_controlli = @@foreign_key_checks;
    SET @chiavi_audio_aggiunte = 0;
    SET @chiavi_audio_corrette = 0;
    SET @chiavi_audio_note = NULL;

    OPEN lista;

    ciclo: LOOP

        FETCH lista INTO v_tabella, v_vincolo, v_colonna, v_riferimento, v_cancellazione, v_aggiornamento, v_condizione,
            v_vecchio_nome, v_vecchia_cancellazione, v_vecchio_aggiornamento;
        IF fine = 1 THEN
            LEAVE ciclo;
        END IF;

        SET v_esito = NULL, v_tipo_figlia = NULL, v_tipo_padre = NULL, v_nullabile = NULL, v_indice = NULL, v_da_correggere = NULL;

        -- i vincoli da correggere: si correggono solo se sul deploy sono ancora esattamente quelli di prima
        IF v_vecchio_nome IS NOT NULL THEN
            SELECT k.CONSTRAINT_NAME INTO v_da_correggere
                FROM information_schema.KEY_COLUMN_USAGE AS k
                INNER JOIN information_schema.REFERENTIAL_CONSTRAINTS AS r
                    ON r.CONSTRAINT_SCHEMA = k.CONSTRAINT_SCHEMA AND r.CONSTRAINT_NAME = k.CONSTRAINT_NAME AND r.TABLE_NAME = k.TABLE_NAME
                WHERE k.TABLE_SCHEMA = database() AND k.TABLE_NAME = v_tabella AND k.COLUMN_NAME = v_colonna
                  AND k.REFERENCED_TABLE_NAME = v_riferimento
                  AND BINARY k.CONSTRAINT_NAME = BINARY v_vecchio_nome
                  AND r.DELETE_RULE = v_vecchia_cancellazione AND r.UPDATE_RULE = v_vecchio_aggiornamento
                LIMIT 1;
        END IF;

        SELECT COLUMN_TYPE, IS_NULLABLE INTO v_tipo_figlia, v_nullabile
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna
            LIMIT 1;

        SELECT COLUMN_TYPE INTO v_tipo_padre
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_riferimento AND COLUMN_NAME = 'id'
            LIMIT 1;

        -- fine si alza anche quando una delle due SELECT qui sopra non trova niente
        SET fine = 0;

        IF v_da_correggere IS NOT NULL THEN
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                    BEGIN
                        GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                        SET errore = 1;
                    END;
                SET errore = 0;
                SET foreign_key_checks = 0;
                SET @chiavi_audio_sql = CONCAT( 'ALTER TABLE `', v_tabella, '` DROP FOREIGN KEY `', v_da_correggere, '`' );
                PREPARE togli FROM @chiavi_audio_sql;
                EXECUTE togli;
                DEALLOCATE PREPARE togli;
                IF errore = 0 THEN
                    SET @chiavi_audio_sql = CONCAT(
                        'ALTER TABLE `', v_tabella, '` ADD CONSTRAINT `', v_vincolo, '` FOREIGN KEY (`', v_colonna, '`) ',
                        'REFERENCES `', v_riferimento, '` (`id`) ON DELETE ', v_cancellazione, ' ON UPDATE ', v_aggiornamento
                    );
                    PREPARE metti FROM @chiavi_audio_sql;
                    EXECUTE metti;
                    DEALLOCATE PREPARE metti;
                    IF errore = 1 THEN
                        -- se la nuova non entra si rimette la vecchia, cosi' la colonna non resta senza vincolo
                        SET @chiavi_audio_sql = CONCAT(
                            'ALTER TABLE `', v_tabella, '` ADD CONSTRAINT `', v_da_correggere, '` FOREIGN KEY (`', v_colonna, '`) ',
                            'REFERENCES `', v_riferimento, '` (`id`) ON DELETE ', v_vecchia_cancellazione, ' ON UPDATE ', v_vecchio_aggiornamento
                        );
                        PREPARE metti FROM @chiavi_audio_sql;
                        EXECUTE metti;
                        DEALLOCATE PREPARE metti;
                        SET v_esito = LEFT( CONCAT( 'correzione fallita, rimesso il vincolo di prima: ', messaggio ), 255 );
                    ELSE
                        SET v_esito = 'corretto', @chiavi_audio_corrette = @chiavi_audio_corrette + 1;
                    END IF;
                ELSE
                    SET v_esito = LEFT( CONCAT( 'correzione fallita: ', messaggio ), 255 );
                END IF;
                SET foreign_key_checks = @chiavi_audio_controlli;
            END;
        ELSEIF v_tipo_figlia IS NULL THEN
            SET v_esito = CONCAT( 'non esiste ', v_tabella, '.', v_colonna );
        ELSEIF v_tipo_padre IS NULL THEN
            SET v_esito = CONCAT( 'non esiste ', v_riferimento, '.id' );
        ELSEIF EXISTS (
            SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna
              AND REFERENCED_TABLE_NAME IS NOT NULL
        ) THEN
            SET v_esito = 'presente';
        ELSEIF v_condizione IS NOT NULL AND NOT EXISTS (
            SELECT 1 FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database()
              AND TABLE_NAME = SUBSTRING_INDEX( v_condizione, '.', 1 )
              AND COLUMN_NAME = SUBSTRING_INDEX( v_condizione, '.', -1 )
        ) THEN
            SET v_esito = CONCAT( 'manca ', v_condizione, ', da cui il vincolo dipende' );
        ELSEIF EXISTS (
            SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
            WHERE CONSTRAINT_SCHEMA = database() AND CONSTRAINT_NAME = v_vincolo
        ) THEN
            SET v_esito = 'il nome e'' gia'' usato da un altro vincolo';
        ELSEIF NOT EXISTS (
            SELECT 1 FROM information_schema.STATISTICS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_riferimento AND COLUMN_NAME = 'id'
              AND SEQ_IN_INDEX = 1 AND NON_UNIQUE = 0
        ) THEN
            SET v_esito = CONCAT( v_riferimento, '.id non e'' una chiave' );
        ELSEIF v_tipo_figlia <> v_tipo_padre THEN
            SET v_esito = CONCAT( 'tipi diversi, ', v_tabella, '.', v_colonna, ' ', v_tipo_figlia, ' e ', v_riferimento, '.id ', v_tipo_padre );
        ELSEIF v_cancellazione = 'SET NULL' AND v_nullabile = 'NO' THEN
            SET v_esito = CONCAT( v_tabella, '.', v_colonna, ' e'' NOT NULL e il vincolo e'' ON DELETE SET NULL' );
        END IF;

        -- righe orfane
        IF v_esito IS NULL THEN
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                    BEGIN
                        GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                        SET errore = 1;
                    END;
                SET errore = 0, @chiavi_audio_orfani = NULL;
                SET @chiavi_audio_sql = CONCAT(
                    'SELECT count(*) INTO @chiavi_audio_orfani FROM `', v_tabella, '` AS figlie ',
                    'LEFT JOIN `', v_riferimento, '` AS padri ON padri.id = figlie.`', v_colonna, '` ',
                    'WHERE figlie.`', v_colonna, '` IS NOT NULL AND padri.id IS NULL'
                );
                PREPARE controllo FROM @chiavi_audio_sql;
                EXECUTE controllo;
                DEALLOCATE PREPARE controllo;
                IF errore = 1 THEN
                    SET v_esito = LEFT( CONCAT( 'controllo delle righe orfane fallito: ', messaggio ), 255 );
                ELSEIF @chiavi_audio_orfani > 0 THEN
                    SET v_esito = CONCAT( @chiavi_audio_orfani, ' righe di ', v_tabella, ' con un ', v_colonna, ' che non esiste in ', v_riferimento );
                END IF;
            END;
        END IF;

        -- il vincolo, con il suo indice se la colonna non ne ha uno
        IF v_esito IS NULL THEN
            IF NOT EXISTS (
                SELECT 1 FROM information_schema.STATISTICS
                WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna AND SEQ_IN_INDEX = 1
            ) AND NOT EXISTS (
                SELECT 1 FROM information_schema.STATISTICS
                WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND INDEX_NAME = v_colonna
            ) THEN
                SET v_indice = CONCAT( 'ADD KEY `', v_colonna, '` (`', v_colonna, '`), ' );
            END IF;
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                    BEGIN
                        GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                        SET errore = 1;
                    END;
                SET errore = 0;
                SET @chiavi_audio_sql = CONCAT(
                    'ALTER TABLE `', v_tabella, '` ', IFNULL( v_indice, '' ),
                    'ADD CONSTRAINT `', v_vincolo, '` FOREIGN KEY (`', v_colonna, '`) REFERENCES `', v_riferimento, '` (`id`) ',
                    'ON DELETE ', v_cancellazione, ' ON UPDATE ', v_aggiornamento
                );
                SET foreign_key_checks = 0;
                PREPARE aggiunta FROM @chiavi_audio_sql;
                EXECUTE aggiunta;
                DEALLOCATE PREPARE aggiunta;
                SET foreign_key_checks = @chiavi_audio_controlli;
                IF errore = 1 THEN
                    SET v_esito = LEFT( CONCAT( 'ALTER TABLE fallita: ', messaggio ), 255 );
                ELSE
                    SET v_esito = 'aggiunto', @chiavi_audio_aggiunte = @chiavi_audio_aggiunte + 1;
                END IF;
            END;
        END IF;

        UPDATE `__patch_chiavi_audio__` SET `esito` = v_esito
            WHERE `tabella` = v_tabella AND `vincolo` = v_vincolo;

        IF v_esito NOT IN ( 'presente', 'aggiunto', 'corretto' ) THEN
            SET @chiavi_audio_note = CONCAT_WS( '\n', @chiavi_audio_note, CONCAT( v_vincolo, ': ', v_esito ) );
        END IF;

    END LOOP;

    CLOSE lista;

    SET foreign_key_checks = @chiavi_audio_controlli;

END;

-- | 202610022903

-- si esegue
CALL `__patch_chiavi_audio__`();

-- | 202610022904

-- quello che non e' stato aggiunto, e perche': lo legge chi applica la patch a mano
SELECT @chiavi_audio_aggiunte AS aggiunte, @chiavi_audio_corrette AS corrette, @chiavi_audio_note AS nota;

-- | 202610022905

DROP PROCEDURE IF EXISTS `__patch_chiavi_audio__`;

-- | 202610022906

-- e la lista di lavoro
DROP TABLE IF EXISTS `__patch_chiavi_audio__`;

-- | FINE
