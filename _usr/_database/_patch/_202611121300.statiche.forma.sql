-- 2026-11-12 — statiche: la forma della famiglia
--
-- Schema canonico, punto 6, righe 251-255, decisione di Fabio del 12/11/2026 ( opzione A ): una statica
-- <t>_view_static e' la sua vista colonna per colonna, stessi nomi e stessi tipi, piu' la PRIMARY KEY su id, gli
-- stessi UNIQUE della tabella base sulle colonne che espone e le KEY dell'ordine dell'elenco; i due timestamp che
-- syncStaticView() usa li espone la vista, e la statica non ha colonne proprie.
--
-- Cosa fa: porta ai tipi della vista 13 colonne di quattro statiche ( anagrafica, attivita, offerte, todo ), aggiunge
-- a todo_view_static timestamp_inserimento e timestamp_aggiornamento e ne fa UNIQUE la KEY codice. Con la procedura
-- che prova e annota ( il modello e' la 202611042330 ): una statica che su un deploy non c'e' si salta, e questa
-- patch non ne crea nessuna; rilanciata, l'ADD COLUMN dei timestamp fallisce nella nota e il resto rifa' lo stesso.
--
-- Cosa NON fa: le colonne nuove di documenti_view, offerte_view e todo_view, che arrivano col ricaricamento dei file
-- base ( 300.database.md, "le viste vivono nei file base" ), e il riempimento dei timestamp di todo_view_static, che
-- fa syncStaticView() al primo giro della corte.
--
-- IDEMPOTENTE.

-- | 202611121300

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

-- | 202611121301

-- anagrafica_view_static: i tipi di anagrafica
CALL `__patch_statiche_forma__`( 'anagrafica_view_static', 'ALTER TABLE `anagrafica_view_static` MODIFY COLUMN `riferimento` char(255) DEFAULT NULL, MODIFY COLUMN `sesso` enum(\'m\',\'f\',\'-\') DEFAULT NULL, MODIFY COLUMN `anno_nascita` int(4) DEFAULT NULL, MODIFY COLUMN `mese_nascita` int(2) DEFAULT NULL, MODIFY COLUMN `giorno_nascita` int(2) DEFAULT NULL' );

-- | 202611121302

-- attivita_view_static: i codici a char(32)
CALL `__patch_statiche_forma__`( 'attivita_view_static', 'ALTER TABLE `attivita_view_static` MODIFY COLUMN `codice` char(32) DEFAULT NULL, MODIFY COLUMN `codice_archivium` char(32) DEFAULT NULL' );

-- | 202611121303

-- offerte_view_static: il codice a char(32)
CALL `__patch_statiche_forma__`( 'offerte_view_static', 'ALTER TABLE `offerte_view_static` MODIFY COLUMN `codice` char(32) DEFAULT NULL' );

-- | 202611121304

-- todo_view_static: i tipi di todo
CALL `__patch_statiche_forma__`( 'todo_view_static', 'ALTER TABLE `todo_view_static` MODIFY COLUMN `anno_programmazione` year(4) DEFAULT NULL, MODIFY COLUMN `settimana_programmazione` int(11) DEFAULT NULL, MODIFY COLUMN `data_chiusura` date DEFAULT NULL, MODIFY COLUMN `data_archiviazione` date DEFAULT NULL' );

-- | 202611121305

-- todo_view_static: i timestamp, come nella vista
CALL `__patch_statiche_forma__`( 'todo_view_static', 'ALTER TABLE `todo_view_static` ADD COLUMN `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`, ADD COLUMN `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`' );

-- | 202611121306

-- todo_view_static: codice e' UNIQUE come in todo
CALL `__patch_statiche_forma__`( 'todo_view_static', 'ALTER TABLE `todo_view_static` DROP INDEX `codice`, ADD UNIQUE KEY `codice` (`codice`)' );

-- | FINE FILE
