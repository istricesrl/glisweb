CREATE OR REPLACE VIEW categorie_notizie_view AS
    SELECT
	categorie_notizie.*,
	categorie_notizie_path( categorie_notizie.id ) AS __label__
    FROM categorie_notizie
    ORDER BY __label__
;