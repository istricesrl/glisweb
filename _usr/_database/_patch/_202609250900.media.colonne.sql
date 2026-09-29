-- 2026-09-26 — audio, video, ruoli_audio e ruoli_video: le colonne dello schema di base, prima delle patch del 25/09
--
-- Contesto: le patch del 25/09 ( _202609251100 e _202609251300 ) ricreano ruoli_audio_view, ruoli_video_view,
-- audio_view e video_view con tutte le colonne dello schema di base. I deploy installati prima non le hanno tutte:
-- su gimbe mancavano, fra le altre, audio.id_marchio, audio.id_annuncio, audio.note, video.id_marchio e
-- ruoli_audio.se_marchi. La CREATE VIEW falliva, il motore delle patch si ferma al primo errore, e _202609251300
-- ( audio.embed e video.embed ) non arrivava mai: aggiungiDati() cercava video.embed, la query falliva con 1054 e
-- dal 26/09 le pagine di bernispa, gimbe, polmasi e utensilerialughese sono rimaste senza video e audio.
--
-- Questa patch ha un livello piu' basso di quelle del 25/09 apposta, cosi' gira prima di loro: un deploy fermo al
-- 23/09 la legge, uno che le ha gia' passate la salta, e non ne ha bisogno. Le colonne sono quelle di
-- _010000999999.tables.sql, tolte id, id_embed ed embed, di cui si occupa _202609251300. ADD COLUMN IF NOT EXISTS
-- e' di MariaDB: dove la colonna c'e' gia' non fa niente, quindi rilanciarla non cambia nulla. Nessun dato toccato.

-- | 202609250900

-- audio
ALTER TABLE `audio`
	ADD COLUMN IF NOT EXISTS `id_anagrafica` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_pagina` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_file` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_prodotto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_articolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_prodotti` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_marchio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_risorsa` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_risorse` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_notizia` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_annuncio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_notizie` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_annunci` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_lingua` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_ruolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_progetto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_progetti` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_indirizzo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_edificio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_immobile` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_valutazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `path` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `codice_embed` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `embed_custom` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `target` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL;

-- | 202609250901

-- video
ALTER TABLE `video`
	ADD COLUMN IF NOT EXISTS `id_anagrafica` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_pagina` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_file` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_prodotto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_articolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_prodotti` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_marchio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_risorsa` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_risorse` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_notizia` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_annuncio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_notizie` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_annunci` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_lingua` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_ruolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_progetto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_categoria_progetti` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_indirizzo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_edificio` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_immobile` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_valutazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `path` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `codice_embed` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `embed_custom` char(128) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `target` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `orientamento` enum('L','P','S') DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ratio` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL;

-- | 202609250902

-- ruoli_audio
ALTER TABLE `ruoli_audio`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(64) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_anagrafica` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_pagine` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_prodotti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_articoli` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_prodotti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_marchi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_notizie` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_notizie` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_annunci` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_annunci` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_risorse` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_risorse` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_immobili` tinyint(1) DEFAULT NULL;

-- | 202609250903

-- ruoli_video
ALTER TABLE `ruoli_video`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(64) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_anagrafica` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_pagine` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_prodotti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_articoli` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_prodotti` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_marchi` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_notizie` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_notizie` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_annunci` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_annunci` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_risorse` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_categorie_risorse` tinyint(1) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `se_immobili` tinyint(1) DEFAULT NULL;

-- | FINE FILE
