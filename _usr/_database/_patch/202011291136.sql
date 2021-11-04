CREATE OR REPLACE VIEW `iban_view` AS
	SELECT iban.*,
	iban.iban AS __label__,
	coalesce(
			anagrafica.soprannome,
			anagrafica.denominazione,
			concat_ws(' ', coalesce(anagrafica.cognome, ''),
			coalesce(anagrafica.nome, '') ),
			''
		) AS anagrafica
	FROM iban 
	LEFT JOIN anagrafica ON anagrafica.id = iban.id_anagrafica
	ORDER BY __label__
;