-- 2026-10-01 — orari_ibfk_01 cancella in cascata, relazioni_articoli_ibfk_02 diventa _nofollow
--
-- COSA SI VEDEVA. orari_ibfk_01 ( orari.id_tipologia_contratti -> tipologie_contratti ) era ON DELETE NO ACTION: orari
-- e' la tabella secondaria degli orari di accesso di una tipologia di abbonamento, e per il canone delle tabelle
-- secondarie ( 300.database.md ) le sue righe se ne vanno con la principale; invece la tipologia non si poteva
-- cancellare finche' aveva degli orari. Il vincolo resta seguito, perche' il form delle tipologie di abbonamento mostra
-- gli orari dal blocco dati.
--
-- relazioni_articoli_ibfk_02 ( relazioni_articoli.id_articolo_collegato -> articoli ) era seguito: aprendo un articolo
-- controller() caricava nel sotto-elenco delle relazioni anche quelle in cui l'articolo e' il collegato, e il
-- sotto-elenco ( articoli.form.relazioni.html e catalogo.articoli.form.relazioni.twig ) le mostra come se l'articolo
-- fosse il principale, perche' legge id_articolo. Il lato proprietario e' relazioni_articoli_ibfk_01 ( id_articolo );
-- relazioni_articoli_ibfk_04 ( id_prodotto_collegato ) resta seguito, perche' la scheda relazioni dei prodotti mostra
-- quel sotto-elenco.
--
-- COSA FA. Per ciascuno dei due vincoli, se c'e' col vecchio nome o col nuovo e non e' gia' come deve essere: lo toglie
-- e lo rimette col nome e le regole nuove, sulla stessa colonna e verso la stessa tabella; se il nuovo non entra
-- rimette quello di prima. Le ALTER girano con foreign_key_checks a 0 ( i dati non cambiano ). Quello che non fa va in
-- @vincoli_note, restituita in fondo. Dopo la patch va svuotata memcache, perche' controller() legge le chiavi
-- esterne con mysqlCachedQuery().
--
-- IDEMPOTENTE: una seconda esecuzione trova i vincoli gia' come devono essere e non fa niente.

-- | 202610011800

-- la procedura che rimette un vincolo col nome e le regole volute ( NULL = la regola che ha )
CREATE OR REPLACE PROCEDURE `__patch_vincolo__`(
    IN tabella VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
    IN vecchio VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
    IN nuovo VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci,
    IN cancellazione VARCHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci,
    IN aggiornamento VARCHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci
)
BEGIN

    DECLARE errore INT DEFAULT 0;
    DECLARE messaggio TEXT CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE v_nome, v_colonna, v_riferimento VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE v_cancellazione, v_aggiornamento VARCHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
            SET errore = 1;
        END;

    SELECT k.CONSTRAINT_NAME, k.COLUMN_NAME, k.REFERENCED_TABLE_NAME, r.DELETE_RULE, r.UPDATE_RULE
        INTO v_nome, v_colonna, v_riferimento, v_cancellazione, v_aggiornamento
        FROM information_schema.KEY_COLUMN_USAGE AS k
        INNER JOIN information_schema.REFERENTIAL_CONSTRAINTS AS r
            ON r.CONSTRAINT_SCHEMA = k.CONSTRAINT_SCHEMA AND r.CONSTRAINT_NAME = k.CONSTRAINT_NAME AND r.TABLE_NAME = k.TABLE_NAME
        WHERE k.TABLE_SCHEMA = database() AND k.TABLE_NAME = tabella
          AND ( BINARY k.CONSTRAINT_NAME = BINARY nuovo OR BINARY k.CONSTRAINT_NAME = BINARY vecchio )
          AND k.REFERENCED_TABLE_NAME IS NOT NULL
        ORDER BY BINARY k.CONSTRAINT_NAME = BINARY nuovo DESC
        LIMIT 1;

    SET cancellazione = COALESCE( cancellazione, v_cancellazione );
    SET aggiornamento = COALESCE( aggiornamento, v_aggiornamento );
    SET @vincoli_controlli = @@foreign_key_checks;

    IF v_nome IS NULL THEN
        SET messaggio = 'non c''e'' ne'' col vecchio nome ne'' col nuovo: lasciato com''era';
    ELSEIF BINARY v_nome = BINARY nuovo AND v_cancellazione = cancellazione AND v_aggiornamento = aggiornamento THEN
        -- gia' come deve essere
        SET messaggio = NULL;
    ELSEIF BINARY v_nome <> BINARY nuovo AND EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE CONSTRAINT_SCHEMA = database() AND CONSTRAINT_NAME = nuovo
    ) THEN
        SET messaggio = CONCAT( 'il nome ', nuovo, ' e'' gia'' usato da un altro vincolo: ', v_nome, ' lasciato' );
    ELSE
        SET foreign_key_checks = 0;
        SET @vincoli_sql = CONCAT( 'ALTER TABLE `', tabella, '` DROP FOREIGN KEY `', v_nome, '`' );
        PREPARE togli FROM @vincoli_sql;
        EXECUTE togli;
        DEALLOCATE PREPARE togli;
        IF errore = 0 THEN
            SET @vincoli_sql = CONCAT(
                'ALTER TABLE `', tabella, '` ADD CONSTRAINT `', nuovo, '` FOREIGN KEY (`', v_colonna, '`) ',
                'REFERENCES `', v_riferimento, '` (`id`) ON DELETE ', cancellazione, ' ON UPDATE ', aggiornamento
            );
            PREPARE metti FROM @vincoli_sql;
            EXECUTE metti;
            DEALLOCATE PREPARE metti;
            IF errore = 1 THEN
                -- se il nuovo non entra si rimette quello di prima, cosi' la colonna non resta senza vincolo
                SET @vincoli_sql = CONCAT(
                    'ALTER TABLE `', tabella, '` ADD CONSTRAINT `', v_nome, '` FOREIGN KEY (`', v_colonna, '`) ',
                    'REFERENCES `', v_riferimento, '` (`id`) ON DELETE ', v_cancellazione, ' ON UPDATE ', v_aggiornamento
                );
                PREPARE metti FROM @vincoli_sql;
                EXECUTE metti;
                DEALLOCATE PREPARE metti;
                SET messaggio = CONCAT( 'modifica fallita, rimesso il vincolo di prima: ', messaggio );
            ELSE
                SET messaggio = NULL;
            END IF;
        ELSE
            SET messaggio = CONCAT( 'modifica fallita: ', messaggio );
        END IF;
        SET foreign_key_checks = @vincoli_controlli;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @vincoli_note = CONCAT_WS( '\n', @vincoli_note, CONCAT( tabella, '.', vecchio, ': ', messaggio ) );
    END IF;

END;

-- | 202610011801

-- orari.id_tipologia_contratti -> tipologie_contratti, seguito, in cascata
CALL `__patch_vincolo__`( 'orari', 'orari_ibfk_01', 'orari_ibfk_01', 'CASCADE', 'CASCADE' );

-- | 202610011802

-- relazioni_articoli.id_articolo_collegato -> articoli, non seguito, con le regole che ha
CALL `__patch_vincolo__`( 'relazioni_articoli', 'relazioni_articoli_ibfk_02', 'relazioni_articoli_ibfk_02_nofollow', NULL, NULL );

-- | 202610011803

DROP PROCEDURE IF EXISTS `__patch_vincolo__`;

-- | 202610011804

SELECT @vincoli_note AS nota;

-- | FINE FILE
