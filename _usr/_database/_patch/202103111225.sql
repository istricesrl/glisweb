CREATE OR REPLACE VIEW risorse_categorie_view AS
    SELECT
    risorse_categorie.*,
    risorse_categorie.id AS __label__
    FROM risorse_categorie
    ORDER BY id;
    