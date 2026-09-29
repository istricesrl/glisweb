-- 2026-09-30 — coupon: il codice in una colonna sua, e le colonne id_coupon dello stesso tipo di coupon.id
--
-- Contesto: prima del 02/03/2026 l'id di un coupon era il suo codice ( char( 32 ) ), quello che il cliente digita
-- nel carrello, e carrelli, carrelli_articoli, documenti, pagamenti e pianificazioni lo citavano come testo. Il
-- riallineamento di marzo ha reso coupon.id numerico ( il file degli indici lo porta a bigint AUTO_INCREMENT ) senza
-- dare al codice un'altra colonna e senza cambiare le colonne che lo citano: il modulo _4170.ecommerce cercava il
-- coupon con id = codice digitato e non lo trovava mai, la gestione _4140.coupon scriveva il codice in id, e le
-- chiavi esterne verso coupon non si potevano creare. I file di base hanno adesso coupon.codice ( UNIQUE ), tutte le
-- colonne id_coupon a bigint e coupon_view e __report_utilizzi_coupon__, che mancavano; il codice del modulo cerca il
-- coupon per codice e usa l'id nelle relazioni.
--
-- COSA FA, SUI DEPLOY ESISTENTI.
--
-- -# aggiunge coupon.codice, se manca, e dove coupon.id e' ancora testuale ( il modello di prima di marzo ) ci copia
--    l'id: e' il codice che i clienti conoscono, e da qui in avanti il modulo lo cerca li';
-- -# per ciascuna colonna che cita un coupon ( carrelli.id_coupon, carrelli_articoli.id_coupon, documenti.id_coupon,
--    pagamenti.id_coupon, pianificazioni.model_id_coupon ) la porta al tipo di coupon.id SOLO se coupon.id e'
--    numerico e la colonna contiene solo numeri o valori vuoti ( che diventano NULL ). Dove coupon.id e' testuale la
--    colonna resta testuale, perche' i valori sono codici e sono giusti cosi'; dove ci sono valori non numerici
--    ( un codice scritto al posto dell'id ) non si converte niente, perche' la conversione li perderebbe, e lo si
--    scrive: vanno ricondotti a mano all'id del coupon, poi la patch si puo' rilanciare;
-- -# rifa coupon_view e __report_utilizzi_coupon__; se una delle due non si puo' creare lascia quella che c'era.
--
-- Quello che non fa lo scrive in @coupon_note, restituita dal blocco dopo l'ultima CALL a chi applica la patch a mano.
-- Le chiavi esterne verso coupon le aggiunge _202609301100.chiavi.esterne.sql, che viene dopo e le mette solo dove i
-- tipi coincidono. Le istruzioni condizionali stanno in procedure, perche' il task delle patch non esegue PREPARE ed
-- EXECUTE ( vedi quella patch ).
--
-- IDEMPOTENTE.

-- | 202609301030

-- coupon.codice, il codice che il cliente digita
ALTER TABLE `coupon`
    ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `id`,
    ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`);

-- | 202609301031

-- dove coupon.id e' ancora il codice ( modello di prima di marzo ) il codice e' l'id
UPDATE `coupon` SET `codice` = `id`
    WHERE `codice` IS NULL
    AND ( SELECT DATA_TYPE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'coupon' AND COLUMN_NAME = 'id' ) IN ( 'char', 'varchar' );

-- | 202609301032

-- la procedura delle colonne
-- la procedura che porta una colonna al tipo di coupon.id, se si puo' fare senza perdere niente
CREATE OR REPLACE PROCEDURE `__patch_coupon_colonna__`( IN tabella VARCHAR(64), IN colonna VARCHAR(64) )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE v_tipo_colonna, v_dato_colonna, v_tipo_coupon, v_dato_coupon VARCHAR(64) DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    SELECT COLUMN_TYPE, DATA_TYPE INTO v_tipo_colonna, v_dato_colonna
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = tabella AND COLUMN_NAME = colonna
        LIMIT 1;

    SELECT COLUMN_TYPE, DATA_TYPE INTO v_tipo_coupon, v_dato_coupon
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'coupon' AND COLUMN_NAME = 'id'
        LIMIT 1;

    IF v_tipo_colonna IS NULL OR v_tipo_coupon IS NULL THEN
        SET messaggio = 'la colonna o coupon.id non esistono';
    ELSEIF v_tipo_colonna = v_tipo_coupon THEN
        SET messaggio = NULL;
    ELSEIF v_dato_coupon NOT IN ( 'int', 'bigint', 'mediumint', 'smallint', 'tinyint' ) THEN
        SET messaggio = CONCAT( 'coupon.id e'' ', v_tipo_coupon, ' ( modello di prima di marzo ): colonna lasciata ', v_tipo_colonna );
    ELSE
        SET @coupon_non_numerici = 0;
        IF v_dato_colonna IN ( 'char', 'varchar' ) THEN
            SET @coupon_sql = CONCAT(
                'SELECT count(*) INTO @coupon_non_numerici FROM `', tabella, '` ',
                'WHERE `', colonna, '` IS NOT NULL AND `', colonna, '` <> '''' AND `', colonna, '` NOT REGEXP ''^[0-9]+$'''
            );
            PREPARE controllo FROM @coupon_sql;
            EXECUTE controllo;
            DEALLOCATE PREPARE controllo;
        END IF;
        IF messaggio IS NULL AND @coupon_non_numerici > 0 THEN
            SET messaggio = CONCAT( @coupon_non_numerici, ' righe con un valore non numerico: colonna lasciata ', v_tipo_colonna );
        ELSEIF messaggio IS NULL THEN
            IF v_dato_colonna IN ( 'char', 'varchar' ) THEN
                SET @coupon_sql = CONCAT( 'UPDATE `', tabella, '` SET `', colonna, '` = NULL WHERE `', colonna, '` = ''''' );
                PREPARE vuoti FROM @coupon_sql;
                EXECUTE vuoti;
                DEALLOCATE PREPARE vuoti;
            END IF;
            IF messaggio IS NULL THEN
                SET @coupon_sql = CONCAT( 'ALTER TABLE `', tabella, '` MODIFY `', colonna, '` ', v_tipo_coupon, ' DEFAULT NULL' );
                PREPARE converti FROM @coupon_sql;
                EXECUTE converti;
                DEALLOCATE PREPARE converti;
            END IF;
        END IF;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @coupon_note = CONCAT_WS( '\n', @coupon_note, CONCAT( tabella, '.', colonna, ': ', messaggio ) );
    END IF;

END;

-- | 202609301033

-- carrelli.id_coupon
CALL `__patch_coupon_colonna__`( 'carrelli', 'id_coupon' );

-- | 202609301034

-- carrelli_articoli.id_coupon
CALL `__patch_coupon_colonna__`( 'carrelli_articoli', 'id_coupon' );

-- | 202609301035

-- documenti.id_coupon
CALL `__patch_coupon_colonna__`( 'documenti', 'id_coupon' );

-- | 202609301036

-- pagamenti.id_coupon
CALL `__patch_coupon_colonna__`( 'pagamenti', 'id_coupon' );

-- | 202609301037

-- pianificazioni.model_id_coupon
CALL `__patch_coupon_colonna__`( 'pianificazioni', 'model_id_coupon' );

-- | 202609301038

-- la procedura delle viste
-- la procedura che prova a rifare una vista e, se non si puo', lo annota
CREATE OR REPLACE PROCEDURE `__patch_coupon_vista__`( IN istruzione LONGTEXT, IN oggetto VARCHAR(64) )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    SET @coupon_sql = istruzione;
    PREPARE prova FROM @coupon_sql;
    IF messaggio IS NULL THEN
        EXECUTE prova;
        DEALLOCATE PREPARE prova;
    END IF;

    IF messaggio IS NOT NULL THEN
        SET @coupon_note = CONCAT_WS( '\n', @coupon_note, CONCAT( oggetto, ': ', messaggio ) );
    END IF;

END;

-- | 202609301039

-- coupon_view
CALL `__patch_coupon_vista__`( '
CREATE OR REPLACE VIEW `coupon_view` AS
	SELECT
		coupon.id,
		coupon.codice,
		coupon.nome,
		coupon.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, '' '', a1.nome ), '''' ) AS anagrafica,
		coupon.timestamp_inizio,
		from_unixtime( coupon.timestamp_inizio, ''%Y-%m-%d'' ) AS data_ora_inizio,
		coupon.timestamp_fine,
		from_unixtime( coupon.timestamp_fine, ''%Y-%m-%d'' ) AS data_ora_fine,
		coupon.sconto_percentuale,
		coupon.sconto_fisso,
		coupon.se_multiuso,
		coupon.se_globale,
		coupon.se_vincolato,
		coupon.causale,
		coupon.causale_id_contratto,
		group_concat( DISTINCT categorie_progetti.id SEPARATOR ''|'' ) AS id_categorie_progetti,
		group_concat( DISTINCT categorie_progetti.nome SEPARATOR ''|'' ) AS categorie_progetti,
		group_concat( DISTINCT categorie_progetti_path_find_ancestor( categorie_progetti.id ) ) AS id_aree,
		group_concat( DISTINCT aree.nome ) AS aree,
		coupon.id_account_inserimento,
		coupon.timestamp_inserimento,
		coupon.id_account_aggiornamento,
		coupon.timestamp_aggiornamento,
		concat_ws( '' '', coupon.codice, coupon.nome ) AS __label__
	FROM coupon
		LEFT JOIN anagrafica AS a1 ON a1.id = coupon.id_anagrafica
		LEFT JOIN contratti ON contratti.id = coupon.causale_id_contratto
		LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN categorie_progetti ON ( categorie_progetti.id = progetti_categorie.id_categoria AND categorie_progetti.se_disciplina = 1 )
		LEFT JOIN categorie_progetti AS aree ON aree.id = categorie_progetti_path_find_ancestor( categorie_progetti.id )
	GROUP BY coupon.id
', 'coupon_view' );

-- | 202609301040

-- __report_utilizzi_coupon__
CALL `__patch_coupon_vista__`( '
CREATE OR REPLACE VIEW `__report_utilizzi_coupon__` AS
    SELECT
        coupon.id,
        ''carrelli'' AS tipo,
        concat ( ''carrello #'', carrelli.id ) AS riferimento,
        from_unixtime( carrelli.timestamp_pagamento, "%Y-%m-%d" ) AS data_pagamento,
        carrelli_articoli.id AS id_carrelli_articoli,
        NULL AS id_pagamento,
        coalesce( carrelli_articoli.prezzo_lordo_totale, 0 ) AS importo_lordo_totale,
        coalesce( carrelli_articoli.coupon_valore, 0 ) AS coupon_valore,
        coalesce( carrelli_articoli.prezzo_lordo_finale, 0 ) AS importo_lordo_finale
    FROM coupon
        INNER JOIN carrelli_articoli ON carrelli_articoli.id_coupon = coupon.id
        INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello

    UNION

    SELECT
        coupon.id,
        ''pagamenti'' AS tipo,
        concat ( ''documento n. '', documenti.numero, ''/'', documenti.sezionale, '' del '', documenti.data ) AS riferimento,
        from_unixtime( pagamenti.timestamp_pagamento, "%Y-%m-%d" ) AS data_pagamento,
        NULL AS id_carrelli_articoli,
        pagamenti.id AS id_pagamento,
        coalesce( pagamenti.importo_lordo_totale, 0 ) AS importo_lordo_totale,
        coalesce( pagamenti.coupon_valore, 0 ) AS coupon_valore,
        coalesce( pagamenti.importo_lordo_finale, 0 ) AS importo_lordo_finale
    FROM coupon
        INNER JOIN pagamenti ON pagamenti.id_coupon = coupon.id
        INNER JOIN documenti ON documenti.id = pagamenti.id_documento
', '__report_utilizzi_coupon__' );

-- | 202609301041

-- quello che non si e' potuto fare, e perche': lo legge chi applica la patch a mano
SELECT @coupon_note AS nota;

-- | 202609301042

-- si liberano le procedure
DROP PROCEDURE IF EXISTS `__patch_coupon_colonna__`;

-- | 202609301043

DROP PROCEDURE IF EXISTS `__patch_coupon_vista__`;

-- | FINE FILE
