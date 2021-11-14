CREATE OR REPLACE VIEW `__report_giacenza_mastri_orari__` AS
    SELECT
    __report_mastri_orari__.id,
    __report_mastri_orari__.id_progetto,
    __report_mastri_orari__.cliente,
    SUM(ore) AS ore
    FROM __report_mastri_orari__
    GROUP BY id, id_progetto, cliente
; 
