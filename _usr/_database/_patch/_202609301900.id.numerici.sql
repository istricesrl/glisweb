-- 2026-09-30 — articoli, prodotti, progetti, coupon e consensi con l'id numerico e il codice nella sua colonna
--
-- Contesto: prima del 02/03/2026 l'id di articoli, prodotti, progetti, coupon e consensi era il loro codice
-- ( char( 32 ), char( 64 ) per i consensi ), e ogni colonna che li citava era testuale. Il riallineamento di marzo ha
-- reso quegli id numerici nei file di base, con il codice in una colonna codice, ma non ha portato niente ai deploy
-- installati prima, dove gli id sono ancora i codici. _202609301030.coupon.sql e _202609301700.consensi.sql hanno
-- dato a coupon e consensi la colonna codice, lasciando testuali gli id dove non erano numeri. La decisione di Fabio
-- ( punto 72 ): i valori non numerici vanno nella colonna codice e tutti i riferimenti devono essere sull'id
-- numerico, ovunque.
--
-- COSA FA, PER CIASCUNA DELLE CINQUE TABELLE ( la madre ).
--
-- -# se manca aggiunge la colonna codice, e dove l'id e' ancora testuale ci copia l'id ( solo dove codice e' vuoto );
-- -# riempie __mappatura_id__, che resta: per ogni vecchio id testuale il nuovo id numerico. Un id che e' gia' un
--    numero ( 1001, senza zeri davanti ) tiene lo stesso valore, cosi' URL e riferimenti esterni con quel numero
--    restano buoni; gli altri prendono, in ordine di id, i numeri che vengono dopo il piu' alto di quelli. Per i
--    consensi PRIVACY_POLICY, EVASIONE_ORDINE e INVIO_COMUNICAZIONI_MARKETING prendono 1, 2 e 3 come nei file di base;
-- -# trova le colonne che citano la madre: quelle dei file di base ( id_articolo, id_articolo_collegato,
--    id_componente, id_prodotto, id_prodotto_collegato, id_progetto, id_progetto_collegato, id_coupon, id_consenso e
--    le model_id_* ), cercate per nome in tutte le tabelle del deploy, quelle che hanno una chiave esterna verso la
--    madre, e l'id delle due copie articoli_view_static e corsi_view_static;
-- -# controlla prima di toccare: ogni valore di ogni colonna deve essere un id della madre ( un codice, dove la madre
--    e' numerica e la colonna testuale, come mastri_articoli.id_articolo ). Un valore che non lo e' ( riga orfana ) si
--    salva in __mappatura_id_orfani__ e diventa NULL; nelle copie ( *_view_static e __report_*__ ) la riga si
--    cancella se la colonna e' NOT NULL. Se c'e' un'orfana in una colonna NOT NULL di una tabella vera la madre non
--    si converte, e lo si scrive;
-- -# toglie le chiavi esterne verso la madre e quelle sulle colonne da convertire, e se le segna;
-- -# in una transazione traduce l'id della madre e tutte le colonne dal vecchio valore al nuovo; se una sola UPDATE
--    fallisce torna indietro tutto;
-- -# porta a bigint( 20 ) l'id della madre ( AUTO_INCREMENT come nei file di base, tranne consensi ) e le colonne;
-- -# rimette le chiavi esterne che il deploy aveva, con lo stesso nome e le stesse regole, poi aggiunge quelle dei
--    file di base che su una colonna mancano, con i controlli di _202609301100.chiavi.esterne.sql ( tipi uguali,
--    nome libero, nessuna orfana );
-- -# controlla dopo: colonne dello stesso tipo della madre e nessuna riga che cita un id che non c'e'; mette la
--    chiave UNIQUE su codice se i valori sono tutti diversi;
-- -# rifa le viste che mostrano l'id come se fosse il codice ( prodotti_view, progetti_view, relazioni_articoli_view,
--    relazioni_prodotti_view, modalita_spedizione_view, sconti_articoli_view ) solo se la loro definizione sul
--    deploy non legge ancora codice; se una non si puo' creare resta quella di prima.
--
-- Dove la madre e' gia' numerica non tocca gli id: porta solo le colonne rimaste testuali ( mastri_articoli, le
-- copie static e i report ) al tipo della madre, traducendo i codici negli id.
--
-- DOPO LA PATCH. Le copie __report_*__ con una chiave composta ( __report_giacenza_magazzini__.id e simili ) e gli
-- indici di ricerca vanno ripopolati con i loro task, e memcache va svuotata, perche' controller() legge le chiavi
-- esterne con mysqlCachedQuery(). I riferimenti fuori dal database ( URL con ?id=CODICE, nomi di file, log, sistemi
-- esterni ) si traducono con __mappatura_id__; per tornare indietro vedi _usr/_docs/_read/219.file.database.md.
--
-- Quello che non fa lo scrive in @id_numerici_note, restituita dal blocco dopo l'ultima CALL a chi applica la patch
-- a mano. Le istruzioni condizionali stanno in procedure, come in _202609301100.chiavi.esterne.sql; nessuna CALL
-- restituisce righe. Le tabelle di lavoro sono vere, non temporanee, perche' il task puo' riprendere su un'altra
-- connessione; si tolgono alla fine, tranne le due __mappatura_id*__.
--
-- COLLATION. Le tabelle di lavoro sono utf8_general_ci, i deploy spesso utf8_unicode_ci: ogni confronto fra
-- __mappatura_id__.vecchio_id e una colonna del deploy porta quest'ultima a utf8_general_ci ( CONVERT ... COLLATE ),
-- altrimenti il confronto si ferma con 1267 Illegal mix of collations; per la stessa ragione i parametri e le
-- variabili di testo delle procedure dichiarano utf8_general_ci, invece di prendere quella del database. Corretto il 2026-10-01: un deploy che si e'
-- fermato qui deve rifare i blocchi di questo file da 202609301900, perche' le procedure si ricreino corrette.
--
-- IDEMPOTENTE: una seconda esecuzione trova le madri numeriche, le colonne dello stesso tipo e le chiavi presenti, e
-- non fa niente.

-- | 202609301900

