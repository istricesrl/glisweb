CREATE OR REPLACE VIEW `sostituzioni_progetti_view` AS
	SELECT
	sostituzioni_progetti.*,
	coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.nome, ''),
		coalesce(anagrafica.cognome, '') ),
		''
	) AS anagrafica,
	progetti.nome AS progetto,
	sostituzioni_progetti.id AS __label__
	FROM sostituzioni_progetti
	LEFT JOIN anagrafica ON anagrafica.id = sostituzioni_progetti.id_anagrafica
	LEFT JOIN progetti ON progetti.id = sostituzioni_progetti.id_progetto
	ORDER BY __label__
;