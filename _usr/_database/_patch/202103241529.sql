CREATE OR REPLACE VIEW `tipologie_variazioni_attivita_view` AS
	SELECT
	tipologie_variazioni_attivita.*,
	tipologie_variazioni_attivita.nome AS __label__
	FROM tipologie_variazioni_attivita
	ORDER BY __label__
;