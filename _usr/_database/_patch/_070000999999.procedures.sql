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

--| 070000000410

-- anagrafica_check_gestita
DROP FUNCTION IF EXISTS `anagrafica_check_gestita`;

--| 070000000411

-- anagrafica_check_gestita
-- verifica: 2021-05-23 15:24 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `anagrafica_check_gestita`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole sapere se è un'azienda gestita

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_anagrafica_path( <id> ) AS path

		DECLARE gestita int( 1 ) DEFAULT NULL;

		SELECT anagrafica_categorie.id
		FROM anagrafica_categorie
		INNER JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
		WHERE anagrafica_categorie.id_anagrafica = p1
		AND categorie_anagrafica.se_gestita = 1
		INTO gestita;

		RETURN gestita;

END;

--| 070000001000

-- todo_view_static
DROP PROCEDURE IF EXISTS `attivita_view_static`;

--| 070000001001

-- todo_view_static
-- verifica: 2021-05-23 15:24 Fabio Mosti
CREATE
    DEFINER = CURRENT_USER()
    PROCEDURE `attivita_view_static`( IN `i` INT(11) )
    BEGIN

--        IF @TRIGGER_LAZY IS NULL THEN

            IF i IS NULL THEN

                DELETE FROM attivita_view_static;
                
                REPLACE INTO attivita_view_static SELECT * FROM attivita_view;

            ELSE
            
                DELETE FROM attivita_view_static WHERE attivita_view_static.id = i;

                INSERT INTO attivita_view_static SELECT * FROM attivita_view WHERE attivita_view.id = i;
            
            END IF;

--        END IF;

    END;

--| 070000003100

-- categorie_anagrafica_path
DROP FUNCTION IF EXISTS `categorie_anagrafica_path`;

--| 070000003101

-- categorie_anagrafica_path
-- verifica: 2021-06-01 18:34 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_anagrafica_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_anagrafica.id_genitore,
				categorie_anagrafica.nome
			FROM categorie_anagrafica
			WHERE categorie_anagrafica.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000003110

-- categorie_anagrafica_path_check
DROP FUNCTION IF EXISTS `categorie_anagrafica_path_check`;

--| 070000003111

-- categorie_anagrafica_path_check
-- verifica: 2021-06-01 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_anagrafica_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT categorie_anagrafica_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_anagrafica.id_genitore
			FROM categorie_anagrafica
			WHERE categorie_anagrafica.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000003120

-- categorie_anagrafica_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_anagrafica_path_find_ancestor`;

--| 070000003121

-- categorie_anagrafica_path_find_ancestor
-- verifica: 2021-05-23 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_anagrafica_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_anagrafica_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_anagrafica.id_genitore,
				categorie_anagrafica.id
			FROM categorie_anagrafica
			WHERE categorie_anagrafica.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000003700

-- categorie_notizie_path
DROP FUNCTION IF EXISTS `categorie_notizie_path`;

--| 070000003701

-- categorie_notizie_path
-- verifica: 2021-06-01 18:34 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_notizie_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_notizie.id_genitore,
				categorie_notizie.nome
			FROM categorie_notizie
			WHERE categorie_notizie.id = p1
			INTO p1, step;

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
	FUNCTION `categorie_prodotti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_prodotti.id_genitore,
				categorie_prodotti.nome
			FROM categorie_prodotti
			WHERE categorie_prodotti.id = p1
			INTO p1, step;

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
	FUNCTION `categorie_progetti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_progetti.id_genitore,
				categorie_progetti.nome
			FROM categorie_progetti
			WHERE categorie_progetti.id = p1
			INTO p1, step;

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
	FUNCTION `categorie_risorse_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_risorse.id_genitore,
				categorie_risorse.nome
			FROM categorie_risorse
			WHERE categorie_risorse.id = p1
			INTO p1, step;

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
	FUNCTION `colori_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				colori.id_genitore,
				colori.nome
			FROM colori
			WHERE colori.id = p1
			INTO p1, step;

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
	FUNCTION `gruppi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				gruppi.id_genitore,
				gruppi.nome
			FROM gruppi
			WHERE gruppi.id = p1
			INTO p1, step;

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

--| 070000018000

-- luoghi_path
DROP FUNCTION IF EXISTS `luoghi_path`;

--| 070000018001

-- luoghi_path
-- verifica: 2021-09-10 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `luoghi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT luoghi_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				luoghi.id_genitore,
				luoghi.nome
			FROM luoghi
			WHERE luoghi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000018010

-- luoghi_path_check
DROP FUNCTION IF EXISTS `luoghi_path_check`;

--| 070000018011

-- luoghi_path_check
-- verifica: 2021-09-10 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `luoghi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT luoghi_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				luoghi.id_genitore
			FROM luoghi
			WHERE luoghi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000018020

-- luoghi_path_find_ancestor
DROP FUNCTION IF EXISTS `luoghi_path_find_ancestor`;

--| 070000018021

-- luoghi_path_find_ancestor
-- verifica: 2021-09-10 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `luoghi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT luoghi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				luoghi.id_genitore,
				luoghi.id
			FROM luoghi
			WHERE luoghi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000020600

-- mastri_path
DROP FUNCTION IF EXISTS `mastri_path`;

--| 070000020601

-- mastri_path
-- verifica: 2021-09-28 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `mastri_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT mastri_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				mastri.id_genitore,
				mastri.nome
			FROM mastri
			WHERE mastri.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000020610

-- mastri_path_check
DROP FUNCTION IF EXISTS `mastri_path_check`;

