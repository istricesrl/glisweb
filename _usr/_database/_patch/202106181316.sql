CREATE OR REPLACE VIEW ruoli_file_view AS
	SELECT
		ruoli_file.*,
		ruoli_file.nome AS __label__
	FROM ruoli_file
	ORDER BY __label__
;
