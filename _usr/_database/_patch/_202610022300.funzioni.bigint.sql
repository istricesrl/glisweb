-- 2026-10-02 — le funzioni del framework con id bigint( 20 )
--
-- COSA SI VEDEVA. Tutte le 205 funzioni di _070000999999.procedures.sql ( *_path, *_path_check,
-- *_path_find_ancestor ) prendevano e restituivano gli id come INT( 11 ), mentre il canone vuole bigint( 20 ) per
-- id e id_* ( 300.database.md ) e _202610021500.tipi.canonici.sql porta lì le colonne. Con un id oltre 2147483647 la
-- funzione si ferma con un errore o, senza STRICT, lo tronca e calcola il path sulla riga sbagliata.
--
-- COSA FA. Per ognuna delle 205 funzioni, DROP FUNCTION IF EXISTS e CREATE col corpo del file di base del
-- 02/10/2026, che differisce dal precedente solo per INT( 11 ) -> BIGINT( 20 ) e per
-- tipologie_chiavi_path_find_ancestor, che il file di base cancellava senza mai ricrearla. Le funzioni di un deploy che ne
-- avesse una versione sua vengono sostituite da quella canonica: è voluto, lo schema è uno solo per tutti.
--
-- Il numero dei blocchi va da 202610022300 a 202610022709: sono 410 e non ci stanno in un'ora, ma restano sotto
-- 202610030000, quindi una patch datata da domani in poi viene comunque dopo.
--
-- IDEMPOTENTE: DROP IF EXISTS + CREATE.

-- | 202610022300

-- caratteristiche_path
DROP FUNCTION IF EXISTS `caratteristiche_path`;

-- | 202610022301

-- caratteristiche_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `caratteristiche_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022302

-- caratteristiche_path_check
DROP FUNCTION IF EXISTS `caratteristiche_path_check`;

-- | 202610022303

-- caratteristiche_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `caratteristiche_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022304

-- caratteristiche_path_find_ancestor
DROP FUNCTION IF EXISTS `caratteristiche_path_find_ancestor`;

-- | 202610022305

-- caratteristiche_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `caratteristiche_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT caratteristiche_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022306

-- categorie_anagrafica_path
DROP FUNCTION IF EXISTS `categorie_anagrafica_path`;

-- | 202610022307

-- categorie_anagrafica_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_anagrafica_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022308

-- categorie_anagrafica_path_check
DROP FUNCTION IF EXISTS `categorie_anagrafica_path_check`;

-- | 202610022309

-- categorie_anagrafica_path_check
-- verifica: 2021-06-01 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_anagrafica_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022310

-- categorie_anagrafica_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_anagrafica_path_find_ancestor`;

-- | 202610022311

-- categorie_anagrafica_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_anagrafica_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_anagrafica_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022312

-- categorie_annunci_path
DROP FUNCTION IF EXISTS `categorie_annunci_path`;

-- | 202610022313

-- categorie_annunci_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_annunci_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_annunci_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_annunci.id_genitore,
				categorie_annunci.nome
			FROM categorie_annunci
			WHERE categorie_annunci.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202610022314

-- categorie_annunci_path_check
DROP FUNCTION IF EXISTS `categorie_annunci_path_check`;

-- | 202610022315

-- categorie_annunci_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_annunci_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_annunci_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_annunci.id_genitore
			FROM categorie_annunci
			WHERE categorie_annunci.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202610022316

-- categorie_annunci_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_annunci_path_find_ancestor`;

-- | 202610022317

-- categorie_annunci_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_annunci_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_annunci_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_annunci.id_genitore,
				categorie_annunci.id
			FROM categorie_annunci
			WHERE categorie_annunci.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202610022318

-- categorie_notizie_path
DROP FUNCTION IF EXISTS `categorie_notizie_path`;

-- | 202610022319

-- categorie_notizie_path
-- verifica: 2021-06-01 18:34 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_notizie_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022320

-- categorie_notizie_path_check
DROP FUNCTION IF EXISTS `categorie_notizie_path_check`;

-- | 202610022321

-- categorie_notizie_path_check
-- verifica: 2021-06-01 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_notizie_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022322

-- categorie_notizie_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_notizie_path_find_ancestor`;

-- | 202610022323

-- categorie_notizie_path_find_ancestor
-- verifica: 2021-05-23 18:35 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_notizie_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_notizie_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022324

-- categorie_prodotti_path
DROP FUNCTION IF EXISTS `categorie_prodotti_path`;

-- | 202610022325

-- categorie_prodotti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_prodotti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022326

-- categorie_prodotti_path_check
DROP FUNCTION IF EXISTS `categorie_prodotti_path_check`;

-- | 202610022327

-- categorie_prodotti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_prodotti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022328

-- categorie_prodotti_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_prodotti_path_find_ancestor`;

-- | 202610022329

-- categorie_prodotti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_prodotti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_prodotti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022330

-- categorie_progetti_path
DROP FUNCTION IF EXISTS `categorie_progetti_path`;

-- | 202610022331

-- categorie_progetti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_progetti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022332

-- categorie_progetti_path_check
DROP FUNCTION IF EXISTS `categorie_progetti_path_check`;

-- | 202610022333

-- categorie_progetti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_progetti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022334

-- categorie_progetti_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_progetti_path_find_ancestor`;

