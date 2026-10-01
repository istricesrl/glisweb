-- 2026-10-01 — un albero solo delle caratteristiche: caratteristiche_prodotti confluisce in caratteristiche
--
-- COSA SI VEDEVA. Le caratteristiche stavano in due tabelle. caratteristiche era quella dei file di base, piatta nei
-- fatti anche se aveva id_genitore, e la usavano il modulo PR000.prodotti, gli immobili e i contenuti;
-- caratteristiche_prodotti era l'albero vero ( gruppi e caratteristiche ) che usavano il modulo 4100.prodotti e i
-- progetti, con le importazioni e le stampe. Le chiavi esterne di articoli_caratteristiche e prodotti_caratteristiche
-- puntavano a caratteristiche nei file di base e a caratteristiche_prodotti sui deploy che usano l'albero, per cui su
-- un'installazione nuova le schede del 4100 proponevano caratteristiche che il database rifiutava.
--
-- COSA FA. L'albero e' caratteristiche: ha l'indice e la chiave esterna su id_genitore, e l'indice unico
-- ( nome, id_genitore ). Dove caratteristiche_prodotti e' una tabella con dei nodi:
--
-- -# ogni nodo viene copiato in caratteristiche con id = id di prima + lo scostamento ( il massimo id di
--    caratteristiche ), e il genitore spostato dello stesso scostamento: l'albero resta com'era, senza fondere nodi
--    con lo stesso nome, cosi' nessun indice unico puo' scontrarsi; i flag passano da se_categoria, se_prodotto e
--    se_articolo a se_categorie_prodotti, se_prodotti e se_articoli;
-- -# in articoli_caratteristiche e prodotti_caratteristiche si spostano dello scostamento i riferimenti, ma solo
--    nelle tabelle la cui chiave esterna su id_caratteristica puntava a caratteristiche_prodotti. Se la chiave puntava
--    a caratteristiche i riferimenti restano; se non c'era nessuna chiave non si puo' sapere a quale tabella si
--    riferiscano, e la tabella resta com'e' ( lo dice la nota );
-- -# la tabella viene rinominata caratteristiche_prodotti_migrata, come copia, e al suo posto c'e' la vista
--    caratteristiche_prodotti con i nomi di colonna di prima, su cui si puo' anche scrivere: il codice dei progetti
--    che la legge o ci fa INSERT ... ON DUPLICATE KEY UPDATE continua a funzionare.
--
-- Poi le chiavi esterne di articoli_caratteristiche e prodotti_caratteristiche puntano a caratteristiche, se non ci
-- sono righe orfane. Quello che non si e' potuto fare va in @caratteristiche_note, restituita in fondo.
--
-- ⚠ DA LANCIARE A SITO FERMO e con un backup: sui deploy che usano l'albero cambia gli id delle caratteristiche.
--
-- COLLATION. Le variabili di testo della procedura sono utf8_general_ci come information_schema, perche' su un
-- database utf8_unicode_ci i confronti non si fermino con 1267 ( come in _202609301900.id.numerici.sql ).
--
-- IDEMPOTENTE. La migrazione parte solo se caratteristiche_prodotti e' ancora una tabella; dopo e' una vista, e una
-- seconda esecuzione rifa' solo indici, chiavi e viste uguali.

-- | 202610011700

