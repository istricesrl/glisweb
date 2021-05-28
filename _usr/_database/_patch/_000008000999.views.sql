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

--| 000008000100

-- account_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_view`;

--| 000008000101

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

--| 000008000200

-- account_gruppi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_gruppi_view`;

--| 000008000201

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
			' | ',
			gruppi.nome
		) AS __label__
	FROM account_gruppi
		INNER JOIN account ON account.id = account_gruppi.id_account
		INNER JOIN gruppi ON gruppi.id = account_gruppi.id_gruppo
;

--| 000008000300

-- account_gruppi_attribuzione_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_gruppi_attribuzione_view`;

--| 000008000301

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
			' | ',
			gruppi.nome,
			' | ',
			account_gruppi_attribuzione.entita
		) AS __label__
	FROM account_gruppi_attribuzione
		INNER JOIN account ON account.id = account_gruppi_attribuzione.id_account
		INNER JOIN gruppi ON gruppi.id = account_gruppi_attribuzione.id_gruppo
;

--| 000008000400

-- anagrafica_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_view`;

--| 000008000401

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
;

--| 000008000410

-- anagrafica_archiviati_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_archiviati_view`;

--| 000008000411

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
;

--| 000008000500

-- anagrafica_categorie_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_categorie_view`;

--| 000008000501

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
			' | ',
			categorie_anagrafica.nome
		) AS __label__
	FROM anagrafica_categorie
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_categorie.id_anagrafica
		INNER JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
;

-- NOTA non dovrebbe esserci il path qui?

--| 000008000600

-- anagrafica_categorie_diritto_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_categorie_diritto_view`;

--| 000008000601

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
			' | ',
			categorie_anagrafica.nome
		) AS __label__
	FROM anagrafica_categorie_diritto
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_categorie_diritto.id_anagrafica
		INNER JOIN categorie_diritto ON categorie_diritto.id = anagrafica_categorie_diritto.id_categoria
;

--| 000008000700

-- anagrafica_cittadinanze_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_cittadinanze_view`;

--| 000008000701

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
			' | ',
			stati.nome
		) AS __label__
	FROM anagrafica_cittadinanze
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_cittadinanze.id_anagrafica
		INNER JOIN stati ON stati.id = anagrafica_cittadinanze.id_stato
;

--| 000008000800

-- anagrafica_condizioni_pagamento_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_condizioni_pagamento_view`;

--| 000008000801

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
			' | ',
			condizioni_pagamento.nome
		) AS __label__
	FROM anagrafica_condizioni_pagamento
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_condizioni_pagamento.id_anagrafica
		INNER JOIN condizioni_pagamento ON condizioni_pagamento.id = anagrafica_condizioni_pagamento.id_condizione
;

--| 000008000900

-- anagrafica_indirizzi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_indirizzi_view`;

--| 000008000901

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
			' | ',
			coalesce( anagrafica_indirizzi.note, anagrafica_indirizzi.id_indirizzo )
		) AS __label__
	FROM anagrafica_indirizzi
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_indirizzi.id_anagrafica
;

--| 000008001000

-- anagrafica_modalita_pagamento_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_modalita_pagamento_view`;

--| 000008001001

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
			' | ',
			modalita_pagamento.nome
		) AS __label__
	FROM anagrafica_modalita_pagamento
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_modalita_pagamento.id_anagrafica
		INNER JOIN modalita_pagamento ON modalita_pagamento.id = modalita_pagamento_pagamento.id_modalita
;

--| 000008001100

-- anagrafica_ruoli_view
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:35 Fabio Mosti
DROP TABLE IF EXISTS `anagrafica_ruoli_view`;

--| 000008001101

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
			' | ',
			anagrafica_ruoli_path( anagrafica_ruoli.id )
		) AS __label__
	FROM anagrafica_ruoli
		LEFT JOIN anagrafica ON anagrafica.id = anagrafica_ruoli.id_anagrafica
;

--| 000008001200

-- anagrafica_settori_view
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:35 Fabio Mosti
DROP TABLE IF EXISTS `anagrafica_settori_view`;

--| 000008001201

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
			' | ',
			settori.nome
		) AS __label__
	FROM anagrafica_settori
		LEFT JOIN anagrafica ON anagrafica.id = anagrafica_settori.id_anagrafica
		LEFT JOIN settori ON settori.id = anagrafica_settori.id_settore
;

-- NOTA per il nome del settore usare settori_path?

--| 000008001300

-- articoli_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `articoli_view`;

--| 000008001301

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
			' | ',
			articoli.id,
			' | ',
			articoli.nome
		) AS __label__
	FROM articoli
;

--| 000008001600

-- articoli_caratteristiche_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `articoli_caratteristiche_view`;

--| 000008001601

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
			' | ',
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

--| 000008001700

-- articoli_correlati_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `articoli_correlati_view`;

--| 000008001701

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
			' | ',
			tipologie_correlazioni_articoli.nome,
			' | ',
			coalesce(
				articoli_correlati.id_prodotto_correlato,
				articoli_correlati.id_articolo_correlato
			)
		) AS __label__
	FROM articoli_correlati
		LEFT JOIN tipologie_correlazioni_articoli ON tipologie_correlazioni_articoli.id = articoli_correlati.id_tipologia
;

--| 000008001800

-- attivita_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `attivita_view`;

--| 000008001801

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
			' | ',
			attivita.ore,
			' | ',
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

--| 000008002100

-- audio_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `audio_view`;

--| 000008002101

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
			' | ',
			lingue.nome
		) AS __label__
	FROM audio
		LEFT JOIN lingue ON lingue.id = audio.id_lingua
		LEFT JOIN ruoli_audio ON ruoli_audio.id = audio.id_ruolo
		LEFT JOIN tipologie_embed ON tipologie_embed.id = audio.id_tipologia_embed
;

--| FINE FILE
