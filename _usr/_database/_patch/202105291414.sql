CREATE OR REPLACE VIEW `progetti_produzione_view` AS
	SELECT
	progetti.*,
	tipologie_progetti.nome AS tipologia,
	categorie_progetti.se_ordinario,
	categorie_progetti.se_straordinario,
	group_concat( DISTINCT categorie_progetti_path( categorie_progetti.id ) SEPARATOR ' | ' ) AS categorie,
	tipologie_crm.ordine,
	if( progetti.timestamp_chiusura IS NOT NULL, 1, 0 ) AS chiuso,
	mastri.nome AS mastro_attivita_default,
	if( sum( if( task.id IS NOT NULL AND task.timestamp_completamento IS NULL, 1, 0 ) ), 1, 0 ) AS attivo,
	sum( if( task.id IS NOT NULL AND task.timestamp_completamento IS NULL, 1, 0 ) ) AS task_aperti,
	sum( if( task.id IS NOT NULL AND task.timestamp_completamento IS NOT NULL, 1, 0 ) ) AS task_chiusi,
	coalesce( anagrafica_cliente.soprannome, anagrafica_cliente.denominazione , concat( anagrafica_cliente.cognome, ' ', anagrafica_cliente.nome ), '' ) AS cliente,
	concat( 
		if(indirizzi.descrizione not like '', concat (indirizzi.descrizione, ' - '), ''),
		indirizzi.indirizzo,
		if(indirizzi.civico not like '', concat (' ', indirizzi.civico), ''),
		if(indirizzi.cap not like '', concat (', ', indirizzi.cap), ''),
		if(indirizzi.localita not like '', concat (' ', indirizzi.localita), ''),
		if(indirizzi.id_comune is not null, concat (' ', comuni.nome, ' (', provincie.sigla, ')'), '')
	) AS indirizzo,
	progetti.nome AS __label__
	FROM progetti
	LEFT JOIN task ON task.id_progetto = progetti.id
	LEFT JOIN anagrafica AS anagrafica_cliente ON anagrafica_cliente.id = progetti.id_cliente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
	LEFT JOIN tipologie_crm ON tipologie_crm.id = anagrafica_cliente.id_tipologia_crm
	LEFT JOIN indirizzi ON indirizzi.id = progetti.id_indirizzo
	LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
	LEFT JOIN provincie ON provincie.id = comuni.id_provincia
	LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
	LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria
	LEFT JOIN mastri ON progetti.id_mastro_attivita_default = mastri.id
	WHERE progetti.timestamp_accettazione IS NOT NULL OR progetti.data_accettazione IS NOT NULL AND progetti.se_cancellare IS NULL
	GROUP BY progetti.id
	ORDER BY __label__
;
