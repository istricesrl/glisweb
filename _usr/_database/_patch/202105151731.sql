CREATE OR REPLACE VIEW progetti_categorie_view AS
	SELECT
		progetti_categorie.*,
		concat(
			progetti.nome,
			'/',
			categorie_progetti.nome
		) AS __label__
	FROM progetti_categorie
	INNER JOIN progetti ON progetti.id = progetti_categorie.id_progetto
	INNER JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria
	ORDER BY __label__
;