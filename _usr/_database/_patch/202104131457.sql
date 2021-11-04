CREATE OR REPLACE VIEW progetti_anagrafica_view AS
	SELECT progetti_anagrafica.*,
	ruoli_progetti.se_responsabile_qualita,
	ruoli_progetti.se_responsabile_acquisti,
	ruoli_progetti.se_coordinatore,
	ruoli_progetti.se_responsabile_amministrativo,
	ruoli_progetti.se_responsabile_servizi,	
	ruoli_progetti.se_operativo,
 	concat_ws( ' ', progetti.nome, anagrafica.nome, ruoli_progetti.nome ) AS __label__
	FROM progetti_anagrafica
	LEFT JOIN ruoli_progetti ON ruoli_progetti.id = progetti_anagrafica.id_ruolo
 	LEFT JOIN progetti ON progetti.id = progetti_anagrafica.id_progetto
	LEFT JOIN anagrafica ON anagrafica.id = progetti_anagrafica.id_anagrafica
	ORDER BY __label__
;