--| 070000020611

-- mastri_path_check
-- verifica: 2021-09-28 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `mastri_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT mastri_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				mastri.id_genitore
			FROM mastri
			WHERE mastri.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000020620

-- mastri_path_find_ancestor
DROP FUNCTION IF EXISTS `mastri_path_find_ancestor`;

--| 070000020621

-- mastri_path_find_ancestor
-- verifica: 2021-09-28 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `mastri_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT mastri_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				mastri.id_genitore,
				mastri.id
			FROM mastri
			WHERE mastri.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000022800

-- organizzazioni_path
DROP FUNCTION IF EXISTS `organizzazioni_path`;

--| 070000022801

-- organizzazioni_path
-- verifica: 2021-05-23 15:24 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `organizzazioni_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT organizzazioni_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				organizzazioni.id_genitore,
				coalesce(
					anagrafica.soprannome,
					anagrafica.denominazione,
					concat( anagrafica.cognome, ' ', anagrafica.nome ),
					'' )
			FROM organizzazioni
			LEFT JOIN anagrafica ON anagrafica.id = organizzazioni.id_anagrafica
			WHERE organizzazioni.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000022810

-- organizzazioni_path_check
DROP FUNCTION IF EXISTS `organizzazioni_path_check`;

--| 070000022811

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

--| 070000022820

-- organizzazioni_path_find_ancestor
DROP FUNCTION IF EXISTS `organizzazioni_path_find_ancestor`;

--| 070000022821

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

--| 070000023200

-- pagine_path
DROP FUNCTION IF EXISTS `pagine_path`;

--| 070000023201

-- pagine_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pagine_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT pagine_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				pagine.id_genitore,
				pagine.nome
			FROM pagine
			WHERE pagine.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000023210

-- pagine_path_check
DROP FUNCTION IF EXISTS `pagine_path_check`;

--| 070000023211

-- pagine_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pagine_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT pagine_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				pagine.id_genitore
			FROM pagine
			WHERE pagine.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000023220

-- pagine_path_find_ancestor
DROP FUNCTION IF EXISTS `pagine_path_find_ancestor`;

--| 070000023221

-- pagine_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pagine_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT pagine_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				pagine.id_genitore,
				pagine.id
			FROM pagine
			WHERE pagine.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000023800

-- pianificazioni_path
DROP FUNCTION IF EXISTS `pianificazioni_path`;

--| 070000023801

-- pianificazioni_path
-- verifica: 2021-06-01 18:34 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pianificazioni_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT pianificazioni_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				pianificazioni.id_genitore,
				pianificazioni.nome
			FROM pianificazioni
			WHERE pianificazioni.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000023810

-- pianificazioni_path_check
DROP FUNCTION IF EXISTS `pianificazioni_path_check`;

--| 070000023811

-- pianificazioni_path_check
-- verifica: 2021-06-01 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pianificazioni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT pianificazioni_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				pianificazioni.id_genitore
			FROM pianificazioni
			WHERE pianificazioni.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000023820

-- pianificazioni_path_find_ancestor
DROP FUNCTION IF EXISTS `pianificazioni_path_find_ancestor`;

--| 070000023821

-- pianificazioni_path_find_ancestor
-- verifica: 2021-05-23 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pianificazioni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT pianificazioni_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				pianificazioni.id_genitore,
				pianificazioni.id
			FROM pianificazioni
			WHERE pianificazioni.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000034000

-- ruoli_anagrafica_path
DROP FUNCTION IF EXISTS `ruoli_anagrafica_path`;

--| 070000034001

-- ruoli_anagrafica_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_anagrafica_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_anagrafica_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_anagrafica.id_genitore,
				ruoli_anagrafica.nome
			FROM ruoli_anagrafica
			WHERE ruoli_anagrafica.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000034010

-- ruoli_anagrafica_path_check
DROP FUNCTION IF EXISTS `ruoli_anagrafica_path_check`;

--| 070000034011

-- ruoli_anagrafica_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_anagrafica_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_anagrafica_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_anagrafica.id_genitore
			FROM ruoli_anagrafica
			WHERE ruoli_anagrafica.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000034020

-- ruoli_anagrafica_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_anagrafica_path_find_ancestor`;

--| 070000034021

-- ruoli_anagrafica_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_anagrafica_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_anagrafica_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_anagrafica.id_genitore,
				ruoli_anagrafica.id
			FROM ruoli_anagrafica
			WHERE ruoli_anagrafica.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000034100

-- ruoli_articoli_path
DROP FUNCTION IF EXISTS `ruoli_articoli_path`;

--| 070000034101

-- ruoli_articoli_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
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

--| 070000034110

-- ruoli_articoli_path_check
DROP FUNCTION IF EXISTS `ruoli_articoli_path_check`;

--| 070000034111

-- ruoli_articoli_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
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

--| 070000034120

-- ruoli_articoli_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_articoli_path_find_ancestor`;

--| 070000034121

-- ruoli_articoli_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
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

--| 070000034200

-- ruoli_audio_path
DROP FUNCTION IF EXISTS `ruoli_audio_path`;

--| 070000034201

-- ruoli_audio_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_audio_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_audio_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_audio.id_genitore,
				ruoli_audio.nome
			FROM ruoli_audio
			WHERE ruoli_audio.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000034210

-- ruoli_audio_path_check
DROP FUNCTION IF EXISTS `ruoli_audio_path_check`;

--| 070000034211

-- ruoli_audio_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_audio_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_audio_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_audio.id_genitore
			FROM ruoli_audio
			WHERE ruoli_audio.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000034220

-- ruoli_audio_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_audio_path_find_ancestor`;

