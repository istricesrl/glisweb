CREATE OR REPLACE VIEW `obiettivi_articoli_view` AS
    SELECT
    obiettivi_articoli.*,
    obiettivi_articoli.id AS __label__
    FROM obiettivi_articoli
;