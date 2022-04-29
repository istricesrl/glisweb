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

--| 090000000010

-- abbonamenti_view
-- tipologia: vista virtuale
-- verifica: 2021-09-10 16:54 Fabio Mosti
DROP TABLE IF EXISTS `abbonamenti_view`;

--| 090000000011

-- abbonamenti_view
-- tipologia: vista virtuale
-- verifica: 2021-09-10 16:54 Fabio Mosti
CREATE OR REPLACE VIEW `abbonamenti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
    WHERE tipologie_contratti.se_abbonamento = 1
;

--| 090000000020

-- abbonamenti_attivi_view
-- tipologia: vista virtuale
-- verifica: 2021-09-10 16:54 Fabio Mosti
DROP TABLE IF EXISTS `abbonamenti_attivi_view`;

--| 090000000021

-- abbonamenti_attivi_view
-- tipologia: vista virtuale
-- verifica: 2021-09-10 16:54 Fabio Mosti
CREATE OR REPLACE VIEW `abbonamenti_attivi_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_abbonamento = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
    GROUP BY contratti.id
;

--| 090000000030

-- abbonamenti_archiviati_view
-- tipologia: vista virtuale
-- verifica: 2021-09-10 16:54 Fabio Mosti
DROP TABLE IF EXISTS `abbonamenti_archiviati_view`;

--| 090000000031

-- abbonamenti_archiviati_view
-- tipologia: vista virtuale
-- verifica: 2021-09-10 16:54 Fabio Mosti
CREATE OR REPLACE VIEW `abbonamenti_archiviati_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_abbonamento = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio >= CURRENT_DATE() ) AND  rinnovi.data_fine < CURRENT_DATE() 
    GROUP BY contratti.id
;

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
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), NULL ) AS anagrafica,
		account.id_mail,
		mail.indirizzo AS mail,
		account.username,
		account.password,
		account.se_attivo,
		account.token,
		account.timestamp_login,
		account.timestamp_cambio_password,
		group_concat( gruppi.nome ORDER BY gruppi.id SEPARATOR '|' ) AS gruppi,
		group_concat( gruppi.id ORDER BY gruppi.id SEPARATOR '|' ) AS id_gruppi,
		group_concat(
			DISTINCT
			concat( account_gruppi_attribuzione.entita,'#',account_gruppi_attribuzione.id_gruppo )
			ORDER BY account_gruppi_attribuzione.entita,account_gruppi_attribuzione.id_gruppo
			SEPARATOR '|' ) AS id_gruppi_attribuzione,
		account.id_account_inserimento,
		account.id_account_aggiornamento,
		account.username AS __label__
	FROM account
		LEFT JOIN anagrafica ON anagrafica.id = account.id_anagrafica
		LEFT JOIN mail ON mail.id = account.id_mail
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
		account.username AS account,
		account_gruppi.id_gruppo,
		gruppi.nome AS gruppo,
		account_gruppi.ordine,
		account_gruppi.se_amministratore,
		account_gruppi.id_account_inserimento,
		account_gruppi.id_account_aggiornamento,
		concat(
			account.username,
			' / ',
			gruppi.nome
		) AS __label__
	FROM account_gruppi
		LEFT JOIN account ON account.id = account_gruppi.id_account
		LEFT JOIN gruppi ON gruppi.id = account_gruppi.id_gruppo
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
		account_gruppi_attribuzione.ordine,
		account_gruppi_attribuzione.entita,
		account_gruppi_attribuzione.id_account_inserimento,
		account_gruppi_attribuzione.id_account_aggiornamento,
		concat(
			account.username,
			' / ',
			gruppi.nome,
			' / ',
			account_gruppi_attribuzione.entita
		) AS __label__
	FROM account_gruppi_attribuzione
		LEFT JOIN account ON account.id = account_gruppi_attribuzione.id_account
		LEFT JOIN gruppi ON gruppi.id = account_gruppi_attribuzione.id_gruppo
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
		tipologie_anagrafica.nome AS tipologia,
		anagrafica.codice,
		anagrafica.riferimento,
		anagrafica.nome,
		anagrafica.cognome,
		anagrafica.denominazione,
		anagrafica.soprannome,
		anagrafica.sesso,
		anagrafica.codice_fiscale,
		anagrafica.partita_iva,
		ranking.nome AS ranking,
		anagrafica.recapiti,
		max( categorie_anagrafica.se_prospect ) AS se_prospect,
		max( categorie_anagrafica.se_lead ) AS se_lead,
		max( categorie_anagrafica.se_cliente ) AS se_cliente,
		max( categorie_anagrafica.se_fornitore ) AS se_fornitore,
		max( categorie_anagrafica.se_produttore ) AS se_produttore,
		max( categorie_anagrafica.se_collaboratore ) AS se_collaboratore,
		max( categorie_anagrafica.se_interno ) AS se_interno,
		max( categorie_anagrafica.se_esterno ) AS se_esterno,
		max( categorie_anagrafica.se_commerciale ) AS se_commerciale,
		max( categorie_anagrafica.se_concorrente ) AS se_concorrente,
		max( categorie_anagrafica.se_gestita ) AS se_gestita,
		max( categorie_anagrafica.se_amministrazione ) AS se_amministrazione,
		max( categorie_anagrafica.se_notizie ) AS se_notizie,
		group_concat( DISTINCT categorie_anagrafica_path( categorie_anagrafica.id ) SEPARATOR ' | ' ) AS categorie,
		group_concat( DISTINCT telefoni.numero SEPARATOR ' | ' ) AS telefoni,
		group_concat( DISTINCT mail.indirizzo SEPARATOR ' | ' ) AS mail,
		concat_ws( '-', anagrafica.anno_nascita, anagrafica.mese_nascita, anagrafica.giorno_nascita ) AS data_nascita,
		anagrafica.data_archiviazione,
		anagrafica.id_account_inserimento,
		anagrafica.id_account_aggiornamento,
		coalesce(
			anagrafica.soprannome,
			anagrafica.denominazione,
			concat_ws(' ', coalesce(anagrafica.cognome, ''),
			coalesce(anagrafica.nome, '') ),
			''
		) AS __label__
	FROM anagrafica
		LEFT JOIN tipologie_anagrafica ON tipologie_anagrafica.id = anagrafica.id_tipologia
		LEFT JOIN ranking ON ranking.id = anagrafica.id_ranking
		LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id
		LEFT JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
		LEFT JOIN telefoni ON telefoni.id_anagrafica = anagrafica.id
		LEFT JOIN mail ON mail.id_anagrafica = anagrafica.id
	GROUP BY anagrafica.id
;

--| 090000000410

-- anagrafica_archiviati_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_archiviati_view`;

--| 090000000411

-- anagrafica_archiviati_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:15 Fabio Mosti
CREATE OR REPLACE VIEW anagrafica_archiviati_view AS
	SELECT
		anagrafica.id,
		tipologie_anagrafica.nome AS tipologia,
		anagrafica.codice,
		anagrafica.riferimento,
		anagrafica.nome,
		anagrafica.cognome,
		anagrafica.denominazione,
		anagrafica.soprannome,
		anagrafica.sesso,
		anagrafica.codice_fiscale,
		anagrafica.partita_iva,
		ranking.nome AS ranking,
		anagrafica.recapiti,
		max( categorie_anagrafica.se_prospect ) AS se_prospect,
		max( categorie_anagrafica.se_lead ) AS se_lead,
		max( categorie_anagrafica.se_cliente ) AS se_cliente,
		max( categorie_anagrafica.se_fornitore ) AS se_fornitore,
		max( categorie_anagrafica.se_produttore ) AS se_produttore,
		max( categorie_anagrafica.se_collaboratore ) AS se_collaboratore,
		max( categorie_anagrafica.se_interno ) AS se_interno,
		max( categorie_anagrafica.se_esterno ) AS se_esterno,
		max( categorie_anagrafica.se_commerciale ) AS se_commerciale,
		max( categorie_anagrafica.se_concorrente ) AS se_concorrente,
		max( categorie_anagrafica.se_gestita ) AS se_gestita,
		max( categorie_anagrafica.se_amministrazione ) AS se_amministrazione,
		max( categorie_anagrafica.se_notizie ) AS se_notizie,
		group_concat( DISTINCT categorie_anagrafica_path( categorie_anagrafica.id ) SEPARATOR ' | ' ) AS categorie,
		group_concat( DISTINCT telefoni.numero SEPARATOR ' | ' ) AS telefoni,
		group_concat( DISTINCT mail.indirizzo SEPARATOR ' | ' ) AS mail,
		concat_ws( '-', anagrafica.anno_nascita, anagrafica.mese_nascita, anagrafica.giorno_nascita ) AS data_nascita,
		anagrafica.data_archiviazione,
		anagrafica.id_account_inserimento,
		anagrafica.id_account_aggiornamento,
		coalesce(
			anagrafica.soprannome,
			anagrafica.denominazione,
			concat_ws(' ', coalesce(anagrafica.cognome, ''),
			coalesce(anagrafica.nome, '') ),
			''
		) AS __label__
	FROM anagrafica
		LEFT JOIN tipologie_anagrafica ON tipologie_anagrafica.id = anagrafica.id_tipologia
		LEFT JOIN ranking ON ranking.id = anagrafica.id_ranking
		LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id
		LEFT JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
		LEFT JOIN telefoni ON telefoni.id_anagrafica = anagrafica.id
		LEFT JOIN mail ON mail.id_anagrafica = anagrafica.id
	WHERE anagrafica.data_archiviazione IS NOT NULL
	GROUP BY anagrafica.id
;

--| 090000000412