--| 070000034221

-- ruoli_audio_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_audio_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_audio_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_audio.id_genitore,
				ruoli_audio.id
			FROM ruoli_audio
			WHERE ruoli_audio.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000034300

-- ruoli_documenti_path
DROP FUNCTION IF EXISTS `ruoli_documenti_path`;

--| 070000034301

-- ruoli_documenti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_documenti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_documenti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_documenti.id_genitore,
				ruoli_documenti.nome
			FROM ruoli_documenti
			WHERE ruoli_documenti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000034310

-- ruoli_documenti_path_check
DROP FUNCTION IF EXISTS `ruoli_documenti_path_check`;

--| 070000034311

-- ruoli_documenti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_documenti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_documenti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_documenti.id_genitore
			FROM ruoli_documenti
			WHERE ruoli_documenti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000034320

-- ruoli_documenti_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_documenti_path_find_ancestor`;

--| 070000034321

-- ruoli_documenti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_documenti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_documenti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_documenti.id_genitore,
				ruoli_documenti.id
			FROM ruoli_documenti
			WHERE ruoli_documenti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000034400

-- ruoli_file_path
DROP FUNCTION IF EXISTS `ruoli_file_path`;

--| 070000034401

-- ruoli_file_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_file_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_file_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_file.id_genitore,
				ruoli_file.nome
			FROM ruoli_file
			WHERE ruoli_file.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000034410

-- ruoli_file_path_check
DROP FUNCTION IF EXISTS `ruoli_file_path_check`;

--| 070000034411

-- ruoli_file_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_file_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_file_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_file.id_genitore
			FROM ruoli_file
			WHERE ruoli_file.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000034420

-- ruoli_file_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_file_path_find_ancestor`;

--| 070000034421

-- ruoli_file_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_file_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_file_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_file.id_genitore,
				ruoli_file.id
			FROM ruoli_file
			WHERE ruoli_file.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000034600

-- ruoli_immagini_path
DROP FUNCTION IF EXISTS `ruoli_immagini_path`;

--| 070000034601

-- ruoli_immagini_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_immagini_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_immagini_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_immagini.id_genitore,
				ruoli_immagini.nome
			FROM ruoli_immagini
			WHERE ruoli_immagini.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000034610

-- ruoli_immagini_path_check
DROP FUNCTION IF EXISTS `ruoli_immagini_path_check`;

--| 070000034611

-- ruoli_immagini_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_immagini_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_immagini_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_immagini.id_genitore
			FROM ruoli_immagini
			WHERE ruoli_immagini.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000034620

-- ruoli_immagini_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_immagini_path_find_ancestor`;

--| 070000034621

-- ruoli_immagini_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_immagini_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_immagini_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_immagini.id_genitore,
				ruoli_immagini.id
			FROM ruoli_immagini
			WHERE ruoli_immagini.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000034800

-- ruoli_indirizzi_path
DROP FUNCTION IF EXISTS `ruoli_indirizzi_path`;

--| 070000034801

-- ruoli_indirizzi_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_indirizzi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_indirizzi_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_indirizzi.id_genitore,
				ruoli_indirizzi.nome
			FROM ruoli_indirizzi
			WHERE ruoli_indirizzi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000034810

-- ruoli_indirizzi_path_check
DROP FUNCTION IF EXISTS `ruoli_indirizzi_path_check`;

--| 070000034811

-- ruoli_indirizzi_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_indirizzi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_indirizzi_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_indirizzi.id_genitore
			FROM ruoli_indirizzi
			WHERE ruoli_indirizzi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000034820

-- ruoli_indirizzi_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_indirizzi_path_find_ancestor`;

--| 070000034821

-- ruoli_indirizzi_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_indirizzi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_indirizzi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_indirizzi.id_genitore,
				ruoli_indirizzi.id
			FROM ruoli_indirizzi
			WHERE ruoli_indirizzi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000034900

-- ruoli_matricole_path
DROP FUNCTION IF EXISTS `ruoli_matricole_path`;

--| 070000034901

-- ruoli_matricole_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
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

--| 070000034910

-- ruoli_matricole_path_check
DROP FUNCTION IF EXISTS `ruoli_matricole_path_check`;

--| 070000034911

-- ruoli_matricole_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
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

--| 070000034920

-- ruoli_matricole_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_matricole_path_find_ancestor`;

--| 070000034921

-- ruoli_matricole_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
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

--| 070000035000

-- ruoli_prodotti_path
DROP FUNCTION IF EXISTS `ruoli_prodotti_path`;

--| 070000035001

-- ruoli_prodotti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_prodotti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_prodotti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_prodotti.id_genitore,
				ruoli_prodotti.nome
			FROM ruoli_prodotti
			WHERE ruoli_prodotti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000035010

-- ruoli_prodotti_path_check
DROP FUNCTION IF EXISTS `ruoli_prodotti_path_check`;

--| 070000035011

-- ruoli_prodotti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_prodotti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_prodotti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_prodotti.id_genitore
			FROM ruoli_prodotti
			WHERE ruoli_prodotti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000035020

-- ruoli_prodotti_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_prodotti_path_find_ancestor`;

--| 070000035021

-- ruoli_prodotti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_prodotti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_prodotti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_prodotti.id_genitore,
				ruoli_prodotti.id
			FROM ruoli_prodotti
			WHERE ruoli_prodotti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000035200

