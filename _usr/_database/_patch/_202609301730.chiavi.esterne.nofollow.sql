-- 2026-09-30 — i vincoli seguiti che il canone vuole _nofollow, e le chiavi esterne di distinta
--
-- Contesto: il canone delle chiavi esterne ( _usr/_docs/_read/300.database.md, "chiavi esterne" e "auto follow delle
-- chiavi esterne" ) vuole _nofollow le chiavi verso tipologie, ruoli e alberi, perche' controller(), quando apre una
-- riga in GET, carica dentro la scheda tutte le righe delle tabelle che la citano con una chiave non _nofollow: aprire
-- un listino caricava ogni suo prezzo, aprire una tipologia ogni riga di quella tipologia. Quattordici vincoli dei file
-- di base erano ancora seguiti senza che nessun form della tabella madre leggesse quelle righe come sotto-elenco ( le
-- schede di listini e categorie di prodotti mostrano prezzi e prodotti con una vista filtrata, non dal blocco dati,
-- quelle di reparti e tipologie di periodi non li mostrano, iva e gli altri ruoli e tipologie non hanno form ): i file
-- di base li hanno adesso col suffisso, con le stesse regole.
-- orari_ibfk_01 resta seguito, perche' il form delle tipologie di abbonamento mostra gli orari dal blocco dati.
--
-- La tabella distinta non aveva chiavi esterne, ne' nei file di base ne' nelle patch, quindi la scheda di un articolo
-- non la caricava: i file di base hanno adesso distinta_ibfk_01 ( id_articolo, il composto, seguita, CASCADE ),
-- distinta_ibfk_02_nofollow ( id_componente, CASCADE come l'altro lato di una tabella di relazione, sul modello di
-- relazioni_articoli ) e 98 / 99.
--
-- COSA FA, SUI DEPLOY ESISTENTI.
--
-- -# per ciascuno dei quattordici vincoli, solo se c'e' ancora col vecchio nome: lo toglie e lo rimette col suffisso
--    _nofollow, sulla stessa colonna, verso la stessa tabella e con le stesse regole ON DELETE / ON UPDATE che ha sul
--    deploy; se il nuovo non entra rimette il vecchio, cosi' la colonna non resta senza vincolo. Dove il vincolo non
--    c'e' col vecchio nome ( i deploy di prima di marzo hanno gia' prezzi_ibfk_03_nofollow e 04_nofollow,
--    prodotti_categorie_ibfk_02_nofollow ) non fa niente;
-- -# aggiunge le quattro chiavi di distinta, ciascuna solo se la tabella e la colonna esistono, sulla colonna non
--    c'e' gia' una chiave esterna, il nome non e' gia' usato, i tipi coincidono e non ci sono righe orfane.
--
-- Quello che non fa lo scrive in @nofollow_note, restituita dal blocco dopo l'ultima CALL a chi applica la patch a
-- mano. Le ALTER girano con foreign_key_checks a 0 ( i dati non cambiano, e le orfane di distinta si contano prima ),
-- in procedure come in _202609301100.chiavi.esterne.sql. Dopo la patch va svuotata memcache, perche' controller()
-- legge le chiavi esterne con mysqlCachedQuery().
--
-- IDEMPOTENTE.

-- | 202609301730

-- la procedura che rinomina un vincolo in _nofollow, con le regole che ha
CREATE OR REPLACE PROCEDURE `__patch_nofollow__`( IN tabella VARCHAR(64), IN vecchio VARCHAR(64) )
BEGIN

    DECLARE errore INT DEFAULT 0;
    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE nuovo VARCHAR(64) DEFAULT CONCAT( vecchio, '_nofollow' );
    DECLARE v_colonna, v_riferimento VARCHAR(64) DEFAULT NULL;
    DECLARE v_cancellazione, v_aggiornamento VARCHAR(16) DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
            SET errore = 1;
        END;

    SELECT k.COLUMN_NAME, k.REFERENCED_TABLE_NAME, r.DELETE_RULE, r.UPDATE_RULE
        INTO v_colonna, v_riferimento, v_cancellazione, v_aggiornamento
        FROM information_schema.KEY_COLUMN_USAGE AS k
        INNER JOIN information_schema.REFERENTIAL_CONSTRAINTS AS r
            ON r.CONSTRAINT_SCHEMA = k.CONSTRAINT_SCHEMA AND r.CONSTRAINT_NAME = k.CONSTRAINT_NAME AND r.TABLE_NAME = k.TABLE_NAME
        WHERE k.TABLE_SCHEMA = database() AND k.TABLE_NAME = tabella
          AND BINARY k.CONSTRAINT_NAME = BINARY vecchio
          AND k.REFERENCED_TABLE_NAME IS NOT NULL
        LIMIT 1;

    SET @nofollow_controlli = @@foreign_key_checks;

    IF v_colonna IS NULL THEN
        -- non c'e' col vecchio nome: gia' rinominato, o il deploy ha un'altra storia
        SET messaggio = NULL;
    ELSEIF EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE CONSTRAINT_SCHEMA = database() AND CONSTRAINT_NAME = nuovo
    ) THEN
        SET messaggio = CONCAT( 'il nome ', nuovo, ' e'' gia'' usato da un altro vincolo: ', vecchio, ' lasciato' );
    ELSE
        SET foreign_key_checks = 0;
        SET @nofollow_sql = CONCAT( 'ALTER TABLE `', tabella, '` DROP FOREIGN KEY `', vecchio, '`' );
        PREPARE togli FROM @nofollow_sql;
        EXECUTE togli;
        DEALLOCATE PREPARE togli;
        IF errore = 0 THEN
            SET @nofollow_sql = CONCAT(
                'ALTER TABLE `', tabella, '` ADD CONSTRAINT `', nuovo, '` FOREIGN KEY (`', v_colonna, '`) ',
                'REFERENCES `', v_riferimento, '` (`id`) ON DELETE ', v_cancellazione, ' ON UPDATE ', v_aggiornamento
            );
            PREPARE metti FROM @nofollow_sql;
            EXECUTE metti;
            DEALLOCATE PREPARE metti;
            IF errore = 1 THEN
                -- se il nuovo non entra si rimette il vecchio, cosi' la colonna non resta senza vincolo
                SET @nofollow_sql = CONCAT(
                    'ALTER TABLE `', tabella, '` ADD CONSTRAINT `', vecchio, '` FOREIGN KEY (`', v_colonna, '`) ',
                    'REFERENCES `', v_riferimento, '` (`id`) ON DELETE ', v_cancellazione, ' ON UPDATE ', v_aggiornamento
                );
                PREPARE metti FROM @nofollow_sql;
                EXECUTE metti;
                DEALLOCATE PREPARE metti;
                SET messaggio = CONCAT( 'rinomina fallita, rimesso il vincolo di prima: ', messaggio );
            ELSE
                SET messaggio = NULL;
            END IF;
        ELSE
            SET messaggio = CONCAT( 'rinomina fallita: ', messaggio );
        END IF;
        SET foreign_key_checks = @nofollow_controlli;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @nofollow_note = CONCAT_WS( '\n', @nofollow_note, CONCAT( vecchio, ': ', messaggio ) );
    END IF;

