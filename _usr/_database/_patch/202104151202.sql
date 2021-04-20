CREATE OR REPLACE VIEW `tipologie_obiettivi_view` AS
    SELECT
    tipologie_obiettivi.*,
    tipologie_obiettivi.nome AS __label__
    FROM tipologie_obiettivi
    ORDER BY __label__
;