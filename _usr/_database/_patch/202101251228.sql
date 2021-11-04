CREATE OR REPLACE VIEW `righe_documenti_amministrativi_view` AS
    SELECT
	righe_documenti_amministrativi.*,
	righe_documenti_amministrativi.nome AS __label__,
	COUNT(figlie.id) AS numero_aggregate
    FROM 
	righe_documenti_amministrativi
    LEFT JOIN righe_documenti_amministrativi AS figlie ON figlie.id_genitore = righe_documenti_amministrativi.id
    GROUP BY righe_documenti_amministrativi.id
    ORDER BY 
	__label__
;