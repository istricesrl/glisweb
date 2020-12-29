CREATE OR REPLACE VIEW `tipologie_attivita_inps_view` AS
	SELECT
	tipologie_attivita_inps.*,
	tipologie_attivita_inps.nome AS __label__
	FROM tipologie_attivita_inps
	ORDER BY __label__
;