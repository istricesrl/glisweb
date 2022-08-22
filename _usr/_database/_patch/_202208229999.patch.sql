--
-- PATCH
--

--| 202208223010
CREATE OR REPLACE VIEW `prezzi_view` AS
	SELECT
		prezzi.id,
		prezzi.id_prodotto,
		prezzi.id_articolo,
		prezzi.prezzo,
		prezzi.id_listino,
		listini.nome AS listino,
		valute.iso4217 AS iso4217,
		valute.utf8 AS utf8,
		prezzi.id_iva,
		iva.descrizione AS iva,
		iva.aliquota AS aliquota,
		prezzi.id_account_inserimento,
		prezzi.id_account_aggiornamento,
		concat_ws(
			' ',
			prezzi.id_prodotto,
			prezzi.id_articolo,
			prezzi.prezzo,
			listini.nome,
			valute.iso4217,
			iva.descrizione
		) AS __label__
	FROM prezzi
		LEFT JOIN listini ON listini.id = prezzi.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN iva ON iva.id = prezzi.id_iva
;

--| 202208223020 
CREATE OR REPLACE VIEW `__report_movimenti_crediti__` AS
SELECT
  id,
  nome,
  articolo,
  id_articolo,
  data,
  id_tipologia,
  tipologia,
  documento,
  numero,
  id_riga,
  id_crediti,
  carico,
  scarico
FROM (
SELECT
  mastri.id,
  mastri.nome,
  concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			' ',
			articoli.nome
  ) AS articolo,
  articoli.id AS id_articolo,
  crediti.data,
  documenti.id_tipologia,
  tipologie_documenti.sigla AS tipologia,
  documenti.nome AS documento,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  documenti_articoli.id AS id_riga,
  crediti.id AS id_crediti,
  coalesce( crediti.quantita, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_destinazione = mastri.id OR mastri_path_check( crediti.id_mastro_destinazione, mastri.id ) = 1
  LEFT JOIN documenti_articoli ON documenti_articoli.id = crediti.id_documenti_articolo
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  WHERE crediti.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			' ',
			articoli.nome
  ) AS articolo,
  articoli.id AS id_articolo,
  crediti.data,
  documenti.id_tipologia,
  tipologie_documenti.sigla AS tipologia,
  documenti.nome AS documento,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  documenti_articoli.id AS id_riga,
  crediti.id AS id_crediti,
  0 AS carico,
  coalesce( crediti.quantita, 0 ) AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_provenienza = mastri.id OR mastri_path_check( crediti.id_mastro_provenienza, mastri.id ) = 1
  LEFT JOIN documenti_articoli ON documenti_articoli.id = crediti.id_documenti_articolo
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  WHERE crediti.quantita IS NOT NULL
) AS movimenti;


--| FINE