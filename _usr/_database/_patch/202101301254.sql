CREATE OR REPLACE VIEW progetti_anagrafica_view AS
	SELECT progetti_anagrafica.*,
 	concat_ws( ' ', progetti.nome, anagrafica.nome, ruoli_anagrafica.nome ) AS __label__
	FROM progetti_anagrafica
	LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = progetti_anagrafica.id_ruolo
 	LEFT JOIN progetti ON progetti.id = progetti_anagrafica.id_progetto
	LEFT JOIN anagrafica ON anagrafica.id = progetti_anagrafica.id_anagrafica
	ORDER BY __label__
;