-- | 202610022335

-- categorie_progetti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_progetti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_progetti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022336

-- categorie_risorse_path
DROP FUNCTION IF EXISTS `categorie_risorse_path`;

-- | 202610022337

-- categorie_risorse_path
-- verifica: 2021-06-02 20:22 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_risorse_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022338

-- categorie_risorse_path_check
DROP FUNCTION IF EXISTS `categorie_risorse_path_check`;

-- | 202610022339

-- categorie_risorse_path_check
-- verifica: 2021-06-02 20:22 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_risorse_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022340

-- categorie_risorse_path_find_ancestor
DROP FUNCTION IF EXISTS `categorie_risorse_path_find_ancestor`;

-- | 202610022341

-- categorie_risorse_path_find_ancestor
-- verifica: 2021-06-02 19:56 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `categorie_risorse_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT categorie_risorse_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022342

-- colori_path
DROP FUNCTION IF EXISTS `colori_path`;

-- | 202610022343

-- colori_path
-- verifica: 2021-06-03 15:19 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `colori_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022344

-- colori_path_check
DROP FUNCTION IF EXISTS `colori_path_check`;

-- | 202610022345

-- colori_path_check
-- verifica: 2021-06-03 15:25 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `colori_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022346

-- colori_path_find_ancestor
DROP FUNCTION IF EXISTS `colori_path_find_ancestor`;

-- | 202610022347

-- colori_path_find_ancestor
-- verifica: 2021-06-02 19:56 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `colori_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT colori_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022348

-- gruppi_path
DROP FUNCTION IF EXISTS `gruppi_path`;

-- | 202610022349

-- gruppi_path
-- verifica: 2021-09-10 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `gruppi_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022350

-- gruppi_path_check
DROP FUNCTION IF EXISTS `gruppi_path_check`;

-- | 202610022351

-- gruppi_path_check
-- verifica: 2021-09-10 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `gruppi_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022352

-- gruppi_path_find_ancestor
DROP FUNCTION IF EXISTS `gruppi_path_find_ancestor`;

-- | 202610022353

-- gruppi_path_find_ancestor
-- verifica: 2021-09-10 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `gruppi_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT gruppi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022354

-- luoghi_path
DROP FUNCTION IF EXISTS `luoghi_path`;

-- | 202610022355

-- luoghi_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `luoghi_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022356

-- luoghi_path_check
DROP FUNCTION IF EXISTS `luoghi_path_check`;

-- | 202610022357

-- luoghi_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `luoghi_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022358

-- luoghi_path_find_ancestor
DROP FUNCTION IF EXISTS `luoghi_path_find_ancestor`;

-- | 202610022359

-- luoghi_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `luoghi_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT luoghi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022360

-- mastri_path
DROP FUNCTION IF EXISTS `mastri_path`;

-- | 202610022361

-- mastri_path
-- verifica: 2021-09-28 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `mastri_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022362

-- mastri_path_check
DROP FUNCTION IF EXISTS `mastri_path_check`;

-- | 202610022363

-- mastri_path_check
-- verifica: 2021-09-28 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `mastri_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022364

-- mastri_path_find_ancestor
DROP FUNCTION IF EXISTS `mastri_path_find_ancestor`;

-- | 202610022365

-- mastri_path_find_ancestor
-- verifica: 2021-09-28 18:10 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `mastri_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT mastri_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022366

-- organizzazioni_path
DROP FUNCTION IF EXISTS `organizzazioni_path`;

-- | 202610022367

-- organizzazioni_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `organizzazioni_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022368

-- organizzazioni_path_check
DROP FUNCTION IF EXISTS `organizzazioni_path_check`;

-- | 202610022369

-- organizzazioni_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `organizzazioni_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022370

-- organizzazioni_path_find_ancestor
DROP FUNCTION IF EXISTS `organizzazioni_path_find_ancestor`;

-- | 202610022371

-- organizzazioni_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `organizzazioni_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT organizzazioni_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022372

-- pagine_path
DROP FUNCTION IF EXISTS `pagine_path`;

-- | 202610022373

-- pagine_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pagine_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022374

-- pagine_path_check
DROP FUNCTION IF EXISTS `pagine_path_check`;

-- | 202610022375

-- pagine_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pagine_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022376

-- pagine_path_find_ancestor
DROP FUNCTION IF EXISTS `pagine_path_find_ancestor`;

-- | 202610022377

-- pagine_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pagine_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT pagine_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022378

-- pianificazioni_path
DROP FUNCTION IF EXISTS `pianificazioni_path`;

-- | 202610022379

-- pianificazioni_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pianificazioni_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022380

-- pianificazioni_path_check
DROP FUNCTION IF EXISTS `pianificazioni_path_check`;

-- | 202610022381

-- pianificazioni_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pianificazioni_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022382

-- pianificazioni_path_find_ancestor
DROP FUNCTION IF EXISTS `pianificazioni_path_find_ancestor`;

-- | 202610022383

-- pianificazioni_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `pianificazioni_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT pianificazioni_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022384

-- ruoli_anagrafica_path
DROP FUNCTION IF EXISTS `ruoli_anagrafica_path`;

-- | 202610022385

-- ruoli_anagrafica_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_anagrafica_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022386

-- ruoli_anagrafica_path_check
DROP FUNCTION IF EXISTS `ruoli_anagrafica_path_check`;

-- | 202610022387

-- ruoli_anagrafica_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_anagrafica_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022388

-- ruoli_anagrafica_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_anagrafica_path_find_ancestor`;

