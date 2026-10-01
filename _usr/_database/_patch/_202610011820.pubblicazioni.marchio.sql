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

ALTER TABLE `pubblicazioni`
    ADD CONSTRAINT `pubblicazioni_ibfk_16` FOREIGN KEY IF NOT EXISTS (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202610011823

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
