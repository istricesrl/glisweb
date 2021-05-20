--
-- VISTE
-- questo file contiene le query per la creazione delle viste
--
-- CRITERI DI VERIFICA
-- una definizione di view si può definire verificata se:
-- - riporta esplicitamente tutte e sole le colonne significative (evitare SELECT * FROM)
-- - le colonne appaiono nell'ordine in cui si trovano nella tabella, al netto delle colonne aggiunte dalla view
-- - la view si riferisce a una tabella non deprecata e non contengono colonne deprecate
-- - la view non fa riferimento a tabelle o colonne deprecate
-- - il definer è CURRENT_USER()
-- - le colonne sono correttamente documentate, in ordine, nel relativo file dox
--

--| 000008000001

-- account_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_view`;

--| 000008000002

-- account_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 14:27 Fabio Mosti
CREATE OR REPLACE DEFINER = CURRENT_USER() VIEW account_view AS
	SELECT
		account.id,
		account.id_anagrafica,
		account.id_mail,
		account.username,
		account.password,
		account.se_attivo,
		account.token,
		account.timestamp_login,
		account.timestamp_cambio_password,
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
-- verifica: 2021-05-20 17:11 Fabio Mosti
CREATE OR REPLACE VIEW account_gruppi_view AS
	SELECT
		account_gruppi.id,
		account_gruppi.id_account,
		account_gruppi.id_gruppo,
		account_gruppi.se_amministratore,
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

--| 000008000005

-- account_gruppi_attribuzione_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_gruppi_attribuzione_view`;

--| 000008000006

-- account_gruppi_attribuzione_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 17:12 Fabio Mosti
CREATE OR REPLACE VIEW account_gruppi_attribuzione_view AS
	SELECT
		account_gruppi_attribuzione.id,
		account_gruppi_attribuzione.id_account,
		account_gruppi_attribuzione.id_gruppo,
		account_gruppi_attribuzione.entita,
		concat(
			account.username,
			'/',
			gruppi.nome,
			' - ',
			account_gruppi_attribuzione.entita
		) AS __label__
	FROM account_gruppi_attribuzione
		INNER JOIN account ON account.id = account_gruppi_attribuzione.id_account
		INNER JOIN gruppi ON gruppi.id = account_gruppi_attribuzione.id_gruppo
	ORDER BY __label__
;

--| 000008000007

