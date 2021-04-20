CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
	documenti.*,
	concat(tipologie.nome, ' ', documenti.numero, '/', year( documenti.data ), ' del ', documenti.data, ' per cliente ', concat(COALESCE(clienti.nome,''), COALESCE(clienti.cognome,''), 			COALESCE(clienti.denominazione,'')), ' | ', COALESCE(documenti.nome,'')   ) AS __label__,
	tipologie.codice AS codice_tipologia,
	tipologie.nome AS tipologia,
	concat(COALESCE(clienti.nome,''), COALESCE(clienti.cognome,''), COALESCE(clienti.denominazione,'')) AS cliente,
	concat(COALESCE(emittenti.nome,''), COALESCE(emittenti.cognome,''), COALESCE(emittenti.denominazione,'')) AS emittente
    FROM
	documenti
    LEFT JOIN anagrafica AS clienti ON clienti.id = documenti.id_destinatario
    LEFT JOIN anagrafica AS emittenti ON emittenti.id = documenti.id_emittente
    LEFT JOIN tipologie_documenti AS tipologie ON	tipologie.id = documenti.id_tipologia
    ORDER BY __label__
;