-- 2026-10-01 — le funzioni dei file di base che nessuna patch datata crea
--
-- COSA SI VEDEVA. Le funzioni *_path, *_path_check e *_path_find_ancestor di _070000999999.procedures.sql nascono
-- solo su un database nuovo: quelle aggiunte al base dopo l'installazione non le ha portate nessuna patch datata. Le
-- viste che le chiamano si fermano con 1305 FUNCTION does not exist ( la prima e' in
-- _202609291900.tabelle.riallineamento.sql, su tipologie_corrispondenza_path ). Il 01/10/2026 ne mancavano da 26 a 37
-- su ognuno dei quattro deploy guardati.
--
-- COSA FA. Per ognuna delle 133 funzioni di _070000999999.procedures.sql che nessuna patch _2026* crea, la CREATE
-- FUNCTION IF NOT EXISTS col corpo del file di base come era il 01/10/2026.
--
-- COSA NON FA, E PERCHE'. Non sostituisce le funzioni che ci sono: se un deploy ne ha una versione diversa, e' una
-- scelta di quel deploy o la portera' la patch che la cambia.
--
-- Il numero e' fra _202609261100.tabelle.base.sql e _202609281000.articoli.nome.doppio.sql.
--
-- IDEMPOTENTE: CREATE FUNCTION IF NOT EXISTS.

-- | 202609261300

-- caratteristiche_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `caratteristiche_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT caratteristiche_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				caratteristiche.id_genitore,
				caratteristiche.nome
			FROM caratteristiche
			WHERE caratteristiche.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609261301

-- caratteristiche_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `caratteristiche_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT caratteristiche_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				caratteristiche.id_genitore
			FROM caratteristiche
			WHERE caratteristiche.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609261302

-- caratteristiche_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `caratteristiche_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT caratteristiche_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				caratteristiche.id_genitore,
				caratteristiche.id
			FROM caratteristiche
			WHERE caratteristiche.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609261303

-- categorie_anagrafica_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_anagrafica_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261304

-- categorie_anagrafica_path_check
-- verifica: 2021-06-01 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_anagrafica_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261305

-- categorie_anagrafica_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_anagrafica_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261306

-- categorie_notizie_path
-- verifica: 2021-06-01 18:34 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_notizie_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261307

-- categorie_notizie_path_check
-- verifica: 2021-06-01 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_notizie_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261308

-- categorie_notizie_path_find_ancestor
-- verifica: 2021-05-23 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_notizie_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261309

-- categorie_prodotti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_prodotti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261310

-- categorie_prodotti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_prodotti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261311

-- categorie_prodotti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_prodotti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261312

-- categorie_progetti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_progetti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261313

-- categorie_progetti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_progetti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261314

-- categorie_progetti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `categorie_progetti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261315

-- gruppi_path
-- verifica: 2021-09-10 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `gruppi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261316

-- gruppi_path_check
-- verifica: 2021-09-10 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `gruppi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261317

-- gruppi_path_find_ancestor
-- verifica: 2021-09-10 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `gruppi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261318

-- luoghi_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `luoghi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261319

-- luoghi_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `luoghi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261320

-- luoghi_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `luoghi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261321

-- mastri_path
-- verifica: 2021-09-28 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `mastri_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261322

-- mastri_path_check
-- verifica: 2021-09-28 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `mastri_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261323

-- mastri_path_find_ancestor
-- verifica: 2021-09-28 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `mastri_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261324

-- organizzazioni_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `organizzazioni_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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
                    organizzazioni.nome,
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

-- | 202609261325

-- organizzazioni_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `organizzazioni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261326

-- organizzazioni_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `organizzazioni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261327

-- pagine_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `pagine_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261328

-- pagine_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `pagine_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261329

-- pagine_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `pagine_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261330

-- ruoli_anagrafica_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_anagrafica_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261331

-- ruoli_anagrafica_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_anagrafica_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261332

-- ruoli_anagrafica_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_anagrafica_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261333

-- ruoli_documenti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_documenti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261334

-- ruoli_documenti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_documenti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261335

-- ruoli_documenti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_documenti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261336

-- ruoli_file_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_file_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261337

-- ruoli_file_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_file_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261338

-- ruoli_file_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_file_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261339

-- ruoli_immagini_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_immagini_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261340

-- ruoli_immagini_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_immagini_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261341

-- ruoli_immagini_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_immagini_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261342

-- ruoli_indirizzi_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_indirizzi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261343

-- ruoli_indirizzi_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_indirizzi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261344

-- ruoli_indirizzi_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_indirizzi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261345

-- ruoli_prodotti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_prodotti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261346

-- ruoli_prodotti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_prodotti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261347

-- ruoli_prodotti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_prodotti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261348

-- ruoli_video_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_video_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261349

-- ruoli_video_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_video_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261350

-- ruoli_video_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_video_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261351

-- settori_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `settori_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261352

