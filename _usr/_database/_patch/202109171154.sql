CREATE OR REPLACE VIEW `attivita_scoperte_view` AS
	SELECT	
	attivita.id,
	attivita.id_tipologia,
	attivita.id_anagrafica,
	raa.id_anagrafica AS id_assente,
	coalesce(
		operatori.soprannome,
		operatori.denominazione,
		concat_ws(' ', coalesce(operatori.nome, ''),
		coalesce(operatori.cognome, '') ),
		''
	) AS assente,
	attivita.id_cliente,
	attivita.data_programmazione, 
	attivita.ora_inizio_programmazione,
	attivita.ora_fine_programmazione, 
	attivita.id_progetto, 
	attivita.nome,
	attivita.testo,
	day( coalesce( data_attivita, data ) ) as giorno,
	month( coalesce( data_attivita, data ) ) as mese,
	year( coalesce( data_attivita, data ) ) as anno,
	progetti.nome AS progetto,
	todo.nome AS todo,
	tipologie_attivita.nome AS tipologia,
	coalesce(
		cliente.soprannome,
		cliente.denominazione,
		concat_ws(' ', coalesce(cliente.cognome, ''),
		coalesce(cliente.nome, '') ),
		''
	) AS cliente,
	count( sostituzioni_attivita.id ) as richieste,
	concat( tipologie_attivita.nome, ' ', attivita.nome ) AS __label__
	FROM attivita
	LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia
	LEFT JOIN anagrafica ON anagrafica.id = attivita.id_anagrafica
	LEFT JOIN todo ON todo.id = attivita.id_todo
	LEFT JOIN progetti ON progetti.id = attivita.id_progetto
	LEFT JOIN anagrafica AS cliente ON cliente.id = attivita.id_cliente
	LEFT JOIN __report_attivita_assenze__ as raa ON attivita.id = raa.id_attivita
	LEFT JOIN anagrafica AS operatori ON raa.id_anagrafica = operatori.id
	LEFT JOIN sostituzioni_attivita ON sostituzioni_attivita.id_attivita = attivita.id
	WHERE attivita.id_anagrafica IS NULL
	GROUP BY attivita.id
	ORDER BY data_programmazione, ora_inizio_programmazione, __label__ ASC
;
