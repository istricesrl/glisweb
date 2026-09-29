-- 2026-09-29 — le tabelle di sconti, zone, spedizioni, distinta, relazioni fra prodotti e ruoli dei mastri
--
-- Contesto: distinta, listini_zone, modalita_spedizione, relazioni_prodotti, ruoli_mastri, sconti,
-- sconti_articoli, sconti_listini, tipologie_sconti, tipologie_zone e zone sono uscite dai file di base nel
-- riallineamento del 02/03/2026 ( d975b4a15 ), mentre il codice continuava a usarle; su bernispa le ha
-- dovute ricreare a mano la migrazione 2026082704. I file di base le hanno di nuovo, con le forme di prima
-- di marzo portate a bigint e la colonna se_helpdesk di ruoli_mastri che bernispa aveva aggiunto; qui si
-- portano ai deploy esistenti.
--
-- IN QUEST'ORDINE: le tabelle con CREATE TABLE IF NOT EXISTS; le colonne che una tabella gia' presente
-- potrebbe non avere; chiave primaria, indici e AUTO_INCREMENT solo dove la tabella non ha una chiave
-- primaria e non ha doppioni, con la stessa guardia di _202609291500.chiavi.primarie.sql ( dove ci sono
-- doppioni non fa niente e lo dice ); le funzioni *_path dei ruoli dei mastri, delle zone e delle loro
-- tipologie; le viste. Le chiavi esterne stanno nei file di base ( _060000999999.constraints.sql ): sui deploy
-- vecchi ci sono gia', e su quelli dove le tabelle nascono qui arrivano col confronto di _database.rebuild.check.sh.
--
-- I marcatori saltano i minuti oltre il 59 perche' restino orari validi.
--
-- IDEMPOTENTE.

-- | 202609291600

