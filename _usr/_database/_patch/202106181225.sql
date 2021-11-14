CREATE OR REPLACE VIEW `tipologie_certificazioni_view` AS
	SELECT
	tipologie_certificazioni.*,
	tipologie_certificazioni.nome AS __label__
	FROM tipologie_certificazioni
	ORDER BY __label__
;
