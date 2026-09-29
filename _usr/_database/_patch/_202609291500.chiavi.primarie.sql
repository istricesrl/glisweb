-- 2026-09-29 — le chiavi primarie che mancavano
--
-- Contesto: mastri_articoli, mastri_tipologie_veicoli, tipologie_colli, tipologie_listini,
-- tipologie_veicoli, veicoli e todo_view_static non avevano chiave primaria nei file di base ( le prime
-- due uscite col riallineamento del 02/03/2026, le altre mai dichiarate ). Senza, un inserimento dalle
-- maschere fallisce in strict mode o scrive id = 0, e il REPLACE di refreshStaticView() su
-- todo_view_static non sostituisce le righe ma le accoda. I file di base sono stati corretti nello
-- stesso giro; qui si porta la correzione ai deploy esistenti.
--
-- OGNI TABELLA HA DUE PASSI GUARDATI DA information_schema, in PREPARE come in
-- _202609151510.sedi.inline.backfill.sql. Il primo conta i doppioni che impedirebbero la chiave ( id
-- ripetuti, e dove c'e' la UNIQUE le coppie ripetute ); il secondo aggiunge chiave primaria, indici e
-- AUTO_INCREMENT solo se la tabella esiste, non ha gia' una chiave primaria e non ha doppioni. In ogni
-- altro caso non fa niente e lo dice con un SELECT: i doppioni si guardano e si risolvono a mano, una
-- DELETE su una tabella di esercizio non si fa da un patch che gira dappertutto.
--
-- todo_view_static e' diversa perche' e' una copia di todo_view: dove non ha la chiave si svuota, si
-- chiude con la chiave e si ripopola con lo stesso REPLACE di refreshStaticView().

-- | 202609291500

-- mastri_articoli, i doppioni
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_articoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_articoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "SELECT count(*) - count( DISTINCT `id` ) INTO @doppioni FROM `mastri_articoli`",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291501

PREPARE chiavi FROM @chiavi;

-- | 202609291502

EXECUTE chiavi;

-- | 202609291503

DEALLOCATE PREPARE chiavi;

-- | 202609291504

-- mastri_articoli, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_articoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_articoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ) AND @doppioni = 0,
    "ALTER TABLE `mastri_articoli` ADD PRIMARY KEY (`id`), ADD KEY IF NOT EXISTS `id_mastro` (`id_mastro`), ADD KEY IF NOT EXISTS `id_articolo` (`id_articolo`), ADD KEY IF NOT EXISTS `id_ruolo` (`id_ruolo`), ADD KEY IF NOT EXISTS `id_udm` (`id_udm`), ADD KEY IF NOT EXISTS `ordine` (`ordine`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'mastri_articoli ha id o coppie ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'mastri_articoli ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291505

PREPARE chiavi FROM @chiavi;

-- | 202609291506

EXECUTE chiavi;

-- | 202609291507

DEALLOCATE PREPARE chiavi;

-- | 202609291508

-- mastri_tipologie_veicoli, i doppioni
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_tipologie_veicoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_tipologie_veicoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `mastri_tipologie_veicoli` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `mastri_tipologie_veicoli` WHERE `id_mastro` IS NOT NULL AND `id_tipologia` IS NOT NULL GROUP BY `id_mastro`, `id_tipologia` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291509

PREPARE chiavi FROM @chiavi;

-- | 202609291510

EXECUTE chiavi;

-- | 202609291511

DEALLOCATE PREPARE chiavi;

-- | 202609291512

-- mastri_tipologie_veicoli, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_tipologie_veicoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'mastri_tipologie_veicoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ) AND @doppioni = 0,
    "ALTER TABLE `mastri_tipologie_veicoli` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_mastro`,`id_tipologia`), ADD KEY IF NOT EXISTS `id_mastro` (`id_mastro`), ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'mastri_tipologie_veicoli ha id o coppie ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'mastri_tipologie_veicoli ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291513

PREPARE chiavi FROM @chiavi;

-- | 202609291514

EXECUTE chiavi;

-- | 202609291515

DEALLOCATE PREPARE chiavi;

-- | 202609291516

-- tipologie_colli, i doppioni
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_colli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_colli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `tipologie_colli` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `tipologie_colli` WHERE `id_genitore` IS NOT NULL AND `nome` IS NOT NULL GROUP BY `id_genitore`, `nome` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291517

PREPARE chiavi FROM @chiavi;

-- | 202609291518

EXECUTE chiavi;

-- | 202609291519

DEALLOCATE PREPARE chiavi;

-- | 202609291520

-- tipologie_colli, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_colli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_colli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ) AND @doppioni = 0,
    "ALTER TABLE `tipologie_colli` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `ordine` (`ordine`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `sigla` (`sigla`), ADD KEY IF NOT EXISTS `id_udm_dimensioni` (`id_udm_dimensioni`), ADD KEY IF NOT EXISTS `id_udm_peso` (`id_udm_peso`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'tipologie_colli ha id o coppie ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'tipologie_colli ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291521

PREPARE chiavi FROM @chiavi;

-- | 202609291522

EXECUTE chiavi;

-- | 202609291523

DEALLOCATE PREPARE chiavi;

-- | 202609291524

-- tipologie_listini, i doppioni
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_listini'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_listini' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `tipologie_listini` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `tipologie_listini` WHERE `id_genitore` IS NOT NULL AND `nome` IS NOT NULL GROUP BY `id_genitore`, `nome` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291525

PREPARE chiavi FROM @chiavi;

