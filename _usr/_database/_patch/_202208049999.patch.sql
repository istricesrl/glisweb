--
-- PATCH
--

--| 202208040005
ALTER TABLE `metadati`
    DROP KEY `indice_anagrafica` ,
	DROP KEY `indice_pagina`,
	DROP KEY `indice_prodotti`,
	DROP KEY `indice_articoli` ,
	DROP KEY `indice_categorie_prodotti`,
	DROP KEY `indice_notizie`,
	DROP KEY `indice_categoria_notizie`,
	DROP KEY `indice_risorse`,
	DROP KEY `indice_categorie_risorse` ,
	DROP KEY `indice_immagini`,
	DROP KEY `indice_video` ,
	DROP KEY `indice_audio`,
    DROP KEY `indice_file`;
    
--| 202208040010
ALTER TABLE `metadati`
ADD COLUMN   `id_pianificazione` int(11) DEFAULT NULL AFTER `id_banner`,
ADD KEY `id_pianificazione` (`id_pianificazione`), 
ADD UNIQUE KEY `unica_pianificazione` (`id_lingua`,`id_pianificazione`,`nome`), 
ADD CONSTRAINT `metadati_ibfk_25` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202208040020
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
        metadati.id_tipologia_attivita,
		metadati.id_banner,
        metadati.id_pianificazione,
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

--| 202208040030
ALTER TABLE `file`
ADD COLUMN   `id_licenza` int(11) DEFAULT NULL    AFTER `id_valutazione_certificazioni`,
ADD KEY `id_licenza` (`id_licenza`), 
ADD CONSTRAINT `file_ibfk_27` FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202208040040
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
		file.id_anagrafica_certificazioni,
		file.id_valutazione_certificazioni,
        file.id_licenza,
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

--| 202208040050
ALTER TABLE `file`
DROP KEY `indice_anagrafica`,
DROP KEY `indice_prodotti`,
DROP KEY `indice_articoli`,
DROP KEY `indice_categorie_prodotti`,
DROP KEY `indice_todo`,
DROP KEY `indice_pagine`,
DROP KEY `indice_template`,
DROP KEY `indice_notizie`,
DROP KEY `indice_categorie_notizie`,
DROP KEY `indice_risorse`,
DROP KEY `indice_categorie_risorse`;

--| 202208040060
ALTER TABLE `file`
	ADD UNIQUE KEY `unica_mailing` (`id_mailing`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_mail_out` (`id_mail_out`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_mail_sent` (`id_mail_sent`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_progetto` (`id_progetto`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_categoria_progetti` (`id_categoria_progetti`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_indirizzo` (`id_indirizzo`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_edificio` (`id_edificio`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_immobile` (`id_immobile`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_contratto` (`id_contratto`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_valutazione` (`id_valutazione`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_rinnovo` (`id_rinnovo`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_anagrafica_certificazioni` (`id_anagrafica_certificazioni`,`id_ruolo`,`path`), 	
	ADD UNIQUE KEY `unica_valutazione_certificazioni` (`id_valutazione_certificazioni`,`id_ruolo`,`path`), 
	ADD UNIQUE KEY `unica_licenza` (`id_licenza`,`id_ruolo`,`path`);

--| 202208040070
CREATE TABLE IF NOT EXISTS `banner_zone` (
  `id` int(11) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `id_banner` int(11) NOT NULL,
  `se_presente` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202208040080
ALTER TABLE `banner_zone`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_zona`,`id_banner`), 
	ADD KEY `id_banner` (`id_banner`), 
	ADD KEY `id_zona` (`id_zona`),
	ADD KEY `se_presente` (`se_presente`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_zona`,`id_banner`,`se_presente`);

--| 202208040090
ALTER TABLE `banner_zone` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202208040100
ALTER TABLE `banner_zone`
    ADD CONSTRAINT `banner_zone_ibfk_01`               FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `banner_zone_ibfk_02_nofollow`      FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `banner_zone_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `banner_zone_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202208040110
CREATE OR REPLACE VIEW `banner_zone_view` AS
	SELECT
		banner_zone.id,
		banner_zone.id_banner,
		banner_zone.id_zona,
		banner_zone.se_presente,
		banner_zone.id_account_inserimento,
		banner_zone.id_account_aggiornamento,
		concat(
			banner.nome,
			' / ',
			zone_path( banner_zone.id_zona ),
			' / ',
			coalesce( banner_zone.se_presente, 0 )
		) AS __label__
	FROM banner_zone
		LEFT JOIN banner ON banner.id = banner_zone.id_banner
;

--| FINE