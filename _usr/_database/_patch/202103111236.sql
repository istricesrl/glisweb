CREATE OR REPLACE VIEW `documenti_articoli_view` AS
    SELECT
	documenti_articoli.*,
	documenti_articoli.nome AS __label__
    FROM 	documenti_articoli
    ORDER BY __label__
;