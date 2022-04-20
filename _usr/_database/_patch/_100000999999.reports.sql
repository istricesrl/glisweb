--
-- REPORT
-- questo file contiene le query per la creazione dei report
--

--| 100000020000
-- __report_giacenza_magazzini__
-- tipologia: report
DROP VIEW IF EXISTS `__report_giacenza_magazzini__`;

--| 100000020001
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
  coalesce( ( sum( carico ) - sum( scarico ) ), 0 ) AS totale,
  coalesce( ( sum( peso_carico ) - sum( peso_scarico ) ), 0 ) AS peso,
  sigla_udm_peso
FROM (
SELECT
  mastri.id,
  mastri.nome,
  articoli.id AS id_articolo,
  concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
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
  LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
  WHERE documenti_articoli.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  articoli.id AS id_articolo,
  concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
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
  LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
  WHERE documenti_articoli.quantita IS NOT NULL
) AS movimenti
GROUP BY id, nome, id_articolo, articolo, id_matricola, matricola, data_scadenza, sigla_udm_peso;

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
INNER JOIN contratti ON contratti.id_destinatario = anagrafica.id
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
INNER JOIN contratti ON contratti.id_destinatario = anagrafica.id
LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
INNER JOIN rinnovi ON rinnovi.id_contratto = contratti.id
INNER JOIN relazioni_progetti ON relazioni_progetti.id_progetto = contratti.id_progetto
INNER JOIN ruoli_progetti ON ruoli_progetti.id = relazioni_progetti.id_ruolo
WHERE tipologie_contratti.se_iscrizione = 1 AND ruoli_progetti.se_sottoprogetto = 1;

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
  numero,
  id_riga,
  carico,
  scarico
FROM (
SELECT
  mastri.id,
  mastri.nome,
  concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
  articoli.id AS id_articolo,
  matricole.matricola,
  matricole.data_scadenza,
  documenti.data,
  documenti.id_tipologia,
  tipologie_documenti.nome AS tipologia,
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
  WHERE documenti_articoli.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
  articoli.id AS id_articolo,
  matricole.matricola,
  matricole.data_scadenza,
  documenti.data,
  documenti.id_tipologia,
  tipologie_documenti.nome AS tipologia,
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
  WHERE documenti_articoli.quantita IS NOT NULL
) AS movimenti;

--| FINE FILE
