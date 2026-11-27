-- 2026-11-12 — documenti_view_static: la KEY del filtro di classe
--
-- Schema canonico, punto 6, viste non di famiglia ( offerte_view ), decisione di Fabio del 12/11/2026 ( R1 ): una classe
-- di righe si filtra, non si materializza. Si materializza la vista della tabella base, e il modulo di una classe ( le
-- offerte di _DO040, le fatture di _DO010 ) la restringe su id_tipologia; la statica ha quindi la KEY del filtro di classe
-- accanto a quella dell'ordine dell'elenco. Con centinaia di migliaia di documenti, senza questa KEY l'elenco di una classe
-- ( id_tipologia IN ( ... ) AND data_archiviazione IS NULL ORDER BY data DESC ) scorre tutta la statica.
--
-- Cosa fa: aggiunge a documenti_view_static la KEY tipologia_data ( id_tipologia, data_archiviazione, data ), con la
-- procedura della 202611121300 che prova e annota: una statica che su un deploy non c'e' si salta, e rilanciata l'ADD KEY
-- fallisce nella nota senza fermare la coda.
--
-- Cosa NON fa: nessuna colonna nuova, nessun cambio a offerte_view / offerte_view_static ( deprecate, solo-legacy con
-- _0400.documenti: cambia solo la loro testata nei file base ).
--
-- IDEMPOTENTE.

-- | 202611121400

-- la procedura che, se la statica c'e', prova un'istruzione e, se fallisce, lo annota invece di fermare la coda
CREATE OR REPLACE PROCEDURE `__patch_statiche_forma__`( IN tabella VARCHAR(64), IN istruzione LONGTEXT )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    IF EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = tabella ) THEN

        SET @statiche_forma_sql = istruzione;
        PREPARE prova FROM @statiche_forma_sql;
        IF messaggio IS NULL THEN
            EXECUTE prova;
            DEALLOCATE PREPARE prova;
        END IF;

        IF messaggio IS NOT NULL THEN
            SET @statiche_forma_note = CONCAT_WS( '\n', @statiche_forma_note, CONCAT( tabella, ': ', messaggio ) );
        END IF;

    END IF;

END;

-- | 202611121401

-- documenti_view_static: la KEY del filtro di classe
CALL `__patch_statiche_forma__`( 'documenti_view_static', 'ALTER TABLE `documenti_view_static` ADD KEY `tipologia_data` (`id_tipologia`,`data_archiviazione`,`data`)' );

-- | FINE FILE
