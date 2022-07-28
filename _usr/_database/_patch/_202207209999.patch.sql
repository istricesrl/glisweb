--
-- PATCH
--

--| 202207200010
CREATE TABLE IF NOT EXISTS `tipologie_banner` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202207200020
ALTER TABLE `tipologie_banner`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

--| 202207200030
ALTER TABLE `tipologie_banner` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202207200040
ALTER TABLE `tipologie_banner`
    ADD CONSTRAINT `tipologie_banner_ibfk_01_nofollow`          FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_banner` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_banner_ibfk_98_nofollow`          FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_banner_ibfk_99_nofollow`          FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202207200050
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_banner_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_banner.id_genitore,
				tipologie_banner.nome
			FROM tipologie_banner
			WHERE tipologie_banner.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 202207200060
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_banner_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN
	WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_banner.id_genitore
			FROM tipologie_banner
			WHERE tipologie_banner.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 202207200070
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_banner_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

	DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_banner.id_genitore,
				tipologie_banner.id
			FROM tipologie_banner
			WHERE tipologie_banner.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 202207200080
CREATE OR REPLACE VIEW `tipologie_banner_view` AS
	SELECT
		tipologie_banner.id,
		tipologie_banner.id_genitore,
		tipologie_banner.ordine,
		tipologie_banner.nome,
		tipologie_banner.html_entity,
		tipologie_banner.font_awesome,
		tipologie_banner.id_account_inserimento,
		tipologie_banner.id_account_aggiornamento,
		tipologie_banner_path( tipologie_banner.id ) AS __label__
	FROM tipologie_banner
;

--| 202207200090
CREATE TABLE IF NOT EXISTS `banner` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_sito` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_inserzionista` int(11) DEFAULT NULL,
  `altezza_modulo` int(11) DEFAULT NULL,
  `larghezza_modulo` int(11) DEFAULT NULL,
  `note` text,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202207200100
ALTER TABLE `banner`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_sito` (`id_sito`), 
	ADD KEY `ordine` (`ordine`), 
	ADD KEY `nome` (`nome`),
	ADD KEY `id_inserzionista` (`id_inserzionista`),
	ADD KEY `altezza_modulo` (`altezza_modulo`),	
	ADD KEY `larghezza_modulo` (`larghezza_modulo`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`, `id_tipologia`, `id_sito`, `ordine`,`nome`, `id_inserzionista`,`altezza_modulo`,`larghezza_modulo`);

--| 202207200110
ALTER TABLE `banner` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202207200120
ALTER TABLE `banner`
	ADD CONSTRAINT `banner_ibfk_01` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_banner` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
   	ADD CONSTRAINT `banner_ibfk_02_nofollow` FOREIGN KEY (`id_inserzionista`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	ADD CONSTRAINT `banner_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
   	ADD CONSTRAINT `banner_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202207200130
CREATE OR REPLACE VIEW `banner_view` AS
	SELECT
		banner.id,
		banner.id_tipologia,
		tipologie_banner_path( banner.id_tipologia ) AS tipologia,
		banner.id_sito,
		banner.ordine,
		banner.nome,
		banner.id_inserzionista,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS inserzionista,
		banner.altezza_modulo,
		banner.larghezza_modulo,
		banner.id_account_inserimento,
		banner.id_account_aggiornamento,
		concat( banner.nome, ' ', banner.altezza_modulo, 'x', banner.larghezza_modulo ) AS __label__
	FROM banner
		LEFT JOIN anagrafica ON anagrafica.id = banner.id_inserzionista
	;

--| 202207200140
CREATE TABLE IF NOT EXISTS `banner_pagine` (
  `id` int(11) NOT NULL,
  `id_pagina` int(11) NOT NULL,
  `id_banner` int(11) NOT NULL,
  `se_presente` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202207200150
ALTER TABLE `banner_pagine`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_pagina`,`id_banner`), 
	ADD KEY `id_banner` (`id_banner`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `se_presente` (`se_presente`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_pagina`,`id_banner`,`se_presente`);


--| 202207200160
ALTER TABLE `banner_pagine` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202207200170
ALTER TABLE `banner_pagine`
    ADD CONSTRAINT `banner_pagine_ibfk_01`               FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `banner_pagine_ibfk_02_nofollow`      FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `banner_pagine_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `banner_pagine_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202207200180
CREATE OR REPLACE VIEW `banner_pagine_view` AS
	SELECT
		banner_pagine.id,
		banner_pagine.id_banner,
		banner_pagine.id_pagina,
		banner_pagine.se_presente,
		banner_pagine.id_account_inserimento,
		banner_pagine.id_account_aggiornamento,
		concat(
			banner.nome,
			' / ',
			pagine_path( banner_pagine.id_pagina ),
			' / ',
			coalesce( banner_pagine.se_presente, 0 )
		) AS __label__
	FROM banner_pagine
		LEFT JOIN banner ON banner.id = banner_pagine.id_banner
;

--| 202207200190
CREATE TABLE IF NOT EXISTS `banner_azioni` (
  `id` int(11) NOT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `id_banner` int(11) NOT NULL,
  `azione` enum('visualizzazione','click') DEFAULT NULL,
  `timestamp_azione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202207200200
ALTER TABLE `banner_azioni`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_banner` (`id_banner`), 
	ADD KEY `id_pagina` (`id_pagina`),
	ADD KEY `azione` (`azione`),
	ADD KEY `timestamp_azione` (`timestamp_azione`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_pagina`,`id_banner`,`azione`,`timestamp_azione`);

--| 202207200210
ALTER TABLE `banner_azioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202207200220
ALTER TABLE `banner_azioni`
    ADD CONSTRAINT `banner_azioni_ibfk_01`               FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `banner_azioni_ibfk_02_nofollow`      FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `banner_azioni_ibfk_98_nofollow`      FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `banner_azioni_ibfk_99_nofollow`      FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202207200230
CREATE OR REPLACE VIEW `banner_azioni_view` AS
	SELECT
		banner_azioni.id,
		banner_azioni.id_banner,
		banner_azioni.id_pagina,
		banner_azioni.azione,
		banner_azioni.timestamp_azione,
		banner_azioni.id_account_inserimento,
		banner_azioni.id_account_aggiornamento,
		concat(
			banner_azioni.azione,
			' di ',
			banner.nome
		) AS __label__
	FROM banner_azioni
		LEFT JOIN banner ON banner.id = banner_azioni.id_banner
;

--| 202207200240
ALTER TABLE `metadati`
ADD COLUMN   `id_banner` int(11) DEFAULT NULL AFTER `id_tipologia_attivita`,
ADD KEY `id_banner` (`id_banner`), 
ADD UNIQUE KEY `unica_banner` (`id_lingua`,`id_banner`,`nome`), 
ADD CONSTRAINT `metadati_ibfk_24` FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202207200250
ALTER TABLE `immagini`
ADD COLUMN   `id_banner` int(11) DEFAULT NULL AFTER `id_categoria_progetti`,
ADD KEY `id_banner` (`id_banner`), 
ADD UNIQUE KEY `unica_banner` (`id_banner`,`id_ruolo`,`id_lingua`,`path`), 
ADD CONSTRAINT `immagini_ibfk_21` FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202207200260
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

--| 202207200270
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
		immagini.id_banner,
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


--| 202207200970
ALTER TABLE `pubblicazioni` 
ADD `id_banner` INT(11) DEFAULT NULL AFTER `id_categoria_progetti`,
ADD KEY `id_banner` (`id_banner`),
ADD CONSTRAINT `pubblicazioni_ibfk_13`                  FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202207200980
CREATE OR REPLACE VIEW `pubblicazioni_view` AS
    SELECT
		pubblicazioni.id,
		pubblicazioni.id_tipologia,
		tipologie_pubblicazioni.nome AS tipologia,
		pubblicazioni.ordine,
		pubblicazioni.id_prodotto,
		pubblicazioni.id_articolo,
		pubblicazioni.id_categoria_prodotti,
		pubblicazioni.id_notizia,
		pubblicazioni.id_categoria_notizie,
		pubblicazioni.id_pagina,
		pubblicazioni.id_popup,
		pubblicazioni.id_risorsa,
		pubblicazioni.id_categoria_risorse,
		pubblicazioni.id_progetto,
		pubblicazioni.id_categoria_progetti,
		pubblicazioni.id_banner,
		pubblicazioni.timestamp_inizio,
		pubblicazioni.timestamp_fine,
		concat_ws(
			' ',
			tipologie_pubblicazioni.nome,
			pubblicazioni.timestamp_inizio,
			pubblicazioni.timestamp_fine
		) AS __label__
    FROM pubblicazioni
		LEFT JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia
;

--| FINE