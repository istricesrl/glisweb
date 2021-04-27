CREATE OR REPLACE VIEW `contratti_archiviati_view` AS
SELECT contratti.*,
	coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.cognome, ''),
		coalesce(anagrafica.nome, '') ),
		''
	) AS anagrafica,
	concat(
		tipologie_contratti.nome, 
		' ', 
		coalesce(
			anagrafica.soprannome,
			anagrafica.denominazione,
			concat_ws(' ', coalesce(anagrafica.cognome, ''),coalesce(anagrafica.nome, '') ),
			''
		)
	) as __label__
FROM contratti 
LEFT JOIN anagrafica ON contratti.id_anagrafica = anagrafica.id
LEFT JOIN tipologie_contratti ON contratti.id_tipologia = tipologie_contratti.id
WHERE data_fine IS NOT NULL OR data_fine_rapporto IS NOT NULL
ORDER BY __label__
;