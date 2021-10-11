CREATE OR REPLACE VIEW `mastri_view` AS
    SELECT
    mastri.*,
    tipologie_mastri.nome AS tipologia,
    mastri_path( mastri.id ) AS __label__
    FROM mastri
    LEFT JOIN tipologie_mastri ON tipologie_mastri.id = mastri.id_tipologia
    ORDER BY __label__
;