--
-- PATCH
--

--| 202201180010
ALTER TABLE `pagamenti` ADD `timestamp_scadenza` int NULL AFTER `timestamp_pagamento`;

--| 202201180020
ALTER TABLE `documenti` CHANGE `progressivo_invio` `progressivo_invio` char(5) NULL AFTER `timestamp_invio`;

--| 202201180030
ALTER TABLE `pagamenti` ADD KEY `timestamp_scadenza` (`timestamp_scadenza`);

--| 202201180050
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
		pagamenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		pagamenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		pagamenti.id_iban,
		pagamenti.importo_netto_totale,
		pagamenti.id_iva,
		iva.nome AS iva,
		pagamenti.id_listino,
		listini.nome AS listino,
		pagamenti.timestamp_pagamento,
		pagamenti.timestamp_scadenza,
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
;

--| 202201180060
CREATE OR REPLACE VIEW `documenti_view` AS
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
;

--| 202201180070
CREATE OR REPLACE VIEW `fatture_view` AS
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
   WHERE documenti.id_tipologia = 1
;

--| FINE FILE
