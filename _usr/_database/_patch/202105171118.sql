CREATE OR REPLACE VIEW reparti_view AS
    SELECT
    reparti.*,
    reparti.nome AS __label__
    FROM reparti
    ORDER BY __label__
;