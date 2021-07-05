CREATE OR REPLACE VIEW reparti_view AS
    SELECT
    reparti.*,
    iva.aliquota AS aliquota_iva,
    reparti.nome AS __label__
    FROM reparti
    LEFT JOIN iva ON iva.id = reparti.id_iva
    ORDER BY __label__
;