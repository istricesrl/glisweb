CREATE OR REPLACE VIEW `progetti_scoperti_view` AS
	SELECT
	progetti.*,
	tipologie_progetti.nome AS tipologia,
	categorie_progetti.se_ordinario,
	categorie_progetti.se_straordinario,
	group_concat( DISTINCT categorie_progetti_path( categorie_progetti.id ) SEPARATOR ' | ' ) AS categorie,
	tipologie_crm.ordine,
	mastri.nome AS mastro_attivita_default,
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
	LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
	LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria
	LEFT JOIN mastri ON progetti.id_mastro_attivita_default = mastri.id
	WHERE progetti.se_cancellare IS NULL
	GROUP BY progetti.id
	ORDER BY __label__
;
