-- 2026-09-25 — i flag se_annunci e se_categorie_annunci su ruoli_audio e ruoli_video
--
-- Contesto: i form audio e video del modulo annunci ( _mod/_3200.annunci, *.form.audio e
-- *.form.video ) popolano la tendina dei ruoli con WHERE se_annunci = 1 e WHERE
-- se_categorie_annunci = 1, ma nessuna tabella ruoli_* ha mai avuto queste due colonne: il modulo
-- ( commit 39b1ddcc1 del 2024-01-14 ) e' stato ricalcato su quello delle notizie senza toccare il
-- database, e le query fallivano con "Unknown column". La tendina e' selectRequired, quindi senza
-- ruoli non si poteva salvare nessun audio o video di un annuncio.
--
-- COME SONO FATTE. Come gli altri flag dei ruoli: tinyint( 1 ) DEFAULT NULL, dopo
-- se_categorie_notizie ( lo stesso ordine delle colonne id_annuncio e id_categoria_annunci di audio
-- e video ), senza indice come gli altri se_* di queste tabelle, ed esposte dalle viste
-- ruoli_audio_view e ruoli_video_view. I file di base sono stati aggiornati nello stesso giro.
--
-- DATI. Sui ruoli video di base i due flag ricalcano se_notizie e se_categorie_notizie ( ruoli da
-- 1 a 8 ), perche' gli annunci sono costruiti sulle notizie; e' lo stesso modo in cui la patch
-- _202205199999 ha valorizzato se_immobili. I ruoli audio di base non hanno se_notizie, e quindi
-- restano senza anche se_annunci.
--
-- IDEMPOTENZA. ADD COLUMN IF NOT EXISTS e' di MariaDB, come in _202609251000.audio.sql; le UPDATE
-- si possono ripetere e le viste si ricreano.

-- | 202609251100

-- ruoli_audio
ALTER TABLE `ruoli_audio`
	ADD COLUMN IF NOT EXISTS `se_annunci` tinyint(1) DEFAULT NULL AFTER `se_categorie_notizie`,
	ADD COLUMN IF NOT EXISTS `se_categorie_annunci` tinyint(1) DEFAULT NULL AFTER `se_annunci`;

-- | 202609251101

-- ruoli_video
ALTER TABLE `ruoli_video`
	ADD COLUMN IF NOT EXISTS `se_annunci` tinyint(1) DEFAULT NULL AFTER `se_categorie_notizie`,
	ADD COLUMN IF NOT EXISTS `se_categorie_annunci` tinyint(1) DEFAULT NULL AFTER `se_annunci`;

-- | 202609251110

-- ruoli_video
UPDATE `ruoli_video` SET
`se_annunci` = '1',
`se_categorie_annunci` = '1'
WHERE ((`id` = '1') OR (`id` = '2') OR (`id` = '3') OR (`id` = '4') OR (`id` = '5') OR (`id` = '6') OR (`id` = '7') OR (`id` = '8'));

-- | 202609251120

-- ruoli_audio_view
CREATE OR REPLACE VIEW ruoli_audio_view AS
	SELECT
		ruoli_audio.id,
		ruoli_audio.id_genitore,
		ruoli_audio.nome,
		ruoli_audio.html_entity,
		ruoli_audio.font_awesome,
		ruoli_audio.se_anagrafica,
		ruoli_audio.se_pagine,
		ruoli_audio.se_prodotti,
		ruoli_audio.se_articoli,
		ruoli_audio.se_categorie_prodotti,
		ruoli_audio.se_marchi,
		ruoli_audio.se_notizie,
		ruoli_audio.se_categorie_notizie,
		ruoli_audio.se_annunci,
		ruoli_audio.se_categorie_annunci,
		ruoli_audio.se_risorse,
		ruoli_audio.se_categorie_risorse,
		ruoli_audio.se_immobili,
	 	ruoli_audio_path( ruoli_audio.id ) AS __label__
	FROM ruoli_audio
;

-- | 202609251121

-- ruoli_video_view
CREATE OR REPLACE VIEW ruoli_video_view AS
	SELECT
		ruoli_video.id,
		ruoli_video.id_genitore,
		ruoli_video.nome,
		ruoli_video.html_entity,
		ruoli_video.font_awesome,
		ruoli_video.se_anagrafica,
		ruoli_video.se_pagine,
		ruoli_video.se_prodotti,
		ruoli_video.se_articoli,
		ruoli_video.se_categorie_prodotti,
		ruoli_video.se_marchi,
		ruoli_video.se_notizie,
		ruoli_video.se_categorie_notizie,
		ruoli_video.se_annunci,
		ruoli_video.se_categorie_annunci,
		ruoli_video.se_risorse,
		ruoli_video.se_categorie_risorse,
		ruoli_video.se_immobili,
	 	ruoli_video_path( ruoli_video.id ) AS __label__
	FROM ruoli_video
;

-- | FINE FILE
