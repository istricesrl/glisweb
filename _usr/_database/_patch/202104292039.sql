CREATE OR REPLACE VIEW attivita_categorie_view AS
	SELECT
		attivita_categorie.*,
		concat(
			attivita.nome,
			'/',
			categorie_attivita.nome
		) AS __label__
	FROM attivita_categorie
	INNER JOIN attivita ON attivita.id = attivita_categorie.id_attivita
	INNER JOIN categorie_attivita ON categorie_attivita.id = attivita_categorie.id_categoria
	ORDER BY __label__
;