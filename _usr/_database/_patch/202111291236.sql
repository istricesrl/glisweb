CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
    documenti.*,
    tipologie.codice AS codice_tipologia,
    tipologie.nome AS tipologia,
    group_concat( DISTINCT scadenze.id_modalita_pagamento SEPARATOR ' | ' ) AS pagamento,
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
    )  AS emittente,
	concat(tipologie.nome, ' ', documenti.numero, '/', year( documenti.data ), ' del ', documenti.data, ' per cliente ', coalesce(
	clienti.soprannome,
	clienti.denominazione,
	concat_ws(' ', coalesce(clienti.cognome, ''),
	coalesce(clienti.nome, '') ),
	''
    )  ) AS __label__,
    SUM(documenti_articoli_view.totale_riga) AS totale
    FROM
    documenti
    LEFT JOIN anagrafica AS clienti ON clienti.id = documenti.id_destinatario
    LEFT JOIN anagrafica AS emittenti ON emittenti.id = documenti.id_emittente
    LEFT JOIN tipologie_documenti AS tipologie ON	tipologie.id = documenti.id_tipologia
    LEFT JOIN documenti_articoli_view ON documenti_articoli_view.id_documento = documenti.id
    LEFT JOIN scadenze ON scadenze.id_documento = documenti.id
    GROUP BY documenti.id
    ORDER BY __label__
;