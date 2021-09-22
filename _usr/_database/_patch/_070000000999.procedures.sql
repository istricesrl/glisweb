--
-- PROCEDURE
-- questo file contiene le query per la creazione delle stored procedure e delle stored function
--

--| 070000000400

-- anagrafica_view_static
DROP PROCEDURE IF EXISTS `anagrafica_view_static`;

--| 070000000401

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

--| 070000003700

-- categorie_notizie_path
DROP FUNCTION IF EXISTS `categorie_notizie_path`;

--| 070000003701

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

--| 070000003710

-- categorie_notizie_path_check
DROP FUNCTION IF EXISTS `categorie_notizie_path_check`;

--| 070000003711

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

--| 070000003720

-- categorie_notizie_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_notizie_path_find_ancestor`;

--| 070000003721

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

--| 070000003900

-- categorie_prodotti_path
DROP FUNCTION IF EXISTS `categorie_prodotti_path`;

--| 070000003901

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

--| 070000003910

-- categorie_prodotti_path_check
DROP FUNCTION IF EXISTS `categorie_prodotti_path_check`;

--| 070000003911

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

--| 070000003920

-- categorie_prodotti_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_prodotti_path_find_ancestor`;

--| 070000003921

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

--| 070000004300

-- categorie_progetti_path
DROP FUNCTION IF EXISTS `categorie_progetti_path`;

--| 070000004301

-- categorie_progetti_path
-- verifica: 2021-06-02 19:52 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_progetti_path`( `p1` INT( 11 ) ) RETURNS CHAR( 255 ) CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_progetti_path( <id> ) AS path

		DECLARE path char( 255 ) DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';
		DECLARE righe int( 11 ) DEFAULT 0;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_progetti.id_genitore,
				categorie_progetti.nome,
				count( categorie_progetti.id )
			FROM categorie_progetti
			WHERE categorie_progetti.id = p1
			INTO p1, step, righe;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000004310

-- categorie_progetti_path_check
DROP FUNCTION IF EXISTS `categorie_progetti_path_check`;

--| 070000004311

-- categorie_progetti_path_check
-- verifica: 2021-06-02 19:55 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_progetti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT categorie_progetti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_progetti.id_genitore
			FROM categorie_progetti
			WHERE categorie_progetti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000004320

-- categorie_progetti_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_progetti_path_find_ancestor`;

--| 070000004321

-- categorie_progetti_path_find_ancestor
-- verifica: 2021-06-02 19:56 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_progetti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_progetti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_progetti.id_genitore,
				categorie_progetti.id
			FROM categorie_progetti
			WHERE categorie_progetti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000004500

-- categorie_risorse_path
DROP FUNCTION IF EXISTS `categorie_risorse_path`;

--| 070000004501

-- categorie_risorse_path
-- verifica: 2021-06-02 20:22 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_risorse_path`( `p1` INT( 11 ) ) RETURNS CHAR( 255 ) CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_risorse_path( <id> ) AS path

		DECLARE path char( 255 ) DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';
		DECLARE righe int( 11 ) DEFAULT 0;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_risorse.id_genitore,
				categorie_risorse.nome,
				count( categorie_risorse.id )
			FROM categorie_risorse
			WHERE categorie_risorse.id = p1
			INTO p1, step, righe;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000004510

-- categorie_risorse_path_check
DROP FUNCTION IF EXISTS `categorie_risorse_path_check`;

--| 070000004511

-- categorie_risorse_path_check
-- verifica: 2021-06-02 20:22 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_risorse_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT categorie_risorse_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_risorse.id_genitore
			FROM categorie_risorse
			WHERE categorie_risorse.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000004520

-- categorie_risorse_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_risorse_path_find_ancestor`;

--| 070000004521

-- categorie_risorse_path_find_ancestor
-- verifica: 2021-06-02 19:56 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_risorse_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_risorse_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_risorse.id_genitore,
				categorie_risorse.id
			FROM categorie_risorse
			WHERE categorie_risorse.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000005100

-- colori_path
DROP FUNCTION IF EXISTS `colori_path`;

