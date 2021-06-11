CREATE OR REPLACE VIEW `obiettivi_prodotti_view` AS
    SELECT
    obiettivi_prodotti.*,
    obiettivi_prodotti.id AS __label__
    FROM obiettivi_prodotti
;