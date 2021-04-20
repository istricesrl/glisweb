CREATE OR REPLACE VIEW `tipologie_risorse_view` AS
    SELECT
    tipologie_risorse.*,
    tipologie_risorse.nome AS __label__
    FROM tipologie_risorse
    ORDER BY __label__
;