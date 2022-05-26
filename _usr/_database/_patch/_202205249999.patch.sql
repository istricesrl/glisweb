--
-- PATCH
--

--| 202205240010
CREATE TABLE IF NOT EXISTS `tipologie_periodi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `codice` char(8) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202205240020
ALTER TABLE `tipologie_periodi`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

--| 202205240030
ALTER TABLE `tipologie_periodi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202205240040
ALTER TABLE `tipologie_periodi`
    ADD CONSTRAINT `tipologie_periodi_ibfk_01_nofollow`           FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_periodi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_periodi_ibfk_98_nofollow`           FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_periodi_ibfk_99_nofollow`           FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202205240050
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_periodi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_periodi_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_periodi.id_genitore,
				tipologie_periodi.nome
			FROM tipologie_periodi
			WHERE tipologie_periodi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 202205240060
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_periodi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_periodi_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_periodi.id_genitore
			FROM tipologie_periodi
			WHERE tipologie_periodi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 202205240070
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_periodi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_periodi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_periodi.id_genitore,
				tipologie_periodi.id
			FROM tipologie_periodi
			WHERE tipologie_periodi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 202205240080
CREATE OR REPLACE VIEW `tipologie_periodi_view` AS
	SELECT
		tipologie_periodi.id,
		tipologie_periodi.id_genitore,
		tipologie_periodi.ordine,
		tipologie_periodi.nome,
		tipologie_periodi.html_entity,
		tipologie_periodi.font_awesome,
		tipologie_periodi.id_account_inserimento,
		tipologie_periodi.id_account_aggiornamento,
		tipologie_periodi_path( tipologie_periodi.id ) AS __label__
	FROM tipologie_periodi
;

--| 202205240090
REPLACE INTO `tipologie_periodi` (`id`, `id_genitore`, `ordine`, `codice`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	NULL,	'feste',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	NULL,	'ferie',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 202205240100
CREATE TABLE IF NOT EXISTS `periodi` (
  `id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202205240110
ALTER TABLE `periodi`
	ADD PRIMARY KEY (`id`), 
	ADD	KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `indice` ( `id`, `data_inizio`, `data_fine`, `nome`,`id_tipologia`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD UNIQUE KEY `unica` ( `data_inizio`, `data_fine`, `nome`);


--| 202205240120
ALTER TABLE `periodi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202205240130
ALTER TABLE `periodi`
	ADD CONSTRAINT `periodi_ibfk_01` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_periodi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
   	ADD CONSTRAINT `periodi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
   	ADD CONSTRAINT `periodi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202205240140
CREATE OR REPLACE VIEW `periodi_view` AS
	SELECT
		periodi.id,
		periodi.id_tipologia,
		tipologie_periodi_path( periodi.id_tipologia ) AS tipologia,
		periodi.data_inizio,
		periodi.data_fine,
		periodi.id_account_inserimento,
		periodi.id_account_aggiornamento,
		concat( periodi.nome, ' dal ',CONCAT_WS('-',periodi.data_inizio),' al ',CONCAT_WS('-',periodi.data_fine)) AS __label__
	FROM periodi;

--| 202205240150
ALTER TABLE  `anagrafica` 
CHANGE   `riferimento` `riferimento` char(255) DEFAULT NULL;

--| FINE