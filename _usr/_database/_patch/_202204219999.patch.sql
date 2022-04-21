--
-- PATCH
--

--| 202204215010
ALTER TABLE `audio`
ADD COLUMN   `id_indirizzo` int(11) DEFAULT NULL    AFTER `id_categoria_progetti`,
ADD COLUMN   `id_edificio` int(11) DEFAULT NULL    AFTER `id_indirizzo`,
ADD COLUMN   `id_immobile` int(11) DEFAULT NULL    AFTER `id_edificio`,
ADD KEY `id_indirizzo` (`id_indirizzo`), 
ADD KEY `id_edificio` (`id_edificio`), 
ADD KEY `id_immobile` (`id_immobile`), 
ADD CONSTRAINT `audio_ibfk_15` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `audio_ibfk_16` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `audio_ibfk_17` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204215020
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
		audio.id_indirizzo,
		audio.id_edificio,
		audio.id_immobile,
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

--| 202204215030
ALTER TABLE `file`
ADD COLUMN   `id_indirizzo` int(11) DEFAULT NULL    AFTER `id_categoria_progetti`,
ADD COLUMN   `id_edificio` int(11) DEFAULT NULL    AFTER `id_indirizzo`,
ADD COLUMN   `id_immobile` int(11) DEFAULT NULL    AFTER `id_edificio`,
ADD KEY `id_indirizzo` (`id_indirizzo`), 
ADD KEY `id_edificio` (`id_edificio`), 
ADD KEY `id_immobile` (`id_immobile`), 
ADD CONSTRAINT `file_ibfk_19` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `file_ibfk_20` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `file_ibfk_21` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204215040
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
		file.id_indirizzo,
		file.id_edificio,
		file.id_immobile,
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

--| 202204215050
ALTER TABLE `metadati`
ADD COLUMN   `id_indirizzo` int(11) DEFAULT NULL    AFTER `id_categoria_progetti`,
ADD COLUMN   `id_edificio` int(11) DEFAULT NULL    AFTER `id_indirizzo`,
ADD COLUMN   `id_immobile` int(11) DEFAULT NULL    AFTER `id_edificio`,
ADD KEY `id_indirizzo` (`id_indirizzo`), 
ADD KEY `id_edificio` (`id_edificio`), 
ADD KEY `id_immobile` (`id_immobile`), 
ADD CONSTRAINT `metadati_ibfk_17` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `metadati_ibfk_18` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `metadati_ibfk_19` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204215060
CREATE OR REPLACE VIEW `metadati_view` AS
	SELECT
		metadati.id,
		metadati.id_lingua,
		lingue.ietf,
		metadati.id_anagrafica,
		metadati.id_pagina,
		metadati.id_prodotto,
		metadati.id_articolo,
		metadati.id_categoria_prodotti,
		metadati.id_notizia,
		metadati.id_categoria_notizie,
		metadati.id_risorsa,
		metadati.id_categoria_risorse,
		metadati.id_immagine,
		metadati.id_video,
		metadati.id_audio,
		metadati.id_file,
		metadati.id_progetto,
		metadati.id_categoria_progetti,
		metadati.id_indirizzo,
		metadati.id_edificio,
		metadati.id_immobile,
		metadati.id_account_inserimento,
		metadati.id_account_aggiornamento,
		concat(
			metadati.nome,
			':',
			metadati.testo
		) AS __label__
	FROM metadati
		LEFT JOIN lingue ON lingue.id = metadati.id_lingua
;

