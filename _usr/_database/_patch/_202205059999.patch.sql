--
-- PATCH
--
--| 202205050100
ALTER TABLE `metadati`
ADD COLUMN   `id_rinnovo` int(11) DEFAULT NULL    AFTER `id_valutazione`,
ADD KEY `id_rinnovo` (`id_rinnovo`), 
ADD CONSTRAINT `metadati_ibfk_22` FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202205050110
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
		metadati.id_contratto,
        metadati.id_valutazione,
        metadati.id_rinnovo,
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

--| 202205050120
ALTER TABLE `file`
ADD COLUMN   `id_rinnovo` int(11) DEFAULT NULL    AFTER `id_valutazione`,
ADD KEY `id_rinnovo` (`id_rinnovo`), 
ADD CONSTRAINT `file_ibfk_24` FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202205050130
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
		file.id_contratto,
        file.id_valutazione,
        file.id_rinnovo,
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

--| 202205050140
ALTER TABLE `immagini`
ADD COLUMN   `id_rinnovo` int(11) DEFAULT NULL    AFTER `id_valutazione`,
ADD KEY `id_rinnovo` (`id_rinnovo`), 
ADD CONSTRAINT `immagini_ibfk_20` FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202205050150
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
		immagini.id_contratto,
        immagini.id_valutazione,
         immagini.id_rinnovo,
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

--| 202205050160
INSERT IGNORE INTO `tipologie_indirizzi` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'calle',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'campiello',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'campo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'carraia',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	'carrarone',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	NULL,	'chiasso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	NULL,	'circondario',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	NULL,	'circonvallazione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	NULL,	NULL,	'contrà',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	NULL,	'contrada',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	NULL,	'corso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	NULL,	'diga',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	NULL,	NULL,	'discesa',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	NULL,	NULL,	'frazione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	NULL,	NULL,	'giardino',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(16,	NULL,	NULL,	'largo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(17,	NULL,	NULL,	'località',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(18,	NULL,	NULL,	'lungoargine',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(19,	NULL,	NULL,	'lungolago',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(20,	NULL,	NULL,	'lungomare',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(21,	NULL,	NULL,	'maso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(22,	NULL,	NULL,	'parallela',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(23,	NULL,	NULL,	'passeggiata',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(24,	NULL,	NULL,	'piazza',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(25,	NULL,	NULL,	'piazzale',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(26,	NULL,	NULL,	'piazzetta',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(27,	NULL,	NULL,	'rotonda',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(28,	NULL,	NULL,	'salita',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(29,	NULL,	NULL,	'strada',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(30,	NULL,	NULL,	'stradella',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(31,	NULL,	NULL,	'stradello',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(32,	NULL,	NULL,	'traversa',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(33,	NULL,	NULL,	'via',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(34,	NULL,	NULL,	'viale',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(35,	NULL,	NULL,	'vico',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(36,	NULL,	NULL,	'vicoletto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(37,	NULL,	NULL,	'vicolo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(38,	NULL,	NULL,	'vietta',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(39,	NULL,	NULL,	'viottolo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(40,	NULL,	NULL,	'viuzza',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(41,	NULL,	NULL,	'viuzzo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);


--| 202205050170
INSERT IGNORE INTO `disponibilita` (`id`, `nome`, `se_catalogo`, `se_immobili`) VALUES
(1,	'disponibile',	1,	1),
(2,	'in riassortimento',	1,	NULL),
(3,	'nuda proprietà',	NULL,	1),
(4,	'occupato',	NULL,	1);

--| FINE FILE