CREATE OR REPLACE PROCEDURE `__patch_caratteristiche__`()
BEGIN

    DECLARE tipo VARCHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE scostamento BIGINT DEFAULT 0;
    DECLARE fatto INT DEFAULT 0;
    DECLARE tabella VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE chiave VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE puntava VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE contatore INT;
    DECLARE fine INT DEFAULT 0;
    DECLARE ambigue TEXT CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '';
    DECLARE tipo_id VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE tipo_genitore VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE tipo_colonna VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE nullabile VARCHAR(3) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE indice VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE figlie CURSOR FOR
        SELECT t.nome FROM ( SELECT 'articoli_caratteristiche' AS nome UNION ALL SELECT 'prodotti_caratteristiche' ) AS t
        WHERE EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = t.nome );
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fine = 1;

    SET @caratteristiche_note = NULL;
    SET ambigue = '';

    -- l'indice su id_genitore, che serve alla chiave esterna
    IF NOT EXISTS ( SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'caratteristiche' AND INDEX_NAME = 'id_genitore' ) THEN
        ALTER TABLE `caratteristiche` ADD KEY `id_genitore` (`id_genitore`);
    END IF;

    SELECT TABLE_TYPE INTO tipo FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'caratteristiche_prodotti';

    -- migrazione dell'albero, se caratteristiche_prodotti e' ancora una tabella
    IF tipo = 'BASE TABLE' THEN

        SELECT coalesce( max( id ), 0 ) INTO scostamento FROM caratteristiche;

        -- il vecchio indice unico sul solo nome ( p.es. `unica` ) rifiuterebbe i nodi dell'albero che si chiamano come una
        -- caratteristica piatta: al suo posto arriva piu' sotto ( nome, id_genitore )
        SELECT INDEX_NAME INTO indice FROM information_schema.STATISTICS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'caratteristiche' AND NON_UNIQUE = 0 AND INDEX_NAME != 'PRIMARY'
            GROUP BY INDEX_NAME HAVING GROUP_CONCAT( COLUMN_NAME ) = 'nome' LIMIT 1;
        SET fine = 0;
        IF indice IS NOT NULL THEN
            SET @sql = CONCAT( 'ALTER TABLE `caratteristiche` DROP INDEX `', indice, '`' );
            PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
            SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, CONCAT( 'tolto l\'indice unico ', indice, ' ( nome ) di caratteristiche' ) );
        END IF;

        -- i genitori che non esistono piu' diventerebbero chiavi esterne orfane: quei nodi diventano radici
        UPDATE caratteristiche_prodotti AS c LEFT JOIN caratteristiche_prodotti AS g ON g.id = c.id_genitore
            SET c.id_genitore = NULL WHERE c.id_genitore IS NOT NULL AND g.id IS NULL;
        SET fatto = ROW_COUNT();
        IF fatto > 0 THEN
            SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, CONCAT( fatto, ' nodi di caratteristiche_prodotti avevano un genitore inesistente e sono diventati radici' ) );
        END IF;

        -- i nodi, con lo scostamento; prima i genitori di tutti, poi la chiave esterna
        INSERT INTO caratteristiche ( id, id_genitore, nome, font_awesome, html_entity, se_categorie_prodotti, se_prodotti, se_articoli,
                id_account_inserimento, timestamp_inserimento, id_account_aggiornamento, timestamp_aggiornamento )
            SELECT id + scostamento, IF( id_genitore IS NULL, NULL, id_genitore + scostamento ), nome, font_awesome, html_entity,
                se_categoria, se_prodotto, se_articolo,
                id_account_inserimento, timestamp_inserimento, id_account_aggiornamento, timestamp_aggiornamento
            FROM caratteristiche_prodotti;
        SET fatto = ROW_COUNT();
        SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, CONCAT( fatto, ' nodi copiati da caratteristiche_prodotti, con id spostati di ', scostamento ) );

        -- i riferimenti, tabella per tabella, secondo dove puntava la chiave esterna
        SET fine = 0;
        OPEN figlie;
        giro: LOOP
            FETCH figlie INTO tabella;
            IF fine = 1 THEN LEAVE giro; END IF;
            SET chiave = NULL, puntava = NULL;
            SELECT k.CONSTRAINT_NAME, k.REFERENCED_TABLE_NAME INTO chiave, puntava
                FROM information_schema.KEY_COLUMN_USAGE AS k
                WHERE k.TABLE_SCHEMA = database() AND k.TABLE_NAME = tabella AND k.COLUMN_NAME = 'id_caratteristica'
                AND k.REFERENCED_TABLE_NAME IS NOT NULL LIMIT 1;
            SET fine = 0;
            IF puntava = 'caratteristiche_prodotti' THEN
                SET @sql = CONCAT( 'ALTER TABLE `', tabella, '` DROP FOREIGN KEY `', chiave, '`' );
                PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
                -- dal riferimento piu' alto in giu': spostando verso l'alto una riga non finisce mai, nemmeno per un momento,
                -- sugli stessi valori di una non ancora spostata, che l'indice unico ( articolo, caratteristica ) rifiuterebbe
                SET @sql = CONCAT( 'UPDATE `', tabella, '` SET id_caratteristica = id_caratteristica + ', scostamento, ' WHERE id_caratteristica IS NOT NULL ORDER BY id_caratteristica DESC' );
                PREPARE istruzione FROM @sql; EXECUTE istruzione; SET contatore = ROW_COUNT(); DEALLOCATE PREPARE istruzione;
                SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, CONCAT( tabella, ': ', contatore, ' riferimenti spostati sull\'albero nuovo' ) );
                -- la colonna prende il tipo di caratteristiche.id: fra int( 11 ) e bigint( 20 ) la chiave fallisce con errno 150
                SELECT COLUMN_TYPE INTO tipo_id FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'caratteristiche' AND COLUMN_NAME = 'id';
                SELECT COLUMN_TYPE, IS_NULLABLE INTO tipo_colonna, nullabile FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = tabella AND COLUMN_NAME = 'id_caratteristica';
                IF tipo_id IS NOT NULL AND tipo_colonna IS NOT NULL AND tipo_id != tipo_colonna THEN
                    SET @sql = CONCAT( 'ALTER TABLE `', tabella, '` MODIFY `id_caratteristica` ', tipo_id, IF( nullabile = 'NO', ' NOT NULL', ' DEFAULT NULL' ) );
                    PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
                    SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, CONCAT( tabella, '.id_caratteristica portato da ', tipo_colonna, ' a ', tipo_id, ', il tipo di caratteristiche.id' ) );
                END IF;
                SET @sql = CONCAT( 'ALTER TABLE `', tabella, '` ADD CONSTRAINT `', tabella, '_ibfk_02_nofollow` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE' );
                PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
            ELSEIF puntava IS NULL THEN
                -- senza chiave non si sa a quale tabella si riferiscano le righe; se ce ne sono, la tabella resta com'e' e
                -- senza chiave esterna, perche' aggiungerla verso caratteristiche deciderebbe in silenzio per la tabella piatta
                SET @righe = 0;
                SET @sql = CONCAT( 'SELECT count(*) INTO @righe FROM `', tabella, '` WHERE id_caratteristica IS NOT NULL' );
                PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
                IF @righe > 0 THEN
                    SET ambigue = CONCAT( ambigue, ',', tabella );
                    SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, CONCAT( tabella, ': nessuna chiave esterna su id_caratteristica, e ', @righe, ' righe che possono riferirsi a caratteristiche o a caratteristiche_prodotti; lasciate com\'erano e senza chiave: se erano all\'albero vanno spostate di ', scostamento, ', poi va aggiunta la chiave ', tabella, '_ibfk_02_nofollow' ) );
                END IF;
            END IF;
        END LOOP;
        CLOSE figlie;
        SET fine = 0;

        -- le chiavi esterne di altre tabelle verso caratteristiche_prodotti seguirebbero la copia rinominata
        SELECT count(*) INTO contatore FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = database() AND REFERENCED_TABLE_NAME = 'caratteristiche_prodotti' AND TABLE_NAME != 'caratteristiche_prodotti';
        IF contatore > 0 THEN
            SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, CONCAT( contatore, ' chiavi esterne di altre tabelle puntano a caratteristiche_prodotti: dopo la patch puntano a caratteristiche_prodotti_migrata e vanno portate su caratteristiche a mano' ) );
        END IF;

        -- la tabella resta come copia, e al suo posto c'e' la vista
        RENAME TABLE `caratteristiche_prodotti` TO `caratteristiche_prodotti_migrata`;

    ELSEIF tipo IS NULL THEN
        SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, 'caratteristiche_prodotti non c\'era: niente da migrare' );
    END IF;

    -- l'indice unico ( nome, id_genitore ), se i nomi sono gia' tutti diversi fra fratelli
    IF NOT EXISTS ( SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'caratteristiche' AND INDEX_NAME = 'nome_id_genitore' ) THEN
        IF NOT EXISTS ( SELECT 1 FROM caratteristiche WHERE id_genitore IS NOT NULL GROUP BY nome, id_genitore HAVING count(*) > 1 ) THEN
            ALTER TABLE `caratteristiche` ADD UNIQUE KEY `nome_id_genitore` (`nome`,`id_genitore`);
        ELSE
            SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, 'caratteristiche ha nomi ripetuti sotto lo stesso genitore: indice unico ( nome, id_genitore ) non aggiunto' );
        END IF;
    END IF;

    -- id_genitore dello stesso tipo di id, altrimenti la chiave esterna fallisce con 1005 errno 150: sui deploy installati
    -- prima di marzo id e' spesso int( 11 ), mentre _202609261000.colonne.base.sql aggiunge id_genitore bigint( 20 )
    SELECT COLUMN_TYPE INTO tipo_id FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'caratteristiche' AND COLUMN_NAME = 'id';
    SELECT COLUMN_TYPE INTO tipo_genitore FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'caratteristiche' AND COLUMN_NAME = 'id_genitore';
    IF tipo_id IS NOT NULL AND tipo_genitore IS NOT NULL AND tipo_id != tipo_genitore THEN
        SET @sql = CONCAT( 'ALTER TABLE `caratteristiche` MODIFY `id_genitore` ', tipo_id, ' DEFAULT NULL' );
        PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
        SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, CONCAT( 'caratteristiche.id_genitore portato da ', tipo_genitore, ' a ', tipo_id, ', il tipo di id' ) );
    END IF;

    -- la chiave esterna dell'albero
    IF NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = database() AND TABLE_NAME = 'caratteristiche' AND CONSTRAINT_NAME = 'caratteristiche_ibfk_01_nofollow' ) THEN
        IF NOT EXISTS ( SELECT 1 FROM caratteristiche AS c LEFT JOIN caratteristiche AS g ON g.id = c.id_genitore WHERE c.id_genitore IS NOT NULL AND g.id IS NULL ) THEN
            ALTER TABLE `caratteristiche` ADD CONSTRAINT `caratteristiche_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `caratteristiche` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;
        ELSE
            SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, 'caratteristiche ha nodi con un genitore inesistente: chiave esterna su id_genitore non aggiunta' );
        END IF;
    END IF;

    -- le chiavi esterne di articoli e prodotti verso l'albero, dove mancano e non ci sono orfani
    SET fine = 0;
    OPEN figlie;
    giro2: LOOP
        FETCH figlie INTO tabella;
        IF fine = 1 THEN LEAVE giro2; END IF;
        SET chiave = CONCAT( tabella, '_ibfk_02_nofollow' );
        SET fine = 0;
        -- dopo una migrazione ( c'e' la copia caratteristiche_prodotti_migrata ) le tabelle spostate hanno gia' la chiave, e
        -- una ancora senza chiave e' una di quelle ambigue, anche a una seconda esecuzione: la chiave la aggiunge chi
        -- decide a mano a quale tabella si riferivano le righe
        SET @righe = 0;
        SET @sql = CONCAT( 'SELECT count(*) INTO @righe FROM `', tabella, '` WHERE id_caratteristica IS NOT NULL' );
        PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
        IF @righe > 0
            AND NOT EXISTS ( SELECT 1 FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = database() AND TABLE_NAME = tabella AND COLUMN_NAME = 'id_caratteristica' AND REFERENCED_TABLE_NAME IS NOT NULL )
            AND EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'caratteristiche_prodotti_migrata' ) THEN
            IF FIND_IN_SET( tabella, ambigue ) = 0 THEN
                SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, CONCAT( tabella, ': ancora senza chiave esterna dopo la migrazione, da decidere a mano se i riferimenti sono alla tabella piatta o all\'albero' ) );
            END IF;
        ELSEIF NOT EXISTS ( SELECT 1 FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = database() AND TABLE_NAME = tabella AND COLUMN_NAME = 'id_caratteristica' AND REFERENCED_TABLE_NAME IS NOT NULL ) THEN
            SET @orfani = 0;
            SET @sql = CONCAT( 'SELECT count(*) INTO @orfani FROM `', tabella, '` AS t LEFT JOIN caratteristiche AS c ON c.id = t.id_caratteristica WHERE t.id_caratteristica IS NOT NULL AND c.id IS NULL' );
            PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
            IF @orfani = 0 THEN
                -- la colonna prende il tipo di caratteristiche.id: fra int( 11 ) e bigint( 20 ) la chiave fallisce con errno 150
                SELECT COLUMN_TYPE INTO tipo_id FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'caratteristiche' AND COLUMN_NAME = 'id';
                SELECT COLUMN_TYPE, IS_NULLABLE INTO tipo_colonna, nullabile FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = tabella AND COLUMN_NAME = 'id_caratteristica';
                IF tipo_id IS NOT NULL AND tipo_colonna IS NOT NULL AND tipo_id != tipo_colonna THEN
                    SET @sql = CONCAT( 'ALTER TABLE `', tabella, '` MODIFY `id_caratteristica` ', tipo_id, IF( nullabile = 'NO', ' NOT NULL', ' DEFAULT NULL' ) );
                    PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
                    SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, CONCAT( tabella, '.id_caratteristica portato da ', tipo_colonna, ' a ', tipo_id, ', il tipo di caratteristiche.id' ) );
                END IF;
                SET @sql = CONCAT( 'ALTER TABLE `', tabella, '` ADD CONSTRAINT `', chiave, '` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE' );
                PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
            ELSE
                SET @caratteristiche_note = CONCAT_WS( '\n', @caratteristiche_note, CONCAT( tabella, ': ', @orfani, ' righe con una caratteristica che non esiste, chiave esterna non aggiunta' ) );
            END IF;
        END IF;
    END LOOP;
    CLOSE figlie;

END;

-- | 202610011701

CALL `__patch_caratteristiche__`();

-- | 202610011702

DROP PROCEDURE IF EXISTS `__patch_caratteristiche__`;

-- | 202610011703

-- la vista di compatibilita', al posto della tabella ( se c'e' ancora una tabella con questo nome, la CREATE fallisce:
-- vuol dire che la procedura non l'ha migrata, e la nota dice perche' )
CREATE OR REPLACE VIEW `caratteristiche_prodotti` AS
	SELECT
		caratteristiche.id,
		caratteristiche.id_genitore,
		caratteristiche.nome,
		caratteristiche.font_awesome,
		caratteristiche.html_entity,
		caratteristiche.se_categorie_prodotti AS se_categoria,
		caratteristiche.se_prodotti AS se_prodotto,
		caratteristiche.se_articoli AS se_articolo,
		caratteristiche.id_account_inserimento,
		caratteristiche.timestamp_inserimento,
		caratteristiche.id_account_aggiornamento,
		caratteristiche.timestamp_aggiornamento
	FROM caratteristiche
;

-- | 202610011704

CREATE OR REPLACE VIEW `caratteristiche_prodotti_view` AS
	SELECT
		caratteristiche.id,
		caratteristiche.id_genitore,
		caratteristiche.nome,
		caratteristiche.html_entity,
		caratteristiche.font_awesome,
		caratteristiche.se_categorie_prodotti AS se_categoria,
		caratteristiche.se_prodotti AS se_prodotto,
		caratteristiche.se_articoli AS se_articolo,
		caratteristiche.id_account_inserimento,
		caratteristiche.id_account_aggiornamento,
		caratteristiche_path(
            caratteristiche.id
        ) AS __label__
	FROM caratteristiche
;

-- | 202610011705

-- quello che non si e' potuto fare, per chi applica la patch a mano
SELECT @caratteristiche_note AS nota;

-- | FINE FILE
