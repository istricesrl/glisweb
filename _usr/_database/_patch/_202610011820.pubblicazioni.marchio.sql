-- 2026-10-01 — pubblicazioni.id_marchio: i periodi di pubblicazione di un marchio
--
-- COSA SI VEDEVA. La linguetta web dei marchi aveva un sotto-elenco delle pubblicazioni che scriveva l'id del marchio in
-- pubblicazioni.id_notizia, perche' la tabella non aveva una colonna per i marchi: il 29/09 il sotto-elenco e' stato
-- tolto. Prodotti, articoli, categorie, notizie e le altre entita' pubblicabili hanno la loro colonna.
--
-- COSA FA. Aggiunge pubblicazioni.id_marchio, con l'indice e la chiave esterna pubblicazioni_ibfk_16 verso marchi
-- ( seguita, ON DELETE SET NULL come le altre della tabella: controller() carica le pubblicazioni nella scheda del
-- marchio ), e rifa' pubblicazioni_view con la colonna nuova. La colonna nasce vuota, quindi la chiave entra sempre.
--
-- IDEMPOTENTE.

-- | 202610011820

ALTER TABLE `pubblicazioni`
    ADD COLUMN IF NOT EXISTS `id_marchio` bigint(20) DEFAULT NULL AFTER `id_banner`;

-- | 202610011821

ALTER TABLE `pubblicazioni`
    ADD KEY IF NOT EXISTS `id_marchio` (`id_marchio`);

-- | 202610011822

-- la chiave esterna, con id_marchio prima portato al tipo di marchi.id: sui deploy installati prima di marzo marchi.id e'
-- spesso int( 11 ) e la chiave verso una colonna bigint( 20 ) fallisce con 1005 errno 150
CREATE OR REPLACE PROCEDURE `__patch_pubblicazioni_marchio__`()
BEGIN

    DECLARE tipo_id VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;
    DECLARE tipo_colonna VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL;

    SELECT COLUMN_TYPE INTO tipo_id FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'marchi' AND COLUMN_NAME = 'id';
    SELECT COLUMN_TYPE INTO tipo_colonna FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'pubblicazioni' AND COLUMN_NAME = 'id_marchio';

    IF NOT EXISTS ( SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = database() AND TABLE_NAME = 'pubblicazioni' AND CONSTRAINT_NAME = 'pubblicazioni_ibfk_16' ) THEN
        IF tipo_id IS NOT NULL AND tipo_colonna IS NOT NULL AND tipo_id != tipo_colonna THEN
            SET @sql = CONCAT( 'ALTER TABLE `pubblicazioni` MODIFY `id_marchio` ', tipo_id, ' DEFAULT NULL' );
            PREPARE istruzione FROM @sql; EXECUTE istruzione; DEALLOCATE PREPARE istruzione;
        END IF;
        ALTER TABLE `pubblicazioni`
            ADD CONSTRAINT `pubblicazioni_ibfk_16` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
    END IF;

END;

-- | 202610011823

CALL `__patch_pubblicazioni_marchio__`();

-- | 202610011824

DROP PROCEDURE IF EXISTS `__patch_pubblicazioni_marchio__`;

-- | 202610011825

-- pubblicazioni_view, con id_marchio
CREATE OR REPLACE VIEW `pubblicazioni_view` AS
    SELECT
		pubblicazioni.id,
		pubblicazioni.id_tipologia,
		tp.nome AS tipologia,
		pubblicazioni.ordine,
		pubblicazioni.id_prodotto,
		pubblicazioni.id_articolo,
		pubblicazioni.id_categoria_prodotti,
		pubblicazioni.id_notizia,
		pubblicazioni.id_categoria_notizie,
		pubblicazioni.id_categoria_annunci,
		pubblicazioni.id_pagina,
		pubblicazioni.id_popup,
		pubblicazioni.id_risorsa,
		pubblicazioni.id_categoria_risorse,
		pubblicazioni.id_progetto,
		pubblicazioni.id_categoria_progetti,
		pubblicazioni.id_banner,
		pubblicazioni.id_marchio,
		pubblicazioni.timestamp_inizio,
		pubblicazioni.timestamp_fine,
		concat_ws(
			' ',
			tp.nome,
			pubblicazioni.timestamp_inizio,
			pubblicazioni.timestamp_fine
		) AS __label__
    FROM pubblicazioni
		LEFT JOIN tipologie_pubblicazioni AS tp
            ON tp.id = pubblicazioni.id_tipologia
;

-- | FINE FILE
