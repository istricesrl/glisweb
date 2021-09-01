CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
    documenti.*,
    concat(tipologie.nome, ' ', documenti.numero, '/', year( documenti.data ), ' del ', documenti.data, ' per cliente ', concat(COALESCE(clienti.nome,''), 		COALESCE(clienti.cognome,''),COALESCE(clienti.denominazione,'')), ' | ', COALESCE(documenti.nome,'')   ) AS __label__,
    tipologie.codice AS codice_tipologia,
    tipologie.nome AS tipologia,
    coalesce(
	clienti.soprannome,
	clienti.denominazione,
	concat_ws(' ', coalesce(clienti.cognome, ''),
	coalesce(clienti.nome, '') ),
	''
    )  AS cliente,
    coalesce(
	emittenti.soprannome,
	emittenti.denominazione,
	concat_ws(' ', coalesce(emittenti.cognome, ''),
	coalesce(emittenti.nome, '') ),
	''
    )  AS emittente
    FROM
    documenti
    LEFT JOIN anagrafica AS clienti ON clienti.id = documenti.id_destinatario
    LEFT JOIN anagrafica AS emittenti ON emittenti.id = documenti.id_emittente
    LEFT JOIN tipologie_documenti AS tipologie ON	tipologie.id = documenti.id_tipologia
    ORDER BY __label__
;