-- anagrafica_attivi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_attivi_view`;

--| 090000000413

-- anagrafica_attivi_view
-- tipologia: tabella gestita
-- verifica: 2021-05-20 19:15 Fabio Mosti
CREATE OR REPLACE VIEW anagrafica_attivi_view AS
	SELECT
		anagrafica.id,
		tipologie_anagrafica.nome AS tipologia,
		anagrafica.codice,
		anagrafica.riferimento,
		anagrafica.nome,
		anagrafica.cognome,
		anagrafica.denominazione,
		anagrafica.soprannome,
		anagrafica.sesso,
		anagrafica.codice_fiscale,
		anagrafica.partita_iva,
		ranking.nome AS ranking,
		anagrafica.recapiti,
		max( categorie_anagrafica.se_prospect ) AS se_prospect,
		max( categorie_anagrafica.se_lead ) AS se_lead,
		max( categorie_anagrafica.se_cliente ) AS se_cliente,
		max( categorie_anagrafica.se_fornitore ) AS se_fornitore,
		max( categorie_anagrafica.se_produttore ) AS se_produttore,
		max( categorie_anagrafica.se_collaboratore ) AS se_collaboratore,
		max( categorie_anagrafica.se_interno ) AS se_interno,
		max( categorie_anagrafica.se_esterno ) AS se_esterno,
		max( categorie_anagrafica.se_commerciale ) AS se_commerciale,
		max( categorie_anagrafica.se_concorrente ) AS se_concorrente,
		max( categorie_anagrafica.se_gestita ) AS se_gestita,
		max( categorie_anagrafica.se_amministrazione ) AS se_amministrazione,
		max( categorie_anagrafica.se_notizie ) AS se_notizie,
		group_concat( DISTINCT categorie_anagrafica_path( categorie_anagrafica.id ) SEPARATOR ' | ' ) AS categorie,
		group_concat( DISTINCT telefoni.numero SEPARATOR ' | ' ) AS telefoni,
		group_concat( DISTINCT mail.indirizzo SEPARATOR ' | ' ) AS mail,
		concat_ws( '-', anagrafica.anno_nascita, anagrafica.mese_nascita, anagrafica.giorno_nascita ) AS data_nascita,
		anagrafica.data_archiviazione,
		anagrafica.id_account_inserimento,
		anagrafica.id_account_aggiornamento,
		coalesce(
			anagrafica.soprannome,
			anagrafica.denominazione,
			concat_ws(' ', coalesce(anagrafica.cognome, ''),
			coalesce(anagrafica.nome, '') ),
			''
		) AS __label__
	FROM anagrafica
		LEFT JOIN tipologie_anagrafica ON tipologie_anagrafica.id = anagrafica.id_tipologia
		LEFT JOIN ranking ON ranking.id = anagrafica.id_ranking
		LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id
		LEFT JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
		LEFT JOIN telefoni ON telefoni.id_anagrafica = anagrafica.id
		LEFT JOIN mail ON mail.id_anagrafica = anagrafica.id
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
CREATE OR REPLACE VIEW anagrafica_categorie_view AS
	SELECT
		anagrafica_categorie.id,
		anagrafica_categorie.id_anagrafica,
		anagrafica_categorie.id_categoria,
		anagrafica_categorie.id_account_inserimento,
		anagrafica_categorie.id_account_aggiornamento,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			categorie_anagrafica_path( anagrafica_categorie.id_categoria )
		) AS __label__
	FROM anagrafica_categorie
		LEFT JOIN anagrafica ON anagrafica.id = anagrafica_categorie.id_anagrafica
;

--| 090000000600

-- anagrafica_certificazioni
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `anagrafica_certificazioni_view`;

--| 090000000601

-- anagrafica_certificazioni
-- tipologia: tabella gestita
-- verifica: 2022-02-03 11:12 Chiara GDL
CREATE OR REPLACE VIEW `anagrafica_certificazioni_view` AS
	SELECT
		anagrafica_certificazioni.id,
		anagrafica_certificazioni.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		anagrafica_certificazioni.id_certificazione,
		certificazioni.nome AS certificazione,
		anagrafica_certificazioni.id_emittente,
		coalesce( emittente.denominazione , concat( emittente.cognome, ' ', emittente.nome ), '' ) AS emittente,
		anagrafica_certificazioni.nome,
		anagrafica_certificazioni.codice,
		anagrafica_certificazioni.data_emissione,
		anagrafica_certificazioni.data_scadenza,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			certificazioni.nome,
			' - ',
			anagrafica_certificazioni.codice
		) AS __label__
	FROM anagrafica_certificazioni
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_certificazioni.id_anagrafica
		INNER JOIN anagrafica AS emittente ON emittente.id = anagrafica_certificazioni.id_emittente
		INNER JOIN certificazioni ON certificazioni.id = anagrafica_certificazioni.id_certificazione		
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
		anagrafica_cittadinanze.id_account_inserimento,
		anagrafica_cittadinanze.id_account_aggiornamento,
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
		anagrafica_indirizzi.id_anagrafica,
		anagrafica_indirizzi.id_indirizzo,
		concat(
			indirizzi.indirizzo,
			' ',
			comuni.nome,
			' ',
			provincie.sigla
		) AS indirizzo,
		anagrafica_indirizzi.id_ruolo,
		ruoli_indirizzi.nome AS ruolo,
		anagrafica_indirizzi.id_account_inserimento,
		anagrafica_indirizzi.id_account_aggiornamento,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			tipologie_indirizzi.nome,
			' ',
			indirizzi.indirizzo,
			' ',
			indirizzi.civico,
			' ',
			comuni.nome,
			' ',
			provincie.sigla
		) AS __label__
	FROM anagrafica_indirizzi
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_indirizzi.id_anagrafica
		LEFT JOIN ruoli_indirizzi ON ruoli_indirizzi.id = anagrafica_indirizzi.id_ruolo
		LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
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
		anagrafica_settori.id_account_inserimento,
		anagrafica_settori.id_account_aggiornamento,
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
        articoli.id_udm_dimensioni,
		udm_dimensioni.sigla AS udm_dimensioni,
		articoli.peso,
        articoli.id_udm_peso,
		udm_peso.sigla AS udm_peso,
		articoli.volume,
        articoli.id_udm_volume,
		udm_volume.sigla AS udm_volume,
		articoli.capacita,
        articoli.id_udm_capacita,
		udm_capacita.sigla AS udm_capacita,
        articoli.durata,
        articoli.id_udm_durata,
		udm_durata.sigla AS udm_durata,
		concat_ws(
			' ',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat_ws(
					' ',
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat_ws(
					' ',
					articoli.peso,
					udm_peso.sigla
				),
				concat_ws(
					' ',
					articoli.volume,
					udm_volume.sigla
				),
				concat_ws(
					' ',
					articoli.capacita,
					udm_capacita.sigla
				),
				concat_ws(
					' ',
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS nome,
		group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			articoli.nome,
			coalesce(
				concat_ws(
					' ',
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat_ws(
					' ',
					articoli.peso,
					udm_peso.sigla
				),
				concat_ws(
					' ',
					articoli.volume,
					udm_volume.sigla
				),
				concat_ws(
					' ',
					articoli.capacita,
					udm_capacita.sigla
				),
				concat_ws(
					' ',
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS __label__
	FROM articoli
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = articoli.id_prodotto
	GROUP BY articoli.id
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
			articoli_caratteristiche.id_articolo,
			': ',
			caratteristiche_prodotti.nome,
			' ',
			articoli_caratteristiche.valore
		) AS __label__
	FROM articoli_caratteristiche
		LEFT JOIN caratteristiche_prodotti ON caratteristiche_prodotti.id = articoli_caratteristiche.id_caratteristica
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
		attivita.id_cliente,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		attivita.id_indirizzo,
		indirizzi.indirizzo AS indirizzo,
		attivita.id_luogo,
		luoghi_path( attivita.id_luogo ) AS luogo,
		attivita.data_scadenza,
		attivita.ora_scadenza,
		attivita.data_programmazione,
		attivita.ora_inizio_programmazione,
		attivita.ora_fine_programmazione,
		attivita.id_anagrafica_programmazione,
		coalesce( a3.denominazione , concat( a3.cognome, ' ', a3.nome ), '' ) AS anagrafica_programmazione,
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
		attivita.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		attivita.ore,
		attivita.nome,
		attivita.id_documento,
		concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			documenti.sezionale,
			' del ',
			documenti.data
		) AS documento,
		attivita.id_progetto,
		progetti.nome AS progetto,
		attivita.id_matricola,
		attivita.id_todo,
		todo.nome AS todo,
		attivita.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		attivita.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		attivita.codice_archivium,
		attivita.token,
		attivita.id_account_inserimento,
		attivita.id_account_aggiornamento,
		concat(
			attivita.nome,
			' / ',
			attivita.ore,
			' / ',
			coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM attivita
		LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = attivita.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = attivita.id_cliente
		LEFT JOIN anagrafica AS a3 ON a3.id = attivita.id_anagrafica_programmazione
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = attivita.id_progetto
		LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria
		LEFT JOIN progetti ON progetti.id = attivita.id_progetto
		LEFT JOIN todo ON todo.id = attivita.id_todo
		LEFT JOIN indirizzi ON indirizzi.id = attivita.id_indirizzo
		LEFT JOIN mastri AS m1 ON m1.id = attivita.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = attivita.id_mastro_destinazione
		LEFT JOIN documenti ON documenti.id = attivita.id_documento
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
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
		audio.id_embed,
		embed.nome AS embed,
		audio.codice_embed,
		audio.embed_custom,
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
		audio.id_indirizzo,
		audio.id_edificio,
		audio.id_immobile,
		concat(
			audio.nome,
			' / ',
			lingue.nome
		) AS __label__
	FROM audio
		LEFT JOIN lingue ON lingue.id = audio.id_lingua
		LEFT JOIN ruoli_audio ON ruoli_audio.id = audio.id_ruolo
		LEFT JOIN embed ON embed.id = audio.id_embed
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
		caratteristiche_prodotti.nome,
		caratteristiche_prodotti.html_entity,
		caratteristiche_prodotti.font_awesome,
		caratteristiche_prodotti.se_categoria,
		caratteristiche_prodotti.se_prodotto,
		caratteristiche_prodotti.se_articolo,
		caratteristiche_prodotti.id_account_inserimento,
		caratteristiche_prodotti.id_account_aggiornamento,
		caratteristiche_prodotti.nome AS __label__
	FROM caratteristiche_prodotti
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
		categorie_anagrafica.se_fornitore,
		categorie_anagrafica.se_produttore,
		categorie_anagrafica.se_collaboratore,
		categorie_anagrafica.se_interno,
		categorie_anagrafica.se_esterno,
		categorie_anagrafica.se_concorrente,
		categorie_anagrafica.se_gestita,
		categorie_anagrafica.se_amministrazione,
		categorie_anagrafica.se_produzione,
		categorie_anagrafica.se_commerciale,
		categorie_anagrafica.se_notizie,
		count( c1.id ) AS figli,
		count( anagrafica_categorie.id ) AS membri,
		categorie_anagrafica.id_account_inserimento,
		categorie_anagrafica.id_account_aggiornamento,
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
		categorie_notizie.schema_html,
		categorie_notizie.tema_css,
		categorie_notizie.se_sitemap,
		categorie_notizie.se_cacheable,
		categorie_notizie.id_sito,
		categorie_notizie.id_pagina,
		count( c1.id ) AS figli,
		count( notizie_categorie.id ) AS membri,
		categorie_notizie.id_account_inserimento,
		categorie_notizie.id_account_aggiornamento,
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
		categorie_prodotti.schema_html,
		categorie_prodotti.tema_css,
		categorie_prodotti.se_sitemap,
		categorie_prodotti.se_cacheable,
		categorie_prodotti.id_sito,
		categorie_prodotti.id_pagina,
		count( c1.id ) AS figli,
		count( prodotti_categorie.id ) AS membri,
		categorie_prodotti.id_account_inserimento,
		categorie_prodotti.id_account_aggiornamento,
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
		categorie_progetti.template,
		categorie_progetti.schema_html,
		categorie_progetti.tema_css,
		categorie_progetti.se_sitemap,
		categorie_progetti.se_cacheable,
		categorie_progetti.id_sito,
		categorie_progetti.id_pagina,
		categorie_progetti.se_straordinario,
		categorie_progetti.se_ordinario,
		categorie_progetti.se_materia,
		categorie_progetti.se_classe,
		count( c1.id ) AS figli,
		count( progetti_categorie.id ) AS membri,
		categorie_progetti.id_account_inserimento,
		categorie_progetti.id_account_aggiornamento,
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
		categorie_risorse.template,
		categorie_risorse.schema_html,
		categorie_risorse.tema_css,
		categorie_risorse.se_sitemap,
		categorie_risorse.se_cacheable,
		categorie_risorse.id_sito,
		categorie_risorse.id_pagina,
		count( c1.id ) AS figli,
		count( risorse_categorie.id ) AS membri,
		categorie_risorse.id_account_inserimento,
		categorie_risorse.id_account_aggiornamento,
		categorie_risorse_path( categorie_risorse.id ) AS __label__
	FROM categorie_risorse
		LEFT JOIN categorie_risorse AS c1 ON c1.id_genitore = categorie_risorse.id
		LEFT JOIN risorse_categorie ON risorse_categorie.id_categoria = categorie_risorse.id
	GROUP BY categorie_risorse.id
;

--| 090000004700
-- certificazioni
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `certificazioni_view`;

--| 090000004701
-- certificazioni
-- tipologia: tabella assistita
-- verifica: 2022-02-03 11:12 Chiara GDL
CREATE OR REPLACE VIEW certificazioni_view AS
	SELECT
		certificazioni.id,
		certificazioni.nome,
	 	certificazioni.nome AS __label__
	FROM certificazioni
;

--| 090000004800

-- chiavi_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `chiavi_view`;

--| 090000004801

-- chiavi_view
-- tipologia: tabella gestita
-- verifica: 2021-11-15 12:29 Chiara GDL
CREATE OR REPLACE VIEW chiavi_view AS
	SELECT
		chiavi.id,
		chiavi.id_licenza,
		licenze.nome AS licenza,
        chiavi.id_tipologia,
        tipologie_chiavi.nome AS tipologia,
		chiavi.codice,
		chiavi.seriale,
		chiavi.nome,
		chiavi.id_account_inserimento,
		chiavi.id_account_aggiornamento,
		chiavi.nome AS __label__
	FROM chiavi
		LEFT JOIN licenze ON licenze.id = chiavi.id_licenza
        LEFT JOIN tipologie_chiavi ON tipologie_chiavi.id = chiavi.id_tipologia
;

--| 090000005000

-- classi_energetiche_view
-- tipologia: tabella standard
DROP TABLE IF EXISTS `classi_energetiche_view`;

--| 090000005001

-- classi_energetiche_view
-- tipologia: tabella standard
-- verifica: 2022-04-28 22:22 Chiara GDL
CREATE OR REPLACE VIEW classi_energetiche_view AS
	SELECT
		classi_energetiche.id,
		classi_energetiche.nome,
		classi_energetiche.ep_min,
		classi_energetiche.ep_max,
		classi_energetiche.rgb,
		classi_energetiche.nome AS __label__
	FROM classi_energetiche
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
-- tipologia: tabella standard
DROP TABLE IF EXISTS `comuni_view`;

--| 090000005301

-- comuni_view
-- tipologia: tabella standard
-- verifica: 2021-06-03 20:31 Fabio Mosti
CREATE OR REPLACE VIEW comuni_view AS
	SELECT
		comuni.id,
		comuni.id_provincia,
		provincie.nome AS provincia,
		provincie.sigla AS sigla_provincia,
		provincie.id_regione,
		regioni.nome AS regione,
		regioni.id_stato,
		stati.nome AS stato,
		comuni.nome,
		comuni.codice_istat,
		comuni.codice_catasto,
		concat(
			comuni.nome, ' ',
			coalesce( concat( '(', provincie.sigla, ') '), ' ' ),
			stati.nome
		) AS __label__
	FROM comuni
		INNER JOIN provincie ON provincie.id = comuni.id_provincia
		INNER JOIN regioni ON regioni.id = provincie.id_regione
		INNER JOIN stati ON stati.id = regioni.id_stato
;

--| 090000006000

-- condizioni_view
-- tipologia: tabella standard
DROP TABLE IF EXISTS `condizioni_view`;

--| 090000006001

-- condizioni_view
-- tipologia: tabella standard
-- verifica: 2022-04-28 16:12 Chiara GDL
CREATE OR REPLACE VIEW condizioni_view AS
	SELECT
		condizioni.id,
		condizioni.nome,
		condizioni.se_immobili,
		condizioni.se_catalogo,
		condizioni.nome AS __label__
	FROM
		condizioni
;

--| 090000006200

-- condizioni_pagamento
-- tipologia: tabella standard
DROP TABLE IF EXISTS `condizioni_pagamento_view`;

--| 090000006201

-- condizioni_pagamento
-- tipologia: tabella standard
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE OR REPLACE VIEW condizioni_pagamento_view AS
	SELECT
		condizioni_pagamento.id,
		condizioni_pagamento.codice,
		condizioni_pagamento.nome,
		condizioni_pagamento.note,
		concat( condizioni_pagamento.codice, ' - ', condizioni_pagamento.nome) AS __label__
	FROM
		condizioni_pagamento
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
		contatti.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		contatti.id_inviante,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS inviante,
		contatti.nome,
		contatti.timestamp_contatto,
		contatti.id_account_inserimento,
		contatti.id_account_aggiornamento,
		concat(
			tipologie_contatti.nome,
			' / ',
			contatti.nome
		) AS __label__
	FROM contatti
		LEFT JOIN tipologie_contatti ON tipologie_contatti.id = contatti.id_tipologia
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
		contenuti.id_edificio,
		contenuti.id_immobile,
		contenuti.id_notizia,
		contenuti.id_categoria_notizie,
		contenuti.id_template,
		contenuti.id_colore,
		contenuti.id_progetto,
		contenuti.id_categoria_progetti,
		contenuti.title,
		contenuti.h1,
		contenuti.id_account_inserimento,
		contenuti.id_account_aggiornamento,
		concat(
			contenuti.h1,
			' / ',
			lingue.nome
		) AS __label__
	FROM contenuti
		INNER JOIN lingue ON lingue.id = contenuti.id_lingua
;

--| 090000006950

-- conti_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `conti_view`;

--| 090000006951

-- conti_view
-- tipologia: vista virtuale
-- verifica: 2022-01-28 14:51 Chiara GDL
CREATE OR REPLACE VIEW `conti_view` AS
	SELECT
		mastri.id,
		mastri.id_tipologia,
		tipologie_mastri.nome AS tipologia,
		mastri.nome,
		mastri_path( mastri.id ) AS __label__
	FROM mastri
		INNER JOIN tipologie_mastri ON tipologie_mastri.id = mastri.id_tipologia
WHERE tipologie_mastri.se_conto = 1
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

--| 090000007200

-- contratti_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
CREATE OR REPLACE VIEW `contratti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.id_immobile,
		immobili.nome AS immobile,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		group_concat( DISTINCT concat( coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),': ', ruoli_anagrafica.nome ) SEPARATOR ' | ' ) AS parti,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN immobili ON immobili.id = contratti.id_immobile
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id
		LEFT JOIN anagrafica ON anagrafica.id = contratti_anagrafica.id_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = contratti_anagrafica.id_ruolo
	GROUP BY contratti.id, tipologie_contratti.nome
;


--| 090000007300

-- contratti_anagrafica_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `contratti_anagrafica_view`;

--| 090000007301

-- contratti_anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
CREATE OR REPLACE VIEW  contratti_anagrafica_view AS 
	SELECT 
		contratti_anagrafica.id,
		contratti_anagrafica.id_contratto,
		contratti_anagrafica.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		contratti_anagrafica.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		contratti_anagrafica.ordine,
		contratti_anagrafica.id_account_inserimento ,
		contratti_anagrafica.id_account_aggiornamento ,
		concat( 'contratto ', contratti.nome, ' - ', coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ), ' ruolo ', ruoli_anagrafica.nome  ) AS __label__
	FROM contratti_anagrafica
		LEFT JOIN contratti ON contratti.id = contratti_anagrafica.id_contratto
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = contratti_anagrafica.id_ruolo
		LEFT JOIN anagrafica ON anagrafica.id = contratti_anagrafica.id_anagrafica;

--| 090000007201

-- contratti_attivi_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
CREATE OR REPLACE VIEW `contratti_attivi_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
    GROUP BY contratti.id
;

--| 090000007202

-- contratti_archiviati_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:50 Chiara GDL
CREATE OR REPLACE VIEW `contratti_archiviati_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio >= CURRENT_DATE() ) AND  rinnovi.data_fine < CURRENT_DATE() 
    GROUP BY contratti.id
;

--| 090000007500

-- corsi_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `corsi_view`;

--| 090000007501

-- corsi_view
-- tipologia: vista virtuale
-- verifica: 2022-04-13 11:50 Chiara GDL
CREATE OR REPLACE VIEW `corsi_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			' cliente ',
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
	WHERE tipologie_progetti.se_didattica = 1
	GROUP BY progetti.id
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
		coupon.id_account_inserimento,
		coupon.id_account_aggiornamento,
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
		coupon_categorie_prodotti.ordine,
		coupon_categorie_prodotti.id_account_inserimento,
		coupon_categorie_prodotti.id_account_aggiornamento,
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
		coupon_listini.ordine,
		coupon_listini.id_account_inserimento,
		coupon_listini.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			listini.nome
		) AS __label__
	FROM coupon_listini
		LEFT JOIN coupon ON coupon.id = coupon_listini.id_coupon
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
		coupon_marchi.ordine,
		coupon_marchi.id_account_inserimento,
		coupon_marchi.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			marchi.nome
		) AS __label__
	FROM coupon_marchi
		LEFT JOIN coupon ON coupon.id = coupon_marchi.id_coupon
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
		coupon_prodotti.ordine,
		coupon_prodotti.id_account_inserimento,
		coupon_prodotti.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			prodotti.nome
		) AS __label__
	FROM coupon_prodotti
		LEFT JOIN coupon ON coupon.id = coupon_prodotti.id_coupon
		LEFT JOIN prodotti ON prodotti.id = coupon_prodotti.id_prodotto
;

--| 090000009700

-- ddt_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `ddt_view`;

--| 090000009701

-- ddt_view
-- tipologia: vista virtuale
-- verifica: 2022-01-28 14:25 chiara gdl
CREATE OR REPLACE VIEW `ddt_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.nome,
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
    FROM documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
   	WHERE tipologie_documenti.se_trasporto IS NOT NULL
;

--| 090000009710

-- ddt_attivi_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `ddt_attivi_view`;

--| 090000009711

-- ddt_attivi_view
-- tipologia: vista virtuale
-- verifica: 2022-01-28 14:25 chiara gdl
CREATE OR REPLACE VIEW `ddt_attivi_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.nome,
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
    FROM documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
   	WHERE tipologie_documenti.se_trasporto IS NOT NULL
	   AND anagrafica_check_gestita( a1.id ) IS NOT NULL
;

--| 090000009720

-- ddt_passivi_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `ddt_passivi_view`;

--| 090000009721

-- ddt_passivi_view
-- tipologia: vista virtuale
-- verifica: 2022-01-28 14:25 chiara gdl
CREATE OR REPLACE VIEW `ddt_passivi_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.nome,
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
    FROM documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
   	WHERE tipologie_documenti.se_trasporto IS NOT NULL
	   AND anagrafica_check_gestita( a2.id ) IS NOT NULL
;

--| 090000009000

-- disponibilita_view
-- tipologia: tabella standard
DROP TABLE IF EXISTS `disponibilita_view`;

--| 090000009001

-- disponibilita_view
-- tipologia: tabella standard
-- verifica: 2022-04-28 16:12 Chiara GDL
CREATE OR REPLACE VIEW disponibilita_view AS
	SELECT
		disponibilita.id,
		disponibilita.nome,
		disponibilita.se_immobili,
		disponibilita.se_catalogo,
		disponibilita.nome AS __label__
	FROM
		disponibilita
;

--| 090000009800

-- documenti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `documenti_view`;

--| 090000009801

-- documenti_view
-- tipologia: tabella gestita
-- verifica: 2022-01-07 14:25 chiara gdl
CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizione_pagamento,
		documenti.esigibilita, 
		documenti.codice_archivium,
    	documenti.codice_sdi,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
    	documenti.timestamp_invio,
    	documenti.progressivo_invio,
		documenti.id_coupon,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.timestamp_chiusura,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.nome,
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
		LEFT JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
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
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
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
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		documenti_articoli.id_mastro_provenienza,
		mastri_path( m1.id ) AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		mastri_path( m2.id ) AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
		documenti_articoli.id_listino,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		concat( 'MAT.',lpad(matricole.id, 15, '0') ) AS matricola,
		matricole.data_scadenza,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
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
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti_articoli.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti_articoli.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti_articoli.id_tipologia
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
		LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

