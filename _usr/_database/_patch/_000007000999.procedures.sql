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

--| 000007003300

-- categorie_diritto_path
DROP FUNCTION IF EXISTS `categorie_diritto_path`;

--| 000007003301

-- categorie_diritto_path
-- verifica: 2021-06-01 11:06 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_diritto_path`( `p1` INT( 11 ) ) RETURNS CHAR( 255 ) CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_diritto_path( <id> ) AS path

		DECLARE path char( 255 ) DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';
		DECLARE righe int( 11 ) DEFAULT 0;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_diritto.id_genitore,
				categorie_diritto.nome,
				count( categorie_diritto.id )
			FROM categorie_diritto
			WHERE categorie_diritto.id = p1
			INTO p1, step, righe;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 000007003310

-- categorie_diritto_path_check
DROP FUNCTION IF EXISTS `categorie_diritto_path_check`;

--| 000007003311

-- categorie_diritto_path_check
-- verifica: 2021-06-01 11:08 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_diritto_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT categorie_diritto_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_diritto.id_genitore
			FROM categorie_diritto
			WHERE categorie_diritto.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 000007003320

-- categorie_diritto_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_diritto_path_find_ancestor`;

--| 000007003321

-- categorie_diritto_path_find_ancestor
-- verifica: 2021-05-23 15:24 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_diritto_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_diritto_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_diritto.id_genitore,
				categorie_diritto.id
			FROM categorie_diritto
			WHERE categorie_diritto.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 000007003500

-- categorie_eventi_path
DROP FUNCTION IF EXISTS `categorie_eventi_path`;

--| 000007003501

-- categorie_eventi_path
-- verifica: 2021-06-01 17:51 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_eventi_path`( `p1` INT( 11 ) ) RETURNS CHAR( 255 ) CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_eventi_path( <id> ) AS path

		DECLARE path char( 255 ) DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';
		DECLARE righe int( 11 ) DEFAULT 0;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_eventi.id_genitore,
				categorie_eventi.nome,
				count( categorie_eventi.id )
			FROM categorie_eventi
			WHERE categorie_eventi.id = p1
			INTO p1, step, righe;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 000007003510

-- categorie_eventi_path_check
DROP FUNCTION IF EXISTS `categorie_eventi_path_check`;

--| 000007003511

-- categorie_eventi_path_check
-- verifica: 2021-06-01 17:52 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_eventi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT categorie_eventi_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_eventi.id_genitore
			FROM categorie_eventi
			WHERE categorie_eventi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 000007003520

-- categorie_eventi_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_eventi_path_find_ancestor`;

--| 000007003521

-- categorie_eventi_path_find_ancestor
-- verifica: 2021-05-23 17:52 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_eventi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_eventi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_eventi.id_genitore,
				categorie_eventi.id
			FROM categorie_eventi
			WHERE categorie_eventi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 000007003700

-- categorie_notizie_path
DROP FUNCTION IF EXISTS `categorie_notizie_path`;

--| 000007003701

-- categorie_notizie_path
-- verifica: 2021-06-01 18:34 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_notizie_path`( `p1` INT( 11 ) ) RETURNS CHAR( 255 ) CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_notizie_path( <id> ) AS path

		DECLARE path char( 255 ) DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';
		DECLARE righe int( 11 ) DEFAULT 0;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_notizie.id_genitore,
				categorie_notizie.nome,
				count( categorie_notizie.id )
			FROM categorie_notizie
			WHERE categorie_notizie.id = p1
			INTO p1, step, righe;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 000007003710

-- categorie_notizie_path_check
DROP FUNCTION IF EXISTS `categorie_notizie_path_check`;

--| 000007003711

-- categorie_notizie_path_check
-- verifica: 2021-06-01 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_notizie_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT categorie_notizie_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_notizie.id_genitore
			FROM categorie_notizie
			WHERE categorie_notizie.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 000007003720

-- categorie_notizie_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_notizie_path_find_ancestor`;

--| 000007003721

-- categorie_notizie_path_find_ancestor
-- verifica: 2021-05-23 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_notizie_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_notizie_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_notizie.id_genitore,
				categorie_notizie.id
			FROM categorie_notizie
			WHERE categorie_notizie.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 000007003900

-- categorie_prodotti_path
DROP FUNCTION IF EXISTS `categorie_prodotti_path`;

--| 000007003901

-- categorie_prodotti_path
-- verifica: 2021-06-01 19:58 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_prodotti_path`( `p1` INT( 11 ) ) RETURNS CHAR( 255 ) CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_prodotti_path( <id> ) AS path

		DECLARE path char( 255 ) DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';
		DECLARE righe int( 11 ) DEFAULT 0;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_prodotti.id_genitore,
				categorie_prodotti.nome,
				count( categorie_prodotti.id )
			FROM categorie_prodotti
			WHERE categorie_prodotti.id = p1
			INTO p1, step, righe;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 000007003910

-- categorie_prodotti_path_check
DROP FUNCTION IF EXISTS `categorie_prodotti_path_check`;

--| 000007003911

-- categorie_prodotti_path_check
-- verifica: 2021-06-01 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_prodotti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT categorie_prodotti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_prodotti.id_genitore
			FROM categorie_prodotti
			WHERE categorie_prodotti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 000007003920

-- categorie_prodotti_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_prodotti_path_find_ancestor`;

--| 000007003921

-- categorie_prodotti_path_find_ancestor
-- verifica: 2021-05-23 19:59 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_prodotti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_prodotti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_prodotti.id_genitore,
				categorie_prodotti.id
			FROM categorie_prodotti
			WHERE categorie_prodotti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| FINE FILE
