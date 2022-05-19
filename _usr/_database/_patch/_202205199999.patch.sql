--
-- PATCH
--

--| 202205190010
ALTER TABLE ruoli_immagini 
ADD COLUMN `se_immobili` int(1) DEFAULT NULL  AFTER 	se_categorie_risorse,
ADD KEY `se_immobili` (`se_immobili`);

--| 202205190020
ALTER TABLE ruoli_file 
ADD COLUMN `se_immobili` int(1) DEFAULT NULL  AFTER se_mail,
ADD KEY `se_immobili` (`se_immobili`);

--| 202205190030
ALTER TABLE ruoli_audio 
ADD COLUMN `se_immobili` int(1) DEFAULT NULL  AFTER se_categorie_risorse,
ADD KEY `se_immobili` (`se_immobili`);

--| 202205190040
ALTER TABLE ruoli_video 
ADD COLUMN `se_immobili` int(1) DEFAULT NULL  AFTER se_categorie_risorse,
ADD KEY `se_immobili` (`se_immobili`);

--| 202205190050
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
		ruoli_audio.se_notizie,
		ruoli_audio.se_categorie_notizie,
		ruoli_audio.se_risorse,
		ruoli_audio.se_categorie_risorse,
		ruoli_audio.se_immobili,
	 	ruoli_audio_path( ruoli_audio.id ) AS __label__
	FROM ruoli_audio
;

--| 202205190060
CREATE OR REPLACE VIEW ruoli_file_view AS
	SELECT
		ruoli_file.id,
		ruoli_file.id_genitore,
		ruoli_file.nome,
		ruoli_file.html_entity,
		ruoli_file.font_awesome,
		ruoli_file.se_anagrafica,
		ruoli_file.se_pagine,
		ruoli_file.se_prodotti,
		ruoli_file.se_articoli,
		ruoli_file.se_categorie_prodotti,
		ruoli_file.se_notizie,
		ruoli_file.se_categorie_notizie,
		ruoli_file.se_risorse,
		ruoli_file.se_categorie_risorse,
		ruoli_file.se_mail,
		ruoli_file.se_immobili,
	 	ruoli_file_path( ruoli_file.id ) AS __label__
	FROM ruoli_file
;

--| 202205190070
CREATE OR REPLACE VIEW ruoli_immagini_view AS
	SELECT
		ruoli_immagini.id,
		ruoli_immagini.id_genitore,
		ruoli_immagini.ordine_scalamento,
		ruoli_immagini.nome,
		ruoli_immagini.html_entity,
		ruoli_immagini.font_awesome,
		ruoli_immagini.se_anagrafica,
		ruoli_immagini.se_pagine,
		ruoli_immagini.se_prodotti,
		ruoli_immagini.se_articoli,
		ruoli_immagini.se_categorie_prodotti,
		ruoli_immagini.se_notizie,
		ruoli_immagini.se_categorie_notizie,
		ruoli_immagini.se_risorse,
		ruoli_immagini.se_categorie_risorse,
		ruoli_immagini.se_immobili,
	 	ruoli_immagini_path( ruoli_immagini.id ) AS __label__
	FROM ruoli_immagini
;

--| 202205190080
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
		ruoli_video.se_notizie,
		ruoli_video.se_categorie_notizie,
		ruoli_video.se_risorse,
		ruoli_video.se_categorie_risorse,
		ruoli_video.se_immobili,
	 	ruoli_video_path( ruoli_video.id ) AS __label__
	FROM ruoli_video
;

--| FINE