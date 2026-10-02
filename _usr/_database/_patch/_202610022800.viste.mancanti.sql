-- 2026-10-02 — le viste _view che mancavano, e le funzioni _path delle tabelle ricorsive che non le avevano
--
-- COSA SI VEDEVA. 39 tabelle dei file di base non avevano la loro vista _view: 30 erano state tolte da
-- _090000999999.views.sql nel riallineamento d975b4a15 del 02/03/2026 ( anagrafica_view riaggiunta e ritolta il
-- 03/09/2026 ), 9 non erano mai state scritte. Il codice ne legge diverse ( anagrafica_view in 42 file, mastri_view,
-- tipologie_todo_view, indirizzi_view ): sui deploy che le avevano da prima continuavano a esistere, sui database
-- nuovi no. Sei tabelle ricorsive ( periodi, ruoli_progetti, tipologie_annunci, tipologie_attivita_inps,
-- tipologie_badge, tipologie_sconti ) non avevano le tre funzioni _path, _path_check, _path_find_ancestor; due viste
-- recuperate e carrelli_documenti_view non avevano __label__.
--
-- COSA FA. Crea le 18 funzioni ( DROP IF EXISTS + CREATE ) e poi le 40 viste ( CREATE OR REPLACE ) col testo dei
-- file di base del 02/10/2026. Le 30 recuperate sono l'ultima versione della storia, confrontata con quelle vive su
-- gimbe, bernispa, crmfia, polmasi e lughese: uguale o con piu' colonne in tutti i casi; tolte solo le JOIN verso le
-- tabelle che non esistono piu' ( tipologie_asset, formati_tipologie_corrispondenza, tipologie_istruzioni, funnel ).
-- Su un deploy che ha una versione sua di una di queste viste, la sostituisce: lo schema e' uno solo.
--
-- ATTENZIONE. Le viste citano le colonne del canone: un database a cui manca una colonna si ferma qui con 1054, e la
-- colonna va portata dalla patch che la aggiunge, non tolta dalla vista.
--
-- Blocchi da 202610022800 a 202610022875, sotto 202610030000. IDEMPOTENTE.

-- | 202610022800

-- periodi_path
DROP FUNCTION IF EXISTS `periodi_path`;

-- | 202610022801

-- periodi_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `periodi_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT periodi_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				periodi.id_genitore,
				periodi.nome
			FROM periodi
			WHERE periodi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202610022802

-- periodi_path_check
DROP FUNCTION IF EXISTS `periodi_path_check`;

-- | 202610022803

-- periodi_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `periodi_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT periodi_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				periodi.id_genitore
			FROM periodi
			WHERE periodi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202610022804

-- periodi_path_find_ancestor
DROP FUNCTION IF EXISTS `periodi_path_find_ancestor`;

-- | 202610022805

-- periodi_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `periodi_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT periodi_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				periodi.id_genitore,
				periodi.id
			FROM periodi
			WHERE periodi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202610022806

-- ruoli_progetti_path
DROP FUNCTION IF EXISTS `ruoli_progetti_path`;

-- | 202610022807

-- ruoli_progetti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_progetti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_progetti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_progetti.id_genitore,
				ruoli_progetti.nome
			FROM ruoli_progetti
			WHERE ruoli_progetti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202610022808

-- ruoli_progetti_path_check
DROP FUNCTION IF EXISTS `ruoli_progetti_path_check`;

-- | 202610022809

-- ruoli_progetti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_progetti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT ruoli_progetti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_progetti.id_genitore
			FROM ruoli_progetti
			WHERE ruoli_progetti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202610022810

-- ruoli_progetti_path_find_ancestor
DROP FUNCTION IF EXISTS `ruoli_progetti_path_find_ancestor`;

-- | 202610022811

-- ruoli_progetti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `ruoli_progetti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT ruoli_progetti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_progetti.id_genitore,
				ruoli_progetti.id
			FROM ruoli_progetti
			WHERE ruoli_progetti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202610022812

-- tipologie_annunci_path
DROP FUNCTION IF EXISTS `tipologie_annunci_path`;

-- | 202610022813

-- tipologie_annunci_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_annunci_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_annunci_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_annunci.id_genitore,
				tipologie_annunci.nome
			FROM tipologie_annunci
			WHERE tipologie_annunci.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202610022814

-- tipologie_annunci_path_check
DROP FUNCTION IF EXISTS `tipologie_annunci_path_check`;

-- | 202610022815

-- tipologie_annunci_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_annunci_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_annunci_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_annunci.id_genitore
			FROM tipologie_annunci
			WHERE tipologie_annunci.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202610022816

-- tipologie_annunci_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_annunci_path_find_ancestor`;

-- | 202610022817

-- tipologie_annunci_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_annunci_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_annunci_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_annunci.id_genitore,
				tipologie_annunci.id
			FROM tipologie_annunci
			WHERE tipologie_annunci.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202610022818

-- tipologie_attivita_inps_path
DROP FUNCTION IF EXISTS `tipologie_attivita_inps_path`;

-- | 202610022819

-- tipologie_attivita_inps_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_attivita_inps_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_attivita_inps_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_attivita_inps.id_genitore,
				tipologie_attivita_inps.nome
			FROM tipologie_attivita_inps
			WHERE tipologie_attivita_inps.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202610022820

-- tipologie_attivita_inps_path_check
DROP FUNCTION IF EXISTS `tipologie_attivita_inps_path_check`;

-- | 202610022821

-- tipologie_attivita_inps_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_attivita_inps_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_attivita_inps_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_attivita_inps.id_genitore
			FROM tipologie_attivita_inps
			WHERE tipologie_attivita_inps.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202610022822

-- tipologie_attivita_inps_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_attivita_inps_path_find_ancestor`;

-- | 202610022823

-- tipologie_attivita_inps_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_attivita_inps_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_attivita_inps_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_attivita_inps.id_genitore,
				tipologie_attivita_inps.id
			FROM tipologie_attivita_inps
			WHERE tipologie_attivita_inps.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202610022824

-- tipologie_badge_path
DROP FUNCTION IF EXISTS `tipologie_badge_path`;

-- | 202610022825

-- tipologie_badge_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_badge_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_badge_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_badge.id_genitore,
				tipologie_badge.nome
			FROM tipologie_badge
			WHERE tipologie_badge.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202610022826

-- tipologie_badge_path_check
DROP FUNCTION IF EXISTS `tipologie_badge_path_check`;

-- | 202610022827

-- tipologie_badge_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_badge_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_badge_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_badge.id_genitore
			FROM tipologie_badge
			WHERE tipologie_badge.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202610022828

-- tipologie_badge_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_badge_path_find_ancestor`;

-- | 202610022829

-- tipologie_badge_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_badge_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_badge_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_badge.id_genitore,
				tipologie_badge.id
			FROM tipologie_badge
			WHERE tipologie_badge.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202610022830

-- tipologie_sconti_path
DROP FUNCTION IF EXISTS `tipologie_sconti_path`;

-- | 202610022831

-- tipologie_sconti_path
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_sconti_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_sconti_path( <id> ) AS path

		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_sconti.id_genitore,
				tipologie_sconti.nome
			FROM tipologie_sconti
			WHERE tipologie_sconti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;

-- | 202610022832

-- tipologie_sconti_path_check
DROP FUNCTION IF EXISTS `tipologie_sconti_path_check`;

-- | 202610022833

-- tipologie_sconti_path_check
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_sconti_path_check`( `p1` BIGINT( 20 ), `p2` BIGINT( 20 ) ) RETURNS TINYINT( 1 )
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
		-- SELECT tipologie_sconti_path_check( <id1>, <id2> ) AS check

		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_sconti.id_genitore
			FROM tipologie_sconti
			WHERE tipologie_sconti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;

