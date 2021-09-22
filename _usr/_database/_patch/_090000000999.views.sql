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

--| 090000000100

-- account_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_view`;

--| 090000000101

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

--| 090000000200

-- account_gruppi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_gruppi_view`;

--| 090000000201

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

--| 090000000300

-- account_gruppi_attribuzione_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `account_gruppi_attribuzione_view`;

--| 090000000301

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

--| 090000000400

-- anagrafica_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_view`;

--| 090000000401

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
		anagrafica.data_archiviazione,
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
	WHERE anagrafica.data_archiviazione IS NULL
	GROUP BY anagrafica.id
;

--| 090000000410

-- anagrafica_archivio_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_archivio_view`;

--| 090000000411

-- anagrafica_archivio_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:15 Fabio Mosti
CREATE OR REPLACE VIEW anagrafica_archivio_view AS
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
		anagrafica.data_archiviazione,
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
	WHERE anagrafica.data_archiviazione IS NOT NULL
	GROUP BY anagrafica.id
;

--| 090000000412

-- anagrafica_corrente_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_corrente_view`;

--| 090000000413

-- anagrafica_corrente_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:15 Fabio Mosti
CREATE OR REPLACE VIEW anagrafica_corrente_view AS
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
		anagrafica.data_archiviazione,
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
	WHERE anagrafica.data_archiviazione IS NULL
	GROUP BY anagrafica.id
;

--| 090000000500

-- anagrafica_categorie_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_categorie_view`;

--| 090000000501

-- anagrafica_categorie_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:15 Fabio Mosti
-- nota: non dovrebbe esserci il path qui?
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

--| 090000000700

-- anagrafica_cittadinanze_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_cittadinanze_view`;

--| 090000000701

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

--| 090000000900

-- anagrafica_indirizzi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_indirizzi_view`;

--| 090000000901

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

--| 090000001100

-- anagrafica_ruoli_view
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:35 Fabio Mosti
DROP TABLE IF EXISTS `anagrafica_ruoli_view`;

--| 090000001101

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

--| 090000001200

-- anagrafica_settori_view
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:35 Fabio Mosti
DROP TABLE IF EXISTS `anagrafica_settori_view`;

--| 090000001201

-- anagrafica_settori_view
-- tipologia: tabella gestita
-- verifica: 2021-05-23 15:35 Fabio Mosti
CREATE OR REPLACE VIEW `anagrafica_settori_view` AS
	SELECT
		anagrafica_settori.id,
		anagrafica_settori.id_anagrafica,
		anagrafica_settori.id_settore,
		settori.nome AS settore,
		anagrafica_settori.ordine,
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

--| 090000001300

-- articoli_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `articoli_view`;

--| 090000001301

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

--| 090000001600

-- articoli_caratteristiche_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `articoli_caratteristiche_view`;

--| 090000001601

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

--| 090000001800

-- attivita_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `attivita_view`;

--| 090000001801

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

--| 090000002100

-- audio_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `audio_view`;

--| 090000002101

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

--| 090000002500

-- campagne_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `campagne_view`;

--| 090000002501

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

--| 090000002900

-- caratteristiche_prodotti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `caratteristiche_prodotti_view`;

--| 090000002901

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

--| 090000003100

-- categorie_anagrafica_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `categorie_anagrafica_view`;

--| 090000003101

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

--| 090000003700

-- categorie_notizie_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `categorie_notizie_view`;

--| 090000003701

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

--| 090000003900

-- categorie_prodotti_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `categorie_prodotti_view`;

--| 090000003901

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

--| 090000004300

-- categorie_progetti_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `categorie_progetti_view`;

--| 090000004301

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

--| 090000004500

-- categorie_risorse_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `categorie_risorse_view`;

--| 090000004501

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

--| 090000004700

-- classi_energetiche_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `classi_energetiche_view`;

--| 090000004701

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
		classi_energetiche.se_prodotti,
		concat(
			classi_energetiche.nome,
			' / ',
			colori.hex
		) AS __label__
	FROM categorie_risorse
		LEFT JOIN colori ON colori.id = classi_energetiche.id_colore