-- ruoli_video_path
DROP FUNCTION IF EXISTS `ruoli_video_path`;

--| 070000035201

-- ruoli_video_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_video_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_video_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_video.id_genitore,
				ruoli_video.nome
			FROM ruoli_video
			WHERE ruoli_video.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000035210

-- ruoli_video_path_check
DROP FUNCTION IF EXISTS `ruoli_video_path_check`;

--| 070000035211

-- ruoli_video_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_video_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_video_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_video.id_genitore
			FROM ruoli_video
			WHERE ruoli_video.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000035220

-- ruoli_video_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_video_path_find_ancestor`;

--| 070000035221

-- ruoli_video_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_video_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_video_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_video.id_genitore,
				ruoli_video.id
			FROM ruoli_video
			WHERE ruoli_video.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000037000

-- settori_path
DROP FUNCTION IF EXISTS `settori_path`;

--| 070000037001

-- settori_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `settori_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT settori_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				settori.id_genitore,
				concat( settori.ateco, ' ', settori.nome )
			FROM settori
			WHERE settori.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000037010

-- settori_path_check
DROP FUNCTION IF EXISTS `settori_path_check`;

--| 070000037011

-- settori_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `settori_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT settori_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				settori.id_genitore
			FROM settori
			WHERE settori.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000037020

-- settori_path_find_ancestor
DROP FUNCTION IF EXISTS `settori_path_find_ancestor`;

--| 070000037021

-- settori_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `settori_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT settori_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				settori.id_genitore,
				settori.id
			FROM settori
			WHERE settori.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000041400

-- software_path
DROP FUNCTION IF EXISTS `software_path`;

--| 070000041401

-- software_path
-- verifica: 2021-11-16 10:39 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `software_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT software_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				software.id_genitore,
				software.nome
			FROM software
			WHERE software.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000041410

-- software_path_check
DROP FUNCTION IF EXISTS `software_path_check`;

--| 070000041411

-- software_path_check
-- verifica: 2021-11-16 10:39 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `software_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT software_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				software.id_genitore
			FROM software
			WHERE software.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000041420

-- software_path_find_ancestor
DROP FUNCTION IF EXISTS `software_path_find_ancestor`;

--| 070000041421

-- software_path_find_ancestor
-- verifica: 2021-11-16 10:39 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `software_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT software_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				software.id_genitore,
				software.id
			FROM software
			WHERE software.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000050000

-- tipologie_anagrafica_path
DROP FUNCTION IF EXISTS `tipologie_anagrafica_path`;

--| 070000050001

-- tipologie_anagrafica_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_anagrafica_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_anagrafica_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_anagrafica.id_genitore,
				tipologie_anagrafica.nome
			FROM tipologie_anagrafica
			WHERE tipologie_anagrafica.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000050010

-- tipologie_anagrafica_path_check
DROP FUNCTION IF EXISTS `tipologie_anagrafica_path_check`;

--| 070000050011

-- tipologie_anagrafica_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_anagrafica_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_anagrafica_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_anagrafica.id_genitore
			FROM tipologie_anagrafica
			WHERE tipologie_anagrafica.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000050020

-- tipologie_anagrafica_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_anagrafica_path_find_ancestor`;

--| 070000050021

-- tipologie_anagrafica_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_anagrafica_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_anagrafica_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_anagrafica.id_genitore,
				tipologie_anagrafica.id
			FROM tipologie_anagrafica
			WHERE tipologie_anagrafica.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000050400

-- tipologie_attivita_path
DROP FUNCTION IF EXISTS `tipologie_attivita_path`;

--| 070000050401

-- tipologie_attivita_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_attivita_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_attivita_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_attivita.id_genitore,
				tipologie_attivita.nome
			FROM tipologie_attivita
			WHERE tipologie_attivita.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000050410

-- tipologie_attivita_path_check
DROP FUNCTION IF EXISTS `tipologie_attivita_path_check`;

--| 070000050411

-- tipologie_attivita_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_attivita_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_attivita_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_attivita.id_genitore
			FROM tipologie_attivita
			WHERE tipologie_attivita.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000050420

-- tipologie_attivita_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_attivita_path_find_ancestor`;

--| 070000050421

-- tipologie_attivita_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_attivita_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_attivita_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_attivita.id_genitore,
				tipologie_attivita.id
			FROM tipologie_attivita
			WHERE tipologie_attivita.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000050500

-- tipologie_banner_path
DROP FUNCTION IF EXISTS `tipologie_banner_path`;

--| 070000050501

-- tipologie_banner_path
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_banner_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_banner_path( <id> ) AS path

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

--| 070000050510

-- tipologie_banner_path_check
DROP FUNCTION IF EXISTS `tipologie_banner_path_check`;

--| 070000050511

-- tipologie_banner_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_banner_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_banner_path_check( <id1>, <id2> ) AS check

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

--| 070000050520

-- tipologie_banner_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_banner_path_find_ancestor`;

--| 070000050521

-- tipologie_banner_path_find_ancestor
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_banner_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_banner_path_find_ancestor( <id1> ) AS check

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

--| 070000050600

-- tipologie_chiavi_path
DROP FUNCTION IF EXISTS `tipologie_chiavi_path`;

--| 070000050601

-- tipologie_chiavi_path
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_chiavi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_chiavi_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_chiavi.id_genitore,
				tipologie_chiavi.nome
			FROM tipologie_chiavi
			WHERE tipologie_chiavi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000050610