-- | 202610022834

-- tipologie_sconti_path_find_ancestor
DROP FUNCTION IF EXISTS `tipologie_sconti_path_find_ancestor`;

-- | 202610022835

-- tipologie_sconti_path_find_ancestor
-- verifica: 2021-10-04 11:49 Fabio Mosti
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_sconti_path_find_ancestor`( `p1` BIGINT( 20 ) ) RETURNS BIGINT( 20 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

		-- PARAMETRI
		-- p1 bigint( 20 ) -> l'id dell'oggetto per il quale si vuole trovare il progenitore

		-- DIPENDENZE
		-- nessuna

		-- TEST
		-- SELECT tipologie_sconti_path_find_ancestor( <id1> ) AS check

		DECLARE p2 bigint( 20 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_sconti.id_genitore,
				tipologie_sconti.id
			FROM tipologie_sconti
			WHERE tipologie_sconti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;

-- | 202610022836

-- anagrafica_view
-- estratta dal database e dichiarata qui il 2026-08-28: non era mai stata nei patch,
-- mentre anagrafica_view_static lo era gia'. E' quell'asimmetria ad aver permesso
-- alle due di divergere, rompendo la REPLACE che tiene allineata la statica.
CREATE OR REPLACE VIEW `anagrafica_view` AS
	SELECT
		`anagrafica`.`id` AS `id`,
		`anagrafica`.`id_tipologia` AS `id_tipologia`,
		`tipologie_anagrafica`.`nome` AS `tipologia`,
		`anagrafica`.`codice` AS `codice`,
		`anagrafica`.`riferimento` AS `riferimento`,
		`anagrafica`.`nome` AS `nome`,
		`anagrafica`.`cognome` AS `cognome`,
		`anagrafica`.`denominazione` AS `denominazione`,
		`anagrafica`.`soprannome` AS `soprannome`,
		`anagrafica`.`sesso` AS `sesso`,
		`anagrafica`.`codice_fiscale` AS `codice_fiscale`,
		`anagrafica`.`partita_iva` AS `partita_iva`,
		`anagrafica`.`id_ranking` AS `id_ranking`,
		`ranking`.`nome` AS `ranking`,
		`anagrafica`.`recapiti` AS `recapiti`,
		NULL AS `id_stato`,
		NULL AS `id_provincia`,
		max(`categorie_anagrafica`.`se_prospect`) AS `se_prospect`,
		max(`categorie_anagrafica`.`se_lead`) AS `se_lead`,
		max(`categorie_anagrafica`.`se_cliente`) AS `se_cliente`,
		max(`categorie_anagrafica`.`se_fornitore`) AS `se_fornitore`,
		max(`categorie_anagrafica`.`se_produttore`) AS `se_produttore`,
		max(`categorie_anagrafica`.`se_collaboratore`) AS `se_collaboratore`,
		max(`categorie_anagrafica`.`se_interno`) AS `se_interno`,
		max(`categorie_anagrafica`.`se_esterno`) AS `se_esterno`,
		max(`categorie_anagrafica`.`se_commerciale`) AS `se_commerciale`,
		max(`categorie_anagrafica`.`se_concorrente`) AS `se_concorrente`,
		max(`categorie_anagrafica`.`se_gestita`) AS `se_gestita`,
		max(`categorie_anagrafica`.`se_amministrazione`) AS `se_amministrazione`,
		max(`categorie_anagrafica`.`se_notizie`) AS `se_notizie`,
		group_concat(distinct `categorie_anagrafica_path`(`categorie_anagrafica`.`id`) separator ' | ') AS `categorie`,
		group_concat(distinct `telefoni`.`numero` separator ' | ') AS `telefoni`,
		group_concat(distinct `mail`.`indirizzo` separator ' | ') AS `mail`,
		`anagrafica`.`anno_nascita` AS `anno_nascita`,
		`anagrafica`.`mese_nascita` AS `mese_nascita`,
		`anagrafica`.`giorno_nascita` AS `giorno_nascita`,
		concat_ws('-',`anagrafica`.`anno_nascita`,lpad(`anagrafica`.`mese_nascita`,2,'0'),lpad(`anagrafica`.`giorno_nascita`,2,'0')) AS `data_nascita`,
		`anagrafica`.`id_comune_nascita` AS `id_comune_nascita`,
		`anagrafica`.`data_archiviazione` AS `data_archiviazione`,
		`anagrafica`.`id_account_inserimento` AS `id_account_inserimento`,
		`anagrafica`.`timestamp_inserimento` AS `timestamp_inserimento`,
		`anagrafica`.`id_account_aggiornamento` AS `id_account_aggiornamento`,
		`anagrafica`.`timestamp_aggiornamento` AS `timestamp_aggiornamento`,
		concat_ws(' ',`anagrafica`.`codice`,coalesce(`anagrafica`.`soprannome`,`anagrafica`.`denominazione`,concat_ws(' ',coalesce(`anagrafica`.`cognome`,''),coalesce(`anagrafica`.`nome`,'')),'')) AS `__label__`
	FROM
		((((((`anagrafica`
		left join `tipologie_anagrafica` on(`tipologie_anagrafica`.`id` = `anagrafica`.`id_tipologia`))
		left join `ranking` on(`ranking`.`id` = `anagrafica`.`id_ranking`))
		left join `anagrafica_categorie` on(`anagrafica_categorie`.`id_anagrafica` = `anagrafica`.`id`))
		left join `categorie_anagrafica` on(`categorie_anagrafica`.`id` = `anagrafica_categorie`.`id_categoria`))
		left join `telefoni` on(`telefoni`.`id_anagrafica` = `anagrafica`.`id`))
		left join `mail` on(`mail`.`id_anagrafica` = `anagrafica`.`id`))
		group by `anagrafica`.`id`
;

-- | 202610022837

-- articoli_caratteristiche_view
-- tipologia: tabella gestita
-- verifica: 2021-05-26 12:01 Fabio Mosti
CREATE OR REPLACE VIEW `articoli_caratteristiche_view` AS
	SELECT
		articoli_caratteristiche.id,
		articoli_caratteristiche.id_articolo,
		articoli_caratteristiche.id_caratteristica,
		articoli_caratteristiche.ordine,
		articoli_caratteristiche.valore,
		articoli_caratteristiche.se_assente,
		concat(
			articoli_caratteristiche.id_articolo,
			': ',
			caratteristiche.nome,
			' ',
			articoli_caratteristiche.valore
		) AS __label__
	FROM articoli_caratteristiche
		LEFT JOIN caratteristiche ON caratteristiche.id = articoli_caratteristiche.id_caratteristica
;

-- | 202610022838

-- asset_view
CREATE OR REPLACE VIEW `asset_view` AS
	SELECT
		asset.id,
		asset.id_tipologia,
		asset.codice,
		asset.nome,
        asset.hostname,
        asset.ip_address,
		asset.cespite,
		asset.note,
		asset.id_account_inserimento,
		asset.timestamp_inserimento,
		asset.id_account_aggiornamento,
		asset.timestamp_aggiornamento,
		concat_ws( ' ', concat( '#', asset.codice ), asset.nome ) AS __label__
	FROM asset
;

-- | 202610022839

-- carrelli_view
-- tipologia: tabella gestita
-- verifica: 2022-07-12 14:45 Chiara GDL
CREATE OR REPLACE VIEW `carrelli_view` AS
	SELECT
	carrelli.id,
	carrelli.session,
	coalesce( carrelli.intestazione_nome, carrelli.destinatario_nome ) AS cliente_nome,
	coalesce( carrelli.intestazione_cognome, carrelli.destinatario_cognome ) AS cliente_cognome,
	coalesce( carrelli.intestazione_denominazione, carrelli.destinatario_denominazione ) AS cliente_denominazione,
    coalesce( carrelli.intestazione_mail, carrelli.destinatario_mail ) AS cliente_mail,
    coalesce( carrelli.intestazione_mobile, carrelli.destinatario_mobile ) AS cliente_mobile,
	carrelli.destinatario_nome,
	carrelli.destinatario_cognome,
	carrelli.destinatario_denominazione,
    carrelli.destinatario_id_tipologia_anagrafica,
	carrelli.destinatario_id_anagrafica,
	carrelli.destinatario_id_account,
	carrelli.destinatario_indirizzo,
	carrelli.destinatario_cap,
	carrelli.destinatario_citta,
	carrelli.destinatario_id_comune,
	carrelli.destinatario_id_provincia,
	carrelli.destinatario_id_stato,
	carrelli.destinatario_id_comune_nascita,
	carrelli.destinatario_giorno_nascita,
	carrelli.destinatario_mese_nascita,
	carrelli.destinatario_anno_nascita,
	carrelli.destinatario_id_provincia_nascita,
	carrelli.destinatario_id_stato_nascita,
	carrelli.destinatario_telefono,
	carrelli.destinatario_mobile,
	carrelli.destinatario_fax,
	carrelli.destinatario_mail,
	carrelli.destinatario_codice_fiscale,
	carrelli.destinatario_partita_iva,
	coalesce( concat( carrelli.destinatario_nome, ' ', carrelli.destinatario_cognome ), carrelli.destinatario_denominazione ) AS destinatario,
	carrelli.intestazione_nome,
	carrelli.intestazione_cognome,
	carrelli.intestazione_denominazione,
    carrelli.intestazione_id_tipologia_anagrafica,
	carrelli.intestazione_id_anagrafica,
	carrelli.intestazione_id_account,
	carrelli.intestazione_indirizzo,
	carrelli.intestazione_cap,
	carrelli.intestazione_citta,
	carrelli.intestazione_id_provincia,
	carrelli.intestazione_id_stato,
	carrelli.intestazione_id_comune_nascita,
	carrelli.intestazione_giorno_nascita,
	carrelli.intestazione_mese_nascita,
	carrelli.intestazione_anno_nascita,
	carrelli.intestazione_id_provincia_nascita,
	carrelli.intestazione_id_stato_nascita,
	carrelli.intestazione_telefono,
	carrelli.intestazione_mobile,
	carrelli.intestazione_fax,
	carrelli.intestazione_mail,
	carrelli.intestazione_codice_fiscale,
	carrelli.intestazione_partita_iva,
	carrelli.intestazione_sdi,
	carrelli.intestazione_pec,
	coalesce( concat( carrelli.intestazione_nome, ' ', carrelli.intestazione_cognome ), carrelli.intestazione_denominazione ) AS intestazione,
	carrelli.id_listino,
    carrelli.fatturazione_id_tipologia_documento,
    carrelli.fatturazione_sezionale,
    carrelli.fatturazione_strategia,
	carrelli.prezzo_netto_totale,
	carrelli.prezzo_lordo_totale,
	carrelli.sconto_percentuale,
	carrelli.sconto_valore,
	carrelli.prezzo_netto_finale,
	carrelli.prezzo_lordo_finale,
	from_unixtime( carrelli.timestamp_inserimento, '%Y-%m-%d %H:%i' ) AS data_ora_inserimento,
	carrelli.provider_checkout,
	carrelli.timestamp_checkout,
	from_unixtime( carrelli.timestamp_checkout, '%Y-%m-%d %H:%i' ) AS data_ora_checkout,
	carrelli.provider_pagamento,
	carrelli.timestamp_pagamento,
	from_unixtime( carrelli.timestamp_pagamento, '%Y-%m-%d %H:%i' ) AS data_ora_pagamento,
	carrelli.codice_pagamento,
    carrelli.ordine_pagamento,
	carrelli.status_pagamento,
	carrelli.importo_pagamento,
	from_unixtime( carrelli.timestamp_evasione, '%Y-%m-%d %H:%i' ) AS data_ora_evasione,
    carrelli.utm_id,
    carrelli.utm_source,
    carrelli.utm_medium,
    carrelli.utm_campaign,
    carrelli.utm_term,
    carrelli.utm_content,
	carrelli.id_campagna,
	carrelli.spam_score,
	carrelli.spam_check,
    carrelli.id_reseller,
    carrelli.id_affiliato,
	carrelli.id_affiliazione,
	carrelli.id_account_evasione,
	carrelli.timestamp_evasione,
	carrelli.id_account_inserimento,
	carrelli.timestamp_inserimento,
	carrelli.id_account_aggiornamento,
	carrelli.timestamp_aggiornamento,
	carrelli.id AS __label__
FROM carrelli;

-- | 202610022840

-- carrelli_articoli_view
-- tipologia: tabella gestita
-- verifica: 2022-07-12 14:45 Chiara GDL
CREATE OR REPLACE VIEW `carrelli_articoli_view` AS
	SELECT
		carrelli_articoli.id,
		carrelli_articoli.id_carrello,
		carrelli_articoli.id_articolo,
		carrelli_articoli.id_iva,
		carrelli_articoli.id_pagamento,
		carrelli_articoli.destinatario_nome,
		carrelli_articoli.destinatario_cognome,
		carrelli_articoli.destinatario_denominazione,
		carrelli_articoli.destinatario_id_tipologia_anagrafica,
		carrelli_articoli.destinatario_id_anagrafica,
		carrelli_articoli.destinatario_id_account,
		carrelli_articoli.destinatario_indirizzo,
		carrelli_articoli.destinatario_cap,
		carrelli_articoli.destinatario_citta,
		carrelli_articoli.destinatario_id_comune,
		carrelli_articoli.destinatario_id_provincia,
		carrelli_articoli.destinatario_id_stato,
		carrelli_articoli.destinatario_id_comune_nascita,
		carrelli_articoli.destinatario_giorno_nascita,
		carrelli_articoli.destinatario_mese_nascita,
		carrelli_articoli.destinatario_anno_nascita,
		carrelli_articoli.destinatario_id_provincia_nascita,
		carrelli_articoli.destinatario_id_stato_nascita,
		carrelli_articoli.destinatario_telefono,
		carrelli_articoli.destinatario_mobile,
		carrelli_articoli.destinatario_fax,
		carrelli_articoli.destinatario_mail,
		carrelli_articoli.destinatario_codice_fiscale,
		carrelli_articoli.destinatario_partita_iva,
		carrelli_articoli.prezzo_netto_unitario,
		carrelli_articoli.prezzo_lordo_unitario,
		carrelli_articoli.quantita,
		carrelli_articoli.prezzo_netto_totale,
		carrelli_articoli.prezzo_lordo_totale,
		carrelli_articoli.sconto_percentuale,
		carrelli_articoli.sconto_valore,
		carrelli_articoli.prezzo_netto_finale,
		carrelli_articoli.prezzo_lordo_finale,
		carrelli_articoli.id_account_inserimento,
		carrelli_articoli.id_account_aggiornamento,
		concat_ws(
			' / ',
			carrelli_articoli.id_carrello,
			carrelli_articoli.id_articolo
		) AS __label__
	FROM carrelli_articoli;

-- | 202610022841

-- carrelli_documenti_view
-- tipologia: tabella gestita
-- verifica: 2022-08-22 11:45 Chiara GDL
CREATE OR REPLACE VIEW carrelli_documenti_view AS
	SELECT
		carrelli_documenti.id,
		carrelli_documenti.id_carrello,
		carrelli_documenti.id_documento,
		carrelli_documenti.id_account_inserimento,
		carrelli_documenti.id_account_aggiornamento,
		concat_ws(
			' / ',
			carrelli_documenti.id_carrello,
			carrelli_documenti.id_documento
		) AS __label__
	FROM carrelli_documenti
;

-- | 202610022842

-- categorie_progetti_view
-- tipologia: tabella assistita
-- verifica: 2021-06-01 20:02 Fabio Mosti
CREATE OR REPLACE VIEW categorie_progetti_view AS
	SELECT
		categorie_progetti.id,
		categorie_progetti.id_genitore,
		categorie_progetti.ordine,
		categorie_progetti.nome,
		categorie_progetti.template,
		categorie_progetti.schema_html,
		categorie_progetti.tema_css,
		categorie_progetti.se_sitemap,
		categorie_progetti.se_cacheable,
		categorie_progetti.id_sito,
		categorie_progetti.id_pagina,
		categorie_progetti.se_straordinario,
		categorie_progetti.se_ordinario,
		categorie_progetti.se_disciplina,
		categorie_progetti.se_classe,
		categorie_progetti.se_fascia,
		count( c1.id ) AS figli,
		count( progetti_categorie.id ) AS membri,
		categorie_progetti.id_account_inserimento,
		categorie_progetti.id_account_aggiornamento,
		categorie_progetti_path( categorie_progetti.id ) AS __label__
	FROM categorie_progetti
		LEFT JOIN categorie_progetti AS c1 ON c1.id_genitore = categorie_progetti.id
		LEFT JOIN progetti_categorie ON progetti_categorie.id_categoria = categorie_progetti.id
	GROUP BY categorie_progetti.id
;

-- | 202610022843

-- continenti_view
-- tipologia: tabella di supporto
CREATE OR REPLACE VIEW continenti_view AS
	SELECT
		continenti.id,
		continenti.codice,
		continenti.nome,
		continenti.nome AS __label__
	FROM continenti
;

-- | 202610022844

-- contratti_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
CREATE OR REPLACE VIEW `contratti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.codice,
		contratti.codice_affiliazione,
		contratti.id_immobile,
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
		) AS immobile,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.id_categoria_progetti,
		categorie_progetti_path( contratti.id_categoria_progetti ) AS categoria_progetti,
		contratti.id_badge,
		badge.codice AS badge,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
        coalesce( min(rinnovi.data_inizio), '-' ) AS data_inizio,
        coalesce( max(rinnovi.data_fine), '-' ) AS data_fine,
		group_concat( DISTINCT coalesce( proponente.denominazione , concat( proponente.cognome, ' ', proponente.nome ) )  SEPARATOR ', ' ) AS proponenti,
		group_concat( DISTINCT contraente.id SEPARATOR ', ' ) AS id_contraenti,
		group_concat( DISTINCT contraente.codice  SEPARATOR ', ' ) AS codici_contraenti,
		group_concat( DISTINCT coalesce( contraente.denominazione , concat( contraente.cognome, ' ', contraente.nome ) )  SEPARATOR ', ' ) AS contraenti,
		group_concat( DISTINCT licenze.codice SEPARATOR ', ' ) AS licenze,
		max( licenze.postazioni ) AS postazioni,
		group_concat( DISTINCT tipologie_licenze.nome SEPARATOR ', ' ) AS tipologia_licenza,
		group_concat( DISTINCT concat_ws( ' ', licenze.codice, tipologie_licenze.nome, licenze.nome ) SEPARATOR ' | ' ) AS dettagli_licenze,
		concat_ws( 
			' ', 
			tipologie_contratti.nome, 
			contratti.nome, 
			progetti.nome,
			concat( 'dal ', coalesce( date_format( min(rinnovi.data_inizio), '%d/%m/%Y' ), '-' ) ),
			concat( 'al ', coalesce( date_format( max(rinnovi.data_fine), '%d/%m/%Y' ), '-' ) ),
			group_concat( 
				DISTINCT coalesce( contraente.denominazione , concat( contraente.cognome, ' ', contraente.nome ), NULL )  SEPARATOR ', ' 
			) 
		) AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN badge ON badge.id = contratti.id_badge
		LEFT JOIN immobili ON immobili.id = contratti.id_immobile
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN zone_indirizzi ON zone_indirizzi.id_indirizzo = indirizzi.id 
		LEFT JOIN zone ON zone.id = zone_indirizzi.id_zona
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN ruoli_anagrafica AS ruoli_proponenti ON ruoli_proponenti.se_proponente IS NOT NULL
		LEFT JOIN contratti_anagrafica AS proponenti ON proponenti.id_contratto = contratti.id AND proponenti.id_ruolo = ruoli_proponenti.id
		LEFT JOIN anagrafica AS proponente ON proponente.id = proponenti.id_anagrafica 
		LEFT JOIN ruoli_anagrafica AS ruoli_contraenti ON ruoli_contraenti.se_contraente IS NOT NULL
		LEFT JOIN contratti_anagrafica AS contraenti ON contraenti.id_contratto = contratti.id AND contraenti.id_ruolo = ruoli_contraenti.id
		LEFT JOIN anagrafica AS contraente ON contraente.id = contraenti.id_anagrafica
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
		LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza
		LEFT JOIN tipologie_licenze ON tipologie_licenze.id = licenze.id_tipologia
	GROUP BY contratti.id, licenze.codice
