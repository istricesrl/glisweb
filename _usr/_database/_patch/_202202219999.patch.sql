--
-- PATCH
--

--| 202202210010
CREATE OR REPLACE VIEW __report_immagini_da_scalare__ AS
	SELECT immagini.* FROM immagini
	INNER JOIN ruoli_immagini ON ruoli_immagini.id = immagini.id_ruolo
	WHERE ( immagini.timestamp_scalamento IS NULL OR immagini.timestamp_scalamento < immagini.timestamp_aggiornamento OR immagini.timestamp_aggiornamento IS NULL )
	ORDER BY immagini.timestamp_scalamento ASC, ruoli_immagini.ordine_scalamento ASC, immagini.ordine ASC
;

--| 202202210020
CREATE OR REPLACE VIEW __report_immagini_scalate__ AS
SELECT
	sum(
	if( 
		( timestamp_scalamento IS NOT NULL OR timestamp_scalamento >= timestamp_aggiornamento )
		AND timestamp_aggiornamento IS NOT NULL, 1, 0) 
	) AS scalate,
	sum(
	if(
		timestamp_scalamento IS NULL OR timestamp_scalamento < timestamp_aggiornamento OR timestamp_aggiornamento IS NULL, 1, 0)
	) AS da_scalare,
	count(
		immagini.id
	) AS totali
FROM
	immagini
;

--| 202202210030
CREATE OR REPLACE VIEW `tipologie_contratti_view` AS
	SELECT
		tipologie_contratti.id,
		tipologie_contratti.id_genitore,
		tipologie_contratti.ordine,
		tipologie_contratti.nome,
		tipologie_contratti.html_entity,
		tipologie_contratti.font_awesome,
		tipologie_contratti.se_tesseramento,
        tipologie_contratti.se_abbonamento,
        tipologie_contratti.se_iscrizione,
		tipologie_contratti.id_account_inserimento,
		tipologie_contratti.id_account_aggiornamento,
		tipologie_contratti( tipologie_contratti.id ) AS __label__
	FROM tipologie_contratti
;

--| 202202210040
CREATE OR REPLACE VIEW `contratti_view` AS
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
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
;

--| 202202210050
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
		contratti.nome,
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

--| 202202210060
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
		contratti.nome,
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

--| 202202210070
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
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
    WHERE tipologie_contratti.se_tesseramento = 1
;

--| 202202210080
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
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
    WHERE tipologie_contratti.se_abbonamento = 1
;

--| 202202210090
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
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
    WHERE tipologie_contratti.se_iscrizione = 1
;

--| 202202210100
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
		contratti.nome,
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

--| 202202210110
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
		contratti.nome,
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

--| 202202210120
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
		contratti.nome,
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

--| 202202210130
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
		contratti.nome,
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

--| 202202210140
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
		contratti.nome,
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

--| 202202210150
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
		contratti.nome,
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

--| 202202210160
CREATE OR REPLACE VIEW `tipologie_contratti_view` AS
	SELECT
		tipologie_contratti.id,
		tipologie_contratti.id_genitore,
		tipologie_contratti.ordine,
		tipologie_contratti.nome,
		tipologie_contratti.html_entity,
		tipologie_contratti.font_awesome,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.id_account_inserimento,
		tipologie_contratti.id_account_aggiornamento,
		tipologie_contratti.nome  AS __label__
	FROM tipologie_contatti
;

--| 202202210170
CREATE OR REPLACE VIEW `rinnovi_view` AS
	SELECT
		rinnovi.id,
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
		LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto 
		LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza 
		LEFT JOIN progetti ON progetti.id = rinnovi.id_progetto
	;

--| 202202210180
CREATE OR REPLACE VIEW `matricole_view` AS
	SELECT
		matricole.id,
		matricole.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		matricole.id_marchio,
		marchi.nome AS marchio,
		matricole.id_articolo,
		concat_ws( ' ', articoli.id, prodotti.nome, articoli.nome ) AS articolo,
		matricole.matricola,
		matricole.data_scadenza,
		matricole.nome,
		concat_ws( ' ', articoli.id, prodotti.nome, articoli.nome, matricole.matricola ) AS __label__
	FROM matricole
		LEFT JOIN anagrafica AS a1 ON a1.id = matricole.id_produttore
		LEFT JOIN marchi ON marchi.id = matricole.id_marchio
		LEFT JOIN articoli ON articoli.id = id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto;

