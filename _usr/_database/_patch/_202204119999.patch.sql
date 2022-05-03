--
-- PATCH
--

--| 202204110010
REPLACE INTO `embed` (`id`, `nome`, `se_video`, `se_audio`) VALUES
(1, 'HTML5', 1, 1),
(2, 'Vimeo', 1, NULL),
(3, 'YouTube', 1, NULL);

--| 202204110020
ALTER TABLE `menu` CHANGE `id_pagina` `id_pagina` INT(11) NULL;

--| 202204110030
ALTER TABLE `prodotti`
ADD `id_sito` INT NULL DEFAULT NULL AFTER `note`,
ADD `template` CHAR(255) NULL DEFAULT NULL AFTER `id_sito`,
ADD `schema_html` CHAR(128) NULL DEFAULT NULL AFTER `template`,
ADD `tema_css` CHAR(32) NULL DEFAULT NULL AFTER `schema_html`,
ADD `se_sitemap` INT(1) NULL DEFAULT NULL AFTER `tema_css`,
ADD `se_cacheable` INT(1) NULL DEFAULT NULL AFTER `se_sitemap`,
ADD KEY `id_sito` (`id_sito`),
ADD KEY `se_sitemap` (`se_sitemap`),
ADD KEY `se_cacheable` (`se_cacheable`);


--| 202204110040
CREATE OR REPLACE VIEW `prodotti_view` AS
	SELECT
		prodotti.id,
		prodotti.id_tipologia,
		tipologie_prodotti.nome AS tipologia,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		prodotti.nome,
		prodotti.id_marchio,
		marchi.nome AS marchio,
		prodotti.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		prodotti.codice_produttore,
		group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		prodotti.id_sito,
		prodotti.template,
		prodotti.schema_html,
		prodotti.tema_css,
		prodotti.se_sitemap,
		prodotti.se_cacheable,
		prodotti.id_account_inserimento,
		prodotti.id_account_aggiornamento,
		concat_ws(
			' ',
			prodotti.id,
			prodotti.nome
		) AS __label__
	FROM prodotti
		LEFT JOIN tipologie_prodotti ON tipologie_prodotti.id = prodotti.id_tipologia
		LEFT JOIN marchi ON marchi.id = prodotti.id_marchio
		LEFT JOIN anagrafica AS a1 ON a1.id = prodotti.id_produttore
		LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id
	GROUP BY prodotti.id
;

--| 202204110050
ALTER TABLE `progetti`
ADD `id_sito` INT NULL DEFAULT NULL AFTER `note`,
ADD `template` CHAR(255) NULL DEFAULT NULL AFTER `id_sito`,
ADD `schema_html` CHAR(128) NULL DEFAULT NULL AFTER `template`,
ADD `tema_css` CHAR(32) NULL DEFAULT NULL AFTER `schema_html`,
ADD `se_sitemap` INT(1) NULL DEFAULT NULL AFTER `tema_css`,
ADD `se_cacheable` INT(1) NULL DEFAULT NULL AFTER `se_sitemap`,
ADD KEY `id_sito` (`id_sito`),
ADD KEY `se_sitemap` (`se_sitemap`),
ADD KEY `se_cacheable` (`se_cacheable`);

--| 202204110054
ALTER TABLE `macro` 
ADD `id_progetto` char(32) DEFAULT NULL AFTER `id_categoria_risorse`,
ADD `id_categoria_progetti` INT(11) DEFAULT NULL AFTER `id_progetto`,
ADD KEY `id_progetto` (`id_progetto`),
ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
ADD UNIQUE KEY `unica_progetto` (`id_progetto`,`macro`), 
ADD UNIQUE KEY `unica_categoria_progetti` (`id_categoria_progetti`,`macro`), 
ADD CONSTRAINT `macro_ibfk_09` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `macro_ibfk_10` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204110057
ALTER TABLE `macro` CHANGE `id_pagina` `id_pagina` INT(11) NULL;