;

-- | 202610022845

-- contratti_anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
CREATE OR REPLACE VIEW contratti_anagrafica_view AS 
	SELECT 
		contratti_anagrafica.id,
		contratti_anagrafica.id_contratto,
		contratti.codice,
		contratti_anagrafica.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		contratti_anagrafica.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		contratti_anagrafica.ordine,
		contratti_anagrafica.id_account_inserimento ,
		contratti_anagrafica.id_account_aggiornamento ,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		ruoli_anagrafica.se_proponente,
		ruoli_anagrafica.se_contraente,
		tipologie_contratti.id AS id_tipologia,
		tipologie_contratti.nome AS tipologia,
		contratti.nome,
		contratti.id_progetto,
		progetti.nome AS progetto,
		min( rinnovi.data_inizio ) AS data_inizio,
		max( rinnovi.data_fine ) AS data_fine,
		concat( 'contratto ', contratti.nome, ' - ', coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ), ' ruolo ', ruoli_anagrafica.nome  ) AS __label__
	FROM contratti_anagrafica
		LEFT JOIN contratti ON contratti.id = contratti_anagrafica.id_contratto
		LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = contratti_anagrafica.id_ruolo
		LEFT JOIN anagrafica ON anagrafica.id = contratti_anagrafica.id_anagrafica
		LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
		LEFT JOIN progetti ON progetti.id = contratti.id_progetto
	GROUP BY contratti.id, anagrafica.id
