CREATE OR REPLACE VIEW `attivita_view` AS
	SELECT
	attivita.*,
	day(data) as giorno,
	month(data) as mese,
	year(data) as anno,
	progetti.nome AS progetto,
	task.nome AS task,
	task.ore_previste AS ore_previste_task,
	todo.nome AS todo,
	todo.ore_previste AS ore_previste_todo,
	tipologie_attivita.nome AS tipologia,
	tipologie_attivita_inps.nome AS tipologia_inps,
	tipologie_attivita.html AS icona_html,
	tipologie_attivita.font_awesome AS icona_fa,
	    concat(coalesce(sede.nome, sede.denominazione),'/',pratiche.numero,'/', YEAR(pratiche.data_apertura)) AS pratica,
	concat( anagrafica.nome, ' ', anagrafica.cognome ) AS anagrafica,
	coalesce(
		cliente.soprannome,
		cliente.denominazione,
		concat_ws(' ', coalesce(cliente.cognome, ''),
		coalesce(cliente.nome, '') ),
		''
	) AS cliente,
	CASE
		WHEN attivita.id_incarico IS NULL AND attivita.id_richiesta IS NULL AND attivita.id_immobile IS NOT NULL THEN 'censimento'
		WHEN attivita.id_incarico IS NULL AND attivita.id_richiesta IS NOT NULL THEN 'richiesta'
    		WHEN attivita.id_incarico IS NOT NULL AND attivita.data > incarichi_immobili.data_inizio THEN 'incarico'
   		WHEN attivita.id_incarico IS NOT NULL AND  (incarichi_immobili.data_inizio IS NULL OR attivita.data < incarichi_immobili.data_inizio) AND attivita.data > incarichi_immobili.data_valutazione THEN 'valutazione'
		WHEN attivita.id_incarico IS NOT NULL AND  (incarichi_immobili.data_inizio IS NULL OR attivita.data < incarichi_immobili.data_inizio) AND  (incarichi_immobili.data_valutazione IS NULL OR attivita.data < incarichi_immobili.data_valutazione) AND attivita.data > incarichi_immobili.data_notizia THEN 'notizia'
		WHEN attivita.id_incarico IS NOT NULL AND  (incarichi_immobili.data_inizio IS NULL OR attivita.data < incarichi_immobili.data_inizio) AND  (incarichi_immobili.data_valutazione IS NULL OR attivita.data < incarichi_immobili.data_valutazione) AND  (incarichi_immobili.data_notizia IS NULL OR attivita.data < incarichi_immobili.data_notizia) AND attivita.data > incarichi_immobili.data_sviluppo THEN 'sviluppo'
     		ELSE NULL
	END AS  tipologia_attivita_immobiliare,
	concat_ws( ' ', mandante.nome, mandante.cognome, coalesce( mandante.soprannome, mandante.denominazione ) ) AS mandante,
	concat( tipologie_attivita.nome, ' ', attivita.nome ) AS __label__
	FROM attivita
	LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia
	LEFT JOIN tipologie_attivita_inps ON tipologie_attivita_inps.id = attivita.id_tipologia_inps
	LEFT JOIN incarichi_immobili ON incarichi_immobili.id = attivita.id_incarico
	LEFT JOIN anagrafica ON anagrafica.id = attivita.id_anagrafica
	LEFT JOIN task ON task.id = attivita.id_task
	LEFT JOIN todo ON todo.id = attivita.id_todo
	LEFT JOIN progetti ON progetti.id = attivita.id_progetto
	LEFT JOIN anagrafica AS cliente ON cliente.id = coalesce( attivita.id_cliente, progetti.id_cliente, task.id_cliente, todo.id_cliente )
	LEFT JOIN anagrafica AS mandante ON mandante.id = attivita.id_mandante
	LEFT JOIN pratiche ON pratiche.id = attivita.id_pratica
    	LEFT JOIN anagrafica AS sede ON sede.id = pratiche.id_sede_apertura
	ORDER BY attivita.data DESC, __label__ ASC
;