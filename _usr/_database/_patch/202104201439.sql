CREATE OR REPLACE VIEW `documenti_articoli_view` AS
    SELECT
	documenti_articoli.*,
	concat( documenti_articoli.nome, ' del ', documenti_articoli.data_lavorazione, ' per ', concat(COALESCE(clienti.nome,''), COALESCE(clienti.cognome,''), COALESCE(clienti.denominazione,'')) ) AS __label__,
	tipologie.codice AS codice_tipologia,
	concat('riga di ', tipologie.nome) AS tipologia,
	concat(COALESCE(clienti.nome,''), COALESCE(clienti.cognome,''), COALESCE(clienti.denominazione,'')) AS cliente,
	concat(COALESCE(emittenti.nome,''), COALESCE(emittenti.cognome,''), COALESCE(emittenti.denominazione,'')) AS emittente,
	concat( documenti.numero, '/', year( documenti.data ), ' del ', documenti.data, ' | ', COALESCE(documenti.nome,'')   ) AS  documento
    FROM documenti_articoli
    LEFT JOIN anagrafica AS clienti ON clienti.id = documenti_articoli.id_destinatario
    LEFT JOIN anagrafica AS emittenti ON emittenti.id = documenti_articoli.id_emittente
    LEFT JOIN tipologie_documenti AS tipologie ON	tipologie.id = documenti_articoli.id_tipologia
    LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
    ORDER BY __label__
;