--| 090000012000

-- edifici
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `edifici_view`;

--| 090000012001

-- edifici
-- tipologia: tabella gestita
-- verifica: 2022-04-27 16:56 Chiara GDL
CREATE OR REPLACE VIEW edifici_view AS
	SELECT
		edifici.id,
		edifici.id_tipologia,
		tipologie_edifici.nome AS tipologia,
		edifici.id_indirizzo,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		edifici.codice,
		edifici.nome,
		edifici.piani,
		edifici.id_account_inserimento,
		edifici.id_account_aggiornamento,
		concat_ws(
			' ',
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM edifici
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

--| 090000012800

-- embed_view
-- tipologia: tabella standard
DROP TABLE IF EXISTS `embed_view`;

--| 090000012801

-- embed_view
-- tipologia: tabella standard
-- verifica: 2021-09-10 16:54 Fabio Mosti
CREATE OR REPLACE VIEW `embed_view` AS
	SELECT
		embed.id,
		embed.nome,
		embed.se_audio,
		embed.se_video,
		embed.nome AS __label__
	FROM embed
;

--| 090000013000

-- fatture_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `fatture_view`;

--| 090000013001

-- fatture_view
-- tipologia:  vista virtuale
-- verifica: 2021-09-03 17:25 Fabio Mosti
CREATE OR REPLACE VIEW `fatture_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizione_pagamento,
		documenti.codice_archivium,
    	documenti.codice_sdi,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
    	documenti.timestamp_invio,
    	documenti.progressivo_invio,
		documenti.id_coupon,
		documenti.timestamp_chiusura,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.nome,
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
		LEFT JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento
   WHERE tipologie_documenti.id = 1
;

--| 090000013250

-- fatture_attive_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `fatture_attive_view`;

--| 090000013251

-- fatture_attive_view
-- tipologia:  vista virtuale
-- verifica: 2021-09-03 17:25 Fabio Mosti
CREATE OR REPLACE VIEW `fatture_attive_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		documenti.timestamp_chiusura,
		concat(
			tipologie_documenti.nome,
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
   	WHERE tipologie_documenti.se_fattura IS NOT NULL
	   AND anagrafica_check_gestita( a1.id ) IS NOT NULL
;

--| 090000013500

-- fatture_passive_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `fatture_passive_view`;

--| 090000013501

-- fatture_passive_view
-- tipologia:  vista virtuale
-- verifica: 2021-09-03 17:25 Fabio Mosti
CREATE OR REPLACE VIEW `fatture_passive_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		documenti.timestamp_chiusura,
		concat(
			tipologie_documenti.nome,
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
   	WHERE tipologie_documenti.se_fattura IS NOT NULL
	   AND anagrafica_check_gestita( a2.id ) IS NOT NULL
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
		file.id_template,
		file.id_notizia,
		file.id_categoria_notizie,
		file.id_risorsa,
		file.id_categoria_risorse,
		file.id_mail_out,                    
		file.id_mail_sent, 
		file.id_progetto,
		file.id_categoria_progetti,
		file.id_indirizzo,
		file.id_edificio,
		file.id_immobile,
		file.id_contratto,
		file.id_lingua,
		lingue.iso6393alpha3 AS lingua,
		file.path,
		file.url,
		file.nome,
		file.id_account_inserimento,
		file.id_account_aggiornamento,
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
		LEFT JOIN lingue ON lingue.id = file.id_lingua
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
		gruppi.id_account_inserimento,
		gruppi.id_account_aggiornamento,
		gruppi_path( gruppi.id ) AS __label__
	FROM gruppi
;

--| 090000015400

-- iban_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `iban_view`;

--| 090000015401

-- iban_view
-- tipologia: tabella gestita
-- verifica: 2021-09-22 12:01 Fabio Mosti
CREATE OR REPLACE VIEW `iban_view` AS
	SELECT
		iban.id,
		iban.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		iban.intestazione,
		iban.iban,
		iban.id_account_inserimento,
		iban.id_account_aggiornamento,
		concat(
			iban.iban,
			' ',
			coalesce(
				a1.denominazione,
				concat(
					a1.cognome,
					' ',
					a1.nome
				)
			)
		) AS __label__
	FROM iban
		LEFT JOIN anagrafica AS a1 ON a1.id = iban.id_anagrafica
;

--| 090000015600

-- immagini_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `immagini_view`;

--| 090000015601

-- immagini_view
-- tipologia: tabella gestita
-- verifica: 2021-09-22 12:45 Fabio Mosti
CREATE OR REPLACE VIEW `immagini_view` AS
	SELECT
		immagini.id,
		immagini.id_anagrafica,
		immagini.id_pagina,
		immagini.id_file,
		immagini.id_prodotto,
		immagini.id_articolo,
		immagini.id_categoria_prodotti,
		immagini.id_risorsa,
		immagini.id_categoria_risorse,
		immagini.id_notizia,
		immagini.id_categoria_notizie,
		immagini.id_progetto,
		immagini.id_categoria_progetti,
		immagini.id_indirizzo,
		immagini.id_edificio,
		immagini.id_immobile,
		immagini.id_contratto,
		immagini.id_lingua,
		lingue.nome AS lingua,
		immagini.id_ruolo,
		ruoli_immagini.nome AS ruolo,
		immagini.ordine,
		immagini.orientamento,
		immagini.taglio,
		immagini.nome,
		immagini.path,
		immagini.path_alternativo,
		immagini.token,
		immagini.timestamp_scalamento,
		immagini.id_account_inserimento,
		immagini.id_account_aggiornamento,
		concat(
			ruoli_immagini.nome,
			' # ',
			immagini.ordine,
			' / ',
			immagini.nome,
			' / ',
			immagini.path
		) AS __label__
	FROM immagini
		LEFT JOIN lingue ON lingue.id = immagini.id_lingua
		LEFT JOIN ruoli_immagini ON ruoli_immagini.id = immagini.id_ruolo
;

--| 090000015700

-- immobili_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `immobili_view`;

--| 090000015701

-- immobili_view
-- tipologia: tabella gestita
-- verifica: 2022-04-27 12:20 Chiara GDL
CREATE OR REPLACE VIEW immobili_view AS
	SELECT
		immobili.id,
		immobili.id_tipologia,
		tipologie_immobili.nome AS tipologia,
		immobili.id_edificio,
		immobili.nome,
		immobili.codice,
		edifici.id_indirizzo,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		immobili.scala,
		immobili.piano,
		immobili.interno,
immobili.campanello,
		immobili.id_account_inserimento,
		immobili.id_account_aggiornamento,
		concat_ws(
			' ',
    tipologie_immobili.nome, 
    coalesce(
      concat('scala ', immobili.scala), 
      ''
    ), 
    coalesce(
      concat('piano ', immobili.piano), 
      ''
    ), 
    coalesce(
      concat('int. ', immobili.interno), 
      ''
    ),
			tipologie_edifici.nome,
			edifici.nome,
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM immobili
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

--| 090000015710

-- immobili_anagrafica_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS immobili_anagrafica_view;

--| 090000015711

-- immobili_anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2022-04-28 12:20 Chiara GDL
CREATE OR REPLACE VIEW  immobili_anagrafica_view AS 
	SELECT 
		immobili_anagrafica.id,
		immobili_anagrafica.id_immobile,
		immobili_anagrafica.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		immobili_anagrafica.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		immobili_anagrafica.ordine,
		immobili_anagrafica.id_account_inserimento ,
		immobili_anagrafica.id_account_aggiornamento ,
		concat( 'immobile ', immobili_anagrafica.id_immobile, ' - ', coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ), ' ruolo ', ruoli_anagrafica.nome  ) AS __label__
	FROM immobili_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = immobili_anagrafica.id_ruolo
		LEFT JOIN anagrafica ON anagrafica.id = immobili_anagrafica.id_anagrafica;

--| 090000015800

-- indirizzi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS indirizzi_view;

--| 090000015801

-- indirizzi_view
-- tipologia: tabella gestita
-- verifica: 2021-09-23 16:08 Fabio Mosti
CREATE OR REPLACE VIEW indirizzi_view AS
	SELECT
		indirizzi.id,
		indirizzi.id_tipologia,
		tipologie_indirizzi.nome AS tipologia,
		indirizzi.id_comune,
		comuni.nome AS comune,
		comuni.id_provincia,
		provincie.nome AS provincia,
		provincie.id_regione,
		regioni.nome AS regione,
		regioni.id_stato,
		stati.nome AS stato,
		indirizzi.localita,
		indirizzi.indirizzo,
		indirizzi.civico,
		indirizzi.cap,
		indirizzi.latitudine,
		indirizzi.longitudine,
		indirizzi.token,
		indirizzi.timestamp_geolocalizzazione,
		indirizzi.id_account_inserimento,
		indirizzi.id_account_aggiornamento,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM indirizzi
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

--| 090000015900

-- iscrizioni_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `iscrizioni_view`;

--| 090000015901

-- iscrizioni_view
-- tipologia: vista virtuale
CREATE OR REPLACE VIEW `iscrizioni_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
    WHERE tipologie_contratti.se_iscrizione = 1
;


--| 090000015910

-- iscrizioni_attivi_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `iscrizioni_attivi_view`;

--| 090000015911

-- iscrizioni_attivi_view
-- tipologia: vista virtuale
CREATE OR REPLACE VIEW `iscrizioni_attivi_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_iscrizione = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
    GROUP BY contratti.id
;

--| 090000015920

-- iscrizioni_archiviati_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `iscrizioni_archiviati_view`;

--| 090000015921

-- iscrizioni_archiviati_view
-- tipologia: vista virtuale
CREATE OR REPLACE VIEW `iscrizioni_archiviati_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_iscrizione = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio >= CURRENT_DATE() ) AND  rinnovi.data_fine < CURRENT_DATE() 
    GROUP BY contratti.id
;

--| 090000016000

-- iva_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `iva_view`;

--| 090000016001

-- iva_view
-- tipologia: tabella di supporto
-- verifica: 2021-09-23 16:56 Fabio Mosti
CREATE OR REPLACE VIEW iva_view AS
	SELECT
		iva.id,
		iva.aliquota,
		iva.nome,
		iva.codice,
		iva.timestamp_archiviazione,
		iva.nome AS __label__
	FROM
		iva
;

--| 090000016200

-- job_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `job_view`;

--| 090000016201

-- job_view
-- tipologia: tabella gestita
-- verifica: 2021-09-24 17:19 Fabio Mosti
CREATE OR REPLACE VIEW job_view AS
	SELECT
		job.id,
		job.nome,
		job.job,
		job.totale,
		job.corrente,
		job.iterazioni,
		job.delay,
		job.token,
		job.se_foreground,
		job.timestamp_apertura,
		from_unixtime( job.timestamp_apertura, '%Y-%m-%d %H:%i' ) AS data_ora_apertura,
		job.timestamp_esecuzione,
		from_unixtime( job.timestamp_esecuzione, '%Y-%m-%d %H:%i' ) AS data_ora_esecuzione,
		job.timestamp_completamento,
		from_unixtime( job.timestamp_completamento, '%Y-%m-%d %H:%i' ) AS data_ora_completamento,
		job.id_account_inserimento,
		job.id_account_aggiornamento,
		job.nome AS __label__
	FROM job
;

--| 090000016600

-- licenze_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `licenze_view`;

--| 090000016601

-- licenze_view
-- tipologia: tabella gestita
-- verifica: 2021-11-15 12:44 Chiara GDL
CREATE OR REPLACE VIEW licenze_view AS
	SELECT
		licenze.id,                         
    	licenze.id_tipologia,                
		tipologie_licenze.nome AS tipologia,               
		licenze.id_anagrafica,               
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,               
		licenze.id_rivenditore,              
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS rivenditore,                 
		licenze.codice,                      
		licenze.postazioni,                  
		licenze.nome,                        
		licenze.note,                        
		licenze.testo,                       
		licenze.giorni_validita,             
		licenze.giorni_rinnovo,              
		licenze.timestamp_distribuzione,     
		licenze.timestamp_inizio,            
		licenze.timestamp_fine,              
		licenze.id_account_inserimento,      
		licenze.id_account_aggiornamento,    
		licenze.nome AS __label__
	FROM licenze
		LEFT JOIN tipologie_licenze ON tipologie_licenze.id = licenze.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = licenze.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = licenze.id_rivenditore
;

--| 090000016700

-- licenze_software
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `licenze_software_view`;

--| 090000016701

-- licenze_software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 15:30 Chiara GDL
CREATE OR REPLACE VIEW licenze_software_view AS
	SELECT
		licenze_software.id,
		licenze_software.id_licenza,
		licenze_software.id_software,
		licenze_software.id_account_inserimento,
		licenze_software.id_account_aggiornamento,
		concat( licenze.nome, ' | ', software.nome ) AS __label__
	FROM licenze_software
		LEFT JOIN software ON software.id = licenze_software.id_software
		LEFT JOIN licenze ON licenze.id = licenze_software.id_licenza
;

--| 090000016800

-- lingue_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `lingue_view`;

--| 090000016801

-- lingue_view
-- tipologia: tabella di supporto
-- verifica: 2021-09-24 17:45 Fabio Mosti
CREATE OR REPLACE VIEW lingue_view AS
	SELECT
		lingue.id,
		lingue.nome,
		lingue.iso6391alpha2,
		lingue.iso6393alpha3,
		lingue.ietf,
		lingue.nome AS __label__
	FROM lingue
;

--| 090000017001

-- liste_view
-- tipolgia: tabella gestita
DROP TABLE IF EXISTS `liste_view`;

--| 090000017001

-- liste_view
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE OR REPLACE VIEW `liste_view` AS
	SELECT
	liste.id,
	liste.nome,
	liste.nome AS __label__
	FROM liste
;

--| 090000017100

-- liste_mail_view
-- tipolgia: tabella gestita
DROP TABLE IF EXISTS `liste_mail_view`;

--| 090000017101

-- liste_mail_view
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE OR REPLACE VIEW `liste_mail_view` AS
	SELECT
	liste_mail.id,
	liste_mail.id_lista,
	liste.nome AS lista,
	liste_mail.id_mail,
	mail.indirizzo AS mail,
	mail.id_anagrafica,
	coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
	a1.nome AS anagrafica_nome,
	a1.cognome AS anagrafica_cognome,
	a1.denominazione AS anagrafica_denominazione,
	a1.codice_fiscale AS anagrafica_codice_fiscale,
	a1.codice AS anagrafica_codice,
	concat( liste_mail.id_lista, liste_mail.id_mail ) AS __label__
	FROM liste_mail
	INNER JOIN liste ON liste.id = liste_mail.id_lista
	INNER JOIN mail ON mail.id = liste_mail.id_mail
	INNER JOIN anagrafica AS a1 ON a1.id = mail.id_anagrafica
;

--| 090000017200

-- listini_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `listini_view`;

--| 090000017201

-- listini_view
-- tipologia: tabella assistita
-- verifica: 2021-09-24 17:59 Fabio Mosti
CREATE OR REPLACE VIEW `listini_view` AS
	SELECT
		listini.id,
		listini.id_valuta,
		valute.iso4217 AS valuta,
		listini.nome,
		listini.id_account_inserimento,
		listini.id_account_aggiornamento,
		concat(
			listini.nome,
			' ',
			valute.iso4217
		) AS __label__
	FROM listini
		LEFT JOIN valute ON valute.id = listini.id_valuta
;

--| 090000017400

-- listini_clienti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `listini_clienti_view`;

--| 090000017401

-- listini_clienti_view
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:20 Fabio Mosti
CREATE OR REPLACE VIEW `listini_clienti_view` AS
	SELECT
		listini_clienti.id,
		listini_clienti.id_listino,
		concat( listini.nome, ' ', valute.iso4217 ) AS listino,
		listini_clienti.id_cliente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		listini_clienti.ordine,
		listini_clienti.id_account_inserimento,
		listini_clienti.id_account_aggiornamento,
		concat(
			listini.nome,
			' ',
			valute.iso4217,
			' / ',
			coalesce(
				a1.denominazione,
				concat(
					a1.cognome,
					' ',
					a1.nome
				), ''
			)
		) AS __label__
	FROM listini_clienti
		LEFT JOIN listini ON listini.id = listini_clienti.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN anagrafica AS a1 ON a1.id = listini_clienti.id_cliente
;

--| 090000018000

-- luoghi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `luoghi_view`;

--| 090000018001

-- luoghi_view
-- tipologia: tabella gestita
-- verifica: 2021-09-24 18:49 Fabio Mosti
CREATE OR REPLACE VIEW `luoghi_view` AS
	SELECT
		luoghi.id,
		luoghi.id_genitore,
		luoghi.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		luoghi.nome,
		luoghi.id_account_inserimento,
		luoghi.id_account_aggiornamento,
		luoghi_path( luoghi.id ) AS __label__
	FROM luoghi
		LEFT JOIN indirizzi ON indirizzi.id = luoghi.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

--| 090000018200

-- macro_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `macro_view`;

--| 090000018201

-- macro_view
-- tipologia: tabella gestita
-- verifica: 2021-09-24 19:40 Fabio Mosti
CREATE OR REPLACE VIEW `macro_view` AS
	SELECT
		macro.id,
		macro.id_pagina,
		macro.id_prodotto,
		macro.id_articolo,
		macro.id_categoria_prodotti,
		macro.id_notizia,
		macro.id_categoria_notizie,
		macro.id_risorsa,
		macro.id_categoria_risorse,
		macro.id_progetto,
		macro.id_categoria_progetti,
		macro.ordine,
		macro.macro,
		macro.macro AS __label__
	FROM macro
;

--| 090000018400
-- magazzini_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `magazzini_view`;

--| 090000018401
-- magazzini_view
-- tipologia: vista virtuale
-- verifica: 2022-01-28 14:51 Chiara GDL
CREATE OR REPLACE VIEW `magazzini_view` AS
	SELECT
		mastri.id,
		mastri.id_tipologia,
		tipologie_mastri.nome AS tipologia,
		mastri.id_anagrafica_indirizzi,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		anagrafica_indirizzi.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		mastri.nome,
		tipologie_mastri.se_magazzino,
		tipologie_mastri.se_conto,
		tipologie_mastri.se_registro,
		mastri_path( mastri.id ) AS __label__
	FROM mastri
		LEFT JOIN tipologie_mastri ON tipologie_mastri.id = mastri.id_tipologia
		LEFT JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id = mastri.id_anagrafica_indirizzi
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_indirizzi.id_anagrafica
		LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
	WHERE tipologie_mastri.se_magazzino = 1
;

--| 090000018600

-- mail_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `mail_view`;

--| 090000018601

-- mail_view
-- tipologia: tabella gestita
-- verifica: 2021-09-28 14:51 Fabio Mosti
CREATE OR REPLACE VIEW `mail_view` AS
	SELECT
		mail.id,
		mail.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		mail.indirizzo,
		mail.se_notifiche,
		mail.se_pec,
		mail.id_account_inserimento,
		mail.id_account_aggiornamento,
		concat(
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ),
			' ',
			mail.indirizzo
		) AS __label__
	FROM mail
		LEFT JOIN anagrafica AS a1 ON a1.id = mail.id_anagrafica
