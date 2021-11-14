CREATE OR REPLACE VIEW `tipologie_todo_view` AS
	SELECT
	tipologie_todo.*,
	tipologie_todo.nome AS __label__
	FROM tipologie_todo
	ORDER BY __label__
;