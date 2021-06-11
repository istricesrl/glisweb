CREATE OR REPLACE VIEW `progetti_scoperti_view` AS
	SELECT
	progetti.*,
	tipologie_progetti.nome AS tipologia,
	tipologie_progetti.se_scalare,
	tipologie_progetti.se_commessa,
	tipologie_crm.ordine,
	coalesce( anagrafica_cliente.soprannome, anagrafica_cliente.denominazione , concat( anagrafica_cliente.cognome, ' ', anagrafica_cliente.nome ), '' ) AS cliente,
	min( attivita_scoperte_view.data_programmazione ) as data_scopertura,
	progetti.nome AS __label__
	FROM progetti
	INNER JOIN attivita_scoperte_view ON progetti.id = attivita_scoperte_view.id_progetto
	LEFT JOIN anagrafica AS anagrafica_cliente ON anagrafica_cliente.id = progetti.id_cliente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
	LEFT JOIN tipologie_crm ON tipologie_crm.id = anagrafica_cliente.id_tipologia_crm
	GROUP BY progetti.id
	ORDER BY __label__
;