-- tipologie_chiavi_path_check
DROP FUNCTION IF EXISTS `tipologie_chiavi_path_check`;

--| 070000050611

-- tipologie_chiavi_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_chiavi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_chiavi_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_chiavi.id_genitore
			FROM tipologie_chiavi
			WHERE tipologie_chiavi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000050620

-- tipologie_chiavi_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_chiavi_path_find_ancestor`;

--| 070000050621

-- tipologie_chiavi_path_find_ancestor
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_chiavi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_chiavi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_chiavi.id_genitore,
				tipologie_chiavi.id
			FROM tipologie_chiavi
			WHERE tipologie_chiavi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000050800

-- tipologie_contatti_path
DROP FUNCTION IF EXISTS `tipologie_contatti_path`;

--| 070000050801

-- tipologie_contatti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_contatti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_contatti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_contatti.id_genitore,
				tipologie_contatti.nome
			FROM tipologie_contatti
			WHERE tipologie_contatti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000050810

-- tipologie_contatti_path_check
DROP FUNCTION IF EXISTS `tipologie_contatti_path_check`;

--| 070000050811

-- tipologie_contatti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_contatti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_contatti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_contatti.id_genitore
			FROM tipologie_contatti
			WHERE tipologie_contatti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000050820

-- tipologie_contatti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_contatti_path_find_ancestor`;

--| 070000050821

-- tipologie_contatti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_contatti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_contatti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_contatti.id_genitore,
				tipologie_contatti.id
			FROM tipologie_contatti
			WHERE tipologie_contatti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000050900

-- tipologie_contratti_path
DROP FUNCTION IF EXISTS `tipologie_contratti_path`;

--| 070000050901

-- tipologie_contratti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_contratti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_contratti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_contratti.id_genitore,
				tipologie_contratti.nome
			FROM tipologie_contratti
			WHERE tipologie_contratti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000050910

-- tipologie_contratti_path_check
DROP FUNCTION IF EXISTS `tipologie_contratti_path_check`;

--| 070000050911

-- tipologie_contratti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_contratti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_contratti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_contratti.id_genitore
			FROM tipologie_contratti
			WHERE tipologie_contratti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000050920

-- tipologie_contratti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_contratti_path_find_ancestor`;

--| 070000050921

-- tipologie_contratti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_contratti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_contratti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_contratti.id_genitore,
				tipologie_contratti.id
			FROM tipologie_contratti
			WHERE tipologie_contratti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000052600

-- tipologie_documenti_path
DROP FUNCTION IF EXISTS `tipologie_documenti_path`;

--| 070000052601

-- tipologie_documenti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_documenti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_documenti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_documenti.id_genitore,
				tipologie_documenti.nome
			FROM tipologie_documenti
			WHERE tipologie_documenti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000052610

-- tipologie_documenti_path_check
DROP FUNCTION IF EXISTS `tipologie_documenti_path_check`;

--| 070000052611

-- tipologie_documenti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_documenti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_documenti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_documenti.id_genitore
			FROM tipologie_documenti
			WHERE tipologie_documenti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000052620

-- tipologie_documenti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_documenti_path_find_ancestor`;

--| 070000052621

-- tipologie_documenti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_documenti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_documenti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_documenti.id_genitore,
				tipologie_documenti.id
			FROM tipologie_documenti
			WHERE tipologie_documenti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;


--| 070000052800

-- tipologie_edifici_path
DROP FUNCTION IF EXISTS `tipologie_edifici_path`;

--| 070000052801

-- tipologie_edifici_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
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

--| 070000052810

-- tipologie_edifici_path_check
DROP FUNCTION IF EXISTS `tipologie_edifici_path_check`;

--| 070000052811

-- tipologie_edifici_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
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

--| 070000052820

-- tipologie_edifici_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_edifici_path_find_ancestor`;

--| 070000052821

-- tipologie_edifici_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
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

--| 070000052900

-- tipologie_immobili_path
DROP FUNCTION IF EXISTS `tipologie_immobili_path`;

--| 070000052901

-- tipologie_immobili_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
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

--| 070000052910

-- tipologie_immobili_path_check
DROP FUNCTION IF EXISTS `tipologie_immobili_path_check`;

--| 070000052911

-- tipologie_immobili_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
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

--| 070000052920

-- tipologie_immobili_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_immobili_path_find_ancestor`;

--| 070000052921

-- tipologie_immobili_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
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

--| 070000053000

-- tipologie_indirizzi_path
DROP FUNCTION IF EXISTS `tipologie_indirizzi_path`;

--| 070000053001

-- tipologie_indirizzi_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_indirizzi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_indirizzi_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_indirizzi.id_genitore,
				tipologie_indirizzi.nome
			FROM tipologie_indirizzi
			WHERE tipologie_indirizzi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000053010

-- tipologie_indirizzi_path_check
DROP FUNCTION IF EXISTS `tipologie_indirizzi_path_check`;

--| 070000053011

-- tipologie_indirizzi_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_indirizzi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_indirizzi_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_indirizzi.id_genitore
			FROM tipologie_indirizzi
			WHERE tipologie_indirizzi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000053020

