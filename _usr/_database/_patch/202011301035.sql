DROP TABLE IF EXISTS `task_view`;
CREATE OR REPLACE VIEW task_view AS SELECT
    task.id,
    from_unixtime( task.timestamp_apertura, '%Y-%m-%d %H:%i' ) AS data_ora_apertura,
    coalesce(
	anagrafica_cliente.soprannome,
	anagrafica_cliente.denominazione,
	concat( anagrafica_cliente.cognome, ' ', anagrafica_cliente.nome ), ''
    ) AS cliente,
    coalesce(
	task.id_cliente,
	progetti.id_cliente
    ) AS id_cliente,
    progetti.nome AS progetto,
    tipologie_crm.nome AS crm,
    tipologie_task.nome AS tipologia,
    priorita.nome AS priorita,
    task.nome,
    task.id_priorita,
    task.ore_previste,
    task.id_progetto,
    task.anno_previsto,
    task.settimana_prevista,
    concat( anno_previsto, '/', lpad( settimana_prevista, 2, '0' ) ) AS pianificazione,
    coalesce( sum( attivita.ore ), 0 ) AS ore_lavorate,
    greatest( ( task.ore_previste - coalesce( sum( attivita.ore ), 0 ) ), 0 ) AS ore_residue,
    task.id_responsabile,
    coalesce(
	anagrafica_responsabile.denominazione,
	concat( anagrafica_responsabile.cognome, ' ', anagrafica_responsabile.nome ),
	''
    ) AS responsabile,
    task.id_account_inserimento,
    ( coalesce( sum( attivita.ore ), 0 ) / task.ore_previste * 100 ) AS avanzamento,
    concat( coalesce( sum( attivita.ore ), 0 ), ' di ', task.ore_previste ) AS progresso,
    task.timestamp_completamento,
    task.timestamp_inserimento,
    task.timestamp_revisione,
    from_unixtime( task.timestamp_completamento, '%Y-%m-%d %H:%i' ) AS data_ora_completamento,
    if( task.timestamp_completamento IS NOT NULL, 2, if( task.timestamp_revisione IS NOT NULL, 1, 0 ) ) AS completato,
    concat_ws(
	' | ',
	coalesce(
	    anagrafica_cliente.soprannome,
	    anagrafica_cliente.denominazione,
	    concat( anagrafica_cliente.cognome, ' ', anagrafica_cliente.nome ), ''
	),
	task.id_progetto,
	task.nome
    ) AS __label__
FROM
    task
LEFT JOIN anagrafica
    ON anagrafica.id = task.id_anagrafica
LEFT JOIN anagrafica AS anagrafica_cliente
    ON anagrafica_cliente.id = task.id_cliente
LEFT JOIN anagrafica AS anagrafica_responsabile
    ON anagrafica_responsabile.id = task.id_responsabile
LEFT JOIN attivita
    ON attivita.id_task = task.id
LEFT JOIN progetti
    ON progetti.id = task.id_progetto
LEFT JOIN priorita
    ON priorita.id = task.id_priorita
LEFT JOIN tipologie_task
    ON tipologie_task.id = task.id_tipologia
LEFT JOIN tipologie_crm
    ON tipologie_crm.id = anagrafica_cliente.id_tipologia_crm
GROUP BY
    task.id
ORDER BY
    pianificazione ASC,
    priorita.ordine DESC,
    tipologie_crm.ordine ASC,
    task.timestamp_apertura ASC
;