END;

-- | 202609301731

-- badge.id_tipologia -> tipologie_badge
CALL `__patch_nofollow__`( 'badge', 'badge_ibfk_01' );

-- | 202609301732

-- banner.id_tipologia -> tipologie_banner
CALL `__patch_nofollow__`( 'banner', 'banner_ibfk_01' );

-- | 202609301733

-- mail.id_ruolo -> ruoli_mail
CALL `__patch_nofollow__`( 'mail', 'mail_ibfk_01' );

-- | 202609301734

-- modalita_spedizione.id_tipologia -> tipologie_spedizioni
CALL `__patch_nofollow__`( 'modalita_spedizione', 'modalita_spedizione_ibfk_01' );

-- | 202609301735

-- periodi.id_tipologia -> tipologie_periodi
CALL `__patch_nofollow__`( 'periodi', 'periodi_ibfk_02' );

-- | 202609301736

-- sconti.id_tipologia -> tipologie_sconti
CALL `__patch_nofollow__`( 'sconti', 'sconti_ibfk_01' );

-- | 202609301737

-- relazioni_documenti_articoli.id_ruolo -> ruoli_documenti
CALL `__patch_nofollow__`( 'relazioni_documenti_articoli', 'relazioni_documenti_articoli_ibfk_03' );

-- | 202609301738

-- prodotti_categorie.id_categoria -> categorie_prodotti
CALL `__patch_nofollow__`( 'prodotti_categorie', 'prodotti_categorie_ibfk_02' );

-- | 202609301739

-- prezzi.id_listino -> listini
CALL `__patch_nofollow__`( 'prezzi', 'prezzi_ibfk_03' );

-- | 202609301740

-- prezzi.id_iva -> iva
CALL `__patch_nofollow__`( 'prezzi', 'prezzi_ibfk_04' );

-- | 202609301741

-- prezzi.id_reparto -> reparti
CALL `__patch_nofollow__`( 'prezzi', 'prezzi_ibfk_05' );

-- | 202609301742

-- ruoli_articoli.id_genitore
CALL `__patch_nofollow__`( 'ruoli_articoli', 'ruoli_articoli_ibfk_01' );

-- | 202609301743

-- ruoli_categorie_progetti.id_genitore
CALL `__patch_nofollow__`( 'ruoli_categorie_progetti', 'ruoli_categorie_progetti_ibfk_01' );

-- | 202609301744

-- ruoli_matricole.id_genitore
CALL `__patch_nofollow__`( 'ruoli_matricole', 'ruoli_matricole_ibfk_01' );

-- | 202609301745