;

-- | 202610022846

-- corrispondenza_view
CREATE OR REPLACE VIEW corrispondenza_view AS 
	SELECT 
		corrispondenza.id,
		corrispondenza.id_distinta,
		corrispondenza.id_tipologia,
		tipologie_corrispondenza_path( corrispondenza.id_tipologia ) AS tipologia,
		corrispondenza.id_peso,
		pesi_tipologie_corrispondenza.nome AS peso_tipologia,
		tipologie_corrispondenza.se_pesata,
		corrispondenza.peso,
		corrispondenza.id_formato,
		corrispondenza.quantita,
		corrispondenza.id_mittente,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS mittente,
		corrispondenza.id_organizzazione_mittente,
		organizzazioni_path( corrispondenza.id_organizzazione_mittente ) AS organizzazione_mittente,
		corrispondenza.id_commesso,
		coalesce( commessi.denominazione , concat( commessi.cognome, ' ', commessi.nome ), '' ) AS commesso,
		corrispondenza.nome,
		coalesce( corrispondenza.destinatario_denominazione , concat( corrispondenza.destinatario_cognome, ' ', corrispondenza.destinatario_nome ), '' ) AS destinatario,
		coalesce(
			concat( corrispondenza.destinatario_indirizzo, ' ', corrispondenza.destinatario_civico, ', ', corrispondenza.destinatario_cap, ' ', coalesce( corrispondenza.destinatario_citta, '' ), comuni.nome, ' ', provincie.sigla ),
			concat( comuni.nome, ' ', provincie.sigla ),
			concat_ws( ' ', corrispondenza.destinatario_cap, stati.nome ),
			''
		) AS destinazione,
		corrispondenza.timestamp_elaborazione,
		corrispondenza.timestamp_gestione,
		corrispondenza.id_account_inserimento,
		corrispondenza.timestamp_inserimento,
		corrispondenza.id_account_aggiornamento,
		corrispondenza.timestamp_aggiornamento,
		concat_ws(
            ' ',
            'da',
            coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
            concat( '(', organizzazioni_path( corrispondenza.id_organizzazione_mittente ), ')' ),
            tipologie_corrispondenza_path( corrispondenza.id_tipologia ),
            'per',
            coalesce( corrispondenza.destinatario_denominazione , concat( corrispondenza.destinatario_cognome, ' ', corrispondenza.destinatario_nome ), '' )
        ) AS __label__
	FROM corrispondenza
        INNER JOIN tipologie_corrispondenza ON tipologie_corrispondenza.id = corrispondenza.id_tipologia
		LEFT JOIN pesi_tipologie_corrispondenza ON pesi_tipologie_corrispondenza.id = corrispondenza.id_peso
		LEFT JOIN anagrafica ON anagrafica.id = corrispondenza.id_mittente
		LEFT JOIN anagrafica AS commessi ON anagrafica.id = corrispondenza.id_commesso
		LEFT JOIN comuni ON comuni.id = corrispondenza.destinatario_id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN stati ON stati.id = corrispondenza.destinatario_id_stato
    WHERE tipologie_corrispondenza.se_corrispondenza = 1
	GROUP BY corrispondenza.id