-- | 202610022389

-- ruoli_anagrafica_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_anagrafica_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_anagrafica_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022390

-- ruoli_articoli_path
DROP FUNCTION IF EXISTS `ruoli_articoli_path`;

-- | 202610022391

-- ruoli_articoli_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_articoli_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022392

-- ruoli_articoli_path_check
DROP FUNCTION IF EXISTS `ruoli_articoli_path_check`;

-- | 202610022393

-- ruoli_articoli_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_articoli_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022394

-- ruoli_articoli_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_articoli_path_find_ancestor`;

-- | 202610022395

-- ruoli_articoli_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_articoli_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_articoli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022396

-- ruoli_audio_path
DROP FUNCTION IF EXISTS `ruoli_audio_path`;

-- | 202610022397

-- ruoli_audio_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_audio_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022398

-- ruoli_audio_path_check
DROP FUNCTION IF EXISTS `ruoli_audio_path_check`;

-- | 202610022399

-- ruoli_audio_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_audio_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022400

-- ruoli_audio_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_audio_path_find_ancestor`;

-- | 202610022401

-- ruoli_audio_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_audio_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_audio_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022402

-- ruoli_categorie_progetti_path
DROP FUNCTION IF EXISTS `ruoli_categorie_progetti_path`;

-- | 202610022403

-- ruoli_categorie_progetti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_categorie_progetti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_categorie_progetti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_categorie_progetti.id_genitore,
				ruoli_categorie_progetti.nome
			FROM ruoli_categorie_progetti
			WHERE ruoli_categorie_progetti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202610022404

-- ruoli_categorie_progetti_path_check
DROP FUNCTION IF EXISTS `ruoli_categorie_progetti_path_check`;

-- | 202610022405

-- ruoli_categorie_progetti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_categorie_progetti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_categorie_progetti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_categorie_progetti.id_genitore
			FROM ruoli_categorie_progetti
			WHERE ruoli_categorie_progetti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202610022406

-- ruoli_categorie_progetti_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_categorie_progetti_path_find_ancestor`;

-- | 202610022407

-- ruoli_categorie_progetti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_categorie_progetti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_categorie_progetti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_categorie_progetti.id_genitore,
				ruoli_categorie_progetti.id
			FROM ruoli_categorie_progetti
			WHERE ruoli_categorie_progetti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202610022408

-- ruoli_documenti_path
DROP FUNCTION IF EXISTS `ruoli_documenti_path`;

-- | 202610022409

-- ruoli_documenti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_documenti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022410

-- ruoli_documenti_path_check
DROP FUNCTION IF EXISTS `ruoli_documenti_path_check`;

-- | 202610022411

-- ruoli_documenti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_documenti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022412

-- ruoli_documenti_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_documenti_path_find_ancestor`;

-- | 202610022413

-- ruoli_documenti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_documenti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_documenti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022414

-- ruoli_file_path
DROP FUNCTION IF EXISTS `ruoli_file_path`;

-- | 202610022415

-- ruoli_file_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_file_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022416

-- ruoli_file_path_check
DROP FUNCTION IF EXISTS `ruoli_file_path_check`;

-- | 202610022417

-- ruoli_file_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_file_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022418

-- ruoli_file_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_file_path_find_ancestor`;

-- | 202610022419

-- ruoli_file_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_file_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_file_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022420

-- ruoli_immagini_path
DROP FUNCTION IF EXISTS `ruoli_immagini_path`;

-- | 202610022421

-- ruoli_immagini_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_immagini_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022422

-- ruoli_immagini_path_check
DROP FUNCTION IF EXISTS `ruoli_immagini_path_check`;

-- | 202610022423

-- ruoli_immagini_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_immagini_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022424

-- ruoli_immagini_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_immagini_path_find_ancestor`;

-- | 202610022425

-- ruoli_immagini_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_immagini_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_immagini_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022426

-- ruoli_indirizzi_path
DROP FUNCTION IF EXISTS `ruoli_indirizzi_path`;

-- | 202610022427

-- ruoli_indirizzi_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_indirizzi_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022428

-- ruoli_indirizzi_path_check
DROP FUNCTION IF EXISTS `ruoli_indirizzi_path_check`;

-- | 202610022429

-- ruoli_indirizzi_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_indirizzi_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022430

-- ruoli_indirizzi_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_indirizzi_path_find_ancestor`;

-- | 202610022431

-- ruoli_indirizzi_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_indirizzi_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_indirizzi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022432

-- ruoli_mastri_path
DROP FUNCTION IF EXISTS `ruoli_mastri_path`;

-- | 202610022433

-- ruoli_mastri_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_mastri_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_mastri_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_mastri.id_genitore,
				ruoli_mastri.nome
			FROM ruoli_mastri
			WHERE ruoli_mastri.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202610022434

-- ruoli_mastri_path_check
DROP FUNCTION IF EXISTS `ruoli_mastri_path_check`;

-- | 202610022435

-- ruoli_mastri_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_mastri_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_mastri_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_mastri.id_genitore
			FROM ruoli_mastri
			WHERE ruoli_mastri.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202610022436

-- ruoli_mastri_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_mastri_path_find_ancestor`;

