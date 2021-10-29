CREATE OR REPLACE VIEW `periodi_variazioni_attivita_view` AS
	SELECT
	variazioni_attivita.id_anagrafica,
	coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.nome, ''),
		coalesce(anagrafica.cognome, '') ),
		''
	) AS anagrafica,
	variazioni_attivita.id_tipologia,
	tipologie_variazioni_attivita.nome AS tipologia,
	if( variazioni_attivita.data_approvazione IS NOT NULL, 1, if( variazioni_attivita.data_rifiuto IS NOT NULL, 2, 0 ) ) AS approvata,
	periodi_variazioni_attivita.*,
	periodi_variazioni_attivita.id AS __label__
	FROM periodi_variazioni_attivita
	LEFT JOIN variazioni_attivita ON periodi_variazioni_attivita.id_variazione = variazioni_attivita.id
	LEFT JOIN tipologie_variazioni_attivita ON tipologie_variazioni_attivita.id = variazioni_attivita.id_tipologia
	LEFT JOIN anagrafica ON anagrafica.id = variazioni_attivita.id_anagrafica
	ORDER BY __label__
;
