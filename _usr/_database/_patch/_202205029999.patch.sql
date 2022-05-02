--
-- PATCH
--

--| 202205020010
ALTER TABLE `todo` ADD `id_immobile` INT NULL DEFAULT NULL AFTER `id_pianificazione`, 
ADD INDEX `id_immobile` (`id_immobile`),
ADD CONSTRAINT `todo_ibfk_09_nofollow`      FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202205020020
ALTER TABLE `todo_view_static` ADD `id_immobile` INT NULL DEFAULT NULL AFTER `id_pianificazione`;

--| 202205020030
CREATE OR REPLACE VIEW `todo_view` AS
	SELECT
		todo.id,
		todo.id_tipologia,
		tipologie_todo.nome AS tipologia,
		todo.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		todo.id_cliente,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		todo.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		todo.id_luogo,
		luoghi_path( todo.id_luogo ) AS luogo,
		todo.data_scadenza,
		todo.ora_scadenza,
		todo.data_programmazione,
		todo.ora_inizio_programmazione,
		todo.ora_fine_programmazione,
		todo.anno_programmazione,
		todo.settimana_programmazione,
		todo.ore_programmazione,
		todo.data_chiusura,
		todo.nome,
		todo.id_contatto,
		todo.id_progetto,
		todo.id_pianificazione,
		todo.id_immobile,
		todo.data_archiviazione,
		todo.id_account_inserimento,
		todo.id_account_aggiornamento,
		concat(
			todo.nome,
			' per ',
			coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ),
			' su ',
			todo.id_progetto
		) AS __label__
	FROM todo
		LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente
		LEFT JOIN indirizzi ON indirizzi.id = todo.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
;

--| 202205020040
TRUNCATE todo_view_static;

--| 202205020050
INSERT INTO todo_view_static SELECT * FROM todo_view;


--| 202205020060
ALTER TABLE  `pianificazioni` 
    ADD COLUMN`id_contratto` int(11) DEFAULT NULL AFTER `id_attivita`,
    ADD KEY `id_contratto` (`id_contratto`),
    ADD KEY `indice_contratto` (`id`,`id_contratto`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`),
    ADD CONSTRAINT `pianificazioni_ibfk_06`             FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202205020070
CREATE OR REPLACE VIEW `pianificazioni_view` AS
	SELECT
		pianificazioni.id,
		pianificazioni.id_progetto,
		pianificazioni.id_todo,
		pianificazioni.id_attivita,
		pianificazioni.id_contratto,
		pianificazioni.nome,
		pianificazioni.id_periodicita,
		periodicita.nome AS periodicita,
		pianificazioni.cadenza,
		pianificazioni.se_lunedi,
		pianificazioni.se_martedi,
		pianificazioni.se_mercoledi,
		pianificazioni.se_giovedi,
		pianificazioni.se_venerdi,
		pianificazioni.se_sabato,
		pianificazioni.se_domenica,
		pianificazioni.schema_ripetizione,
		pianificazioni.data_elaborazione,
		pianificazioni.giorni_estensione,
		pianificazioni.data_fine,
		pianificazioni.entita,
		pianificazioni.model_id_luogo,
		pianificazioni.model_ora_inizio_programmazione,
		pianificazioni.model_ora_fine_programmazione,
		pianificazioni.workspace,
		pianificazioni.token,
		pianificazioni.id_account_inserimento,
		pianificazioni.id_account_aggiornamento,
		concat_ws(
			' ',
			pianificazioni.nome,
			periodicita.nome,
			pianificazioni.cadenza
		) as __label__
	FROM pianificazioni
		LEFT JOIN periodicita ON periodicita.id = pianificazioni.id_periodicita
;

--| 202205020090
ALTER TABLE `pianificazioni`
ADD INDEX `id_progetto` (`id_progetto`),
ADD INDEX `id_todo` (`id_todo`),
ADD INDEX `id_attivita` (`id_attivita`),
DROP INDEX `unica_progetto`,
DROP INDEX `unica_todo`,
DROP INDEX `unica_attivita`;

--| 202205020100
ALTER TABLE `metadati`
ADD COLUMN   `id_valutazione` int(11) DEFAULT NULL    AFTER `id_contratto`,
ADD KEY `id_valutazione` (`id_valutazione`), 
ADD CONSTRAINT `metadati_ibfk_21` FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202205020110
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

--| 202205020120
ALTER TABLE `file`
ADD COLUMN   `id_valutazione` int(11) DEFAULT NULL    AFTER `id_contratto`,
ADD KEY `id_valutazione` (`id_valutazione`), 
ADD CONSTRAINT `file_ibfk_23` FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202205020130
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

--| 202205020140
ALTER TABLE `immagini`
ADD COLUMN   `id_valutazione` int(11) DEFAULT NULL    AFTER `id_contratto`,
ADD KEY `id_valutazione` (`id_valutazione`), 
ADD CONSTRAINT `immagini_ibfk_19` FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202205020150
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

--| 202205020160
ALTER TABLE `video`
ADD COLUMN   `id_valutazione` int(11) DEFAULT NULL    AFTER `id_immobile`,
ADD KEY `id_valutazione` (`id_valutazione`), 
ADD CONSTRAINT `video_ibfk_19` FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202205020170
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
        video.id_valutazione,
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

--| FINE FILE
