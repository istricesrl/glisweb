--
-- PATCH
--

--| 202205040001
CREATE OR REPLACE VIEW `articoli_view` AS
	SELECT
		articoli.id,
		articoli.id_prodotto,
		articoli.ordine,
		articoli.ean,
		articoli.isbn,
		articoli.id_reparto,
		articoli.id_taglia,
		articoli.id_colore,
		articoli.larghezza,
		articoli.lunghezza,
		articoli.altezza,
        articoli.id_udm_dimensioni,
		udm_dimensioni.sigla AS udm_dimensioni,
		articoli.peso,
        articoli.id_udm_peso,
		udm_peso.sigla AS udm_peso,
		articoli.volume,
        articoli.id_udm_volume,
		udm_volume.sigla AS udm_volume,
		articoli.capacita,
        articoli.id_udm_capacita,
		udm_capacita.sigla AS udm_capacita,
        articoli.durata,
        articoli.id_udm_durata,
		udm_durata.sigla AS udm_durata,
		concat_ws(
			' ',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS nome,
		group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS __label__
	FROM articoli
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = articoli.id_prodotto
	GROUP BY articoli.id
;

--| 202205040010
CREATE OR REPLACE VIEW `documenti_articoli_view` AS
    SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		documenti_articoli.data,
		documenti_articoli.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti_articoli.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti_articoli.id_reparto,
		documenti_articoli.id_progetto,
		documenti_articoli.id_todo,
		documenti_articoli.id_attivita,
		documenti_articoli.id_articolo,
				concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
		documenti_articoli.id_mastro_provenienza,
		mastri_path( m1.id ) AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		mastri_path( m2.id ) AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
		documenti_articoli.id_listino,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		concat( 'MAT.',lpad(matricole.id, 15, '0') ) AS matricola,
		matricole.data_scadenza,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat(
			documenti_articoli.data,
			' / ',
			tipologie_documenti.nome,
			' / ',
			documenti_articoli.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			documenti_articoli.nome,
			' / ',
			documenti_articoli.importo_netto_totale,
			' ',
			valute.utf8
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti_articoli.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti_articoli.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti_articoli.id_tipologia
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
		LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
;

--| 202205040020
CREATE OR REPLACE VIEW `__report_giacenza_magazzini__` AS
SELECT
  id,
  nome,
  id_articolo,
  articolo,
  id_matricola,
  matricola,
  data_scadenza,
  sum( carico ) AS carico,
  sum( scarico ) AS scarico,
  FORMAT(coalesce( ( sum( carico ) - sum( scarico ) ), 0 ), 2,'es_ES') AS totale,
  FORMAT(coalesce( ( sum( peso_carico ) - sum( peso_scarico ) ), 0 ), 2,'es_ES') AS peso,
  sigla_udm_peso
FROM (
SELECT
  mastri.id,
  mastri.nome,
  articoli.id AS id_articolo,
  				concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
  matricole.id AS id_matricola,
  matricole.matricola,
  matricole.data_scadenza,
  documenti.data,
  documenti.id_tipologia,
  tipologie_documenti.nome AS tipologia,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  documenti_articoli.id AS id_riga,
  coalesce( documenti_articoli.quantita, 0 ) AS carico,
  coalesce( articoli.peso, 0 ) * documenti_articoli.quantita AS peso_carico,
  0 AS scarico,
  0 AS peso_scarico,
  udm_peso.sigla AS sigla_udm_peso
FROM mastri
  LEFT JOIN documenti_articoli
    ON documenti_articoli.id_mastro_destinazione = mastri.id
      OR mastri_path_check( documenti_articoli.id_mastro_destinazione, mastri.id ) = 1
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = articoli.id_prodotto
  WHERE documenti_articoli.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  articoli.id AS id_articolo,
				concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
  matricole.id AS id_matricola,
  matricole.matricola,
  matricole.data_scadenza,
  documenti.data,
  documenti.id_tipologia,
  tipologie_documenti.nome AS tipologia,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  documenti_articoli.id AS id_riga,
  0 AS carico,
  0 AS peso_carico,
  coalesce( documenti_articoli.quantita, 0 ) AS scarico,
  coalesce( articoli.peso, 0 ) * documenti_articoli.quantita AS peso_scarico,
  udm_peso.sigla AS sigla_udm_peso
FROM mastri
  LEFT JOIN documenti_articoli
    ON documenti_articoli.id_mastro_provenienza = mastri.id
      OR mastri_path_check( documenti_articoli.id_mastro_provenienza, mastri.id ) = 1
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = articoli.id_prodotto
  WHERE documenti_articoli.quantita IS NOT NULL
) AS movimenti
GROUP BY id, nome, id_articolo, articolo, id_matricola, matricola, data_scadenza, sigla_udm_peso;

--| FINE FILE