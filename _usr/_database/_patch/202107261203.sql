CREATE OR REPLACE VIEW anagrafica_certificazioni_view AS
	SELECT
		anagrafica_certificazioni.*,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) as anagrafica,
		coalesce( emittenti.denominazione , concat( emittenti.cognome, ' ', emittenti.nome ), '' ) as emittente,
		certificazioni.nome as certificazione,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			'/',
			certificazioni.nome
		) AS __label__
	FROM anagrafica_certificazioni
	INNER JOIN anagrafica ON anagrafica.id = anagrafica_certificazioni.id_anagrafica
	LEFT JOIN anagrafica as emittenti ON emittenti.id = anagrafica_certificazioni.id_emittente
	INNER JOIN certificazioni ON certificazioni.id = anagrafica_certificazioni.id_certificazione
	ORDER BY __label__
;