-- settori_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `settori_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261353

-- settori_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `settori_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261354

-- tipologie_anagrafica_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_anagrafica_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261355

-- tipologie_anagrafica_path_sigla
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_anagrafica_path_sigla`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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
				tipologie_anagrafica.sigla
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

-- | 202609261356

-- tipologie_anagrafica_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_anagrafica_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261357

-- tipologie_anagrafica_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_anagrafica_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261358

-- tipologie_attivita_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_attivita_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261359

-- tipologie_attivita_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_attivita_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261360

-- tipologie_attivita_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_attivita_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261361

-- tipologie_colli_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_colli_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_colli_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_colli.id_genitore,
				tipologie_colli.nome
			FROM tipologie_colli
			WHERE tipologie_colli.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609261362

-- tipologie_colli_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_colli_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_colli_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_colli.id_genitore
			FROM tipologie_colli
			WHERE tipologie_colli.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609261363

-- tipologie_colli_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_colli_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_colli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_colli.id_genitore,
				tipologie_colli.id
			FROM tipologie_colli
			WHERE tipologie_colli.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609261364

-- tipologie_contatti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_contatti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261365

-- tipologie_contatti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_contatti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261366

-- tipologie_contatti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_contatti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261367

-- tipologie_corrispondenza_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_corrispondenza_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_corrispondenza_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_corrispondenza.id_genitore,
				tipologie_corrispondenza.nome
			FROM tipologie_corrispondenza
			WHERE tipologie_corrispondenza.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609261368

-- tipologie_corrispondenza_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_corrispondenza_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_corrispondenza_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_corrispondenza.id_genitore
			FROM tipologie_corrispondenza
			WHERE tipologie_corrispondenza.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609261369

-- tipologie_corrispondenza_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_corrispondenza_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_corrispondenza_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_corrispondenza.id_genitore,
				tipologie_corrispondenza.id
			FROM tipologie_corrispondenza
			WHERE tipologie_corrispondenza.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609261370

-- tipologie_documenti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_documenti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261371

-- tipologie_documenti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_documenti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261372

-- tipologie_documenti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_documenti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261373

-- tipologie_indirizzi_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_indirizzi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261374

-- tipologie_indirizzi_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_indirizzi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261375

-- tipologie_indirizzi_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_indirizzi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261376

-- tipologie_listini_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_listini_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_listini_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_listini.id_genitore,
				tipologie_listini.nome
			FROM tipologie_listini
			WHERE tipologie_listini.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609261377

-- tipologie_listini_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_listini_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_listini_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_listini.id_genitore
			FROM tipologie_listini
			WHERE tipologie_listini.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609261378

-- tipologie_listini_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_listini_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_listini_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_listini.id_genitore,
				tipologie_listini.id
			FROM tipologie_listini
			WHERE tipologie_listini.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609261379

-- tipologie_notizie_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_notizie_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261380

-- tipologie_notizie_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_notizie_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261381

-- tipologie_notizie_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_notizie_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261382

-- tipologie_prodotti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_prodotti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261383

-- tipologie_prodotti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_prodotti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261384

-- tipologie_prodotti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_prodotti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261385

-- tipologie_progetti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_progetti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261386

-- tipologie_progetti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_progetti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261387

-- tipologie_progetti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_progetti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261388

-- tipologie_pubblicazioni_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_pubblicazioni_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261389

-- tipologie_pubblicazioni_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_pubblicazioni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261390

-- tipologie_pubblicazioni_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_pubblicazioni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261391

-- tipologie_telefoni_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_telefoni_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261392

-- tipologie_telefoni_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_telefoni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261393

-- tipologie_telefoni_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_telefoni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261394

-- tipologie_url_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_url_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261395

-- tipologie_url_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_url_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261396

-- tipologie_url_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_url_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261397

-- tipologie_veicoli_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_veicoli_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_veicoli_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_veicoli.id_genitore,
				tipologie_veicoli.nome
			FROM tipologie_veicoli
			WHERE tipologie_veicoli.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609261398

-- tipologie_veicoli_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_veicoli_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_veicoli_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_veicoli.id_genitore
			FROM tipologie_veicoli
			WHERE tipologie_veicoli.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609261399

-- tipologie_veicoli_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_veicoli_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_veicoli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_veicoli.id_genitore,
				tipologie_veicoli.id
			FROM tipologie_veicoli
			WHERE tipologie_veicoli.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609261400

-- attivita_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `attivita_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT attivita_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				attivita.id_genitore,
				attivita.nome
			FROM attivita
			WHERE attivita.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609261401

