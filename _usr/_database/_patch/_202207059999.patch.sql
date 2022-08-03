-- 
-- PATCH
--

--| 202207050010
CREATE OR REPLACE VIEW `corsi_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
				progetti.id_articolo,
		progetti.id_prodotto,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		if( progetti.data_accettazione > CURRENT_DATE(), 'futuro', if( progetti.data_chiusura > CURRENT_DATE(), 'attivo', 'concluso'  ) ) AS stato,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		group_concat( DISTINCT if( f.id, categorie_progetti_path( f.id ), null ) SEPARATOR ' | ' ) AS fasce,
		group_concat( DISTINCT if( d.id, categorie_progetti_path( d.id ), null ) SEPARATOR ' | ' ) AS discipline,
		group_concat( DISTINCT if( l.id, categorie_progetti_path( l.id ), null ) SEPARATOR ' | ' ) AS livelli,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			' dal ',
			coalesce( progetti.data_accettazione, '-' ),
			' al ',
			coalesce( progetti.data_chiusura, '-' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN categorie_progetti AS f ON f.id = progetti_categorie.id_categoria AND f.se_fascia = 1
		LEFT JOIN categorie_progetti AS d ON d.id = progetti_categorie.id_categoria AND d.se_disciplina = 1		
		LEFT JOIN categorie_progetti AS l ON l.id = progetti_categorie.id_categoria AND l.se_classe = 1
	WHERE tipologie_progetti.se_didattica = 1
	GROUP BY progetti.id
;

--| FINE