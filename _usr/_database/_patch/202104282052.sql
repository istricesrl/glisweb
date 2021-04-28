CREATE OR REPLACE VIEW `tipologie_progetti_view` AS
	SELECT
	tipologie_progetti.*,
	tipologie_progetti.nome AS __label__
	FROM tipologie_progetti
	ORDER BY __label__
;