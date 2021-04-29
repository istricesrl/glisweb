--
-- VISTE
-- questo file contiene le query per la creazione delle viste
--

--| 000008000001

-- account_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_view`;

--| 000008000002

-- account_view
-- tipologia: tabella gestita
CREATE OR REPLACE DEFINER = CURRENT_USER() VIEW account_view AS
	SELECT
	account.*,
	if( account.se_attivo = '1', 'attivo', 'inattivo' ) AS attivo,
	coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS utente,
	group_concat( gruppi.nome ORDER BY gruppi.id SEPARATOR '|' ) AS gruppi,
	group_concat( gruppi.id ORDER BY gruppi.id SEPARATOR '|' ) AS id_gruppi,
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
	GROUP BY account.id
	ORDER BY __label__
;

--| 000008000003

-- account_gruppi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_gruppi_view`;

--| 000008000004

-- account_gruppi_view
-- tipologia: tabella gestita
CREATE OR REPLACE VIEW account_gruppi_view AS
	SELECT
		account_gruppi.*,
		concat(
			account.username,
			'/',
			gruppi.nome
		) AS __label__
	FROM account_gruppi
	INNER JOIN account ON account.id = account_gruppi.id_account
	INNER JOIN gruppi ON gruppi.id = account_gruppi.id_gruppo
	ORDER BY __label__
;

--| FINE FILE
