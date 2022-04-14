--
-- PATCH
--

--| 202204140010
CREATE TABLE IF NOT EXISTS `ruoli_articoli` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` char(128) COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_progetti`int(1) DEFAULT NULL,
  `se_risorse` int(1) DEFAULT NULL,
  `se_acquisto` int(1) DEFAULT NULL,
  `se_rinnovo` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204140020
ALTER TABLE `ruoli_articoli`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `se_progetti` (`se_progetti`),
	ADD KEY `se_risorse` (`se_risorse`),
	ADD KEY `se_acquisto` (`se_acquisto`),
	ADD KEY `se_rinnovo` (`se_rinnovo`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`se_progetti`,`se_risorse`,`se_acquisto`, `se_rinnovo`);

--| 202204140030
ALTER TABLE `ruoli_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204140040
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_articoli_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_articoli_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_articoli.id_genitore,
				ruoli_articoli.nome
			FROM ruoli_articoli
			WHERE ruoli_articoli.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 202204140050
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_articoli_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_articoli_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_articoli.id_genitore
			FROM ruoli_articoli
			WHERE ruoli_articoli.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 202204140055
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_articoli_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_articoli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_articoli.id_genitore,
				ruoli_articoli.id
			FROM ruoli_articoli
			WHERE ruoli_articoli.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 202204140060
DROP TABLE IF EXISTS `ruoli_articoli_view`;

--| 202204140090
CREATE OR REPLACE VIEW ruoli_articoli_view AS
	SELECT
		ruoli_articoli.id,
		ruoli_articoli.id_genitore,
		ruoli_articoli.nome,
		ruoli_articoli.html_entity,
		ruoli_articoli.font_awesome,
		ruoli_articoli.se_progetti,
		ruoli_articoli.se_risorse,
		ruoli_articoli.se_acquisto,
        ruoli_articoli.se_rinnovo,
	 	ruoli_articoli_path( ruoli_articoli.id ) AS __label__
	FROM ruoli_articoli
;

--| 202204140100
ALTER TABLE `ruoli_articoli`
    ADD CONSTRAINT `ruoli_articoli_ibfk_01`   FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
   

-- FINE