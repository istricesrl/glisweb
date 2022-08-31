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

--| 202205190090
UPDATE `ruoli_audio` SET
`se_immobili` = '1'
WHERE ((`id` = '1') OR (`id` = '2'));

--| 202205190100
UPDATE `ruoli_file` SET
`se_immobili` = '1'
WHERE ((`id` = '1') OR (`id` = '3') OR (`id` = '5'));

--| 202205190110
INSERT INTO `ruoli_file` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_template`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_risorse`, `se_categorie_risorse`, `se_mail`, `se_immobili`) VALUES
(9,	NULL,	'contratto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(10,	NULL,	'utenze',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(11,	NULL,	'condominio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1);

--| 202205190120
UPDATE `ruoli_immagini` SET
`se_immobili` = '1'
WHERE ((`id` = '1') OR (`id` = '2'));

--| 202205190130
INSERT INTO `ruoli_immagini` (`id`, `id_genitore`, `ordine_scalamento`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_risorse`, `se_categorie_risorse`, `se_immobili`) VALUES
(12,	NULL,	NULL,	'contratto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(13,	NULL,	NULL,	'utenze',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(14,	NULL,	NULL,	'condominio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1);

--| 202205190140
UPDATE `ruoli_video` SET
`se_immobili` = '1'
WHERE ((`id` = '1') OR (`id` = '2') OR (`id` = '9'));

--| 202205190150
INSERT INTO `ruoli_video` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_risorse`, `se_categorie_risorse`, `se_immobili`) VALUES
(12,	NULL,	'condominio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(13,	NULL,	'utenze',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1);

--| 202205190160
UPDATE `ruoli_anagrafica` SET
`id` = '28',
`id_genitore` = NULL,
`nome` = 'conduttore',
`html_entity` = NULL,
`font_awesome` = NULL,
`se_produzione` = NULL,
`se_didattica` = NULL,
`se_organizzazioni` = NULL,
`se_relazioni` = NULL,
`se_risorse` = NULL,
`se_progetti` = NULL,
`se_immobili` = NULL,
`se_contratti` = '1'
WHERE `id` = '28';

--| 202205190170
CREATE TABLE `valutazioni_certificazioni` (
  `id` int NOT NULL,
  `id_valutazione` int DEFAULT NULL,
  `id_certificazione` int DEFAULT NULL,
  `id_emittente` int DEFAULT NULL,
  `nome` char(1) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `data_emissione` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL
) ENGINE=InnoDB;

--| 202205190180
ALTER TABLE `valutazioni_certificazioni`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_certificazione` (`id_certificazione`), 
	ADD KEY `id_valutazione` (`id_valutazione`), 
	ADD KEY `id_emittente` (`id_emittente`), 
	ADD KEY `nome` (`nome`), 
	ADD KEY `codice` (`codice`), 
	ADD KEY `data_emissione` (`data_emissione`), 
	ADD KEY `data_scadenza` (`data_scadenza`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD UNIQUE KEY `unica` (`id_valutazione`,`id_certificazione`, `codice`),
	ADD KEY `indice` (`id`,`id_valutazione`,`id_certificazione`,`codice`, `id_emittente`, `nome`, `data_emissione`, `data_scadenza`);


--| 202205190190
ALTER TABLE `valutazioni_certificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202205190200
ALTER TABLE `valutazioni_certificazioni`
    ADD CONSTRAINT `valutazioni_certificazioni_ibfk_01`               FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `valutazioni_certificazioni_ibfk_02_nofollow`      FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `valutazioni_certificazioni_ibfk_03_nofollow`      FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `valutazioni_certificazioni_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `valutazioni_certificazioni_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202205190210
CREATE OR REPLACE VIEW `valutazioni_certificazioni_view` AS
	SELECT
		valutazioni_certificazioni.id,
		valutazioni_certificazioni.id_valutazione,
		valutazioni_certificazioni.id_certificazione,
		certificazioni.nome AS certificazione,
		valutazioni_certificazioni.id_emittente,
		coalesce( emittente.denominazione , concat( emittente.cognome, ' ', emittente.nome ), '' ) AS emittente,
		valutazioni_certificazioni.nome,
		valutazioni_certificazioni.codice,
		valutazioni_certificazioni.data_emissione,
		valutazioni_certificazioni.data_scadenza,
		concat(
			valutazioni_certificazioni.id_valutazione, ' ',
			certificazioni.nome,
			' - ',
			valutazioni_certificazioni.codice
		) AS __label__
	FROM valutazioni_certificazioni
		LEFT JOIN anagrafica AS emittente ON emittente.id = valutazioni_certificazioni.id_emittente
		INNER JOIN certificazioni ON certificazioni.id = valutazioni_certificazioni.id_certificazione		
;


--| FINE