;

--| 090000018800

-- mail_out_view
-- tipolgia: tabella gestita
DROP TABLE IF EXISTS `mail_out_view`;

--| 090000018801

-- mail_out_view
-- tipolgia: tabella gestita
-- verifica: 2021-09-28 15:35 Fabio Mosti
CREATE OR REPLACE VIEW `mail_out_view` AS
	SELECT
		mail_out.id,
		mail_out.id_mail,
		mail_out.id_mailing,
		mail_out.ordine,
		mail_out.timestamp_composizione,
		mail_out.mittente,
		mail_out.destinatari,
		mail_out.destinatari_cc,
		mail_out.destinatari_bcc,
		mail_out.oggetto,
		mail_out.allegati,
		mail_out.headers,
		mail_out.server,
		mail_out.host,
		mail_out.port,
		mail_out.user,
		mail_out.password,
		mail_out.token,
		mail_out.tentativi,
		mail_out.timestamp_invio,
		from_unixtime( mail_out.timestamp_invio, '%Y-%m-%d' ) AS data_ora_invio,
		mail_out.id_account_inserimento,
		mail_out.id_account_aggiornamento,
		concat(
			mail_out.destinatari,
			' / ',
			mail_out.oggetto
		) AS __label__
	FROM mail_out
;

--| 090000018900

-- mail_sent_view
-- tipolgia: tabella gestita
DROP TABLE IF EXISTS `mail_sent_view`;

--| 090000018901

-- mail_sent_view
-- tipolgia: tabella gestita
-- verifica: 2021-09-28 15:35 Fabio Mosti
CREATE OR REPLACE VIEW `mail_sent_view` AS
	SELECT
		mail_sent.id,
		mail_sent.id_mail,
		mail_sent.id_mailing,
		mail_sent.ordine,
		mail_sent.timestamp_composizione,
		mail_sent.mittente,
		mail_sent.destinatari,
		mail_sent.destinatari_cc,
		mail_sent.destinatari_bcc,
		mail_sent.oggetto,
		mail_sent.allegati,
		mail_sent.headers,
		mail_sent.server,
		mail_sent.host,
		mail_sent.port,
		mail_sent.user,
		mail_sent.password,
		mail_sent.token,
		mail_sent.tentativi,
		mail_sent.timestamp_invio,
		from_unixtime( mail_sent.timestamp_invio, '%Y-%m-%d' ) AS data_ora_invio,
		mail_sent.id_account_inserimento,
		mail_sent.id_account_aggiornamento,
		concat(
			mail_sent.destinatari,
			' / ',
			mail_sent.oggetto
		) AS __label__
	FROM mail_sent
;

--| 090000019000

-- mailing
-- tipolgia: tabella gestita
DROP TABLE IF EXISTS `mailing_view`;

--| 090000019001

-- mailing
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE OR REPLACE VIEW `mailing_view` AS
	SELECT
	mailing.id,
	mailing.nome,
	mailing.timestamp_invio,
	mailing.id_account_inserimento,
	mailing.id_account_aggiornamento,
	mailing.nome AS __label__
	FROM mailing
;

--| 090000019050

-- mailing_liste_view
-- tipolgia: tabella gestita
DROP TABLE IF EXISTS `mailing_liste_view`;

--| 090000019051

-- mailing_liste_view
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE OR REPLACE VIEW `mailing_liste_view` AS
	SELECT
	mailing_liste.id,
	mailing_liste.id_lista,
	mailing_liste.id_mailing,
	concat( mailing_liste.id_lista, mailing_liste.id_mailing ) AS __label__
	FROM mailing_liste
;

--| 090000019100

-- mailing_mail_view
-- tipolgia: tabella gestita
DROP TABLE IF EXISTS `mmailing_mail_view`;

--| 090000019101

-- mailing_mail_view
-- tipolgia: tabella gestita
-- verifica: 2022-02-07 15:47 Chiara GDL
CREATE OR REPLACE VIEW `mailing_mail_view` AS
	SELECT
		mailing_mail.id,
		mailing_mail.id_mailing,
		mailing.nome AS mailing,
		mailing_mail.id_mail,
		mail.indirizzo AS mail,
		mail.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		mailing_mail.id_mail_out,
		mailing_mail.timestamp_generazione,
		from_unixtime( mailing_mail.timestamp_generazione, '%Y-%m-%d' ) AS data_ora_generazione,
		mailing_mail.timestamp_invio,
		from_unixtime( mailing_mail.timestamp_invio, '%Y-%m-%d' ) AS data_ora_invio,
		concat(mailing_mail.id_mailing  , " | ", mailing_mail.id_mail , " | ", mailing_mail.id_mail_out) AS __label__
	FROM mailing_mail
		INNER JOIN mailing ON mailing.id = mailing_mail.id_mailing
		INNER JOIN mail ON mail.id = mailing_mail.id_mail
		INNER JOIN anagrafica AS a1 ON a1.id = mail.id_anagrafica
;

--| 090000020200

-- marchi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `marchi_view`;

--| 090000020201

-- marchi_view
-- tipologia: tabella gestita
-- verifica: 2021-09-28 16:57 Fabio Mosti
CREATE OR REPLACE VIEW `marchi_view` AS
	SELECT
		marchi.id,
		marchi.nome,
		marchi.nome AS __label__
	FROM marchi
;

--| 090000020600

-- mastri_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `mastri_view`;

--| 090000020601

-- mastri_view
-- tipologia: tabella gestita
-- verifica: 2021-09-29 11:43 Fabio Mosti
CREATE OR REPLACE VIEW `mastri_view` AS
	SELECT
		mastri.id,
		mastri.id_tipologia,
		tipologie_mastri.nome AS tipologia,
		mastri.id_anagrafica_indirizzi,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		anagrafica_indirizzi.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		mastri.nome,
		tipologie_mastri.se_magazzino,
		tipologie_mastri.se_conto,
		tipologie_mastri.se_registro,
		mastri_path( mastri.id ) AS __label__
	FROM mastri
		LEFT JOIN tipologie_mastri ON tipologie_mastri.id = mastri.id_tipologia
		LEFT JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id = mastri.id_anagrafica_indirizzi
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_indirizzi.id_anagrafica
		LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

--| 090000021000

-- matricole
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `matricole_view`;

--| 090000021001

-- matricole_view
-- tipologia: tabella gestita
-- verifica: 2021-12-28 16:20 Chiara GDL
CREATE OR REPLACE VIEW `matricole_view` AS
	SELECT
		matricole.id,
		matricole.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		matricole.id_marchio,
		marchi.nome AS marchio,
		matricole.id_articolo,
		concat_ws( ' ', articoli.id, prodotti.nome, articoli.nome ) AS articolo,
		matricole.matricola,
		matricole.data_scadenza,
		matricole.nome,
		concat_ws( ' ', matricole.matricola, '/', articoli.id, '/', prodotti.nome, articoli.nome, concat( 'scad. ', matricole.data_scadenza ) ) AS __label__
	FROM matricole
		LEFT JOIN anagrafica AS a1 ON a1.id = matricole.id_produttore
		LEFT JOIN marchi ON marchi.id = matricole.id_marchio
		LEFT JOIN articoli ON articoli.id = id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

--| 090000021600

-- menu_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `menu_view`;

--| 090000021601

-- menu_view
-- tipologia: tabella gestita
-- verifica: 2021-10-01 10:01 Fabio Mosti
CREATE OR REPLACE VIEW `menu_view` AS
    SELECT
		menu.id,
		menu.id_lingua,
		menu.id_pagina,
		menu.id_categoria_prodotti,
		menu.id_categoria_notizie,
		menu.id_categoria_risorse,
		menu.ordine,
		menu.menu,
		menu.nome,
		menu.target,
		menu.ancora,
		menu.sottopagine,
		menu.id_account_inserimento,
		menu.id_account_aggiornamento,
		concat_ws(
			' / ',
			menu.menu,
			menu.ordine,
			lingue.ietf,
			menu.nome
		) AS __label__
    FROM menu
		INNER JOIN lingue ON lingue.id = menu.id_lingua
;

--| 090000021800

-- metadati_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `metadati_view`;

--| 090000021801

-- metadati_view
-- tipologia: tabella gestita
-- verifica: 2021-10-01 10:49 Fabio Mosti
CREATE OR REPLACE VIEW `metadati_view` AS
	SELECT
		metadati.id,
		metadati.id_lingua,
		lingue.ietf,
		metadati.id_anagrafica,
		metadati.id_pagina,
		metadati.id_prodotto,
		metadati.id_articolo,
		metadati.id_categoria_prodotti,
		metadati.id_notizia,
		metadati.id_categoria_notizie,
		metadati.id_risorsa,
		metadati.id_categoria_risorse,
		metadati.id_immagine,
		metadati.id_video,
		metadati.id_audio,
		metadati.id_file,
		metadati.id_progetto,
		metadati.id_categoria_progetti,
		metadati.id_indirizzo,
		metadati.id_edificio,
		metadati.id_immobile,
		metadati.id_account_inserimento,
		metadati.id_account_aggiornamento,
		concat(
			metadati.nome,
			':',
			metadati.testo
		) AS __label__
	FROM metadati
		LEFT JOIN lingue ON lingue.id = metadati.id_lingua
;

--| 090000021900

-- modalita_pagamento
-- tipologia: tabella standard
DROP TABLE IF EXISTS `modalita_pagamento_view`;

--| 090000021901

-- modalita_pagamento
-- tipologia: tabella standard
-- verifica: 2022-01-18 12:06 Chiara GDL
CREATE OR REPLACE VIEW `modalita_pagamento_view` AS
	SELECT
	modalita_pagamento.id,
	modalita_pagamento.nome,
	modalita_pagamento.codice,
	modalita_pagamento.provider,
	concat( modalita_pagamento.codice,' - ', modalita_pagamento.nome) AS __label__
	FROM modalita_pagamento
	ORDER BY __label__
;

--| 090000021970

-- note_credito_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `note_credito_view`;

--| 090000021971