-- distinta
CREATE TABLE IF NOT EXISTS `distinta` (
  `id` bigint(20) NOT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `id_componente` bigint(20) DEFAULT NULL,
  `quantita` decimal(16,5) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291601

-- listini_zone
CREATE TABLE IF NOT EXISTS `listini_zone` (
  `id` bigint(20) NOT NULL,
  `id_listino` bigint(20) DEFAULT NULL,
  `id_zona` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291602

-- modalita_spedizione
CREATE TABLE IF NOT EXISTS `modalita_spedizione` (
  `id` bigint(20) NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `id_zona` bigint(20) DEFAULT NULL,
  `id_categoria_prodotti` bigint(20) DEFAULT NULL,
  `id_prodotto` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `lotto_spedizione` int(11) DEFAULT NULL,
  `importo_netto` int(11) DEFAULT NULL,
  `id_valuta` bigint(20) DEFAULT NULL,
  `id_iva` bigint(20) DEFAULT NULL,
  `giorni_spedizione` int(11) DEFAULT NULL,
  `giorni_consegna` int(11) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291603

-- relazioni_prodotti
CREATE TABLE IF NOT EXISTS `relazioni_prodotti` (
  `id` bigint(20) NOT NULL,
  `id_prodotto` bigint(20) DEFAULT NULL,
  `id_ruolo` bigint(20) DEFAULT NULL,
  `id_prodotto_collegato` bigint(20) DEFAULT NULL,
  `id_articolo_collegato` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
);

-- | 202609291604

-- ruoli_mastri
CREATE TABLE IF NOT EXISTS `ruoli_mastri` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_xml` tinyint(1) DEFAULT NULL,
  `se_commerciale` tinyint(1) DEFAULT NULL,
  `se_produzione` tinyint(1) DEFAULT NULL,
  `se_amministrazione` tinyint(1) DEFAULT NULL,
  `se_acquisti` tinyint(1) DEFAULT NULL,
  `se_ordini` tinyint(1) DEFAULT NULL,
  `se_logistica` tinyint(1) DEFAULT NULL,
  `se_helpdesk` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291605

-- sconti
CREATE TABLE IF NOT EXISTS `sconti` (
  `id` bigint(20) NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `sconto_percentuale` decimal(5,2) DEFAULT NULL,
  `sconto_fisso` decimal(5,2) DEFAULT NULL,
  `qta_min` int(11) DEFAULT NULL,
  `id_valuta` bigint(20) DEFAULT NULL,
  `timestamp_inizio` int(11) DEFAULT NULL,
  `timestamp_fine` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291606

-- sconti_articoli
CREATE TABLE IF NOT EXISTS `sconti_articoli` (
  `id` bigint(20) NOT NULL,
  `id_sconto` bigint(20) DEFAULT NULL,
  `id_articolo` bigint(20) NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291607

-- sconti_listini
CREATE TABLE IF NOT EXISTS `sconti_listini` (
  `id` bigint(20) NOT NULL,
  `id_sconto` bigint(20) DEFAULT NULL,
  `id_listino` bigint(20) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291608

-- tipologie_sconti
CREATE TABLE IF NOT EXISTS `tipologie_sconti` (
  `id` int NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291609

-- tipologie_zone
CREATE TABLE IF NOT EXISTS `tipologie_zone` (
  `id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_ecommerce` tinyint(1) DEFAULT NULL,
  `se_commerciale` tinyint(1) DEFAULT NULL,
  `se_immobiliare` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291610

-- zone
CREATE TABLE IF NOT EXISTS `zone` (
`id` bigint(20) NOT NULL,
  `id_genitore` bigint(20) DEFAULT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202609291611

-- ruoli_mastri, la colonna che bernispa ha aggiunto
ALTER TABLE `ruoli_mastri` ADD COLUMN IF NOT EXISTS `se_helpdesk` tinyint(1) DEFAULT NULL AFTER `se_logistica`;

-- | 202609291612

-- modalita_spedizione, le colonne degli account che su bernispa mancano
ALTER TABLE `modalita_spedizione`
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL;

-- | 202609291613

-- distinta, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'distinta' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'distinta' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `distinta` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `distinta` WHERE `id_articolo` IS NOT NULL AND `id_componente` IS NOT NULL GROUP BY `id_articolo`, `id_componente` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291614

PREPARE chiavi FROM @chiavi;

-- | 202609291615

EXECUTE chiavi;

-- | 202609291616

DEALLOCATE PREPARE chiavi;

-- | 202609291617

-- distinta, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'distinta' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'distinta' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `distinta` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_articolo`,`id_componente`), ADD KEY IF NOT EXISTS `id_articolo` (`id_articolo`), ADD KEY IF NOT EXISTS `id_componente` (`id_componente`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`)",
    IF( @doppioni > 0,
        "SELECT 'distinta ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'distinta ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291618

PREPARE chiavi FROM @chiavi;

-- | 202609291619

EXECUTE chiavi;

-- | 202609291620

DEALLOCATE PREPARE chiavi;

-- | 202609291621

-- listini_zone, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'listini_zone' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'listini_zone' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `listini_zone` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `listini_zone` WHERE `id_listino` IS NOT NULL AND `id_zona` IS NOT NULL GROUP BY `id_listino`, `id_zona` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291622

PREPARE chiavi FROM @chiavi;

-- | 202609291623

EXECUTE chiavi;

-- | 202609291624

DEALLOCATE PREPARE chiavi;

-- | 202609291625

-- listini_zone, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'listini_zone' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'listini_zone' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `listini_zone` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_listino`,`id_zona`), ADD KEY IF NOT EXISTS `id_listino` (`id_listino`), ADD KEY IF NOT EXISTS `id_zona` (`id_zona`), ADD KEY IF NOT EXISTS `ordine` (`ordine`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'listini_zone ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'listini_zone ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291626

PREPARE chiavi FROM @chiavi;

-- | 202609291627

EXECUTE chiavi;

-- | 202609291628

DEALLOCATE PREPARE chiavi;

-- | 202609291629

-- modalita_spedizione, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'modalita_spedizione' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'modalita_spedizione' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `modalita_spedizione` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `modalita_spedizione` WHERE `id_tipologia` IS NOT NULL AND `id_zona` IS NOT NULL AND `id_prodotto` IS NOT NULL AND `id_articolo` IS NOT NULL GROUP BY `id_tipologia`, `id_zona`, `id_prodotto`, `id_articolo` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291630

PREPARE chiavi FROM @chiavi;

-- | 202609291631

EXECUTE chiavi;

-- | 202609291632

DEALLOCATE PREPARE chiavi;

-- | 202609291633

-- modalita_spedizione, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'modalita_spedizione' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'modalita_spedizione' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `modalita_spedizione` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_tipologia`,`id_zona`,`id_prodotto`,`id_articolo`), ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`), ADD KEY IF NOT EXISTS `id_zona` (`id_zona`), ADD KEY IF NOT EXISTS `id_categoria_prodotti` (`id_categoria_prodotti`), ADD KEY IF NOT EXISTS `id_prodotto` (`id_prodotto`), ADD KEY IF NOT EXISTS `id_articolo` (`id_articolo`), ADD KEY IF NOT EXISTS `lotto_spedizione` (`lotto_spedizione`), ADD KEY IF NOT EXISTS `importo_netto` (`importo_netto`), ADD KEY IF NOT EXISTS `id_valuta` (`id_valuta`), ADD KEY IF NOT EXISTS `id_iva` (`id_iva`), ADD KEY IF NOT EXISTS `giorni_spedizione` (`giorni_spedizione`), ADD KEY IF NOT EXISTS `giorni_consegna` (`giorni_consegna`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'modalita_spedizione ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'modalita_spedizione ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291634

PREPARE chiavi FROM @chiavi;

-- | 202609291635

EXECUTE chiavi;

-- | 202609291636

DEALLOCATE PREPARE chiavi;

-- | 202609291637

-- relazioni_prodotti, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'relazioni_prodotti' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'relazioni_prodotti' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `relazioni_prodotti` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `relazioni_prodotti` WHERE `id_prodotto` IS NOT NULL AND `id_prodotto_collegato` IS NOT NULL AND `id_ruolo` IS NOT NULL GROUP BY `id_prodotto`, `id_prodotto_collegato`, `id_ruolo` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291638

PREPARE chiavi FROM @chiavi;

-- | 202609291639

EXECUTE chiavi;

-- | 202609291640

DEALLOCATE PREPARE chiavi;

-- | 202609291641

-- relazioni_prodotti, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'relazioni_prodotti' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'relazioni_prodotti' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `relazioni_prodotti` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unico` (`id_prodotto`,`id_prodotto_collegato`,`id_ruolo`), ADD KEY IF NOT EXISTS `id_prodotto` (`id_prodotto`), ADD KEY IF NOT EXISTS `id_ruolo` (`id_ruolo`), ADD KEY IF NOT EXISTS `id_prodotto_collegato` (`id_prodotto_collegato`), ADD KEY IF NOT EXISTS `id_articolo_collegato` (`id_articolo_collegato`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'relazioni_prodotti ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'relazioni_prodotti ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291642

PREPARE chiavi FROM @chiavi;

-- | 202609291643

EXECUTE chiavi;

-- | 202609291644

DEALLOCATE PREPARE chiavi;

-- | 202609291645

-- ruoli_mastri, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'ruoli_mastri' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'ruoli_mastri' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `ruoli_mastri` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `ruoli_mastri` WHERE `nome` IS NOT NULL AND `id_genitore` IS NOT NULL GROUP BY `nome`, `id_genitore` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291646

PREPARE chiavi FROM @chiavi;

-- | 202609291647

EXECUTE chiavi;

-- | 202609291648

DEALLOCATE PREPARE chiavi;

-- | 202609291649

-- ruoli_mastri, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'ruoli_mastri' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'ruoli_mastri' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `ruoli_mastri` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`,`id_genitore`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`nome`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'ruoli_mastri ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'ruoli_mastri ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291650

PREPARE chiavi FROM @chiavi;

-- | 202609291651

EXECUTE chiavi;

-- | 202609291652

DEALLOCATE PREPARE chiavi;

-- | 202609291653

-- sconti, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `sconti` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `sconti` WHERE `id_tipologia` IS NOT NULL AND `nome` IS NOT NULL GROUP BY `id_tipologia`, `nome` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291654

PREPARE chiavi FROM @chiavi;

-- | 202609291655

EXECUTE chiavi;

-- | 202609291656

DEALLOCATE PREPARE chiavi;

-- | 202609291657

-- sconti, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `sconti` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_tipologia`,`nome`), ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `id_valuta` (`id_valuta`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_tipologia`,`nome`,`sconto_percentuale`,`sconto_fisso`,`qta_min`,`id_valuta`,`timestamp_inizio`,`timestamp_fine`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'sconti ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'sconti ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291658

PREPARE chiavi FROM @chiavi;

-- | 202609291659

EXECUTE chiavi;

-- | 202609291700

DEALLOCATE PREPARE chiavi;

-- | 202609291701

-- sconti_articoli, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_articoli' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_articoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `sconti_articoli` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `sconti_articoli` WHERE `id_sconto` IS NOT NULL AND `id_articolo` IS NOT NULL GROUP BY `id_sconto`, `id_articolo` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291702

PREPARE chiavi FROM @chiavi;

-- | 202609291703

EXECUTE chiavi;

-- | 202609291704

DEALLOCATE PREPARE chiavi;

-- | 202609291705

-- sconti_articoli, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_articoli' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_articoli' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `sconti_articoli` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_sconto`,`id_articolo`), ADD KEY IF NOT EXISTS `id_sconto` (`id_sconto`), ADD KEY IF NOT EXISTS `id_articolo` (`id_articolo`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_sconto`,`id_articolo`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'sconti_articoli ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'sconti_articoli ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291706

PREPARE chiavi FROM @chiavi;

-- | 202609291707

EXECUTE chiavi;

-- | 202609291708

DEALLOCATE PREPARE chiavi;

-- | 202609291709

-- sconti_listini, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_listini' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_listini' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `sconti_listini` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `sconti_listini` WHERE `id_sconto` IS NOT NULL AND `id_listino` IS NOT NULL GROUP BY `id_sconto`, `id_listino` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291710

PREPARE chiavi FROM @chiavi;

-- | 202609291711

EXECUTE chiavi;

-- | 202609291712

DEALLOCATE PREPARE chiavi;

-- | 202609291713

-- sconti_listini, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_listini' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'sconti_listini' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `sconti_listini` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_sconto`,`id_listino`), ADD KEY IF NOT EXISTS `id_sconto` (`id_sconto`), ADD KEY IF NOT EXISTS `id_listino` (`id_listino`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_sconto`,`id_listino`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'sconti_listini ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'sconti_listini ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291714

PREPARE chiavi FROM @chiavi;

-- | 202609291715

EXECUTE chiavi;

-- | 202609291716

DEALLOCATE PREPARE chiavi;

-- | 202609291717

-- tipologie_sconti, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_sconti' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_sconti' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `tipologie_sconti` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `tipologie_sconti` WHERE `id_genitore` IS NOT NULL AND `nome` IS NOT NULL GROUP BY `id_genitore`, `nome` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291718

PREPARE chiavi FROM @chiavi;

-- | 202609291719

EXECUTE chiavi;

-- | 202609291720

DEALLOCATE PREPARE chiavi;

-- | 202609291721

-- tipologie_sconti, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_sconti' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_sconti' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `tipologie_sconti` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`nome`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'tipologie_sconti ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'tipologie_sconti ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291722

PREPARE chiavi FROM @chiavi;

-- | 202609291723

EXECUTE chiavi;

-- | 202609291724

DEALLOCATE PREPARE chiavi;

-- | 202609291725

-- tipologie_zone, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_zone' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_zone' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `tipologie_zone` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `tipologie_zone` WHERE `id_genitore` IS NOT NULL AND `nome` IS NOT NULL GROUP BY `id_genitore`, `nome` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291726

PREPARE chiavi FROM @chiavi;

-- | 202609291727

EXECUTE chiavi;

-- | 202609291728

DEALLOCATE PREPARE chiavi;

-- | 202609291729

-- tipologie_zone, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_zone' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'tipologie_zone' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `tipologie_zone` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `ordine` (`ordine`), ADD KEY IF NOT EXISTS `nome` (`nome`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'tipologie_zone ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'tipologie_zone ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291730

PREPARE chiavi FROM @chiavi;

-- | 202609291731

EXECUTE chiavi;

-- | 202609291732

DEALLOCATE PREPARE chiavi;

-- | 202609291733

-- zone, i doppioni
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'zone' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'zone' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ),
    "SELECT ( SELECT count(*) - count( DISTINCT `id` ) FROM `zone` ) + ( SELECT count(*) FROM ( SELECT 1 FROM `zone` WHERE `nome` IS NOT NULL AND `id_genitore` IS NOT NULL GROUP BY `nome`, `id_genitore` HAVING count(*) > 1 ) AS d ) INTO @doppioni",
    "SELECT 0 INTO @doppioni"
);

-- | 202609291734

PREPARE chiavi FROM @chiavi;

-- | 202609291735

EXECUTE chiavi;

-- | 202609291736

DEALLOCATE PREPARE chiavi;

-- | 202609291737

-- zone, la chiave
SET @chiavi = IF(
    EXISTS ( SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'zone' ) AND NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'zone' AND CONSTRAINT_TYPE = 'PRIMARY KEY' ) AND @doppioni = 0,
    "ALTER TABLE `zone` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`, `id_genitore`), ADD KEY IF NOT EXISTS `id_tipologia` (`id_tipologia`), ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`), ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`), ADD KEY IF NOT EXISTS `id_genitore` (`id_genitore`), ADD KEY IF NOT EXISTS `indice` (`id`,`id_genitore`,`nome`, `id_tipologia`), MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT",
    IF( @doppioni > 0,
        "SELECT 'zone ha id o chiavi uniche ripetuti: chiave primaria non aggiunta, i doppioni vanno risolti a mano' AS nota",
        "SELECT 'zone ha la chiave primaria o non esiste: niente da fare' AS nota" )
);

