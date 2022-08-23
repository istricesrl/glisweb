--
-- REPORT
-- questo file contiene le query per la creazione dei report
--

--| 100000015000
-- __report_giacenza_crediti__
-- tipologia: report
DROP VIEW IF EXISTS `__report_giacenza_crediti__`;

--| 100000015001
CREATE OR REPLACE VIEW `__report_giacenza_crediti__` AS
SELECT
  movimenti.id,
  movimenti.id_mastro,
  movimenti.id_account,
  movimenti.nome,
  sum( movimenti.carico ) AS carico,
  sum( movimenti.scarico ) AS scarico,
  format( coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2,'es_ES' ) AS totale,
  concat_ws(
      ' ',
      movimenti.nome ,
      'giacenza',
      FORMAT(coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2,'es_ES'),
      'pz'
		) AS __label__
FROM (
SELECT
  mastri.id,
  mastri.id AS id_mastro,
  mastri.id_account,
  mastri_path( mastri.id ) AS nome,
  crediti.data,
  coalesce( crediti.quantita, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_destinazione = mastri.id OR mastri_path_check( crediti.id_mastro_destinazione, mastri.id ) = 1
  WHERE crediti.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.id AS id_mastro,
  mastri.id_account,
  mastri_path( mastri.id ) AS nome,
  crediti.data,
  0 AS carico,
  coalesce( crediti.quantita, 0 ) AS scarico
FROM mastri
LEFT JOIN crediti ON crediti.id_mastro_provenienza = mastri.id OR mastri_path_check( crediti.id_mastro_provenienza, mastri.id ) = 1
  WHERE crediti.quantita IS NOT NULL
) AS movimenti
GROUP BY movimenti.id, movimenti.id_mastro, movimenti.id_account, movimenti.nome;

--| 100000020000
-- __report_giacenza_magazzini__
-- tipologia: report
DROP VIEW IF EXISTS `__report_giacenza_magazzini__`;

--| 100000020001
CREATE OR REPLACE VIEW `__report_giacenza_magazzini__` AS
SELECT
  concat_ws( '|', movimenti.id, movimenti.id_articolo, movimenti.id_matricola ) AS id,
  movimenti.id_mastro,
  movimenti.nome,
  movimenti.id_articolo,
  movimenti.articolo,
  movimenti.id_prodotto,
  movimenti.prodotto,
  group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
  movimenti.id_matricola,
  movimenti.matricola,
  movimenti.data_scadenza,
  sum( movimenti.carico ) AS carico,
  sum( movimenti.scarico ) AS scarico,
  FORMAT(coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2,'es_ES') AS totale,
  FORMAT(coalesce( ( sum( movimenti.peso_carico ) - sum( movimenti.peso_scarico ) ), 0 ), 2,'es_ES') AS peso,
  movimenti.sigla_udm_peso,
		concat_ws(
			' ',
      group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ),
			movimenti.articolo,
			concat( 'scad. ', movimenti.data_scadenza ),
      concat( 'matr. ', movimenti.matricola ),
      'da',
      movimenti.nome,
      'giacenza',
      FORMAT(coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2,'es_ES'),
      'pz'
		) AS __label__
FROM (
SELECT
  mastri.id,
  mastri.id AS id_mastro,
  mastri_path( mastri.id ) AS nome,
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
					' ',
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					' ',
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					' ',
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					' ',
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					' ',
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
articoli.id_prodotto AS id_prodotto,
prodotti.nome AS prodotto,
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
  AND documenti_articoli.id_articolo IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.id AS id_mastro,
  mastri_path( mastri.id ) AS nome,
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
					' ',
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					' ',
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					' ',
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					' ',
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					' ',
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
		articoli.id_prodotto AS id_prodotto,
prodotti.nome AS prodotto,
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
  AND documenti_articoli.id_articolo IS NOT NULL
) AS movimenti
LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = movimenti.id_prodotto
GROUP BY movimenti.id, movimenti.nome, movimenti.id_articolo, movimenti.articolo, movimenti.id_prodotto, movimenti.prodotto, movimenti.id_matricola, movimenti.matricola, movimenti.data_scadenza, movimenti.sigla_udm_peso;

--| 100000020002
CREATE OR REPLACE VIEW `__report_giacenza_magazzini_foglie__` AS
SELECT
  concat_ws( '|', movimenti.id, movimenti.id_articolo, movimenti.id_matricola ) AS id,
  movimenti.id_mastro,
  movimenti.nome,
  movimenti.id_articolo,
  movimenti.articolo,
  movimenti.id_prodotto,
  movimenti.prodotto,
  group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
  movimenti.id_matricola,
  movimenti.matricola,
  movimenti.data_scadenza,
  sum( movimenti.carico ) AS carico,
  sum( movimenti.scarico ) AS scarico,
  FORMAT(coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2,'es_ES') AS totale,
  FORMAT(coalesce( ( sum( movimenti.peso_carico ) - sum( movimenti.peso_scarico ) ), 0 ), 2,'es_ES') AS peso,
  movimenti.sigla_udm_peso,
		concat_ws(
			' ',
      group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ),
			movimenti.articolo,
			concat( 'scad. ', movimenti.data_scadenza ),
      concat( 'matr. ', movimenti.matricola ),
      'da',
      movimenti.nome,
      'giacenza',
      FORMAT(coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2,'es_ES'),
      'pz'
		) AS __label__