--| 202204110060
CREATE OR REPLACE VIEW `progetti_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti.nome AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.nome,
        progetti.id_sito,
		progetti.template,
		progetti.schema_html,
		progetti.tema_css,
		progetti.se_sitemap,
		progetti.se_cacheable,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			' cliente ',
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
	GROUP BY progetti.id
;

--| 202204110070
CREATE OR REPLACE VIEW `macro_view` AS
	SELECT
		macro.id,
		macro.id_pagina,
		macro.id_prodotto,
		macro.id_articolo,
		macro.id_categoria_prodotti,
		macro.id_notizia,
		macro.id_categoria_notizie,
		macro.id_risorsa,
		macro.id_categoria_risorse,
		macro.id_progetto,
		macro.id_categoria_progetti,
		macro.ordine,
		macro.macro,
		macro.macro AS __label__
	FROM macro
;

--| 202204110080
ALTER TABLE `file` 
ADD `id_progetto` char(32) DEFAULT NULL AFTER `id_mail_sent`,
ADD `id_categoria_progetti` INT(11) DEFAULT NULL AFTER `id_progetto`,
ADD KEY `id_progetto` (`id_progetto`),
ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
ADD CONSTRAINT `file_ibfk_17` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `file_ibfk_18` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204110090
CREATE OR REPLACE VIEW `file_view` AS
	SELECT
		file.id,
		file.ordine,
		file.id_ruolo,
		ruoli_file.nome AS ruolo,
		file.id_anagrafica,
		file.id_prodotto,
		file.id_articolo,
		file.id_categoria_prodotti,
		file.id_todo,
		file.id_pagina,
		file.id_template,
		file.id_notizia,
		file.id_categoria_notizie,
		file.id_risorsa,
		file.id_categoria_risorse,
		file.id_mail_out,                    
		file.id_mail_sent, 
		file.id_progetto,
		file.id_categoria_progetti,
		file.id_lingua,
		lingue.iso6393alpha3 AS lingua,
		file.path,
		file.url,
		file.nome,
		file.id_account_inserimento,
		file.id_account_aggiornamento,
		concat(
			ruoli_file.nome,
			' # ',
			file.ordine,
			' / ',
			file.nome,
			' / ',
			coalesce(
				file.path,
				file.url
			)
		) AS __label__
	FROM file
		LEFT JOIN ruoli_file ON ruoli_file.id = file.id_ruolo
		LEFT JOIN lingue ON lingue.id = file.id_lingua
;


--| 202204110100
ALTER TABLE `video` 
ADD `id_progetto` char(32) DEFAULT NULL AFTER `id_ruolo`,
ADD `id_categoria_progetti` INT(11) DEFAULT NULL AFTER `id_progetto`,
ADD KEY `id_progetto` (`id_progetto`),
ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
ADD CONSTRAINT `video_ibfk_14` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `video_ibfk_15` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204110110
CREATE OR REPLACE VIEW `video_view` AS
	SELECT
		video.id,
		video.id_anagrafica,
		video.id_pagina,
		video.id_file,
		video.id_prodotto,
		video.id_articolo,
		video.id_categoria_prodotti,
		video.id_risorsa,
		video.id_categoria_risorse,
		video.id_notizia,
		video.id_categoria_notizie,
		video.id_lingua,
		lingue.nome AS lingua,
		video.id_ruolo,
		video.id_progetto,
		video.id_categoria_progetti,
		ruoli_video.nome AS ruolo,
		video.ordine,
		video.nome,
		video.path,
		video.id_embed,
		video.codice_embed,
		video.embed_custom,
		video.target,
		video.orientamento,
		video.ratio,
		video.id_account_inserimento,
		video.id_account_aggiornamento,
		concat(
			ruoli_video.nome,
			' # ',
			video.ordine,
			' / ',
			video.nome,
			' / ',
			video.path
		) AS __label__
	FROM video
		LEFT JOIN lingue ON lingue.id = video.id_lingua
		LEFT JOIN ruoli_video ON ruoli_video.id = video.id_ruolo
;

--| 202204110120
ALTER TABLE `audio` 
ADD `id_progetto` char(32) DEFAULT NULL AFTER `id_categoria_notizie`,
ADD `id_categoria_progetti` INT(11) DEFAULT NULL AFTER `id_progetto`,
ADD KEY `id_progetto` (`id_progetto`),
ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
ADD CONSTRAINT `audio_ibfk_13` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `audio_ibfk_14` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204110130
CREATE OR REPLACE VIEW `audio_view` AS
	SELECT
		audio.id,
		audio.id_lingua,
		lingue.nome AS lingua,
		audio.id_ruolo,
		ruoli_audio.nome AS ruolo,
		audio.ordine,
		audio.path,
		audio.id_embed,
		embed.nome AS embed,
		audio.codice_embed,
		audio.embed_custom,
		audio.nome,
		audio.target,
		audio.id_anagrafica,
		audio.id_pagina,
		audio.id_file,
		audio.id_risorsa,
		audio.id_prodotto,
		audio.id_categoria_prodotti,
		audio.id_notizia,
		audio.id_categoria_notizie,
        audio.id_progetto,
		audio.id_categoria_progetti,
		concat(
			audio.nome,
			' / ',
			lingue.nome
		) AS __label__
	FROM audio
		LEFT JOIN lingue ON lingue.id = audio.id_lingua
		LEFT JOIN ruoli_audio ON ruoli_audio.id = audio.id_ruolo
		LEFT JOIN embed ON embed.id = audio.id_embed
;

--| 202204110140
ALTER TABLE `audio`
 ADD CONSTRAINT `audio_ibfk_03_nofollow` FOREIGN KEY (`id_embed`) REFERENCES `embed` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
 
--| FINE FILE

