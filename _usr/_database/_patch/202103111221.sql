CREATE OR REPLACE VIEW `categorie_risorse_view` AS
    SELECT
    categorie_risorse.*,
    categorie_risorse.nome AS __label__
    FROM categorie_risorse
    ORDER BY __label__
;