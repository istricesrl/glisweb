CREATE OR REPLACE VIEW `orari_contratti_view` AS
	SELECT
	orari_contratti.*,
	concat(id_giorno, ' ', ora_inizio, ' ', ora_fine) AS __label__
	FROM orari_contratti
	ORDER BY __label__
;