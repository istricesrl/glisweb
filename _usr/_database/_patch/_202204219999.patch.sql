--
-- PATCH
--

--| 202204210010
CREATE TABLE `tipologie_edifici` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB;

--| 202204210020
ALTER TABLE `tipologie_edifici`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
  	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
  	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

--| 202204210030
ALTER TABLE `tipologie_edifici` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204210040
INSERT INTO `tipologie_edifici` (`id`, `id_genitore`, `nome`) VALUES
(1, NULL, 'palazzo'),
(2, NULL, 'palazzo storico'),
(3, NULL, 'palazzina'),
(4, NULL, 'complesso'),
(5, NULL, 'residence'),
(6, NULL, 'edificio indipendente');

--| 202204210050
ALTER TABLE `tipologie_edifici`
  ADD CONSTRAINT `tipologie_edifici_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_edifici` (`id`),
  ADD CONSTRAINT `tipologie_edifici_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `tipologie_edifici_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202204210060
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_edifici_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_edifici_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_edifici.id_genitore,
				tipologie_edifici.nome
			FROM tipologie_edifici
			WHERE tipologie_edifici.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 202204210070
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_edifici_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 int( 11 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_edifici_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_edifici.id_genitore
			FROM tipologie_edifici
			WHERE tipologie_edifici.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 202204210080
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_edifici_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_edifici_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_edifici.id_genitore,
				tipologie_edifici.id
			FROM tipologie_edifici
			WHERE tipologie_edifici.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 202204210090
CREATE OR REPLACE VIEW tipologie_edifici_view AS
	SELECT
	tipologie_edifici.id,
	tipologie_edifici.id_genitore,
	tipologie_edifici.ordine,
	tipologie_edifici.nome,
	tipologie_edifici.html_entity,
	tipologie_edifici.font_awesome,
	tipologie_edifici.id_account_inserimento,
	tipologie_edifici.id_account_aggiornamento,
	tipologie_edifici_path( tipologie_edifici.id )  AS __label__
	FROM tipologie_edifici
	;
	
--| 202204210100
CREATE TABLE IF NOT EXISTS `edifici` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `piani` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB;

--| 202204210110
ALTER TABLE `edifici`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_tipologia` (`id_tipologia`),
  ADD KEY `id_indirizzo` (`id_indirizzo`),
  ADD KEY `nome` (`nome`),
  ADD KEY `codice` (`codice`),
  ADD KEY `id_account_inserimento` (`id_account_inserimento`),
  ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  ADD KEY `indice` (`id`, `id_tipologia`, `id_indirizzo`, `nome`, `codice`);
  
--| 202204210120
ALTER TABLE `edifici`  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204210130
ALTER TABLE `edifici`
  ADD CONSTRAINT `edifici_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_edifici` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `edifici_ibfk_02_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `edifici_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `edifici_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202204210140
CREATE OR REPLACE VIEW edifici_view AS
	SELECT
		edifici.id,
		edifici.id_tipologia,
		tipologie_edifici.nome AS tipologia,
		edifici.id_indirizzo,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		edifici.codice,
		edifici.nome,
		edifici.piani,
		edifici.id_account_inserimento,
		edifici.id_account_aggiornamento,
		concat_ws(
			' ',
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM edifici
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

--| 202204210141
CREATE TABLE `tipologie_immobili` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_residenziale` int(1) DEFAULT NULL,
  `se_industriale` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204210142
ALTER TABLE `tipologie_immobili`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY  `se_residenziale` (`se_residenziale`),
  	ADD KEY `se_industriale` (`se_industriale`),
  	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
  	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`, `se_residenziale`, `se_industriale`);

--| 202204210143
ALTER TABLE `tipologie_immobili` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204210144
INSERT INTO `tipologie_immobili` (`id`, `nome`, `se_residenziale`, `se_industriale`) VALUES
(1, 'appartamento', 1, NULL),
(3, 'abitazione', 1, NULL),
(6, 'garage', 1, NULL),
(7, 'magazzino', 1, 1),
(8, 'ufficio', NULL, 1),
(9, 'negozio', NULL, 1);

--| 202204210145
ALTER TABLE `tipologie_immobili`
  ADD CONSTRAINT `tipologie_immobili_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_immobili` (`id`),
  ADD CONSTRAINT `tipologie_immobili_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `tipologie_immobili_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202204210146
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_immobili_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_immobili_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_immobili.id_genitore,
				tipologie_immobili.nome
			FROM tipologie_immobili
			WHERE tipologie_immobili.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 202204210147
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_immobili_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 int( 11 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_immobili_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_immobili.id_genitore
			FROM tipologie_immobili
			WHERE tipologie_immobili.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 202204210148
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_immobili_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_immobili_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_immobili.id_genitore,
				tipologie_immobili.id
			FROM tipologie_immobili
			WHERE tipologie_immobili.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 202204210149
CREATE OR REPLACE VIEW tipologie_immobili_view AS
	SELECT
	tipologie_immobili.id,
	tipologie_immobili.id_genitore,
	tipologie_immobili.ordine,
	tipologie_immobili.nome,
	tipologie_immobili.html_entity,
	tipologie_immobili.font_awesome,
	tipologie_immobili.se_residenziale ,
	tipologie_immobili.se_industriale ,
	tipologie_immobili.id_account_inserimento,
	tipologie_immobili.id_account_aggiornamento,
	tipologie_immobili_path( tipologie_immobili.id )  AS __label__
	FROM tipologie_immobili
	;


--| 202204210150
CREATE TABLE IF NOT EXISTS  `immobili` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_edificio` int(11) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `scala` char(32) DEFAULT NULL,
  `piano` char(64) DEFAULT NULL,
  `interno` char(8) DEFAULT NULL,
  `campanello` char(128) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204210160
ALTER TABLE `immobili`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unica` (`id_tipologia`,`id_edificio`, `scala`,  `piano`, `interno`, `nome`, `codice`),
  ADD KEY `id_tipologia` (`id_tipologia`),
  ADD KEY `id_edificio` (`id_edificio`),
  ADD KEY `nome` (`nome`),
  ADD KEY `codice` (`codice`),
  ADD KEY `scala` (`scala`),
  ADD KEY `piano` (`piano`),
  ADD KEY `interno` (`interno`),
  ADD KEY `id_account_inserimento` (`id_account_inserimento`),
  ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);

--| 202204210170
ALTER TABLE `immobili`  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204210180
ALTER TABLE `immobili`
  ADD CONSTRAINT `immobili_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_immobili` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `immobili_ifbk_02_nofollow` FOREIGN KEY (`id_edificio`) REFERENCES `edifici` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `immobili_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `immobili_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202204210190
CREATE OR REPLACE VIEW immobili_view AS
	SELECT
		immobili.id,
		immobili.id_tipologia,
		tipologie_immobili.nome AS tipologia,
		immobili.id_edificio,
		immobili.nome,
		immobili.codice,
		edifici.id_indirizzo,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		immobili.scala,
		immobili.piano,
		immobili.interno,
immobili.campanello,
		immobili.id_account_inserimento,
		immobili.id_account_aggiornamento,
		concat_ws(
			' ',
    tipologie_immobili.nome, 
    coalesce(
      concat('scala ', immobili.scala), 
      ''
    ), 
    coalesce(
      concat('piano ', immobili.piano), 
      ''
    ), 
    coalesce(
      concat('int. ', immobili.interno), 
      ''
    ),
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM immobili
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

--| 202204210200
ALTER TABLE `ruoli_anagrafica` DROP KEY indice;

--| 202204210210
ALTER TABLE `ruoli_anagrafica` ADD `se_immobili` int NULL,
ADD KEY `se_immobili` (`se_immobili`),
ADD KEY `indice` (`id`,`id_genitore`,`nome`,`se_organizzazioni`,`se_risorse`,`se_progetti`, `se_immobili`);

--| 202204210220
INSERT INTO `ruoli_anagrafica` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_organizzazioni`, `se_relazioni`, `se_risorse`, `se_progetti`, `se_didattica`, `se_immobili`) VALUES
(1,	NULL,	'titolare',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	'amministratore',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	'socio',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	'dipendente',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	'direttore',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	'presidente',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	'tesoriere',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	'coordinatore',	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL),
(9,	NULL,	'vicepresidente',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	'vicedirettore',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	'segretario',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	'responsabile amministrativo',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	NULL,	'responsabile acquisti',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	NULL,	'responsabile operativo',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	NULL,	'operatore',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(16,	NULL,	'responsabile',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(17,	NULL,	'assistente',	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL),
(18,	NULL,	'autore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(19,	NULL,	'genitore',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(20,	NULL,	'fratello',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(21,	NULL,	'tutore',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(22,	NULL,	'coniuge',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(23,	NULL,	'collega',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(24,	NULL,	'docente',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL),
(25,	NULL,	'istruttore',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL),
(26,	NULL,	'proprietario',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1)
ON DUPLICATE KEY UPDATE
	id_genitore = VALUES( id_genitore ),
	nome = VALUES(nome),
	html_entity = VALUES(html_entity),
	font_awesome = VALUES(font_awesome),
	se_organizzazioni = VALUES(se_organizzazioni),
	se_relazioni = VALUES(se_relazioni),
	se_risorse = VALUES(se_risorse),
	se_progetti = VALUES(se_progetti),
	se_didattica = VALUES(se_didattica),
	se_immobili = VALUES(se_immobili);

--| 202204210230
CREATE OR REPLACE VIEW ruoli_anagrafica_view AS
	SELECT
		ruoli_anagrafica.id,
		ruoli_anagrafica.id_genitore,
		ruoli_anagrafica.nome,
		ruoli_anagrafica.se_organizzazioni,
		ruoli_anagrafica.se_relazioni,
		ruoli_anagrafica.se_risorse,
		ruoli_anagrafica.se_progetti,
		ruoli_anagrafica.se_immobili,
	 	ruoli_anagrafica_path( ruoli_anagrafica.id ) AS __label__
	FROM ruoli_anagrafica
;

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

--| 202204215130
CREATE OR REPLACE VIEW `fatture_attive_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		documenti.timestamp_chiusura,
		concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' per ',
			coalesce(
				a2.denominazione,
				concat(
					a2.cognome,
					' ',
					a2.nome
				),
				''
			)
		) AS __label__
    FROM
		documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
   	WHERE tipologie_documenti.se_fattura IS NOT NULL
	   AND anagrafica_check_gestita( a1.id ) IS NOT NULL
;

--| 202204215140
CREATE OR REPLACE VIEW `fatture_passive_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		documenti.timestamp_chiusura,
		concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' per ',
			coalesce(
				a2.denominazione,
				concat(
					a2.cognome,
					' ',
					a2.nome
				),
				''
			)
		) AS __label__
    FROM
		documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
   	WHERE tipologie_documenti.se_fattura IS NOT NULL
	   AND anagrafica_check_gestita( a2.id ) IS NOT NULL
;

--| 202204215150
CREATE TABLE IF NOT EXISTS `immobili_anagrafica` (
  `id` int(11) NOT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204215160
ALTER TABLE `immobili_anagrafica`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_immobile`,`id_anagrafica`,`id_ruolo`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_immobile`,`id_anagrafica`,`id_ruolo`,`ordine`);

--| 202204215170
ALTER TABLE `immobili_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204215180
ALTER TABLE `immobili_anagrafica`
    ADD CONSTRAINT `immobili_anagrafica_ibfk_01`            FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `immobili_anagrafica_ibfk_02_nofollow`   FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `immobili_anagrafica_ibfk_03_nofollow`   FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `immobili_anagrafica_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `immobili_anagrafica_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
    

--| 202204215190
CREATE OR REPLACE VIEW  immobili_anagrafica_view AS 
	SELECT 
		immobili_anagrafica.id,
		immobili_anagrafica.id_immobile,
		immobili_anagrafica.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		immobili_anagrafica.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		immobili_anagrafica.ordine,
		immobili_anagrafica.id_account_inserimento ,
		immobili_anagrafica.id_account_aggiornamento ,
		concat( 'immobile ', immobili_anagrafica.id_immobile, ' - ', coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ), ' ruolo ', ruoli_anagrafica.nome  ) AS __label__
	FROM immobili_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = immobili_anagrafica.id_ruolo
		LEFT JOIN anagrafica ON anagrafica.id = immobili_anagrafica.id_anagrafica;

