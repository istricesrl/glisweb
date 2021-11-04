CREATE OR REPLACE DEFINER = CURRENT_USER() VIEW account_view AS
    SELECT
    account.*,
    if( account.se_attivo = '1', 'attivo', 'inattivo' ) AS attivo,
    coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS utente,
    group_concat( DISTINCT gruppi.nome ORDER BY gruppi.id SEPARATOR '|' ) AS gruppi,
    group_concat( DISTINCT gruppi.id ORDER BY gruppi.id SEPARATOR '|' ) AS id_gruppi,
    group_concat( concat(ga.nome, '->', account_gruppi_attribuzione.entita, ' ' ) SEPARATOR '| ' ) AS gruppi_attribuzione,
    max( gruppi.id ) AS gruppo_sede,
    account_get_struttura( account.id ) AS id_anagrafica_struttura,
    group_concat(
	DISTINCT
	concat( account_gruppi_attribuzione.entita,'#',account_gruppi_attribuzione.id_gruppo )
	ORDER BY account_gruppi_attribuzione.entita,account_gruppi_attribuzione.id_gruppo
	SEPARATOR '|' ) AS id_gruppi_attribuzione,
    account.username AS __label__
    FROM account
    LEFT JOIN anagrafica ON anagrafica.id = account.id_anagrafica
    LEFT JOIN account_gruppi ON account_gruppi.id_account = account.id
    LEFT JOIN account_gruppi_attribuzione ON account_gruppi_attribuzione.id_account = account.id
    LEFT JOIN gruppi ON gruppi.id = account_gruppi.id_gruppo
    LEFT JOIN gruppi AS ga ON ga.id = account_gruppi_attribuzione.id_gruppo
    GROUP BY account.id
    ORDER BY __label__
;