-- note_credito_view
-- tipologia: vista virtuale
-- verifica: 2021-09-03 17:25 Fabio Mosti
CREATE OR REPLACE VIEW `note_credito_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizione_pagamento,
		documenti.codice_archivium,
    	documenti.codice_sdi,
    	documenti.timestamp_invio,
    	documenti.progressivo_invio,
		documenti.id_coupon,
		documenti.timestamp_chiusura,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.nome,
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
		LEFT JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento
   WHERE tipologie_documenti.id = 3
;

--| 090000022000

-- notizie_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `notizie_view`;

--| 090000022001

-- notizie_view
-- tipologia: tabella gestita
-- verifica: 2021-10-01 10:49 Fabio Mosti
CREATE OR REPLACE VIEW `notizie_view` AS
	SELECT
		notizie.id,
		notizie.id_tipologia,
		tipologie_notizie.nome AS tipologia,
		notizie.nome,
		group_concat( categorie_notizie.nome SEPARATOR '|' ) AS categorie,
		notizie.id_account_inserimento,
		notizie.id_account_aggiornamento,
		notizie.nome AS __label__
	FROM notizie
		LEFT JOIN tipologie_notizie ON tipologie_notizie.id = notizie.id_tipologia
		LEFT JOIN notizie_categorie ON notizie_categorie.id_notizia = notizie.id
		LEFT JOIN categorie_notizie ON categorie_notizie.id = notizie_categorie.id_categoria
	GROUP BY notizie.id
;

--| 090000022200

-- notizie_categorie_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `notizie_categorie_view`;

--| 090000022201

-- notizie_categorie_view
-- tipologia: tabella gestita
-- verifica: 2021-10-01 12:39 Fabio Mosti
CREATE OR REPLACE VIEW `notizie_categorie_view` AS
	SELECT
		notizie_categorie.id,
		notizie_categorie.id_notizia,
		notizie.nome AS notizia,
		notizie_categorie.id_categoria,
		categorie_notizie_path( notizie_categorie.id_categoria ) AS categoria,
		notizie_categorie.ordine,
		notizie_categorie.id_account_inserimento,
		notizie_categorie.id_account_aggiornamento,
		concat(
			notizie.nome,
			' / ',
			categorie_notizie_path( notizie_categorie.id_categoria )
		) AS __label__
	FROM notizie_categorie
		LEFT JOIN notizie ON notizie.id = notizie_categorie.id_notizia
;

--| 090000022800

-- organizzazioni_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `organizzazioni_view`;

--| 090000022801

-- organizzazioni_view
-- tipologia: tabella gestita
-- verifica: 2021-10-01 13:10 Fabio Mosti
CREATE OR REPLACE VIEW `organizzazioni_view` AS
	SELECT
		organizzazioni.id,
		organizzazioni.id_genitore,
		organizzazioni.ordine,
		organizzazioni.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		organizzazioni.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		organizzazioni.id_account_inserimento,
		organizzazioni.id_account_aggiornamento,
		concat_ws(
			' ',
			organizzazioni_path( organizzazioni.id ),
			ruoli_anagrafica.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM organizzazioni
		LEFT JOIN anagrafica AS a1 ON a1.id = organizzazioni.id_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = organizzazioni.id_ruolo
;

--| 090000023100

-- pagamenti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `pagamenti_view`;

--| 090000023101

-- pagamenti_view
-- tipologia: tabella gestita
-- verifica: 2022-01-07 16:00 Chiara GDL
CREATE OR REPLACE VIEW `pagamenti_view` AS
	SELECT
		pagamenti.id,
		pagamenti.id_tipologia,
		pagamenti.id_modalita_pagamento,
		concat(modalita_pagamento.codice, ' - ' ,modalita_pagamento.nome) AS modalita_pagamento,
		tipologie_pagamenti.nome AS tipologia,
		pagamenti.ordine,
		pagamenti.nome,
		pagamenti.note,
		pagamenti.note_pagamento,
		pagamenti.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		pagamenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		pagamenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		pagamenti.id_iban,
		iban.iban AS iban,
		pagamenti.importo_netto_totale,
		pagamenti.id_iva,
		iva.nome AS iva,
		pagamenti.id_listino,
		listini.nome AS listino,
		pagamenti.timestamp_scadenza,
		from_unixtime( pagamenti.timestamp_scadenza, '%Y-%m-%d' ) AS data_ora_scadenza,
		pagamenti.timestamp_pagamento,
		from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) AS data_ora_pagamento,
		pagamenti.id_account_inserimento,
		pagamenti.id_account_aggiornamento,
		pagamenti.nome AS __label__
	FROM pagamenti
		LEFT JOIN tipologie_pagamenti ON tipologie_pagamenti.id = pagamenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = pagamenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = pagamenti.id_mastro_destinazione
		LEFT JOIN iva ON iva.id = pagamenti.id_iva
		LEFT JOIN listini ON listini.id = pagamenti.id_listino
		LEFT JOIN modalita_pagamento ON modalita_pagamento.id = pagamenti.id_modalita_pagamento
		LEFT JOIN documenti ON documenti.id = pagamenti.id_documento
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN iban ON iban.id = pagamenti.id_iban
	WHERE
		tipologie_documenti.se_fattura = 1
		OR
		tipologie_documenti.se_nota_credito = 1
		OR
		tipologie_documenti.se_ricevuta = 1
		OR
		tipologie_documenti.se_pro_forma = 1
;

--| 090000023200

-- pagine_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `pagine_view`;

--| 090000023201

-- pagine_view
-- tipologia: tabella gestita
-- verifica: 2021-10-04 11:43 Fabio Mosti
CREATE OR REPLACE VIEW `pagine_view` AS
	SELECT
		pagine.id,
		pagine.id_genitore,
		pagine.id_sito,
		pagine.nome,
		pagine.template,
		pagine.schema_html,
		pagine.tema_css,
		pagine.id_contenuti,
		pagine.se_sitemap,
		pagine.se_cacheable,
		pagine.id_account_inserimento,
		pagine.id_account_aggiornamento,
		pagine_path( pagine.id ) AS __label__
	FROM pagine
;

--| 090000023600

-- periodicita_view
-- tipologia: tabella standard
DROP TABLE IF EXISTS `periodicita_view`;

--| 090000023601

-- periodicita_view
-- tipologia: tabella standard
-- verifica: 2021-10-05 18:00 Fabio Mosti
CREATE OR REPLACE VIEW `popup_view` AS
	SELECT
		periodicita.id,
		periodicita.nome,
		periodicita.nome AS __label__
	FROM periodicita
;

--| 090000023800

-- pianificazioni_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `pianificazioni_view`;

--| 090000023801

-- pianificazioni_view
-- tipologia: tabella gestita
CREATE OR REPLACE VIEW `pianificazioni_view` AS
	SELECT
		pianificazioni.id,
		pianificazioni.id_progetto,
		pianificazioni.id_todo,
		pianificazioni.id_attivita,
		pianificazioni.nome,
		pianificazioni.id_periodicita,
		periodicita.nome AS periodicita,
		pianificazioni.cadenza,
		pianificazioni.se_lunedi,
		pianificazioni.se_martedi,
		pianificazioni.se_mercoledi,
		pianificazioni.se_giovedi,
		pianificazioni.se_venerdi,
		pianificazioni.se_sabato,
		pianificazioni.se_domenica,
		pianificazioni.schema_ripetizione,
		pianificazioni.data_elaborazione,
		pianificazioni.giorni_estensione,
		pianificazioni.data_fine,
		pianificazioni.entita,
		pianificazioni.model_id_luogo,
		pianificazioni.model_ora_inizio_programmazione,
		pianificazioni.model_ora_fine_programmazione,
		pianificazioni.workspace,
		pianificazioni.token,
		pianificazioni.id_account_inserimento,
		pianificazioni.id_account_aggiornamento,
		concat_ws(
			' ',
			pianificazioni.nome,
			periodicita.nome,
			pianificazioni.cadenza
		) as __label__
	FROM pianificazioni
		LEFT JOIN periodicita ON periodicita.id = pianificazioni.id_periodicita
;

--| 090000024000

-- popup_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `popup_view`;

--| 090000024001

-- popup_view
-- tipologia: tabella gestita
-- verifica: 2021-10-04 17:02 Fabio Mosti
CREATE OR REPLACE VIEW `popup_view` AS
	SELECT
		popup.id,
		popup.id_tipologia,
		tipologie_popup.nome AS tipologia,
		popup.id_sito,
		popup.nome,
		popup.html_id,
		popup.html_class,
		popup.html_class_attivazione,
		popup.n_scroll,
		popup.n_secondi,
		popup.template,
		popup.schema_html,
		popup.se_ovunque,
		popup.id_account_inserimento,
		popup.id_account_aggiornamento,
		popup.nome AS __label__
	FROM popup
		LEFT JOIN tipologie_popup ON tipologie_popup.id = popup.id_tipologia
;

--| 090000024200

-- popup_pagine_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `popup_pagine_view`;

--| 090000024201

-- popup_pagine_view
-- tipologia: tabella gestita
-- verifica: 2021-10-04 17:02 Fabio Mosti
CREATE OR REPLACE VIEW `popup_pagine_view` AS
	SELECT
		popup_pagine.id,
		popup_pagine.id_popup,
		popup_pagine.id_pagina,
		popup_pagine.se_presente,
		popup_pagine.id_account_inserimento,
		popup_pagine.id_account_aggiornamento,
		concat(
			popup.nome,
			' / ',
			pagine_path( popup_pagine.id_pagina ),
			' / ',
			coalesce( popup_pagine.se_presente, 0 )
		) AS __label__
	FROM popup_pagine
		LEFT JOIN popup ON popup.id = popup_pagine.id_popup
;

--| 090000025000

-- prezzi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `prezzi_view`;

--| 090000025001

-- prezzi_view
-- tipologia: tabella gestita
-- verifica: 2021-10-04 17:02 Fabio Mosti
CREATE OR REPLACE VIEW `prezzi_view` AS
	SELECT
		prezzi.id,
		prezzi.id_prodotto,
		prezzi.id_articolo,
		prezzi.prezzo,
		prezzi.id_listino,
		listini.nome AS listino,
		valute.iso4217 AS valuta,
		prezzi.id_iva,
		iva.descrizione AS iva,
		prezzi.id_account_inserimento,
		prezzi.id_account_aggiornamento,
		concat_ws(
			' ',
			prezzi.id_prodotto,
			prezzi.id_articolo,
			prezzi.prezzo,
			listini.nome,
			valute.iso4217,
			iva.descrizione
		) AS __label__
	FROM prezzi
		LEFT JOIN listini ON listini.id = prezzi.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN iva ON iva.id = prezzi.id_iva
;

--| 090000026000

-- prodotti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `prodotti_view`;

--| 090000026001

-- prodotti_view
-- tipologia: tabella gestita
-- verifica: 2021-10-04 18:56 Fabio Mosti
CREATE OR REPLACE VIEW `prodotti_view` AS
	SELECT
		prodotti.id,
		prodotti.id_tipologia,
		tipologie_prodotti.nome AS tipologia,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		prodotti.nome,
		prodotti.id_marchio,
		marchi.nome AS marchio,
		prodotti.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		prodotti.codice_produttore,
		group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		prodotti.id_sito,
		prodotti.template,
		prodotti.schema_html,
		prodotti.tema_css,
		prodotti.se_sitemap,
		prodotti.se_cacheable,
		prodotti.id_account_inserimento,
		prodotti.id_account_aggiornamento,
		concat_ws(
			' ',
			prodotti.id,
			prodotti.nome
		) AS __label__
	FROM prodotti
		LEFT JOIN tipologie_prodotti ON tipologie_prodotti.id = prodotti.id_tipologia
		LEFT JOIN marchi ON marchi.id = prodotti.id_marchio
		LEFT JOIN anagrafica AS a1 ON a1.id = prodotti.id_produttore
		LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id
	GROUP BY prodotti.id
;

--| 090000026200

-- prodotti_caratteristiche_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `prodotti_caratteristiche_view`;

--| 090000026201

-- prodotti_caratteristiche_view
-- tipologia: tabella gestita
-- verifica: 2021-10-04 19:40 Fabio Mosti
CREATE OR REPLACE VIEW `prodotti_caratteristiche_view` AS
	SELECT
		prodotti_caratteristiche.id,
		prodotti_caratteristiche.id_prodotto,
		prodotti_caratteristiche.id_caratteristica,
		caratteristiche_prodotti.nome AS caratteristica,
		prodotti_caratteristiche.ordine,
		prodotti_caratteristiche.id_account_inserimento,
		prodotti_caratteristiche.id_account_aggiornamento,
		concat(
			prodotti_caratteristiche.id_prodotto,
			' / ',
			caratteristiche_prodotti.nome
		) AS __label__
	FROM prodotti_caratteristiche
		LEFT JOIN caratteristiche_prodotti ON caratteristiche_prodotti.id = prodotti_caratteristiche.id_caratteristica
;

--| 090000026400

-- prodotti_categorie_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `prodotti_categorie_view`;

--| 090000026401

-- prodotti_categorie_view
-- tipologia: tabella gestita
-- verifica: 2021-10-04 19:45 Fabio Mosti
CREATE OR REPLACE VIEW `prodotti_categorie_view` AS
	SELECT
		prodotti_categorie.id,
		prodotti_categorie.id_prodotto,
		prodotti_categorie.id_categoria,
		categorie_prodotti_path( prodotti_categorie.id_categoria ) AS categoria,
		prodotti_categorie.id_ruolo,
		ruoli_prodotti.nome AS ruolo,
		prodotti_categorie.ordine,
		prodotti_categorie.id_account_inserimento,
		prodotti_categorie.id_account_aggiornamento,
		concat_ws(
			' ',
			prodotti_categorie.id_prodotto,
			ruoli_prodotti.nome,
			categorie_prodotti_path( prodotti_categorie.id_categoria )
		) AS __label__
	FROM prodotti_categorie
		LEFT JOIN ruoli_prodotti ON ruoli_prodotti.id = prodotti_categorie.id_ruolo
;

--| 090000026600

-- proforma_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `proforma_view`;

--| 090000026601

-- proforma_view
-- tipologia: tabella gestita
-- verifica: 2021-09-03 17:25 Fabio Mosti
CREATE OR REPLACE VIEW `proforma_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.timestamp_chiusura,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.nome,
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
   WHERE tipologie_documenti.se_pro_forma = 1
;

--| 090000027000

-- progetti_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `progetti_view`;

--| 090000027001

-- progetti_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:14 Fabio Mosti
CREATE OR REPLACE VIEW `progetti_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.nome,
        progetti.id_sito,
		progetti.template,
		progetti.schema_html,
		progetti.tema_css,
		progetti.se_sitemap,
		progetti.se_cacheable,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			' cliente ',
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
	GROUP BY progetti.id
;

--| 090000027010

-- progetti_commerciale_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `progetti_commerciale_view`;

--| 090000027011

-- progetti_commerciale_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:14 Fabio Mosti
CREATE OR REPLACE VIEW `progetti_commerciale_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
	WHERE progetti.data_accettazione IS NULL
		AND progetti.data_chiusura IS NULL
		AND progetti.data_archiviazione IS NULL
	GROUP BY progetti.id
;

--| 090000027012

-- progetti_commerciale_archivio_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `progetti_commerciale_archivio_view`;

--| 090000027013

-- progetti_commerciale_archivio_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:14 Fabio Mosti
CREATE OR REPLACE VIEW `progetti_commerciale_archivio_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
	WHERE progetti.data_accettazione IS NULL
		AND progetti.data_chiusura IS NULL
		AND progetti.data_archiviazione IS NOT NULL
	GROUP BY progetti.id
;

--| 090000027020

-- progetti_produzione_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `progetti_produzione_view`;

--| 090000027021

-- progetti_produzione_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:14 Fabio Mosti
CREATE OR REPLACE VIEW `progetti_produzione_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
	WHERE progetti.data_accettazione IS NOT NULL
		AND progetti.data_chiusura IS NULL
		AND progetti.data_archiviazione IS NULL
	GROUP BY progetti.id
;

--| 090000027022

-- progetti_produzione_archivio_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `progetti_produzione_archivio_view`;

--| 090000027023

-- progetti_produzione_archivio_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:14 Fabio Mosti
CREATE OR REPLACE VIEW `progetti_produzione_archivio_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
	WHERE progetti.data_accettazione IS NOT NULL
		AND progetti.data_chiusura IS NULL
		AND progetti.data_archiviazione IS NOT NULL
	GROUP BY progetti.id
;

--| 090000027030

-- progetti_amministrazione_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `progetti_amministrazione_view`;

--| 090000027031

-- progetti_amministrazione_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:14 Fabio Mosti
CREATE OR REPLACE VIEW `progetti_amministrazione_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
	WHERE progetti.data_accettazione IS NOT NULL
		AND progetti.data_chiusura IS NOT NULL
		AND progetti.data_archiviazione IS NULL
	GROUP BY progetti.id
;

--| 090000027032

-- progetti_amministrazione_archivio_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `progetti_amministrazione_archivio_view`;

--| 090000027033

-- progetti_amministrazione_archivio_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 14:14 Fabio Mosti
CREATE OR REPLACE VIEW `progetti_amministrazione_archivio_view` AS
	SELECT
		progetti.id,
		progetti.id_tipologia,
		tipologie_progetti_path( tipologie_progetti.id ) AS tipologia,
		progetti.id_pianificazione,
		progetti.id_cliente,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,
		progetti.id_indirizzo,
		progetti.nome,
		progetti.entrate_previste,
		progetti.ore_previste,
		progetti.costi_previsti,
		progetti.entrate_accettazione,
		progetti.data_accettazione,
		progetti.data_chiusura,
		progetti.entrate_totali,
		progetti.uscite_totali,
		progetti.data_archiviazione,
		group_concat( DISTINCT categorie_progetti_path( progetti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
		progetti.id_account_inserimento,
		progetti.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM progetti
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti.id_cliente
		LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
	WHERE progetti.data_accettazione IS NOT NULL
		AND progetti.data_chiusura IS NOT NULL
		AND progetti.data_archiviazione IS NOT NULL
	GROUP BY progetti.id
;

--| 090000027200

-- progetti_anagrafica_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `progetti_anagrafica_view`;

--| 090000027201

-- progetti_anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:07 Fabio Mosti
CREATE OR REPLACE VIEW progetti_anagrafica_view AS
	SELECT
		progetti_anagrafica.id,
		progetti_anagrafica.id_progetto,
		progetti.nome AS progetto,
		progetti_anagrafica.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		progetti_anagrafica.id_ruolo,
		ruoli_anagrafica.nome as ruolo,
		progetti_anagrafica.ordine,
		progetti_anagrafica.se_sostituto,
		progetti_anagrafica.id_account_inserimento,
		progetti_anagrafica.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ),
			ruoli_anagrafica.nome
		) AS __label__
	FROM progetti_anagrafica
		LEFT JOIN progetti ON progetti.id = progetti_anagrafica.id_progetto
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti_anagrafica.id_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = progetti_anagrafica.id_ruolo
;

--| 090000027300

-- progetti_articoli_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `progetti_articoli_view`;

--| 090000027301

-- progetti_articoli_view
-- tipologia: tabella gestita
-- verifica: 2021-04-14 14:58 Chiara GDL
CREATE OR REPLACE VIEW `progetti_articoli_view` AS
	SELECT
		progetti_articoli.id,
		progetti_articoli.id_progetto,
		progetti.nome AS progetto,
		progetti_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		progetti_articoli.id_ruolo,
		progetti_articoli.ordine,
		progetti_articoli.id_account_inserimento,
		progetti_articoli.id_account_aggiornamento,
		concat_ws(
			' ',
			progetti.nome,
			concat_ws( ' ', prodotti.nome, articoli.nome ),
			ruoli_articoli.nome
		) AS __label__
	FROM progetti_articoli
		LEFT JOIN ruoli_articoli ON ruoli_articoli.id = progetti_articoli.id_ruolo
		LEFT JOIN progetti ON progetti.id = progetti_articoli.id_progetto
		LEFT JOIN articoli ON articoli.id = progetti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto;

--| 090000027400

-- progetti_categorie_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `progetti_categorie_view`;

--| 090000027401

-- progetti_categorie_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:07 Fabio Mosti
CREATE OR REPLACE VIEW progetti_categorie_view AS
	SELECT
		progetti_categorie.id,
		progetti_categorie.id_progetto,
		progetti.nome AS progetto,
		progetti_categorie.id_categoria,
		categorie_progetti_path( progetti_categorie.id_categoria ) AS categoria,
		progetti_categorie.ordine,
		progetti_categorie.id_account_inserimento,
		progetti_categorie.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			categorie_progetti_path( progetti_categorie.id_categoria )
		) AS __label__
	FROM progetti_categorie
		LEFT JOIN progetti ON progetti.id = progetti_categorie.id_progetto
;

--| 090000027800

-- progetti_matricole_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `progetti_matricole_view`;

--| 090000027801

-- progetti_matricole_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 15:07 Fabio Mosti
CREATE OR REPLACE VIEW progetti_matricole_view AS
	SELECT
		progetti_matricole.id,
		progetti_matricole.id_progetto,
		progetti.nome AS progetto,
		progetti_matricole.id_matricola,
		matricole.matricola AS matricola,
		progetti_matricole.id_ruolo,
		ruoli_matricole_path( progetti_matricole.id_ruolo ) AS ruolo,
		progetti_matricole.ordine,
		progetti_matricole.id_account_inserimento,
		progetti_matricole.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			matricole.matricola
		) AS __label__
	FROM progetti_matricole
		LEFT JOIN progetti ON progetti.id = progetti_matricole.id_progetto
		LEFT JOIN matricole ON matricole.id = progetti_matricole.id_matricola
;

--| 090000028000

-- provincie_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `provincie_view`;

--| 090000028001

-- provincie_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-08 15:07 Fabio Mosti
CREATE OR REPLACE VIEW provincie_view AS
	SELECT
		provincie.id,
		provincie.id_regione,
		regioni.nome AS regione,
		regioni.id_stato,
		stati.nome AS stato,
		provincie.nome,
		provincie.sigla,
		provincie.codice_istat,
		concat_ws(
			' ',
			provincie.nome,
			concat( '(', provincie.sigla, ')' ),
			stati.nome
		) AS __label__
	FROM provincie
		INNER JOIN regioni ON regioni.id = provincie.id_regione
		INNER JOIN stati ON stati.id = regioni.id_stato
;

--| 090000028400

-- pubblicazioni_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `pubblicazioni_view`;

--| 090000028401

