--
-- PATCH
--

--| 202204299000
alter table contratti drop key indice;

--| 202204299010
alter table contratti
ADD COLUMN `codice` char(32) DEFAULT NULL AFTER `id_immobile`,
ADD KEY  `codice` ( `codice` ),
ADD KEY `indice` ( `id_tipologia`, `id_emittente`, `id_destinatario`, `codice`, `nome`, `id_progetto`, `id_immobile`);

--| 202204299020
CREATE OR REPLACE VIEW `contratti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.id_immobile,
		immobili.nome AS immobile,
		contratti.codice,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
        MIN(rinnovi.data_inizio),
        MAX(rinnovi.data_fine),
		group_concat( DISTINCT concat( coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),': ', ruoli_anagrafica.nome ) SEPARATOR ' | ' ) AS parti,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN immobili ON immobili.id = contratti.id_immobile
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id
		LEFT JOIN anagrafica ON anagrafica.id = contratti_anagrafica.id_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = contratti_anagrafica.id_ruolo
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
	GROUP BY contratti.id, tipologie_contratti.nome
;

--| 202204299030
CREATE OR REPLACE VIEW `abbonamenti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio),
        MAX(rinnovi.data_fine),
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_abbonamento = 1
    GROUP BY contratti.id, tipologie_contratti.nome
;

--| 202204299040
CREATE OR REPLACE VIEW `abbonamenti_attivi_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MAX(rinnovi.data_inizio),
        MAX(rinnovi.data_fine),
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_abbonamento = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
    GROUP BY contratti.id
;

--| 202204299050
CREATE OR REPLACE VIEW `abbonamenti_archiviati_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio),
        MAX(rinnovi.data_fine),
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_abbonamento = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio >= CURRENT_DATE() ) AND  rinnovi.data_fine < CURRENT_DATE() 
    GROUP BY contratti.id
;

--| 202204299060
CREATE OR REPLACE VIEW `contratti_attivi_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MAX(rinnovi.data_inizio),
        MAX(rinnovi.data_fine),
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
    GROUP BY contratti.id
;

--| 202204299070
CREATE OR REPLACE VIEW `contratti_archiviati_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio),
        MAX(rinnovi.data_fine),
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio >= CURRENT_DATE() ) AND  rinnovi.data_fine < CURRENT_DATE() 
    GROUP BY contratti.id
;

--| 202204299080
CREATE OR REPLACE VIEW `iscrizioni_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio),
        MAX(rinnovi.data_fine),
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_iscrizione = 1
    GROUP BY contratti.id
;

--| 202204299090
CREATE OR REPLACE VIEW `iscrizioni_attivi_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MAX(rinnovi.data_inizio),
        MAX(rinnovi.data_fine),
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_iscrizione = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
    GROUP BY contratti.id
;

--| 202204299100
CREATE OR REPLACE VIEW `iscrizioni_archiviati_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio),
        MAX(rinnovi.data_fine),
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_iscrizione = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio >= CURRENT_DATE() ) AND  rinnovi.data_fine < CURRENT_DATE() 
    GROUP BY contratti.id
;

--| 202204299110
CREATE OR REPLACE VIEW `tesseramenti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio),
        MAX(rinnovi.data_fine),
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_tesseramento = 1
    GROUP BY contratti.id
;

--| 202204299120
CREATE OR REPLACE VIEW `tesseramenti_attivi_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MAX(rinnovi.data_inizio),
        MAX(rinnovi.data_fine),
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_tesseramento = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
    GROUP BY contratti.id
;

--| 202204299130
CREATE OR REPLACE VIEW `tesseramenti_archiviati_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        MIN(rinnovi.data_inizio),
        MAX(rinnovi.data_fine),
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_tesseramento = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio >= CURRENT_DATE() ) AND  rinnovi.data_fine < CURRENT_DATE() 
    GROUP BY contratti.id
;

--| 202204299140
CREATE TABLE IF NOT EXISTS `tipologie_rinnovi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_tesseramenti` int(1) DEFAULT NULL,
  `se_iscrizioni` int(1) DEFAULT NULL,
  `se_abbonamenti` int(1) DEFAULT NULL,
  `se_licenze` int(1) DEFAULT NULL,
  `se_contratti` int(1) DEFAULT NULL,
  `se_progetti` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204299150
ALTER TABLE `tipologie_rinnovi`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `se_tesseramenti` (`se_tesseramenti`),
  	ADD KEY `se_iscrizioni` (`se_iscrizioni`),
  	ADD KEY `se_abbonamenti` (`se_abbonamenti`),
  	ADD KEY `se_licenze` (`se_licenze`),
  	ADD KEY `se_contratti` (`se_contratti`),
  	ADD KEY `se_progetti`(`se_progetti`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`, `se_tesseramenti`,`se_iscrizioni`, `se_abbonamenti`, `se_licenze`, `se_contratti`, `se_progetti`);


--| 202204299160
ALTER TABLE `tipologie_rinnovi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204299170
INSERT INTO `tipologie_rinnovi` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_tesseramenti`, `se_iscrizioni`, `se_abbonamenti`, `se_licenze`, `se_contratti`, `se_progetti`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'ordinario',	NULL,	NULL,	1,	1,	1,	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'ridotto',	NULL,	NULL,	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);


--| 202204299180
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

--| 202204299190
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

--| 202204299200
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

--| 202204299220
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

--| 202204299230
alter table rinnovi drop key indice;

--| 202204299240
alter table rinnovi
	add COLUMN id_tipologia int(11) default null after id,
	ADD	KEY `id_tipologia` (`id_tipologia`),
   ADD CONSTRAINT `rinnovi_ibfk_04` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_rinnovi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202204299250
CREATE OR REPLACE VIEW `rinnovi_view` AS
	SELECT
		rinnovi.id,
		rinnovi.id_tipologia,
		tipologie_rinnovi.nome AS tipologia,
		rinnovi.id_contratto,
		contratti.nome AS contratto,
		rinnovi.id_licenza,
		licenze.nome AS licenza,
		rinnovi.id_progetto,
		progetti.nome AS progetto,
		rinnovi.data_inizio,
		rinnovi.data_fine,
		rinnovi.codice,
		rinnovi.id_account_inserimento,
		rinnovi.id_account_aggiornamento,
		concat('rinnovo ', rinnovi.id, ' dal ',CONCAT_WS('-',rinnovi.data_inizio),' al ',CONCAT_WS('-',rinnovi.data_fine)) AS __label__
	FROM rinnovi
		LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = rinnovi.id_tipologia
		LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto 
		LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza 
		LEFT JOIN progetti ON progetti.id = rinnovi.id_progetto
	;

--| FINE FILE