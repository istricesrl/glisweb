--
-- PATCH
--

--| 202205160010
CREATE OR REPLACE VIEW `corsi_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
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
	WHERE tipologie_progetti.se_didattica = 1
	GROUP BY progetti.id
;


--| FINE FILE