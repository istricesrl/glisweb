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
		tipologie_luoghi.id_account_inserimento,
		tipologie_luoghi.id_account_aggiornamento,
		tipologie_luoghi_path( tipologie_luoghi.id ) AS __label__
	FROM tipologie_luoghi
;

--| 202202210350
ALTER TABLE `udm`
CHANGE `id_genitore` `id_base` int NULL AFTER `id`,
ADD `se_volume` INT(1) NULL AFTER `se_lunghezza`,
ADD `se_massa` INT(1) NULL AFTER `se_volume`,
ADD `se_tempo` INT(1) NULL AFTER `se_massa`,
ADD KEY `se_volume`(`se_volume`),
ADD KEY `se_massa`(`se_massa`),
ADD KEY `se_tempo`(`se_tempo`);

--| 202202210360
ALTER TABLE `udm` DROP COLUMN `se_peso`;

--| 202202210370
ALTER TABLE `udm` DROP INDEX `indice`;

--| 202202210381
ALTER TABLE `udm`
ADD KEY `indice` (`id`,`id_base`,`conversione`,`nome`,`sigla`,`se_tempo`,`se_lunghezza`,`se_volume`,`se_quantita`);

--| 202202210390
CREATE OR REPLACE VIEW udm_view AS
	SELECT
		udm.id,
		coalesce( udm.id_base, udm.id ) AS id_base,
		coalesce( udm.conversione, 1 ) AS conversione,
		udm.nome,
		udm.sigla,
		udm.se_lunghezza,
		udm.se_volume,
		udm.se_massa,
		udm.se_tempo,
		udm.se_quantita,
		udm.sigla AS __label__
	FROM udm
;

