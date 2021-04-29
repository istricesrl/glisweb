CREATE OR REPLACE VIEW `tipologie_attivita_view` AS
	SELECT
	tipologie_attivita.*,
	tipologie_attivita_path( tipologie_attivita.id ) AS __label__
	FROM tipologie_attivita
	ORDER BY __label__
;