-- tipologie_indirizzi_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_indirizzi_path_find_ancestor`;

--| 070000053021

-- tipologie_indirizzi_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_indirizzi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_indirizzi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_indirizzi.id_genitore,
				tipologie_indirizzi.id
			FROM tipologie_indirizzi
			WHERE tipologie_indirizzi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000053200

-- tipologie_licenze_path
DROP FUNCTION IF EXISTS `tipologie_licenze_path`;

--| 070000053201

-- tipologie_licenze_path
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_licenze_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_licenze_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_licenze.id_genitore,
				tipologie_licenze.nome
			FROM tipologie_licenze
			WHERE tipologie_licenze.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000053210

-- tipologie_licenze_path_check
DROP FUNCTION IF EXISTS `tipologie_licenze_path_check`;

--| 070000053211

-- tipologie_licenze_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_licenze_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_licenze_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_licenze.id_genitore
			FROM tipologie_licenze
			WHERE tipologie_licenze.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000053220

-- tipologie_licenze_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_licenze_path_find_ancestor`;

--| 070000053221

-- tipologie_licenze_path_find_ancestor
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_licenze_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_licenze_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_licenze.id_genitore,
				tipologie_licenze.id
			FROM tipologie_licenze
			WHERE tipologie_licenze.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000053300

-- tipologie_luoghi_path
DROP FUNCTION IF EXISTS `tipologie_luoghi_path`;

--| 070000053301

-- tipologie_luoghi_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_luoghi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_luoghi_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_luoghi.id_genitore,
				tipologie_luoghi.nome
			FROM tipologie_luoghi
			WHERE tipologie_luoghi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000053310

-- tipologie_luoghi_path_check
DROP FUNCTION IF EXISTS `tipologie_luoghi_path_check`;

--| 070000053311

-- tipologie_luoghi_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_luoghi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_luoghi_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_luoghi.id_genitore
			FROM tipologie_luoghi
			WHERE tipologie_luoghi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000053320

-- tipologie_luoghi_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_luoghi_path_find_ancestor`;

--| 070000053321

-- tipologie_luoghi_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_luoghi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_luoghi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_luoghi.id_genitore,
				tipologie_luoghi.id
			FROM tipologie_luoghi
			WHERE tipologie_luoghi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000053400

-- tipologie_mastri_path
DROP FUNCTION IF EXISTS `tipologie_mastri_path`;

--| 070000053401

-- tipologie_mastri_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_mastri_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_mastri_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_mastri.id_genitore,
				tipologie_mastri.nome
			FROM tipologie_mastri
			WHERE tipologie_mastri.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000053410

-- tipologie_mastri_path_check
DROP FUNCTION IF EXISTS `tipologie_mastri_path_check`;

--| 070000053411

-- tipologie_mastri_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_mastri_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_mastri_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_mastri.id_genitore
			FROM tipologie_mastri
			WHERE tipologie_mastri.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000053420

-- tipologie_mastri_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_mastri_path_find_ancestor`;

--| 070000053421

-- tipologie_mastri_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_mastri_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_mastri_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_mastri.id_genitore,
				tipologie_mastri.id
			FROM tipologie_mastri
			WHERE tipologie_mastri.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000053800

-- tipologie_notizie_path
DROP FUNCTION IF EXISTS `tipologie_notizie_path`;

--| 070000053801

-- tipologie_notizie_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_notizie_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_notizie_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_notizie.id_genitore,
				tipologie_notizie.nome
			FROM tipologie_notizie
			WHERE tipologie_notizie.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000053810

-- tipologie_notizie_path_check
DROP FUNCTION IF EXISTS `tipologie_notizie_path_check`;

--| 070000053811

-- tipologie_notizie_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_notizie_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_notizie_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_notizie.id_genitore
			FROM tipologie_notizie
			WHERE tipologie_notizie.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000053820

-- tipologie_notizie_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_notizie_path_find_ancestor`;

--| 070000053821

-- tipologie_notizie_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_notizie_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_notizie_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_notizie.id_genitore,
				tipologie_notizie.id
			FROM tipologie_notizie
			WHERE tipologie_notizie.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000054000

-- tipologie_pagamenti_path
DROP FUNCTION IF EXISTS `tipologie_pagamenti_path`;

--| 070000054001

-- tipologie_pagamenti_path
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_pagamenti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_pagamenti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_pagamenti.id_genitore,
				tipologie_pagamenti.nome
			FROM tipologie_pagamenti
			WHERE tipologie_pagamenti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000054010

-- tipologie_pagamenti_path_check
DROP FUNCTION IF EXISTS `tipologie_pagamenti_path_check`;

--| 070000054011

-- tipologie_pagamenti_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_pagamenti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_pagamenti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_pagamenti.id_genitore
			FROM tipologie_pagamenti
			WHERE tipologie_pagamenti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000054020

-- tipologie_pagamenti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_pagamenti_path_find_ancestor`;

--| 070000054021

-- tipologie_pagamenti_path_find_ancestor
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_pagamenti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_pagamenti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_pagamenti.id_genitore,
				tipologie_pagamenti.id
			FROM tipologie_pagamenti
			WHERE tipologie_pagamenti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000054100

-- tipologie_periodi_path
DROP FUNCTION IF EXISTS `tipologie_periodi_path`;

--| 070000054101

-- tipologie_periodi_path
-- verifica: 2021-11-15 11:29 Chiara GDL
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

--| 070000054110

-- tipologie_periodi_path_check
DROP FUNCTION IF EXISTS `tipologie_periodi_path_check`;

--| 070000054111

-- tipologie_periodi_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
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

--| 070000054120

