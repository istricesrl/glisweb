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
  coalesce( ( sum( carico ) - sum( scarico ) ), 0 ) AS totale
FROM (
SELECT
  mastri.id,
  mastri.nome,
  articoli.id AS id_articolo,
  articoli.nome AS articolo,
  matricole.id AS id_matricola,
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
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
  WHERE documenti_articoli.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  articoli.id AS id_articolo,
  articoli.nome AS articolo,
  matricole.id AS id_matricola,
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
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
  WHERE documenti_articoli.quantita IS NOT NULL
) AS movimenti
GROUP BY id, nome, id_articolo, articolo, id_matricola, matricola, data_scadenza;

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
  articoli.nome AS articolo,
  articoli.id AS id_articolo,
  matricole.matricola,
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
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
  WHERE documenti_articoli.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  articoli.nome AS articolo,
  articoli.id AS id_articolo,
  matricole.matricola,
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
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
  WHERE documenti_articoli.quantita IS NOT NULL
) AS movimenti;

--| FINE FILE
