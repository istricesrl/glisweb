CREATE OR REPLACE VIEW `progetti_produzione_view` AS
	SELECT
	progetti.*,
	tipologie_progetti.nome AS tipologia,
	tipologie_progetti.se_scalare,
	tipologie_progetti.se_commessa,
	tipologie_crm.ordine,
	if( progetti.timestamp_chiusura IS NOT NULL, 1, 0 ) AS chiuso,
	if( sum( if( task.id IS NOT NULL AND task.timestamp_completamento IS NULL, 1, 0 ) ), 1, 0 ) AS attivo,
	sum( if( task.id IS NOT NULL AND task.timestamp_completamento IS NULL, 1, 0 ) ) AS task_aperti,
	sum( if( task.id IS NOT NULL AND task.timestamp_completamento IS NOT NULL, 1, 0 ) ) AS task_chiusi,
	coalesce( anagrafica_cliente.soprannome, anagrafica_cliente.denominazione , concat( anagrafica_cliente.cognome, ' ', anagrafica_cliente.nome ), '' ) AS cliente,
	progetti.nome AS __label__
	FROM progetti
	LEFT JOIN task ON task.id_progetto = progetti.id
	LEFT JOIN anagrafica AS anagrafica_cliente ON anagrafica_cliente.id = progetti.id_cliente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
	LEFT JOIN tipologie_crm ON tipologie_crm.id = anagrafica_cliente.id_tipologia_crm
	WHERE progetti.timestamp_accettazione IS NOT NULL OR progetti.data_accettazione IS NOT NULL
	GROUP BY progetti.id
	ORDER BY __label__
;