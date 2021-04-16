CREATE OR REPLACE VIEW `obiettivi_categorie_prodotti_view` AS
    SELECT
    obiettivi_categorie_prodotti.*,
    obiettivi_categorie_prodotti.id AS __label__
    FROM obiettivi_categorie_prodotti
;