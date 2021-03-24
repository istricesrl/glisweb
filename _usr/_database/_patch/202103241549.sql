CREATE OR REPLACE VIEW `sostituzioni_attivita_view` AS
	SELECT
	sostituzioni_attivita.*,
	coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.nome, ''),
		coalesce(anagrafica.cognome, '') ),
		''
	) AS anagrafica,
	attivita.nome AS attivita,
	concat(
		coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.nome, ''),
		coalesce(anagrafica.cognome, '') ),
		''
		),
		' ',
		attivita.nome
	) AS __label__
	FROM sostituzioni_attivita
	LEFT JOIN anagrafica ON anagrafica.id = sostituzioni_attivita.id_anagrafica
	LEFT JOIN attivita ON attivita.id = sostituzioni_attivita.id_attivita
	ORDER BY __label__
;
