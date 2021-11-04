CREATE OR REPLACE VIEW `__report_mastri__` AS
    SELECT
    mastri.id,
    mastri.nome AS mastro,
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
    documenti_articoli.id_listino,
    documenti_articoli.id_progetto,
    documenti_articoli.id_todo,
    documenti_articoli.matricola AS id_matricola,
    concat( 'MAT.',lpad(documenti_articoli.matricola, 15, '0') ) AS matricola,
    todo.nome AS todo,
    COALESCE( todo.id_progetto, documenti_articoli.id_progetto ) AS progetto
    FROM mastri
    INNER JOIN documenti_articoli ON documenti_articoli.id_mastro_provenienza = mastri.id
    LEFT JOIN anagrafica AS clienti ON clienti.id = documenti_articoli.id_destinatario
    LEFT JOIN anagrafica AS emittenti ON emittenti.id = documenti_articoli.id_emittente
    LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
    LEFT JOIN valute ON valute.id = listini.id_valuta
    LEFT JOIN todo ON todo.id = documenti_articoli.id_todo
    UNION
    SELECT
    mastri.id,
    mastri.nome AS mastro,
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
    documenti_articoli.id_listino,
    documenti_articoli.id_progetto,
    documenti_articoli.id_todo,
    documenti_articoli.matricola AS id_matricola,
    concat( 'MAT.',lpad(documenti_articoli.matricola, 15, '0') ) AS matricola,
    todo.nome AS todo,
    COALESCE( todo.id_progetto, documenti_articoli.id_progetto ) AS progetto
    FROM mastri
    INNER JOIN documenti_articoli ON documenti_articoli.id_mastro_destinazione = mastri.id
    LEFT JOIN anagrafica AS clienti ON clienti.id = documenti_articoli.id_destinatario
    LEFT JOIN anagrafica AS emittenti ON emittenti.id = documenti_articoli.id_emittente
    LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
    LEFT JOIN valute ON valute.id = listini.id_valuta
    LEFT JOIN todo ON todo.id = documenti_articoli.id_todo
;