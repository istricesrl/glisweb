CREATE OR REPLACE VIEW `tipologie_qualifiche_inps_view` AS
	SELECT
	tipologie_qualifiche_inps.*,
	tipologie_qualifiche_inps.nome AS __label__
	FROM tipologie_qualifiche_inps
	ORDER BY __label__
;