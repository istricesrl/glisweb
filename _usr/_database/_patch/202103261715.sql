CREATE OR REPLACE VIEW caratteristiche_articoli_view AS
    SELECT
	caratteristiche_articoli.*,
	caratteristiche_articoli.nome AS __label__
    FROM caratteristiche_articoli
    ORDER BY __label__
;