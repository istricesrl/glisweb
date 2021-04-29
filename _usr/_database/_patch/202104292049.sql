CREATE OR REPLACE VIEW todo_categorie_view AS
	SELECT
		todo_categorie.*,
		concat(
			todo.nome,
			'/',
			categorie_attivita.nome
		) AS __label__
	FROM todo_categorie
	INNER JOIN todo ON todo.id = todo_categorie.id_todo
	INNER JOIN categorie_attivita ON categorie_attivita.id = todo_categorie.id_categoria
	ORDER BY __label__
;