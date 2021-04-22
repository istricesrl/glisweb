CREATE OR REPLACE VIEW `obiettivi_tipologie_documenti_view` AS
    SELECT
    obiettivi_tipologie_documenti.*,
    obiettivi_tipologie_documenti.id AS __label__
    FROM obiettivi_tipologie_documenti
;