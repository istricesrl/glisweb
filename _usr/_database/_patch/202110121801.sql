CREATE OR REPLACE VIEW categorie_attivita_view AS
	SELECT
		categorie_attivita.*,
	 	categorie_attivita_path( categorie_attivita.id ) AS __label__
	FROM categorie_attivita
	ORDER BY __label__
;