--| 202202210190
CREATE OR REPLACE VIEW `note_credito_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizione_pagamento,
		documenti.codice_archivium,
    	documenti.codice_sdi,
    	documenti.timestamp_invio,
    	documenti.progressivo_invio,
		documenti.id_coupon,
		documenti.timestamp_chiusura,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' per ',
			coalesce(
				a2.denominazione,
				concat(
					a2.cognome,
					' ',
					a2.nome
				),
				''
			)
		) AS __label__
    FROM
		documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento
   WHERE tipologie_documenti.id = 3
;

--| 202202210200
CREATE OR REPLACE VIEW `pagamenti_view` AS
	SELECT
		pagamenti.id,
		pagamenti.id_tipologia,
		pagamenti.id_modalita_pagamento,
		concat(modalita_pagamento.codice, ' - ' ,modalita_pagamento.nome) AS modalita_pagamento,
		tipologie_pagamenti.nome AS tipologia,
		pagamenti.ordine,
		pagamenti.nome,
		pagamenti.note,
		pagamenti.note_pagamento,
		pagamenti.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		pagamenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		pagamenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		pagamenti.id_iban,
		pagamenti.importo_netto_totale,
		pagamenti.id_iva,
		iva.nome AS iva,
		pagamenti.id_listino,
		listini.nome AS listino,
		pagamenti.timestamp_scadenza,
		from_unixtime( pagamenti.timestamp_scadenza, '%Y-%m-%d' ) AS data_ora_scadenza,
		pagamenti.timestamp_pagamento,
		from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) AS data_ora_pagamento,
		pagamenti.id_account_inserimento,
		pagamenti.id_account_aggiornamento,
		pagamenti.nome AS __label__
	FROM pagamenti
		LEFT JOIN tipologie_pagamenti ON tipologie_pagamenti.id = pagamenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = pagamenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = pagamenti.id_mastro_destinazione
		LEFT JOIN iva ON iva.id = pagamenti.id_iva
		LEFT JOIN listini ON listini.id = pagamenti.id_listino
		LEFT JOIN modalita_pagamento ON modalita_pagamento.id = pagamenti.id_modalita_pagamento
		LEFT JOIN documenti ON documenti.id = pagamenti.id_documento
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
	WHERE
		tipologie_documenti.se_fattura = 1
		OR
		tipologie_documenti.se_nota_credito = 1
		OR
		tipologie_documenti.se_ricevuta = 1
;

--| 202202210210
ALTER TABLE `documenti_articoli`
ADD `sconto_percentuale` decimal(16,5) DEFAULT NULL after `importo_netto_totale`,
ADD `sconto_valore` decimal(16,5) DEFAULT NULL after `sconto_percentuale`;

--| 202202210220
CREATE OR REPLACE VIEW `documenti_articoli_view` AS
    SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		documenti_articoli.data,
		documenti_articoli.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti_articoli.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti_articoli.id_reparto,
		documenti_articoli.id_progetto,
		documenti_articoli.id_todo,
		documenti_articoli.id_attivita,
		documenti_articoli.id_articolo,
		documenti_articoli.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
		documenti_articoli.id_listino,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		concat( 'MAT.',lpad(matricole.id, 15, '0') ) AS matricola,
		matricole.data_scadenza,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat(
			documenti_articoli.data,
			' / ',
			tipologie_documenti.nome,
			' / ',
			documenti_articoli.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			documenti_articoli.nome,
			' / ',
			documenti_articoli.importo_netto_totale,
			' ',
			valute.utf8
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti_articoli.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti_articoli.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti_articoli.id_tipologia
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
;

--| 202202210230
CREATE OR REPLACE VIEW `righe_fatture_view` AS
       SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		documenti_articoli.data,
		documenti_articoli.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti_articoli.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti_articoli.id_reparto,
		documenti_articoli.id_progetto,
		documenti_articoli.id_todo,
		documenti_articoli.id_attivita,
		documenti_articoli.id_articolo,
		documenti_articoli.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
		documenti_articoli.id_listino,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		concat( 'MAT.',lpad(matricole.id, 15, '0') ) AS matricola,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat(
			documenti_articoli.data,
			' / ',
			tipologie_documenti.nome,
			' / ',
			documenti_articoli.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			documenti_articoli.nome,
			' / ',
			documenti_articoli.importo_netto_totale,
			' ',
			valute.utf8
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti_articoli.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti_articoli.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti_articoli.id_tipologia
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
		WHERE tipologie_documenti.id = 1
;

--| 202202210240
CREATE OR REPLACE VIEW `righe_fatture_passive_view` AS
       SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		documenti_articoli.data,
		documenti_articoli.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti_articoli.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti_articoli.id_reparto,
		documenti_articoli.id_progetto,
		documenti_articoli.id_todo,
		documenti_articoli.id_attivita,
		documenti_articoli.id_articolo,
		documenti_articoli.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
		documenti_articoli.id_listino,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		concat( 'MAT.',lpad(matricole.id, 15, '0') ) AS matricola,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat(
			documenti_articoli.data,
			' / ',
			tipologie_documenti.nome,
			' / ',
			documenti_articoli.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			documenti_articoli.nome,
			' / ',
			documenti_articoli.importo_netto_totale,
			' ',
			valute.utf8
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti_articoli.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti_articoli.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti_articoli.id_tipologia
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
		WHERE tipologie_documenti.id = 11
;

--| 202202210250
CREATE OR REPLACE VIEW `righe_proforma_view` AS
        SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		documenti_articoli.data,
		documenti_articoli.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti_articoli.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti_articoli.id_reparto,
		documenti_articoli.id_progetto,
		documenti_articoli.id_todo,
		documenti_articoli.id_attivita,
		documenti_articoli.id_articolo,
		documenti_articoli.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
		documenti_articoli.id_listino,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		concat( 'MAT.',lpad(matricole.id, 15, '0') ) AS matricola,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat(
			documenti_articoli.data,
			' / ',
			tipologie_documenti.nome,
			' / ',
			documenti_articoli.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			documenti_articoli.nome,
			' / ',
			documenti_articoli.importo_netto_totale,
			' ',
			valute.utf8
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti_articoli.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti_articoli.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti_articoli.id_tipologia
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
		WHERE tipologie_documenti.se_pro_forma = 1
;

--| 202202210260
CREATE TABLE IF NOT EXISTS `tipologie_luoghi` (
  `id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `nome` char(64) COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202202210270
