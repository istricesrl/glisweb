CREATE OR REPLACE VIEW `mastri_view` AS
    SELECT
    mastri.*,
    mastri.nome AS __label__
    FROM mastri
    ORDER BY __label__
;