-- pubblicazioni_view
-- tipologia: tabella gestita
-- verifica: 2021-10-08 17:17 Fabio Mosti
CREATE OR REPLACE VIEW `pubblicazioni_view` AS
    SELECT
		pubblicazioni.id,
		pubblicazioni.id_tipologia,
		tipologie_pubblicazioni.nome AS tipologia,
		pubblicazioni.ordine,
		pubblicazioni.id_prodotto,
		pubblicazioni.id_articolo,
		pubblicazioni.id_categoria_prodotti,
		pubblicazioni.id_notizia,
		pubblicazioni.id_categoria_notizie,
		pubblicazioni.id_pagina,
		pubblicazioni.id_popup,
		pubblicazioni.id_risorsa,
		pubblicazioni.id_categoria_risorse,
		pubblicazioni.id_progetto,
		pubblicazioni.id_categoria_progetti,
		pubblicazioni.timestamp_inizio,
		pubblicazioni.timestamp_fine,
		concat_ws(
			' ',
			tipologie_pubblicazioni.nome,
			pubblicazioni.timestamp_inizio,
			pubblicazioni.timestamp_fine
		) AS __label__
    FROM pubblicazioni
		LEFT JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia
;

--| 090000028600

-- ranking_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `ranking_view`;

--| 090000028601

-- ranking_view
-- tipologia: tabella gestita
-- verifica: 2021-10-11 17:55 Fabio Mosti
CREATE OR REPLACE VIEW `ranking_view` AS
    SELECT
		ranking.id,
		ranking.nome,
		ranking.ordine,
		ranking.id_account_inserimento,
		ranking.id_account_aggiornamento,
		ranking.nome AS __label__
    FROM ranking
;

--| 090000029400

-- redirect_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `redirect_view`;

--| 090000029401

-- redirect_view
-- tipologia: tabella gestita
-- verifica: 2021-10-09 14:44 Fabio Mosti
CREATE OR REPLACE VIEW redirect_view AS
	SELECT
		redirect.id,
		redirect.id_sito,
		redirect.codice,
		redirect.sorgente,
		redirect.destinazione,
		redirect.id_account_inserimento,
		redirect.id_account_aggiornamento,
		concat_ws(
			' ',
			redirect.sorgente,
			redirect.codice,
			redirect.destinazione
		) AS __label__
	FROM redirect
;

--| 090000029800

-- regimi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `regimi_view`;

--| 090000029801

-- regimi_view
-- tipologia: tabella gestita
-- verifica: 2021-10-09 15:09 Fabio Mosti
CREATE OR REPLACE VIEW regimi_view AS
	SELECT
		regimi.id,
		regimi.nome,
		regimi.codice,
		concat_ws(
			' ',
			regimi.nome,
			regimi.codice
		) AS __label__
	FROM regimi
;

--| 090000030300

-- relazioni_anagrafica_view
-- tipologia: tabella relazione
DROP TABLE IF EXISTS `relazioni_anagrafica_view`;

--| 090000030301

-- relazioni_anagrafica_view
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE OR REPLACE VIEW relazioni_anagrafica_view AS
	SELECT
	relazioni_anagrafica.id,
	relazioni_anagrafica.id_ruolo,
	relazioni_anagrafica.id_anagrafica,
	relazioni_anagrafica.id_anagrafica_collegata,
	concat( relazioni_anagrafica.id_anagrafica,' - ', relazioni_anagrafica.id_anagrafica_collegata) AS __label__
	FROM relazioni_anagrafica
;

--| 090000030400

-- relazioni_documenti_view
-- tipologia: tabella relazione
DROP TABLE IF EXISTS `relazioni_documenti_view`;

--| 090000030401

-- relazioni_documenti_view
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE OR REPLACE VIEW relazioni_documenti_view AS
	SELECT
	relazioni_documenti.id_documento,
	relazioni_documenti.id_documento_collegato,
	concat( relazioni_documenti.id_documento,' - ', relazioni_documenti.id_documento_collegato) AS __label__
	FROM relazioni_documenti
;

--| 090000030410

-- relazioni_documenti_articoli_view
-- tipologia: tabella relazione
DROP TABLE IF EXISTS `relazioni_documenti_articoli_view`;

--| 090000030411

-- relazioni_documenti_articoli_view
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE OR REPLACE VIEW relazioni_documenti_articoli_view AS
	SELECT
	relazioni_documenti_articoli.id_documenti_articolo,
	relazioni_documenti_articoli.id_documenti_articolo_collegato,
	concat( relazioni_documenti_articoli.id_documenti_articolo,' - ', relazioni_documenti_articoli.id_documenti_articolo_collegato) AS __label__
	FROM relazioni_documenti_articoli
;

--| 090000030440

-- relazioni_pagamenti_view
-- tipologia: tabella relazione
DROP TABLE IF EXISTS `relazioni_pagamenti_view`;

--| 090000030441

-- relazioni_pagamenti_view
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE OR REPLACE VIEW relazioni_pagamenti_view AS
	SELECT
	relazioni_pagamenti.id_pagamento,
	relazioni_pagamenti.id_pagamento_collegato,
	concat( relazioni_pagamenti.id_pagamento,' - ', relazioni_pagamenti.id_pagamento_collegato) AS __label__
	FROM relazioni_pagamenti
;

--| 090000030490

-- relazioni_progetti_view
-- tipologia: tabella relazione
DROP TABLE IF EXISTS `relazioni_progetti_view`;

--| 090000030491

-- relazioni_progetti_view
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE OR REPLACE VIEW relazioni_progetti_view AS
	SELECT
	relazioni_progetti.id,
	relazioni_progetti.id_progetto,
	relazioni_progetti.id_progetto_collegato,
	relazioni_progetti.id_ruolo,
	ruoli_progetti.nome AS ruolo,
	concat( relazioni_progetti.id_progetto,' - ', relazioni_progetti.id_progetto_collegato) AS __label__
	FROM relazioni_progetti
	LEFT JOIN ruoli_progetti ON ruoli_progetti.id = relazioni_progetti.id_ruolo
;

--| 060000030500

-- relazioni_software_view
-- tipologia: tabella relazione
DROP TABLE IF EXISTS `relazioni_software_view`;

--| 060000030501

-- relazioni_software_view
-- tipologia: tabella relazione
-- verifica: 2022-01-17 16:12 Chiara GDL
CREATE OR REPLACE VIEW relazioni_software_view AS
	SELECT
	relazioni_software.id_software,
	relazioni_software.id_software_collegato,
	concat( relazioni_software.id_software,' - ', relazioni_software.id_software_collegato) AS __label__
	FROM relazioni_software
;

--| 090000030200

-- regioni_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `regioni_view`;

--| 090000030201

-- regioni_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 15:40 Fabio Mosti
CREATE OR REPLACE VIEW regioni_view AS
	SELECT
		regioni.id,
		regioni.id_stato,
		stati.nome AS stato,
		regioni.codice_istat,
		concat_ws(
			' ',
			regioni.nome,
			stati.nome
		) AS __label__
	FROM regioni
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

--| 090000030400
-- registri_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `registri_view`;

--| 090000030401
-- registri_view
-- tipologia: vista virtuale
-- verifica: 2022-01-28 14:51 Chiara GDL
CREATE OR REPLACE VIEW `registri_view` AS
	SELECT
		mastri.id,
		mastri.id_tipologia,
		tipologie_mastri.nome AS tipologia,
		mastri.nome,
		mastri_path( mastri.id ) AS __label__
	FROM mastri
		INNER JOIN tipologie_mastri ON tipologie_mastri.id = mastri.id_tipologia
WHERE tipologie_mastri.se_registro = 1
;

--| 090000030800

-- reparti_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS reparti_view;

--| 090000030801

-- reparti_view
-- tipologia: tabella assistita
-- verifica: 2021-10-09 15:40 Fabio Mosti
CREATE OR REPLACE VIEW reparti_view AS
	SELECT
		reparti.id,
		reparti.id_iva,
		iva.aliquota AS iva,
		reparti.id_settore,
		settori_path( reparti.id_settore ) AS settore,
		reparti.nome,
		reparti.id_account_inserimento,
		reparti.id_account_aggiornamento,
		reparti.nome AS __label__
	FROM reparti
		LEFT JOIN iva ON iva.id = reparti.id_iva
;



--| 090000031400

-- righe_fatture_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `righe_fatture_view`;

--| 090000031401

-- righe_fatture_view
-- tipologia: vista virtuale
-- verifica: 2021-10-09 16:02 Fabio Mosti
CREATE OR REPLACE VIEW `righe_fatture_view` AS
       SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
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
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		concat( 'MAT.',lpad(matricole.id, 15, '0') ) AS matricola,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
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
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti_articoli.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti_articoli.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti_articoli.id_tipologia
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
		WHERE tipologie_documenti.id = 1
;

--| 090000031402

-- righe_fatture_passive_view
-- tipologia: vista virtuale
DROP TABLE IF EXISTS `righe_fatture_passive_view`;

--| 090000031403

-- righe_fatture_passive_view
-- tipologia: vista virtuale
-- verifica: 2021-10-09 16:02 Fabio Mosti
CREATE OR REPLACE VIEW `righe_fatture_passive_view` AS
       SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
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
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		concat( 'MAT.',lpad(matricole.id, 15, '0') ) AS matricola,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
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
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti_articoli.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti_articoli.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti_articoli.id_tipologia
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
		WHERE tipologie_documenti.id = 11
;

--| 090000031404

-- righe_proforma_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `righe_proforma_view`;

--| 090000031405

-- righe_proforma_view
-- tipologia: tabella gestita
-- verifica: 2021-10-09 16:02 Fabio Mosti
CREATE OR REPLACE VIEW `righe_proforma_view` AS
        SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
		documenti_articoli.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
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
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		concat( 'MAT.',lpad(matricole.id, 15, '0') ) AS matricola,
		documenti_articoli.nome,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
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
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti_articoli.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti_articoli.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti_articoli.id_tipologia
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
		WHERE tipologie_documenti.se_pro_forma = 1
;

--| 090000031500

-- rinnovi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `rinnovi_view`;

--| 090000031501

-- rinnovi_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 12:59 Chiara GDL
CREATE OR REPLACE VIEW `rinnovi_view` AS
	SELECT
		rinnovi.id,
		rinnovi.id_contratto,
		contratti.nome AS contratto,
		rinnovi.id_licenza,
		licenze.nome AS licenza,
		rinnovi.id_progetto,
		progetti.nome AS progetto,
		rinnovi.data_inizio,
		rinnovi.data_fine,
		rinnovi.codice,
		rinnovi.id_account_inserimento,
		rinnovi.id_account_aggiornamento,
		concat('rinnovo ', rinnovi.id, ' dal ',CONCAT_WS('-',rinnovi.data_inizio),' al ',CONCAT_WS('-',rinnovi.data_fine)) AS __label__
	FROM rinnovi
		LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto 
		LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza 
		LEFT JOIN progetti ON progetti.id = rinnovi.id_progetto
	;

--| 090000031550

-- rinnovi_documenti_articoli_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `rinnovi_documenti_articoli_view`;

--| 090000031551

-- rinnovi_documenti_articoli_view
-- tipologia: tabella gestita
-- verifica: 2022-03-08 15:59 Chiara GDL
CREATE OR REPLACE VIEW rinnovi_documenti_articoli_view AS
	SELECT
	rinnovi_documenti_articoli.id_documenti_articolo,
	rinnovi_documenti_articoli.id_rinnovo,
	concat( rinnovi_documenti_articoli.id_rinnovo ,' - ', rinnovi_documenti_articoli.id_documenti_articolo) AS __label__
	FROM rinnovi_documenti_articoli
	ORDER BY __label__
;

--| 090000032000

-- risorse_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `risorse_view`;

--| 090000032001

-- risorse_view
-- tipologia: tabella gestita
-- verifica: 2021-10-09 16:02 Fabio Mosti
CREATE OR REPLACE VIEW `risorse_view` AS
	SELECT
		risorse.id, 
		risorse.id_tipologia,
		tipologie_risorse.nome AS tipologia,
		risorse.codice, 
		risorse.nome,
		risorse.template,
		risorse.schema_html,
		risorse.tema_css,
		risorse.se_sitemap,
		risorse.se_cacheable,
		risorse.id_sito,
		risorse.id_testata, 
		testate.nome AS testata,
		risorse.giorno_pubblicazione,
		risorse.mese_pubblicazione,
		risorse.anno_pubblicazione,
		risorse.id_account_inserimento,
		risorse.id_account_aggiornamento,
		concat_ws(
			' ',
			risorse.codice,
			risorse.nome
		) AS __label__
	FROM risorse
		LEFT JOIN tipologie_risorse ON tipologie_risorse.id = risorse.id_tipologia
		LEFT JOIN testate ON testate.id = risorse.id_testata
;

--| 090000032200

-- risorse_anagrafica_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `risorse_anagrafica_view`;

--| 090000032201

