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
	attivita_view.nome AS attivita,
	attivita_view.id_progetto AS id_progetto,
	attivita_view.progetto AS progetto,
	if( sostituzioni_attivita.data_rifiuto IS NOT NULL, 2, if( sostituzioni_attivita.data_accettazione IS NOT NULL, 1, 0 ) ) AS accettata,
	concat(
		coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.nome, ''),
		coalesce(anagrafica.cognome, '') ),
		''
		),
		' ',
		attivita_view.nome
	) AS __label__
	FROM sostituzioni_attivita
	LEFT JOIN anagrafica ON anagrafica.id = sostituzioni_attivita.id_anagrafica
	LEFT JOIN attivita_view ON attivita_view.id = sostituzioni_attivita.id_attivita
	ORDER BY __label__
;