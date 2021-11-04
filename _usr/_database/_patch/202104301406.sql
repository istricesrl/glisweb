CREATE OR REPLACE VIEW `variazioni_attivita_view` AS
	SELECT
	variazioni_attivita.*,
	if( variazioni_attivita.data_approvazione IS NOT NULL, 1, if( variazioni_attivita.data_rifiuto IS NOT NULL, 2, 0 ) ) AS approvata,
	tipologie_variazioni_attivita.nome AS tipologia,
	tipologie_attivita_inps.nome AS tipologia_inps,
	coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.nome, ''),
		coalesce(anagrafica.cognome, '') ),
		''
	) AS anagrafica,
	CONCAT( 
		coalesce(
			anagrafica.soprannome,
			anagrafica.denominazione,
			concat_ws(' ', coalesce(anagrafica.nome, ''),
			coalesce(anagrafica.cognome, '') ),
			''
		), 
		' - ', 
		tipologie_variazioni_attivita.nome, 
		' - ', 
		data_richiesta 
	) AS __label__
	FROM variazioni_attivita
	LEFT JOIN tipologie_variazioni_attivita ON tipologie_variazioni_attivita.id = variazioni_attivita.id_tipologia
	LEFT JOIN tipologie_attivita_inps ON tipologie_attivita_inps.id = variazioni_attivita.id_tipologia_inps
	LEFT JOIN anagrafica ON anagrafica.id = variazioni_attivita.id_anagrafica
	ORDER BY __label__
;