FROM (
SELECT
  mastri.id,
  mastri.id AS id_mastro,
  mastri_path( mastri.id ) AS nome,
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
					' ',
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					' ',
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					' ',
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					' ',
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					' ',
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
articoli.id_prodotto AS id_prodotto,
prodotti.nome AS prodotto,
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
  AND documenti_articoli.id_articolo IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.id AS id_mastro,
  mastri_path( mastri.id ) AS nome,
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
					' ',
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					' ',
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					' ',
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					' ',
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					' ',
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
		articoli.id_prodotto AS id_prodotto,
prodotti.nome AS prodotto,
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
  AND documenti_articoli.id_articolo IS NOT NULL
) AS movimenti
LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = movimenti.id_prodotto
GROUP BY movimenti.id, movimenti.nome, movimenti.id_articolo, movimenti.articolo, movimenti.id_prodotto, movimenti.prodotto, movimenti.id_matricola, movimenti.matricola, movimenti.data_scadenza, movimenti.sigla_udm_peso;

--| 100000020500

-- __report_immagini_da_scalare__
-- tipologia: report
DROP TABLE IF EXISTS `__report_immagini_da_scalare__`;

--| 100000020501
-- __report_immagini_da_scalare__
-- tipologia: report
CREATE OR REPLACE VIEW __report_immagini_da_scalare__ AS
	SELECT immagini.* FROM immagini
	INNER JOIN ruoli_immagini ON ruoli_immagini.id = immagini.id_ruolo
	WHERE ( immagini.timestamp_scalamento IS NULL OR immagini.timestamp_scalamento < immagini.timestamp_aggiornamento OR immagini.timestamp_aggiornamento IS NULL )
	ORDER BY immagini.timestamp_scalamento ASC, ruoli_immagini.ordine_scalamento ASC, immagini.ordine ASC
;

--| 100000020550

-- __report_immagini_scalate__
-- tipologia: report
DROP TABLE IF EXISTS `__report_immagini_scalate__`;

--| 100000020551

-- __report_immagini_scalate__
-- tipologia: report
CREATE OR REPLACE VIEW __report_immagini_scalate__ AS
SELECT
	sum(
	if( 
		( timestamp_scalamento IS NOT NULL OR timestamp_scalamento >= timestamp_aggiornamento )
		AND timestamp_aggiornamento IS NOT NULL, 1, 0) 
	) AS scalate,
	sum(
	if(
		timestamp_scalamento IS NULL OR timestamp_scalamento < timestamp_aggiornamento OR timestamp_aggiornamento IS NULL, 1, 0)
	) AS da_scalare,
	count(
		immagini.id
	) AS totali
FROM
	immagini
;

--| 100000020700

-- __report_iscritti_corsi__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_iscritti_corsi__` AS
SELECT
	anagrafica.id AS id_anagrafica,
	coalesce(anagrafica.soprannome,anagrafica.denominazione, concat_ws(' ', coalesce(anagrafica.cognome, ''),coalesce(anagrafica.nome, '') ),'') AS anagrafica,
	contratti.id_progetto,
	rinnovi.data_inizio,
	rinnovi.data_fine,
	rinnovi.id_contratto
FROM anagrafica
INNER JOIN contratti_anagrafica ON contratti_anagrafica.id_anagrafica = anagrafica.id	
INNER JOIN contratti ON contratti.id = contratti_anagrafica.id_contratto 
LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
INNER JOIN rinnovi ON rinnovi.id_contratto = contratti.id
INNER JOIN progetti ON progetti.id = contratti.id_progetto
WHERE tipologie_contratti.se_iscrizione = 1  
UNION
SELECT
	anagrafica.id AS id_anagrafica,
	coalesce(anagrafica.soprannome,anagrafica.denominazione, concat_ws(' ', coalesce(anagrafica.cognome, ''),coalesce(anagrafica.nome, '') ),'') AS anagrafica,
	relazioni_progetti.id_progetto_collegato AS id_progetto,
	rinnovi.data_inizio,
	rinnovi.data_fine,
	rinnovi.id_contratto
FROM anagrafica
INNER JOIN contratti_anagrafica ON contratti_anagrafica.id_anagrafica = anagrafica.id	
INNER JOIN contratti ON contratti.id = contratti_anagrafica.id_contratto 
LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
INNER JOIN rinnovi ON rinnovi.id_contratto = contratti.id
INNER JOIN relazioni_progetti ON relazioni_progetti.id_progetto = contratti.id_progetto
INNER JOIN ruoli_progetti ON ruoli_progetti.id = relazioni_progetti.id_ruolo
WHERE tipologie_contratti.se_iscrizione = 1 AND ruoli_progetti.se_sottoprogetto = 1;

--| 100000020900
-- __report_movimenti_crediti__
-- tipologia: report
DROP VIEW IF EXISTS `__report_movimenti_crediti__`;

--| 100000020901
-- __report_movimenti_crediti__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_movimenti_crediti__` AS
SELECT
  id,
  nome,
  id_account,
  data,
  id_crediti,
  carico,
  scarico
