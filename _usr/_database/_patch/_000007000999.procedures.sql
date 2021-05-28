--
-- PROCEDURE
-- questo file contiene le query per la creazione delle stored procedure e delle stored function
--

--| 000007000400

-- anagrafica_view_static
DROP PROCEDURE IF EXISTS `anagrafica_view_static`;

--| 000007000401

-- anagrafica_view_static
-- verifica: 2021-05-23 15:24 Fabio Mosti
CREATE
    DEFINER = CURRENT_USER()
    PROCEDURE `anagrafica_view_static`( IN `i` INT(11) )
    BEGIN

--        IF @TRIGGER_LAZY IS NULL THEN

            IF i IS NULL THEN

                DELETE FROM anagrafica_view_static;
                
                REPLACE INTO anagrafica_view_static SELECT * FROM anagrafica_view;

            ELSE
            
                DELETE FROM anagrafica_view_static WHERE anagrafica_view_static.id = i;

                INSERT INTO anagrafica_view_static SELECT * FROM anagrafica_view WHERE anagrafica_view.id = i;
            
            END IF;

--        END IF;

    END;

--| 000007001100

-- anagrafica_ruoli_path
DROP FUNCTION IF EXISTS `anagrafica_ruoli_path`;

--| 000007001101

-- anagrafica_ruoli_path
-- verifica: 2021-05-23 15:24 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `anagrafica_ruoli_path`( `p1` INT( 11 ) ) RETURNS CHAR( 255 ) CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_anagrafica_path( <id> ) AS path

		DECLARE path char( 255 ) DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';
		DECLARE righe int( 11 ) DEFAULT 0;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				anagrafica_ruoli.id_genitore,
				coalesce(
					anagrafica.soprannome,
					anagrafica.denominazione,
					concat( anagrafica.cognome, ' ', anagrafica.nome ),
					'' ),
				count( anagrafica_ruoli.id )
			FROM anagrafica_ruoli
			LEFT JOIN anagrafica ON anagrafica.id = anagrafica_ruoli.id_anagrafica
			WHERE anagrafica_ruoli.id = p1
			INTO p1, step, righe;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 000007001110

-- anagrafica_ruoli_path_check
DROP FUNCTION IF EXISTS `anagrafica_ruoli_path_check`;

--| 000007001111

-- anagrafica_ruoli_path_check
-- verifica: 2021-05-23 15:24 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `anagrafica_ruoli_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT anagrafica_ruoli_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				anagrafica_ruoli.id_genitore
			FROM anagrafica_ruoli
			WHERE anagrafica_ruoli.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 000007001120

-- anagrafica_ruoli_path_find_ancestor
DROP FUNCTION IF EXISTS `anagrafica_ruoli_path_find_ancestor`;

--| 000007001121

-- anagrafica_ruoli_path_find_ancestor
-- verifica: 2021-05-23 15:24 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `anagrafica_ruoli_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT anagrafica_ruoli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				anagrafica_ruoli.id_genitore,
				anagrafica_ruoli.id
			FROM anagrafica_ruoli
			WHERE anagrafica_ruoli.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| FINE FILE
