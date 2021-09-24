CREATE OR REPLACE VIEW `documenti_articoli_view` AS
    SELECT
    documenti_articoli.*,
    concat( documenti_articoli.nome, ' del ', documenti_articoli.data_lavorazione, ' per ',coalesce(
	clienti.soprannome,
	clienti.denominazione,
	concat_ws(' ', coalesce(clienti.cognome, ''),
	coalesce(clienti.nome, '') ),
	''
    ) ) AS __label__,
    tipologie.codice AS codice_tipologia,
    concat('riga di ', tipologie.nome) AS tipologia,
    coalesce(
	clienti.soprannome,
	clienti.denominazione,
	concat_ws(' ', coalesce(clienti.cognome, ''),
	coalesce(clienti.nome, '') ),
	''
    )  AS cliente,
    coalesce(
	emittenti.soprannome,
	emittenti.denominazione,
	concat_ws(' ', coalesce(emittenti.cognome, ''),
	coalesce(emittenti.nome, '') ),
	''
    )  AS emittente,
    concat( documenti.numero, '/', year( documenti.data ), ' del ', documenti.data ) AS  documento,
    reparti.nome AS reparto,
    articoli.nome AS articolo,
    udm.nome AS udm,
    iva.nome AS iva,
    iva.aliquota AS aliquota_iva,
    concat( 'MAT.',lpad(matricole.id, 11, '0') ) AS label_matricola,
    carico.nome AS mastro_carico,
    scarico.nome AS mastro_scarico,
    ROUND( documenti_articoli.importo_netto_totale * documenti_articoli. quantita * ( 100 + iva.aliquota )/ 100, 2 ) AS totale_riga
    FROM documenti_articoli
    LEFT JOIN anagrafica AS clienti ON clienti.id = documenti_articoli.id_destinatario
    LEFT JOIN anagrafica AS emittenti ON emittenti.id = documenti_articoli.id_emittente
    LEFT JOIN tipologie_documenti AS tipologie ON	tipologie.id = documenti_articoli.id_tipologia
    LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
    LEFT JOIN reparti ON reparti.id = documenti_articoli.id_reparto
    LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
    LEFT JOIN udm ON udm.id = documenti_articoli.id_udm
    LEFT JOIN iva ON iva.id = documenti_articoli.id_iva
    LEFT JOIN matricole ON matricole.id = documenti_articoli.matricola
    LEFT JOIN mastri AS scarico ON scarico.id = documenti_articoli.id_mastro_provenienza
    LEFT JOIN mastri AS carico ON carico.id = documenti_articoli.id_mastro_destinazione
    ORDER BY __label__
;