;

-- | 202610022847

-- distinta_view
CREATE OR REPLACE VIEW `distinta_view` AS
	SELECT
		distinta.id,
		distinta.id_articolo,
		concat_ws( ' ', p1.nome, a1.nome ) AS articolo,
		distinta.id_componente,
		concat_ws( ' ', p2.nome, a2.nome ) AS componente,
		distinta.quantita,
		distinta.id_account_inserimento,
		distinta.id_account_aggiornamento,
		concat_ws(
			' / ',
			concat_ws( ' ', p1.nome, a1.nome ),
			concat_ws( ' ', p2.nome, a2.nome )
		) AS __label__
	FROM distinta
		LEFT JOIN articoli AS a1 ON a1.id = distinta.id_articolo
		LEFT JOIN prodotti AS p1 ON p1.id = a1.id_prodotto
		LEFT JOIN articoli AS a2 ON a2.id = distinta.id_componente
		LEFT JOIN prodotti AS p2 ON p2.id = a2.id_prodotto
;

-- | 202610022848

-- immobili_anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2022-04-28 12:20 Chiara GDL
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

-- | 202610022849

-- indirizzi_view
-- tipologia: tabella gestita
-- verifica: 2021-09-23 16:08 Fabio Mosti
CREATE OR REPLACE VIEW indirizzi_view AS
	SELECT
		indirizzi.id,
		indirizzi.id_tipologia,
		tipologie_indirizzi.nome AS tipologia,
		indirizzi.id_comune,
		comuni.nome AS comune,
		comuni.id_provincia,
		provincie.nome AS provincia,
		provincie.id_regione,
		regioni.nome AS regione,
		regioni.id_stato,
		stati.nome AS stato,
		indirizzi.localita,
		indirizzi.indirizzo,
		indirizzi.civico,
		indirizzi.cap,
		indirizzi.latitudine,
		indirizzi.longitudine,
		indirizzi.token,
		indirizzi.timestamp_geolocalizzazione,
		indirizzi.id_account_inserimento,
		indirizzi.id_account_aggiornamento,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM indirizzi
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

-- | 202610022850

-- istruzioni_view
CREATE OR REPLACE VIEW `istruzioni_view` AS
	SELECT
		istruzioni.id,
		istruzioni.id_tipologia,
		istruzioni.id_prodotto,
		prodotti.nome AS prodotto,
		istruzioni.id_articolo,
		articoli.nome AS articolo,
		istruzioni.nome,
		istruzioni.id_account_inserimento,
		istruzioni.id_account_aggiornamento,
		concat_ws(
			' / ',
			coalesce( prodotti.nome, articoli.nome ),
			istruzioni.nome
		) AS __label__
	FROM istruzioni
		LEFT JOIN prodotti ON prodotti.id = istruzioni.id_prodotto
		LEFT JOIN articoli ON articoli.id = istruzioni.id_articolo
;

-- | 202610022851

-- job_view
-- tipologia: tabella gestita
-- verifica: 2021-09-24 17:19 Fabio Mosti
CREATE OR REPLACE VIEW job_view AS
	SELECT
		job.id,
		job.nome,
		job.job,
		job.totale,
		job.corrente,
		job.iterazioni,
		job.delay,
		job.token,
		job.se_foreground,
		job.timestamp_apertura,
        -- concat( ( ( unix_timestamp() - job.timestamp_apertura ) / job.corrente ), 's' ) AS velocita,
        -- from_unixtime( ceil( unix_timestamp() + ( ( ( unix_timestamp() - job.timestamp_apertura ) / job.corrente ) * ( job.totale - job.corrente ) ) ), '%Y-%m-%d %H:%i' ) AS proiezione,
        concat( ( ( coalesce( job.timestamp_esecuzione, unix_timestamp() ) - job.timestamp_apertura ) / job.corrente ), 's' ) AS velocita,
        from_unixtime( ceil( coalesce( job.timestamp_esecuzione, unix_timestamp() ) + ( ( ( coalesce( job.timestamp_esecuzione, unix_timestamp() ) - job.timestamp_apertura ) / job.corrente ) * ( job.totale - job.corrente ) ) ), '%Y-%m-%d %H:%i' ) AS proiezione,
		from_unixtime( job.timestamp_apertura, '%Y-%m-%d %H:%i' ) AS data_ora_apertura,
		job.timestamp_esecuzione,
		from_unixtime( job.timestamp_esecuzione, '%Y-%m-%d %H:%i' ) AS data_ora_esecuzione,
		job.timestamp_completamento,
		from_unixtime( job.timestamp_completamento, '%Y-%m-%d %H:%i' ) AS data_ora_completamento,
		job.id_account_inserimento,
		job.id_account_aggiornamento,
		job.nome AS __label__
	FROM job
