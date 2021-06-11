CREATE OR REPLACE VIEW tipologie_mastri_view AS
    SELECT
	tipologie_mastri.*,
	tipologie_mastri.nome AS __label__
    FROM tipologie_mastri
    ORDER BY __label__
;