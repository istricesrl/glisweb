CREATE OR REPLACE VIEW `tipologie_durate_inps_view` AS
	SELECT
	tipologie_durate_inps.*,
	tipologie_durate_inps.nome AS __label__
	FROM tipologie_durate_inps
	ORDER BY __label__
;