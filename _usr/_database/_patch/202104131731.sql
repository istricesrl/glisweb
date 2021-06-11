CREATE OR REPLACE VIEW `__report_mastri__` AS
    SELECT
    mastri.*,
    documenti_articoli.id AS id_riga,
    documenti_articoli.nome AS descrizione,
    documenti_articoli.quantita * -1 AS quantita,
    documenti_articoli.importo_netto_totale * -1 AS importo,
    documenti_articoli.data_lavorazione
    FROM mastri
    INNER JOIN documenti_articoli ON documenti_articoli.id_mastro_provenienza = mastri.id
    UNION
    SELECT
    mastri.*,
    documenti_articoli.id AS id_riga,
    documenti_articoli.nome AS descrizione,
    documenti_articoli.quantita,
    documenti_articoli.importo_netto_totale AS importo,
    documenti_articoli.data_lavorazione
    FROM mastri
    INNER JOIN documenti_articoli ON documenti_articoli.id_mastro_destinazione = mastri.id
;
