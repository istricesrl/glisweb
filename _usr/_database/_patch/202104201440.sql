CREATE OR REPLACE VIEW `__report_mastri__` AS
    SELECT
    mastri.*,
    concat(COALESCE(clienti.nome,''), COALESCE(clienti.cognome,''), COALESCE(clienti.denominazione,'')) AS cliente,
    concat(COALESCE(emittenti.nome,''), COALESCE(emittenti.cognome,''), COALESCE(emittenti.denominazione,'')) AS emittente,
    documenti_articoli.id AS id_riga,
    documenti_articoli.id_articolo,
    documenti_articoli.id_tipologia,
    documenti_articoli.nome AS 'descrizione',
    documenti_articoli.quantita * -1 AS quantita,
    documenti_articoli.importo_netto_totale * -1 AS importo,
    documenti_articoli.data_lavorazione,
    documenti_articoli.id_destinatario,
    documenti_articoli.id_emittente
    FROM mastri
    INNER JOIN documenti_articoli ON documenti_articoli.id_mastro_provenienza = mastri.id
    LEFT JOIN anagrafica AS clienti ON clienti.id = documenti_articoli.id_destinatario
    LEFT JOIN anagrafica AS emittenti ON emittenti.id = documenti_articoli.id_emittente
    UNION
    SELECT
    mastri.*,
    concat(COALESCE(clienti.nome,''), COALESCE(clienti.cognome,''), COALESCE(clienti.denominazione,'')) AS cliente,
    concat(COALESCE(emittenti.nome,''), COALESCE(emittenti.cognome,''), COALESCE(emittenti.denominazione,'')) AS emittente,
    documenti_articoli.id AS id_riga,
    documenti_articoli.id_articolo,
    documenti_articoli.id_tipologia,
    documenti_articoli.nome AS 'descrizione',
    documenti_articoli.quantita,
    documenti_articoli.importo_netto_totale AS importo,
    documenti_articoli.data_lavorazione,
    documenti_articoli.id_destinatario,
    documenti_articoli.id_emittente
    FROM mastri
    INNER JOIN documenti_articoli ON documenti_articoli.id_mastro_destinazione = mastri.id
    LEFT JOIN anagrafica AS clienti ON clienti.id = documenti_articoli.id_destinatario
    LEFT JOIN anagrafica AS emittenti ON emittenti.id = documenti_articoli.id_emittente
;