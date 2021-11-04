CREATE OR REPLACE VIEW `__report_mastri__` AS
    SELECT
    mastri.id,
    concat(COALESCE(clienti.nome,''), COALESCE(clienti.cognome,''), COALESCE(clienti.denominazione,'')) AS cliente,
    concat(COALESCE(emittenti.nome,''), COALESCE(emittenti.cognome,''), COALESCE(emittenti.denominazione,'')) AS emittente,
    documenti_articoli.id AS id_riga,
    documenti_articoli.id_articolo,
    documenti_articoli.id_tipologia,
    documenti_articoli.nome AS 'descrizione',
    documenti_articoli.quantita * -1  AS quantita,
    concat(valute.utf8, ' ' ,documenti_articoli.importo_netto_totale * -1) AS importo,
    listini.nome AS listino,
    documenti_articoli.data_lavorazione,
    documenti_articoli.id_destinatario,
    documenti_articoli.id_emittente,
    documenti_articoli.id_listino
    FROM mastri
    INNER JOIN documenti_articoli ON documenti_articoli.id_mastro_provenienza = mastri.id
    LEFT JOIN anagrafica AS clienti ON clienti.id = documenti_articoli.id_destinatario
    LEFT JOIN anagrafica AS emittenti ON emittenti.id = documenti_articoli.id_emittente
    LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
    LEFT JOIN valute ON valute.id = listini.id_valuta
    UNION
    SELECT
    mastri.id,
    concat(COALESCE(clienti.nome,''), COALESCE(clienti.cognome,''), COALESCE(clienti.denominazione,'')) AS cliente,
    concat(COALESCE(emittenti.nome,''), COALESCE(emittenti.cognome,''), COALESCE(emittenti.denominazione,'')) AS emittente,
    documenti_articoli.id AS id_riga,
    documenti_articoli.id_articolo,
    documenti_articoli.id_tipologia,
    documenti_articoli.nome AS 'descrizione',
    documenti_articoli.quantita,
    concat(valute.utf8, ' ' ,documenti_articoli.importo_netto_totale)  AS importo,
    listini.nome AS listino,
    documenti_articoli.data_lavorazione,
    documenti_articoli.id_destinatario,
    documenti_articoli.id_emittente,
    documenti_articoli.id_listino
    FROM mastri
    INNER JOIN documenti_articoli ON documenti_articoli.id_mastro_destinazione = mastri.id
    LEFT JOIN anagrafica AS clienti ON clienti.id = documenti_articoli.id_destinatario
    LEFT JOIN anagrafica AS emittenti ON emittenti.id = documenti_articoli.id_emittente
    LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
    LEFT JOIN valute ON valute.id = listini.id_valuta
;