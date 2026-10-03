-- 2026-10-03 — MySQL con sql_generate_invisible_primary_key=ON ( Azure di gimbe ): le tabelle nate senza chiave primaria
-- hanno una PRIMARY KEY ( my_row_id ) invisibile, e su metadati_articoli, metadati_prodotti, recensioni, relazioni_articoli
-- l'id resta senza chiave: la 3910 non puo' dargli l'AUTO_INCREMENT ( 1075, finito in @allarga_note ). Qui, solo se c'e'
-- my_row_id e l'id non e' gia' AUTO_INCREMENT, in un solo ALTER: via la chiave invisibile, id AUTO_INCREMENT e PRIMARY KEY.
-- Su MariaDB my_row_id non esiste e ogni blocco fa SELECT 1. Trovato e provato da GIMBE sul banco uguale ad Azure
-- ( le 4 tabelle li' sono vuote ). Un'istruzione per blocco. IDEMPOTENTE.

-- | 202610033920

SET @chiave_invisibile = IF(
    EXISTS ( SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'metadati_articoli' AND COLUMN_NAME = 'my_row_id' )
    AND EXISTS ( SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'metadati_articoli' AND COLUMN_NAME = 'id' AND EXTRA NOT LIKE '%auto_increment%' ),
    'ALTER TABLE `metadati_articoli` DROP PRIMARY KEY, DROP COLUMN `my_row_id`, MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`id`)',
    'SELECT 1'
);

-- | 202610033921

PREPARE chiave_invisibile FROM @chiave_invisibile;

-- | 202610033922

EXECUTE chiave_invisibile;

-- | 202610033923

DEALLOCATE PREPARE chiave_invisibile;

-- | 202610033924

SET @chiave_invisibile = IF(
    EXISTS ( SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'metadati_prodotti' AND COLUMN_NAME = 'my_row_id' )
    AND EXISTS ( SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'metadati_prodotti' AND COLUMN_NAME = 'id' AND EXTRA NOT LIKE '%auto_increment%' ),
    'ALTER TABLE `metadati_prodotti` DROP PRIMARY KEY, DROP COLUMN `my_row_id`, MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`id`)',
    'SELECT 1'
);

-- | 202610033925

PREPARE chiave_invisibile FROM @chiave_invisibile;

-- | 202610033926

EXECUTE chiave_invisibile;

-- | 202610033927

DEALLOCATE PREPARE chiave_invisibile;

-- | 202610033928

SET @chiave_invisibile = IF(
    EXISTS ( SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'recensioni' AND COLUMN_NAME = 'my_row_id' )
    AND EXISTS ( SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'recensioni' AND COLUMN_NAME = 'id' AND EXTRA NOT LIKE '%auto_increment%' ),
    'ALTER TABLE `recensioni` DROP PRIMARY KEY, DROP COLUMN `my_row_id`, MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`id`)',
    'SELECT 1'
);

-- | 202610033929

PREPARE chiave_invisibile FROM @chiave_invisibile;

-- | 202610033930

EXECUTE chiave_invisibile;

-- | 202610033931

DEALLOCATE PREPARE chiave_invisibile;

-- | 202610033932

SET @chiave_invisibile = IF(
    EXISTS ( SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'relazioni_articoli' AND COLUMN_NAME = 'my_row_id' )
    AND EXISTS ( SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'relazioni_articoli' AND COLUMN_NAME = 'id' AND EXTRA NOT LIKE '%auto_increment%' ),
    'ALTER TABLE `relazioni_articoli` DROP PRIMARY KEY, DROP COLUMN `my_row_id`, MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`id`)',
    'SELECT 1'
);

-- | 202610033933

PREPARE chiave_invisibile FROM @chiave_invisibile;

-- | 202610033934

EXECUTE chiave_invisibile;

-- | 202610033935

DEALLOCATE PREPARE chiave_invisibile;

-- | FINE
