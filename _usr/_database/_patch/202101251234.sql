CREATE OR REPLACE VIEW `attivita_archiviate_view` AS
    SELECT
    attivita.*,
    progetti.nome AS progetto,
    task.nome AS task,
    task.ore_previste AS ore_previste_task,
    todo.nome AS todo,
    todo.ore_previste AS ore_previste_todo,
    tipologie_attivita.nome AS tipologia,
    tipologie_attivita.html AS icona_html,
    tipologie_attivita.font_awesome AS icona_fa,
    concat( anagrafica.nome, ' ', anagrafica.cognome ) AS anagrafica,
    concat_ws( ' ', cliente.nome, cliente.cognome, coalesce( cliente.soprannome, cliente.denominazione ) ) AS cliente,
    concat_ws( ' ', mandante.nome, mandante.cognome, coalesce( mandante.soprannome, mandante.denominazione ) ) AS mandante,
    concat( tipologie_attivita.nome, ' ', attivita.nome ) AS __label__
    FROM attivita
    LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia
    LEFT JOIN anagrafica ON anagrafica.id = attivita.id_anagrafica
    LEFT JOIN task ON task.id = attivita.id_task
    LEFT JOIN todo ON todo.id = attivita.id_todo
    LEFT JOIN progetti ON progetti.id = attivita.id_progetto
    LEFT JOIN anagrafica AS cliente ON cliente.id = coalesce( progetti.id_cliente, task.id_cliente, todo.id_cliente )
    LEFT JOIN anagrafica AS mandante ON mandante.id = attivita.id_mandante
    WHERE attivita.data IS NOT NULL
    AND attivita.timestamp_scadenza IS NOT NULL
    ORDER BY attivita.data DESC, __label__ ASC
;