-- tipologie_periodi_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_periodi_path_find_ancestor`;

--| 070000054121

-- tipologie_periodi_path_find_ancestor
-- verifica: 2021-11-15 11:29 Chiara GDL
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

--| 070000054200

-- tipologie_popup_path
DROP FUNCTION IF EXISTS `tipologie_popup_path`;

--| 070000054201

-- tipologie_popup_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_popup_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_popup_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_popup.id_genitore,
				tipologie_popup.nome
			FROM tipologie_popup
			WHERE tipologie_popup.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000054210

-- tipologie_popup_path_check
DROP FUNCTION IF EXISTS `tipologie_popup_path_check`;

--| 070000054211

-- tipologie_popup_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_popup_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_popup_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_popup.id_genitore
			FROM tipologie_popup
			WHERE tipologie_popup.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000054220

-- tipologie_popup_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_popup_path_find_ancestor`;

--| 070000054221

-- tipologie_popup_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_popup_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_popup_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_popup.id_genitore,
				tipologie_popup.id
			FROM tipologie_popup
			WHERE tipologie_popup.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000054600

-- tipologie_prodotti_path
DROP FUNCTION IF EXISTS `tipologie_prodotti_path`;

--| 070000054601

-- tipologie_prodotti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_prodotti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_prodotti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_prodotti.id_genitore,
				tipologie_prodotti.nome
			FROM tipologie_prodotti
			WHERE tipologie_prodotti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000054610

-- tipologie_prodotti_path_check
DROP FUNCTION IF EXISTS `tipologie_prodotti_path_check`;

--| 070000054611

-- tipologie_prodotti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_prodotti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_prodotti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_prodotti.id_genitore
			FROM tipologie_prodotti
			WHERE tipologie_prodotti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000054620

-- tipologie_prodotti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_prodotti_path_find_ancestor`;

--| 070000054621

-- tipologie_prodotti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_prodotti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_prodotti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_prodotti.id_genitore,
				tipologie_prodotti.id
			FROM tipologie_prodotti
			WHERE tipologie_prodotti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000055000

-- tipologie_progetti_path
DROP FUNCTION IF EXISTS `tipologie_progetti_path`;

--| 070000055001

-- tipologie_progetti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_progetti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_progetti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_progetti.id_genitore,
				tipologie_progetti.nome
			FROM tipologie_progetti
			WHERE tipologie_progetti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000055010

-- tipologie_progetti_path_check
DROP FUNCTION IF EXISTS `tipologie_progetti_path_check`;

--| 070000055011

-- tipologie_progetti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_progetti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_progetti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_progetti.id_genitore
			FROM tipologie_progetti
			WHERE tipologie_progetti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000055020

-- tipologie_progetti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_progetti_path_find_ancestor`;

--| 070000055021

-- tipologie_progetti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_progetti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_progetti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_progetti.id_genitore,
				tipologie_progetti.id
			FROM tipologie_progetti
			WHERE tipologie_progetti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000055400

-- tipologie_pubblicazioni_path
DROP FUNCTION IF EXISTS `tipologie_pubblicazioni_path`;

--| 070000055401

-- tipologie_pubblicazioni_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_pubblicazioni_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_pubblicazioni_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_pubblicazioni.id_genitore,
				tipologie_pubblicazioni.nome
			FROM tipologie_pubblicazioni
			WHERE tipologie_pubblicazioni.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000055410

-- tipologie_pubblicazioni_path_check
DROP FUNCTION IF EXISTS `tipologie_pubblicazioni_path_check`;

--| 070000055411

-- tipologie_pubblicazioni_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_pubblicazioni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_pubblicazioni_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_pubblicazioni.id_genitore
			FROM tipologie_pubblicazioni
			WHERE tipologie_pubblicazioni.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000055420

-- tipologie_pubblicazioni_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_pubblicazioni_path_find_ancestor`;

--| 070000055421

-- tipologie_pubblicazioni_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_pubblicazioni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_pubblicazioni_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_pubblicazioni.id_genitore,
				tipologie_pubblicazioni.id
			FROM tipologie_pubblicazioni
			WHERE tipologie_pubblicazioni.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000055700

-- tipologie_rinnovi_path
DROP FUNCTION IF EXISTS `tipologie_rinnovi_path`;

--| 070000055701

-- tipologie_rinnovi_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_rinnovi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_rinnovi_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_rinnovi.id_genitore,
				tipologie_rinnovi.nome
			FROM tipologie_rinnovi
			WHERE tipologie_rinnovi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000055710

-- tipologie_rinnovi_path_check
DROP FUNCTION IF EXISTS `tipologie_rinnovi_path_check`;

--| 070000055711

-- tipologie_rinnovi_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_rinnovi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_rinnovi_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_rinnovi.id_genitore
			FROM tipologie_rinnovi
			WHERE tipologie_rinnovi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000055720

-- tipologie_rinnovi_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_rinnovi_path_find_ancestor`;

--| 070000055721

-- tipologie_rinnovi_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_rinnovi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_rinnovi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_rinnovi.id_genitore,
				tipologie_rinnovi.id
			FROM tipologie_rinnovi
			WHERE tipologie_rinnovi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000055800

-- tipologie_risorse_path
DROP FUNCTION IF EXISTS `tipologie_risorse_path`;

--| 070000055801

-- tipologie_risorse_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_risorse_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_risorse_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_risorse.id_genitore,
				tipologie_risorse.nome
			FROM tipologie_risorse
			WHERE tipologie_risorse.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000055810

-- tipologie_risorse_path_check
DROP FUNCTION IF EXISTS `tipologie_risorse_path_check`;

--| 070000055811

-- tipologie_risorse_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_risorse_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_risorse_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_risorse.id_genitore
			FROM tipologie_risorse
			WHERE tipologie_risorse.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000055820