ALTER TABLE `tipologie_luoghi`
	ADD PRIMARY KEY (`id`),
  	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD KEY `id_genitore` (`id_genitore`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

--| 202202210280
ALTER TABLE `tipologie_luoghi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202202210290
INSERT INTO `tipologie_luoghi` (`id`, `nome`) VALUES
(1, 'teatro'),
(2, 'palestra'),
(3, 'piscina');

--| 202202210300
ALTER TABLE `tipologie_luoghi`
    ADD CONSTRAINT `tipologie_luoghi_ibfk_01_nofollow`          FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_luoghi_ibfk_98_nofollow`          FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_luoghi_ibfk_99_nofollow`          FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202210310
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_luoghi_path`( `p1` INT( 11 ) ) RETURNS TEXT CHARSET utf8 COLLATE utf8_general_ci
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

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

--| 202202210320
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_luoghi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN
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

--| 202202210330
CREATE
	DEFINER = CURRENT_USER()
	FUNCTION `tipologie_luoghi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS INT( 11 )
	NOT DETERMINISTIC
	READS SQL DATA
	SQL SECURITY DEFINER
	BEGIN

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

--| 202202210340
CREATE OR REPLACE VIEW `tipologie_luoghi_view` AS
	SELECT
		tipologie_luoghi.id,
		tipologie_luoghi.id_genitore,
		tipologie_luoghi.ordine,
		tipologie_luoghi.nome,
		tipologie_luoghi.html_entity,
		tipologie_luoghi.font_awesome,
		tipologie_luoghi.se_magazzino,
		tipologie_luoghi.se_conto,
		tipologie_luoghi.se_registro,
		tipologie_luoghi.id_account_inserimento,
		tipologie_luoghi.id_account_aggiornamento,
		tipologie_luoghi_path( tipologie_luoghi.id ) AS __label__
	FROM tipologie_luoghi
;

--| FINE