-- | 202609291526

EXECUTE chiavi;

-- | 202609291527

DEALLOCATE PREPARE chiavi;

-- | 202609291528

-- tipologie_listini, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_listini'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_listini' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ) AND @doppioni = 0,
    "ALTER TABLE `tipologie_listini` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `ordine` (`ordine`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'tipologie_listini ha id o coppie ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'tipologie_listini ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291529

PREPARE chiavi FROM @chiavi;

-- | 202609291530

EXECUTE chiavi;

-- | 202609291531

DEALLOCATE PREPARE chiavi;

-- | 202609291532

-- tipologie_veicoli, i doppioni
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_veicoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_veicoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `tipologie_veicoli` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `tipologie_veicoli` WHERE `id_genitore` IS NOT NULL AND `nome` IS NOT NULL GROUP BY `id_genitore`, `nome` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291533

PREPARE chiavi FROM @chiavi;

-- | 202609291534

EXECUTE chiavi;

-- | 202609291535

DEALLOCATE PREPARE chiavi;

-- | 202609291536

-- tipologie_veicoli, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_veicoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_veicoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ) AND @doppioni = 0,
    "ALTER TABLE `tipologie_veicoli` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `ordine` (`ordine`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'tipologie_veicoli ha id o coppie ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'tipologie_veicoli ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291537

PREPARE chiavi FROM @chiavi;

-- | 202609291538

EXECUTE chiavi;

-- | 202609291539

DEALLOCATE PREPARE chiavi;

-- | 202609291540

-- veicoli, i doppioni
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'veicoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'veicoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "SELECT count(*) - count( DISTINCT `id` ) INTO @doppioni FROM `veicoli`",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291541

PREPARE chiavi FROM @chiavi;

-- | 202609291542

EXECUTE chiavi;

-- | 202609291543

DEALLOCATE PREPARE chiavi;

-- | 202609291544

-- veicoli, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'veicoli'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'veicoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ) AND @doppioni = 0,
    "ALTER TABLE `veicoli` ADD PRIMARY KEY (`id`), ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`), ADD KEY IF NOT EXISTS `id_costruttore` (`id_costruttore`), ADD KEY IF NOT EXISTS `targa` (`targa`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `data_archiviazione` (`data_archiviazione`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'veicoli ha id o coppie ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'veicoli ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291545

PREPARE chiavi FROM @chiavi;

-- | 202609291546

EXECUTE chiavi;

-- | 202609291547

DEALLOCATE PREPARE chiavi;

-- | 202609291548

-- todo_view_static, si svuota se non ha la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'todo_view_static'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'todo_view_static' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "DELETE FROM `todo_view_static`",
    "SELECT 'todo_view_static ha la chiave primaria o non esiste: niente da fare' AS nota"
);

-- | 202609291549

PREPARE chiavi FROM @chiavi;

-- | 202609291550

EXECUTE chiavi;

-- | 202609291551

DEALLOCATE PREPARE chiavi;

-- | 202609291552

-- todo_view_static, la chiave
SET @chiavi = IF(
    EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'todo_view_static'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'todo_view_static' AND CONSTRAINT_TYPE = 'PRIMARY KEY'
    ),
    "ALTER TABLE `todo_view_static` ADD PRIMARY KEY (`id`)",
    "SELECT 'todo_view_static ha la chiave primaria o non esiste: niente da fare' AS nota"
);

-- | 202609291553

PREPARE chiavi FROM @chiavi;

-- | 202609291554

EXECUTE chiavi;

-- | 202609291555

DEALLOCATE PREPARE chiavi;

-- | 202609291556

-- todo_view_static, ripopolata con lo stesso REPLACE di refreshStaticView() ( come in _202609151400 )
REPLACE INTO `todo_view_static` ( `id`, `id_tipologia`, `tipologia`, `codice`, `se_agenda`, `id_anagrafica`, `anagrafica`, `id_cliente`, `cliente`, `id_indirizzo`, `indirizzo`, `id_luogo`, `luogo`, `timestamp_apertura`, `data_scadenza`, `ora_scadenza`, `data_programmazione`, `ora_inizio_programmazione`, `ora_fine_programmazione`, `anno_programmazione`, `settimana_programmazione`, `ore_programmazione`, `data_chiusura`, `nome`, `id_contatto`, `id_progetto`, `progetto`, `discipline`, `id_documento`, `documento`, `id_documenti_articoli`, `documenti_articoli`, `id_istruzione`, `istruzione`, `id_pianificazione`, `id_immobile`, `data_archiviazione`, `id_account_inserimento`, `id_account_aggiornamento`, `__label__` ) SELECT `id`, `id_tipologia`, `tipologia`, `codice`, `se_agenda`, `id_anagrafica`, `anagrafica`, `id_cliente`, `cliente`, `id_indirizzo`, `indirizzo`, `id_luogo`, `luogo`, `timestamp_apertura`, `data_scadenza`, `ora_scadenza`, `data_programmazione`, `ora_inizio_programmazione`, `ora_fine_programmazione`, `anno_programmazione`, `settimana_programmazione`, `ore_programmazione`, `data_chiusura`, `nome`, `id_contatto`, `id_progetto`, `progetto`, `discipline`, `id_documento`, `documento`, `id_documenti_articoli`, `documenti_articoli`, `id_istruzione`, `istruzione`, `id_pianificazione`, `id_immobile`, `data_archiviazione`, `id_account_inserimento`, `id_account_aggiornamento`, `__label__` FROM `todo_view`;

-- | FINE FILE