-- | 202610022437

-- ruoli_mastri_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_mastri_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_mastri_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_mastri.id_genitore,
				ruoli_mastri.id
			FROM ruoli_mastri
			WHERE ruoli_mastri.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202610022438

-- ruoli_matricole_path
DROP FUNCTION IF EXISTS `ruoli_matricole_path`;

-- | 202610022439

-- ruoli_matricole_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_matricole_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022440

-- ruoli_matricole_path_check
DROP FUNCTION IF EXISTS `ruoli_matricole_path_check`;

-- | 202610022441

-- ruoli_matricole_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_matricole_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022442

-- ruoli_matricole_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_matricole_path_find_ancestor`;

-- | 202610022443

-- ruoli_matricole_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_matricole_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_matricole_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022444

-- ruoli_prodotti_path
DROP FUNCTION IF EXISTS `ruoli_prodotti_path`;

-- | 202610022445

-- ruoli_prodotti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_prodotti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022446

-- ruoli_prodotti_path_check
DROP FUNCTION IF EXISTS `ruoli_prodotti_path_check`;

-- | 202610022447

-- ruoli_prodotti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_prodotti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022448

-- ruoli_prodotti_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_prodotti_path_find_ancestor`;

-- | 202610022449

-- ruoli_prodotti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_prodotti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_prodotti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022450

-- ruoli_video_path
DROP FUNCTION IF EXISTS `ruoli_video_path`;

-- | 202610022451

-- ruoli_video_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_video_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022452

-- ruoli_video_path_check
DROP FUNCTION IF EXISTS `ruoli_video_path_check`;

-- | 202610022453

-- ruoli_video_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_video_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022454

-- ruoli_video_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_video_path_find_ancestor`;

-- | 202610022455

-- ruoli_video_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_video_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_video_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022456

-- settori_path
DROP FUNCTION IF EXISTS `settori_path`;

-- | 202610022457

-- settori_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `settori_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022458

-- settori_path_check
DROP FUNCTION IF EXISTS `settori_path_check`;

-- | 202610022459

-- settori_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `settori_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022460

-- settori_path_find_ancestor
DROP FUNCTION IF EXISTS `settori_path_find_ancestor`;

-- | 202610022461

-- settori_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `settori_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT settori_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022462

-- software_path
DROP FUNCTION IF EXISTS `software_path`;

-- | 202610022463

-- software_path
-- verifica: 2021-11-16 10:39 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `software_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022464

-- software_path_check
DROP FUNCTION IF EXISTS `software_path_check`;

-- | 202610022465

-- software_path_check
-- verifica: 2021-11-16 10:39 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `software_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022466

-- software_path_find_ancestor
DROP FUNCTION IF EXISTS `software_path_find_ancestor`;

-- | 202610022467

-- software_path_find_ancestor
-- verifica: 2021-11-16 10:39 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `software_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT software_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022468

-- tipologie_anagrafica_path
DROP FUNCTION IF EXISTS `tipologie_anagrafica_path`;

-- | 202610022469

-- tipologie_anagrafica_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_anagrafica_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022470

-- tipologie_anagrafica_path_sigla
DROP FUNCTION IF EXISTS `tipologie_anagrafica_path_sigla`;

-- | 202610022471

-- tipologie_anagrafica_path_sigla
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_anagrafica_path_sigla`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022472

-- tipologie_anagrafica_path_check
DROP FUNCTION IF EXISTS `tipologie_anagrafica_path_check`;

-- | 202610022473

-- tipologie_anagrafica_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_anagrafica_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022474

-- tipologie_anagrafica_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_anagrafica_path_find_ancestor`;

-- | 202610022475

-- tipologie_anagrafica_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_anagrafica_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_anagrafica_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022476

-- tipologie_attivita_path
DROP FUNCTION IF EXISTS `tipologie_attivita_path`;

-- | 202610022477

-- tipologie_attivita_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_attivita_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022478

-- tipologie_attivita_path_check
DROP FUNCTION IF EXISTS `tipologie_attivita_path_check`;

-- | 202610022479

-- tipologie_attivita_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_attivita_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022480

-- tipologie_attivita_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_attivita_path_find_ancestor`;

-- | 202610022481

-- tipologie_attivita_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_attivita_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_attivita_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022482

-- tipologie_banner_path
DROP FUNCTION IF EXISTS `tipologie_banner_path`;

-- | 202610022483

-- tipologie_banner_path
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_banner_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022484

-- tipologie_banner_path_check
DROP FUNCTION IF EXISTS `tipologie_banner_path_check`;

-- | 202610022485

-- tipologie_banner_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_banner_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022486

-- tipologie_banner_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_banner_path_find_ancestor`;

-- | 202610022487

-- tipologie_banner_path_find_ancestor
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_banner_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_banner_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022488

-- tipologie_chiavi_path
DROP FUNCTION IF EXISTS `tipologie_chiavi_path`;

-- | 202610022489

-- tipologie_chiavi_path
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_chiavi_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022490

-- tipologie_chiavi_path_check
DROP FUNCTION IF EXISTS `tipologie_chiavi_path_check`;

-- | 202610022491

-- tipologie_chiavi_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_chiavi_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022492

-- tipologie_chiavi_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_chiavi_path_find_ancestor`;