-- | 202609291738

PREPARE chiavi FROM @chiavi;

-- | 202609291739

EXECUTE chiavi;

-- | 202609291740

DEALLOCATE PREPARE chiavi;

-- | 202609291741

-- ruoli_mastri_path
DROP FUNCTION IF EXISTS `ruoli_mastri_path`;

-- | 202609291742

-- ruoli_mastri_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_mastri_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_mastri_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_mastri.id_genitore,
				ruoli_mastri.nome
			FROM ruoli_mastri
			WHERE ruoli_mastri.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609291743

-- ruoli_mastri_path_check
DROP FUNCTION IF EXISTS `ruoli_mastri_path_check`;

-- | 202609291744

-- ruoli_mastri_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_mastri_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 int( 11 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_mastri_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_mastri.id_genitore
			FROM ruoli_mastri
			WHERE ruoli_mastri.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609291745

-- ruoli_mastri_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_mastri_path_find_ancestor`;

-- | 202609291746

-- ruoli_mastri_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_mastri_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_mastri_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_mastri.id_genitore,
				ruoli_mastri.id
			FROM ruoli_mastri
			WHERE ruoli_mastri.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609291747

-- tipologie_zone_path
DROP FUNCTION IF EXISTS `tipologie_zone_path`;

-- | 202609291748

-- tipologie_zone_path
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_zone_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_zone_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_zone.id_genitore,
				tipologie_zone.nome
			FROM tipologie_zone
			WHERE tipologie_zone.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609291749

-- tipologie_zone_path_check
DROP FUNCTION IF EXISTS `tipologie_zone_path_check`;

-- | 202609291750

-- tipologie_zone_path_check
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_zone_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 int( 11 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_zone_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_zone.id_genitore
			FROM tipologie_zone
			WHERE tipologie_zone.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609291751

-- tipologie_zone_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_zone_path_find_ancestor`;

-- | 202609291752

-- tipologie_zone_path_find_ancestor
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_zone_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_zone_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_zone.id_genitore,
				tipologie_zone.id
			FROM tipologie_zone
			WHERE tipologie_zone.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609291753

-- zone_path
DROP FUNCTION IF EXISTS `zone_path`;

-- | 202609291754

-- zone_path
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `zone_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT zone_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				zone.id_genitore,
				zone.nome
			FROM zone
			WHERE zone.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609291755

-- zone_path_check
DROP FUNCTION IF EXISTS `zone_path_check`;

-- | 202609291756

-- zone_path_check
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `zone_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 int( 11 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT zone_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				zone.id_genitore
			FROM zone
			WHERE zone.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609291757

-- zone_path_find_ancestor
DROP FUNCTION IF EXISTS `zone_path_find_ancestor`;

-- | 202609291758

-- zone_path_find_ancestor
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `zone_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT zone_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				zone.id_genitore,
				zone.id
			FROM zone
			WHERE zone.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609291759

-- listini_zone_view
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:20 Fabio Mosti
CREATE OR REPLACE VIEW `listini_zone_view` AS
	SELECT
		listini_zone.id,
		listini_zone.id_listino,
		concat( listini.nome, ' ', valute.iso4217 ) AS listino,
		listini_zone.id_zona,
		zone.nome AS zona,
		listini_zone.ordine,
		listini_zone.id_account_inserimento,
		listini_zone.id_account_aggiornamento,
		concat(
			listini.nome,
			' ',
			valute.iso4217,
			' / ',
			zone.nome
		) AS __label__
	FROM listini_zone
		LEFT JOIN listini ON listini.id = listini_zone.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN zone ON zone.id = listini_zone.id_zona
;

-- | 202609291800

-- modalita_spedizione
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
		concat( zone.nome, ' - ', coalesce( modalita_spedizione.id_prodotto, modalita_spedizione.id_articolo ) ) AS __label__
	FROM modalita_spedizione
		LEFT JOIN zone ON zone.id = modalita_spedizione.id_zona
		LEFT JOIN iva ON iva.id = modalita_spedizione.id_iva
		LEFT JOIN valute ON valute.id = modalita_spedizione.id_valuta
;

-- | 202609291801

-- relazioni_prodotti_view
CREATE OR REPLACE VIEW `relazioni_prodotti_view` AS
	SELECT 
		relazioni_prodotti.id,
		relazioni_prodotti.id_prodotto,
		relazioni_prodotti.id_ruolo,
		relazioni_prodotti.id_prodotto_collegato,
		relazioni_prodotti.id_articolo_collegato,
		concat( relazioni_prodotti.id_prodotto,' - ', relazioni_prodotti.id_prodotto_collegato) AS __label__
	FROM relazioni_prodotti
;

-- | 202609291802

-- ruoli_mastri_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 11:23 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_mastri_view AS
	SELECT
		ruoli_mastri.id,
		ruoli_mastri.id_genitore,
		ruoli_mastri.nome,
    	ruoli_mastri.html_entity,
    	ruoli_mastri.font_awesome,
	 	ruoli_mastri_path( ruoli_mastri.id ) AS __label__
	FROM ruoli_mastri
;

-- | 202609291803

-- sconti_view
CREATE OR REPLACE VIEW `sconti_view` AS
	SELECT
	sconti.id,
	sconti.nome,
	sconti.timestamp_inizio,
	from_unixtime( sconti.timestamp_inizio, '%Y-%m-%d' ) AS data_ora_inizio,
	sconti.timestamp_fine,
	from_unixtime( sconti.timestamp_fine, '%Y-%m-%d' ) AS data_ora_fine,
	concat_ws( ' ', sconti.id, sconti.nome ) AS __label__
	FROM sconti
;

-- | 202609291804

-- sconti_articoli_view
CREATE OR REPLACE VIEW `sconti_articoli_view` AS
	SELECT
		sconti_articoli.id,
		sconti_articoli.id_sconto,
		sconti.nome AS sconto,
		sconti_articoli.id_articolo,
		articoli.id_prodotto,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		concat_ws( ' ', sconti.nome, articoli.id ) AS __label__
	FROM sconti_articoli
		LEFT JOIN sconti ON sconti.id = sconti_articoli.id_sconto
		LEFT JOIN articoli ON articoli.id = sconti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

-- | 202609291805

-- sconti_listini_view
CREATE OR REPLACE VIEW `sconti_listini_view` AS
	SELECT
		sconti_listini.id,
		sconti_listini.id_sconto,
		sconti.nome AS sconto,
		sconti_listini.id_listino,
		listini.nome AS listino,	
		concat_ws( ' ', sconti.nome, listini.nome ) AS __label__
	FROM sconti_listini
		LEFT JOIN sconti ON sconti.id = sconti_listini.id_sconto
		LEFT JOIN listini ON listini.id = sconti_listini.id_listino
;

-- | 202609291806

-- tipologie_sconti_view
CREATE OR REPLACE VIEW `tipologie_sconti_view` AS
	SELECT
		tipologie_sconti.id,
		tipologie_sconti.nome,
		tipologie_sconti.nome AS __label__
	FROM tipologie_sconti
;

-- | 202609291807

-- tipologie_zone
-- tipologia: tabella gestita
-- verifica: 2022-06-16 16:40 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_zone_view` AS
	SELECT
		tipologie_zone.id,
		tipologie_zone.id_genitore,
		tipologie_zone.ordine,
		tipologie_zone.nome,
		tipologie_zone.html_entity,
		tipologie_zone.font_awesome,
		tipologie_zone.id_account_inserimento,
		tipologie_zone.id_account_aggiornamento,
		tipologie_zone_path( tipologie_zone.id ) AS __label__
	FROM tipologie_zone
;

-- | 202609291808

-- zone_view
-- tipologia: tabella gestita
-- verifica: 2022-06-16 13:16 Chiara GDL
CREATE OR REPLACE VIEW zone_view AS
	SELECT
		zone.id,
		zone.id_genitore,
		zone.id_tipologia,
		tipologie_zone.nome AS tipologia,
		zone.nome,
		zone.id_account_inserimento,
		zone.id_account_aggiornamento,
		zone_path( zone.id ) AS __label__
	FROM zone
		LEFT JOIN tipologie_zone ON tipologie_zone.id = zone.id_tipologia
;

-- | FINE FILE
