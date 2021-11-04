CREATE OR REPLACE VIEW tipologie_indirizzi_view AS
	SELECT *, concat(COALESCE(html,''), ' ', nome) AS __label__ FROM tipologie_indirizzi
	ORDER BY __label__
;