-- | 202610022493

-- tipologie_chiavi_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_chiavi_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_chiavi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022494

-- tipologie_colli_path
DROP FUNCTION IF EXISTS `tipologie_colli_path`;

-- | 202610022495

-- tipologie_colli_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_colli_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022496

-- tipologie_colli_path_check
DROP FUNCTION IF EXISTS `tipologie_colli_path_check`;

-- | 202610022497

-- tipologie_colli_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_colli_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022498

-- tipologie_colli_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_colli_path_find_ancestor`;

-- | 202610022499

-- tipologie_colli_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_colli_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_colli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022500

-- tipologie_contatti_path
DROP FUNCTION IF EXISTS `tipologie_contatti_path`;

-- | 202610022501

-- tipologie_contatti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_contatti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022502

-- tipologie_contatti_path_check
DROP FUNCTION IF EXISTS `tipologie_contatti_path_check`;

-- | 202610022503

-- tipologie_contatti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_contatti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022504

-- tipologie_contatti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_contatti_path_find_ancestor`;

-- | 202610022505

-- tipologie_contatti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_contatti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_contatti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022506

-- tipologie_corrispondenza_path
DROP FUNCTION IF EXISTS `tipologie_corrispondenza_path`;

-- | 202610022507

-- tipologie_corrispondenza_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_corrispondenza_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022508

-- tipologie_corrispondenza_path_check
DROP FUNCTION IF EXISTS `tipologie_corrispondenza_path_check`;

-- | 202610022509

-- tipologie_corrispondenza_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_corrispondenza_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022510

-- tipologie_corrispondenza_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_corrispondenza_path_find_ancestor`;

-- | 202610022511

-- tipologie_corrispondenza_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_corrispondenza_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_corrispondenza_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022512

-- tipologie_documenti_path
DROP FUNCTION IF EXISTS `tipologie_documenti_path`;

-- | 202610022513

-- tipologie_documenti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_documenti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022514

-- tipologie_documenti_path_check
DROP FUNCTION IF EXISTS `tipologie_documenti_path_check`;

-- | 202610022515

-- tipologie_documenti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_documenti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022516

-- tipologie_documenti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_documenti_path_find_ancestor`;

-- | 202610022517

-- tipologie_documenti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_documenti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_documenti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022518

-- tipologie_documenti_articoli_path
DROP FUNCTION IF EXISTS `tipologie_documenti_articoli_path`;

-- | 202610022519

-- tipologie_documenti_articoli_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_documenti_articoli_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_documenti_articoli_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_documenti_articoli.id_genitore,
				tipologie_documenti_articoli.nome
			FROM tipologie_documenti_articoli
			WHERE tipologie_documenti_articoli.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202610022520

-- tipologie_documenti_articoli_path_check
DROP FUNCTION IF EXISTS `tipologie_documenti_articoli_path_check`;

-- | 202610022521

-- tipologie_documenti_articoli_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_documenti_articoli_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_documenti_articoli_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_documenti_articoli.id_genitore
			FROM tipologie_documenti_articoli
			WHERE tipologie_documenti_articoli.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202610022522

-- tipologie_documenti_articoli_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_documenti_articoli_path_find_ancestor`;

-- | 202610022523

-- tipologie_documenti_articoli_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_documenti_articoli_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_documenti_articoli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_documenti_articoli.id_genitore,
				tipologie_documenti_articoli.id
			FROM tipologie_documenti_articoli
			WHERE tipologie_documenti_articoli.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202610022524

-- tipologie_edifici_path
DROP FUNCTION IF EXISTS `tipologie_edifici_path`;

-- | 202610022525

-- tipologie_edifici_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_edifici_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022526

-- tipologie_edifici_path_check
DROP FUNCTION IF EXISTS `tipologie_edifici_path_check`;

-- | 202610022527

-- tipologie_edifici_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_edifici_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022528

-- tipologie_edifici_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_edifici_path_find_ancestor`;

-- | 202610022529

-- tipologie_edifici_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_edifici_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_edifici_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022530

-- tipologie_immobili_path
DROP FUNCTION IF EXISTS `tipologie_immobili_path`;

-- | 202610022531

-- tipologie_immobili_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_immobili_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022532

-- tipologie_immobili_path_check
DROP FUNCTION IF EXISTS `tipologie_immobili_path_check`;

-- | 202610022533

-- tipologie_immobili_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_immobili_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022534

-- tipologie_immobili_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_immobili_path_find_ancestor`;

-- | 202610022535

-- tipologie_immobili_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_immobili_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_immobili_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022536

-- tipologie_indirizzi_path
DROP FUNCTION IF EXISTS `tipologie_indirizzi_path`;

-- | 202610022537

-- tipologie_indirizzi_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_indirizzi_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022538

-- tipologie_indirizzi_path_check
DROP FUNCTION IF EXISTS `tipologie_indirizzi_path_check`;

-- | 202610022539

-- tipologie_indirizzi_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_indirizzi_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022540

-- tipologie_indirizzi_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_indirizzi_path_find_ancestor`;

-- | 202610022541

-- tipologie_indirizzi_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_indirizzi_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_indirizzi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022542

-- tipologie_licenze_path
DROP FUNCTION IF EXISTS `tipologie_licenze_path`;

