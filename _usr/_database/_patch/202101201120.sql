CREATE OR REPLACE VIEW `contratti_view` AS
SELECT contratti.*,
	coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.cognome, ''),
		coalesce(anagrafica.nome, '') ),
		''
	) AS anagrafica,
	coalesce(
		agenzie.soprannome,
		agenzie.denominazione,
		concat_ws(' ', coalesce(agenzie.cognome, ''),
		coalesce(agenzie.nome, '') ),
		''
	) AS agenzia,
	concat(
		contratti.id, ' - ',
		tipologie_contratti.nome, 
		' - ', 
		coalesce(
			anagrafica.soprannome,
			anagrafica.denominazione,
			concat_ws(' ', coalesce(anagrafica.cognome, ''),coalesce(anagrafica.nome, '') ),
			''
		)
	) as __label__
FROM contratti 
LEFT JOIN anagrafica ON contratti.id_anagrafica = anagrafica.id
LEFT JOIN anagrafica as agenzie ON contratti.id_agenzia = agenzie.id
LEFT JOIN tipologie_contratti ON contratti.id_tipologia = tipologie_contratti.id
WHERE data_fine_rapporto IS NULL AND ( data_fine IS NULL OR ( data_fine IS NOT NULL and data_fine >= CURDATE() ) )
ORDER BY __label__
;