-- attivita_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `attivita_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT attivita_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				attivita.id_genitore
			FROM attivita
			WHERE attivita.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609261402

-- attivita_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `attivita_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT attivita_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				attivita.id_genitore,
				attivita.id
			FROM attivita
			WHERE attivita.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609261403

-- listini_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `listini_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT listini_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				listini.id_genitore,
				listini.nome
			FROM listini
			WHERE listini.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609261404

-- listini_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `listini_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT listini_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				listini.id_genitore
			FROM listini
			WHERE listini.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609261405

-- listini_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `listini_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT listini_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				listini.id_genitore,
				listini.id
			FROM listini
			WHERE listini.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609261406

-- ruoli_mail_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_mail_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_mail_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_mail.id_genitore,
				ruoli_mail.nome
			FROM ruoli_mail
			WHERE ruoli_mail.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609261407

-- ruoli_mail_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_mail_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_mail_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_mail.id_genitore
			FROM ruoli_mail
			WHERE ruoli_mail.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609261408

-- ruoli_mail_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `ruoli_mail_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_mail_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_mail.id_genitore,
				ruoli_mail.id
			FROM ruoli_mail
			WHERE ruoli_mail.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609261409

-- asset_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `asset_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT asset_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				asset.id_genitore,
				asset.nome
			FROM asset
			WHERE asset.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609261410

-- asset_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `asset_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT asset_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				asset.id_genitore
			FROM asset
			WHERE asset.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609261411

-- asset_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `asset_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT asset_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				asset.id_genitore,
				asset.id
			FROM asset
			WHERE asset.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609261412

-- caratteristiche_prodotti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `caratteristiche_prodotti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT caratteristiche_prodotti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				caratteristiche_prodotti.id_genitore,
				caratteristiche_prodotti.nome
			FROM caratteristiche_prodotti
			WHERE caratteristiche_prodotti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609261413

-- caratteristiche_prodotti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `caratteristiche_prodotti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT caratteristiche_prodotti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				caratteristiche_prodotti.id_genitore
			FROM caratteristiche_prodotti
			WHERE caratteristiche_prodotti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609261414

-- caratteristiche_prodotti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `caratteristiche_prodotti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT caratteristiche_prodotti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				caratteristiche_prodotti.id_genitore,
				caratteristiche_prodotti.id
			FROM caratteristiche_prodotti
			WHERE caratteristiche_prodotti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609261415

-- colli_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `colli_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT colli_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				colli.id_genitore,
				colli.nome
			FROM colli
			WHERE colli.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609261416

-- colli_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `colli_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT colli_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				colli.id_genitore
			FROM colli
			WHERE colli.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609261417

-- colli_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `colli_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT colli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				colli.id_genitore,
				colli.id
			FROM colli
			WHERE colli.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609261418

-- documenti_articoli_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `documenti_articoli_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT documenti_articoli_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				documenti_articoli.id_genitore,
				documenti_articoli.nome
			FROM documenti_articoli
			WHERE documenti_articoli.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202609261419

-- documenti_articoli_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `documenti_articoli_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT documenti_articoli_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				documenti_articoli.id_genitore
			FROM documenti_articoli
			WHERE documenti_articoli.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202609261420

-- documenti_articoli_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `documenti_articoli_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT documenti_articoli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				documenti_articoli.id_genitore,
				documenti_articoli.id
			FROM documenti_articoli
			WHERE documenti_articoli.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202609261421

-- tipologie_contratti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_contratti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261422

-- tipologie_contratti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_contratti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261423

-- tipologie_contratti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_contratti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261424

-- tipologie_pagamenti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_pagamenti_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261425

-- tipologie_pagamenti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_pagamenti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261426

-- tipologie_pagamenti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_pagamenti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261427

-- tipologie_rinnovi_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_rinnovi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261428

-- tipologie_rinnovi_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_rinnovi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261429

-- tipologie_rinnovi_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_rinnovi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | 202609261430

-- tipologie_todo_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_todo_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
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

-- | 202609261431

-- tipologie_todo_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_todo_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
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

-- | 202609261432

-- tipologie_todo_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION IF NOT EXISTS `tipologie_todo_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
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

-- | FINE FILE
