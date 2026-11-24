-- 2026-11-24 — documenti: destinatario in testo libero
--
-- Alcuni documenti ( le offerte, soprattutto ) partono verso chi non è ancora in anagrafica, e creare l'anagrafica
-- solo per stamparne il nome è un passaggio che chi fa l'offerta salta. Con il flag documenti.destinatario.libero
-- del modulo 0400.documenti il form espone un campo di testo, e il PDF lo stampa quando id_destinatario è vuoto.
--
-- Cosa fa: aggiunge `documenti`.`destinatario` ( text, dopo `id_destinatario` ) e ricrea documenti_view con il testo
-- libero come ultimo ripiego del nome del destinatario, così elenchi e mail lo mostrano.
--
-- Cosa NON fa: non tocca le altre viste che calcolano il destinatario, né i dati esistenti.
--
-- IDEMPOTENTE.

-- | 202611241900

-- documenti
ALTER TABLE `documenti`
	ADD COLUMN IF NOT EXISTS `destinatario` text DEFAULT NULL AFTER `id_destinatario`;

-- documenti_view
CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.codice,
		documenti.numero,
		documenti.sezionale,
		concat_ws(
			'/',
			documenti.numero,
			documenti.sezionale
		) AS numero_sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_referente_emittente,
		documenti.id_sede_emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), documenti.destinatario, '' ) AS destinatario,
		documenti.id_sede_destinatario,
		documenti.id_destinatario_spedizione,
		coalesce( a3.denominazione , concat( a3.cognome, ' ', a3.nome ), '' ) AS destinatario_spedizione,
		documenti.id_sede_destinatario_spedizione,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizione_pagamento,
		documenti.esigibilita,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
		-- Il totale di un documento e' quello che vale la prestazione, non i soli contanti.
		--
		-- Fix 2026-09-08. `importo_lordo_finale` e' la sola parte pagata in denaro: una ricevuta
		-- saldata per intero con un coupon ci metteva dentro ZERO. E non in modo coerente, perche'
		-- il ripiego su `importo_lordo_totale` scattava solo con NULL e mai con `0.00`, che i vari
		-- flussi di checkout scrivono uno per uno: due ricevute della stessa tornata finivano cosi'
		-- a dichiarare l'importo in due modi diversi ( segreteria Polisportiva Masi, 08/09/2026 ).
		--
		-- Il coupon e' un modo di pagare, non uno sconto sul dovuto: va sommato al contante. E'
		-- la stessa somma che la stampa della ricevuta usa da sempre come totale pagato
		-- ( coupon_valore + importo_lordo_finale ). Il ripiego sul nominale resta per il solo caso
		-- in cui non si sa ne' quanto e' stato incassato ne' quanto coperto dal buono: la rata
		-- pianificata e non ancora saldata.
		--
		-- NOTA per chi tocchera' questa vista: la `sum()` sta dentro un GROUP BY che ha in JOIN
		-- anche `relazioni_documenti` ( r1/r2 ), quindi su un documento con N pagamenti e M
		-- documenti collegati il totale risulta moltiplicato per M. Difetto reale ma indipendente
		-- da questo, e non verificabile qui: su questo deploy `relazioni_documenti` e' vuota.
		sum(
			CASE WHEN pagamenti.importo_lordo_finale IS NULL AND pagamenti.coupon_valore IS NULL
			     THEN coalesce( pagamenti.importo_lordo_totale, 0 )
			     ELSE coalesce( pagamenti.importo_lordo_finale, 0 ) + coalesce( pagamenti.coupon_valore, 0 )
			END
		) AS totale_lordo_finale,
		sum( coalesce( pagamenti.coupon_valore, 0 ) ) AS totale_coupon,
		documenti.codice_sdi,
		documenti.codice_archivium,
		documenti.progressivo_invio,
		documenti.timestamp_invio,
		documenti.data_consegna,
		documenti.id_coupon,
		documenti.id_carrello,
		documenti.id_carrelli_articoli,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_causale,
		documenti.id_trasportatore,
		documenti.porto,
		documenti.numero_colli,
		documenti.numero_pallet,
		documenti.id_pianificazione,
		documenti.id_progetto,
		group_concat( DISTINCT d1.codice SEPARATOR ' | ' ) AS documenti_antecedenti,
		group_concat( DISTINCT d2.codice SEPARATOR ' | ' ) AS documenti_successivi,
		documenti.timestamp_chiusura,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_archiviazione,
		documenti.data_archiviazione,
		documenti.id_account_proprietario,
		documenti.id_gruppo_proprietario,
		documenti.id_diritto_proprietario,
		documenti.id_diritto_gruppo,
		documenti.id_diritto_altri,
		documenti.id_account_inserimento,
		documenti.timestamp_inserimento,
		documenti.id_account_aggiornamento,
		documenti.timestamp_aggiornamento,
		concat_ws(
			' ',
			tipologie_documenti.sigla,
			concat_ws(
				'/',
				documenti.numero,
				documenti.sezionale
			),
			concat( 'del ', documenti.data ),
			concat(
				'per ',
				coalesce(
					a2.denominazione,
					concat(
						a2.cognome,
						' ',
						a2.nome
					),
					''
				)
			)
		) AS __label__
    FROM
		documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN anagrafica AS a3 ON a3.id = documenti.id_destinatario_spedizione
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
		LEFT JOIN pagamenti ON pagamenti.id_documento = documenti.id
		LEFT JOIN relazioni_documenti AS r1 ON r1.id_documento = documenti.id
		LEFT JOIN documenti AS d1 ON d1.id = r1.id_documento_collegato
		LEFT JOIN relazioni_documenti AS r2 ON r2.id_documento_collegato = documenti.id
		LEFT JOIN documenti AS d2 ON d2.id = r2.id_documento
	GROUP BY
		documenti.id
;

-- | FINE FILE
