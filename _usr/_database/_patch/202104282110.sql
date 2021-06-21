CREATE OR REPLACE VIEW todo_view AS SELECT
	todo.id,
	from_unixtime( todo.timestamp_apertura, '%Y-%m-%d %H:%i' ) AS data_ora_apertura,
	from_unixtime( todo.timestamp_pianificazione, '%Y-%m-%d %H:%i' ) AS data_ora_pianificazione,
	coalesce(
		anagrafica_cliente.soprannome,
		anagrafica_cliente.denominazione,
		concat_ws(' ', coalesce(anagrafica_cliente.cognome, ''),
		coalesce(anagrafica_cliente.nome, '') ),
		''
	) AS cliente,
	coalesce(
		todo.id_cliente,
		progetti.id_cliente
	) AS id_cliente,
	progetti.nome AS progetto,
	tipologie_crm.nome AS crm,
	todo.id_tipologia,
	tipologie_todo.nome AS tipologia,
	coalesce( tipologie_todo.se_contratto, tipologie_progetti.se_contratto ) as se_contratto,
	coalesce( tipologie_todo.se_chiamata, tipologie_progetti.se_chiamata ) as se_chiamata,
	coalesce( tipologie_todo.se_scalare, tipologie_progetti.se_scalare ) as se_scalare,
	coalesce( tipologie_todo.se_commessa, tipologie_progetti.se_commessa ) as se_commessa,
	coalesce( tipologie_todo.se_forfait, tipologie_progetti.se_forfait ) as se_forfait,	
	priorita.nome AS priorita,
	todo.nome,
	todo.id_luogo,
	todo.id_indirizzo,
	todo.id_priorita,
	todo.ore_previste,
	todo.id_progetto,
	todo.anno_previsto,
	todo.settimana_prevista,	
	todo.data_programmazione,
	todo.ora_inizio_programmazione,
	todo.ora_fine_programmazione,
	todo.anno_programmazione,
	todo.settimana_programmazione,
	todo.data_scadenza,
	todo.ora_scadenza,	
	todo.id_pianificazione,
	todo.timestamp_pianificazione,
	concat( anno_previsto, '/', lpad( settimana_prevista, 2, '0' ) ) AS pianificazione,
	coalesce( sum( attivita.ore ), 0 ) AS ore_lavorate,
	greatest( ( todo.ore_previste - coalesce( sum( attivita.ore ), 0 ) ), 0 ) AS ore_residue,
	todo.id_responsabile,
	coalesce(
		anagrafica_responsabile.denominazione,
		concat( anagrafica_responsabile.cognome, ' ', anagrafica_responsabile.nome ),
		''
	) AS responsabile,
	todo.id_account_inserimento,
	( coalesce( sum( attivita.ore ), 0 ) / todo.ore_previste * 100 ) AS avanzamento,
	concat( coalesce( sum( attivita.ore ), 0 ), ' di ', todo.ore_previste ) AS progresso,
	todo.timestamp_completamento,
	todo.timestamp_inserimento,
	todo.timestamp_revisione,
	from_unixtime( todo.timestamp_completamento, '%Y-%m-%d %H:%i' ) AS data_ora_completamento,
	if( todo.timestamp_completamento IS NOT NULL, 2, if( todo.timestamp_revisione IS NOT NULL, 1, 0 ) ) AS completato,
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
LEFT JOIN anagrafica ON anagrafica.id = todo.id_anagrafica
LEFT JOIN anagrafica AS anagrafica_cliente ON anagrafica_cliente.id = todo.id_cliente
LEFT JOIN anagrafica AS anagrafica_responsabile ON anagrafica_responsabile.id = todo.id_responsabile
LEFT JOIN attivita ON attivita.id_todo = todo.id
LEFT JOIN progetti ON progetti.id = todo.id_progetto
LEFT JOIN tipologie_progetti ON progetti.id_tipologia = tipologie_progetti.id
LEFT JOIN priorita ON priorita.id = todo.id_priorita
LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
LEFT JOIN tipologie_crm	ON tipologie_crm.id = anagrafica_cliente.id_tipologia_crm
GROUP BY todo.id
ORDER BY pianificazione ASC, priorita.ordine DESC, tipologie_crm.ordine ASC, todo.timestamp_apertura ASC
;