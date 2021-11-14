CREATE OR REPLACE VIEW `attivita_view` AS
	SELECT	
	attivita.id,
	attivita.id_tipologia,
	tipologie_attivita.nome AS tipologia,
	attivita.id_tipologia_inps,
	tipologie_attivita_inps.nome AS tipologia_inps,
	attivita.id_anagrafica,
	coalesce(
		anagrafica.soprannome,
		anagrafica.denominazione,
		concat_ws(' ', coalesce(anagrafica.nome, ''),
		coalesce(anagrafica.cognome, '') ),
		''
	) AS anagrafica,
	attivita.id_cliente,
	coalesce(
		cliente.soprannome,
		cliente.denominazione,
		concat_ws(' ', coalesce(cliente.cognome, ''),
		coalesce(cliente.nome, '') ),
		''
	) AS cliente,
	attivita.id_luogo,
	attivita.id_indirizzo,
	concat( 
		if(indirizzi.descrizione not like '', concat (indirizzi.descrizione, ' - '), ''),
		indirizzi.indirizzo,
		if(indirizzi.civico not like '', concat (' ', indirizzi.civico), ''),
		if(indirizzi.cap not like '', concat (', ', indirizzi.cap), ''),
		if(indirizzi.localita not like '', concat (' ', indirizzi.localita), ''),
		if(indirizzi.id_comune is not null, concat (' ', comuni.nome, ' (', provincie.sigla, ')'), '')
	) as indirizzo,	
	attivita.latitudine_ora_inizio,
	attivita.longitudine_ora_inizio,
	attivita.latitudine_ora_fine,
	attivita.longitudine_ora_fine,
	attivita.id_categoria_prodotti,
	attivita.data_attivita,
	attivita.ora_inizio,
	attivita.ora_fine,
	attivita.token,
	attivita.data_programmazione, 
	attivita.ora_inizio_programmazione, 
	attivita.ora_fine_programmazione, 
	todo.id_pianificazione,
	attivita.id_progetto,
	progetti.nome AS progetto,
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
	) as referenti,
	attivita.id_campagna,
	attivita.id_todo,
	todo.nome AS todo,
	attivita.id_immobile,
	attivita.id_incarico,
	attivita.id_richiesta,
	attivita.nome,
	coalesce(attivita.testo, todo.testo) as testo,
	group_concat( DISTINCT categorie_progetti_path( categorie_progetti.id ) SEPARATOR ' | ' ) AS categorie_progetto,
	coalesce( 
		attivita.data_scadenza, 
		todo.data_scadenza 
	) as data_scadenza,
	coalesce( 
		attivita.ora_scadenza, 
		todo.ora_scadenza 
	) as ora_scadenza,	
	attivita.note_scadenza,
	attivita.ore,
	day( data_attivita ) as giorno,
	month( data_attivita ) as mese,
	year( data_attivita ) as anno,	
	attivita.id_mastro_provenienza,
	mp.nome AS mastro_provenienza,
	attivita.id_mastro_destinazione,
	md.nome AS mastro_destinazione,
	concat( tipologie_attivita.nome, ' ', attivita.nome ) AS __label__
	FROM attivita
	LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia
	LEFT JOIN tipologie_attivita_inps ON tipologie_attivita_inps.id = attivita.id_tipologia_inps
	LEFT JOIN anagrafica ON anagrafica.id = attivita.id_anagrafica
	LEFT JOIN todo ON todo.id = attivita.id_todo
	LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
	LEFT JOIN progetti ON progetti.id = attivita.id_progetto
	LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = attivita.id_progetto
	LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria
	LEFT JOIN anagrafica AS cliente ON cliente.id = attivita.id_cliente
	LEFT JOIN indirizzi ON attivita.id_indirizzo = indirizzi.id	
	LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
	LEFT JOIN provincie ON provincie.id = comuni.id_provincia
	LEFT JOIN mastri AS mp ON mp.id = attivita.id_mastro_provenienza
	LEFT JOIN mastri AS md ON md.id = attivita.id_mastro_destinazione
	GROUP BY attivita.id
	ORDER BY attivita.data_attivita DESC, __label__ ASC
;