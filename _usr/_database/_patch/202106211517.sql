CREATE OR REPLACE VIEW `documenti_articoli_view` AS
    SELECT
    documenti_articoli.*,
    concat( documenti_articoli.nome, ' del ', documenti_articoli.data_lavorazione, ' per ', concat(COALESCE(clienti.nome,''), COALESCE(clienti.cognome,''), COALESCE(clienti.denominazione,'')) ) AS __label__,
    tipologie.codice AS codice_tipologia,
    concat('riga di ', tipologie.nome) AS tipologia,
    concat(COALESCE(clienti.nome,''), COALESCE(clienti.cognome,''), COALESCE(clienti.denominazione,'')) AS cliente,
    concat(COALESCE(emittenti.nome,''), COALESCE(emittenti.cognome,''), COALESCE(emittenti.denominazione,'')) AS emittente,
    concat( documenti.numero, '/', year( documenti.data ), ' del ', documenti.data, ' | ', COALESCE(documenti.nome,'')   ) AS  documento,
    reparti.nome AS reparto,
    articoli.nome AS articolo,
    udm.nome AS udm,
    iva.nome AS iva,
    iva.aliquota AS aliquota_iva
    FROM documenti_articoli
    LEFT JOIN anagrafica AS clienti ON clienti.id = documenti_articoli.id_destinatario
    LEFT JOIN anagrafica AS emittenti ON emittenti.id = documenti_articoli.id_emittente
    LEFT JOIN tipologie_documenti AS tipologie ON	tipologie.id = documenti_articoli.id_tipologia
    LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
    LEFT JOIN reparti ON reparti.id = documenti_articoli.id_reparto
    LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
    LEFT JOIN udm ON udm.id = documenti_articoli.id_udm
    LEFT JOIN iva ON iva.id = documenti_articoli.id_iva
    ORDER BY __label__
;