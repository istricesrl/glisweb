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
	attivita_view.progetto AS progetto,
	attivita_view.data_programmazione,
	attivita_view.ora_inizio_programmazione,
	attivita_view.ora_fine_programmazione,
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