;

-- | 202610022852

-- licenze_view
-- tipologia: tabella gestita
-- verifica: 2021-11-15 12:44 Chiara GDL
-- TODO i dati sul contratto vanno recuperati in maniera più precisa
-- NOTA il campo id_anagrafica nelle licenze è lì perché la licenza potrebbe avere un intestatario diverso dal contratto
CREATE OR REPLACE VIEW licenze_view AS
	SELECT
		licenze.id,                         
    	licenze.id_tipologia,                
		tipologie_licenze.nome AS tipologia,               
		licenze.id_anagrafica,
		group_concat( DISTINCT coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) ) AS anagrafica,
		licenze.id_rivenditore,              
		group_concat( DISTINCT coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) ) AS rivenditore,
		licenze.codice,                      
		licenze.postazioni,                  
		licenze.nome,                        
		licenze.note,                        
		licenze.testo,                       
		licenze.giorni_validita,             
		licenze.giorni_rinnovo,
		min( rinnovi.data_inizio ) AS data_inizio,
		max( rinnovi.data_fine ) AS data_fine,
		max( rinnovi.id_contratto ) AS id_contratto,
		group_concat( DISTINCT tipologie_contratti.nome SEPARATOR ', ' ) AS tipologia_contratto,
		group_concat( DISTINCT concat_ws( '§', software.codice, software.nome ) SEPARATOR ' | ' ) AS software,
		licenze.timestamp_distribuzione,     
		licenze.timestamp_inizio,            
		licenze.timestamp_fine,              
		licenze.id_account_inserimento,      
		licenze.id_account_aggiornamento,    
		licenze.nome AS __label__
	FROM licenze
		LEFT JOIN tipologie_licenze ON tipologie_licenze.id = licenze.id_tipologia
		LEFT JOIN rinnovi ON rinnovi.id_licenza = licenze.id
		LEFT JOIN licenze_software ON licenze_software.id_licenza = licenze.id
		LEFT JOIN software ON software.id = licenze_software.id_software
		LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto
		LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON ( contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo IN ( 32 ) )
		LEFT JOIN anagrafica AS a1 ON a1.id = coalesce( licenze.id_anagrafica, contratti_anagrafica.id_anagrafica )
		LEFT JOIN anagrafica AS a2 ON a2.id = licenze.id_rivenditore
	GROUP BY licenze.id
;

-- | 202610022853

-- mail_status_view
CREATE OR REPLACE VIEW `mail_status_view` AS
	SELECT
		mail_status.id,
		mail_status.indirizzo,
		mail_status.dominio,
		mail_status.id_tipologia,
		tipologie_mail_status.nome AS tipologia,
		mail_status.stato,
		mail_status.motivo,
		mail_status.punteggio,
		mail_status.se_accept_all,
		mail_status.se_ruolo,
		mail_status.se_temporanea,
		mail_status.se_gratuita,
		mail_status.tentativi,
		mail_status.id_account_inserimento,
		mail_status.id_account_aggiornamento,
		concat_ws(
			' ',
			mail_status.indirizzo,
			tipologie_mail_status.nome
		) AS __label__
	FROM mail_status
		LEFT JOIN tipologie_mail_status ON tipologie_mail_status.id = mail_status.id_tipologia
;

-- | 202610022854

-- mastri_view
-- tipologia: tabella gestita
-- verifica: 2021-09-29 11:43 Fabio Mosti
CREATE OR REPLACE VIEW `mastri_view` AS
	SELECT
		mastri.id,
		mastri.id_tipologia,
		tipologie_mastri.nome AS tipologia,
        mastri.codice,
		mastri.id_anagrafica_indirizzi,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzi.indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		coalesce( mastri.id_anagrafica, anagrafica_indirizzi.id_anagrafica ) AS id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS anagrafica,
		mastri.id_account,
		account.username AS account,
		mastri.id_progetto,
		progetti.nome AS progetto,
		mastri.nome,
		tipologie_mastri.se_magazzino,
		tipologie_mastri.se_conto,
		tipologie_mastri.se_registro,
		concat_ws( ' ', mastri.codice, mastri_path( mastri.id ) ) AS __label__
	FROM mastri
		LEFT JOIN tipologie_mastri ON tipologie_mastri.id = mastri.id_tipologia
		LEFT JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id = mastri.id_anagrafica_indirizzi
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_indirizzi.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = mastri.id_anagrafica
		LEFT JOIN account ON account.id = mastri.id_account
		LEFT JOIN progetti ON progetti.id = mastri.id_progetto
		LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

-- | 202610022855

-- mastri_articoli_view
CREATE OR REPLACE VIEW `mastri_articoli_view` AS
	SELECT
		mastri_articoli.id,
		mastri_articoli.ordine,
		mastri_articoli.codice,
		mastri_articoli.id_mastro,
		mastri_path( mastri_articoli.id_mastro ) AS mastro,
		mastri_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		mastri_articoli.scorta_minima,
		mastri_articoli.scorta_massima,
		mastri_articoli.id_udm,
		udm.sigla AS udm,
		mastri_articoli.id_account_inserimento,
		mastri_articoli.id_account_aggiornamento,
		concat_ws(
			' / ',
			mastri_path( mastri_articoli.id_mastro ),
			concat_ws( ' ', prodotti.nome, articoli.nome )
		) AS __label__
	FROM mastri_articoli
		LEFT JOIN articoli ON articoli.id = mastri_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN udm ON udm.id = mastri_articoli.id_udm
;

-- | 202610022856

-- matricole_view
-- tipologia: tabella gestita
-- verifica: 2021-12-28 16:20 Chiara GDL
CREATE OR REPLACE VIEW `matricole_view` AS
	SELECT
		matricole.id,
		matricole.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		matricole.id_marchio,
		marchi.nome AS marchio,
		matricole.id_articolo,
		concat_ws(
			' ',
			articoli.id,
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
		matricole.matricola,
		matricole.data_scadenza,
		matricole.nome,
		concat_ws(
			' ',
			matricole.matricola,
			'/',
			articoli.id,
			'/',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			),
			concat( 'scad. ', matricole.data_scadenza )
		) AS __label__
	FROM matricole
		LEFT JOIN anagrafica AS a1 ON a1.id = matricole.id_produttore
		LEFT JOIN marchi ON marchi.id = matricole.id_marchio
		LEFT JOIN articoli ON articoli.id = id_articolo
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

-- | 202610022857

