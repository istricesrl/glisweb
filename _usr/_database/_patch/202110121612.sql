CREATE OR REPLACE VIEW `ticket_view` AS SELECT
	todo.id,
	from_unixtime( todo.timestamp_apertura, '%Y-%m-%d %H:%i' ) AS data_ora_apertura,
	todo.id_cliente,
	coalesce(
		anagrafica_cliente.soprannome,
		anagrafica_cliente.denominazione,
		concat_ws(' ', coalesce(anagrafica_cliente.cognome, ''),
		coalesce(anagrafica_cliente.nome, '') ),
		''
	) AS cliente,
	todo.id_progetto,
	progetti.nome AS progetto,
	todo.id_tipologia,
	tipologie_attivita.nome AS tipologia,
	todo.id_priorita,
	priorita.nome AS priorita,
	todo.nome,
	todo.data_programmazione as data_apertura,
	todo.id_responsabile,
	coalesce(
		anagrafica_responsabile.denominazione,
		concat( anagrafica_responsabile.cognome, ' ', anagrafica_responsabile.nome ),
		''
	) AS responsabile,
	todo.testo,
	todo.timestamp_completamento,
	todo.testo_completamento,
	from_unixtime( todo.timestamp_completamento, '%Y-%m-%d %H:%i' ) AS data_ora_completamento,
	if( todo.timestamp_completamento IS NOT NULL, 1, 0 ) AS completato,
	concat_ws(
		' | ',
		coalesce(
			anagrafica_cliente.soprannome,
			anagrafica_cliente.denominazione,
			concat( anagrafica_cliente.cognome, ' ', anagrafica_cliente.nome ), ''
		),
		todo.id_progetto,
		todo.nome
	) AS __label__
FROM todo
LEFT JOIN anagrafica AS anagrafica_cliente ON anagrafica_cliente.id = todo.id_cliente
LEFT JOIN anagrafica AS anagrafica_responsabile ON anagrafica_responsabile.id = todo.id_responsabile
LEFT JOIN progetti ON progetti.id = todo.id_progetto
LEFT JOIN priorita ON priorita.id = todo.id_priorita
LEFT JOIN tipologie_attivita ON tipologie_attivita.id = todo.id_tipologia
WHERE tipologie_attivita.se_ticket = 1
GROUP BY todo.id
;
