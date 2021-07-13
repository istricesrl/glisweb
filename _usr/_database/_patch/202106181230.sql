CREATE OR REPLACE VIEW `certificazioni_view` AS
SELECT certificazioni.*,
	coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.cognome, ''),
		coalesce(anagrafica.nome, '') ),
		''
	) AS anagrafica,
	coalesce(
		emittenti.soprannome,
		emittenti.denominazione,
		concat_ws(' ', coalesce(emittenti.cognome, ''),
		coalesce(emittenti.nome, '') ),
		''
	) AS emittente,
	tipologie_certificazioni.nome as tipologia,
	concat(
		certificazioni.id, ' ',
		tipologie_certificazioni.nome, 
		' ', 
		coalesce(
			anagrafica.soprannome,
			anagrafica.denominazione,
			concat_ws(' ', coalesce(anagrafica.cognome, ''),coalesce(anagrafica.nome, '') ),
			''
		)
	) as __label__
FROM certificazioni 
LEFT JOIN anagrafica ON certificazioni.id_anagrafica = anagrafica.id
LEFT JOIN anagrafica AS emittenti ON certificazioni.id_emittente = emittenti.id
LEFT JOIN tipologie_certificazioni ON certificazioni.id_tipologia = tipologie_certificazioni.id
WHERE data_scadenza IS NULL OR data_scadenza >= CURDATE()
ORDER BY __label__
;