-- metadati_articoli_view
CREATE OR REPLACE VIEW `metadati_articoli_view` AS
	SELECT
		metadati_articoli.id,
		metadati_articoli.id_lingua,
		lingue.nome AS lingua,
		metadati_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		metadati_articoli.nome,
		metadati_articoli.id_account_inserimento,
		metadati_articoli.id_account_aggiornamento,
		concat_ws(
			' / ',
			concat_ws( ' ', prodotti.nome, articoli.nome ),
			metadati_articoli.nome
		) AS __label__
	FROM metadati_articoli
		LEFT JOIN lingue ON lingue.id = metadati_articoli.id_lingua
		LEFT JOIN articoli ON articoli.id = metadati_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

-- | 202610022858

-- metadati_prodotti_view
CREATE OR REPLACE VIEW `metadati_prodotti_view` AS
	SELECT
		metadati_prodotti.id,
		metadati_prodotti.id_lingua,
		lingue.nome AS lingua,
		metadati_prodotti.id_prodotto,
		prodotti.nome AS prodotto,
		metadati_prodotti.nome,
		metadati_prodotti.id_account_inserimento,
		metadati_prodotti.id_account_aggiornamento,
		concat_ws(
			' / ',
			prodotti.nome,
			metadati_prodotti.nome
		) AS __label__
	FROM metadati_prodotti
		LEFT JOIN lingue ON lingue.id = metadati_prodotti.id_lingua
		LEFT JOIN prodotti ON prodotti.id = metadati_prodotti.id_prodotto
;

-- | 202610022859

-- organizzazioni_view
-- tipologia: tabella gestita
-- verifica: 2021-10-01 13:10 Fabio Mosti
CREATE OR REPLACE VIEW `organizzazioni_view` AS
	SELECT
		organizzazioni.id,
		organizzazioni.id_genitore,
		organizzazioni.ordine,
		organizzazioni.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		organizzazioni.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		organizzazioni.id_account_inserimento,
		organizzazioni.id_account_aggiornamento,
		concat_ws(
			' ',
			organizzazioni_path( organizzazioni.id ),
			ruoli_anagrafica.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM organizzazioni
		LEFT JOIN anagrafica AS a1 ON a1.id = organizzazioni.id_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = organizzazioni.id_ruolo
;

-- | 202610022860

-- prodotti_caratteristiche_view
-- tipologia: tabella gestita
-- verifica: 2021-10-04 19:40 Fabio Mosti
CREATE OR REPLACE VIEW `prodotti_caratteristiche_view` AS
	SELECT
		prodotti_caratteristiche.id,
		prodotti_caratteristiche.id_prodotto,
		prodotti_caratteristiche.id_caratteristica,
		prodotti_caratteristiche.id_lingua,
		caratteristiche.nome AS caratteristica,
		prodotti_caratteristiche.valore AS valore,
		prodotti_caratteristiche.ordine,
		prodotti_caratteristiche.id_account_inserimento,
		prodotti_caratteristiche.id_account_aggiornamento,
		concat(
			prodotti_caratteristiche.id_prodotto,
			' / ',
			caratteristiche.nome
		) AS __label__
	FROM prodotti_caratteristiche
		LEFT JOIN caratteristiche ON caratteristiche.id = prodotti_caratteristiche.id_caratteristica
;

-- | 202610022861

-- progetti_categorie_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:07 Fabio Mosti
CREATE OR REPLACE VIEW progetti_categorie_view AS
	SELECT
		progetti_categorie.id,
		progetti_categorie.id_progetto,
		progetti.nome AS progetto,
		progetti_categorie.id_categoria,
		categorie_progetti_path( progetti_categorie.id_categoria ) AS categoria,
		progetti_categorie.ordine,
		progetti_categorie.id_account_inserimento,
		progetti_categorie.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			categorie_progetti_path( progetti_categorie.id_categoria )
		) AS __label__
	FROM progetti_categorie
		LEFT JOIN progetti ON progetti.id = progetti_categorie.id_progetto
;

-- | 202610022862

CREATE OR REPLACE VIEW `recensioni_view` AS
    SELECT
		recensioni.id,
		recensioni.id_lingua,
		recensioni.id_prodotto,
		recensioni.id_articolo,
		recensioni.id_risorsa,
		recensioni.id_pagina,
		recensioni.data,
		recensioni.autore,
		recensioni.valutazione,
		recensioni.titolo,
		recensioni.se_approvata,
		recensioni.id_account_inserimento,
		recensioni.id_account_aggiornamento,
		concat_ws(
			' / ',
			recensioni.autore,
			recensioni.titolo
		) AS __label__
	FROM recensioni
;

-- | 202610022863

-- redirect_azioni_view
CREATE OR REPLACE VIEW `redirect_azioni_view` AS
	SELECT
		redirect_azioni.id,
		redirect_azioni.id_redirect,
		redirect.sorgente AS redirect,
		redirect_azioni.referral,
		redirect_azioni.azione,
		redirect_azioni.id_account_inserimento,
		redirect_azioni.id_account_aggiornamento,
		concat_ws(
			' ',
			redirect.sorgente,
			redirect_azioni.azione
		) AS __label__
	FROM redirect_azioni
		LEFT JOIN redirect ON redirect.id = redirect_azioni.id_redirect
;

-- | 202610022864

-- regioni_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 15:40 Fabio Mosti
CREATE OR REPLACE VIEW regioni_view AS
	SELECT
		regioni.id,
		regioni.id_stato,
		stati.nome AS stato,
		regioni.nome,
		regioni.codice_istat,
		concat_ws(
			' ',
			regioni.nome,
			stati.nome
		) AS __label__
	FROM regioni
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

-- | 202610022865

-- rinnovi_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 12:59 Chiara GDL
CREATE OR REPLACE VIEW `rinnovi_view` AS
	SELECT
		rinnovi.id,
		rinnovi.id_tipologia,
		tipologie_rinnovi.nome AS tipologia,
		rinnovi.id_contratto,
		contratti.nome AS contratto,
		rinnovi.id_licenza,
		licenze.nome AS licenza,
		licenze.codice AS codice_licenza,
		rinnovi.id_progetto,
		progetti.nome AS progetto,
		rinnovi.id_categoria_progetti,
		categorie_progetti_path( rinnovi.id_categoria_progetti ) AS categoria_progetti,
		rinnovi.data_inizio,
		rinnovi.data_fine,
		rinnovi.codice,
		rinnovi.id_pianificazione,
		rinnovi.id_account_inserimento,
		rinnovi.id_account_aggiornamento,
		concat_ws(
			' ',
			'rinnovo',
			rinnovi.id,
			progetti.nome,
			'dal',
			rinnovi.data_inizio,
			'al',
			rinnovi.data_fine,
			coalesce( 
				anagrafica.denominazione,
				concat( anagrafica.cognome, ' ', anagrafica.nome )
			)
		) AS __label__
	FROM rinnovi
		LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = rinnovi.id_tipologia
		LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto 
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 29
		LEFT JOIN anagrafica ON anagrafica.id = contratti_anagrafica.id_anagrafica
		LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza 
		LEFT JOIN progetti ON progetti.id = coalesce( rinnovi.id_progetto, contratti.id_progetto )
	GROUP BY rinnovi.id
	;

-- | 202610022866

