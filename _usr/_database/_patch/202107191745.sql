CREATE OR REPLACE VIEW `__report_mastri_orari__` AS
    SELECT
    mastri.id,
    concat(COALESCE(clienti.nome,''), ' ',COALESCE(clienti.cognome,''), COALESCE(clienti.denominazione,'')) AS cliente,
    progetti.id AS progetto,
    attivita.id AS id_attivita,
    attivita.nome AS nome_attivita,
    attivita.ore * -1  AS ore,
    attivita.id_progetto,
    attivita.id_todo,
    attivita.id_cliente,
    attivita.data AS data,
    attivita.id_tipologia 
    FROM mastri
    INNER JOIN attivita ON attivita.id_mastro_provenienza = mastri.id
    LEFT JOIN anagrafica AS clienti ON clienti.id = attivita.id_cliente
    LEFT JOIN progetti ON progetti.id = attivita.id_progetto
    WHERE mastri.id_tipologia = 3
    UNION
    SELECT
    mastri.id,
    concat(COALESCE(clienti.nome,''), ' ',COALESCE(clienti.cognome,''), COALESCE(clienti.denominazione,'')) AS cliente,
    progetti.id AS progetto,
    attivita.id AS id_attivita,
    attivita.nome AS nome_attivita,
    attivita.ore AS ore,
    attivita.id_progetto,
    attivita.id_todo,
    attivita.id_cliente,
    attivita.data AS data,
    attivita.id_tipologia 
    FROM mastri
    INNER JOIN attivita ON attivita.id_mastro_destinazione = mastri.id
    LEFT JOIN anagrafica AS clienti ON clienti.id = attivita.id_cliente
    LEFT JOIN progetti ON progetti.id = attivita.id_progetto
    WHERE mastri.id_tipologia = 3
;