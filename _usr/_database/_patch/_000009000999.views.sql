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

--| 000009000100

-- account_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_view`;

--| 000009000101

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
;

--| 000009000200

-- account_gruppi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_gruppi_view`;

--| 000009000201

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
			' / ',
			gruppi.nome
		) AS __label__
	FROM account_gruppi
		INNER JOIN account ON account.id = account_gruppi.id_account
		INNER JOIN gruppi ON gruppi.id = account_gruppi.id_gruppo
;

--| 000009000300

-- account_gruppi_attribuzione_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_gruppi_attribuzione_view`;

--| 000009000301

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
			' / ',
			gruppi.nome,
			' / ',
			account_gruppi_attribuzione.entita
		) AS __label__
	FROM account_gruppi_attribuzione
		INNER JOIN account ON account.id = account_gruppi_attribuzione.id_account
		INNER JOIN gruppi ON gruppi.id = account_gruppi_attribuzione.id_gruppo
;

--| 000009000400

-- anagrafica_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_view`;

--| 000009000401

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
		max( categorie_anagrafica.se_produzione ) AS se_produzione,
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
		group_concat( DISTINCT categorie_anagrafica_path( categorie_anagrafica.id ) SEPARATOR ' / ' ) AS categorie,
		group_concat( DISTINCT telefoni.numero SEPARATOR ' / ' ) AS telefoni,
		group_concat( DISTINCT mail.indirizzo SEPARATOR ' / ' ) AS mail,
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
;

--| 000009000410

-- anagrafica_archiviati_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_archiviati_view`;

--| 000009000411

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
		max( categorie_anagrafica.se_produzione ) AS se_produzione,
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
		group_concat( DISTINCT categorie_anagrafica_path( categorie_anagrafica.id ) SEPARATOR ' / ' ) AS categorie,
		group_concat( DISTINCT telefoni.numero SEPARATOR ' / ' ) AS telefoni,
		group_concat( DISTINCT mail.indirizzo SEPARATOR ' / ' ) AS mail,
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
;

--| 000009000500

-- anagrafica_categorie_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_categorie_view`;

--| 000009000501

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
			' / ',
			categorie_anagrafica.nome
		) AS __label__
	FROM anagrafica_categorie
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_categorie.id_anagrafica
		INNER JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
;

-- NOTA non dovrebbe esserci il path qui?

--| 000009000600

-- anagrafica_categorie_diritto_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_categorie_diritto_view`;

--| 000009000601

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
			' / ',
			categorie_anagrafica.nome
		) AS __label__
	FROM anagrafica_categorie_diritto
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_categorie_diritto.id_anagrafica
		INNER JOIN categorie_diritto ON categorie_diritto.id = anagrafica_categorie_diritto.id_categoria
;

--| 000009000700

-- anagrafica_cittadinanze_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_cittadinanze_view`;

--| 000009000701

-- anagrafica_cittadinanze_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 21:47 Fabio Mosti
CREATE OR REPLACE VIEW `anagrafica_cittadinanze_view` AS
	SELECT
		anagrafica_cittadinanze.id,
		anagrafica_cittadinanze.id_anagrafica,
		anagrafica_cittadinanze.id_stato,
		anagrafica_cittadinanze.data_inizio,
		anagrafica_cittadinanze.data_fine,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			stati.nome
		) AS __label__
	FROM anagrafica_cittadinanze
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_cittadinanze.id_anagrafica
		INNER JOIN stati ON stati.id = anagrafica_cittadinanze.id_stato
;

--| 000009000800

-- anagrafica_condizioni_pagamento_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_condizioni_pagamento_view`;

--| 000009000801

-- anagrafica_condizioni_pagamento_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 22:04 Fabio Mosti
CREATE OR REPLACE VIEW `anagrafica_condizioni_pagamento_view` AS
	SELECT
		anagrafica_condizioni_pagamento.id,
		anagrafica_condizioni_pagamento.id_anagrafica,
		anagrafica_condizioni_pagamento.id_condizione,
		condizioni_pagamento.nome AS condizione,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			condizioni_pagamento.nome
		) AS __label__
	FROM anagrafica_condizioni_pagamento
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_condizioni_pagamento.id_anagrafica
		INNER JOIN condizioni_pagamento ON condizioni_pagamento.id = anagrafica_condizioni_pagamento.id_condizione
;

--| 000009000900

-- anagrafica_indirizzi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_indirizzi_view`;

