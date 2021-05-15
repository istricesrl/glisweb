CREATE OR REPLACE VIEW `attivita_view` AS
	SELECT	
	attivita.id,
	attivita.id_tipologia,
	tipologie_attivita.nome AS tipologia,
	tipologie_attivita.se_contratto,
	tipologie_attivita.se_chiamata,
	tipologie_attivita.se_scalare,
	tipologie_attivita.se_commessa,
	tipologie_attivita.se_forfait,	
	attivita.id_tipologia_inps,
	attivita.id_anagrafica,
	attivita.id_mandante,
	attivita.id_cliente,
	attivita.id_luogo,
	attivita.id_indirizzo,
	indirizzi_view.__label__ as indirizzo,
	attivita.latitudine_ora_inizio,
	attivita.longitudine_ora_inizio,
	attivita.latitudine_ora_fine,
	attivita.longitudine_ora_fine,
	attivita.id_categoria_prodotti,
	attivita.data,
	attivita.data_attivita,
	attivita.ora,
	attivita.ora_inizio,
	attivita.ora_fine,
	coalesce( 
		attivita.data_programmazione, 
		todo.data_programmazione 
	) as data_programmazione,
	coalesce( 
		attivita.ora_inizio_programmazione, 
		todo.ora_inizio_programmazione 
	) as ora_inizio_programmazione,
	coalesce( 
		attivita.ora_fine_programmazione, 
		todo.ora_fine_programmazione 
	) as ora_fine_programmazione,
	todo.id_pianificazione,
	attivita.id_pratica,
	coalesce( 
		attivita.id_progetto, 
		todo.id_progetto 
	) as id_progetto,
	coalesce(
		attivita.referente,
		(SELECT GROUP_CONCAT( concat_ws( ' - ', anagrafica_view.__label__, anagrafica_view.telefoni ) SEPARATOR ' | ' ) 
			FROM anagrafica_view INNER JOIN progetti_anagrafica_view ON anagrafica_view.id = progetti_anagrafica_view.id_anagrafica WHERE progetti_anagrafica_view.se_responsabile_servizi=1 AND progetti_anagrafica_view.id_progetto = attivita.id_progetto),
		( SELECT GROUP_CONCAT( concat_ws( ' - ', anagrafica_view.__label__, anagrafica_view.telefoni ) SEPARATOR ' | ' ) 
			FROM anagrafica_view INNER JOIN progetti_anagrafica_view ON anagrafica_view.id = progetti_anagrafica_view.id_anagrafica WHERE progetti_anagrafica_view.se_responsabile_amministrativo=1 AND progetti_anagrafica_view.id_progetto = attivita.id_progetto
		),
		 ( SELECT GROUP_CONCAT( concat_ws( ' - ', anagrafica_view.__label__, anagrafica_view.telefoni ) SEPARATOR ' | ' ) 
			FROM anagrafica_view INNER JOIN progetti_anagrafica_view ON anagrafica_view.id = progetti_anagrafica_view.id_anagrafica WHERE progetti_anagrafica_view.se_responsabile_acquisti=1 AND progetti_anagrafica_view.id_progetto = attivita.id_progetto
		)
	) as referente,
	attivita.id_campagna,
	attivita.id_task,
	attivita.id_todo,
	attivita.id_tipologia_interesse,
	attivita.id_tipologia_soddisfazione,
	attivita.note_feedback,
	attivita.id_immobile,
	attivita.id_incarico,
	attivita.id_richiesta,
	attivita.id_incrocio_immobile,
	attivita.nome,
	coalesce(attivita.testo, todo.testo) as testo,
	coalesce(
		(SELECT group_concat( DISTINCT categorie_attivita_path( categorie_attivita.id ) SEPARATOR ' | ' ) FROM categorie_attivita INNER JOIN attivita_categorie ON categorie_attivita.id = attivita_categorie.id_categoria WHERE attivita_categorie.id_attivita = attivita.id),
		(SELECT group_concat( DISTINCT categorie_attivita_path( categorie_attivita.id ) SEPARATOR ' | ' ) FROM categorie_attivita INNER JOIN todo_categorie ON categorie_attivita.id = todo_categorie.id_categoria WHERE todo_categorie.id_todo = attivita.id_todo)
	) as categorie,
	group_concat( DISTINCT categorie_progetti_path( categorie_progetti.id ) SEPARATOR ' | ' ) AS categorie_progetto,
	attivita.timestamp_scadenza,
	coalesce( 
		attivita.data_scadenza, 
		todo.data_scadenza 
	) as data_scadenza,
	coalesce( 
		attivita.ora_scadenza, 
		todo.ora_scadenza 
	) as ora_scadenza,	
	attivita.note_scadenza,
	attivita.id_attivita_completamento,
	attivita.ore,
	attivita.id_esito,
	attivita.id_account_editor,
	attivita.id_account_inserimento,
	attivita.timestamp_inserimento,
	attivita.id_account_aggiornamento,
	attivita.timestamp_aggiornamento,	
	day( coalesce( data_attivita, data ) ) as giorno,
	month( coalesce( data_attivita, data ) ) as mese,
	year( coalesce( data_attivita, data ) ) as anno,
	progetti.nome AS progetto,
	task.nome AS task,
	task.ore_previste AS ore_previste_task,
	todo.nome AS todo,
	todo.ore_previste AS ore_previste_todo,
	tipologie_attivita_inps.nome AS tipologia_inps,
	tipologie_attivita.html AS icona_html,
	tipologie_attivita.font_awesome AS icona_fa,
	concat(coalesce(sede.nome, sede.denominazione),'/',pratiche.numero,'/', YEAR(pratiche.data_apertura)) AS pratica,
	coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.nome, ''),
		coalesce(anagrafica.cognome, '') ),
		''
	) AS anagrafica,
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
	LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
	LEFT JOIN progetti ON progetti.id = coalesce( attivita.id_progetto, todo.id_progetto )
	LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = attivita.id_progetto
	LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria
	LEFT JOIN anagrafica AS cliente ON cliente.id = coalesce( attivita.id_cliente, progetti.id_cliente, task.id_cliente, todo.id_cliente )
	LEFT JOIN anagrafica AS mandante ON mandante.id = attivita.id_mandante
	LEFT JOIN pratiche ON pratiche.id = attivita.id_pratica
    LEFT JOIN anagrafica AS sede ON sede.id = pratiche.id_sede_apertura
	LEFT JOIN indirizzi_view ON attivita.id_indirizzo = indirizzi_view.id
	
	ORDER BY attivita.data_attivita DESC, __label__ ASC
;