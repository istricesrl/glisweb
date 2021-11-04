CREATE OR REPLACE VIEW `periodi_variazioni_attivita_view` AS
	SELECT
	periodi_variazioni_attivita.*,
	periodi_variazioni_attivita.id AS __label__
	FROM periodi_variazioni_attivita
	ORDER BY __label__
;