--| 000009000901

-- anagrafica_indirizzi_view
-- tipologia: tabella gestita
CREATE OR REPLACE VIEW anagrafica_indirizzi_view AS
	SELECT
		anagrafica_indirizzi.id,
		anagrafica_indirizzi.id_tipologia,
		tipologie_indirizzi.nome AS tipologia,
		anagrafica_indirizzi.id_anagrafica,
		anagrafica_indirizzi.id_indirizzo,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			coalesce( anagrafica_indirizzi.note, anagrafica_indirizzi.id_indirizzo )
		) AS __label__
	FROM anagrafica_indirizzi
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_indirizzi.id_anagrafica
;

--| 000009001000

-- anagrafica_modalita_pagamento_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_modalita_pagamento_view`;

--| 000009001001

-- anagrafica_modalita_pagamento_view
-- tipologia: tabella gestita
-- verifica: 2021-05-22 16:28 Fabio Mosti
CREATE OR REPLACE VIEW `anagrafica_modalita_pagamento_view` AS
	SELECT
		anagrafica_modalita_pagamento.id,
		anagrafica_modalita_pagamento.id_anagrafica,
		anagrafica_modalita_pagamento.id_modalita,
		modalita_pagamento.nome AS modalita,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			modalita_pagamento.nome
		) AS __label__
	FROM anagrafica_modalita_pagamento
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_modalita_pagamento.id_anagrafica
		INNER JOIN modalita_pagamento ON modalita_pagamento.id = modalita_pagamento_pagamento.id_modalita
;

--| 000009001100

-- anagrafica_ruoli_view
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:35 Fabio Mosti
DROP TABLE IF EXISTS `anagrafica_ruoli_view`;

--| 000009001101

-- anagrafica_ruoli_view
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:35 Fabio Mosti
CREATE OR REPLACE VIEW anagrafica_ruoli_view AS
	SELECT
		anagrafica_ruoli.id,
		anagrafica_ruoli.id_genitore,
		anagrafica_ruoli.ordine,
		anagrafica_ruoli.id_anagrafica,
		anagrafica_ruoli.id_ruolo,
		anagrafica_ruoli_path( anagrafica_ruoli.id ) AS ruolo,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			anagrafica_ruoli_path( anagrafica_ruoli.id )
		) AS __label__
	FROM anagrafica_ruoli
		LEFT JOIN anagrafica ON anagrafica.id = anagrafica_ruoli.id_anagrafica
;

--| 000009001200

-- anagrafica_settori_view
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:35 Fabio Mosti
DROP TABLE IF EXISTS `anagrafica_settori_view`;

--| 000009001201

-- anagrafica_settori_view
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:35 Fabio Mosti
CREATE OR REPLACE VIEW `anagrafica_settori_view` AS
	SELECT
		anagrafica_settori.id,
		anagrafica_settori.id_anagrafica,
		anagrafica_settori.id_settore,
		settori.nome AS settore,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			settori.nome
		) AS __label__
	FROM anagrafica_settori
		LEFT JOIN anagrafica ON anagrafica.id = anagrafica_settori.id_anagrafica
		LEFT JOIN settori ON settori.id = anagrafica_settori.id_settore
;

-- NOTA per il nome del settore usare settori_path?

--| 000009001300

-- articoli_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `articoli_view`;

--| 000009001301

-- articoli_view
-- tipologia: tabella gestita
-- verifica: 2021-05-25 10:56 Fabio Mosti
CREATE OR REPLACE VIEW `articoli_view` AS
	SELECT
		articoli.id,
		articoli.id_prodotto,
		articoli.ordine,
		articoli.ean,
		articoli.isbn,
		articoli.id_reparto,
		articoli.id_taglia,
		articoli.id_colore,
		articoli.larghezza,
		articoli.lunghezza,
		articoli.altezza,
		articoli.peso,
		articoli.volume,
		articoli.capacita,
		articoli.nome,
		concat(
			articoli.id_prodotto,
			' / ',
			articoli.id,
			' / ',
			articoli.nome
		) AS __label__
	FROM articoli
;

--| 000009001600

-- articoli_caratteristiche_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `articoli_caratteristiche_view`;

--| 000009001601

-- articoli_caratteristiche_view
-- tipologia: tabella gestita
-- verifica: 2021-05-26 12:01 Fabio Mosti
CREATE OR REPLACE VIEW `articoli_caratteristiche_view` AS
	SELECT
		articoli_caratteristiche.id,
		articoli_caratteristiche.id_articolo,
		articoli_caratteristiche.id_caratteristica,
		articoli_caratteristiche.ordine,
		articoli_caratteristiche.valore,
		articoli_caratteristiche.se_assente,
		concat(
			articoli.id,
			' / ',
			tipologie_caratteristiche_prodotti.nome,
			': ',
			caratteristiche_prodotti.nome,
			' ',
			articoli_caratteristiche.valore
		) AS __label__
	FROM articoli_caratteristiche
		LEFT JOIN caratteristiche_prodotti ON caratteristiche_prodotti.id = articoli_caratteristiche.id_caratteristica
		LEFT JOIN tipologie_caratteristiche_prodotti ON tipologie_caratteristiche_prodotti.id = caratteristiche_prodotti.id_tipologia
;

--| 000009001700

-- articoli_correlati_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `articoli_correlati_view`;

--| 000009001701

-- articoli_correlati_view
-- tipologia: tabella gestita
-- verifica: 2021-05-26 12:08 Fabio Mosti
CREATE OR REPLACE VIEW `articoli_correlati_view` AS
	SELECT
		articoli_correlati.id,
		articoli_correlati.id_tipologia,
		tipologie_correlazioni_articoli.nome AS tipologia,
		articoli_correlati.id_articolo,
		articoli_correlati.id_prodotto_correlato,
		articoli_correlati.id_articolo_correlato,
		articoli_correlati.ordine,
		articoli_correlati.se_upselling,
		articoli_correlati.se_crosselling,
		concat(
			articoli_correlati.id_articolo,
			' / ',
			tipologie_correlazioni_articoli.nome,
			' / ',
			coalesce(
				articoli_correlati.id_prodotto_correlato,
				articoli_correlati.id_articolo_correlato
			)
		) AS __label__
	FROM articoli_correlati
		LEFT JOIN tipologie_correlazioni_articoli ON tipologie_correlazioni_articoli.id = articoli_correlati.id_tipologia
;

--| 000009001800

-- attivita_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `attivita_view`;

--| 000009001801

-- attivita_view
-- tipologia: tabella gestita
-- verifica: 2021-05-28 13:12 Fabio Mosti
CREATE OR REPLACE VIEW `attivita_view` AS
	SELECT	
		attivita.id,
		attivita.id_tipologia,
		tipologie_attivita.nome AS tipologia,
		attivita.id_tipologia_inps,
		tipologie_attivita.nome AS tipologia_inps,
		attivita.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		attivita.id_cliente,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		coalesce( attivita.referenti, progetti_referenti_view_static.referenti ) AS referenti,
		attivita.id_indirizzo,
		indirizzi_view_static.indirizzo,
		attivita.id_luogo,
		luoghi_view_static.luogo,
		attivita.data_scadenza,
		attivita.ora_scadenza,
		attivita.data_programmazione,
		attivita.ora_inizio_programmazione,
		attivita.ora_fine_programmazione,
		attivita.ore_programmazione,
		attivita.data_attivita,
		day( data_attivita ) as giorno_attivita,
		month( data_attivita ) as mese_attivita,
		year( data_attivita ) as anno_attivita,
		attivita.ora_inizio,
		attivita.latitudine_ora_inizio,
		attivita.longitudine_ora_inizio,
		attivita.ora_fine,
		attivita.latitudine_ora_fine,
		attivita.longitudine_ora_fine,
		attivita.ore,
		attivita.nome,
		attivita.id_progetto,
		progetti.nome AS progetto,
		attivita.id_todo,
		todo.nome AS todo,
		attivita.id_campagna,
		attivita.id_immobile,
		attivita.id_richiesta,
		attivita.id_todo_articoli,
		attivita.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		attivita.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		max( categorie_progetti.se_ordinario ) AS se_ordinario,
		max( categorie_progetti.se_straordinario ) AS se_straordinario,
		attivita.token,
		concat(
			attivita.nome,
			' / ',
			attivita.ore,
			' / ',
			coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM attivita
		LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia
		LEFT JOIN tipologie_attivita_inps ON tipologie_attivita_inps.id = attivita.id_tipologia_inps
		LEFT JOIN anagrafica AS a1 ON a1.id = attivita.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = attivita.id_cliente
		LEFT JOIN progetti_referenti_view_static ON progetti_referenti_view_static.id_progetto = attivita.id_progetto
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = attivita.id_progetto
		LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria
		LEFT JOIN progetti ON progetti.id = attivita.id_progetto
		LEFT JOIN todo ON todo.id = attivita.id_todo
		LEFT JOIN mastri AS m1 ON m1.id = attivita.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = attivita.id_mastro_destinazione
;

--| 000009002100

-- audio_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `audio_view`;

--| 000009002101

-- audio_view
-- tipologia: tabella gestita
-- verifica: 2021-05-28 16:25 Fabio Mosti
CREATE OR REPLACE VIEW `audio_view` AS
	SELECT
		audio.id,
		audio.id_lingua,
		lingue.nome AS lingua,
		audio.id_ruolo,
		ruoli_audio.nome AS ruolo,
		audio.ordine,
		audio.path,
		audio.codice_embed,
		audio.id_tipologia_embed,
		tipologie_embed.nome AS tipologia_embed,
		audio.nome,
		audio.target,
		audio.id_anagrafica,
		audio.id_pagina,
		audio.id_file,
		audio.id_risorsa,
		audio.id_prodotto,
		audio.id_categoria_prodotti,
		audio.id_notizia,
		audio.id_categoria_notizie,
		audio.id_evento,
		audio.id_categoria_eventi,
		concat(
			audio.nome,
			' / ',
			lingue.nome
		) AS __label__
	FROM audio
		LEFT JOIN lingue ON lingue.id = audio.id_lingua
		LEFT JOIN ruoli_audio ON ruoli_audio.id = audio.id_ruolo
		LEFT JOIN tipologie_embed ON tipologie_embed.id = audio.id_tipologia_embed
;

--| 000009002500

-- campagne_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `campagne_view`;

--| 000009002501

-- campagne_view
-- tipologia: tabella gestita
-- verifica: 2021-05-28 17:53 Fabio Mosti
CREATE OR REPLACE VIEW `campagne_view` AS
	SELECT
		campagne.id,
		campagne.nome,
		campagne.timestamp_apertura,
		campagne.timestamp_chiusura,
		campagne.nome AS __label__
	FROM campagne
;

--| 000009002700

-- caratteristiche_immobili_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `caratteristiche_immobili_view`;

--| 000009002701

-- caratteristiche_immobili_view
-- tipologia: tabella di supporto
-- verifica: 2021-05-28 18:51 Fabio Mosti
CREATE OR REPLACE VIEW `caratteristiche_immobili_view` AS
	SELECT
		caratteristiche_immobili.id,
		caratteristiche_immobili.id_tipologia,
		tipologie_caratteristiche_immobili.nome AS tipologia,
		caratteristiche_immobili.nome,
		caratteristiche_immobili.html_entity,
		caratteristiche_immobili.font_awesome,
		caratteristiche_immobili.se_indirizzo,
		caratteristiche_immobili.se_immobile,
		concat(
			tipologie_caratteristiche_immobili.nome,
			' / ',
			caratteristiche_immobili.nome
		) AS __label__
	FROM caratteristiche_immobili
		LEFT JOIN tipologie_caratteristiche_immobili ON tipologie_caratteristiche_immobili.id = caratteristiche_immobili.id_tipologia
;

--| 000009002900

-- caratteristiche_prodotti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `caratteristiche_prodotti_view`;

--| 000009002901

-- caratteristiche_prodotti_view
-- tipologia: tabella gestita
-- verifica: 2021-05-28 18:51 Fabio Mosti
CREATE OR REPLACE VIEW caratteristiche_prodotti_view AS
	SELECT
		caratteristiche_prodotti.id,
		caratteristiche_prodotti.id_tipologia,
		tipologie_caratteristiche_prodotti.nome AS tipologia,
		caratteristiche_prodotti.nome,
		caratteristiche_prodotti.html_entity,
		caratteristiche_prodotti.font_awesome,
		caratteristiche_prodotti.se_categoria,
		caratteristiche_prodotti.se_prodotto,
		caratteristiche_prodotti.se_articolo,
		concat(
			tipologie_caratteristiche_prodotti.nome,
			' / ',
			caratteristiche_prodotti.nome
		) AS __label__
	FROM caratteristiche_prodotti
		LEFT JOIN tipologie_caratteristiche_prodotti ON tipologie_caratteristiche_prodotti.id = caratteristiche_prodotti.id_tipologia
;

--| 000009003100

-- categorie_anagrafica_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `categorie_anagrafica_view`;

--| 000009003101

-- categorie_anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2021-06-01 10:55 Fabio Mosti
CREATE OR REPLACE VIEW categorie_anagrafica_view AS
	SELECT
		categorie_anagrafica.id,
		categorie_anagrafica.id_genitore,
		categorie_anagrafica.ordine,
		categorie_anagrafica.nome,
		categorie_anagrafica.se_prospect,
		categorie_anagrafica.se_lead,
		categorie_anagrafica.se_cliente,
		categorie_anagrafica.se_mandante,
		categorie_anagrafica.se_fornitore,
		categorie_anagrafica.se_produttore,
		categorie_anagrafica.se_collaboratore,
		categorie_anagrafica.se_dipendente,
		categorie_anagrafica.se_interinale,
		categorie_anagrafica.se_interno,
		categorie_anagrafica.se_esterno,
		categorie_anagrafica.se_agente,
		categorie_anagrafica.se_concorrente,
		categorie_anagrafica.se_rassegna_stampa,
		categorie_anagrafica.se_azienda_gestita,
		categorie_anagrafica.se_amministrazione,
		categorie_anagrafica.se_notizie,
		categorie_anagrafica.se_docente,
		categorie_anagrafica.se_tutor,
		categorie_anagrafica.se_classe,
		categorie_anagrafica.se_allievo,
		categorie_anagrafica.se_agenzia_interinale,
		categorie_anagrafica.se_referente,
		categorie_anagrafica.se_sostituto,
		categorie_anagrafica.se_squadra,
		count( c1.id ) AS figli,
		count( anagrafica_categorie.id ) AS membri,
	 	categorie_anagrafica_path( categorie_anagrafica.id ) AS __label__
	FROM categorie_anagrafica
		LEFT JOIN categorie_anagrafica AS c1 ON c1.id_genitore = categorie_anagrafica.id
		LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_categoria = categorie_anagrafica.id
	GROUP BY categorie_anagrafica.id
;

--| 000009003300

-- categorie_diritto_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `categorie_diritto_view`;

--| 000009003301

-- categorie_diritto_view
-- tipologia: tabella assistita
-- verifica: 2021-06-01 10:56 Fabio Mosti
CREATE OR REPLACE VIEW categorie_diritto_view AS
	SELECT
		categorie_diritto.id,
		categorie_diritto.id_genitore,
		categorie_diritto.ordine,
		categorie_diritto.nome,
		categorie_diritto.template,
		categorie_diritto.schema_html.
		categorie_diritto.tema_css,
		categorie_diritto.id_pagina,
		count( c1.id ) AS figli,
		count( anagrafica_categorie_diritto.id ) AS membri,
		categorie_diritto_path( categorie_diritto.id ) AS __label__
	FROM categorie_diritto
		LEFT JOIN categorie_diritto AS c1 ON c1.id_genitore = categorie_diritto.id
		LEFT JOIN anagrafica_categorie_diritto ON anagrafica_categorie_diritto.id_categoria = categorie_diritto.id
	GROUP BY categorie_diritto.id
;

--| 000009003500

-- categorie_eventi_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `categorie_eventi_view`;

--| 000009003501

-- categorie_eventi_view
-- tipologia: tabella assistita
-- verifica: 2021-06-01 10:56 Fabio Mosti
CREATE OR REPLACE VIEW categorie_eventi_view AS
	SELECT
		categorie_eventi.id,
		categorie_eventi.id_genitore,
		categorie_eventi.ordine,
		categorie_eventi.nome,
		categorie_eventi.template,
		categorie_eventi.schema_html.
		categorie_eventi.tema_css,
		categorie_eventi.id_pagina,
		count( c1.id ) AS figli,
		count( eventi_categorie.id ) AS membri,
		categorie_eventi_path( categorie_eventi.id ) AS __label__
	FROM categorie_eventi
		LEFT JOIN categorie_eventi AS c1 ON c1.id_genitore = categorie_eventi.id
		LEFT JOIN eventi_categorie ON eventi_categorie.id_categoria = categorie_eventi.id
	GROUP BY categorie_eventi.id
;

--| 000009003700

-- categorie_notizie_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `categorie_notizie_view`;

--| 000009003701

-- categorie_notizie_view
-- tipologia: tabella assistita
-- verifica: 2021-06-01 18:36 Fabio Mosti
CREATE OR REPLACE VIEW categorie_notizie_view AS
	SELECT
		categorie_notizie.id,
		categorie_notizie.id_genitore,
		categorie_notizie.ordine,
		categorie_notizie.nome,
		categorie_notizie.template,
		categorie_notizie.schema_html.
		categorie_notizie.tema_css,
		categorie_notizie.id_pagina,
		count( c1.id ) AS figli,
		count( notizie_categorie.id ) AS membri,
		categorie_notizie_path( categorie_notizie.id ) AS __label__
	FROM categorie_notizie
		LEFT JOIN categorie_notizie AS c1 ON c1.id_genitore = categorie_notizie.id
		LEFT JOIN notizie_categorie ON notizie_categorie.id_categoria = categorie_notizie.id
	GROUP BY categorie_notizie.id
;

--| 000009003900

-- categorie_prodotti_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `categorie_prodotti_view`;

--| 000009003901

-- categorie_prodotti_view
-- tipologia: tabella assistita
-- verifica: 2021-06-01 20:02 Fabio Mosti
CREATE OR REPLACE VIEW categorie_prodotti_view AS
	SELECT
		categorie_prodotti.id,
		categorie_prodotti.id_genitore,
		categorie_prodotti.ordine,
		categorie_prodotti.nome,
		categorie_prodotti.template,
		categorie_prodotti.schema_html.
		categorie_prodotti.tema_css,
		categorie_prodotti.id_pagina,
		count( c1.id ) AS figli,
		count( prodotti_categorie.id ) AS membri,
		categorie_prodotti_path( categorie_prodotti.id ) AS __label__
	FROM categorie_prodotti
		LEFT JOIN categorie_prodotti AS c1 ON c1.id_genitore = categorie_prodotti.id
		LEFT JOIN prodotti_categorie ON prodotti_categorie.id_categoria = categorie_prodotti.id
	GROUP BY categorie_prodotti.id
;

--| 000009004100

-- categorie_prodotti_caratteristiche_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `categorie_prodotti_caratteristiche_view`;

--| 000009004101

-- categorie_prodotti_caratteristiche_view
-- tipologia: tabella assistita
-- verifica: 2021-06-02 19:29 Fabio Mosti
CREATE OR REPLACE VIEW categorie_prodotti_caratteristiche_view AS
	SELECT
		categorie_prodotti_caratteristiche.id,
		categorie_prodotti_caratteristiche.id_categoria,
		categorie_prodotti_caratteristiche.id_caratteristica,
		categorie_prodotti_caratteristiche.ordine,
		categorie_prodotti_caratteristiche.se_assente,
		categorie_prodotti_caratteristiche.se_visibile,
		count( prodotti_categorie.id ) AS membri,
		concat(
			categorie_prodotti.nome,
			' / ',
			caratteristiche_prodotti.nome
		) AS __label__
	FROM categorie_prodotti
		LEFT JOIN categorie_prodotti ON categorie_prodotti.id = categorie_prodotti_caratteristiche.id_categoria
		LEFT JOIN caratteristiche_prodotti ON caratteristiche_prodotti.id = categorie_prodotti_caratteristiche.id_caratteristica
	GROUP BY categorie_prodotti.id
;

--| 000009004300

-- categorie_progetti_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `categorie_progetti_view`;

--| 000009004301

-- categorie_progetti_view
-- tipologia: tabella assistita
-- verifica: 2021-06-01 20:02 Fabio Mosti
CREATE OR REPLACE VIEW categorie_progetti_view AS
	SELECT
		categorie_progetti.id,
		categorie_progetti.id_genitore,
		categorie_progetti.ordine,
		categorie_progetti.nome,
		categorie_progetti.se_ordinario,
		categorie_progetti.se_straordinario,
		count( c1.id ) AS figli,
		count( progetti_categorie.id ) AS membri,
		categorie_progetti_path( categorie_progetti.id ) AS __label__
	FROM categorie_progetti
		LEFT JOIN categorie_progetti AS c1 ON c1.id_genitore = categorie_progetti.id
		LEFT JOIN progetti_categorie ON progetti_categorie.id_categoria = categorie_progetti.id
	GROUP BY categorie_progetti.id
;

--| 000009004500

-- categorie_risorse_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `categorie_risorse_view`;

--| 000009004501

-- categorie_risorse_view
-- tipologia: tabella assistita
-- verifica: 2021-06-01 20:25 Fabio Mosti
CREATE OR REPLACE VIEW categorie_risorse_view AS
	SELECT
		categorie_risorse.id,
		categorie_risorse.id_genitore,
		categorie_risorse.ordine,
		categorie_risorse.nome,
		count( c1.id ) AS figli,
		count( risorse_categorie.id ) AS membri,
		categorie_risorse_path( categorie_risorse.id ) AS __label__
	FROM categorie_risorse
		LEFT JOIN categorie_risorse AS c1 ON c1.id_genitore = categorie_risorse.id
		LEFT JOIN risorse_categorie ON risorse_categorie.id_categoria = categorie_risorse.id
	GROUP BY categorie_risorse.id
;

--| 000009004700

-- classi_energetiche_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `classi_energetiche_view`;

--| 000009004701

-- classi_energetiche_view
-- tipologia: tabella assistita
-- verifica: 2021-06-01 20:25 Fabio Mosti
CREATE OR REPLACE VIEW classi_energetiche_view AS
	SELECT
		classi_energetiche.id,
		classi_energetiche.nome,
		classi_energetiche.ep_min,
		classi_energetiche.ep_max,
		classi_energetiche.id_colore,
		colori.hex,
		classi_energetiche.se_immobili,
		classi_energetiche.se_prodotti,
		concat(
			classi_energetiche.nome,
			' / ',
			colori.hex
		) AS __label__
	FROM categorie_risorse
		LEFT JOIN colori ON colori.id = classi_energetiche.id_colore
;

--| 000009005100

-- colori_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `colori_view`;

--| 000009005101

-- colori_view
-- tipologia: tabella di supporto
-- verifica: 2021-06-03 15:05 Fabio Mosti
CREATE OR REPLACE VIEW colori_view AS
	SELECT
		colori.id,
		colori.id_genitore,
		colori.nome,
		colori.hex,
		colori.r,
		colori.g,
		colori.b,
		colori.ral,
		colori.pantone,
		colori.c,
		colori.m,
		colori.y,
		colori.k,
		colori_path( colori.id ) AS __label__
	FROM colori
;

--| 000009005300

-- comuni_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `comuni_view`;

--| 000009005301

-- comuni_view
-- tipologia: tabella di supporto
-- verifica: 2021-06-03 20:31 Fabio Mosti
CREATE OR REPLACE VIEW comuni_view AS
	SELECT
		comuni.id,
		comuni.id_provincia,
		provincie.nome AS provincia,
		provincie.sigla AS sigla_provincia,
		provincie.id_regione,
		regioni.nome AS regione
		regioni.id_stato,
		stati.nome AS stato,
		provincie.nome,
		provincie.codice_istat,
		provincie.codice_catasto,
		concat(
			comuni.nome, ' ',
			coalesce( concat( '(', provincie.sigla, ') '), ' ' ),
			stati.nome
		) AS __label__
	FROM comuni
		INNER JOIN provincie ON provincie.id = comuni.id_provincia
		INNER JOIN regioni ON regioni.id = provincie.id_regioni
		INNER JOIN stati ON stati.id = regioni.id_stato
	ORDER BY __label__
;

--| 000009006700

-- contatti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `contatti_view`;

--| 000009006701

-- contatti_view
-- tipologia: tabella gestita
-- verifica: 2021-06-04 15:37 Fabio Mosti
CREATE OR REPLACE VIEW contatti_view AS
	SELECT
		contatti.id,
		contatti.id_tipologia,
		tipologie_contatti.nome AS tipologia,
		contatti.id_campagna,
		campagne.nome AS campagna,
		contatti.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		contatti.id_inviante,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS inviante,
		contatti.nome,
		contatti.timestamp_contatto,
		concat(
			tipologie_contatti.nome,
			' / ',
			contatti.nome
		) AS __label__
	FROM contatti
		LEFT JOIN tipologie_contatti ON tipologie_contatti.id = contatti.id_tipologia
		LEFT JOIN campagne ON campagne.id = contatti.id_campagna
		LEFT JOIN anagrafica AS a1 ON a1.id = contatti.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = contatti.id_inviante
;

--| FINE FILE
