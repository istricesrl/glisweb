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

-- FINE