-- | 202610022543

-- tipologie_licenze_path
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_licenze_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022544

-- tipologie_licenze_path_check
DROP FUNCTION IF EXISTS `tipologie_licenze_path_check`;

-- | 202610022545

-- tipologie_licenze_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_licenze_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022546

-- tipologie_licenze_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_licenze_path_find_ancestor`;

-- | 202610022547

-- tipologie_licenze_path_find_ancestor
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_licenze_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_licenze_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022548

-- tipologie_luoghi_path
DROP FUNCTION IF EXISTS `tipologie_luoghi_path`;

-- | 202610022549

-- tipologie_luoghi_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_luoghi_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022550

-- tipologie_luoghi_path_check
DROP FUNCTION IF EXISTS `tipologie_luoghi_path_check`;

-- | 202610022551

-- tipologie_luoghi_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_luoghi_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022552

-- tipologie_luoghi_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_luoghi_path_find_ancestor`;

-- | 202610022553

-- tipologie_luoghi_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_luoghi_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_luoghi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022554

-- tipologie_mastri_path
DROP FUNCTION IF EXISTS `tipologie_mastri_path`;

-- | 202610022555

-- tipologie_mastri_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_mastri_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022556

-- tipologie_mastri_path_check
DROP FUNCTION IF EXISTS `tipologie_mastri_path_check`;

-- | 202610022557

-- tipologie_mastri_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_mastri_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022558

-- tipologie_mastri_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_mastri_path_find_ancestor`;

-- | 202610022559

-- tipologie_mastri_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_mastri_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_mastri_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022560

-- tipologie_listini_path
DROP FUNCTION IF EXISTS `tipologie_listini_path`;

-- | 202610022561

-- tipologie_listini_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_listini_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022562

-- tipologie_listini_path_check
DROP FUNCTION IF EXISTS `tipologie_listini_path_check`;

-- | 202610022563

-- tipologie_listini_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_listini_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022564

-- tipologie_listini_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_listini_path_find_ancestor`;

-- | 202610022565

-- tipologie_listini_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_listini_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_listini_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022566

-- tipologie_notizie_path
DROP FUNCTION IF EXISTS `tipologie_notizie_path`;

-- | 202610022567

-- tipologie_notizie_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_notizie_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022568

-- tipologie_notizie_path_check
DROP FUNCTION IF EXISTS `tipologie_notizie_path_check`;

-- | 202610022569

-- tipologie_notizie_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_notizie_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022570

-- tipologie_notizie_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_notizie_path_find_ancestor`;

-- | 202610022571

-- tipologie_notizie_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_notizie_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_notizie_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022572

-- tipologie_periodi_path
DROP FUNCTION IF EXISTS `tipologie_periodi_path`;

-- | 202610022573

-- tipologie_periodi_path
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_periodi_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022574

-- tipologie_periodi_path_check
DROP FUNCTION IF EXISTS `tipologie_periodi_path_check`;

-- | 202610022575

-- tipologie_periodi_path_check
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_periodi_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022576

-- tipologie_periodi_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_periodi_path_find_ancestor`;

-- | 202610022577

-- tipologie_periodi_path_find_ancestor
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_periodi_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_periodi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022578

-- tipologie_popup_path
DROP FUNCTION IF EXISTS `tipologie_popup_path`;

-- | 202610022579

-- tipologie_popup_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_popup_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022580

-- tipologie_popup_path_check
DROP FUNCTION IF EXISTS `tipologie_popup_path_check`;

-- | 202610022581

-- tipologie_popup_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_popup_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022582

-- tipologie_popup_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_popup_path_find_ancestor`;

-- | 202610022583

-- tipologie_popup_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_popup_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_popup_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022584

-- tipologie_prodotti_path
DROP FUNCTION IF EXISTS `tipologie_prodotti_path`;

-- | 202610022585

-- tipologie_prodotti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_prodotti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022586

-- tipologie_prodotti_path_check
DROP FUNCTION IF EXISTS `tipologie_prodotti_path_check`;

-- | 202610022587

-- tipologie_prodotti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_prodotti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022588

-- tipologie_prodotti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_prodotti_path_find_ancestor`;

-- | 202610022589

-- tipologie_prodotti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_prodotti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_prodotti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022590

-- tipologie_progetti_path
DROP FUNCTION IF EXISTS `tipologie_progetti_path`;

-- | 202610022591

-- tipologie_progetti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_progetti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022592

-- tipologie_progetti_path_check
DROP FUNCTION IF EXISTS `tipologie_progetti_path_check`;

-- | 202610022593

-- tipologie_progetti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_progetti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022594

-- tipologie_progetti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_progetti_path_find_ancestor`;

-- | 202610022595

-- tipologie_progetti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_progetti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_progetti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022596

-- tipologie_pubblicazioni_path
DROP FUNCTION IF EXISTS `tipologie_pubblicazioni_path`;

-- | 202610022597

-- tipologie_pubblicazioni_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_pubblicazioni_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022598

-- tipologie_pubblicazioni_path_check
DROP FUNCTION IF EXISTS `tipologie_pubblicazioni_path_check`;

-- | 202610022599

-- tipologie_pubblicazioni_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_pubblicazioni_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022600

-- tipologie_pubblicazioni_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_pubblicazioni_path_find_ancestor`;