-- anagrafica_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_view`;

--| 000008000008

-- anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 18:47 Fabio Mosti
CREATE OR REPLACE VIEW anagrafica_view AS
	SELECT
		anagrafica.id,
		anagrafica.codice,
		anagrafica.riferimento,
		tipologie_anagrafica.nome AS tipologia,
		anagrafica.nome,
		anagrafica.cognome,
		anagrafica.denominazione,
		anagrafica.soprannome,
		anagrafica.sesso,
		anagrafica.codice_fiscale,
		anagrafica.partita_iva,
		tipologie_crm.nome AS tipologia_crm,
		anagrafica.recapiti,
		max( categorie_anagrafica.se_collaboratore ) AS se_collaboratore,
		max( categorie_anagrafica.se_dipendente ) AS se_dipendente,
		max( categorie_anagrafica.se_interinale ) AS se_interinale,
		max( categorie_anagrafica.se_cliente ) AS se_cliente,
		max( categorie_anagrafica.se_lead ) AS se_lead,
		max( categorie_anagrafica.se_prospect ) AS se_prospect,
		max( categorie_anagrafica.se_mandante ) AS se_mandante,
		max( categorie_anagrafica.se_fornitore ) AS se_fornitore,
		max( categorie_anagrafica.se_produttore ) AS se_produttore,
		max( categorie_anagrafica.se_agente ) AS se_agente,
		max( categorie_anagrafica.se_interno ) AS se_interno,
		max( categorie_anagrafica.se_esterno ) AS se_esterno,
		max( categorie_anagrafica.se_amministrazione ) AS se_amministrazione,
		max( categorie_anagrafica.se_azienda_gestita ) AS se_azienda_gestita,
		max( categorie_anagrafica.se_concorrente ) AS se_concorrente,
		max( categorie_anagrafica.se_tutor ) AS se_tutor,
		max( categorie_anagrafica.se_classe ) AS se_classe,
		max( categorie_anagrafica.se_docente ) AS se_docente,
		max( categorie_anagrafica.se_allievo ) AS se_allievo,
		max( categorie_anagrafica.se_agenzia_interinale ) AS se_agenzia_interinale,
		max( categorie_anagrafica.se_referente ) AS se_referente,
		max( categorie_anagrafica.se_sostituto ) AS se_sostituto,
		max( categorie_anagrafica.se_squadra ) AS se_squadra,
		group_concat( DISTINCT categorie_anagrafica_path( categorie_anagrafica.id ) SEPARATOR ' | ' ) AS categorie,
		group_concat( DISTINCT telefoni.numero SEPARATOR ' | ' ) AS telefoni,
		group_concat( DISTINCT mail.indirizzo SEPARATOR ' | ' ) AS mail,
		coalesce(
			anagrafica.soprannome,
			anagrafica.denominazione,
			concat_ws(' ', coalesce(anagrafica.cognome, ''),
			coalesce(anagrafica.nome, '') ),
			''
		) AS __label__
	FROM anagrafica
		LEFT JOIN tipologie_anagrafica ON tipologie_anagrafica.id = anagrafica.id_tipologia
		LEFT JOIN tipologie_crm ON tipologie_crm.id = anagrafica.id_tipologia_crm
		LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id
		LEFT JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
		LEFT JOIN telefoni ON telefoni.id_anagrafica = anagrafica.id
		LEFT JOIN mail ON mail.id_anagrafica = anagrafica.id
		LEFT JOIN __acl_anagrafica__ ON __acl_anagrafica__.id_entita = anagrafica.id
	WHERE anagrafica.data_cessazione IS NULL
	GROUP BY anagrafica.id
	ORDER BY __label__
;

--| 000008000008

-- anagrafica_archiviati_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_archiviati_view`;

--| 000008000009