--| 202204215070
ALTER TABLE `contenuti`
ADD COLUMN   `id_edificio` int(11) DEFAULT NULL    AFTER `id_indirizzo`,
ADD COLUMN   `id_immobile` int(11) DEFAULT NULL    AFTER `id_edificio`,
ADD KEY `id_edificio` (`id_edificio`), 
ADD KEY `id_immobile` (`id_immobile`), 
ADD CONSTRAINT `contenuti_ibfk_26` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `contenuti_ibfk_27` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204215080
CREATE OR REPLACE VIEW contenuti_view AS
	SELECT
		contenuti.id,
		contenuti.id_lingua,
		contenuti.id_anagrafica,
		contenuti.id_prodotto,
		contenuti.id_articolo,
		contenuti.id_categoria_prodotti,
		contenuti.id_caratteristica_prodotti,
		contenuti.id_marchio,
		contenuti.id_file,
		contenuti.id_immagine,
		contenuti.id_video,
		contenuti.id_audio,
		contenuti.id_risorsa,
		contenuti.id_categoria_risorse,
		contenuti.id_pagina,
		contenuti.id_popup,
		contenuti.id_indirizzo,
		contenuti.id_edificio,
		contenuti.id_immobile,
		contenuti.id_notizia,
		contenuti.id_categoria_notizie,
		contenuti.id_template,
		contenuti.id_colore,
		contenuti.id_progetto,
		contenuti.id_categoria_progetti,
		contenuti.title,
		contenuti.h1,
		contenuti.id_account_inserimento,
		contenuti.id_account_aggiornamento,
		concat(
			contenuti.h1,
			' / ',
			lingue.nome
		) AS __label__
	FROM contenuti
		INNER JOIN lingue ON lingue.id = contenuti.id_lingua
;

--| 202204215090
ALTER TABLE `video`
ADD COLUMN   `id_indirizzo` int(11) DEFAULT NULL    AFTER `id_categoria_progetti`,
ADD COLUMN   `id_edificio` int(11) DEFAULT NULL    AFTER `id_indirizzo`,
ADD COLUMN   `id_immobile` int(11) DEFAULT NULL    AFTER `id_edificio`,
ADD KEY `id_indirizzo` (`id_indirizzo`), 
ADD KEY `id_edificio` (`id_edificio`), 
ADD KEY `id_immobile` (`id_immobile`), 
ADD CONSTRAINT `video_ibfk_16` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `video_ibfk_17` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `video_ibfk_18` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204215100
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
		video.id_indirizzo,
		video.id_edificio,
		video.id_immobile,
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

--| 202204215110
ALTER TABLE `immagini`
ADD COLUMN   `id_edificio` int(11) DEFAULT NULL    AFTER `id_indirizzo`,
ADD COLUMN   `id_immobile` int(11) DEFAULT NULL    AFTER `id_edificio`,
ADD KEY `id_edificio` (`id_edificio`), 
ADD KEY `id_immobile` (`id_immobile`), 
ADD CONSTRAINT `immagini_ibfk_16` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `immagini_ibfk_17` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204215120
CREATE OR REPLACE VIEW `immagini_view` AS
	SELECT
		immagini.id,
		immagini.id_anagrafica,
		immagini.id_pagina,
		immagini.id_file,
		immagini.id_prodotto,
		immagini.id_articolo,
		immagini.id_categoria_prodotti,
		immagini.id_risorsa,
		immagini.id_categoria_risorse,
		immagini.id_notizia,
		immagini.id_categoria_notizie,
		immagini.id_progetto,
		immagini.id_categoria_progetti,
		immagini.id_indirizzo,
		immagini.id_edificio,
		immagini.id_immobile,
		immagini.id_lingua,
		lingue.nome AS lingua,
		immagini.id_ruolo,
		ruoli_immagini.nome AS ruolo,
		immagini.ordine,
		immagini.orientamento,
		immagini.taglio,
		immagini.nome,
		immagini.path,
		immagini.path_alternativo,
		immagini.token,
		immagini.timestamp_scalamento,
		immagini.id_account_inserimento,
		immagini.id_account_aggiornamento,
		concat(
			ruoli_immagini.nome,
			' # ',
			immagini.ordine,
			' / ',
			immagini.nome,
			' / ',
			immagini.path
		) AS __label__
	FROM immagini
		LEFT JOIN lingue ON lingue.id = immagini.id_lingua
		LEFT JOIN ruoli_immagini ON ruoli_immagini.id = immagini.id_ruolo
;






-- FINE