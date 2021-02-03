CREATE OR REPLACE VIEW ruoli_progetti_view AS
	SELECT
		ruoli_progetti.*,
	 	ruoli_progetti.id AS __label__
	FROM ruoli_progetti
	ORDER BY __label__
;
