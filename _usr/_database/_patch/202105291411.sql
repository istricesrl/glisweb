CREATE OR REPLACE VIEW categorie_progetti_view AS
	SELECT
		categorie_progetti.*,
	 	categorie_progetti_path( categorie_progetti.id ) AS __label__
	FROM categorie_progetti
	ORDER BY __label__
;