-- anagrafica_archiviati_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:15 Fabio Mosti
CREATE OR REPLACE VIEW anagrafica_archiviati_view AS
	SELECT
		anagrafica.id,
		anagrafica.codice,
		anagrafica.riferimento,
		tipologie_anagrafica.nome AS tipologia,
		anagrafica.nome,
		anagrafica.cognome,
		anagrafica.denominazione,
		anagrafica.soprannome,
		anagrafica.sesso,
		anagrafica.codice_fiscale,
		anagrafica.partita_iva,
		tipologie_crm.nome AS tipologia_crm,
		anagrafica.recapiti,
		max( categorie_anagrafica.se_collaboratore ) AS se_collaboratore,
		max( categorie_anagrafica.se_dipendente ) AS se_dipendente,
		max( categorie_anagrafica.se_interinale ) AS se_interinale,
		max( categorie_anagrafica.se_cliente ) AS se_cliente,
		max( categorie_anagrafica.se_lead ) AS se_lead,
		max( categorie_anagrafica.se_prospect ) AS se_prospect,
		max( categorie_anagrafica.se_mandante ) AS se_mandante,
		max( categorie_anagrafica.se_fornitore ) AS se_fornitore,
		max( categorie_anagrafica.se_produttore ) AS se_produttore,
		max( categorie_anagrafica.se_agente ) AS se_agente,
		max( categorie_anagrafica.se_interno ) AS se_interno,
		max( categorie_anagrafica.se_esterno ) AS se_esterno,
		max( categorie_anagrafica.se_amministrazione ) AS se_amministrazione,
		max( categorie_anagrafica.se_azienda_gestita ) AS se_azienda_gestita,
		max( categorie_anagrafica.se_concorrente ) AS se_concorrente,
		max( categorie_anagrafica.se_tutor ) AS se_tutor,
		max( categorie_anagrafica.se_classe ) AS se_classe,
		max( categorie_anagrafica.se_docente ) AS se_docente,
		max( categorie_anagrafica.se_allievo ) AS se_allievo,
		max( categorie_anagrafica.se_agenzia_interinale ) AS se_agenzia_interinale,
		max( categorie_anagrafica.se_referente ) AS se_referente,
		max( categorie_anagrafica.se_sostituto ) AS se_sostituto,
		max( categorie_anagrafica.se_squadra ) AS se_squadra,
		group_concat( DISTINCT categorie_anagrafica_path( categorie_anagrafica.id ) SEPARATOR ' | ' ) AS categorie,
		group_concat( DISTINCT telefoni.numero SEPARATOR ' | ' ) AS telefoni,
		group_concat( DISTINCT mail.indirizzo SEPARATOR ' | ' ) AS mail,
		anagrafica.data_cessazione,
		coalesce(
			anagrafica.soprannome,
			anagrafica.denominazione,
			concat_ws(' ', coalesce(anagrafica.cognome, ''),
			coalesce(anagrafica.nome, '') ),
			''
		) AS __label__
	FROM anagrafica
		LEFT JOIN tipologie_anagrafica ON tipologie_anagrafica.id = anagrafica.id_tipologia
		LEFT JOIN tipologie_crm ON tipologie_crm.id = anagrafica.id_tipologia_crm
		LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id
		LEFT JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
		LEFT JOIN telefoni ON telefoni.id_anagrafica = anagrafica.id
		LEFT JOIN mail ON mail.id_anagrafica = anagrafica.id
		LEFT JOIN __acl_anagrafica__ ON __acl_anagrafica__.id_entita = anagrafica.id
	WHERE anagrafica.data_cessazione IS NOT NULL
	GROUP BY anagrafica.id
	ORDER BY __label__

--| 000008000011

-- anagrafica_categorie_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_categorie_view`;

--| 000008000012

-- anagrafica_categorie_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:15 Fabio Mosti
CREATE OR REPLACE VIEW anagrafica_categorie_view AS
	SELECT
		anagrafica_categorie.id,
		anagrafica_categorie.id_anagrafica,
		anagrafica_categorie.id_categoria,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			'/',
			categorie_anagrafica.nome
		) AS __label__
	FROM anagrafica_categorie
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_categorie.id_anagrafica
		INNER JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
	ORDER BY __label__
;

--| 000008000013

-- anagrafica_categorie_diritto_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:40 Fabio Mosti
CREATE OR REPLACE VIEW anagrafica_categorie_diritto_view AS
	SELECT
		anagrafica_categorie_diritto.id,
		anagrafica_categorie_diritto.id_anagrafica,
		anagrafica_categorie_diritto.id_categoria,
		anagrafica_categorie_diritto.se_specialita,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			'/',
			categorie_anagrafica.nome
		) AS __label__
	FROM anagrafica_categorie_diritto
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_categorie_diritto.id_anagrafica
		INNER JOIN categorie_diritto ON categorie_diritto.id = anagrafica_categorie_diritto.id_categoria
	ORDER BY __label__
;

--| 000008000014

-- anagrafica_cittadinanze_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:47 Fabio Mosti
DROP TABLE IF EXISTS `anagrafica_cittadinanze_view`;
CREATE OR REPLACE VIEW `anagrafica_cittadinanze_view` AS
	SELECT
	anagrafica_cittadinanze.id,
	anagrafica_cittadinanze.id_anagrafica,
	anagrafica_cittadinanze.id_stato,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			'/',
			stati.nome
		) AS __label__
	FROM anagrafica_cittadinanze
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_cittadinanze.id_anagrafica
		INNER JOIN stati ON stati.id = anagrafica_cittadinanze.id_stato
;

--| FINE FILE