;

--| 090000005100

-- colori_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `colori_view`;

--| 090000005101

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

--| 090000005300

-- comuni_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `comuni_view`;

--| 090000005301

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

--| 090000006700

-- contatti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `contatti_view`;

--| 090000006701

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

--| 090000006900

-- contenuti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `contenuti_view`;

--| 090000006901

-- contenuti_view
-- tipologia: tabella gestita
-- verifica: 2021-06-09 10:46 Fabio Mosti
CREATE OR REPLACE VIEW contenuti_view AS
	SELECT
		contenuti.id,
		contenuti.id_lingua,
		contenuti.id_anagrafica,
		contenuti.id_prodotto,
		contenuti.id_articolo,
		contenuti.id_categoria_prodotti,
		contenuti.id_caratteristica_prodotti,
		contenuti.id_marchio,
		contenuti.id_file,
		contenuti.id_immagine,
		contenuti.id_video,
		contenuti.id_audio,
		contenuti.id_risorsa,
		contenuti.id_categoria_risorse,
		contenuti.id_pagina,
		contenuti.id_popup,
		contenuti.id_indirizzo,
		contenuti.id_notizia,
		contenuti.id_categoria_notizie,
		contenuti.id_data,
		contenuti.id_template_mail,
		contenuti.id_colore,
		contenuti.title,
		contenuti.h1,
		concat(
			contenuti.h1,
			' / ',
			lingue.nome
		) AS __label__
	FROM contenuti
		INNER JOIN lingue ON lingue.id = contenuti.id_lingua
;

--| 090000007100

-- continenti_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `continenti_view`;

--| 090000007101

-- continenti_view
-- tipologia: tabella di supporto
CREATE OR REPLACE VIEW continenti_view AS
	SELECT
		continenti.id,
		continenti.codice,
		continenti.nome,
		continenti.nome AS __label__
	FROM continenti
;

--| 090000007600

-- contratti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `contratti_view`;

--| 090000007601

-- contratti_view
-- tipologia: tabella gestita
-- verifica: 2021-06-09 13:37 Fabio Mosti
CREATE OR REPLACE VIEW `contratti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
		tipologie_contratti.nome AS tipologia,
		contratti.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		contratti.id_azienda,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS azienda,
		contratti.id_agenzia,
		coalesce( a3.denominazione , concat( a3.cognome, ' ', a3.nome ), '' ) AS agenzia,
		contratti.data_stipula,
		contratti.data_inizio,
		contratti.data_fine,
		contratti.data_inizio_rapporto,
		contratti.data_fine_rapporto,
		contratti.id_livello,
		livelli_contratti.nome AS livello,
		contratti.id_qualifica,
		qualifiche_contratti.nome AS qualifica,
		contratti.ore_settimanali,
		concat(
			tipologie_contratti.nome, 
			' / ', 
			coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ),
			' / ', 
			coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' )
		) as __label__
	FROM contratti 
		LEFT JOIN anagrafica AS a1 ON contratti.id_anagrafica = a1.id
		LEFT JOIN anagrafica AS a2 ON contratti.id_azienda = a2.id
		LEFT JOIN anagrafica AS a3 ON contratti.id_agenzia = a3.id
		LEFT JOIN tipologie_contratti ON contratti.id_tipologia = tipologie_contratti.id
		LEFT JOIN qualifiche_contratti ON contratti.id_qualifica = qualifiche_contratti.id
	WHERE data_fine_rapporto IS NULL AND (
		( data_fine IS NULL )
		OR
		( data_fine IS NOT NULL and data_fine >= CURDATE() )
	)
;

--| 090000007610

-- contratti_archivio_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `contratti_archivio_view`;

--| 090000007611

-- contratti_archivio_view
-- tipologia: tabella gestita
-- verifica: 2021-06-09 14:23 Fabio Mosti
CREATE OR REPLACE VIEW `contratti_archivio_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
		tipologie_contratti.nome AS tipologia,
		contratti.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		contratti.id_azienda,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS azienda,
		contratti.id_agenzia,
		coalesce( a3.denominazione , concat( a3.cognome, ' ', a3.nome ), '' ) AS agenzia,
		contratti.data_stipula,
		contratti.data_inizio,
		contratti.data_fine,
		contratti.data_inizio_rapporto,
		contratti.data_fine_rapporto,
		contratti.id_livello,
		livelli_contratti.nome AS livello,
		contratti.id_qualifica,
		qualifiche_contratti.nome AS qualifica,
		contratti.id_tipologia_durata,
		tipologie_durate_contratti.nome AS tipologia_durata,
		contratti.id_tipologia_orario,
		tipologie_orari_contratti.nome AS tipologia_orario,
		contratti.ore_settimanali,
		concat(
			tipologie_contratti.nome, 
			' / ', 
			coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ),
			' / ', 
			coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' )
		) as __label__
	FROM contratti 
		LEFT JOIN anagrafica AS a1 ON contratti.id_anagrafica = a1.id
		LEFT JOIN anagrafica AS a2 ON contratti.id_azienda = a2.id
		LEFT JOIN anagrafica AS a3 ON contratti.id_agenzia = a3.id
		LEFT JOIN tipologie_contratti ON contratti.id_tipologia = tipologie_contratti.id
		LEFT JOIN qualifiche_contratti ON contratti.id_qualifica = qualifiche_contratti.id
		LEFT JOIN tipologie_durate_contratti ON contratti.id_tipologia_durata = tipologie_durate_contratti.id
		LEFT JOIN tipologie_orari_contratti ON contratti.id_tipologia_orario = tipologie_orari_contratti.id
	WHERE data_fine_rapporto IS NOT NULL AND (
		( data_fine IS NOT NULL )
		OR
		( data_fine IS NOT NULL AND data_fine < CURDATE() )
	)