-- | 202610022601

-- tipologie_pubblicazioni_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_pubblicazioni_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_pubblicazioni_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022602

-- tipologie_risorse_path
DROP FUNCTION IF EXISTS `tipologie_risorse_path`;

-- | 202610022603

-- tipologie_risorse_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_risorse_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022604

-- tipologie_risorse_path_check
DROP FUNCTION IF EXISTS `tipologie_risorse_path_check`;

-- | 202610022605

-- tipologie_risorse_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_risorse_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022606

-- tipologie_risorse_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_risorse_path_find_ancestor`;

-- | 202610022607

-- tipologie_risorse_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_risorse_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_risorse_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022608

-- tipologie_spedizioni_path
DROP FUNCTION IF EXISTS `tipologie_spedizioni_path`;

-- | 202610022609

-- tipologie_spedizioni_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_spedizioni_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_spedizioni_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_spedizioni.id_genitore,
				tipologie_spedizioni.nome
			FROM tipologie_spedizioni
			WHERE tipologie_spedizioni.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202610022610

-- tipologie_spedizioni_path_check
DROP FUNCTION IF EXISTS `tipologie_spedizioni_path_check`;

-- | 202610022611

-- tipologie_spedizioni_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_spedizioni_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_spedizioni_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_spedizioni.id_genitore
			FROM tipologie_spedizioni
			WHERE tipologie_spedizioni.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202610022612

-- tipologie_spedizioni_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_spedizioni_path_find_ancestor`;

-- | 202610022613

-- tipologie_spedizioni_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_spedizioni_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_spedizioni_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_spedizioni.id_genitore,
				tipologie_spedizioni.id
			FROM tipologie_spedizioni
			WHERE tipologie_spedizioni.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202610022614

-- tipologie_telefoni_path
DROP FUNCTION IF EXISTS `tipologie_telefoni_path`;

-- | 202610022615

-- tipologie_telefoni_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_telefoni_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022616

-- tipologie_telefoni_path_check
DROP FUNCTION IF EXISTS `tipologie_telefoni_path_check`;

-- | 202610022617

-- tipologie_telefoni_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_telefoni_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022618

-- tipologie_telefoni_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_telefoni_path_find_ancestor`;

-- | 202610022619

-- tipologie_telefoni_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_telefoni_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_telefoni_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022620

-- tipologie_url_path
DROP FUNCTION IF EXISTS `tipologie_url_path`;

-- | 202610022621

-- tipologie_url_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_url_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022622

-- tipologie_url_path_check
DROP FUNCTION IF EXISTS `tipologie_url_path_check`;

-- | 202610022623

-- tipologie_url_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_url_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022624

-- tipologie_url_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_url_path_find_ancestor`;

-- | 202610022625

-- tipologie_url_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_url_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_url_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022626

-- tipologie_veicoli_path
DROP FUNCTION IF EXISTS `tipologie_veicoli_path`;

-- | 202610022627

-- tipologie_veicoli_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_veicoli_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022628

-- tipologie_veicoli_path_check
DROP FUNCTION IF EXISTS `tipologie_veicoli_path_check`;

-- | 202610022629

-- tipologie_veicoli_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_veicoli_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022630

-- tipologie_veicoli_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_veicoli_path_find_ancestor`;

-- | 202610022631

-- tipologie_veicoli_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_veicoli_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_veicoli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022632

-- tipologie_zone_path
DROP FUNCTION IF EXISTS `tipologie_zone_path`;

-- | 202610022633

-- tipologie_zone_path
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_zone_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022634

-- tipologie_zone_path_check
DROP FUNCTION IF EXISTS `tipologie_zone_path_check`;

-- | 202610022635

-- tipologie_zone_path_check
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_zone_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022636

-- tipologie_zone_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_zone_path_find_ancestor`;

-- | 202610022637

-- tipologie_zone_path_find_ancestor
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_zone_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_zone_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022638

-- attivita_path
DROP FUNCTION IF EXISTS `attivita_path`;

-- | 202610022639

-- attivita_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `attivita_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022640

-- attivita_path_check
DROP FUNCTION IF EXISTS `attivita_path_check`;

-- | 202610022641

-- attivita_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `attivita_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022642

-- attivita_path_find_ancestor
DROP FUNCTION IF EXISTS `attivita_path_find_ancestor`;

-- | 202610022643

-- attivita_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `attivita_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT attivita_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022644

-- listini_path
DROP FUNCTION IF EXISTS `listini_path`;

-- | 202610022645

-- listini_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `listini_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022646

-- listini_path_check
DROP FUNCTION IF EXISTS `listini_path_check`;

-- | 202610022647

-- listini_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `listini_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022648

-- listini_path_find_ancestor
DROP FUNCTION IF EXISTS `listini_path_find_ancestor`;

-- | 202610022649

-- listini_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `listini_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT listini_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022650

-- ruoli_mail_path
DROP FUNCTION IF EXISTS `ruoli_mail_path`;

-- | 202610022651

-- ruoli_mail_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_mail_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022652

-- ruoli_mail_path_check
DROP FUNCTION IF EXISTS `ruoli_mail_path_check`;

-- | 202610022653

-- ruoli_mail_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_mail_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022654