-- la mappatura vecchio id -> nuovo id, che resta per i riferimenti fuori dal database e per tornare indietro
CREATE TABLE IF NOT EXISTS `__mappatura_id__` (
  `tabella` char(64) NOT NULL,
  `vecchio_id` char(64) NOT NULL,
  `nuovo_id` bigint(20) NOT NULL,
  `timestamp_conversione` int(11) DEFAULT NULL,
  PRIMARY KEY (`tabella`,`vecchio_id`),
  UNIQUE KEY `nuovo_id` (`tabella`,`nuovo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202609301901

-- i valori che non citavano nessuna riga della madre, com'erano prima di diventare NULL
CREATE TABLE IF NOT EXISTS `__mappatura_id_orfani__` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tabella` char(64) NOT NULL,
  `colonna` char(64) NOT NULL,
  `riferimento` char(64) NOT NULL,
  `id_riga` char(64) DEFAULT NULL,
  `valore` char(64) DEFAULT NULL,
  `azione` char(16) DEFAULT NULL,
  `timestamp_conversione` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tabella` (`tabella`,`colonna`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202609301902

-- la lista di lavoro delle colonne: una riga per colonna che cita una madre, con quello che le si fa
CREATE TABLE IF NOT EXISTS `__patch_id_numerici_colonne__` (
  `riferimento` char(64) NOT NULL,
  `tabella` char(64) NOT NULL,
  `colonna` char(64) NOT NULL,
  `azione` char(16) DEFAULT NULL,
  `nullabile` char(3) DEFAULT NULL,
  `copia` tinyint(1) DEFAULT NULL,
  `orfane` int(11) DEFAULT NULL,
  `esito` char(255) DEFAULT NULL,
  PRIMARY KEY (`riferimento`,`tabella`,`colonna`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202609301903

-- la lista di lavoro dei vincoli: quelli dei file di base e quelli che la patch toglie dal deploy per rimetterli
CREATE TABLE IF NOT EXISTS `__patch_id_numerici_vincoli__` (
  `tabella` char(64) NOT NULL,
  `vincolo` char(64) NOT NULL,
  `colonna` char(64) NOT NULL,
  `riferimento` char(64) NOT NULL,
  `cancellazione` char(16) NOT NULL,
  `aggiornamento` char(16) NOT NULL,
  `origine` char(8) NOT NULL DEFAULT 'base',
  `esito` char(255) DEFAULT NULL,
  PRIMARY KEY (`tabella`,`vincolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 202609301904

-- i vincoli dei file di base verso le cinque madri
INSERT IGNORE INTO `__patch_id_numerici_vincoli__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento` ) VALUES
( 'annunci', 'annunci_ibfk_04_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' ),
( 'articoli_caratteristiche', 'articoli_caratteristiche_ibfk_01', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' ),
( 'audio', 'audio_ibfk_05', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_02_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' ),
( 'contenuti', 'contenuti_ibfk_04', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'conversazioni', 'conversazioni_ibfk_02_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' ),
( 'distinta', 'distinta_ibfk_01', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' ),
( 'distinta', 'distinta_ibfk_02_nofollow', 'id_componente', 'articoli', 'CASCADE', 'CASCADE' ),
( 'documenti_articoli', 'documenti_articoli_ibfk_10_nofollow', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'file', 'file_ibfk_04', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'immagini', 'immagini_ibfk_05', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'istruzioni', 'istruzioni_ibfk_03', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' ),
( 'macro', 'macro_ibfk_03', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'matricole', 'matricole_ibfk_03_nofollow', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'metadati', 'metadati_ibfk_08', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'metadati_articoli', 'metadati_articoli_ibfk_02', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'modalita_spedizione', 'modalita_spedizione_ibfk_05', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'prezzi', 'prezzi_ibfk_02', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' ),
( 'progetti', 'progetti_ibfk_06_nofollow', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'progetti_articoli', 'progetti_articoli_ibfk_02', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' ),
( 'pubblicazioni', 'pubblicazioni_ibfk_05', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'relazioni_articoli', 'relazioni_articoli_ibfk_01', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' ),
( 'relazioni_articoli', 'relazioni_articoli_ibfk_02', 'id_articolo_collegato', 'articoli', 'CASCADE', 'CASCADE' ),
( 'relazioni_prodotti', 'relazioni_prodotti_ibfk_04_nofollow', 'id_articolo_collegato', 'articoli', 'NO ACTION', 'CASCADE' ),
( 'risorse', 'risorse_ibfk_02_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' ),
( 'sconti_articoli', 'sconti_articoli_ibfk_02', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' ),
( 'software', 'software_ibfk_02_nofollow', 'id_articolo', 'articoli', 'CASCADE', 'CASCADE' ),
( 'video', 'video_ibfk_05', 'id_articolo', 'articoli', 'SET NULL', 'SET NULL' ),
( 'anagrafica_consensi', 'anagrafica_consensi_ibfk_03_nofollow', 'id_consenso', 'consensi', 'CASCADE', 'CASCADE' ),
( 'carrelli_consensi', 'carrelli_consensi_ibfk_04_nofollow', 'id_consenso', 'consensi', 'CASCADE', 'CASCADE' ),
( 'consensi_moduli', 'consensi_moduli_ibfk_02_nofollow', 'id_consenso', 'consensi', 'SET NULL', 'SET NULL' ),
( 'carrelli', 'carrelli_ibfk_17_nofollow', 'id_coupon', 'coupon', 'SET NULL', 'SET NULL' ),
( 'carrelli_articoli', 'carrelli_articoli_ibfk_13_nofollow', 'id_coupon', 'coupon', 'SET NULL', 'SET NULL' ),
( 'coupon_categorie_prodotti', 'coupon_categorie_prodotti_ibfk_01', 'id_coupon', 'coupon', 'CASCADE', 'CASCADE' ),
( 'coupon_listini', 'coupon_listini_ibfk_01', 'id_coupon', 'coupon', 'CASCADE', 'CASCADE' ),
( 'coupon_marchi', 'coupon_marchi_ibfk_01', 'id_coupon', 'coupon', 'CASCADE', 'CASCADE' ),
( 'coupon_prodotti', 'coupon_prodotti_ibfk_01', 'id_coupon', 'coupon', 'CASCADE', 'CASCADE' ),
( 'documenti', 'documenti_ibfk_06_nofollow', 'id_coupon', 'coupon', 'SET NULL', 'SET NULL' ),
( 'pagamenti', 'pagamenti_ibfk_12_nofollow', 'id_coupon', 'coupon', 'SET NULL', 'SET NULL' ),
( 'annunci', 'annunci_ibfk_03_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'articoli', 'articoli_ibfk_01_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'audio', 'audio_ibfk_04', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'contenuti', 'contenuti_ibfk_03', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'coupon_prodotti', 'coupon_prodotti_ibfk_02_nofollow', 'id_prodotto', 'prodotti', 'CASCADE', 'CASCADE' ),
( 'documenti_articoli', 'documenti_articoli_ibfk_18_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'file', 'file_ibfk_03', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'immagini', 'immagini_ibfk_04', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'istruzioni', 'istruzioni_ibfk_02', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'macro', 'macro_ibfk_02', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'metadati', 'metadati_ibfk_11', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'metadati_prodotti', 'metadati_prodotti_ibfk_02', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'modalita_spedizione', 'modalita_spedizione_ibfk_04', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'prezzi', 'prezzi_ibfk_01', 'id_prodotto', 'prodotti', 'CASCADE', 'CASCADE' ),
( 'prodotti_caratteristiche', 'prodotti_caratteristiche_ibfk_01', 'id_prodotto', 'prodotti', 'CASCADE', 'CASCADE' ),
( 'prodotti_categorie', 'prodotti_categorie_ibfk_01', 'id_prodotto', 'prodotti', 'CASCADE', 'CASCADE' ),
( 'progetti', 'progetti_ibfk_07_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'pubblicazioni', 'pubblicazioni_ibfk_04', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'relazioni_articoli', 'relazioni_articoli_ibfk_04', 'id_prodotto_collegato', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'relazioni_prodotti', 'relazioni_prodotti_ibfk_01', 'id_prodotto', 'prodotti', 'CASCADE', 'CASCADE' ),
( 'relazioni_prodotti', 'relazioni_prodotti_ibfk_02', 'id_prodotto_collegato', 'prodotti', 'CASCADE', 'CASCADE' ),
( 'risorse', 'risorse_ibfk_03_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_02_nofollow', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'video', 'video_ibfk_04', 'id_prodotto', 'prodotti', 'SET NULL', 'SET NULL' ),
( 'anagrafica_progetti', 'anagrafica_progetti_ibfk_02_nofollow', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE' ),
( 'attivita', 'attivita_ibfk_15_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'audio', 'audio_ibfk_16', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'contenuti', 'contenuti_ibfk_24', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'contratti', 'contratti_ibfk_04_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'contratti_progetti', 'contratti_progetti_ibfk_02_nofollow', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE' ),
( 'documenti_articoli', 'documenti_articoli_ibfk_07_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'file', 'file_ibfk_19', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'immagini', 'immagini_ibfk_16', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'macro', 'macro_ibfk_11', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'mastri', 'mastri_ibfk_06_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'metadati', 'metadati_ibfk_21', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'pianificazioni', 'pianificazioni_ibfk_01', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'progetti_anagrafica', 'progetti_anagrafica_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE' ),
( 'progetti_articoli', 'progetti_articoli_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE' ),
( 'progetti_categorie', 'progetti_categorie_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE' ),
( 'progetti_certificazioni', 'progetti_certificazioni_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE' ),
( 'progetti_matricole', 'progetti_matricole_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE' ),
( 'pubblicazioni', 'pubblicazioni_ibfk_13', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'relazioni_progetti', 'relazioni_progetti_ibfk_01', 'id_progetto', 'progetti', 'CASCADE', 'CASCADE' ),
( 'relazioni_progetti', 'relazioni_progetti_ibfk_02', 'id_progetto_collegato', 'progetti', 'CASCADE', 'CASCADE' ),
( 'rinnovi', 'rinnovi_ibfk_03', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'tipologie_contratti', 'tipologie_contratti_ibfk_03_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'todo', 'todo_ibfk_07_nofollow', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' ),
( 'video', 'video_ibfk_16', 'id_progetto', 'progetti', 'SET NULL', 'SET NULL' );

-- | 202609301905

-- le copie che hanno come id l'id della madre
INSERT IGNORE INTO `__patch_id_numerici_colonne__` ( `riferimento`, `tabella`, `colonna` ) VALUES
( 'articoli', 'articoli_view_static', 'id' ),
( 'progetti', 'corsi_view_static', 'id' );

-- | 202609301906

-- la procedura che esegue un'istruzione e ne annota l'errore in @id_numerici_errore invece di fermarsi
CREATE OR REPLACE PROCEDURE `__patch_id_numerici_esegui__`( IN istruzione LONGTEXT )
BEGIN

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @id_numerici_errore = MESSAGE_TEXT;
        END;

    SET @id_numerici_errore = NULL;
    SET @id_numerici_sql = istruzione;
    PREPARE istruzione_id_numerici FROM @id_numerici_sql;
    IF @id_numerici_errore IS NULL THEN
        EXECUTE istruzione_id_numerici;
        DEALLOCATE PREPARE istruzione_id_numerici;
    END IF;

END;

-- | 202609301907

-- la procedura della mappatura: codice e __mappatura_id__, solo dove l'id della madre e' ancora testuale
CREATE OR REPLACE PROCEDURE `__patch_id_numerici_mappa__`( IN p_tabella VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci )
BEGIN

    DECLARE v_dato_id VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;

    SET v_dato_id = ( SELECT DATA_TYPE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = p_tabella AND COLUMN_NAME = 'id' LIMIT 1 );

    IF v_dato_id IN ( 'char', 'varchar' ) THEN

        -- il codice e' il vecchio id, dove non ce n'e' gia' uno
        IF EXISTS ( SELECT 1 FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = p_tabella AND COLUMN_NAME = 'codice' ) THEN
            CALL `__patch_id_numerici_esegui__`( CONCAT(
                'UPDATE `', p_tabella, '` SET `codice` = `id` WHERE `codice` IS NULL OR `codice` = '''''
            ) );
            IF @id_numerici_errore IS NOT NULL THEN
                SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, '.codice: ', @id_numerici_errore ) );
            END IF;
            SET @id_numerici_conteggio = 0;
            CALL `__patch_id_numerici_esegui__`( CONCAT(
                'SELECT count(*) INTO @id_numerici_conteggio FROM `', p_tabella, '` WHERE `codice` <> `id`'
            ) );
            IF @id_numerici_conteggio > 0 THEN
                SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, ': ', @id_numerici_conteggio,
                    ' righe avevano gia'' un codice diverso dall''id, che resta; il vecchio id e'' in __mappatura_id__' ) );
            END IF;
        ELSE
            SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, ': manca la colonna codice' ) );
        END IF;

        -- gli id che sono gia' numeri tengono il loro valore
        CALL `__patch_id_numerici_esegui__`( CONCAT(
            'INSERT IGNORE INTO `__mappatura_id__` ( `tabella`, `vecchio_id`, `nuovo_id`, `timestamp_conversione` ) ',
            'SELECT ''', p_tabella, ''', `id`, CAST( `id` AS UNSIGNED ), unix_timestamp() FROM `', p_tabella, '` ',
            'WHERE `id` REGEXP ''^[1-9][0-9]{0,17}$'''
        ) );
        IF @id_numerici_errore IS NOT NULL THEN
            SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, ' mappatura degli id numerici: ', @id_numerici_errore ) );
        END IF;

        -- gli altri, in ordine di id, dopo il piu' alto gia' assegnato
        SET @id_numerici_base = ( SELECT coalesce( max( `nuovo_id` ), 0 ) FROM `__mappatura_id__` WHERE `tabella` = p_tabella );
        CALL `__patch_id_numerici_esegui__`( CONCAT(
            'INSERT INTO `__mappatura_id__` ( `tabella`, `vecchio_id`, `nuovo_id`, `timestamp_conversione` ) ',
            'SELECT ''', p_tabella, ''', t.`id`, @id_numerici_base + ROW_NUMBER() OVER ( ORDER BY t.`id` ), unix_timestamp() ',
            'FROM `', p_tabella, '` AS t ',
            'WHERE NOT EXISTS ( SELECT 1 FROM `__mappatura_id__` AS m WHERE m.`tabella` = ''', p_tabella, ''' AND m.`vecchio_id` = CONVERT( t.`id` USING utf8 ) COLLATE utf8_general_ci )'
        ) );
        IF @id_numerici_errore IS NOT NULL THEN
            SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, ' mappatura: ', @id_numerici_errore ) );
        END IF;

    END IF;

END;

-- | 202609301908

-- la procedura che trova le colonne che citano una madre: per nome in tutte le tabelle, e per chiave esterna
CREATE OR REPLACE PROCEDURE `__patch_id_numerici_elenco__`( IN p_tabella VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci, IN p_nomi VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_general_ci )
BEGIN

    INSERT IGNORE INTO `__patch_id_numerici_colonne__` ( `riferimento`, `tabella`, `colonna` )
        SELECT p_tabella, c.TABLE_NAME, c.COLUMN_NAME
        FROM information_schema.COLUMNS AS c
        INNER JOIN information_schema.TABLES AS t
            ON t.TABLE_SCHEMA = c.TABLE_SCHEMA AND t.TABLE_NAME = c.TABLE_NAME AND t.TABLE_TYPE = 'BASE TABLE'
        WHERE c.TABLE_SCHEMA = database()
          AND c.COLUMN_NAME REGEXP p_nomi
          AND c.TABLE_NAME NOT LIKE '\_\_patch\_%'
          AND c.TABLE_NAME NOT LIKE '\_\_mappatura\_%'
        UNION
        SELECT p_tabella, k.TABLE_NAME, k.COLUMN_NAME
        FROM information_schema.KEY_COLUMN_USAGE AS k
        WHERE k.TABLE_SCHEMA = database() AND k.REFERENCED_TABLE_NAME = p_tabella AND k.REFERENCED_COLUMN_NAME = 'id';

    -- le colonne e le copie che sul deploy non ci sono si tolgono dalla lista
    DELETE l FROM `__patch_id_numerici_colonne__` AS l
        WHERE l.`riferimento` = p_tabella
          AND NOT EXISTS ( SELECT 1 FROM information_schema.COLUMNS AS c
            WHERE c.TABLE_SCHEMA = database() AND c.TABLE_NAME = l.`tabella` AND c.COLUMN_NAME = l.`colonna` );

    -- le copie: le righe orfane si possono cancellare, perche' si ripopolano
    UPDATE `__patch_id_numerici_colonne__`
        SET `copia` = IF( `tabella` LIKE '%\_view\_static' OR `tabella` LIKE '\_\_report\_%', 1, 0 )
        WHERE `riferimento` = p_tabella;

END;

-- | 202609301909

-- la procedura che converte: controlli, chiavi esterne tolte, traduzione in una transazione, tipi
CREATE OR REPLACE PROCEDURE `__patch_id_numerici_converti__`( IN p_tabella VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci, IN p_autoincremento TINYINT )
converti: BEGIN

    DECLARE fine INT DEFAULT 0;
    DECLARE v_tabella, v_colonna, v_vincolo, v_riferimento VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_cancellazione, v_aggiornamento VARCHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_azione VARCHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_dato_id, v_tipo_id, v_tipo_finale, v_dato, v_tipo, v_nullabile VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE v_testuale, v_copia, v_ha_id, v_blocchi, v_errori INT DEFAULT 0;
    DECLARE v_traducibile, v_riga TEXT CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;

    DECLARE colonne CURSOR FOR
        SELECT `tabella`, `colonna`, `azione`, `nullabile`, `copia`
        FROM `__patch_id_numerici_colonne__`
        WHERE `riferimento` = p_tabella
        ORDER BY `tabella`, `colonna`;

    DECLARE vincoli CURSOR FOR
        SELECT k.TABLE_NAME, k.CONSTRAINT_NAME, k.COLUMN_NAME, k.REFERENCED_TABLE_NAME, r.DELETE_RULE, r.UPDATE_RULE
        FROM information_schema.KEY_COLUMN_USAGE AS k
        INNER JOIN information_schema.REFERENTIAL_CONSTRAINTS AS r
            ON r.CONSTRAINT_SCHEMA = k.CONSTRAINT_SCHEMA AND r.CONSTRAINT_NAME = k.CONSTRAINT_NAME AND r.TABLE_NAME = k.TABLE_NAME
        WHERE k.TABLE_SCHEMA = database() AND k.REFERENCED_TABLE_NAME IS NOT NULL
          AND (
            ( v_testuale = 1 AND k.REFERENCED_TABLE_NAME = p_tabella )
            OR EXISTS ( SELECT 1 FROM `__patch_id_numerici_colonne__` AS l
                WHERE l.`riferimento` = p_tabella AND l.`tabella` = k.TABLE_NAME AND l.`colonna` = k.COLUMN_NAME
                  AND l.`azione` IS NOT NULL )
          );

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fine = 1;

    SET v_dato_id = ( SELECT DATA_TYPE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = p_tabella AND COLUMN_NAME = 'id' LIMIT 1 );
    SET v_tipo_id = ( SELECT COLUMN_TYPE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = p_tabella AND COLUMN_NAME = 'id' LIMIT 1 );

    IF v_dato_id IS NULL THEN
        SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, ': la tabella o il suo id non esistono' ) );
        LEAVE converti;
    END IF;

    SET v_testuale = IF( v_dato_id IN ( 'char', 'varchar' ), 1, 0 );
    SET v_tipo_finale = IF( v_testuale = 1, 'bigint(20)', v_tipo_id );

    -- quando un valore della colonna t.c cita una riga della madre: il vecchio id nella mappatura, dove la madre e'
    -- testuale; un id che esiste o un codice, dove e' numerica
    IF v_testuale = 1 THEN
        SET v_traducibile = CONCAT( 'EXISTS ( SELECT 1 FROM `__mappatura_id__` AS m WHERE m.`tabella` = ''', p_tabella, ''' AND m.`vecchio_id` = CONVERT( t.`@@` USING utf8 ) COLLATE utf8_general_ci )' );
    ELSE
        SET v_traducibile = CONCAT(
            '( ( CONCAT( t.`@@` ) REGEXP ''^[0-9]+$'' AND EXISTS ( SELECT 1 FROM `', p_tabella, '` AS padri WHERE padri.`id` = t.`@@` ) ) ',
            'OR EXISTS ( SELECT 1 FROM `', p_tabella, '` AS padri WHERE padri.`codice` = t.`@@` ) )'
        );
    END IF;

    -- 1. cosa fare di ogni colonna, e le orfane: nessuna modifica finche' i controlli non sono passati tutti
    SET fine = 0;
    OPEN colonne;
    ciclo: LOOP
        FETCH colonne INTO v_tabella, v_colonna, v_azione, v_nullabile, v_copia;
        IF fine = 1 THEN
            LEAVE ciclo;
        END IF;
        SET v_dato = ( SELECT DATA_TYPE FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna LIMIT 1 );
        SET v_tipo = ( SELECT COLUMN_TYPE FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna LIMIT 1 );
        SET v_nullabile = ( SELECT IS_NULLABLE FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna LIMIT 1 );
        SET v_azione = NULL;
        IF v_dato IN ( 'char', 'varchar' ) OR ( v_testuale = 1 AND v_dato IN ( 'int', 'bigint', 'mediumint', 'smallint', 'tinyint' ) ) THEN
            SET v_azione = 'traduci';
        ELSEIF v_dato IN ( 'int', 'bigint', 'mediumint', 'smallint', 'tinyint' ) AND v_tipo <> v_tipo_finale THEN
            SET v_azione = 'allarga';
        ELSEIF v_dato NOT IN ( 'int', 'bigint', 'mediumint', 'smallint', 'tinyint' ) THEN
            SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( v_tabella, '.', v_colonna, ': tipo ', v_tipo, ', lasciata' ) );
        END IF;
        SET @id_numerici_conteggio = 0;
        IF v_azione = 'traduci' THEN
            CALL `__patch_id_numerici_esegui__`( CONCAT(
                'SELECT count(*) INTO @id_numerici_conteggio FROM `', v_tabella, '` AS t ',
                'WHERE t.`', v_colonna, '` IS NOT NULL ',
                IF( v_nullabile = 'YES' AND v_dato IN ( 'char', 'varchar' ), CONCAT( 'AND t.`', v_colonna, '` <> '''' ' ), '' ),
                'AND NOT ', REPLACE( v_traducibile, '@@', v_colonna )
            ) );
            IF @id_numerici_errore IS NOT NULL THEN
                SET v_blocchi = v_blocchi + 1;
                SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( v_tabella, '.', v_colonna, ': controllo fallito, ', @id_numerici_errore ) );
            ELSEIF @id_numerici_conteggio > 0 AND v_nullabile = 'NO' AND v_copia = 0 THEN
                SET v_blocchi = v_blocchi + 1;
                SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( v_tabella, '.', v_colonna, ': ', @id_numerici_conteggio,
                    ' righe citano un ', p_tabella, ' che non esiste e la colonna e'' NOT NULL: vanno sistemate a mano' ) );
            END IF;
        END IF;
        UPDATE `__patch_id_numerici_colonne__` SET `azione` = v_azione, `nullabile` = v_nullabile, `orfane` = @id_numerici_conteggio
            WHERE `riferimento` = p_tabella AND `tabella` = v_tabella AND `colonna` = v_colonna;
    END LOOP;
    CLOSE colonne;

    IF v_blocchi > 0 THEN
        SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, ': non convertita, niente e'' stato convertito' ) );
        LEAVE converti;
    END IF;

    -- 2. le chiavi esterne che impedirebbero di cambiare i tipi: si segnano, per rimetterle, e si tolgono
    SET fine = 0;
    OPEN vincoli;
    ciclo: LOOP
        FETCH vincoli INTO v_tabella, v_vincolo, v_colonna, v_riferimento, v_cancellazione, v_aggiornamento;
        IF fine = 1 THEN
            LEAVE ciclo;
        END IF;
        INSERT INTO `__patch_id_numerici_vincoli__` ( `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `origine`, `esito` )
            VALUES ( v_tabella, v_vincolo, v_colonna, v_riferimento, v_cancellazione, v_aggiornamento, 'deploy', NULL )
            ON DUPLICATE KEY UPDATE `colonna` = v_colonna, `riferimento` = v_riferimento, `cancellazione` = v_cancellazione,
                `aggiornamento` = v_aggiornamento, `origine` = 'deploy', `esito` = NULL;
        CALL `__patch_id_numerici_esegui__`( CONCAT( 'ALTER TABLE `', v_tabella, '` DROP FOREIGN KEY `', v_vincolo, '`' ) );
        IF @id_numerici_errore IS NOT NULL THEN
            SET v_errori = v_errori + 1;
            SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( v_vincolo, ': non si toglie, ', @id_numerici_errore ) );
        END IF;
    END LOOP;
    CLOSE vincoli;

    IF v_errori > 0 THEN
        SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, ': non convertita, le chiavi tolte si rimettono' ) );
        LEAVE converti;
    END IF;

    -- 3. la traduzione, tutta o niente
    SET @id_numerici_orfani_prima = ( SELECT count(*) FROM `__mappatura_id_orfani__` WHERE `riferimento` = p_tabella );
    START TRANSACTION;

    IF v_testuale = 1 THEN
        CALL `__patch_id_numerici_esegui__`( CONCAT(
            'UPDATE `', p_tabella, '` AS t INNER JOIN `__mappatura_id__` AS m ON m.`tabella` = ''', p_tabella, ''' AND m.`vecchio_id` = CONVERT( t.`id` USING utf8 ) COLLATE utf8_general_ci ',
            'SET t.`id` = m.`nuovo_id`'
        ) );
        IF @id_numerici_errore IS NOT NULL THEN
            SET v_errori = v_errori + 1;
            SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, '.id: ', @id_numerici_errore ) );
        END IF;
    END IF;

    SET fine = 0;
    OPEN colonne;
    ciclo: LOOP
        FETCH colonne INTO v_tabella, v_colonna, v_azione, v_nullabile, v_copia;
        IF fine = 1 OR v_errori > 0 THEN
            LEAVE ciclo;
        END IF;
        IF v_azione = 'traduci' THEN
            SET v_dato = ( SELECT DATA_TYPE FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna LIMIT 1 );
            SET v_ha_id = IF( v_colonna <> 'id' AND EXISTS ( SELECT 1 FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = 'id' ), 1, 0 );
            SET v_riga = IF( v_ha_id = 1, 'CONCAT( t.`id` )', 'NULL' );
            -- i vuoti sono NULL
            IF v_nullabile = 'YES' AND v_dato IN ( 'char', 'varchar' ) THEN
                CALL `__patch_id_numerici_esegui__`( CONCAT( 'UPDATE `', v_tabella, '` SET `', v_colonna, '` = NULL WHERE `', v_colonna, '` = ''''' ) );
                IF @id_numerici_errore IS NOT NULL THEN
                    SET v_errori = v_errori + 1;
                END IF;
            END IF;
            -- le orfane si salvano, poi diventano NULL ( o, nelle copie con la colonna NOT NULL, si cancellano )
            IF v_errori = 0 THEN
                CALL `__patch_id_numerici_esegui__`( CONCAT(
                    'INSERT INTO `__mappatura_id_orfani__` ( `tabella`, `colonna`, `riferimento`, `id_riga`, `valore`, `azione`, `timestamp_conversione` ) ',
                    'SELECT ''', v_tabella, ''', ''', v_colonna, ''', ''', p_tabella, ''', ', v_riga, ', t.`', v_colonna, '`, ',
                    IF( v_nullabile = 'YES', '''annullata''', '''cancellata''' ), ', unix_timestamp() ',
                    'FROM `', v_tabella, '` AS t WHERE t.`', v_colonna, '` IS NOT NULL AND NOT ', REPLACE( v_traducibile, '@@', v_colonna )
                ) );
                IF @id_numerici_errore IS NOT NULL THEN
                    SET v_errori = v_errori + 1;
                END IF;
            END IF;
            IF v_errori = 0 THEN
                CALL `__patch_id_numerici_esegui__`( CONCAT(
                    IF( v_nullabile = 'YES',
                        CONCAT( 'UPDATE `', v_tabella, '` AS t SET t.`', v_colonna, '` = NULL ' ),
                        CONCAT( 'DELETE t FROM `', v_tabella, '` AS t ' ) ),
                    'WHERE t.`', v_colonna, '` IS NOT NULL AND NOT ', REPLACE( v_traducibile, '@@', v_colonna )
                ) );
                IF @id_numerici_errore IS NOT NULL THEN
                    SET v_errori = v_errori + 1;
                END IF;
            END IF;
            -- la traduzione
            IF v_errori = 0 AND v_testuale = 1 THEN
                CALL `__patch_id_numerici_esegui__`( CONCAT(
                    'UPDATE `', v_tabella, '` AS t INNER JOIN `__mappatura_id__` AS m ',
                    'ON m.`tabella` = ''', p_tabella, ''' AND m.`vecchio_id` = CONVERT( t.`', v_colonna, '` USING utf8 ) COLLATE utf8_general_ci ',
                    'SET t.`', v_colonna, '` = m.`nuovo_id`'
                ) );
            ELSEIF v_errori = 0 THEN
                CALL `__patch_id_numerici_esegui__`( CONCAT(
                    'UPDATE `', v_tabella, '` AS t INNER JOIN `', p_tabella, '` AS padri ON padri.`codice` = t.`', v_colonna, '` ',
                    'SET t.`', v_colonna, '` = padri.`id` WHERE t.`', v_colonna, '` NOT REGEXP ''^[0-9]+$'''
                ) );
            END IF;
            IF v_errori = 0 AND @id_numerici_errore IS NOT NULL THEN
                SET v_errori = v_errori + 1;
            END IF;
            IF v_errori > 0 THEN
                SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( v_tabella, '.', v_colonna, ': ', @id_numerici_errore ) );
            END IF;
        END IF;
    END LOOP;
    CLOSE colonne;

    IF v_errori > 0 THEN
        ROLLBACK;
        SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, ': traduzione annullata, i dati sono quelli di prima; le chiavi tolte si rimettono' ) );
        LEAVE converti;
    END IF;

    COMMIT;

    SET @id_numerici_conteggio = ( SELECT count(*) FROM `__mappatura_id_orfani__` WHERE `riferimento` = p_tabella ) - @id_numerici_orfani_prima;
    IF @id_numerici_conteggio > 0 THEN
        SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, ': ', @id_numerici_conteggio,
            ' valori che non citavano nessuna riga sono in __mappatura_id_orfani__' ) );
    END IF;

    -- 4. i tipi: prima la madre, poi le colonne
    IF v_testuale = 1 THEN
        CALL `__patch_id_numerici_esegui__`( CONCAT(
            'ALTER TABLE `', p_tabella, '` MODIFY `id` bigint(20) NOT NULL', IF( p_autoincremento = 1, ' AUTO_INCREMENT', '' )
        ) );
        IF @id_numerici_errore IS NOT NULL THEN
            SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, '.id: tradotto ma non portato a bigint, ', @id_numerici_errore ) );
            LEAVE converti;
        END IF;
    END IF;

    SET fine = 0;
    OPEN colonne;
    ciclo: LOOP
        FETCH colonne INTO v_tabella, v_colonna, v_azione, v_nullabile, v_copia;
        IF fine = 1 THEN
            LEAVE ciclo;
        END IF;
        IF v_azione IN ( 'traduci', 'allarga' ) THEN
            CALL `__patch_id_numerici_esegui__`( CONCAT(
                'ALTER TABLE `', v_tabella, '` MODIFY `', v_colonna, '` ', v_tipo_finale,
                IF( v_nullabile = 'YES', ' DEFAULT NULL', ' NOT NULL' )
            ) );
            UPDATE `__patch_id_numerici_colonne__` SET `esito` = IF( @id_numerici_errore IS NULL, 'convertita', LEFT( @id_numerici_errore, 255 ) )
                WHERE `riferimento` = p_tabella AND `tabella` = v_tabella AND `colonna` = v_colonna;
            IF @id_numerici_errore IS NOT NULL THEN
                SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( v_tabella, '.', v_colonna, ': tradotta ma non portata a ', v_tipo_finale, ', ', @id_numerici_errore ) );
            END IF;
        END IF;
    END LOOP;
    CLOSE colonne;

END;

-- | 202609301910

-- la procedura che rimette le chiavi esterne del deploy e aggiunge quelle dei file di base che mancano
CREATE OR REPLACE PROCEDURE `__patch_id_numerici_chiavi__`( IN p_tabella VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci )
BEGIN

    DECLARE fine INT DEFAULT 0;
    DECLARE v_tabella, v_vincolo, v_colonna, v_riferimento VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_cancellazione, v_aggiornamento VARCHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_origine VARCHAR(8) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_tipo_figlia, v_tipo_padre, v_nullabile VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE v_esito VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE v_indice TEXT CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;

    DECLARE lista CURSOR FOR
        SELECT `tabella`, `vincolo`, `colonna`, `riferimento`, `cancellazione`, `aggiornamento`, `origine`
        FROM `__patch_id_numerici_vincoli__` AS v
        WHERE v.`esito` IS NULL
          AND ( v.`riferimento` = p_tabella OR EXISTS ( SELECT 1 FROM `__patch_id_numerici_colonne__` AS l
            WHERE l.`riferimento` = p_tabella AND l.`tabella` = v.`tabella` AND l.`colonna` = v.`colonna` ) )
        ORDER BY IF( v.`origine` = 'deploy', 0, 1 ), v.`tabella`, v.`vincolo`;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fine = 1;

    SET @id_numerici_controlli = @@foreign_key_checks;

    OPEN lista;

    ciclo: LOOP

        FETCH lista INTO v_tabella, v_vincolo, v_colonna, v_riferimento, v_cancellazione, v_aggiornamento, v_origine;
        IF fine = 1 THEN
            LEAVE ciclo;
        END IF;

        SET v_esito = NULL, v_indice = NULL;
        SET v_tipo_figlia = ( SELECT COLUMN_TYPE FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna LIMIT 1 );
        SET v_nullabile = ( SELECT IS_NULLABLE FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna LIMIT 1 );
        SET v_tipo_padre = ( SELECT COLUMN_TYPE FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_riferimento AND COLUMN_NAME = 'id' LIMIT 1 );

        IF v_tipo_figlia IS NULL OR v_tipo_padre IS NULL THEN
            -- i vincoli dei file di base su tabelle che il deploy non ha: li ha gia' annotati _202609301100
            SET v_esito = IF( v_origine = 'deploy', CONCAT( 'non esiste ', v_tabella, '.', v_colonna, ' o ', v_riferimento, '.id' ), 'assente' );
        ELSEIF EXISTS ( SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna
              AND REFERENCED_TABLE_NAME IS NOT NULL ) THEN
            SET v_esito = 'presente';
        ELSEIF EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
            WHERE CONSTRAINT_SCHEMA = database() AND CONSTRAINT_NAME = v_vincolo ) THEN
            SET v_esito = 'il nome e'' gia'' usato da un altro vincolo';
        ELSEIF v_tipo_figlia <> v_tipo_padre THEN
            SET v_esito = CONCAT( 'tipi diversi, ', v_tabella, '.', v_colonna, ' ', v_tipo_figlia, ' e ', v_riferimento, '.id ', v_tipo_padre );
        ELSEIF v_cancellazione = 'SET NULL' AND v_nullabile = 'NO' THEN
            SET v_esito = CONCAT( v_tabella, '.', v_colonna, ' e'' NOT NULL e il vincolo e'' ON DELETE SET NULL' );
        END IF;

        -- righe orfane
        IF v_esito IS NULL THEN
            SET @id_numerici_conteggio = NULL;
            CALL `__patch_id_numerici_esegui__`( CONCAT(
                'SELECT count(*) INTO @id_numerici_conteggio FROM `', v_tabella, '` AS figlie ',
                'LEFT JOIN `', v_riferimento, '` AS padri ON padri.`id` = figlie.`', v_colonna, '` ',
                'WHERE figlie.`', v_colonna, '` IS NOT NULL AND padri.`id` IS NULL'
            ) );
            IF @id_numerici_errore IS NOT NULL THEN
                SET v_esito = LEFT( CONCAT( 'controllo delle righe orfane fallito: ', @id_numerici_errore ), 255 );
            ELSEIF @id_numerici_conteggio > 0 THEN
                SET v_esito = CONCAT( @id_numerici_conteggio, ' righe di ', v_tabella, ' con un ', v_colonna, ' che non esiste in ', v_riferimento );
            END IF;
        END IF;

        -- il vincolo, con il suo indice se la colonna non ne ha uno
        IF v_esito IS NULL THEN
            IF NOT EXISTS ( SELECT 1 FROM information_schema.STATISTICS
                WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna AND SEQ_IN_INDEX = 1
            ) AND NOT EXISTS ( SELECT 1 FROM information_schema.STATISTICS
                WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND INDEX_NAME = v_colonna
            ) THEN
                SET v_indice = CONCAT( 'ADD KEY `', v_colonna, '` (`', v_colonna, '`), ' );
            END IF;
            SET foreign_key_checks = 0;
            CALL `__patch_id_numerici_esegui__`( CONCAT(
                'ALTER TABLE `', v_tabella, '` ', IFNULL( v_indice, '' ),
                'ADD CONSTRAINT `', v_vincolo, '` FOREIGN KEY (`', v_colonna, '`) REFERENCES `', v_riferimento, '` (`id`) ',
                'ON DELETE ', v_cancellazione, ' ON UPDATE ', v_aggiornamento
            ) );
            SET foreign_key_checks = @id_numerici_controlli;
            IF @id_numerici_errore IS NOT NULL THEN
                SET v_esito = LEFT( CONCAT( 'ALTER TABLE fallita: ', @id_numerici_errore ), 255 );
            ELSE
                SET v_esito = IF( v_origine = 'deploy', 'rimesso', 'aggiunto' );
            END IF;
        END IF;

        UPDATE `__patch_id_numerici_vincoli__` SET `esito` = v_esito
            WHERE `tabella` = v_tabella AND `vincolo` = v_vincolo;

        IF v_esito NOT IN ( 'presente', 'aggiunto', 'rimesso', 'assente' ) THEN
            SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( v_vincolo,
                IF( v_origine = 'deploy', CONCAT( ' ( del deploy: ', v_tabella, '.', v_colonna, ' -> ', v_riferimento,
                    ', ON DELETE ', v_cancellazione, ' ON UPDATE ', v_aggiornamento, ' )' ), '' ),
                ': ', v_esito ) );
        END IF;

    END LOOP;

    CLOSE lista;

    SET foreign_key_checks = @id_numerici_controlli;

END;

-- | 202609301911

-- la procedura dei controlli dopo: tipi, righe orfane, e la chiave UNIQUE su codice
CREATE OR REPLACE PROCEDURE `__patch_id_numerici_controllo__`( IN p_tabella VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci )
BEGIN

    DECLARE fine INT DEFAULT 0;
    DECLARE v_tabella, v_colonna VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci;
    DECLARE v_tipo_id, v_dato_id, v_tipo VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;

    DECLARE colonne CURSOR FOR
        SELECT `tabella`, `colonna` FROM `__patch_id_numerici_colonne__`
        WHERE `riferimento` = p_tabella ORDER BY `tabella`, `colonna`;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fine = 1;

    SET v_tipo_id = ( SELECT COLUMN_TYPE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = p_tabella AND COLUMN_NAME = 'id' LIMIT 1 );
    SET v_dato_id = ( SELECT DATA_TYPE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = p_tabella AND COLUMN_NAME = 'id' LIMIT 1 );

    IF v_dato_id IN ( 'char', 'varchar' ) THEN
        SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( 'CONTROLLO ', p_tabella, '.id e'' ancora ', v_tipo_id ) );
    END IF;

    -- ogni colonna dello stesso tipo della madre, e nessuna riga che cita un id che non c'e'
    OPEN colonne;
    ciclo: LOOP
        FETCH colonne INTO v_tabella, v_colonna;
        IF fine = 1 THEN
            LEAVE ciclo;
        END IF;
        SET v_tipo = ( SELECT COLUMN_TYPE FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = v_tabella AND COLUMN_NAME = v_colonna LIMIT 1 );
        IF v_tipo <> v_tipo_id THEN
            SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( 'CONTROLLO ', v_tabella, '.', v_colonna, ' e'' ', v_tipo, ', ', p_tabella, '.id ', v_tipo_id ) );
        ELSE
            SET @id_numerici_conteggio = 0;
            CALL `__patch_id_numerici_esegui__`( CONCAT(
                'SELECT count(*) INTO @id_numerici_conteggio FROM `', v_tabella, '` AS figlie ',
                'LEFT JOIN `', p_tabella, '` AS padri ON padri.`id` = figlie.`', v_colonna, '` ',
                'WHERE figlie.`', v_colonna, '` IS NOT NULL AND padri.`id` IS NULL'
            ) );
            IF @id_numerici_errore IS NOT NULL OR @id_numerici_conteggio > 0 THEN
                SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( 'CONTROLLO ', v_tabella, '.', v_colonna, ': ',
                    coalesce( @id_numerici_errore, CONCAT( @id_numerici_conteggio, ' righe citano un ', p_tabella, ' che non esiste' ) ) ) );
            END IF;
        END IF;
    END LOOP;
    CLOSE colonne;

    -- il codice identifica la riga: la chiave UNIQUE, se i valori sono tutti diversi e non ce n'e' gia' una
    IF EXISTS ( SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = p_tabella AND COLUMN_NAME = 'codice'
    ) AND NOT EXISTS ( SELECT 1 FROM information_schema.STATISTICS AS s
        WHERE s.TABLE_SCHEMA = database() AND s.TABLE_NAME = p_tabella AND s.COLUMN_NAME = 'codice' AND s.NON_UNIQUE = 0
          AND NOT EXISTS ( SELECT 1 FROM information_schema.STATISTICS AS a
            WHERE a.TABLE_SCHEMA = s.TABLE_SCHEMA AND a.TABLE_NAME = s.TABLE_NAME AND a.INDEX_NAME = s.INDEX_NAME AND a.COLUMN_NAME <> 'codice' )
    ) THEN
        SET @id_numerici_conteggio = 0;
        CALL `__patch_id_numerici_esegui__`( CONCAT(
            'SELECT count(*) INTO @id_numerici_conteggio FROM ( SELECT `codice` FROM `', p_tabella, '` ',
            'WHERE `codice` IS NOT NULL GROUP BY `codice` HAVING count(*) > 1 ) AS doppi'
        ) );
        IF @id_numerici_errore IS NULL AND @id_numerici_conteggio = 0 THEN
            CALL `__patch_id_numerici_esegui__`( CONCAT(
                'ALTER TABLE `', p_tabella, '` ',
                IF( EXISTS ( SELECT 1 FROM information_schema.STATISTICS
                    WHERE TABLE_SCHEMA = database() AND TABLE_NAME = p_tabella AND INDEX_NAME = 'codice' ), 'DROP KEY `codice`, ', '' ),
                'ADD UNIQUE KEY `codice` (`codice`)'
            ) );
        END IF;
        IF @id_numerici_errore IS NOT NULL OR @id_numerici_conteggio > 0 THEN
            SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( p_tabella, '.codice: UNIQUE non aggiunta, ',
                coalesce( @id_numerici_errore, CONCAT( @id_numerici_conteggio, ' codici ripetuti' ) ) ) );
        END IF;
    END IF;

END;

-- | 202609301912

-- la procedura delle viste
-- la procedura che rifa una vista che mostra l'id come codice, se sul deploy non legge ancora codice
CREATE OR REPLACE PROCEDURE `__patch_id_numerici_vista__`( IN istruzione LONGTEXT, IN oggetto VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci )
BEGIN

    IF NOT EXISTS ( SELECT 1 FROM information_schema.VIEWS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = oggetto AND VIEW_DEFINITION LIKE '%`codice`%' ) THEN
        CALL `__patch_id_numerici_esegui__`( istruzione );
        IF @id_numerici_errore IS NOT NULL THEN
            SET @id_numerici_note = CONCAT_WS( '\n', @id_numerici_note, CONCAT( oggetto, ': resta quella di prima, ', @id_numerici_errore ) );
        END IF;
    END IF;

END;

-- | 202609301913

-- articoli.codice, che _202609281000.articoli.nome.doppio.sql aggiunge gia'
ALTER TABLE `articoli` ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `id`;

-- | 202609301914

-- prodotti.codice
ALTER TABLE `prodotti` ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `id`;

-- | 202609301915

-- progetti.codice
ALTER TABLE `progetti` ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `id`;

-- | 202609301916

-- si parte senza note
SET @id_numerici_note = NULL;

-- | 202609301920

-- prodotti: la mappatura
CALL `__patch_id_numerici_mappa__`( 'prodotti' );

-- | 202609301921

-- prodotti: le colonne
CALL `__patch_id_numerici_elenco__`( 'prodotti', '^(model_)?id_prodotto(_collegato)?$' );

-- | 202609301922

-- prodotti: la conversione
CALL `__patch_id_numerici_converti__`( 'prodotti', 1 );

-- | 202609301923

-- prodotti: le chiavi esterne
CALL `__patch_id_numerici_chiavi__`( 'prodotti' );

-- | 202609301924

-- prodotti: i controlli
CALL `__patch_id_numerici_controllo__`( 'prodotti' );

-- | 202609301925

-- articoli: la mappatura
CALL `__patch_id_numerici_mappa__`( 'articoli' );

-- | 202609301926

-- articoli: le colonne; id_componente e' l'articolo componente della distinta
CALL `__patch_id_numerici_elenco__`( 'articoli', '^(model_)?id_articolo(_collegato)?$|^id_componente$' );

-- | 202609301927

-- articoli: la conversione
CALL `__patch_id_numerici_converti__`( 'articoli', 1 );

-- | 202609301928

-- articoli: le chiavi esterne
CALL `__patch_id_numerici_chiavi__`( 'articoli' );

-- | 202609301929

-- articoli: i controlli
CALL `__patch_id_numerici_controllo__`( 'articoli' );

-- | 202609301930

-- progetti: la mappatura
CALL `__patch_id_numerici_mappa__`( 'progetti' );

-- | 202609301931

-- progetti: le colonne
CALL `__patch_id_numerici_elenco__`( 'progetti', '^(model_)?id_progetto(_collegato)?$' );

-- | 202609301932

-- progetti: la conversione
CALL `__patch_id_numerici_converti__`( 'progetti', 1 );

-- | 202609301933

-- progetti: le chiavi esterne
CALL `__patch_id_numerici_chiavi__`( 'progetti' );

-- | 202609301934

-- progetti: i controlli
CALL `__patch_id_numerici_controllo__`( 'progetti' );

-- | 202609301935

-- coupon: la mappatura
CALL `__patch_id_numerici_mappa__`( 'coupon' );

-- | 202609301936

-- coupon: le colonne
CALL `__patch_id_numerici_elenco__`( 'coupon', '^(model_)?id_coupon$' );

-- | 202609301937

-- coupon: la conversione
CALL `__patch_id_numerici_converti__`( 'coupon', 1 );

-- | 202609301938

-- coupon: le chiavi esterne
CALL `__patch_id_numerici_chiavi__`( 'coupon' );

-- | 202609301939

-- coupon: i controlli
CALL `__patch_id_numerici_controllo__`( 'coupon' );

-- | 202609301940

-- consensi: i tre consensi standard prendono gli id dei file di base, se nessun altro consenso ha quel numero
INSERT IGNORE INTO `__mappatura_id__` ( `tabella`, `vecchio_id`, `nuovo_id`, `timestamp_conversione` )
    SELECT 'consensi', c.`id`, v.`id`, unix_timestamp()
    FROM `consensi` AS c
    INNER JOIN (
        SELECT 1 AS `id`, 'PRIVACY_POLICY' AS `codice`
        UNION ALL SELECT 2, 'EVASIONE_ORDINE'
        UNION ALL SELECT 3, 'INVIO_COMUNICAZIONI_MARKETING'
    ) AS v ON v.`codice` = c.`id`
    WHERE ( SELECT DATA_TYPE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'consensi' AND COLUMN_NAME = 'id' ) IN ( 'char', 'varchar' )
    AND NOT EXISTS ( SELECT 1 FROM ( SELECT `id` FROM `consensi` ) AS e WHERE e.`id` = CAST( v.`id` AS CHAR ) );

-- | 202609301941

-- consensi: la mappatura
CALL `__patch_id_numerici_mappa__`( 'consensi' );

-- | 202609301942

-- consensi: le colonne
CALL `__patch_id_numerici_elenco__`( 'consensi', '^id_consenso$' );

-- | 202609301943

-- consensi: la conversione, senza AUTO_INCREMENT come nei file di base
CALL `__patch_id_numerici_converti__`( 'consensi', 0 );

-- | 202609301944

-- consensi: le chiavi esterne
CALL `__patch_id_numerici_chiavi__`( 'consensi' );

-- | 202609301945

-- consensi: i controlli
CALL `__patch_id_numerici_controllo__`( 'consensi' );

-- | 202609301950

-- prodotti_view
CALL `__patch_id_numerici_vista__`( '
CREATE OR REPLACE VIEW `prodotti_view` AS
	SELECT
		pubblicazioni.id_tipologia AS id_tipologia_pubblicazione,
		tipologie_pubblicazioni.nome AS pubblicazione,
		prodotti.id,
		prodotti.codice,
		prodotti.id_tipologia,
		tipologie_prodotti.nome AS tipologia,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		prodotti.nome,
		prodotti.id_marchio,
		marchi.nome AS marchio,
		prodotti.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, '' '', a1.nome ), '''' ) AS produttore,
		prodotti.codice_produttore,
		coalesce( ( SELECT group_concat( DISTINCT categorie_prodotti_path( pc.id_categoria ) SEPARATOR '' | '' )
			FROM prodotti_categorie AS pc
		   WHERE pc.id_prodotto = prodotti.id
		), '''' ) AS categorie,
		prodotti.id_sito,
		prodotti.template,
		prodotti.schema_html,
		prodotti.tema_css,
		prodotti.se_sitemap,
		prodotti.se_cacheable,
        prodotti.data_archiviazione,
		prodotti.id_account_inserimento,
		prodotti.id_account_aggiornamento,
		concat_ws(
			'' '',
			prodotti.codice,
			prodotti.nome
		) AS __label__
	FROM prodotti
		LEFT JOIN tipologie_prodotti ON tipologie_prodotti.id = prodotti.id_tipologia
		LEFT JOIN marchi ON marchi.id = prodotti.id_marchio
		LEFT JOIN anagrafica AS a1 ON a1.id = prodotti.id_produttore
		LEFT JOIN pubblicazioni ON pubblicazioni.id_prodotto = prodotti.id
		LEFT JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia
', 'prodotti_view' );

-- | 202609301951

-- progetti_view
CALL `__patch_id_numerici_vista__`( '
CREATE OR REPLACE VIEW `progetti_view` AS
	SELECT
		progetti.id,
		progetti.codice,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, '' '', a1.nome ), '''' ) AS cliente,
		progetti.id_indirizzo,
		progetti.id_ranking,
		ranking.nome AS ranking,
		progetti.id_articolo,
		progetti.id_prodotto,
		progetti.id_periodo,
		progetti.nome,
		progetti.data_consegna,
		progetti.template,
		progetti.schema_html,
		progetti.tema_css,
		progetti.se_sitemap,
		progetti.se_cacheable,
        progetti.id_sito,
        progetti.id_pagina,
		progetti.data_apertura,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR '' | '' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			'' '',
			progetti.codice,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, '' '', a1.nome ), '''' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN ranking ON ranking.id = progetti.id_ranking
	GROUP BY progetti.id
', 'progetti_view' );

-- | 202609301952

-- relazioni_articoli_view
CALL `__patch_id_numerici_vista__`( '
CREATE OR REPLACE VIEW `relazioni_articoli_view` AS
	SELECT 
		relazioni_articoli.id,
		relazioni_articoli.id_articolo,
		relazioni_articoli.id_ruolo,
		relazioni_articoli.id_prodotto_collegato,
		relazioni_articoli.id_articolo_collegato,
		concat_ws( '' - '', coalesce( a1.codice, a1.id ), coalesce( a2.codice, p2.codice, a2.id, p2.id ) ) AS __label__
	FROM relazioni_articoli
		LEFT JOIN articoli AS a1 ON a1.id = relazioni_articoli.id_articolo
		LEFT JOIN articoli AS a2 ON a2.id = relazioni_articoli.id_articolo_collegato
		LEFT JOIN prodotti AS p2 ON p2.id = relazioni_articoli.id_prodotto_collegato
', 'relazioni_articoli_view' );

-- | 202609301953

-- relazioni_prodotti_view
CALL `__patch_id_numerici_vista__`( '
CREATE OR REPLACE VIEW `relazioni_prodotti_view` AS
	SELECT 
		relazioni_prodotti.id,
		relazioni_prodotti.id_prodotto,
		relazioni_prodotti.id_ruolo,
		relazioni_prodotti.id_prodotto_collegato,
		relazioni_prodotti.id_articolo_collegato,
		concat_ws( '' - '', coalesce( p1.codice, p1.id ), coalesce( p2.codice, a2.codice, p2.id, a2.id ) ) AS __label__
	FROM relazioni_prodotti
		LEFT JOIN prodotti AS p1 ON p1.id = relazioni_prodotti.id_prodotto
		LEFT JOIN prodotti AS p2 ON p2.id = relazioni_prodotti.id_prodotto_collegato
		LEFT JOIN articoli AS a2 ON a2.id = relazioni_prodotti.id_articolo_collegato
', 'relazioni_prodotti_view' );

-- | 202609301954

-- modalita_spedizione_view
CALL `__patch_id_numerici_vista__`( '
CREATE OR REPLACE VIEW `modalita_spedizione_view` AS
	SELECT
		modalita_spedizione.id,
		modalita_spedizione.id_tipologia,
		modalita_spedizione.id_zona,
		zone.nome AS zona,
		modalita_spedizione.id_categoria_prodotti,
		modalita_spedizione.id_prodotto,
		modalita_spedizione.id_articolo,
		modalita_spedizione.lotto_spedizione,
		modalita_spedizione.importo_netto,
		modalita_spedizione.id_valuta,
		valute.utf8 AS valuta,
		modalita_spedizione.id_iva,
		iva.nome AS iva,
		modalita_spedizione.giorni_spedizione,
		modalita_spedizione.giorni_consegna,
		concat( zone.nome, '' - '', coalesce( prodotti.codice, articoli.codice, modalita_spedizione.id_prodotto, modalita_spedizione.id_articolo ) ) AS __label__
	FROM modalita_spedizione
		LEFT JOIN prodotti ON prodotti.id = modalita_spedizione.id_prodotto
		LEFT JOIN articoli ON articoli.id = modalita_spedizione.id_articolo
		LEFT JOIN zone ON zone.id = modalita_spedizione.id_zona
		LEFT JOIN iva ON iva.id = modalita_spedizione.id_iva
		LEFT JOIN valute ON valute.id = modalita_spedizione.id_valuta
', 'modalita_spedizione_view' );

-- | 202609301955

-- sconti_articoli_view
CALL `__patch_id_numerici_vista__`( '
CREATE OR REPLACE VIEW `sconti_articoli_view` AS
	SELECT
		sconti_articoli.id,
		sconti_articoli.id_sconto,
		sconti.nome AS sconto,
		sconti_articoli.id_articolo,
		articoli.id_prodotto,
		concat_ws( '' '', prodotti.nome, articoli.nome ) AS articolo,
		concat_ws( '' '', sconti.nome, coalesce( articoli.codice, articoli.id ) ) AS __label__
	FROM sconti_articoli
		LEFT JOIN sconti ON sconti.id = sconti_articoli.id_sconto
		LEFT JOIN articoli ON articoli.id = sconti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
', 'sconti_articoli_view' );

-- | 202609301958

-- quello che non si e' potuto fare, e perche': lo legge chi applica la patch a mano
SELECT @id_numerici_note AS nota;

-- | 202609302000

-- si liberano le procedure
DROP PROCEDURE IF EXISTS `__patch_id_numerici_mappa__`;

-- | 202609302001

DROP PROCEDURE IF EXISTS `__patch_id_numerici_elenco__`;

-- | 202609302002

DROP PROCEDURE IF EXISTS `__patch_id_numerici_converti__`;

-- | 202609302003

DROP PROCEDURE IF EXISTS `__patch_id_numerici_chiavi__`;

-- | 202609302004

DROP PROCEDURE IF EXISTS `__patch_id_numerici_controllo__`;

-- | 202609302005

DROP PROCEDURE IF EXISTS `__patch_id_numerici_vista__`;

-- | 202609302006

DROP PROCEDURE IF EXISTS `__patch_id_numerici_esegui__`;

-- | 202609302007

-- e le liste di lavoro; le due __mappatura_id*__ restano
DROP TABLE IF EXISTS `__patch_id_numerici_colonne__`;

-- | 202609302008

DROP TABLE IF EXISTS `__patch_id_numerici_vincoli__`;

-- | FINE FILE