;

--| 090000007612

-- contratti_corrente_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `contratti_corrente_view`;

--| 090000007613

-- contratti_corrente_view
-- tipologia: tabella gestita
-- verifica: 2021-06-09 14:23 Fabio Mosti
CREATE OR REPLACE VIEW `contratti_corrente_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
		tipologie_contratti.nome AS tipologia,
		contratti.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		contratti.id_azienda,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS azienda,
		contratti.id_agenzia,
		coalesce( a3.denominazione , concat( a3.cognome, ' ', a3.nome ), '' ) AS agenzia,
		contratti.data_stipula,
		contratti.data_inizio,
		contratti.data_fine,
		contratti.data_inizio_rapporto,
		contratti.data_fine_rapporto,
		contratti.id_livello,
		livelli_contratti.nome AS livello,
		contratti.id_qualifica,
		qualifiche_contratti.nome AS qualifica,
		contratti.id_tipologia_durata,
		tipologie_durate_contratti.nome AS tipologia_durata,
		contratti.id_tipologia_orario,
		tipologie_orari_contratti.nome AS tipologia_orario,
		contratti.ore_settimanali,
		concat(
			tipologie_contratti.nome, 
			' / ', 
			coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ),
			' / ', 
			coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' )
		) as __label__
	FROM contratti 
		LEFT JOIN anagrafica AS a1 ON contratti.id_anagrafica = a1.id
		LEFT JOIN anagrafica AS a2 ON contratti.id_azienda = a2.id
		LEFT JOIN anagrafica AS a3 ON contratti.id_agenzia = a3.id
		LEFT JOIN tipologie_contratti ON contratti.id_tipologia = tipologie_contratti.id
		LEFT JOIN qualifiche_contratti ON contratti.id_qualifica = qualifiche_contratti.id
		LEFT JOIN tipologie_durate_contratti ON contratti.id_tipologia_durata = tipologie_durate_contratti.id
		LEFT JOIN tipologie_orari_contratti ON contratti.id_tipologia_orario = tipologie_orari_contratti.id
	WHERE data_fine_rapporto IS NULL AND (
		( data_fine IS NULL )
		OR
		( data_fine IS NULL OR data_fine >= CURDATE() )
	)
;

--| 090000007700

-- correlazioni_articoli_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `correlazioni_articoli_view`;

--| 090000007701

-- correlazioni_articoli_view
-- tipologia: tabella gestita
-- verifica: 2021-05-26 12:08 Fabio Mosti
CREATE OR REPLACE VIEW `correlazioni_articoli_view` AS
	SELECT
		correlazioni_articoli.id,
		correlazioni_articoli.id_tipologia,
		tipologie_correlazioni_articoli.nome AS tipologia,
		correlazioni_articoli.id_articolo,
		correlazioni_articoli.id_prodotto_correlato,
		correlazioni_articoli.id_articolo_correlato,
		correlazioni_articoli.ordine,
		correlazioni_articoli.se_upselling,
		correlazioni_articoli.se_crosselling,
		concat(
			correlazioni_articoli.id_articolo,
			' / ',
			tipologie_correlazioni_articoli.nome,
			' / ',
			coalesce(
				correlazioni_articoli.id_prodotto_correlato,
				correlazioni_articoli.id_articolo_correlato
			)
		) AS __label__
	FROM correlazioni_articoli
		LEFT JOIN tipologie_correlazioni_articoli ON tipologie_correlazioni_articoli.id = correlazioni_articoli.id_tipologia
;

--| 090000007800

-- costi_contratti
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `costi_contratti_view`;

--| 090000007801

-- costi_contratti
-- tipologia: tabella gestita
-- verifica: 2021-06-29 15:55 Fabio Mosti
CREATE OR REPLACE VIEW `costi_contratti_view` AS
	SELECT
		costi_contratti.id,
		costi_contratti.id_contratto,
		costi_contratti.costo_orario,
		CONCAT( 
			costi_contratti.id_contratto,
			' / ',
			tipologie_inps_attivita.nome,
			' / ',
			costi_contratti.costo_orario
		) AS __label__
	FROM costi_contratti
;

--| 090000008000

-- coupon_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `coupon_view`;

--| 090000008001

-- coupon_view
-- tipologia: tabella gestita
-- verifica: 2021-06-29 15:55 Fabio Mosti
CREATE OR REPLACE VIEW `coupon_view` AS
	SELECT
		coupon.id,
		coupon.nome,
		coupon.timestamp_inizio,
		from_unixtime( coupon.timestamp_inizio, '%Y-%m-%d' ) AS data_ora_inizio,
		coupon.timestamp_fine,
		from_unixtime( coupon.timestamp_fine, '%Y-%m-%d' ) AS data_ora_fine,
		coupon.sconto_percentuale,
		coupon.sconto_fisso,
		coupon.se_multiuso,
		coupon.se_globale,
		coupon.nome AS __label__
	FROM coupon
;

--| 090000008200

-- coupon_categorie_prodotti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `coupon_categorie_prodotti_view`;

--| 090000008201

-- coupon_categorie_prodotti_view
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:12 Fabio Mosti
CREATE OR REPLACE VIEW `coupon_categorie_prodotti_view` AS
	SELECT
		coupon_categorie_prodotti.id,
		coupon_categorie_prodotti.id_coupon,
		coupon_categorie_prodotti.id_categoria,
		categorie_prodotti.nome AS categoria,
		CONCAT(
			coupon.nome,
			' / ',
			categorie_prodotti.nome
		) AS __label__
	FROM coupon_categorie_prodotti
		LEFT JOIN coupon ON coupon_categorie_prodotti.id_coupon = coupon.id
		LEFT JOIN categorie_prodotti ON categorie_prodotti.id = coupon_categorie_prodotti.id_categoria
;

--| 090000008400

-- coupon_listini_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `coupon_listini_view`;

--| 090000008401

-- coupon_listini_view
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:40 Fabio Mosti
CREATE OR REPLACE VIEW `coupon_listini_view` AS
	SELECT
		coupon_listini.id,
		coupon_listini.id_coupon,
		coupon_listini.id_listino,
		listini.nome AS listino,
		CONCAT(
			coupon.nome,
			' / ',
			listini.nome
		) AS __label__
	FROM coupon_listini
		LEFT JOIN coupon ON coupon_categorie_prodotti.id_coupon = coupon.id
		LEFT JOIN listini ON listini.id = coupon_listini.id_listino
;

--| 090000008600

-- coupon_marchi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `coupon_marchi_view`;

--| 090000008601

-- coupon_marchi_view
-- tipologia: tabella gestita
-- verifica: 2021-06-29 16:40 Fabio Mosti
CREATE OR REPLACE VIEW `coupon_marchi_view` AS
	SELECT
		coupon_marchi.id,
		coupon_marchi.id_coupon,
		coupon_marchi.id_marchio,
		marchi.nome AS marchio,
		CONCAT(
			coupon.nome,
			' / ',
			marchi.nome
		) AS __label__
	FROM coupon_listini
		LEFT JOIN coupon ON coupon_categorie_prodotti.id_coupon = coupon.id
		LEFT JOIN marchi ON marchi.id = coupon_marchi.id_marchio
;

--| 090000008800

-- coupon_prodotti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `coupon_prodotti_view`;

--| 090000008801

-- coupon_prodotti_view
-- tipologia: tabella gestita
-- verifica: 2021-06-29 17:00 Fabio Mosti
CREATE OR REPLACE VIEW `coupon_prodotti_view` AS
	SELECT
		coupon_prodotti.id,
		coupon_prodotti.id_coupon,
		coupon_prodotti.id_prodotto,
		prodotti.nome AS prodotto,
		CONCAT(
			coupon.nome,
			' / ',
			prodotti.nome
		) AS __label__
	FROM coupon_listini
		LEFT JOIN coupon ON coupon_categorie_prodotti.id_coupon = coupon.id
		LEFT JOIN prodotti ON prodotti.id = coupon_prodotti.id_prodotto
;

--| 090000009000

-- coupon_stagioni_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `coupon_stagioni_view`;

--| 090000009001

-- coupon_stagioni_view
-- tipologia: tabella gestita
-- verifica: 2021-06-29 17:06 Fabio Mosti
CREATE OR REPLACE VIEW `coupon_stagioni_view` AS
	SELECT
		coupon_stagioni.id,
		coupon_stagioni.id_coupon,
		coupon_stagioni.id_stagione,
		stagioni.nome AS stagione,
		CONCAT(
			coupon.nome,
			' / ',
			stagioni.nome
		) AS __label__
	FROM coupon_listini
		LEFT JOIN coupon ON coupon_categorie_prodotti.id_coupon = coupon.id
		LEFT JOIN stagioni ON stagioni.id = coupon_stagioni.id_stagione
;

--| 090000009400

-- date_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `date_view`;

--| 090000009401

-- date_view
-- tipologia: tabella gestita
-- verifica: 2021-07-01 08:40 Fabio Mosti
CREATE OR REPLACE VIEW date_view AS
	SELECT
		date.id,
		date.id_tipologia,
		tipologie_date.nome AS tipologia,
		date.id_evento,
		eventi.nome AS evento,
		date.id_luogo,
		luoghi.nome AS luogo,
		date.nome,
		date.timestamp_inizio,
		from_unixtime( date.timestamp_inizio, '%Y-%m-%d' ) AS data_ora_inizio,
		date.timestamp_fine,
		from_unixtime( date.timestamp_fine, '%Y-%m-%d' ) AS data_ora_fine,
		CONCAT(
			eventi.nome,
			' / ',
			luoghi.nome,
			' / ',
			date.nome,
			' / ',
			from_unixtime( date.timestamp_inizio, '%Y-%m-%d' ),
			' / ',
			from_unixtime( date.timestamp_fine, '%Y-%m-%d' )
		) AS __label__
	FROM date
		LEFT JOIN tipologie_date ON tipologie_date.id = date.id_tipologia
		LEFT JOIN eventi ON eventi.id = date.id_evento
		LEFT JOIN luoghi ON luoghi.id = date.id_luogo
;

--| 090000009800

-- documenti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `documenti_view`;

--| 090000009801

-- documenti_view
-- tipologia: tabella gestita
-- verifica: 2021-09-03 17:25 Fabio Mosti
CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		concat(
			tipologie.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' per ',
			coalesce(
				a2.denominazione,
				concat(
					a2.cognome,
					' ',
					a2.nome
				),
				''
			)
		) AS __label__
    FROM
		documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
;

--| 090000010000

-- documenti_articoli_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `documenti_articoli_view`;

--| 090000010001

-- documenti_articoli_view
-- tipologia: tabella gestita
-- verifica: 2021-09-10 16:54 Fabio Mosti
CREATE OR REPLACE VIEW `documenti_articoli_view` AS
    SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
		documenti_articoli.data,
		documenti_articoli.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti_articoli.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti_articoli.id_reparto,
		documenti_articoli.id_progetto,
		documenti_articoli.id_todo,
		documenti_articoli.id_attivita,
		documenti_articoli.id_articolo,
		documenti_articoli.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
		documenti_articoli.id_listino,
		documenti_articoli.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.id_iva,
		iva.nome AS iva,
		documenti_articoli.nome,
		concat(
			documenti_articoli.data,
			' / ',
			tipologie_documenti.nome,
			' / ',
			documenti_articoli.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			documenti_articoli.nome,
			' / ',
			documenti_articoli.importo_netto_totale,
			' ',
			valute.utf8
			' +IVA ',
			iva.aliquota,
			' % '
		) AS __label__
	FROM
		documenti_articoli
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti_articoli.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti_articoli.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti_articoli.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN iva ON iva.id = documenti_articoli.id_iva
;

--| 090000015000

-- file_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `file_view`;

--| 090000015001

-- file_view
-- tipologia: tabella gestita
-- verifica: 2021-09-10 16:54 Fabio Mosti
CREATE OR REPLACE VIEW `file_view` AS
	SELECT
		file.id,
		file.ordine,
		file.id_ruolo,
		ruoli_file.nome AS ruolo,
		file.id_anagrafica,
		file.id_prodotto,
		file.id_articolo,
		file.id_categoria_prodotti,
		file.id_todo,
		file.id_pagina,
		file.id_template_mail,
		file.id_notizia,
		file.id_categoria_notizie,
		file.id_risorsa,
		file.id_categoria_risorse,
		file.id_lingua,
		lingue.iso31661alpha3 AS lingua,
		file.path,
		file.url,
		file.nome,
		concat(
			ruoli_file.nome,
			' # ',
			file.ordine,
			' / ',
			file.nome,
			' / ',
			coalesce(
				file.path,
				file.url
			)
		) AS __label__
	FROM file
		LEFT JOIN ruoli_file ON ruoli_file.id = file.id_ruolo
;

--| 090000015200

-- gruppi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `gruppi_view`;

--| 090000015201

-- gruppi_view
-- tipologia: tabella gestita
-- verifica: 2021-09-10 18:07 Fabio Mosti
CREATE OR REPLACE VIEW `gruppi_view` AS
	SELECT
		gruppi.id,
		gruppi.id_genitore,
		gruppi.id_organizzazione,
		gruppi.nome,
		gruppi_path( gruppi.id ) AS __label__
	FROM gruppi
;






























--| 090000009200

-- task_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `task_view`;

--| 090000009201

-- task_view
-- tipologia: tabella gestita
-- verifica: 2021-06-30 11:57 Fabio Mosti
CREATE OR REPLACE VIEW task_view AS
	SELECT
		task.id,
		task.minuto,
		task.ora,
		task.giorno_del_mese,
		task.mese,
		task.giorno_della_settimana,
		task.settimana,
		task.task,
		task.iterazioni,
		task.delay,
		task.token,
		task.timestamp_esecuzione,
		CONCAT(
			' / ',
			coalesce( task.minuto, '*' ),
			' / ',
			coalesce( task.ora, '*' ),
			' / ',
			coalesce( task.giorno_del_mese, '*' ),
			' / ',
			coalesce( task.mese, '*' ),
			' / ',
			coalesce( task.giorno_della_settimana, '*' ),
			' / ',
			coalesce( task.settimana, '*' ),
			' / ',
			task.task
		) AS __label__
	FROM task
;





--| FINE FILE
