CREATE OR REPLACE VIEW `__report_giacenza_mastri__` AS
    SELECT
    __report_mastri__.id,
    __report_mastri__.id_articolo,
    SUM(quantita) AS quantita_totale,
    SUM(importo) AS importo_totale
    FROM __report_mastri__
    GROUP BY id, id_articolo
;