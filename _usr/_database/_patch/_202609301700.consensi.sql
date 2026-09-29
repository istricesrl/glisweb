-- 2026-09-30 — consensi: il codice in una colonna sua, e le colonne id_consenso dello stesso tipo di consensi.id
--
-- Contesto: prima di marzo l'id di un consenso era il suo codice ( char( 64 ), PRIVACY_POLICY, EVASIONE_ORDINE,
-- INVIO_COMUNICAZIONI_MARKETING ), e consensi_moduli, anagrafica_consensi e carrelli_consensi lo citavano come testo.
-- Il riallineamento del 26/03/2026 ha dato a consensi un id numerico e una colonna codice NOT NULL, ma ha lasciato
-- consensi_moduli.id_consenso testuale e i dati standard con gli id testuali: un deploy installato da allora ha in
-- consensi una riga sola, con id 0 e codice vuoto ( le altre due scartate da INSERT IGNORE come doppioni ), e in
-- consensi_moduli i codici. Il codice del framework cercava i consensi per testo: _180.privacy.php indicizzava
-- $cf['privacy']['moduli'][...]['consensi'] per consensi_moduli.id_consenso, e l'ecommerce e la registrazione
-- scrivevano il codice in carrelli_consensi.id_consenso e anagrafica_consensi.id_consenso. Adesso i file di base
-- hanno i consensi con id 1, 2, 3 e il codice nella sua colonna ( UNIQUE ), tutte le colonne id_consenso a bigint,
-- e il codice legge consensi_moduli in join con consensi indicizzando per codice, e scrive l'id che corrisponde al
-- codice.
--
-- COSA FA, SUI DEPLOY ESISTENTI.
--
-- -# aggiunge consensi.codice, se manca, e dove consensi.id e' ancora testuale ( il modello di prima di marzo ) ci
--    copia l'id: e' il codice, e da qui in avanti il codice del framework lo cerca li'. Su quei deploy l'id resta
--    il codice e le colonne che lo citano restano testuali: join e ricerca per codice funzionano lo stesso;
-- -# dove consensi.id e' numerico ripara i dati del 26/03: la riga con id 0 e codice vuoto che ha il nome della
--    privacy policy diventa PRIVACY_POLICY con id 1 ( se l'id 1 e' libero ), e le righe standard che mancano
--    entrano con gli id dei file di base, solo se non c'e' gia' una riga con lo stesso id, codice o nome;
-- -# mette la chiave UNIQUE su consensi.codice, se i valori sono tutti diversi;
-- -# crea consensi_anagrafica e consensi_contatti, che _src/_lib/_privacy.utils.php scrive e che i deploy installati
--    prima del 26/03 non hanno, e le loro viste se mancano;
-- -# per ciascuna colonna che cita un consenso ( consensi_moduli, anagrafica_consensi, carrelli_consensi,
--    consensi_anagrafica, consensi_contatti ) la porta al tipo di consensi.id solo se si puo' fare senza perdere
--    niente: dove consensi.id e' numerico e la colonna e' testuale traduce i codici negli id, e converte solo se
--    ogni valore e' un codice o un id che esiste; dove consensi.id e' testuale e la colonna e' numerica ( le tabelle
--    create dalla patch del 29/09 ) converte solo se la colonna e' vuota. Poi, se i tipi coincidono, sulla colonna
--    non c'e' gia' una chiave esterna e non ci sono righe orfane, aggiunge la chiave esterna dei file di base.
--
-- Quello che non fa lo scrive in @consensi_note, restituita dal blocco dopo l'ultima CALL a chi applica la patch a
-- mano. Le istruzioni condizionali stanno in procedure, come in _202609301030.coupon.sql e
-- _202609301100.chiavi.esterne.sql.
--
-- IDEMPOTENTE.

-- | 202609301700

-- consensi.codice, il codice che i form e $cf['privacy'] usano
ALTER TABLE `consensi`
    ADD COLUMN IF NOT EXISTS `codice` char(64) DEFAULT NULL AFTER `id`;

-- | 202609301701

