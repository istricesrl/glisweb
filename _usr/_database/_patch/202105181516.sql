CREATE OR REPLACE VIEW todo_articoli_view AS
	SELECT
		todo_articoli.*,
		todo.nome AS todo,
		articoli.nome AS articolo,
		concat_ws( ' ', todo.nome, articoli.nome ) AS __label__
	FROM todo_articoli
	LEFT JOIN todo ON todo.id = todo_articoli.id_todo
	LEFT JOIN articoli ON articoli.id = todo_articoli.id_articolo
	ORDER BY __label__
;