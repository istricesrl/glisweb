CREATE OR REPLACE VIEW `tipologie_documenti_view` AS
    SELECT
    tipologie_documenti.*,
    tipologie_documenti.nome AS __label__
    FROM tipologie_documenti
    ORDER BY __label__
;