-- ruoli_mail_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_mail_path_find_ancestor`;

-- | 202610022655

-- ruoli_mail_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_mail_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_mail_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022656

-- asset_path
DROP FUNCTION IF EXISTS `asset_path`;

-- | 202610022657

-- asset_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `asset_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022658

-- asset_path_check
DROP FUNCTION IF EXISTS `asset_path_check`;

-- | 202610022659

-- asset_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `asset_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022660

-- asset_path_find_ancestor
DROP FUNCTION IF EXISTS `asset_path_find_ancestor`;

-- | 202610022661

-- asset_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `asset_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT asset_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022662

-- caratteristiche_prodotti_path
DROP FUNCTION IF EXISTS `caratteristiche_prodotti_path`;

-- | 202610022663

-- caratteristiche_prodotti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `caratteristiche_prodotti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022664

-- caratteristiche_prodotti_path_check
DROP FUNCTION IF EXISTS `caratteristiche_prodotti_path_check`;

-- | 202610022665

-- caratteristiche_prodotti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `caratteristiche_prodotti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022666

-- caratteristiche_prodotti_path_find_ancestor
DROP FUNCTION IF EXISTS `caratteristiche_prodotti_path_find_ancestor`;

-- | 202610022667

-- caratteristiche_prodotti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `caratteristiche_prodotti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT caratteristiche_prodotti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022668

-- colli_path
DROP FUNCTION IF EXISTS `colli_path`;

-- | 202610022669

-- colli_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `colli_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022670

-- colli_path_check
DROP FUNCTION IF EXISTS `colli_path_check`;

-- | 202610022671

-- colli_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `colli_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022672

-- colli_path_find_ancestor
DROP FUNCTION IF EXISTS `colli_path_find_ancestor`;

-- | 202610022673

-- colli_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `colli_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT colli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022674

-- documenti_articoli_path
DROP FUNCTION IF EXISTS `documenti_articoli_path`;

-- | 202610022675

-- documenti_articoli_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `documenti_articoli_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022676

-- documenti_articoli_path_check
DROP FUNCTION IF EXISTS `documenti_articoli_path_check`;

-- | 202610022677

-- documenti_articoli_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `documenti_articoli_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022678

-- documenti_articoli_path_find_ancestor
DROP FUNCTION IF EXISTS `documenti_articoli_path_find_ancestor`;

-- | 202610022679

-- documenti_articoli_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `documenti_articoli_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT documenti_articoli_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022680

-- tipologie_contratti_path
DROP FUNCTION IF EXISTS `tipologie_contratti_path`;

-- | 202610022681

-- tipologie_contratti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_contratti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022682

-- tipologie_contratti_path_check
DROP FUNCTION IF EXISTS `tipologie_contratti_path_check`;

-- | 202610022683

-- tipologie_contratti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_contratti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022684

-- tipologie_contratti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_contratti_path_find_ancestor`;

-- | 202610022685

-- tipologie_contratti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_contratti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_contratti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022686

-- tipologie_pagamenti_path
DROP FUNCTION IF EXISTS `tipologie_pagamenti_path`;

-- | 202610022687

-- tipologie_pagamenti_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_pagamenti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022688

-- tipologie_pagamenti_path_check
DROP FUNCTION IF EXISTS `tipologie_pagamenti_path_check`;

-- | 202610022689

-- tipologie_pagamenti_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_pagamenti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022690

-- tipologie_pagamenti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_pagamenti_path_find_ancestor`;

-- | 202610022691

-- tipologie_pagamenti_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_pagamenti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_pagamenti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022692

-- tipologie_rinnovi_path
DROP FUNCTION IF EXISTS `tipologie_rinnovi_path`;

-- | 202610022693

-- tipologie_rinnovi_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_rinnovi_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022694

-- tipologie_rinnovi_path_check
DROP FUNCTION IF EXISTS `tipologie_rinnovi_path_check`;

-- | 202610022695

-- tipologie_rinnovi_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_rinnovi_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022696

-- tipologie_rinnovi_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_rinnovi_path_find_ancestor`;

-- | 202610022697

-- tipologie_rinnovi_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_rinnovi_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_rinnovi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022698

-- tipologie_todo_path
DROP FUNCTION IF EXISTS `tipologie_todo_path`;

-- | 202610022699

-- tipologie_todo_path
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_todo_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022700

-- tipologie_todo_path_check
DROP FUNCTION IF EXISTS `tipologie_todo_path_check`;

-- | 202610022701

-- tipologie_todo_path_check
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_todo_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022702

-- tipologie_todo_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_todo_path_find_ancestor`;

-- | 202610022703

-- tipologie_todo_path_find_ancestor
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_todo_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_todo_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | 202610022704

-- zone_path
DROP FUNCTION IF EXISTS `zone_path`;

-- | 202610022705

-- zone_path
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `zone_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

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

-- | 202610022706

-- zone_path_check
DROP FUNCTION IF EXISTS `zone_path_check`;

-- | 202610022707

-- zone_path_check
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `zone_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole verificare il path
		-- p2 bigint( 20 ) -> l'id dell'oggetto da cercare nel path

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

-- | 202610022708

-- zone_path_find_ancestor
DROP FUNCTION IF EXISTS `zone_path_find_ancestor`;

-- | 202610022709

-- zone_path_find_ancestor
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `zone_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT zone_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

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

-- | FINE FILE

-- | FINE FILE
