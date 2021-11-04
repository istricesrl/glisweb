CREATE OR REPLACE VIEW ruoli_immagini_view AS
	SELECT
		ruoli_immagini.*,
		ruoli_immagini.nome AS __label__
	FROM ruoli_immagini
	ORDER BY __label__
;