-- la procedura che aggiunge una chiave esterna dei file di base, se si puo'
CREATE OR REPLACE PROCEDURE `__patch_nofollow_aggiunta__`( IN tabella VARCHAR(64), IN vincolo VARCHAR(64), IN colonna VARCHAR(64), IN riferimento VARCHAR(64), IN cancellazione VARCHAR(16), IN aggiornamento VARCHAR(16) )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE v_tipo_figlia, v_tipo_padre, v_nullabile VARCHAR(64) DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    SELECT COLUMN_TYPE, IS_NULLABLE INTO v_tipo_figlia, v_nullabile
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = tabella AND COLUMN_NAME = colonna
        LIMIT 1;

    SELECT COLUMN_TYPE INTO v_tipo_padre
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = riferimento AND COLUMN_NAME = 'id'
        LIMIT 1;

    SET @nofollow_orfani = 0;
    SET @nofollow_controlli = @@foreign_key_checks;

    IF v_tipo_figlia IS NULL THEN
        SET messaggio = CONCAT( 'non esiste ', tabella, '.', colonna );
    ELSEIF v_tipo_padre IS NULL THEN
        SET messaggio = CONCAT( 'non esiste ', riferimento, '.id' );
    ELSEIF EXISTS (
        SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = tabella AND COLUMN_NAME = colonna
          AND REFERENCED_TABLE_NAME IS NOT NULL
    ) THEN
        -- c'e' gia' una chiave esterna sulla colonna, con qualunque nome: non si tocca
        SET messaggio = NULL;
    ELSEIF EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE CONSTRAINT_SCHEMA = database() AND CONSTRAINT_NAME = vincolo
    ) THEN
        SET messaggio = 'il nome e'' gia'' usato da un altro vincolo';
    ELSEIF NOT EXISTS (
        SELECT 1 FROM information_schema.STATISTICS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = riferimento AND COLUMN_NAME = 'id'
          AND SEQ_IN_INDEX = 1 AND NON_UNIQUE = 0
    ) THEN
        SET messaggio = CONCAT( riferimento, '.id non e'' una chiave' );
    ELSEIF v_tipo_figlia <> v_tipo_padre THEN
        SET messaggio = CONCAT( 'tipi diversi, ', tabella, '.', colonna, ' ', v_tipo_figlia, ' e ', riferimento, '.id ', v_tipo_padre );
    ELSEIF cancellazione = 'SET NULL' AND v_nullabile = 'NO' THEN
        SET messaggio = CONCAT( tabella, '.', colonna, ' e'' NOT NULL e il vincolo e'' ON DELETE SET NULL' );
    ELSE
        SET @nofollow_sql = CONCAT(
            'SELECT count(*) INTO @nofollow_orfani FROM `', tabella, '` AS figlie ',
            'LEFT JOIN `', riferimento, '` AS padri ON padri.id = figlie.`', colonna, '` ',
            'WHERE figlie.`', colonna, '` IS NOT NULL AND padri.id IS NULL'
        );
        PREPARE controllo FROM @nofollow_sql;
        EXECUTE controllo;
        DEALLOCATE PREPARE controllo;
        IF messaggio IS NULL AND @nofollow_orfani > 0 THEN
            SET messaggio = CONCAT( @nofollow_orfani, ' righe di ', tabella, ' con un ', colonna, ' che non esiste in ', riferimento );
        ELSEIF messaggio IS NULL THEN
            SET foreign_key_checks = 0;
            SET @nofollow_sql = CONCAT(
                'ALTER TABLE `', tabella, '` ADD CONSTRAINT `', vincolo, '` FOREIGN KEY (`', colonna, '`) ',
                'REFERENCES `', riferimento, '` (`id`) ON DELETE ', cancellazione, ' ON UPDATE ', aggiornamento
            );
            PREPARE aggiunta FROM @nofollow_sql;
            EXECUTE aggiunta;
            DEALLOCATE PREPARE aggiunta;
            SET foreign_key_checks = @nofollow_controlli;
        END IF;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @nofollow_note = CONCAT_WS( '\n', @nofollow_note, CONCAT( vincolo, ': ', messaggio ) );
    END IF;

END;

-- | 202609301746

-- distinta.id_articolo -> articoli, il composto: la distinta fa parte della sua scheda
CALL `__patch_nofollow_aggiunta__`( 'distinta', 'distinta_ibfk_01', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' );

-- | 202609301747

-- distinta.id_componente -> articoli, il componente
CALL `__patch_nofollow_aggiunta__`( 'distinta', 'distinta_ibfk_02_nofollow', 'id_componente', 'articoli', 'CASCADE', 'CASCADE' );

-- | 202609301748

-- distinta.id_account_inserimento
CALL `__patch_nofollow_aggiunta__`( 'distinta', 'distinta_ibfk_98_nofollow', 'id_account_inserimento', 'account', 'SET NULL', 'SET NULL' );

-- | 202609301749

-- distinta.id_account_aggiornamento
CALL `__patch_nofollow_aggiunta__`( 'distinta', 'distinta_ibfk_99_nofollow', 'id_account_aggiornamento', 'account', 'SET NULL', 'SET NULL' );

-- | 202609301750

-- quello che non si e' potuto fare, e perche': lo legge chi applica la patch a mano
SELECT @nofollow_note AS nota;

-- | 202609301751

-- si liberano le procedure
DROP PROCEDURE IF EXISTS `__patch_nofollow__`;

-- | 202609301752

DROP PROCEDURE IF EXISTS `__patch_nofollow_aggiunta__`;

-- | FINE FILE
