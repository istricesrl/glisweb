--
-- REPORT
-- questo file contiene le query per la creazione dei report
--

--| 100000007200
-- __report_status_contratti__
-- tipologia: report
DROP VIEW IF EXISTS `__report_status_contratti__`;

--| 100000007201
CREATE OR REPLACE VIEW `__report_status_contratti__` AS
  SELECT
    progetti.id,
    progetti.nome,
    tipologie_progetti_path( progetti.id_tipologia ) AS tipologia,
    coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
    count( DISTINCT td1.id ) AS backlog,
    count( DISTINCT td2.id ) AS sprint,
    count( DISTINCT td3.id ) AS fatto,
    coalesce( sum( at1.ore ), 0 ) AS ore_fatte,
    coalesce( m1.testo, '-' ) AS ore_mese,
    coalesce( ( m1.testo - sum( at1.ore ) ), '-' ) AS ore_residue
  FROM progetti
    LEFT JOIN todo AS td1 ON ( td1.id_progetto = progetti.id AND td1.data_programmazione IS NULL AND td1.settimana_programmazione IS NULL AND td1.data_chiusura IS NULL )
    LEFT JOIN todo AS td2 ON ( td2.id_progetto = progetti.id AND ( td2.data_programmazione IS NOT NULL OR td2.settimana_programmazione IS NOT NULL ) AND td2.data_chiusura IS NULL )
    LEFT JOIN todo AS td3 ON ( td3.id_progetto = progetti.id AND td3.data_chiusura IS NOT NULL )
    LEFT JOIN anagrafica AS a2 ON a2.id = progetti.id_cliente
    LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
    LEFT JOIN attivita AS at1 ON (
      at1.id_progetto = progetti.id
      AND
      at1.data_attivita BETWEEN
        DATE_SUB( LAST_DAY( NOW() ), INTERVAL DAY( LAST_DAY( NOW() ) ) - 1 DAY )
        AND
        last_day( now() )
    )
    LEFT JOIN metadati AS m1 ON ( m1.id_progetto = progetti.id AND m1.nome = 'contratto|monte_ore' )
  WHERE
    ( tipologie_progetti.se_contratto IS NOT NULL )
  GROUP BY progetti.id

--| 100000015000
-- __report_giacenza_crediti__
-- tipologia: report
DROP VIEW IF EXISTS `__report_giacenza_crediti__`;

--| 100000015001
CREATE OR REPLACE VIEW `__report_giacenza_crediti__` AS
SELECT
  movimenti.id,
  movimenti.id_account,
  movimenti.account,
  movimenti.nome,
  sum( movimenti.carico ) AS carico,
  sum( movimenti.scarico ) AS scarico,
  coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ) AS totale_float,
  format( coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2, 'es_ES' ) AS totale,
  concat_ws(
      ' ',
      movimenti.nome ,
      'giacenza',
      FORMAT( coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2, 'es_ES' ),
      'pz'
		) AS __label__
FROM (
SELECT
  mastri.id,
  mastri.id_account,
  account.username AS account,
  mastri_path( mastri.id ) AS nome,
  crediti.data,
  coalesce( crediti.quantita, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_destinazione = mastri.id OR mastri_path_check( crediti.id_mastro_destinazione, mastri.id ) = 1
  LEFT JOIN account ON account.id = mastri.id_account
WHERE crediti.quantita IS NOT NULL
UNION ALL
SELECT
  mastri.id,
  mastri.id_account,
  account.username AS account,
  mastri_path( mastri.id ) AS nome,
  crediti.data,
  0 AS carico,
  coalesce( crediti.quantita, 0 ) AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_provenienza = mastri.id OR mastri_path_check( crediti.id_mastro_provenienza, mastri.id ) = 1
  LEFT JOIN account ON account.id = mastri.id_account
WHERE crediti.quantita IS NOT NULL
) AS movimenti
GROUP BY movimenti.id, movimenti.id_account, movimenti.account, movimenti.nome;

--| 100000015010
-- __report_giacenza_ore__
-- tipologia: report
DROP VIEW IF EXISTS `__report_giacenza_ore__`;

--| 100000015011
CREATE OR REPLACE VIEW `__report_giacenza_ore__` AS
SELECT
  movimenti.id,
  movimenti.id_progetto,
  movimenti.progetto,
  movimenti.nome,
    count( DISTINCT td1.id ) AS backlog,
    count( DISTINCT td2.id ) AS sprint,
    count( DISTINCT td3.id ) AS fatto,
  sum( movimenti.carico ) AS carico,
  sum( movimenti.scarico ) AS scarico,
  coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ) AS totale_float,
  format( coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2, 'es_ES' ) AS totale,
  concat_ws(
      ' ',
      movimenti.nome ,
      'giacenza',
      FORMAT( coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2, 'es_ES' ),
      'h'
		) AS __label__
