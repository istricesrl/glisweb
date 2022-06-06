--
-- PATCH
--

--| 202206060010
ALTER TABLE documenti ADD COLUMN `note_invio` text DEFAULT NULL AFTER `note_cliente`;

--| 202206060020
CREATE OR REPLACE VIEW `__report_evasione_ordini__` AS
SELECT
  ordine.id_documento,
  ordine.id_ordine,
  ordine.codice_prodotto,
  ordine.prodotto,
  sum( ( ordine.quantita_ordinata / udm.conversione ) ) AS quantita_ordinata,
  sum( ( ordine.quantita_evasa / udm.conversione ) ) AS quantita_evasa,
  (
    sum( ( ordine.quantita_ordinata / udm.conversione ) )
    -
    sum( ( ordine.quantita_evasa / udm.conversione ) )
  ) AS quantita_da_evadere,
  udm.sigla AS udm
FROM (
  SELECT
    relazioni_documenti.id_documento,
    documenti.id AS id_ordine,
    coalesce(
      documenti_articoli.id_prodotto,
      articoli.id_prodotto
    ) AS codice_prodotto,
    prodotti.nome AS prodotto,
    documenti_articoli.id_articolo AS codice_articolo,
    coalesce( ( documenti_articoli.quantita * udm.conversione ), 0 ) AS quantita_ordinata,
    0 AS quantita_evasa,
    udm_base.sigla AS udm_base,
    udm.id AS id_udm
  FROM documenti
  LEFT JOIN relazioni_documenti ON relazioni_documenti.id_documento_collegato = documenti.id
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = coalesce( documenti_articoli.id_prodotto, articoli.id_prodotto )
  LEFT JOIN udm ON udm.id = documenti_articoli.id_udm
  LEFT JOIN udm AS udm_base ON udm_base.id = udm.id_base
  WHERE tipologie_documenti.se_ordine IS NOT NULL
  HAVING codice_prodotto IS NOT NULL
  UNION
  SELECT
    relazioni_documenti.id_documento,
    relazioni_documenti.id_documento_collegato AS id_ordine,
    coalesce(
      documenti_articoli.id_prodotto,
      articoli.id_prodotto
    ) AS codice_prodotto,
    prodotti.nome AS prodotto,
    documenti_articoli.id_articolo AS codice_articolo,
    0 AS quantita_ordinata,
    coalesce( ( articoli.peso * udm.conversione * documenti_articoli.quantita ), 0 ) AS quantita_evasa,
    udm_base.sigla AS udm_base,
    udm.id AS id_udm
  FROM documenti
  INNER JOIN relazioni_documenti ON id_documento = documenti.id
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = coalesce( documenti_articoli.id_prodotto, articoli.id_prodotto )
  LEFT JOIN udm ON udm.id = articoli.id_udm_peso
  LEFT JOIN udm AS udm_base ON udm_base.id = udm.id_base
  WHERE tipologie_documenti.se_trasporto IS NOT NULL
  HAVING codice_prodotto IS NOT NULL
) AS ordine
LEFT JOIN udm ON udm.id = (
  SELECT coalesce( max( documenti_articoli.id_udm ), max( articoli.id_udm_peso ) )
  FROM documenti_articoli LEFT JOIN articoli ON articoli.id = ordine.codice_articolo
  WHERE documenti_articoli.id_documento IN ( ordine.id_documento, ordine.id_ordine )
  AND ( documenti_articoli.id_prodotto = ordine.codice_prodotto OR articoli.id = ordine.codice_articolo )
)
GROUP BY id_documento, id_ordine, codice_prodotto, prodotto, conversione, udm;

--| 202206060030
CREATE OR REPLACE VIEW `matricole_view` AS
	SELECT
		matricole.id,
		matricole.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		matricole.id_marchio,
		marchi.nome AS marchio,
		matricole.id_articolo,
		concat_ws(
			' ',
			articoli.id,
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
		matricole.matricola,
		matricole.data_scadenza,
		matricole.nome,
		concat_ws(
			' ',
			matricole.matricola,
			'/',
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
			),
			concat( 'scad. ', matricole.data_scadenza )
		) AS __label__
	FROM matricole
		LEFT JOIN anagrafica AS a1 ON a1.id = matricole.id_produttore
		LEFT JOIN marchi ON marchi.id = matricole.id_marchio
		LEFT JOIN articoli ON articoli.id = id_articolo
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

--| 202206060040
CREATE OR REPLACE VIEW `__report_avanzamento_progetti__` AS
	SELECT
		progetti.id,
		count( td1.id ) AS backlog,
		count( td2.id ) AS sprint,
		count( td3.id ) AS fatto,
		round( datediff( now(), progetti.data_accettazione ) / 7, 0 ) AS elapsed,
		coalesce( ( count( td3.id ) ) / round( datediff( now(), progetti.data_accettazione ) / 7, 0 ), 0 ) AS speed,
		coalesce(
			date_add( now(), interval ( ( count( td1.id ) + count( td2.id ) ) / ( coalesce( ( count( td3.id ) ) / round( datediff( now(), progetti.data_accettazione ) / 7, 0 ), 0 ) ) ) week ),
			'-'
		) AS eta
	FROM progetti
		LEFT JOIN todo AS td1 ON ( td1.id_progetto = progetti.id AND td1.data_programmazione IS NULL AND td1.settimana_programmazione IS NULL AND td1.data_chiusura IS NULL )
		LEFT JOIN todo AS td2 ON ( td2.id_progetto = progetti.id AND ( td2.data_programmazione IS NOT NULL OR td2.settimana_programmazione IS NOT NULL ) AND td1.data_chiusura IS NULL )
		LEFT JOIN todo AS td3 ON ( td3.id_progetto = progetti.id AND td3.data_chiusura IS NOT NULL )
	GROUP BY progetti.id;

--| FINE