-- dove consensi.id e' ancora il codice ( modello di prima di marzo ) il codice e' l'id
UPDATE `consensi` SET `codice` = `id`
    WHERE ( `codice` IS NULL OR `codice` = '' )
    AND ( SELECT DATA_TYPE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'consensi' AND COLUMN_NAME = 'id' ) IN ( 'char', 'varchar' );

-- | 202609301702

-- la procedura delle istruzioni
-- la procedura che prova un'istruzione e, se fallisce, lo annota invece di fermare il task
CREATE OR REPLACE PROCEDURE `__patch_consensi__`( IN istruzione LONGTEXT, IN oggetto VARCHAR(64) )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    SET @consensi_sql = istruzione;
    PREPARE prova FROM @consensi_sql;
    IF messaggio IS NULL THEN
        EXECUTE prova;
        DEALLOCATE PREPARE prova;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @consensi_note = CONCAT_WS( '\n', @consensi_note, CONCAT( oggetto, ': ', messaggio ) );
    END IF;

END;

-- | 202609301703

-- la riga che i dati del 26/03 hanno lasciato con id 0 e codice vuoto e' la privacy policy
CALL `__patch_consensi__`( '
UPDATE `consensi` SET `codice` = ''PRIVACY_POLICY''
    WHERE `codice` = '''' AND `nome` = ''la privacy e cookie policy del sito''
    AND ( SELECT DATA_TYPE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = ''consensi'' AND COLUMN_NAME = ''id'' ) IN ( ''int'', ''bigint'', ''mediumint'', ''smallint'', ''tinyint'' )
    AND NOT EXISTS ( SELECT 1 FROM ( SELECT `codice` FROM `consensi` ) AS e WHERE e.`codice` = ''PRIVACY_POLICY'' )
', 'consensi PRIVACY_POLICY' );

-- | 202609301704

-- e prende l'id dei file di base, se e' libero
CALL `__patch_consensi__`( '
UPDATE `consensi` SET `id` = 1
    WHERE `codice` = ''PRIVACY_POLICY''
    AND ( SELECT DATA_TYPE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = ''consensi'' AND COLUMN_NAME = ''id'' ) IN ( ''int'', ''bigint'', ''mediumint'', ''smallint'', ''tinyint'' )
    AND `id` = 0
    AND NOT EXISTS ( SELECT 1 FROM ( SELECT `id` FROM `consensi` ) AS e WHERE e.`id` = 1 )
', 'consensi id 0' );

-- | 202609301705

-- le righe standard che mancano, dove consensi.id e' numerico
CALL `__patch_consensi__`( '
INSERT IGNORE INTO `consensi` ( `id`, `codice`, `nome` )
    SELECT v.`id`, v.`codice`, v.`nome` FROM (
        SELECT 1 AS `id`, ''PRIVACY_POLICY'' AS `codice`, ''la privacy e cookie policy del sito'' AS `nome`
        UNION ALL SELECT 2, ''EVASIONE_ORDINE'', ''evasione dell''''ordine''
        UNION ALL SELECT 3, ''INVIO_COMUNICAZIONI_MARKETING'', ''invio di comunicazioni commerciali''
    ) AS v
    WHERE ( SELECT DATA_TYPE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = ''consensi'' AND COLUMN_NAME = ''id'' ) IN ( ''int'', ''bigint'', ''mediumint'', ''smallint'', ''tinyint'' )
    AND NOT EXISTS ( SELECT 1 FROM `consensi` AS e WHERE e.`id` = v.`id` OR e.`codice` = v.`codice` OR e.`nome` = v.`nome` )
', 'consensi standard' );

-- | 202609301706

