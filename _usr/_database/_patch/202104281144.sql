CREATE OR REPLACE VIEW `progetti_scoperti_view` AS
	SELECT
	progetti.*,
	tipologie_progetti.nome AS tipologia,
	tipologie_progetti.se_scalare,
	tipologie_progetti.se_commessa,
	tipologie_crm.ordine,
	coalesce( clienti.soprannome, clienti.denominazione , concat( clienti.cognome, ' ', clienti.nome ), '' ) AS cliente,
	min( attivita_scoperte_view.data_programmazione ) as data_scopertura,
	group_concat( 
		DISTINCT attivita_scoperte_view.assente 
		SEPARATOR ' | ' 
	) AS assenti,
	progetti.nome AS __label__
	FROM progetti
	INNER JOIN attivita_scoperte_view ON progetti.id = attivita_scoperte_view.id_progetto
	LEFT JOIN anagrafica AS clienti ON clienti.id = progetti.id_cliente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
	LEFT JOIN tipologie_crm ON tipologie_crm.id = clienti.id_tipologia_crm
	GROUP BY progetti.id
	ORDER BY __label__
;