--| 202202210395
INSERT INTO `udm` (`id`, `id_base`, `conversione`, `nome`, `sigla`, `note`, `se_lunghezza`, `se_volume`, `se_massa`, `se_tempo`, `se_quantita`) VALUES
(1,	NULL,	NULL,	'pezzi',	'pz.',	'unità di misura usata genericamente per misurare le quantità',	NULL,	NULL,	NULL,	NULL,	1),
(2,	NULL,	1,	'millimetro',	'mm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL),
(3,	2,	10,	'centimetro',	'cm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL),
(4,	2,	100,	'decimetro',	'dm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL),
(5,	2,	1000,	'metro',	'm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL),
(6,	2,	10000,	'decametro',	'dam',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL),
(7,	2,	100000,	'ettometro',	'hm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL),
(8,	2,	1000000,	'kilometro',	'km',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL),
(9,	NULL,	1,	'milligrammo',	'mg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL),
(10,	9,	10,	'centigrammo',	'cg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL),
(11,	9,	100,	'decigrammo',	'dg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL),
(12,	9,	1000,	'grammo',	'gr',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL),
(13,	9,	10000,	'decagrammo',	'dag',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL),
(14,	9,	100000,	'ettogrammo',	'hg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL),
(15,	9,	1000000,	'kilogrammo',	'kg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL),
(16,	NULL,	1,	'millilitro',	'ml',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL),
(17,	16,	10,	'centilitro',	'cl',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL),
(18,	16,	100,	'decilitro',	'dl',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL),
(19,	16,	1000,	'litro',	'l',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL),
(20,	16,	10000,	'decalitro',	'dal',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL),
(21,	16,	100000,	'ettolitro',	'hl',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL),
(22,	16,	1000000,	'kilolitro',	'kl',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL)
ON DUPLICATE KEY UPDATE
	id_base = VALUES( id_base ),
	conversione = VALUES( conversione ),
	nome = VALUES( nome ),
	sigla = VALUES( sigla ),
	note = VALUES( note ),
	se_lunghezza = VALUES( se_lunghezza ),
	se_volume = VALUES( se_volume ),
	se_massa = VALUES( se_massa ),
	se_tempo = VALUES( se_tempo ),
	se_quantita = VALUES( se_quantita )
;

--| 202202210400
ALTER TABLE `tipologie_prodotti`
ADD `se_volume` tinyint(1) DEFAULT NULL AFTER `se_servizio`,
ADD `se_capacita` tinyint(1) DEFAULT NULL AFTER `se_volume`,
ADD `se_peso` tinyint(1) DEFAULT NULL AFTER `se_capacita`;

--| 202202210410
CREATE OR REPLACE VIEW `tipologie_prodotti_view` AS
	SELECT
		tipologie_prodotti.id,
		tipologie_prodotti.id_genitore,
		tipologie_prodotti.ordine,
		tipologie_prodotti.nome,
		tipologie_prodotti.html_entity,
		tipologie_prodotti.font_awesome,
		tipologie_prodotti.se_colori,
		tipologie_prodotti.se_taglie,
		tipologie_prodotti.se_dimensioni,
		tipologie_prodotti.se_imballo,
		tipologie_prodotti.se_spedizione,
		tipologie_prodotti.se_trasporto,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		tipologie_prodotti.se_volume,
		tipologie_prodotti.se_capacita,
		tipologie_prodotti.se_peso,
		tipologie_prodotti.id_account_inserimento,
		tipologie_prodotti.id_account_aggiornamento,
		tipologie_prodotti_path( tipologie_prodotti.id ) AS __label__
	FROM tipologie_prodotti
;

--| 202202210420
INSERT INTO `tipologie_prodotti` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_colori`, `se_taglie`, `se_dimensioni`, `se_volume`, `se_capacita`, `se_peso`, `se_imballo`, `se_spedizione`, `se_trasporto`, `se_prodotto`, `se_servizio`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'prodotto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'servizio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	2,	NULL,	NULL,	NULL,	NULL),
(3,	1,	NULL,	'alimentare (peso)',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	1,	NULL,	'alimentare (volume)',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	1,	NULL,	'alimentare (pezzo)',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL)
ON DUPLICATE KEY UPDATE
	id_genitore = VALUES( id_genitore ),
	ordine = VALUES( ordine ),
	nome = VALUES(nome),
	html_entity = VALUES(html_entity),
	font_awesome = VALUES(font_awesome),
	se_colori = VALUES(se_colori),
	se_taglie = VALUES(se_taglie),
	se_dimensioni = VALUES(se_dimensioni),
	se_volume = VALUES(se_volume),
	se_capacita = VALUES(se_capacita),
	se_peso = VALUES(se_peso),
	se_imballo = VALUES(se_imballo),
	se_spedizione = VALUES(se_spedizione),
	se_trasporto = VALUES(se_trasporto),
	se_prodotto = VALUES(se_prodotto),
	se_servizio= VALUES(se_servizio);

--| 202202210428
ALTER TABLE `tipologie_documenti`
DROP INDEX `indice`;

--| 202202210430
ALTER TABLE `tipologie_documenti`
ADD `numerazione` char(1) DEFAULT NULL AFTER `codice`,
ADD KEY `numerazione`(`numerazione`),
ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`numerazione`);

--| 202202210440
INSERT INTO `tipologie_documenti` (`id`, `id_genitore`, `ordine`, `codice`, `numerazione`, `nome`, `html_entity`, `font_awesome`, `se_fattura`, `se_nota_credito`, `se_trasporto`, `se_pro_forma`, `se_offerta`, `se_ordine`, `se_ricevuta`, `stampa_xml`, `stampa_pdf`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'TD01',	'F',	'fattura',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'TD01',	'F',	'fattura accompagnatoria',	NULL,	NULL,	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'TD04',	'F',	'nota di credito',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	NULL,	'T',	'documento di trasporto',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	NULL,	'P',	'pro forma',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	NULL,	NULL,	'O',	'offerta',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	NULL,	NULL,	'E',	'ordine',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	NULL,	NULL,	'R',	'ricevuta',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	NULL,	NULL,	NULL,	'S',	'scontrino',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	NULL,	NULL,	'G',	'documento di ritiro',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	NULL,	NULL,	'H',	'documento di consegna',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	NULL,	NULL,	'I',	'documento di reso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL)
ON DUPLICATE KEY UPDATE
	id_genitore = VALUES( id_genitore ),
	ordine = VALUES( ordine ),
	nome = VALUES(nome),
	html_entity = VALUES(html_entity),
	font_awesome = VALUES(font_awesome),
	codice = VALUES( codice ),
	numerazione = VALUES(numerazione),
	se_fattura = VALUES(se_fattura),
	se_nota_credito = VALUES(se_nota_credito),
	se_trasporto = VALUES(se_trasporto),
	se_pro_forma = VALUES(se_pro_forma),
	se_offerta = VALUES(se_offerta),
	se_ordine = VALUES(se_ordine),
	se_ricevuta= VALUES(se_ricevuta);

--| 202202210450
CREATE OR REPLACE VIEW `tipologie_documenti_view` AS
	SELECT
		tipologie_documenti.id,
		tipologie_documenti.id_genitore,
		tipologie_documenti.ordine,
		tipologie_documenti.codice,
		tipologie_documenti.numerazione,
		tipologie_documenti.nome,
		tipologie_documenti.html_entity,
		tipologie_documenti.font_awesome,
		tipologie_documenti.se_fattura,
		tipologie_documenti.se_nota_credito,
		tipologie_documenti.se_trasporto,
		tipologie_documenti.se_pro_forma,
		tipologie_documenti.se_offerta,
		tipologie_documenti.se_ordine,
		tipologie_documenti.se_ricevuta,
		tipologie_documenti.id_account_inserimento,
		tipologie_documenti.id_account_aggiornamento,
		tipologie_documenti_path( tipologie_documenti.id ) AS __label__
	FROM tipologie_documenti
;

--| FINE