-- il codice identifica il consenso
CALL `__patch_consensi__`( '
ALTER TABLE `consensi` ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`)
', 'consensi UNIQUE codice' );

-- | 202609301707

-- consensi_anagrafica, che i deploy installati prima del 26/03 non hanno: nasce col tipo dei file di base, e se
-- consensi.id e' testuale la procedura delle colonne la porta al tipo di consensi.id, visto che e' vuota
CREATE TABLE IF NOT EXISTS `consensi_anagrafica` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_consenso` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `modulo` char(32) DEFAULT NULL,
  `valore` int(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_consenso`, `id_anagrafica`, `modulo`),
  KEY `id_consenso` (`id_consenso`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `modulo` (`modulo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`, `id_consenso`, `id_anagrafica`, `modulo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609301708

-- consensi_contatti, come sopra
CREATE TABLE IF NOT EXISTS `consensi_contatti` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_consenso` bigint(20) DEFAULT NULL,
  `id_contatto` bigint(20) DEFAULT NULL,
  `modulo` char(32) DEFAULT NULL,
  `valore` int(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_consenso`, `id_contatto`, `modulo`),
  KEY `id_consenso` (`id_consenso`),
  KEY `id_contatto` (`id_contatto`),
  KEY `modulo` (`modulo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`, `id_consenso`, `id_contatto`, `modulo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609301709

-- la procedura delle colonne
-- la procedura che porta una colonna al tipo di consensi.id, se si puo' fare senza perdere niente, e ci mette la
-- chiave esterna dei file di base se manca
CREATE OR REPLACE PROCEDURE `__patch_consensi_colonna__`( IN tabella VARCHAR(64), IN colonna VARCHAR(64), IN vincolo VARCHAR(64), IN cancellazione VARCHAR(16), IN aggiornamento VARCHAR(16) )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE v_tipo_colonna, v_dato_colonna, v_tipo_consensi, v_dato_consensi VARCHAR(64) DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    SELECT COLUMN_TYPE, DATA_TYPE INTO v_tipo_colonna, v_dato_colonna
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = tabella AND COLUMN_NAME = colonna
        LIMIT 1;

    SELECT COLUMN_TYPE, DATA_TYPE INTO v_tipo_consensi, v_dato_consensi
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'consensi' AND COLUMN_NAME = 'id'
        LIMIT 1;

    SET @consensi_problemi = 0;

    IF v_tipo_colonna IS NULL OR v_tipo_consensi IS NULL THEN
        SET messaggio = 'la colonna o consensi.id non esistono';
    ELSEIF v_tipo_colonna = v_tipo_consensi THEN
        SET messaggio = NULL;
    ELSEIF v_dato_consensi IN ( 'int', 'bigint', 'mediumint', 'smallint', 'tinyint' ) AND v_dato_colonna IN ( 'char', 'varchar' ) THEN
        -- i valori devono essere tutti codici o id di consensi, altrimenti la conversione li perderebbe
        SET @consensi_sql = CONCAT(
            'SELECT count(*) INTO @consensi_problemi FROM `', tabella, '` AS t ',
            'WHERE t.`', colonna, '` IS NOT NULL AND t.`', colonna, '` <> '''' ',
            'AND NOT EXISTS ( SELECT 1 FROM `consensi` AS c WHERE c.`codice` = t.`', colonna, '` ) ',
            'AND NOT ( t.`', colonna, '` REGEXP ''^[0-9]+$'' AND EXISTS ( SELECT 1 FROM `consensi` AS c WHERE c.`id` = t.`', colonna, '` ) )'
        );
        PREPARE controllo FROM @consensi_sql;
        EXECUTE controllo;
        DEALLOCATE PREPARE controllo;
        IF messaggio IS NULL AND @consensi_problemi > 0 THEN
            SET messaggio = CONCAT( @consensi_problemi, ' righe con un valore che non e'' ne'' un codice ne'' un id di consensi: colonna lasciata ', v_tipo_colonna );
        ELSEIF messaggio IS NULL THEN
            SET @consensi_sql = CONCAT( 'UPDATE `', tabella, '` SET `', colonna, '` = NULL WHERE `', colonna, '` = ''''' );
            PREPARE vuoti FROM @consensi_sql;
            EXECUTE vuoti;
            DEALLOCATE PREPARE vuoti;
            IF messaggio IS NULL THEN
                SET @consensi_sql = CONCAT(
                    'UPDATE `', tabella, '` AS t INNER JOIN `consensi` AS c ON c.`codice` = t.`', colonna, '` ',
                    'SET t.`', colonna, '` = c.`id`'
                );
                PREPARE traduci FROM @consensi_sql;
                EXECUTE traduci;
                DEALLOCATE PREPARE traduci;
            END IF;
            IF messaggio IS NULL THEN
                SET @consensi_sql = CONCAT( 'ALTER TABLE `', tabella, '` MODIFY `', colonna, '` ', v_tipo_consensi, ' DEFAULT NULL' );
                PREPARE converti FROM @consensi_sql;
                EXECUTE converti;
                DEALLOCATE PREPARE converti;
            END IF;
        END IF;
    ELSEIF v_dato_consensi IN ( 'int', 'bigint', 'mediumint', 'smallint', 'tinyint' ) THEN
        -- numerica di un'altra ampiezza: gli id restano quelli
        SET @consensi_sql = CONCAT( 'ALTER TABLE `', tabella, '` MODIFY `', colonna, '` ', v_tipo_consensi, ' DEFAULT NULL' );
        PREPARE converti FROM @consensi_sql;
        EXECUTE converti;
        DEALLOCATE PREPARE converti;
    ELSEIF v_dato_colonna IN ( 'int', 'bigint', 'mediumint', 'smallint', 'tinyint' ) THEN
        -- consensi.id e' il codice e la colonna e' numerica: si converte solo se e' vuota
        SET @consensi_sql = CONCAT( 'SELECT count(*) INTO @consensi_problemi FROM `', tabella, '` WHERE `', colonna, '` IS NOT NULL' );
        PREPARE controllo FROM @consensi_sql;
        EXECUTE controllo;
        DEALLOCATE PREPARE controllo;
        IF messaggio IS NULL AND @consensi_problemi > 0 THEN
            SET messaggio = CONCAT( 'consensi.id e'' ', v_tipo_consensi, ' ( modello di prima di marzo ) e ', @consensi_problemi, ' righe hanno un id numerico: colonna lasciata ', v_tipo_colonna );
        ELSEIF messaggio IS NULL THEN
            SET @consensi_sql = CONCAT( 'ALTER TABLE `', tabella, '` MODIFY `', colonna, '` ', v_tipo_consensi, ' DEFAULT NULL' );
            PREPARE converti FROM @consensi_sql;
            EXECUTE converti;
            DEALLOCATE PREPARE converti;
        END IF;
    ELSE
        SET messaggio = CONCAT( 'consensi.id e'' ', v_tipo_consensi, ' e la colonna ', v_tipo_colonna, ': colonna lasciata' );
    END IF;

    -- la chiave esterna dei file di base, se i tipi adesso coincidono e sulla colonna non ce n'e' gia' una
    IF messaggio IS NULL AND vincolo IS NOT NULL THEN
        SELECT COLUMN_TYPE INTO v_tipo_colonna
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = tabella AND COLUMN_NAME = colonna
            LIMIT 1;
        IF v_tipo_colonna = v_tipo_consensi AND NOT EXISTS (
            SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = tabella AND COLUMN_NAME = colonna
              AND REFERENCED_TABLE_NAME IS NOT NULL
        ) THEN
            IF EXISTS (
                SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
                WHERE CONSTRAINT_SCHEMA = database() AND CONSTRAINT_NAME = vincolo
            ) THEN
                SET messaggio = CONCAT( 'il nome ', vincolo, ' e'' gia'' usato da un altro vincolo' );
            ELSE
                SET @consensi_sql = CONCAT(
                    'SELECT count(*) INTO @consensi_problemi FROM `', tabella, '` AS t ',
                    'LEFT JOIN `consensi` AS c ON c.`id` = t.`', colonna, '` ',
                    'WHERE t.`', colonna, '` IS NOT NULL AND c.`id` IS NULL'
                );
                PREPARE controllo FROM @consensi_sql;
                EXECUTE controllo;
                DEALLOCATE PREPARE controllo;
                IF messaggio IS NULL AND @consensi_problemi > 0 THEN
                    SET messaggio = CONCAT( @consensi_problemi, ' righe con un ', colonna, ' che non esiste in consensi: ', vincolo, ' non aggiunto' );
                ELSEIF messaggio IS NULL THEN
                    SET @consensi_sql = CONCAT(
                        'ALTER TABLE `', tabella, '` ADD CONSTRAINT `', vincolo, '` FOREIGN KEY (`', colonna, '`) ',
                        'REFERENCES `consensi` (`id`) ON DELETE ', cancellazione, ' ON UPDATE ', aggiornamento
                    );
                    PREPARE aggiunta FROM @consensi_sql;
                    EXECUTE aggiunta;
                    DEALLOCATE PREPARE aggiunta;
                END IF;
            END IF;
        END IF;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @consensi_note = CONCAT_WS( '\n', @consensi_note, CONCAT( tabella, '.', colonna, ': ', messaggio ) );
    END IF;

END;

-- | 202609301710

-- consensi_moduli.id_consenso
CALL `__patch_consensi_colonna__`( 'consensi_moduli', 'id_consenso', 'consensi_moduli_ibfk_02_nofollow', 'SET NULL', 'SET NULL' );

-- | 202609301711

-- anagrafica_consensi.id_consenso
CALL `__patch_consensi_colonna__`( 'anagrafica_consensi', 'id_consenso', 'anagrafica_consensi_ibfk_03_nofollow', 'CASCADE', 'CASCADE' );

-- | 202609301712

-- carrelli_consensi.id_consenso
CALL `__patch_consensi_colonna__`( 'carrelli_consensi', 'id_consenso', 'carrelli_consensi_ibfk_04_nofollow', 'CASCADE', 'CASCADE' );

-- | 202609301713

-- consensi_anagrafica.id_consenso, senza chiave esterna nei file di base
CALL `__patch_consensi_colonna__`( 'consensi_anagrafica', 'id_consenso', NULL, NULL, NULL );

-- | 202609301714

-- consensi_contatti.id_consenso, senza chiave esterna nei file di base
CALL `__patch_consensi_colonna__`( 'consensi_contatti', 'id_consenso', NULL, NULL, NULL );

-- | 202609301715

-- consensi_anagrafica_view, che la linguetta privacy della scheda anagrafica legge; se c'e' gia' resta quella
CALL `__patch_consensi__`( '
CREATE VIEW IF NOT EXISTS `consensi_anagrafica_view` AS
    SELECT
        consensi_anagrafica.id,
        consensi_anagrafica.id_consenso,
        consensi.nome AS consenso,
        consensi_anagrafica.id_anagrafica,
        concat_ws(
            '' '',
            anagrafica.nome,
            anagrafica.cognome,
            anagrafica.denominazione
        ) AS anagrafica,
        consensi_anagrafica.modulo,
        consensi_anagrafica.valore,
        consensi_anagrafica.id_account_inserimento,
        consensi_anagrafica.timestamp_inserimento,
        from_unixtime( consensi_anagrafica.timestamp_inserimento, ''%Y-%m-%d %H:%i'' ) AS data_ora_inserimento,
        consensi_anagrafica.id_account_aggiornamento,
        concat(
            ''consenso '',
            consensi.nome,
            '' per modulo '',
            consensi_anagrafica.modulo
        ) AS __label__
    FROM consensi_anagrafica
        INNER JOIN consensi ON consensi.id = consensi_anagrafica.id_consenso
        INNER JOIN anagrafica ON anagrafica.id = consensi_anagrafica.id_anagrafica
', 'consensi_anagrafica_view' );

-- | 202609301716

-- consensi_contatti_view, come sopra
CALL `__patch_consensi__`( '
CREATE VIEW IF NOT EXISTS `consensi_contatti_view` AS
    SELECT
        consensi_contatti.id,
        consensi_contatti.id_consenso,
        consensi.nome AS consenso,
        consensi_contatti.id_contatto,
        consensi_contatti.modulo,
        consensi_contatti.valore,
        consensi_contatti.id_account_inserimento,
        consensi_contatti.id_account_aggiornamento,
        concat(
            ''consenso '',
            consensi.nome,
            '' per modulo '',
            consensi_contatti.modulo
        ) AS __label__
    FROM consensi_contatti
        INNER JOIN consensi ON consensi.id = consensi_contatti.id_consenso
', 'consensi_contatti_view' );

-- | 202609301717

-- quello che non si e' potuto fare, e perche': lo legge chi applica la patch a mano
SELECT @consensi_note AS nota;

-- | 202609301718

-- si liberano le procedure
DROP PROCEDURE IF EXISTS `__patch_consensi_colonna__`;

-- | 202609301719

DROP PROCEDURE IF EXISTS `__patch_consensi__`;

-- | FINE FILE