FROM (
SELECT
  mastri.id,
  mastri.nome,
  mastri.id_account,
  crediti.data,
  crediti.id AS id_crediti,
  coalesce( crediti.quantita, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_destinazione = mastri.id OR mastri_path_check( crediti.id_mastro_destinazione, mastri.id ) = 1
  WHERE crediti.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  mastri.id_account,
  crediti.data,
  crediti.id AS id_crediti,
  0 AS carico,
  coalesce( crediti.quantita, 0 ) AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_provenienza = mastri.id OR mastri_path_check( crediti.id_mastro_provenienza, mastri.id ) = 1
  WHERE crediti.quantita IS NOT NULL
) AS movimenti;

--| 100000021000
-- __report_movimenti_magazzini__
-- tipologia: report
DROP VIEW IF EXISTS `__report_movimenti_magazzini__`;

--| 100000021001
-- __report_movimenti_magazzini__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_movimenti_magazzini__` AS
SELECT
  id,
  nome,
  articolo,
  id_articolo,
  matricola,
  data_scadenza,
  data,
  id_tipologia,
  tipologia,
  documento,
  numero,
  id_riga,
  carico,
  scarico
FROM (
SELECT
  mastri.id,
  mastri.nome,
  concat_ws(
			' ',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
          ' ',
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
          ' ',
					udm_peso.sigla
				),
				concat(
					articoli.volume,
          ' ',
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
          ' ',
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
          ' ',
					udm_durata.sigla
				),
				''
			)
		)AS articolo,
  articoli.id AS id_articolo,
  matricole.matricola,
  matricole.data_scadenza,
  documenti.data,
  documenti.id_tipologia,
  tipologie_documenti.sigla AS tipologia,
  documenti.nome AS documento,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  documenti_articoli.id AS id_riga,
  coalesce( documenti_articoli.quantita, 0 ) AS carico,
  0 AS scarico
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
  WHERE documenti_articoli.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  concat_ws(
			' ',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
          ' ',
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
          ' ',
					udm_peso.sigla
				),
				concat(
					articoli.volume,
          ' ',
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
          ' ',
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
          ' ',
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
  articoli.id AS id_articolo,
  matricole.matricola,
  matricole.data_scadenza,
  documenti.data,
  documenti.id_tipologia,
  tipologie_documenti.sigla AS tipologia,
  documenti.nome AS documento,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  documenti_articoli.id AS id_riga,
  0 AS carico,
  coalesce( documenti_articoli.quantita, 0 ) AS scarico
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
  WHERE documenti_articoli.quantita IS NOT NULL
) AS movimenti;

--| 100000022700
-- __report_evasione_ordini__
-- tipologia: report
DROP VIEW IF EXISTS `__report_evasione_ordini__`;

--| 100000022701
-- __report_evasione_ordini__
-- tipologia: report
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

--| 100000027000
-- __report_avanzamento_progetti__
-- tipologia: report
DROP VIEW IF EXISTS `__report_avanzamento_progetti__`;

--| 100000027001
-- __report_avanzamento_progetti__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_avanzamento_progetti__` AS
  SELECT
    progetti.id,
    progetti.nome,
    count( DISTINCT td1.id ) AS backlog,
    count( DISTINCT td2.id ) AS sprint,
    count( DISTINCT td3.id ) AS fatto,
    round( datediff( now(), progetti.data_accettazione ) / 7, 0 ) AS elapsed,
    coalesce( ( count( DISTINCT td3.id ) ) / round( datediff( now(), progetti.data_accettazione ) / 7, 0 ), 0 ) AS speed,
    coalesce( date_add( now(), interval ( ( count( DISTINCT td1.id ) + count( DISTINCT td2.id ) ) / ( coalesce( ( count( DISTINCT td3.id ) ) / round( datediff( now(), progetti.data_accettazione ) / 7, 0 ), 0 ) ) ) week ), '-' ) AS eta
  FROM progetti
    LEFT JOIN todo AS td1 ON ( td1.id_progetto = progetti.id AND td1.data_programmazione IS NULL AND td1.settimana_programmazione IS NULL AND td1.data_chiusura IS NULL )
    LEFT JOIN todo AS td2 ON ( td2.id_progetto = progetti.id AND ( td2.data_programmazione IS NOT NULL OR td2.settimana_programmazione IS NOT NULL ) AND td1.data_chiusura IS NULL )
    LEFT JOIN todo AS td3 ON ( td3.id_progetto = progetti.id AND td3.data_chiusura IS NOT NULL )
  GROUP BY progetti.id

--| FINE FILE