-- risorse_anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2021-10-09 16:18 Fabio Mosti
CREATE OR REPLACE VIEW `risorse_anagrafica_view` AS
	SELECT
		risorse_anagrafica.id,
		risorse_anagrafica.id_risorsa,
		risorse.nome AS risorsa,
		risorse_anagrafica.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		risorse_anagrafica.id_ruolo,
		ruoli_anagrafica_path( risorse_anagrafica.id_ruolo ) AS ruolo,
		risorse_anagrafica.ordine,
		risorse_anagrafica.id_account_inserimento,
		risorse_anagrafica.id_account_aggiornamento,
		concat_ws(
			' ',
			risorse.nome,
			ruoli_anagrafica_path( risorse_anagrafica.id_ruolo ),
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM risorse_anagrafica
		LEFT JOIN risorse ON risorse.id = risorse_anagrafica.id_risorsa
		LEFT JOIN anagrafica AS a1 ON a1.id = risorse_anagrafica.id_anagrafica
;

--| 090000032400

-- risorse_categorie_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `risorse_categorie_view`;

--| 090000032400

-- risorse_categorie_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:03 Fabio Mosti
CREATE OR REPLACE VIEW `risorse_categorie_view` AS
	SELECT
		risorse_categorie.id,
		risorse_categorie.id_risorsa,
		risorse.nome AS risorsa,
		risorse_categorie.id_categoria,
		categorie_risorse_path( risorse_categorie.id_categoria ),
		risorse_categorie.id_account_inserimento,
		risorse_categorie.id_account_aggiornamento,
		concat_ws(
			' ',
			risorse.nome,
			categorie_risorse_path( risorse_categorie.id_categoria )
		) AS __label__
	FROM risorse_categorie
		LEFT JOIN risorse ON risorse.id = risorse_categorie.id_risorsa
;

--| 090000034000

-- ruoli_anagrafica_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `ruoli_anagrafica_view`;

--| 090000034001

-- ruoli_anagrafica_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:17 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_anagrafica_view AS
	SELECT
		ruoli_anagrafica.id,
		ruoli_anagrafica.id_genitore,
		ruoli_anagrafica.nome,
		ruoli_anagrafica.se_produzione,
		ruoli_anagrafica.se_didattica,
		ruoli_anagrafica.se_organizzazioni,
		ruoli_anagrafica.se_relazioni,
		ruoli_anagrafica.se_risorse,
		ruoli_anagrafica.se_progetti,
		ruoli_anagrafica.se_immobili,
		ruoli_anagrafica.se_contratti,
	 	ruoli_anagrafica_path( ruoli_anagrafica.id ) AS __label__
	FROM ruoli_anagrafica
;

--| 090000034100

-- ruoli_articoli_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `ruoli_articoli_view`;

--| 090000034101

-- ruoli_articoli_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:17 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_articoli_view AS
	SELECT
		ruoli_articoli.id,
		ruoli_articoli.id_genitore,
		ruoli_articoli.nome,
		ruoli_articoli.html_entity,
		ruoli_articoli.font_awesome,
		ruoli_articoli.se_progetti,
		ruoli_articoli.se_risorse,
		ruoli_articoli.se_acquisto,
        ruoli_articoli.se_rinnovo,
	 	ruoli_articoli_path( ruoli_articoli.id ) AS __label__
	FROM ruoli_articoli
;

--| 090000034200

-- ruoli_audio_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `ruoli_audio_view`;

--| 090000034201

-- ruoli_audio_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-09 18:41 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_audio_view AS
	SELECT
		ruoli_audio.id,
		ruoli_audio.id_genitore,
		ruoli_audio.nome,
		ruoli_audio.html_entity,
		ruoli_audio.font_awesome,
		ruoli_audio.se_anagrafica,
		ruoli_audio.se_pagine,
		ruoli_audio.se_prodotti,
		ruoli_audio.se_articoli,
		ruoli_audio.se_categorie_prodotti,
		ruoli_audio.se_notizie,
		ruoli_audio.se_categorie_notizie,
		ruoli_audio.se_risorse,
		ruoli_audio.se_categorie_risorse,
	 	ruoli_audio_path( ruoli_audio.id ) AS __label__
	FROM ruoli_audio
;

--| 090000034400

-- ruoli_file_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `ruoli_file_view`;

--| 090000034401

-- ruoli_file_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 18:26 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_file_view AS
	SELECT
		ruoli_file.id,
		ruoli_file.id_genitore,
		ruoli_file.nome,
		ruoli_file.html_entity,
		ruoli_file.font_awesome,
		ruoli_file.se_anagrafica,
		ruoli_file.se_pagine,
		ruoli_file.se_prodotti,
		ruoli_file.se_articoli,
		ruoli_file.se_categorie_prodotti,
		ruoli_file.se_notizie,
		ruoli_file.se_categorie_notizie,
		ruoli_file.se_risorse,
		ruoli_file.se_categorie_risorse,
		ruoli_file.se_mail,
	 	ruoli_file_path( ruoli_file.id ) AS __label__
	FROM ruoli_file
;

--| 090000034600

-- ruoli_immagini_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `ruoli_immagini_view`;

--| 090000034601

-- ruoli_immagini_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 18:26 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_immagini_view AS
	SELECT
		ruoli_immagini.id,
		ruoli_immagini.id_genitore,
		ruoli_immagini.ordine_scalamento,
		ruoli_immagini.nome,
		ruoli_immagini.html_entity,
		ruoli_immagini.font_awesome,
		ruoli_immagini.se_anagrafica,
		ruoli_immagini.se_pagine,
		ruoli_immagini.se_prodotti,
		ruoli_immagini.se_articoli,
		ruoli_immagini.se_categorie_prodotti,
		ruoli_immagini.se_notizie,
		ruoli_immagini.se_categorie_notizie,
		ruoli_immagini.se_risorse,
		ruoli_immagini.se_categorie_risorse,
	 	ruoli_immagini_path( ruoli_immagini.id ) AS __label__
	FROM ruoli_immagini
;

--| 090000034800

-- ruoli_indirizzi_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `ruoli_indirizzi_view`;

--| 090000034801

-- ruoli_indirizzi_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 11:23 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_indirizzi_view AS
	SELECT
		ruoli_indirizzi.id,
		ruoli_indirizzi.id_genitore,
		ruoli_indirizzi.nome,
    	ruoli_indirizzi.html_entity,
    	ruoli_indirizzi.font_awesome,
    	ruoli_indirizzi.se_sede_legale,
    	ruoli_indirizzi.se_sede_operativa,
    	ruoli_indirizzi.se_residenza,
    	ruoli_indirizzi.se_domicilio,
	 	ruoli_indirizzi_path( ruoli_indirizzi.id ) AS __label__
	FROM ruoli_indirizzi
;

--| 090000034900

-- ruoli_matricole_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `ruoli_matricole_view`;

--| 090000034901

-- ruoli_matricole_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 11:23 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_matricole_view AS
	SELECT
		ruoli_matricole.id,
		ruoli_matricole.id_genitore,
		ruoli_matricole.nome,
    	ruoli_matricole.html_entity,
    	ruoli_matricole.font_awesome,
	 	ruoli_matricole_path( ruoli_matricole.id ) AS __label__
	FROM ruoli_matricole
;

--| 090000035000

-- ruoli_prodotti_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `ruoli_prodotti_view`;

--| 090000035001

-- ruoli_prodotti_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 11:23 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_prodotti_view AS
	SELECT
		ruoli_prodotti.id,
		ruoli_prodotti.id_genitore,
		ruoli_prodotti.nome,
	 	ruoli_prodotti_path( ruoli_prodotti.id ) AS __label__
	FROM ruoli_prodotti
;

--| 090000035100

-- ruoli_progetti
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `ruoli_progetti_view`;

--| 090000035101

-- ruoli_progetti
-- tipologia: tabella di supporto
-- verifica: 2022-04-20 10:45 chiara GDL
CREATE OR REPLACE VIEW ruoli_progetti_view AS
	SELECT
		ruoli_progetti.id,
		ruoli_progetti.nome,
		ruoli_progetti.html_entity,
		ruoli_progetti.font_awesome,
		ruoli_progetti.se_sottoprogetto,
		ruoli_progetti.se_proseguimento,
		ruoli_progetti.se_sostituto,
	 	ruoli_progetti.nome AS __label__
	FROM ruoli_progetti
;

--| 090000035200

-- ruoli_video_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `ruoli_video_view`;

--| 090000035201

-- ruoli_video_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-11 18:26 Fabio Mosti
CREATE OR REPLACE VIEW ruoli_video_view AS
	SELECT
		ruoli_video.id,
		ruoli_video.id_genitore,
		ruoli_video.nome,
		ruoli_video.html_entity,
		ruoli_video.font_awesome,
		ruoli_video.se_anagrafica,
		ruoli_video.se_pagine,
		ruoli_video.se_prodotti,
		ruoli_video.se_articoli,
		ruoli_video.se_categorie_prodotti,
		ruoli_video.se_notizie,
		ruoli_video.se_categorie_notizie,
		ruoli_video.se_risorse,
		ruoli_video.se_categorie_risorse,
	 	ruoli_video_path( ruoli_video.id ) AS __label__
	FROM ruoli_video
;

--| 090000037000

-- settori_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `settori_view`;

--| 090000037001

-- settori_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 11:27 Fabio Mosti
CREATE OR REPLACE VIEW settori_view AS
	SELECT
		settori.id,
		settori.id_genitore,
		settori.nome,
		settori.soprannome,
		settori.ateco,
	 	settori_path( settori.id ) AS __label__
	FROM settori
;

--| 090000041000

-- sms_out_view
-- tipolgia: tabella gestita
DROP TABLE IF EXISTS `sms_out_view`;

--| 090000041001

-- sms_out_view
-- tipolgia: tabella gestita
-- verifica: 2021-10-12 15:17 Fabio Mosti
CREATE OR REPLACE VIEW `sms_out_view` AS
	SELECT
		sms_out.id,
		sms_out.id_telefono,
		sms_out.ordine,
		sms_out.timestamp_composizione,
		sms_out.mittente,
		sms_out.destinatari,
		sms_out.corpo,
		sms_out.server,
		sms_out.host,
		sms_out.port,
		sms_out.user,
		sms_out.password,
		sms_out.token,
		sms_out.tentativi,
		sms_out.timestamp_invio,
		sms_out.id_account_inserimento,
		sms_out.id_account_aggiornamento,
		concat_ws(
			' ',
			sms_out.destinatari,
			sms_out.corpo
		) AS __label__
	FROM sms_out
;

--| 090000041200

-- sms_sent_view
-- tipolgia: tabella gestita
DROP TABLE IF EXISTS `sms_sent_view`;

--| 090000041201

-- sms_sent_view
-- tipolgia: tabella gestita
-- verifica: 2021-10-12 15:17 Fabio Mosti
CREATE OR REPLACE VIEW `sms_sent_view` AS
	SELECT
		sms_sent.id,
		sms_sent.id_telefono,
		sms_sent.ordine,
		sms_sent.timestamp_composizione,
		sms_sent.mittente,
		sms_sent.destinatari,
		sms_sent.corpo,
		sms_sent.server,
		sms_sent.host,
		sms_sent.port,
		sms_sent.user,
		sms_sent.password,
		sms_sent.token,
		sms_sent.tentativi,
		sms_sent.timestamp_invio,
		sms_sent.id_account_inserimento,
		sms_sent.id_account_aggiornamento,
		concat_ws(
			' ',
			sms_sent.destinatari,
			sms_sent.corpo
		) AS __label__
	FROM sms_sent
;

--| 090000041400

-- software
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `software_view`;

--| 090000041401

-- software
-- tipologia: tabella gestita
-- verifica: 2021-11-16 10:39 Chiara GDL 
CREATE OR REPLACE VIEW software_view AS
    SELECT
		software.id,
		software.id_genitore,
		software.id_articolo,
		concat(prodotti.nome, ' - ',articoli.nome) AS articolo,
		software.json,
		software.nome,
		software.note,
		software.id_account_inserimento,
		software.id_account_aggiornamento,
	 	software_path( software.id ) AS __label__
	FROM software
		LEFT JOIN articoli ON software.id_articolo = articoli.id
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

--| 090000042000

-- stati_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `stati_view`;

--| 090000042001

-- stati_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 15:17 Fabio Mosti
CREATE OR REPLACE VIEW stati_view AS
    SELECT
		stati.id,
		stati.id_continente,
		continenti.nome AS continente,
		stati.nome,
		stati.iso31661alpha2,
		stati.iso31661alpha3,
		stati.codice_istat,
		data_archiviazione,
		concat_ws(
			' ',
			continenti.nome,
			stati.nome
		) AS __label__
    FROM stati
    	LEFT JOIN continenti ON continenti.id = stati.id_continente
;

--| 090000042200

-- stati_lingue_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `stati_lingue_view`;

--| 090000042201

-- stati_lingue_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-12 15:33 Fabio Mosti
CREATE OR REPLACE VIEW stati_lingue_view AS
    SELECT
		stati_lingue.id,
		stati_lingue.id_stato,
		stati.nome AS stato,
		stati_lingue.id_lingua,
		lingue.nome AS lingua,
		stati_lingue.ordine,
		concat_ws(
			' ',
			stati.nome,
			lingue.nome
		) AS __label__
    FROM stati_lingue
    	LEFT JOIN stati ON stati.id = stati_lingue.id_stato
    	LEFT JOIN lingue ON lingue.id = stati_lingue.id_lingua
;

--| 090000043000

-- task_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `task_view`;

--| 090000043001

-- task_view
-- tipologia: tabella assistita
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
		from_unixtime( task.timestamp_esecuzione, '%Y-%m-%d %H:%i' ) AS data_ora_esecuzione,
		task.id_account_inserimento,
		task.id_account_aggiornamento,
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

--| 090000043600

-- telefoni_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS telefoni_view;

--| 090000043601

-- telefoni_view
-- tipologia: tabella gestita
-- verifica: 2021-10-15 11:54 Fabio Mosti
CREATE OR REPLACE VIEW telefoni_view AS
	SELECT
		telefoni.id,
		telefoni.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		telefoni.id_tipologia,
		tipologie_telefoni.nome AS tipologia,
		telefoni.numero,
		telefoni.se_notifiche,
		telefoni.id_account_inserimento,
		telefoni.id_account_aggiornamento,
		concat_ws(
			' ',
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ),
			tipologie_telefoni.nome,
			telefoni.numero
		) AS __label__
	FROM telefoni
		LEFT JOIN anagrafica AS a1 ON a1.id = telefoni.id_anagrafica
		LEFT JOIN tipologie_telefoni ON tipologie_telefoni.id = telefoni.id_tipologia
;

--| 090000044000

-- template_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `template_view`;

--| 090000044001

-- template_view
-- tipologia: tabella gestita
-- verifica: 2021-10-15 12:43 Fabio Mosti
CREATE OR REPLACE VIEW `template_view` AS
	SELECT
		template.id,
		template.ruolo,
		template.nome,
		template.tipo,
		template.note,
		template.latenza_invio,
		template.se_mail,
		template.se_sms,
		template.id_account_inserimento,
		template.id_account_aggiornamento,
		template.ruolo AS __label__
	FROM template
;

--| 090000044500

-- tesseramenti_view
-- tipologia: tabella gestita
-- verifica: 2021-09-10 16:54 Fabio Mosti
DROP TABLE IF EXISTS `tesseramenti_view`;

--| 090000044501

-- tesseramenti_view
-- tipologia: tabella gestita
-- verifica: 2021-09-10 16:54 Fabio Mosti
CREATE OR REPLACE VIEW `tesseramenti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
    WHERE tipologie_contratti.se_tesseramento = 1
;

--| 090000044510

-- tesseramenti_view
-- tipologia: tabella gestita
-- verifica: 2021-09-10 16:54 Fabio Mosti
DROP TABLE IF EXISTS `tesseramenti_attivi_view`;

--| 090000044511

-- tesseramenti_view
-- tipologia:vista virtuale
-- verifica: 2021-09-10 16:54 Fabio Mosti
CREATE OR REPLACE VIEW `tesseramenti_attivi_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_tesseramento = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio <= CURRENT_DATE() ) AND (rinnovi.data_fine IS NULL OR rinnovi.data_fine >= CURRENT_DATE() )
    GROUP BY contratti.id
;

--| 090000044520

-- tesseramenti_archiviati_view
-- tipologia: vista virtuale
-- verifica: 2021-09-10 16:54 Fabio Mosti
DROP TABLE IF EXISTS `tesseramenti_attivi_view`;

--| 090000044521

-- tesseramenti_archiviati_view
-- tipologia: vista virtuale
-- verifica: 2021-09-10 16:54 Fabio Mosti
CREATE OR REPLACE VIEW `tesseramenti_archiviati_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		contratti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN anagrafica AS a1 ON a1.id = contratti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = contratti.id_destinatario
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
    WHERE tipologie_contratti.se_tesseramento = 1 AND ( rinnovi.data_inizio IS NULL OR rinnovi.data_inizio >= CURRENT_DATE() ) AND  rinnovi.data_fine < CURRENT_DATE() 
    GROUP BY contratti.id
;

--| 090000045000

-- testate_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `testate_view`;

--| 090000045001

-- testate_view
-- tipologia: tabella gestita
-- verifica: 2021-09-10 16:54 Fabio Mosti
CREATE OR REPLACE VIEW `testate_view` AS
	SELECT
		testate.id,
		testate.nome,
		testate.nome AS __label__
	FROM testate
;

--| 090000050000

-- tipologie_anagrafica_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_anagrafica_view`;

--| 090000050001

-- tipologie_anagrafica_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_anagrafica_view` AS
	SELECT
		tipologie_anagrafica.id,
		tipologie_anagrafica.id_genitore,
		tipologie_anagrafica.ordine,
		tipologie_anagrafica.nome,
		tipologie_anagrafica.html_entity,
		tipologie_anagrafica.font_awesome,
		tipologie_anagrafica.se_persona_fisica,
        tipologie_anagrafica.se_persona_giuridica,
        tipologie_anagrafica.se_pubblica_amministrazione,
		tipologie_anagrafica.id_account_inserimento,
		tipologie_anagrafica.id_account_aggiornamento,
		tipologie_anagrafica_path( tipologie_anagrafica.id ) AS __label__
	FROM tipologie_anagrafica
;

--| 090000050400

-- tipologie_attivita_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_attivita_view`;

--| 090000050401

-- tipologie_attivita_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_attivita_view` AS
	SELECT
		tipologie_attivita.id,
		tipologie_attivita.id_genitore,
		tipologie_attivita.ordine,
		tipologie_attivita.codice,
		tipologie_attivita.nome,
		tipologie_attivita.html_entity,
		tipologie_attivita.font_awesome,
		tipologie_attivita.se_anagrafica,
		tipologie_attivita.se_agenda,
		tipologie_attivita.id_account_inserimento,
		tipologie_attivita.id_account_aggiornamento,
		tipologie_attivita_path( tipologie_attivita.id ) AS __label__
	FROM tipologie_attivita
;

--| 090000050600

-- tipologie_chiavi_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_chiavi_view`;

--| 0900000050601

-- tipologie_chiavi_view
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_chiavi_view` AS
	SELECT
		tipologie_chiavi.id,
		tipologie_chiavi.id_genitore,
		tipologie_chiavi.ordine,
		tipologie_chiavi.nome,
		tipologie_chiavi.html_entity,
		tipologie_chiavi.font_awesome,
		tipologie_chiavi.id_account_inserimento,
		tipologie_chiavi.id_account_aggiornamento,
		tipologie_chiavi_path( tipologie_chiavi.id ) AS __label__
	FROM tipologie_chiavi
;

--| 090000050800

-- tipologie_contatti_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_contatti_view`;

--| 090000050801

-- tipologie_contatti_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_contatti_view` AS
	SELECT
		tipologie_contatti.id,
		tipologie_contatti.id_genitore,
		tipologie_contatti.ordine,
		tipologie_contatti.nome,
		tipologie_contatti.html_entity,
		tipologie_contatti.font_awesome,
		tipologie_contatti.id_account_inserimento,
		tipologie_contatti.id_account_aggiornamento,
		tipologie_contatti_path( tipologie_contatti.id ) AS __label__
	FROM tipologie_contatti
;

--| 090000050900

-- tipologie_contratti
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `tipologie_contratti_view`;

--| 090000050901

-- tipologie_contratti
-- tipologia: tabella gestita
-- verifica: 2022-02-21 11:47 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_contratti_view` AS
	SELECT
		tipologie_contratti.id,
		tipologie_contratti.ordine,
		tipologie_contratti.nome,
		tipologie_contratti.html_entity,
		tipologie_contratti.font_awesome,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.id_account_inserimento,
		tipologie_contratti.id_account_aggiornamento,
		tipologie_contratti.nome  AS __label__
	FROM tipologie_contratti
;

--| 090000052600

-- tipologie_documenti_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_documenti_view`;

--| 090000052601

-- tipologie_documenti_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_documenti_view` AS
	SELECT
		tipologie_documenti.id,
		tipologie_documenti.id_genitore,
		tipologie_documenti.ordine,
		tipologie_documenti.codice,
		tipologie_documenti.numerazione,
		tipologie_documenti.nome,
		tipologie_documenti.html_entity,
		tipologie_documenti.font_awesome,
		tipologie_documenti.se_fattura,
		tipologie_documenti.se_nota_credito,
		tipologie_documenti.se_trasporto,
		tipologie_documenti.se_pro_forma,
		tipologie_documenti.se_offerta,
		tipologie_documenti.se_ordine,
		tipologie_documenti.se_ricevuta,
		tipologie_documenti.id_account_inserimento,
		tipologie_documenti.id_account_aggiornamento,
		tipologie_documenti_path( tipologie_documenti.id ) AS __label__
	FROM tipologie_documenti
;

--| 090000052800