--| 070000005101

-- colori_path
-- verifica: 2021-06-03 15:19 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `colori_path`( `p1` INT( 11 ) ) RETURNS CHAR( 255 ) CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT colori_path( <id> ) AS path

		DECLARE path char( 255 ) DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';
		DECLARE righe int( 11 ) DEFAULT 0;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				colori.id_genitore,
				colori.nome,
				count( colori.id )
			FROM colori
			WHERE colori.id = p1
			INTO p1, step, righe;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000005110

-- colori_path_check
DROP FUNCTION IF EXISTS `colori_path_check`;

--| 070000005111

-- colori_path_check
-- verifica: 2021-06-03 15:25 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `colori_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT colori_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				colori.id_genitore
			FROM colori
			WHERE colori.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000005120

-- colori_path_find_ancestor
DROP FUNCTION IF EXISTS `colori_path_find_ancestor`;

--| 070000005121

-- colori_path_find_ancestor
-- verifica: 2021-06-02 19:56 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `colori_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT colori_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				colori.id_genitore,
				colori.id
			FROM colori
			WHERE colori.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000015200

-- gruppi_path
DROP FUNCTION IF EXISTS `gruppi_path`;

--| 070000015201

-- gruppi_path
-- verifica: 2021-09-10 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `gruppi_path`( `p1` INT( 11 ) ) RETURNS CHAR( 255 ) CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT gruppi_path( <id> ) AS path

		DECLARE path char( 255 ) DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';
		DECLARE righe int( 11 ) DEFAULT 0;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				gruppi.id_genitore,
				gruppi.nome,
				count( gruppi.id )
			FROM gruppi
			WHERE gruppi.id = p1
			INTO p1, step, righe;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000015210

-- gruppi_path_check
DROP FUNCTION IF EXISTS `gruppi_path_check`;

--| 070000015211

-- gruppi_path_check
-- verifica: 2021-09-10 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `gruppi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT gruppi_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				gruppi.id_genitore
			FROM gruppi
			WHERE gruppi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000015220

-- gruppi_path_find_ancestor
DROP FUNCTION IF EXISTS `gruppi_path_find_ancestor`;

--| 070000015221

-- gruppi_path_find_ancestor
-- verifica: 2021-09-10 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `gruppi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT gruppi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				gruppi.id_genitore,
				gruppi.id
			FROM gruppi
			WHERE gruppi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;








































--| 070000001100

-- organizzazioni_path
DROP FUNCTION IF EXISTS `organizzazioni_path`;

--| 070000001101

-- organizzazioni_path
-- verifica: 2021-05-23 15:24 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `organizzazioni_path`( `p1` INT( 11 ) ) RETURNS CHAR( 255 ) CHARSET utf8 COLLATE utf8_general_ci
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
				organizzazioni.id_genitore,
				coalesce(
					anagrafica.soprannome,
					anagrafica.denominazione,
					concat( anagrafica.cognome, ' ', anagrafica.nome ),
					'' ),
				count( organizzazioni.id )
			FROM organizzazioni
			LEFT JOIN anagrafica ON anagrafica.id = organizzazioni.id_anagrafica
			WHERE organizzazioni.id = p1
			INTO p1, step, righe;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000001110

-- organizzazioni_path_check
DROP FUNCTION IF EXISTS `organizzazioni_path_check`;

--| 070000001111

-- organizzazioni_path_check
-- verifica: 2021-05-23 15:24 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `organizzazioni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT organizzazioni_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				organizzazioni.id_genitore
			FROM organizzazioni
			WHERE organizzazioni.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000001120

-- organizzazioni_path_find_ancestor
DROP FUNCTION IF EXISTS `organizzazioni_path_find_ancestor`;

--| 070000001121

-- organizzazioni_path_find_ancestor
-- verifica: 2021-05-23 15:24 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `organizzazioni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT organizzazioni_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				organizzazioni.id_genitore,
				organizzazioni.id
			FROM organizzazioni
			WHERE organizzazioni.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;



























--| FINE FILE
