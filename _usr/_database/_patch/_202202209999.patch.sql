--
-- PATCH
--

--| 202202200010
CREATE TABLE IF NOT EXISTS `ruoli_matricole` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202202200020
ALTER TABLE `ruoli_matricole`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`, `html_entity`, `font_awesome`);

--| 202202200030
ALTER TABLE `ruoli_matricole` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202202200040
REPLACE INTO `ruoli_matricole` (`id`, `nome`, `html_entity`, `font_awesome`) VALUES
(1,	'attrezzatura',	    '',	    ''),
(2,	'prodotto',	    '',	    '');

--| 202202200050
ALTER TABLE `ruoli_matricole`
    ADD CONSTRAINT `ruoli_matricole_ibfk_01`    FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_matricole` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202200060
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_matricole_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_matricole_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_matricole.id_genitore,
				ruoli_matricole.nome
			FROM ruoli_matricole
			WHERE ruoli_matricole.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 202202200070
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_matricole_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_matricole_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_matricole.id_genitore
			FROM ruoli_matricole
			WHERE ruoli_matricole.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 202202200080
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_matricole_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_matricole_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_matricole.id_genitore,
				ruoli_matricole.id
			FROM ruoli_matricole
			WHERE ruoli_matricole.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 202202200090
DROP TABLE IF EXISTS `ruoli_matricole_view`;

--| 202202200100
CREATE OR REPLACE VIEW ruoli_matricole_view AS
	SELECT
		ruoli_matricole.id,
		ruoli_matricole.id_genitore,
		ruoli_matricole.nome,
    	ruoli_matricole.html_entity,
    	ruoli_matricole.font_awesome,
	 	ruoli_matricole_path( ruoli_matricole.id ) AS __label__
	FROM ruoli_matricole
;

--| 202202200110
CREATE TABLE IF NOT EXISTS `progetti_matricole` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `id_matricola` int(11) NOT NULL,
  `id_ruolo` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,	
  `id_account_inserimento` int(11) DEFAULT NULL,	
  `timestamp_aggiornamento` int(11) DEFAULT NULL,	
  `id_account_aggiornamento` int(11) DEFAULT NULL	
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202202200120
ALTER TABLE `progetti_matricole`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_progetto`,`id_categoria`,`id_ruolo`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `id_ruolo` (`id_ruolo`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_progetto`,`id_categoria`,`ordine`,`id_ruolo`);

--| 202202200130
ALTER TABLE `progetti_matricole` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202202200140
ALTER TABLE `progetti_matricole`
    ADD CONSTRAINT `progetti_matricole_ibfk_01`             FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_matricole_ibfk_02_nofollow`    FOREIGN KEY (`id_categoria`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_matricole_ibfk_03_nofollow`    FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_matricole` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `progetti_matricole_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_matricole_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202200150
ADROP TABLE IF EXISTS `progetti_matricole_view`;

--| 202202200160
CREATE OR REPLACE VIEW progetti_matricole_view AS
	SELECT
		progetti_matricole.id,
		progetti_matricole.id_progetto,
		progetti.nome AS progetto,
		progetti_matricole.id_matricola,
		matricole.matricola AS matricola,
		progetti_matricole.id_ruolo,
		ruoli_matricole_path( progetti_matricole.id_ruolo ) AS ruolo,
		progetti_matricole.ordine,
		progetti_matricole.id_account_inserimento,
		progetti_matricole.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			matricole.matricola
		) AS __label__
	FROM progetti_matricole
		LEFT JOIN progetti ON progetti.id = progetti_matricole.id_progetto
		LEFT JOIN matricole ON matricole.id = progetti_matricole.id_matricola
;
--| FINE