-- tipologie_edifici_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `tipologie_edifici_view`;

--| 090000052801

-- tipologie_edifici_view
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
CREATE OR REPLACE VIEW tipologie_edifici_view AS
	SELECT
	tipologie_edifici.id,
	tipologie_edifici.id_genitore,
	tipologie_edifici.ordine,
	tipologie_edifici.nome,
	tipologie_edifici.html_entity,
	tipologie_edifici.font_awesome,
	tipologie_edifici.id_account_inserimento,
	tipologie_edifici.id_account_aggiornamento,
	tipologie_edifici_path( tipologie_edifici.id )  AS __label__
	FROM tipologie_edifici
	;

--| 090000052900

-- tipologie_immobili_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `tipologie_immobili_view`;

--| 090000052901

-- tipologie_immobili_view
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
CREATE OR REPLACE VIEW tipologie_immobili_view AS
	SELECT
	tipologie_immobili.id,
	tipologie_immobili.id_genitore,
	tipologie_immobili.ordine,
	tipologie_immobili.nome,
	tipologie_immobili.html_entity,
	tipologie_immobili.font_awesome,
	tipologie_immobili.se_residenziale ,
	tipologie_immobili.se_industriale ,
	tipologie_immobili.id_account_inserimento,
	tipologie_immobili.id_account_aggiornamento,
	tipologie_immobili_path( tipologie_immobili.id )  AS __label__
	FROM tipologie_immobili
	;

--| 090000053000

-- tipologie_indirizzi_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_indirizzi_view`;

--| 090000053001

-- tipologie_indirizzi_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_indirizzi_view` AS
	SELECT
		tipologie_indirizzi.id,
		tipologie_indirizzi.id_genitore,
		tipologie_indirizzi.ordine,
		tipologie_indirizzi.nome,
		tipologie_indirizzi.html_entity,
		tipologie_indirizzi.font_awesome,
		tipologie_indirizzi.id_account_inserimento,
		tipologie_indirizzi.id_account_aggiornamento,
		tipologie_indirizzi_path( tipologie_indirizzi.id ) AS __label__
	FROM tipologie_indirizzi
;

--| 090000053200

-- tipologie_licenze_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_licenze_view`;

--| 0900000053201

-- tipologie_licenze_view
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_licenze_view` AS
	SELECT
		tipologie_licenze.id,
		tipologie_licenze.id_genitore,
		tipologie_licenze.ordine,
		tipologie_licenze.nome,
		tipologie_licenze.html_entity,
		tipologie_licenze.font_awesome,
		tipologie_licenze.id_account_inserimento,
		tipologie_licenze.id_account_aggiornamento,
		tipologie_licenze_path( tipologie_licenze.id ) AS __label__
	FROM tipologie_licenze
;

--| 090000053300

-- tipologie_luoghi_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `tipologie_luoghi_view`;

--| 090000053301

-- tipologie_luoghi_view
-- tipologia: tabella gestita
-- verifica: 2022-02-21 15:30 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_luoghi_view` AS
	SELECT
		tipologie_luoghi.id,
		tipologie_luoghi.id_genitore,
		tipologie_luoghi.ordine,
		tipologie_luoghi.nome,
		tipologie_luoghi.html_entity,
		tipologie_luoghi.font_awesome,
		tipologie_luoghi.id_account_inserimento,
		tipologie_luoghi.id_account_aggiornamento,
		tipologie_luoghi_path( tipologie_luoghi.id ) AS __label__
	FROM tipologie_luoghi
;

--| 090000053400

-- tipologie_mastri_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_mastri_view`;

--| 090000053401

-- tipologie_mastri_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_mastri_view` AS
	SELECT
		tipologie_mastri.id,
		tipologie_mastri.id_genitore,
		tipologie_mastri.ordine,
		tipologie_mastri.nome,
		tipologie_mastri.html_entity,
		tipologie_mastri.font_awesome,
		tipologie_mastri.se_magazzino,
		tipologie_mastri.se_conto,
		tipologie_mastri.se_registro,
		tipologie_mastri.id_account_inserimento,
		tipologie_mastri.id_account_aggiornamento,
		tipologie_mastri_path( tipologie_mastri.id ) AS __label__
	FROM tipologie_mastri
;

--| 090000053800

-- tipologie_notizie_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_notizie_view`;

--| 090000053801

-- tipologie_notizie_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_notizie_view` AS
	SELECT
		tipologie_notizie.id,
		tipologie_notizie.id_genitore,
		tipologie_notizie.ordine,
		tipologie_notizie.nome,
		tipologie_notizie.html_entity,
		tipologie_notizie.font_awesome,
		tipologie_notizie.id_account_inserimento,
		tipologie_notizie.id_account_aggiornamento,
		tipologie_notizie_path( tipologie_notizie.id ) AS __label__
	FROM tipologie_notizie
;

--| 090000054000

-- tipologie_pagamenti_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_pagamenti_view`;

--| 0900000054001

-- tipologie_pagamenti_view
-- tipologia: tabella assistita
-- verifica: 2021-11-15 11:29 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_pagamenti_view` AS
	SELECT
		tipologie_pagamenti.id,
		tipologie_pagamenti.id_genitore,
		tipologie_pagamenti.ordine,
		tipologie_pagamenti.nome,
		tipologie_pagamenti.html_entity,
		tipologie_pagamenti.font_awesome,
		tipologie_pagamenti.id_account_inserimento,
		tipologie_pagamenti.id_account_aggiornamento,
		tipologie_pagamenti_path( tipologie_pagamenti.id ) AS __label__
	FROM tipologie_pagamenti
;

--| 090000054200

-- tipologie_popup_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_popup_view`;

--| 090000054201

-- tipologie_popup_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_popup_view` AS
	SELECT
		tipologie_popup.id,
		tipologie_popup.id_genitore,
		tipologie_popup.ordine,
		tipologie_popup.nome,
		tipologie_popup.html_entity,
		tipologie_popup.font_awesome,
		tipologie_popup.id_account_inserimento,
		tipologie_popup.id_account_aggiornamento,
		tipologie_popup_path( tipologie_popup.id ) AS __label__
	FROM tipologie_popup
;

--| 090000054600

-- tipologie_prodotti_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_prodotti_view`;

--| 090000054601

-- tipologie_prodotti_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_prodotti_view` AS
	SELECT
		tipologie_prodotti.id,
		tipologie_prodotti.id_genitore,
		tipologie_prodotti.ordine,
		tipologie_prodotti.nome,
		tipologie_prodotti.html_entity,
		tipologie_prodotti.font_awesome,
		tipologie_prodotti.se_colori,
		tipologie_prodotti.se_taglie,
		tipologie_prodotti.se_dimensioni,
		tipologie_prodotti.se_imballo,
		tipologie_prodotti.se_spedizione,
		tipologie_prodotti.se_trasporto,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		tipologie_prodotti.se_volume,
		tipologie_prodotti.se_capacita,
		tipologie_prodotti.se_peso,
		tipologie_prodotti.id_account_inserimento,
		tipologie_prodotti.id_account_aggiornamento,
		tipologie_prodotti_path( tipologie_prodotti.id ) AS __label__
	FROM tipologie_prodotti
;

--| 090000055000

-- tipologie_progetti_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_progetti_view`;

--| 090000055001

-- tipologie_progetti_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_progetti_view` AS
	SELECT
		tipologie_progetti.id,
		tipologie_progetti.id_genitore,
		tipologie_progetti.ordine,
		tipologie_progetti.nome,
		tipologie_progetti.html_entity,
		tipologie_progetti.font_awesome,
		tipologie_progetti.se_produzione,
		tipologie_progetti.se_contratto,
		tipologie_progetti.se_pacchetto,
		tipologie_progetti.se_progetto,
		tipologie_progetti.se_consuntivo,
		tipologie_progetti.se_forfait,
		tipologie_progetti.se_didattica,
		tipologie_progetti.id_account_inserimento,
		tipologie_progetti.id_account_aggiornamento,
		tipologie_progetti_path( tipologie_progetti.id ) AS __label__
	FROM tipologie_progetti
;

--| 090000055400

-- tipologie_pubblicazioni_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_pubblicazioni_view`;

--| 090000055401

-- tipologie_pubblicazioni_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_pubblicazioni_view` AS
	SELECT
		tipologie_pubblicazioni.id,
		tipologie_pubblicazioni.id_genitore,
		tipologie_pubblicazioni.ordine,
		tipologie_pubblicazioni.nome,
		tipologie_pubblicazioni.html_entity,
		tipologie_pubblicazioni.font_awesome,
		tipologie_pubblicazioni.id_account_inserimento,
		tipologie_pubblicazioni.id_account_aggiornamento,
		tipologie_pubblicazioni_path( tipologie_pubblicazioni.id ) AS __label__
	FROM tipologie_pubblicazioni
;

--| 090000055800

-- tipologie_risorse_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_risorse_view`;

--| 090000055801

-- tipologie_risorse_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:11 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_risorse_view` AS
	SELECT
		tipologie_risorse.id,
		tipologie_risorse.id_genitore,
		tipologie_risorse.ordine,
		tipologie_risorse.nome,
		tipologie_risorse.html_entity,
		tipologie_risorse.font_awesome,
		tipologie_risorse.id_account_inserimento,
		tipologie_risorse.id_account_aggiornamento,
		tipologie_risorse_path( tipologie_risorse.id ) AS __label__
	FROM tipologie_risorse
;

--| 090000056200

-- tipologie_telefoni_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_telefoni_view`;

--| 090000056201

-- tipologie_telefoni_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:12 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_telefoni_view` AS
	SELECT
		tipologie_telefoni.id,
		tipologie_telefoni.id_genitore,
		tipologie_telefoni.ordine,
		tipologie_telefoni.nome,
		tipologie_telefoni.html_entity,
		tipologie_telefoni.font_awesome,
		tipologie_telefoni.id_account_inserimento,
		tipologie_telefoni.id_account_aggiornamento,
		tipologie_telefoni_path( tipologie_telefoni.id ) AS __label__
	FROM tipologie_telefoni
;

--| 090000056600

-- tipologie_todo_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_todo_view`;

--| 090000056601

-- tipologie_todo_view
-- tipologia: tabella assistita
-- verifica: 2021-10-19 13:12 Fabio Mosti
CREATE OR REPLACE VIEW `tipologie_todo_view` AS
	SELECT
		tipologie_todo.id,
		tipologie_todo.id_genitore,
		tipologie_todo.ordine,
		tipologie_todo.nome,
		tipologie_todo.html_entity,
		tipologie_todo.font_awesome,
		tipologie_todo.id_account_inserimento,
		tipologie_todo.id_account_aggiornamento,
		tipologie_todo_path( tipologie_todo.id ) AS __label__
	FROM tipologie_todo
;

--| 090000056800

-- tipologie_url_view
-- tipologia: tabella assistita
DROP TABLE IF EXISTS `tipologie_url_view`;

--| 090000056801

-- tipologie_url_view
-- tipologia: tabella assistita
-- verifica: 2021-11-09 12:45 Chiara GDL
CREATE OR REPLACE VIEW `tipologie_url_view` AS
	SELECT
		tipologie_url.id,
		tipologie_url.id_genitore,
		tipologie_url.ordine,
		tipologie_url.nome,
		tipologie_url.html_entity,
		tipologie_url.font_awesome,
		tipologie_url.id_account_inserimento,
		tipologie_url.id_account_aggiornamento,
		tipologie_url_path( tipologie_url.id ) AS __label__
	FROM tipologie_url
;

--| 090000060000

-- todo_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `todo_view`;

--| 090000060001

-- todo_view
-- tipologia: tabella gestita
-- verifica: 2021-10-19 13:12 Fabio Mosti
CREATE OR REPLACE VIEW `todo_view` AS
	SELECT
		todo.id,
		todo.id_tipologia,
		tipologie_todo.nome AS tipologia,
		todo.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		todo.id_cliente,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		todo.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		todo.id_luogo,
		luoghi_path( todo.id_luogo ) AS luogo,
		todo.data_scadenza,
		todo.ora_scadenza,
		todo.data_programmazione,
		todo.ora_inizio_programmazione,
		todo.ora_fine_programmazione,
		todo.anno_programmazione,
		todo.settimana_programmazione,
		todo.ore_programmazione,
		todo.data_chiusura,
		todo.nome,
		todo.id_contatto,
		todo.id_progetto,
		todo.id_pianificazione,
		todo.data_archiviazione,
		todo.id_account_inserimento,
		todo.id_account_aggiornamento,
		concat(
			todo.nome,
			' per ',
			coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ),
			' su ',
			todo.id_progetto
		) AS __label__
	FROM todo
		LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente
		LEFT JOIN indirizzi ON indirizzi.id = todo.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
;

--| 090000062000

-- udm_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `udm_view`;

--| 090000062001

-- udm_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-19 13:12 Fabio Mosti
CREATE OR REPLACE VIEW udm_view AS
	SELECT
		udm.id,
		coalesce( udm.id_base, udm.id ) AS id_base,
		coalesce( udm.conversione, 1 ) AS conversione,
		udm.nome,
		udm.sigla,
		udm.se_lunghezza,
		udm.se_volume,
		udm.se_massa,
		udm.se_tempo,
		udm.se_quantita,
		udm.se_area,
		udm.sigla AS __label__
	FROM udm
;

--| 090000062600

-- url_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `url_view`;

--| 090000062601

-- url_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-19 13:12 Fabio Mosti
CREATE OR REPLACE VIEW url_view AS
	SELECT
		url.id,
		url.id_tipologia,
		tipologie_url.nome AS tipologia,
		url.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		url.url,
		url.nome,
		url.id_account_inserimento,
		url.id_account_aggiornamento,
		concat_ws(
			' ',
			url.url,
			tipologie_url.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM url
		LEFT JOIN anagrafica AS a1 ON a1.id = url.id_anagrafica
		LEFT JOIN tipologie_url ON tipologie_url.id = url.id_tipologia
;

--| 090000062900

-- valutazioni_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `valutazioni_view`;

--| 090000062901

-- valutazioni_view
-- tipologia: tabella gestita
-- verifica: 2022-04-28 Chiara GDL
CREATE OR REPLACE VIEW valutazioni_view AS
	SELECT
		valutazioni.id,
		valutazioni.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		valutazioni.id_matricola,
		matricole.matricola AS matricola,
		valutazioni.id_immobile,
		immobili.nome AS immobile,
		valutazioni.mq_commerciali,
		valutazioni.mq_calpestabili,
		valutazioni.id_condizione,
		condizioni.nome AS condizione,
		valutazioni.id_disponibilita,
		disponibilita.nome AS disponibilita,
		valutazioni.id_classe_energetica,
		classi_energetiche.nome AS classe_energetica,
		valutazioni.timestamp_valutazione,
		valutazioni.id_account_inserimento,
		valutazioni.id_account_aggiornamento,
		concat('valutazione ', immobili.nome) AS __label__
	FROM valutazioni
		LEFT JOIN anagrafica ON anagrafica.id = valutazioni.id_anagrafica
		LEFT JOIN matricole ON matricole.id = valutazioni.id_matricola
		LEFT JOIN immobili ON immobili.id = valutazioni.id_immobile
		LEFT JOIN condizioni ON condizioni.id = valutazioni.id_condizione
		LEFT JOIN disponibilita ON disponibilita.id = valutazioni.id_disponibilita
		LEFT JOIN classi_energetiche ON classi_energetiche.id = valutazioni.id_classe_energetica;
		
--| 090000063000

-- valute_view
-- tipologia: tabella di supporto
DROP TABLE IF EXISTS `valute_view`;

--| 090000063001

-- valute_view
-- tipologia: tabella di supporto
-- verifica: 2021-10-19 13:22 Fabio Mosti
CREATE OR REPLACE VIEW valute_view AS
	SELECT
		valute.id,
		valute.iso4217,
		valute.html_entity,
		valute.utf8,
		valute.iso4217 AS __label__
	FROM valute
;

--| 090000065000

-- video_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `video_view`;

--| 090000065001

-- video_view
-- tipologia: tabella gestita
-- verifica: 2021-09-22 12:45 Fabio Mosti
CREATE OR REPLACE VIEW `video_view` AS
	SELECT
		video.id,
		video.id_anagrafica,
		video.id_pagina,
		video.id_file,
		video.id_prodotto,
		video.id_articolo,
		video.id_categoria_prodotti,
		video.id_risorsa,
		video.id_categoria_risorse,
		video.id_notizia,
		video.id_categoria_notizie,
		video.id_lingua,
		lingue.nome AS lingua,
		video.id_ruolo,
		video.id_progetto,
		video.id_categoria_progetti,
		video.id_indirizzo,
		video.id_edificio,
		video.id_immobile,
		ruoli_video.nome AS ruolo,
		video.ordine,
		video.nome,
		video.path,
		video.id_embed,
		video.codice_embed,
		video.embed_custom,
		video.target,
		video.orientamento,
		video.ratio,
		video.id_account_inserimento,
		video.id_account_aggiornamento,
		concat(
			ruoli_video.nome,
			' # ',
			video.ordine,
			' / ',
			video.nome,
			' / ',
			video.path
		) AS __label__
	FROM video
		LEFT JOIN lingue ON lingue.id = video.id_lingua
		LEFT JOIN ruoli_video ON ruoli_video.id = video.id_ruolo
;

--| FINE FILE
