CREATE OR REPLACE VIEW caratteristiche_prodotti_view AS
    SELECT
	caratteristiche_prodotti.*,
	caratteristiche_prodotti.nome AS __label__
    FROM caratteristiche_prodotti
    ORDER BY __label__
;