--| 202204215200
CREATE TABLE `condizioni` (
  `id` int(11) NOT NULL,
  `nome` char(32) DEFAULT NULL,
  `se_catalogo` int(1) DEFAULT NULL,
  `se_immobili` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204215210
ALTER TABLE `condizioni`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `nome` (`nome`),
	ADD KEY `se_catalogo` (`se_catalogo`),
	ADD KEY `se_immobili` (`se_immobili`),
	ADD UNIQUE KEY `unico` (`nome`);

--| 202204215220
ALTER TABLE `condizioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204215230
CREATE OR REPLACE VIEW condizioni_view AS
	SELECT
		condizioni.id,
		condizioni.nome,
		condizioni.se_immobili,
		condizioni.se_catalogo,
		condizioni.nome AS __label__
	FROM
		condizioni
;

--| 202204215240
INSERT INTO `condizioni` (`id`, `nome`, `se_catalogo`, `se_immobili`) VALUES
(1,	'nuovo',	1,	1),
(2,	'usato',	1,	NULL),
(3,	'da ristrutturare',	NULL,	1);

--| 202204215250
CREATE TABLE `disponibilita` (
  `id` int(11) NOT NULL,
  `nome` char(32) DEFAULT NULL,
  `se_catalogo` int(1) DEFAULT NULL,
  `se_immobili` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204215260
ALTER TABLE `disponibilita`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `nome` (`nome`),
	ADD KEY `se_catalogo` (`se_catalogo`),
	ADD KEY `se_immobili` (`se_immobili`),
	ADD UNIQUE KEY `unico` (`nome`);

--| 202204215270
ALTER TABLE `disponibilita` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204215280
CREATE OR REPLACE VIEW disponibilita_view AS
	SELECT
		disponibilita.id,
		disponibilita.nome,
		disponibilita.se_immobili,
		disponibilita.se_catalogo,
		disponibilita.nome AS __label__
	FROM
		disponibilita
;

--| 202204215290
INSERT INTO `disponibilita` (`id`, `nome`, `se_catalogo`, `se_immobili`) VALUES
(1,	'disponibile',	1,	1),
(2,	'in riassortimento',	1,	NULL),
(3,	'nuda proprietà',	NULL,	1);

--| 202204215300
CREATE TABLE `valutazioni` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `mq_commerciali` decimal(15,2) DEFAULT NULL,
  `mq_calpestabili` decimal(15,2) DEFAULT NULL,
  `id_condizione` int(11) DEFAULT NULL,
  `id_disponibilita` int(11) DEFAULT NULL,
  `id_classe_energetica` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `timestamp_valutazione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204215310
ALTER TABLE `valutazioni`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_immobile`,`timestamp_valutazione`),
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_matricola` (`id_matricola`), 
	ADD KEY `id_immobile` (`id_immobile`), 
	ADD KEY `id_condizione` (`id_condizione`), 
	ADD KEY `id_disponibilita` (`id_disponibilita`), 
	ADD KEY `id_classe_energetica` (`id_classe_energetica`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_matricola`,`id_anagrafica`,`id_immobile`, `id_condizione`, `id_disponibilita`, `id_classe_energetica`); 

--| 202204215320
ALTER TABLE `valutazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204215330
CREATE TABLE IF NOT EXISTS `classi_energetiche` (
`id` int(11) NOT NULL,
  `nome` char(8) NOT NULL,
  `ep_min` int(11) DEFAULT NULL,
  `ep_max` int(11) DEFAULT NULL,
  `rgb` char(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204215340
ALTER TABLE `classi_energetiche`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`);

--| 202204215350
ALTER TABLE `classi_energetiche` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204215360
INSERT INTO `classi_energetiche` (`id`, `nome`, `ep_min`, `ep_max`, `rgb`) VALUES
(1, 'G', NULL, NULL, 'ff2a1a'),
(2, 'F', NULL, NULL, 'c0504d'),
(3, 'E', NULL, NULL, 'e46c1c'),
(4, 'D', NULL, NULL, 'ffc02b'),
(5, 'C', NULL, NULL, 'fef934'),
(6, 'B', NULL, NULL, '99cc26'),
(7, 'A1', NULL, NULL, '00cc22'),
(8, 'A2', NULL, NULL, '009917'),
(9, 'A3', NULL, NULL, '00660c'),
(10, 'A4', NULL, NULL, '33660d')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	ep_min = VALUES( ep_min ),
	ep_max = VALUES( ep_max ),
	rgb = VALUES( rgb );

--| 202204215370
CREATE OR REPLACE VIEW classi_energetiche_view AS
	SELECT
		classi_energetiche.id,
		classi_energetiche.nome,
		classi_energetiche.ep_min,
		classi_energetiche.ep_max,
		classi_energetiche.rgb,
		classi_energetiche.nome AS __label__
	FROM classi_energetiche
;

--| 202204215380
ALTER TABLE `valutazioni`
    ADD CONSTRAINT `valutazioni_ibfk_01_nofollow`       FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `valutazioni_ibfk_02_nofollow`       FOREIGN KEY (`id_matricola`) REFERENCES `matricole` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `valutazioni_ibfk_03_nofollow`       FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `valutazioni_ibfk_04_nofollow`       FOREIGN KEY (`id_condizione`) REFERENCES `condizioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `valutazioni_ibfk_05_nofollow`       FOREIGN KEY (`id_disponibilita`) REFERENCES `disponibilita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `valutazioni_ibfk_06_nofollow`       FOREIGN KEY (`id_classe_energetica`) REFERENCES `classi_energetiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `valutazioni_ibfk_98_nofollow`       FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `valutazioni_ibfk_99_nofollow`       FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202204215390
CREATE OR REPLACE VIEW valutazioni_view AS
	SELECT
		valutazioni.id,
		valutazioni.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		valutazioni.id_matricola,
		matricole.matricola AS matricola,
		valutazioni.id_immobile,
		immobili.nome AS immobile,
		valutazioni.mq_commerciali,
		valutazioni.mq_calpestabili,
		valutazioni.id_condizione,
		condizioni.nome AS condizione,
		valutazioni.id_disponibilita,
		disponibilita.nome AS disponibilita,
		valutazioni.id_classe_energetica,
		classi_energetiche.nome AS classe_energetica,
		valutazioni.timestamp_valutazione,
		valutazioni.id_account_inserimento,
		valutazioni.id_account_aggiornamento,
		concat('valutazione ', immobili.nome) AS __label__
	FROM valutazioni
		LEFT JOIN anagrafica ON anagrafica.id = valutazioni.id_anagrafica
		LEFT JOIN matricole ON matricole.id = valutazioni.id_matricola
		LEFT JOIN immobili ON immobili.id = valutazioni.id_immobile
		LEFT JOIN condizioni ON condizioni.id = valutazioni.id_condizione
		LEFT JOIN disponibilita ON disponibilita.id = valutazioni.id_disponibilita
		LEFT JOIN classi_energetiche ON classi_energetiche.id = valutazioni.id_classe_energetica;

--| 202204215400
ALTER TABLE `ruoli_anagrafica` DROP KEY indice;


--| 202204215410
ALTER TABLE `ruoli_anagrafica` ADD `se_contratti` int NULL,
ADD KEY `se_contratti` (`se_contratti`),
ADD KEY `indice` (`id`,`id_genitore`,`nome`,`se_organizzazioni`,`se_risorse`,`se_progetti`, `se_immobili`, `se_contratti`);


--| 202204215420
INSERT INTO `ruoli_anagrafica` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_produzione`, `se_didattica`, `se_organizzazioni`, `se_relazioni`, `se_risorse`, `se_progetti`, `se_immobili`, `se_contratti`) VALUES
(1,	NULL,	'titolare',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	'amministratore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	'socio',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	'dipendente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	'direttore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	'presidente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	'tesoriere',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	'coordinatore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL),
(9,	NULL,	'vicepresidente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	'vicedirettore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	'segretario',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	'responsabile amministrativo',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	NULL,	'responsabile acquisti',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	NULL,	'responsabile operativo',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	NULL,	'operatore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(16,	NULL,	'responsabile',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(17,	NULL,	'assistente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL),
(18,	NULL,	'autore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(19,	NULL,	'genitore',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(20,	NULL,	'fratello',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(21,	NULL,	'tutore',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(22,	NULL,	'coniuge',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(23,	NULL,	'collega',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(24,	NULL,	'docente',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(25,	NULL,	'istruttore',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(26,	NULL,	'proprietario',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(27,	NULL,	'proponente',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(28,	NULL,	'contraente',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1)
ON DUPLICATE KEY UPDATE
	id_genitore = VALUES( id_genitore ),
	nome = VALUES(nome),
	html_entity = VALUES(html_entity),
	font_awesome = VALUES(font_awesome),
	se_organizzazioni = VALUES(se_organizzazioni),
	se_relazioni = VALUES(se_relazioni),
	se_risorse = VALUES(se_risorse),
	se_progetti = VALUES(se_progetti),
	se_didattica = VALUES(se_didattica),
	se_immobili = VALUES(se_immobili),
	se_contratti = VALUES(se_contratti);

--| 202204215430
CREATE OR REPLACE VIEW ruoli_anagrafica_view AS
	SELECT
		ruoli_anagrafica.id,
		ruoli_anagrafica.id_genitore,
		ruoli_anagrafica.nome,
		ruoli_anagrafica.se_produzione,
		ruoli_anagrafica.se_didattica,
		ruoli_anagrafica.se_organizzazioni,
		ruoli_anagrafica.se_relazioni,
		ruoli_anagrafica.se_risorse,
		ruoli_anagrafica.se_progetti,
		ruoli_anagrafica.se_immobili,
		ruoli_anagrafica.se_contratti,
	 	ruoli_anagrafica_path( ruoli_anagrafica.id ) AS __label__
	FROM ruoli_anagrafica
;

--| 202204215440
CREATE TABLE IF NOT EXISTS `contratti_anagrafica` (
  `id` int(11) NOT NULL,
  `id_contratto` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204215450
ALTER TABLE `contratti_anagrafica`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_contratto`,`id_anagrafica`,`id_ruolo`), 
	ADD KEY `id_contratto` (`id_contratto`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_contratto`,`id_anagrafica`,`id_ruolo`,`ordine`);

--| 202204215460
ALTER TABLE `contratti_anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204215470
ALTER TABLE `contratti_anagrafica`
    ADD CONSTRAINT `contratti_anagrafica_ibfk_01`            FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `contratti_anagrafica_ibfk_02_nofollow`   FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `contratti_anagrafica_ibfk_03_nofollow`   FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `contratti_anagrafica_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `contratti_anagrafica_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202204215480
CREATE OR REPLACE VIEW  contratti_anagrafica_view AS 
	SELECT 
		contratti_anagrafica.id,
		contratti_anagrafica.id_contratto,
		contratti_anagrafica.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		contratti_anagrafica.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		contratti_anagrafica.ordine,
		contratti_anagrafica.id_account_inserimento ,
		contratti_anagrafica.id_account_aggiornamento ,
		concat( 'contratto ', contratti.nome, ' - ', coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ), ' ruolo ', ruoli_anagrafica.nome  ) AS __label__
	FROM contratti_anagrafica
		LEFT JOIN contratti ON contratti.id = contratti_anagrafica.id_contratto
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = contratti_anagrafica.id_ruolo
		LEFT JOIN anagrafica ON anagrafica.id = contratti_anagrafica.id_anagrafica;

--| 202204215489
ALTER TABLE contratti drop key indice;

--| 202204215490
ALTER TABLE contratti
change   `nome`  `nome` char(128) DEFAULT NULL,
change `id_destinatario`  `id_destinatario` int DEFAULT NULL,
ADD COLUMN `id_immobile` int(11) DEFAULT NULL,
ADD KEY  `id_immobile` ( `id_immobile` ),
ADD KEY `indice` ( `id_tipologia`, `id_emittente`, `id_destinatario`, `nome`, `id_progetto`, `id_immobile`),
ADD CONSTRAINT `contratti_ibfk_05_nofollow` FOREIGN KEY (`id_immobile`) REFERENCES `immobili` (`id`);

--| 202204215500
CREATE OR REPLACE VIEW `contratti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.id_immobile,
		immobili.nome AS immobile,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		group_concat( DISTINCT concat( coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),': ', ruoli_anagrafica.nome ) SEPARATOR ' | ' ) AS parti,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN immobili ON immobili.id = contratti.id_immobile
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id
		LEFT JOIN anagrafica ON anagrafica.id = contratti_anagrafica.id_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = contratti_anagrafica.id_ruolo
	GROUP BY contratti.id, tipologie_contratti.nome
;

--| 202204215510
ALTER TABLE `metadati`
ADD COLUMN   `id_contratto` int(11) DEFAULT NULL    AFTER `id_immobile`,
ADD KEY `id_contratto` (`id_contratto`), 
ADD CONSTRAINT `metadati_ibfk_20` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204215520
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

--| 202204215530
ALTER TABLE `file`
ADD COLUMN   `id_contratto` int(11) DEFAULT NULL    AFTER `id_immobile`,
ADD KEY `id_contratto` (`id_contratto`), 
ADD CONSTRAINT `file_ibfk_22` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204215540
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

--| 202204215550
ALTER TABLE `immagini`
ADD COLUMN   `id_contratto` int(11) DEFAULT NULL    AFTER `id_edificio`,
ADD KEY `id_contratto` (`id_contratto`), 
ADD CONSTRAINT `immagini_ibfk_18` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202204215560
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

--| 202204215570
ALTER TABLE `attivita` ADD `id_matricola` INT NULL DEFAULT NULL AFTER `id_progetto`, 
ADD INDEX `id_matricola` (`id_matricola`),
    ADD CONSTRAINT `attivita_ibfk_12_nofollow` FOREIGN KEY (`id_matricola`) REFERENCES `matricole` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202204215580
CREATE OR REPLACE VIEW `attivita_view` AS
	SELECT	
		attivita.id,
		attivita.id_tipologia,
		tipologie_attivita.nome AS tipologia,
		attivita.id_cliente,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		attivita.id_indirizzo,
		indirizzi.indirizzo AS indirizzo,
		attivita.id_luogo,
		luoghi_path( attivita.id_luogo ) AS luogo,
		attivita.data_scadenza,
		attivita.ora_scadenza,
		attivita.data_programmazione,
		attivita.ora_inizio_programmazione,
		attivita.ora_fine_programmazione,
		attivita.id_anagrafica_programmazione,
		coalesce( a3.denominazione , concat( a3.cognome, ' ', a3.nome ), '' ) AS anagrafica_programmazione,
		attivita.ore_programmazione,
		attivita.data_attivita,
		day( data_attivita ) as giorno_attivita,
		month( data_attivita ) as mese_attivita,
		year( data_attivita ) as anno_attivita,
		attivita.ora_inizio,
		attivita.latitudine_ora_inizio,
		attivita.longitudine_ora_inizio,
		attivita.ora_fine,
		attivita.latitudine_ora_fine,
		attivita.longitudine_ora_fine,
		attivita.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		attivita.ore,
		attivita.nome,
		attivita.id_documento,
		concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			documenti.sezionale,
			' del ',
			documenti.data
		) AS documento,
		attivita.id_progetto,
		progetti.nome AS progetto,
		attivita.id_matricola,
		attivita.id_todo,
		todo.nome AS todo,
		attivita.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		attivita.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		attivita.codice_archivium,
		attivita.token,
		attivita.id_account_inserimento,
		attivita.id_account_aggiornamento,
		concat(
			attivita.nome,
			' / ',
			attivita.ore,
			' / ',
			coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM attivita
		LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = attivita.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = attivita.id_cliente
		LEFT JOIN anagrafica AS a3 ON a3.id = attivita.id_anagrafica_programmazione
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = attivita.id_progetto
		LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria
		LEFT JOIN progetti ON progetti.id = attivita.id_progetto
		LEFT JOIN todo ON todo.id = attivita.id_todo
		LEFT JOIN indirizzi ON indirizzi.id = attivita.id_indirizzo
		LEFT JOIN mastri AS m1 ON m1.id = attivita.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = attivita.id_mastro_destinazione
		LEFT JOIN documenti ON documenti.id = attivita.id_documento
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
;


--| FINE

