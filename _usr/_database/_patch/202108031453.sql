CREATE OR REPLACE VIEW `__report_giacenza_mastri__` AS
    SELECT
    __report_mastri__.id,
    __report_mastri__.id_articolo,
    __report_mastri__.descrizione,
    __report_mastri__.matricola,
    __report_mastri__.id_matricola,
    __report_mastri__.id_progetto,
    __report_mastri__.id_todo,
    __report_mastri__.id_destinatario,
    SUM(quantita) AS quantita_totale,
    SUM(importo) AS importo_totale
    FROM __report_mastri__
    GROUP BY id, id_articolo, matricola, id_todo
;