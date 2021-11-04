CREATE OR REPLACE VIEW `campagne_view` AS
    SELECT
    campagne.*,
    COUNT(contatti.id) AS n_contatti,
    campagne.nome AS __label__
    FROM campagne
    LEFT JOIN contatti ON contatti.id_campagna = campagne.id
    GROUP BY campagne.id
    ORDER BY __label__
;