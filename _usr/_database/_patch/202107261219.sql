CREATE OR REPLACE VIEW progetti_certificazioni_view AS
	SELECT
		progetti_certificazioni.*,
		certificazioni.nome as certificazione,
		concat(
			progetti.nome,
			'/',
			certificazioni.nome
		) AS __label__
	FROM progetti_certificazioni
	INNER JOIN progetti ON progetti.id = progetti_certificazioni.id_progetto
	INNER JOIN certificazioni ON certificazioni.id = progetti_certificazioni.id_certificazione
	ORDER BY __label__
;