-- ruoli_mail_view
CREATE OR REPLACE VIEW `ruoli_mail_view` AS
	SELECT
		ruoli_mail.id,
		ruoli_mail.id_genitore,
		ruoli_mail.nome,
		ruoli_mail.html_entity,
		ruoli_mail.font_awesome,
		ruoli_mail.se_xml,
		ruoli_mail.se_commerciale,
		ruoli_mail.se_produzione,
		ruoli_mail.se_amministrazione,
		ruoli_mail.se_acquisti,
		ruoli_mail.se_ordini,
		ruoli_mail.se_helpdesk,
		ruoli_mail.id_account_inserimento,
		ruoli_mail.id_account_aggiornamento,
		ruoli_mail_path( ruoli_mail.id ) AS __label__
	FROM ruoli_mail
;

-- | 202610022867

-- step_view
CREATE OR REPLACE VIEW step_view AS
	SELECT
		step.id,
		step.id_funnel,
		step.ordine,
		step.nome,
		step.id_account_inserimento,
		step.id_account_aggiornamento,
		concat_ws(
			' / ',
			step.nome
		) AS __label__
	FROM step
	ORDER BY step.id_funnel, step.ordine
;

-- | 202610022868

-- task_view
-- tipologia: tabella assistita
-- verifica: 2021-06-30 11:57 Fabio Mosti
CREATE OR REPLACE VIEW task_view AS
	SELECT
		task.id,
		task.minuto,
		task.ora,
		task.giorno_del_mese,
		task.mese,
		task.giorno_della_settimana,
		task.settimana,
		task.task,
		task.iterazioni,
		task.delay,
		task.token,
		task.timestamp_esecuzione,
		from_unixtime( task.timestamp_esecuzione, '%Y-%m-%d %H:%i' ) AS data_ora_esecuzione,
		task.id_account_inserimento,
		task.id_account_aggiornamento,
		CONCAT(
			' / ',
			coalesce( task.minuto, '*' ),
			' / ',
			coalesce( task.ora, '*' ),
			' / ',
			coalesce( task.giorno_del_mese, '*' ),
			' / ',
			coalesce( task.mese, '*' ),
			' / ',
			coalesce( task.giorno_della_settimana, '*' ),
			' / ',
			coalesce( task.settimana, '*' ),
			' / ',
			task.task
		) AS __label__
	FROM task
;

-- | 202610022869

-- tipologie_annunci_view
CREATE OR REPLACE VIEW `tipologie_annunci_view` AS
	SELECT
		tipologie_annunci.id,
		tipologie_annunci.id_genitore,
		tipologie_annunci.ordine,
		tipologie_annunci.nome,
		tipologie_annunci.sigla,
		tipologie_annunci.html_entity,
		tipologie_annunci.font_awesome,
		tipologie_annunci.id_account_inserimento,
		tipologie_annunci.id_account_aggiornamento,
		tipologie_annunci_path( tipologie_annunci.id ) AS __label__
	FROM tipologie_annunci
;

-- | 202610022870

-- tipologie_contratti_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:47 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_contratti_view` AS
	SELECT
		tipologie_contratti.id,
		tipologie_contratti.id_genitore,
		tipologie_contratti.ordine,
		tipologie_contratti.nome,
		tipologie_contratti.id_prodotto,
		tipologie_contratti.id_progetto,
		tipologie_contratti.id_categoria_progetti,
		tipologie_contratti.html_entity,
		tipologie_contratti.font_awesome,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		tipologie_contratti.se_libero,
		tipologie_contratti.se_prenotazione,
		tipologie_contratti.se_scalare,
		tipologie_contratti.se_affiliazione,
		tipologie_contratti.se_online,
		tipologie_contratti.id_account_inserimento,
		tipologie_contratti.id_account_aggiornamento,
		tipologie_contratti_path( tipologie_contratti.id ) AS __label__
	FROM tipologie_contratti
;

-- | 202610022871

-- tipologie_corrispondenza_view
CREATE OR REPLACE VIEW `tipologie_corrispondenza_view` AS
	SELECT
		tipologie_corrispondenza.id,
		tipologie_corrispondenza.id_genitore,
		tipologie_corrispondenza.nome,
		tipologie_corrispondenza.se_massivo,
		tipologie_corrispondenza.se_corrispondenza,
		tipologie_corrispondenza.se_atto,
		tipologie_corrispondenza.se_ricevuta_ritorno,
		tipologie_corrispondenza.id_account_inserimento,
		tipologie_corrispondenza.id_account_aggiornamento,
		tipologie_corrispondenza_path( tipologie_corrispondenza.id ) AS __label__
	FROM tipologie_corrispondenza
;

-- | 202610022872

-- tipologie_mail_status_view
CREATE OR REPLACE VIEW `tipologie_mail_status_view` AS
	SELECT
		tipologie_mail_status.id,
		tipologie_mail_status.ordine,
		tipologie_mail_status.codice,
		tipologie_mail_status.nome,
		tipologie_mail_status.se_recapitabile,
		tipologie_mail_status.se_sistema,
		tipologie_mail_status.id_account_inserimento,
		tipologie_mail_status.id_account_aggiornamento,
		tipologie_mail_status.nome AS __label__
	FROM tipologie_mail_status
;

-- | 202610022873

-- tipologie_pagamenti_view
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_pagamenti_view` AS
	SELECT
		tipologie_pagamenti.id,
		tipologie_pagamenti.id_genitore,
		tipologie_pagamenti.ordine,
		tipologie_pagamenti.nome,
		tipologie_pagamenti.html_entity,
		tipologie_pagamenti.font_awesome,
		tipologie_pagamenti.id_account_inserimento,
		tipologie_pagamenti.id_account_aggiornamento,
		tipologie_pagamenti_path( tipologie_pagamenti.id ) AS __label__
	FROM tipologie_pagamenti
;

-- | 202610022874

-- tipologie_rinnovi_view
-- tipologia: tabella di supporto
-- verifica: 2022-04-29 17:45 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_rinnovi_view` AS
	SELECT
		tipologie_rinnovi.id,
		tipologie_rinnovi.id_genitore,
		tipologie_rinnovi.ordine,
		tipologie_rinnovi.nome,
		tipologie_rinnovi.html_entity,
		tipologie_rinnovi.font_awesome,
		tipologie_rinnovi.se_tesseramenti, 
		tipologie_rinnovi.se_iscrizioni, 
		tipologie_rinnovi.se_abbonamenti,
		tipologie_rinnovi.se_licenze, 
		tipologie_rinnovi.se_contratti,
		tipologie_rinnovi.se_progetti,
		tipologie_rinnovi.id_account_inserimento,
		tipologie_rinnovi.id_account_aggiornamento,
		tipologie_rinnovi_path( tipologie_rinnovi.id ) AS __label__
	FROM tipologie_rinnovi
;

-- | 202610022875

-- tipologie_todo_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:12 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_todo_view` AS
	SELECT
		tipologie_todo.id,
		tipologie_todo.id_genitore,
		tipologie_todo.ordine,
		tipologie_todo.nome,
		tipologie_todo.html_entity,
		tipologie_todo.font_awesome,
		tipologie_todo.se_agenda,
		tipologie_todo.se_ticket,
		tipologie_todo.se_commerciale,
		tipologie_todo.se_produzione,
		tipologie_todo.se_amministrazione,
		tipologie_todo.id_account_inserimento,
		tipologie_todo.id_account_aggiornamento,
		tipologie_todo_path( tipologie_todo.id ) AS __label__
	FROM tipologie_todo
;

-- | FINE FILE