FROM (
SELECT
  mastri.id,
  mastri.id_progetto,
  progetti.nome AS progetto,
  mastri_path( mastri.id ) AS nome,
  attivita.data_attivita AS data,
  coalesce( attivita.ore, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN attivita ON attivita.id_mastro_destinazione = mastri.id OR mastri_path_check( attivita.id_mastro_destinazione, mastri.id ) = 1
  LEFT JOIN progetti ON progetti.id = mastri.id_progetto
WHERE attivita.ore IS NOT NULL
UNION ALL
SELECT
  mastri.id,
  mastri.id_progetto,
  progetti.nome AS progetto,
  mastri_path( mastri.id ) AS nome,
  attivita.data_attivita AS data,
  0 AS carico,
  coalesce( attivita.ore, 0 ) AS scarico
FROM mastri
  LEFT JOIN attivita ON attivita.id_mastro_provenienza = mastri.id OR mastri_path_check( attivita.id_mastro_provenienza, mastri.id ) = 1
  LEFT JOIN progetti ON progetti.id = mastri.id_progetto
WHERE attivita.ore IS NOT NULL
) AS movimenti
    LEFT JOIN todo AS td1 ON ( td1.id_progetto = movimenti.id_progetto AND td1.data_programmazione IS NULL AND td1.settimana_programmazione IS NULL AND td1.data_chiusura IS NULL AND td1.data_archiviazione IS NULL )
    LEFT JOIN todo AS td2 ON ( td2.id_progetto = movimenti.id_progetto AND ( td2.data_programmazione IS NOT NULL OR td2.settimana_programmazione IS NOT NULL ) AND ( td2.data_chiusura IS NULL AND td2.data_archiviazione IS NULL ) )
    LEFT JOIN todo AS td3 ON ( td3.id_progetto = movimenti.id_progetto AND td3.data_chiusura IS NOT NULL )
GROUP BY movimenti.id, movimenti.id_progetto, movimenti.progetto, movimenti.nome;

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
  movimenti.codice_produttore,
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
  prodotti.codice_produttore,
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
  prodotti.codice_produttore,
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
GROUP BY movimenti.id, movimenti.id_mastro, movimenti.nome, movimenti.id_articolo, movimenti.articolo, movimenti.id_prodotto, movimenti.prodotto, movimenti.codice_produttore, movimenti.id_matricola, movimenti.matricola, movimenti.data_scadenza, movimenti.sigla_udm_peso;

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
GROUP BY movimenti.id, movimenti.id_mastro, movimenti.nome, movimenti.id_articolo, movimenti.articolo, movimenti.id_prodotto, movimenti.prodotto, movimenti.id_matricola, movimenti.matricola, movimenti.data_scadenza, movimenti.sigla_udm_peso;

--| 100000020003
CREATE OR REPLACE VIEW `__report_giacenza_magazzini_foglie_attive__` AS
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
GROUP BY movimenti.id, movimenti.id_mastro, movimenti.nome, movimenti.id_articolo, movimenti.articolo, movimenti.id_prodotto, movimenti.prodotto, movimenti.id_matricola, movimenti.matricola, movimenti.data_scadenza, movimenti.sigla_udm_peso
HAVING totale > 0
;

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

--| 100000020910
-- __report_movimenti_ore__
-- tipologia: report
DROP VIEW IF EXISTS `__report_movimenti_ore__`;

--| 100000020911
-- __report_movimenti_ore__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_movimenti_ore__` AS
SELECT
  id,
  nome,
  id_progetto,
  progetto,
  data,
  id_attivita,
  attivita,
  id_todo,
  todo,
  carico,
  scarico
FROM (
SELECT
  mastri.id,
  mastri.nome,
  mastri.id_progetto,
  progetti.nome AS progetto,
  attivita.data_attivita AS data,
  attivita.id AS id_attivita,
  attivita.nome AS attivita,
  attivita.id_todo,
  todo.nome AS todo,
  coalesce( attivita.ore, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN attivita ON attivita.id_mastro_destinazione = mastri.id OR mastri_path_check( attivita.id_mastro_destinazione, mastri.id ) = 1
  LEFT JOIN todo ON todo.id = attivita.id_todo
  LEFT JOIN progetti ON progetti.id = mastri.id_progetto
  WHERE attivita.ore IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  mastri.id_progetto,
  progetti.nome AS progetto,
  attivita.data_attivita AS data,
  attivita.id AS id_attivita,
  attivita.nome AS attivita,
  attivita.id_todo,
  todo.nome AS todo,
  0 AS carico,
  coalesce( attivita.ore, 0 ) AS scarico
FROM mastri
  LEFT JOIN attivita ON attivita.id_mastro_provenienza = mastri.id OR mastri_path_check( attivita.id_mastro_provenienza, mastri.id ) = 1
  LEFT JOIN todo ON todo.id = attivita.id_todo
  LEFT JOIN progetti ON progetti.id = mastri.id_progetto
  WHERE attivita.ore IS NOT NULL
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
  group_concat( DISTINCT categorie_prodotti_path( id_categoria ) SEPARATOR ' | ' ) AS categorie,
  id_prodotto,
  prodotto,
  codice_produttore,
  id_articolo,
  articolo,
  matricola,
  data_scadenza,
  data,
  id_tipologia,
  tipologia,
  documento,
  numero,
  emittente,
  destinatario,
  id_riga,
  carico,
  mastro_carico,
  qta_carico,
  scarico,
  mastro_scarico,
  qta_scarico,
  udm_qta
FROM (
SELECT
  mastri.id,
  mastri_path( mastri.id ) AS nome,
  prodotti_categorie.id_categoria,
  prodotti.id AS id_prodotto,
  prodotti.nome AS prodotto,
  prodotti.codice_produttore,
  articoli.id AS id_articolo,
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
  matricole.matricola,
  matricole.data_scadenza,
  documenti.data,
  documenti.id_tipologia,
  tipologie_documenti.sigla AS tipologia,
  documenti.nome AS documento,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  concat_ws( ' ', a1.nome, a1.cognome, a1.denominazione ) AS emittente,
  concat_ws( ' ', a2.nome, a2.cognome, a2.denominazione ) AS destinatario,
  documenti_articoli.id AS id_riga,
  coalesce( documenti_articoli.quantita, 0 ) AS carico,
  0 AS scarico,
  ( coalesce( articoli.peso, articoli.volume, articoli.capacita, articoli.durata, 0 ) * coalesce( documenti_articoli.quantita, 1 ) ) AS qta_carico,
  0 AS qta_scarico,
  coalesce( udm_peso.sigla, udm_volume.sigla, udm_capacita.sigla, udm_durata.sigla ) AS udm_qta,
  mastri_path( documenti_articoli.id_mastro_destinazione ) AS mastro_carico,
  NULL AS mastro_scarico
FROM mastri
  LEFT JOIN documenti_articoli
    ON documenti_articoli.id_mastro_destinazione = mastri.id
      OR mastri_path_check( documenti_articoli.id_mastro_destinazione, mastri.id ) = 1
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
  LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
  LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
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
  mastri_path( mastri.id ) AS nome,
  prodotti_categorie.id_categoria,
  prodotti.id AS id_prodotto,
  prodotti.nome AS prodotto,
  prodotti.codice_produttore,
  articoli.id AS id_articolo,
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
  matricole.matricola,
  matricole.data_scadenza,
  documenti.data,
  documenti.id_tipologia,
  tipologie_documenti.sigla AS tipologia,
  documenti.nome AS documento,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  concat_ws( ' ', a1.nome, a1.cognome, a1.denominazione ) AS emittente,
  concat_ws( ' ', a2.nome, a2.cognome, a2.denominazione ) AS destinatario,
  documenti_articoli.id AS id_riga,
  0 AS carico,
  coalesce( documenti_articoli.quantita, 0 ) AS scarico,
  0 AS qta_carico,
  ( coalesce( articoli.peso, articoli.volume, articoli.capacita, articoli.durata, 0 ) * coalesce( documenti_articoli.quantita, 1 ) ) AS qta_scarico,
  coalesce( udm_peso.sigla, udm_volume.sigla, udm_capacita.sigla, udm_durata.sigla ) AS udm_qta,
  NULL AS mastro_carico,
  mastri_path( documenti_articoli.id_mastro_provenienza ) AS mastro_scarico
FROM mastri
  LEFT JOIN documenti_articoli
    ON documenti_articoli.id_mastro_provenienza = mastri.id
      OR mastri_path_check( documenti_articoli.id_mastro_provenienza, mastri.id ) = 1
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
  LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
  LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
  LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
  WHERE documenti_articoli.quantita IS NOT NULL
) AS movimenti
-- GROUP BY id, nome, id_prodotto, prodotto, codice_produttore, id_articolo, articolo, matricola, data_scadenza, data, id_tipologia, tipologia, documento, numero, emittente, destinatario, id_riga, carico, mastro_carico, qta_carico, scarico, mastro_scarico, qta_scarico, udm_qta;
GROUP BY id_riga;

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
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
    count( DISTINCT td1.id ) AS backlog,
    count( DISTINCT td2.id ) AS sprint,
    count( DISTINCT td3.id ) AS fatto,
    coalesce( concat( round( ( count( DISTINCT td3.id ) ) / ( count( DISTINCT td1.id ) + count( DISTINCT td2.id ) ), 2 ) * 100, '%' ), '-' ) AS completed,
    round( datediff( now(), progetti.data_accettazione ) / 7, 0 ) AS elapsed,
    coalesce( ( count( DISTINCT td3.id ) ) / round( datediff( now(), progetti.data_accettazione ) / 7, 0 ), 0 ) AS speed,
    coalesce( date_add( now(), interval ( ( count( DISTINCT td1.id ) + count( DISTINCT td2.id ) ) / ( coalesce( ( count( DISTINCT td3.id ) ) / round( datediff( now(), progetti.data_accettazione ) / 7, 0 ), 0 ) ) ) week ), '-' ) AS eta
  FROM progetti
    LEFT JOIN todo AS td1 ON ( td1.id_progetto = progetti.id AND td1.data_programmazione IS NULL AND td1.settimana_programmazione IS NULL AND td1.data_chiusura IS NULL )
    LEFT JOIN todo AS td2 ON ( td2.id_progetto = progetti.id AND ( td2.data_programmazione IS NOT NULL OR td2.settimana_programmazione IS NOT NULL ) AND td2.data_chiusura IS NULL )
    LEFT JOIN todo AS td3 ON ( td3.id_progetto = progetti.id AND td3.data_chiusura IS NOT NULL )
	LEFT JOIN anagrafica AS a2 ON a2.id = progetti.id_cliente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
  WHERE
  	( tipologie_progetti.se_progetto IS NOT NULL OR tipologie_progetti.se_forfait IS NOT NULL )
    AND
    progetti.data_accettazione IS NOT NULL
    AND
    progetti.data_chiusura IS NULL
  GROUP BY progetti.id

--| 100000027010
-- __report_avanzamento_trattative__
-- tipologia: report
DROP VIEW IF EXISTS `__report_avanzamento_trattative__`;

--| 100000027011
-- __report_avanzamento_trattative__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_avanzamento_trattative__` AS
  SELECT
    progetti.id,
    progetti.nome,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS account,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
    progetti.entrate_previste,
    progetti.costi_previsti,
    progetti.ore_previste,
    ( progetti.entrate_previste - progetti.costi_previsti ) AS margine_previsto,
    coalesce( max( at1.data_attivita ), '-' ) AS data_ultima_attivita,
    coalesce( min( at2.data_programmazione ), '-' ) AS data_prossima_attivita
  FROM progetti
	LEFT JOIN anagrafica AS a2 ON a2.id = progetti.id_cliente
	LEFT JOIN anagrafica AS a1 ON a1.id = a2.id_agente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
  LEFT JOIN attivita AS at1 ON ( at1.id_progetto = progetti.id AND at1.data_attivita IS NOT NULL )
  LEFT JOIN attivita AS at2 ON ( at2.id_progetto = progetti.id AND at2.data_attivita IS NULL AND at2.data_programmazione IS NOT NULL )
	WHERE progetti.data_accettazione IS NULL
		AND progetti.data_chiusura IS NULL
		AND progetti.data_archiviazione IS NULL
  GROUP BY progetti.id

--| 100000031510
-- __report_tesseramenti_anagrafica__
-- tipologia: report
DROP VIEW IF EXISTS `__report_tesseramenti_anagrafica__`;

--| 100000031511
-- __report_tesseramenti_anagrafica__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_tesseramenti_anagrafica__` AS
	SELECT
		rinnovi.id,
		rinnovi.id_tipologia,
    contratti_anagrafica.id_anagrafica,
		tipologie_rinnovi.nome AS tipologia,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		rinnovi.id_contratto,
		contratti.nome AS contratto,
		rinnovi.id_licenza,
		licenze.nome AS licenza,
		rinnovi.id_progetto,
		progetti.nome AS progetto,
		rinnovi.data_inizio,
		rinnovi.data_fine,
		rinnovi.codice,
		rinnovi.id_pianificazione,
		rinnovi.id_account_inserimento,
		rinnovi.id_account_aggiornamento,
		concat('rinnovo ', rinnovi.id, ' dal ',CONCAT_WS('-',rinnovi.data_inizio),' al ',CONCAT_WS('-',rinnovi.data_fine)) AS __label__
	FROM rinnovi
		LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = rinnovi.id_tipologia
		LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto 
    LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
    LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id
		LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza 
		LEFT JOIN progetti ON progetti.id = rinnovi.id_progetto
	;

--| 100000056610
-- __report_backlog_todo__
-- tipologia: report
DROP VIEW IF EXISTS `__report_backlog_todo__`;

--| 100000056611
-- __report_backlog_todo__
-- tipologia: report
-- NOTA: questo report è ancora da documentare
CREATE OR REPLACE VIEW `__report_backlog_todo__` AS
	SELECT
		todo.id,
		todo.id_tipologia,
		tipologie_todo.nome AS tipologia,
		tipologie_todo.se_agenda,
		todo.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		todo.id_cliente,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		todo.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		todo.id_luogo,
		luoghi_path( todo.id_luogo ) AS luogo,
		todo.data_scadenza,
		todo.ora_scadenza,
		todo.data_programmazione,
		todo.ora_inizio_programmazione,
		todo.ora_fine_programmazione,
		todo.anno_programmazione,
		todo.settimana_programmazione,
		todo.ore_programmazione,
		todo.data_chiusura,
		todo.nome,
		todo.id_contatto,
		todo.id_progetto,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			' cliente ',
			coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' )
		) AS progetto,    
		todo.id_pianificazione,
		todo.id_immobile,
		todo.data_archiviazione,
		todo.id_account_inserimento,
		todo.id_account_aggiornamento,
		concat(
			todo.nome,
			coalesce( concat( ' per ', a2.denominazione, concat( a2.cognome, ' ', a2.nome ) ), '' ),
			coalesce( concat( ' su ', todo.id_progetto, ' ', progetti.nome ), '' )
		) AS __label__
	FROM todo
		LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente
		LEFT JOIN indirizzi ON indirizzi.id = todo.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
		LEFT JOIN progetti ON progetti.id = todo.id_progetto
  WHERE ( todo.data_chiusura IS NULL AND todo.data_archiviazione IS NULL )
    AND coalesce( todo.data_programmazione, todo.settimana_programmazione ) IS NULL
--    AND tipologie_todo.se_produzione IS NOT NULL
;

--| 100000056612
-- __report_sprint_todo__
-- tipologia: report
DROP VIEW IF EXISTS `__report_sprint_todo__`;

--| 100000056613
-- __report_sprint_todo__
-- tipologia: report
-- NOTA: questo report è ancora da documentare
CREATE OR REPLACE VIEW `__report_sprint_todo__` AS
	SELECT
		todo.id,
		todo.id_tipologia,
		tipologie_todo.nome AS tipologia,
		tipologie_todo.se_agenda,
		todo.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		todo.id_cliente,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		todo.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		todo.id_luogo,
		luoghi_path( todo.id_luogo ) AS luogo,
		todo.data_scadenza,
		todo.ora_scadenza,
		todo.data_programmazione,
		todo.ora_inizio_programmazione,
		todo.ora_fine_programmazione,
		todo.anno_programmazione,
		todo.settimana_programmazione,
		todo.ore_programmazione,
		todo.data_chiusura,
		todo.nome,
		todo.id_contatto,
		todo.id_progetto,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			' cliente ',
			coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' )
		) AS progetto,
    tipologie_progetti.id AS id_tipologia_progetto,
    tipologie_progetti.nome AS tipologia_progetto,
    tipologie_progetti.se_pacchetto,
		todo.id_pianificazione,
		todo.id_immobile,
		todo.data_archiviazione,
		todo.id_account_inserimento,
		todo.id_account_aggiornamento,
		concat(
			todo.nome,
			coalesce( concat( ' per ', a2.denominazione, concat( a2.cognome, ' ', a2.nome ) ), '' ),
			coalesce( concat( ' su ', todo.id_progetto, ' ', progetti.nome ), '' )
		) AS __label__
	FROM todo
		LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente
		LEFT JOIN indirizzi ON indirizzi.id = todo.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
		LEFT JOIN progetti ON progetti.id = todo.id_progetto
    LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
  WHERE ( todo.data_chiusura IS NULL AND todo.data_archiviazione IS NULL )
    AND (
      (
        date_format( todo.data_programmazione, '%Y' ) = date_format( now(), '%Y' )
        AND
        date_format( todo.data_programmazione, '%u' ) <= date_format( now(), '%u' )
      )
      OR
      (
        date_format( todo.data_programmazione, '%Y' ) < date_format( now(), '%Y' )
      )
      OR
      (
        todo.anno_programmazione = date_format( now(), '%Y' )
        AND
        todo.settimana_programmazione <= date_format( now(), '%u' )
      )
      OR
      (
        todo.anno_programmazione < date_format( now(), '%Y' )
      )
    )
--    AND tipologie_todo.se_produzione IS NOT NULL
;

--| 100000056614
-- __report_planned_todo__
-- tipologia: report
DROP VIEW IF EXISTS `__report_planned_todo__`;

--| 100000056615
-- __report_planned_todo__
-- tipologia: report
-- NOTA: questo report è ancora da documentare
CREATE OR REPLACE VIEW `__report_planned_todo__` AS
	SELECT
		todo.id,
		todo.id_tipologia,
		tipologie_todo.nome AS tipologia,
		tipologie_todo.se_agenda,
		todo.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		todo.id_cliente,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		todo.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		todo.id_luogo,
		luoghi_path( todo.id_luogo ) AS luogo,
		todo.data_scadenza,
		todo.ora_scadenza,
		todo.data_programmazione,
		todo.ora_inizio_programmazione,
		todo.ora_fine_programmazione,
		todo.anno_programmazione,
		todo.settimana_programmazione,
		todo.ore_programmazione,
		todo.data_chiusura,
		todo.nome,
		todo.id_contatto,
		todo.id_progetto,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			' cliente ',
			coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' )
		) AS progetto,    
		todo.id_pianificazione,
		todo.id_immobile,
		todo.data_archiviazione,
		todo.id_account_inserimento,
		todo.id_account_aggiornamento,
		concat(
			todo.nome,
			coalesce( concat( ' per ', a2.denominazione, concat( a2.cognome, ' ', a2.nome ) ), '' ),
			coalesce( concat( ' su ', todo.id_progetto, ' ', progetti.nome ), '' )
		) AS __label__
	FROM todo
		LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente
		LEFT JOIN indirizzi ON indirizzi.id = todo.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
		LEFT JOIN progetti ON progetti.id = todo.id_progetto
  WHERE ( todo.data_chiusura IS NULL AND todo.data_archiviazione IS NULL )
    AND (
      (
        date_format( todo.data_programmazione, '%Y' ) = date_format( now(), '%Y' )
        AND
        date_format( todo.data_programmazione, '%u' ) > date_format( now(), '%u' )
      )
      OR
      (
        date_format( todo.data_programmazione, '%Y' ) > date_format( now(), '%Y' )
      )
      OR
      (
        todo.anno_programmazione = date_format( now(), '%Y' )
        AND
        todo.settimana_programmazione > date_format( now(), '%u' )
      )
      OR
      (
        todo.anno_programmazione > date_format( now(), '%Y' )
      )
    )
--    AND tipologie_todo.se_produzione IS NOT NULL
;

--| 100000056618
-- __report_done_todo__
-- tipologia: report
DROP VIEW IF EXISTS `__report_done_todo__`;

--| 100000056619
-- __report_done_todo__
-- tipologia: report
-- NOTA: questo report è ancora da documentare
CREATE OR REPLACE VIEW `__report_done_todo__` AS
	SELECT
		todo.id,
		todo.id_tipologia,
		tipologie_todo.nome AS tipologia,
		tipologie_todo.se_agenda,
		todo.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		todo.id_cliente,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		todo.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		todo.id_luogo,
		luoghi_path( todo.id_luogo ) AS luogo,
		todo.data_scadenza,
		todo.ora_scadenza,
		todo.data_programmazione,
		todo.ora_inizio_programmazione,
		todo.ora_fine_programmazione,
		todo.anno_programmazione,
		todo.settimana_programmazione,
		todo.ore_programmazione,
		todo.data_chiusura,
		todo.nome,
		todo.id_contatto,
		todo.id_progetto,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			' cliente ',
			coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' )
		) AS progetto,    
		todo.id_pianificazione,
		todo.id_immobile,
		todo.data_archiviazione,
		todo.id_account_inserimento,
		todo.id_account_aggiornamento,
		concat(
			todo.nome,
			coalesce( concat( ' per ', a2.denominazione, concat( a2.cognome, ' ', a2.nome ) ), '' ),
			coalesce( concat( ' su ', todo.id_progetto, ' ', progetti.nome ), '' )
		) AS __label__
	FROM todo
		LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente
		LEFT JOIN indirizzi ON indirizzi.id = todo.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
		LEFT JOIN progetti ON progetti.id = todo.id_progetto
  WHERE ( todo.data_chiusura IS NOT NULL AND todo.data_archiviazione IS NULL )
--    AND tipologie_todo.se_produzione IS NOT NULL
;

--| FINE FILE
