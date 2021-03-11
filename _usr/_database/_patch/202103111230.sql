CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
	documenti.*,
	concat( documenti.numero, '/', year( documenti.data ), ' del ', documenti.data) AS __label__,
	tipologie.codice AS codice_tipologia
    FROM 
	documenti
    LEFT JOIN tipologie_documenti AS tipologie ON tipologie.id = documenti.id_tipologia
    ORDER BY __label__
;