-- tipologie_risorse_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_risorse_path_find_ancestor`;

--| 070000055821

-- tipologie_risorse_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_risorse_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_risorse_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_risorse.id_genitore,
				tipologie_risorse.id
			FROM tipologie_risorse
			WHERE tipologie_risorse.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000056200

-- tipologie_telefoni_path
DROP FUNCTION IF EXISTS `tipologie_telefoni_path`;

--| 070000056201

-- tipologie_telefoni_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_telefoni_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_telefoni_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_telefoni.id_genitore,
				tipologie_telefoni.nome
			FROM tipologie_telefoni
			WHERE tipologie_telefoni.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000056210

-- tipologie_telefoni_path_check
DROP FUNCTION IF EXISTS `tipologie_telefoni_path_check`;

--| 070000056211

-- tipologie_telefoni_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_telefoni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_telefoni_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_telefoni.id_genitore
			FROM tipologie_telefoni
			WHERE tipologie_telefoni.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000056220

-- tipologie_telefoni_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_telefoni_path_find_ancestor`;

--| 070000056221

-- tipologie_telefoni_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_telefoni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_telefoni_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_telefoni.id_genitore,
				tipologie_telefoni.id
			FROM tipologie_telefoni
			WHERE tipologie_telefoni.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000056600

-- tipologie_todo_path
DROP FUNCTION IF EXISTS `tipologie_todo_path`;

--| 070000056601

-- tipologie_todo_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_todo_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_todo_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_todo.id_genitore,
				tipologie_todo.nome
			FROM tipologie_todo
			WHERE tipologie_todo.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000056610

-- tipologie_todo_path_check
DROP FUNCTION IF EXISTS `tipologie_todo_path_check`;

--| 070000056611

-- tipologie_todo_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_todo_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_todo_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_todo.id_genitore
			FROM tipologie_todo
			WHERE tipologie_todo.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000056620

-- tipologie_todo_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_todo_path_find_ancestor`;

--| 070000056621

-- tipologie_todo_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_todo_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_todo_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_todo.id_genitore,
				tipologie_todo.id
			FROM tipologie_todo
			WHERE tipologie_todo.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000056800

-- tipologie_url_path
DROP FUNCTION IF EXISTS `tipologie_url_path`;

--| 070000056801

-- tipologie_url_path
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_url_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_url_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_url.id_genitore,
				tipologie_url.nome
			FROM tipologie_url
			WHERE tipologie_url.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000056810

-- tipologie_url_path_check
DROP FUNCTION IF EXISTS `tipologie_url_path_check`;

--| 070000056811

-- tipologie_url_path_check
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_url_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_url_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_url.id_genitore
			FROM tipologie_url
			WHERE tipologie_url.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000056820

-- tipologie_url_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_url_path_find_ancestor`;

--| 070000056821

-- tipologie_url_path_find_ancestor
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_url_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_url_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_url.id_genitore,
				tipologie_url.id
			FROM tipologie_url
			WHERE tipologie_url.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000056900

-- tipologie_zone_path
DROP FUNCTION IF EXISTS `tipologie_zone_path`;

--| 070000056901

-- tipologie_zone_path
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_zone_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_zone_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_zone.id_genitore,
				tipologie_zone.nome
			FROM tipologie_zone
			WHERE tipologie_zone.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000056910

-- tipologie_zone_path_check
DROP FUNCTION IF EXISTS `tipologie_zone_path_check`;

--| 070000056911

-- tipologie_zone_path_check
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_zone_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_zone_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_zone.id_genitore
			FROM tipologie_zone
			WHERE tipologie_zone.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000056920

-- tipologie_zone_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_zone_path_find_ancestor`;

--| 070000056921

-- tipologie_zone_path_find_ancestor
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_zone_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_zone_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_zone.id_genitore,
				tipologie_zone.id
			FROM tipologie_zone
			WHERE tipologie_zone.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| 070000060000

-- todo_view_static
DROP PROCEDURE IF EXISTS `todo_view_static`;

--| 070000060001

-- todo_view_static
-- verifica: 2021-05-23 15:24 Fabio Mosti
CREATE
    DEFINER = CURRENT_USER()
    PROCEDURE `todo_view_static`( IN `i` INT(11) )
    BEGIN

--        IF @TRIGGER_LAZY IS NULL THEN

            IF i IS NULL THEN

                DELETE FROM todo_view_static;
                
                REPLACE INTO todo_view_static SELECT * FROM todo_view;

            ELSE
            
                DELETE FROM todo_view_static WHERE todo_view_static.id = i;

                INSERT INTO todo_view_static SELECT * FROM todo_view WHERE todo_view.id = i;
            
            END IF;

--        END IF;

    END;



--| 070000100000

-- zone_path
DROP FUNCTION IF EXISTS `zone_path`;

--| 070000100001

-- zone_path
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `zone_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT zone_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				zone.id_genitore,
				zone.nome
			FROM zone
			WHERE zone.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

--| 070000100010

-- zone_path_check
DROP FUNCTION IF EXISTS `zone_path_check`;

--| 070000100011

-- zone_path_check
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `zone_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT zone_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				zone.id_genitore
			FROM zone
			WHERE zone.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

--| 070000100020

-- zone_path_find_ancestor
DROP FUNCTION IF EXISTS `zone_path_find_ancestor`;

--| 070000100021

-- zone_path_find_ancestor
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `zone_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT zone_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				zone.id_genitore,
				zone.id
			FROM zone
			WHERE zone.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

--| FINE FILE
