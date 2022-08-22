--
-- PATCH
--

--| 202208223005
ALTER TABLE `mastri`
    ADD COLUMN  `id_anagrafica` int(11) DEFAULT NULL AFTER `id_anagrafica_indirizzi`, 
    ADD COLUMN  `id_account` int(11) DEFAULT NULL AFTER `id_anagrafica`, 
    ADD KEY `id_anagrafica` (`id_anagrafica`),
    ADD KEY `id_account` (`id_account`),
    ADD CONSTRAINT `mastri_ibfk_04_nofollow`    FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mastri_ibfk_05_nofollow`    FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202208223007
CREATE OR REPLACE VIEW `mastri_view` AS
	SELECT
		mastri.id,
		mastri.id_tipologia,
		tipologie_mastri.nome AS tipologia,
		mastri.id_anagrafica_indirizzi,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzi.indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		coalesce( mastri.id_anagrafica, anagrafica_indirizzi.id_anagrafica ) AS id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS anagrafica,
		mastri.id_account,
		account.username AS account,
		mastri.nome,
		tipologie_mastri.se_magazzino,
		tipologie_mastri.se_conto,
		tipologie_mastri.se_registro,
		mastri_path( mastri.id ) AS __label__
	FROM mastri
		LEFT JOIN tipologie_mastri ON tipologie_mastri.id = mastri.id_tipologia
		LEFT JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id = mastri.id_anagrafica_indirizzi
		LEFT JOIN anagrafica AS a1 ON a1.id = anagrafica_indirizzi.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = mastri.id_anagrafica
		LEFT JOIN account ON account.id = mastri.id_account
		LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

--| 202208223010
CREATE OR REPLACE VIEW `prezzi_view` AS
	SELECT
		prezzi.id,
		prezzi.id_prodotto,
		prezzi.id_articolo,
		prezzi.prezzo,
		prezzi.id_listino,
		listini.nome AS listino,
		valute.iso4217 AS iso4217,
		valute.utf8 AS utf8,
		prezzi.id_iva,
		iva.descrizione AS iva,
		iva.aliquota AS aliquota,
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

--| 202208223020 
CREATE OR REPLACE VIEW `__report_movimenti_crediti__` AS
SELECT
  id,
  nome,
  articolo,
  id_articolo,
  data,
  id_tipologia,
  tipologia,
  documento,
  numero,
  id_riga,
  id_crediti,
  carico,
  scarico
FROM (
SELECT
  mastri.id,
  mastri.nome,
  concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			' ',
			articoli.nome
  ) AS articolo,
  articoli.id AS id_articolo,
  crediti.data,
  documenti.id_tipologia,
  tipologie_documenti.sigla AS tipologia,
  documenti.nome AS documento,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  documenti_articoli.id AS id_riga,
  crediti.id AS id_crediti,
  coalesce( crediti.quantita, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_destinazione = mastri.id OR mastri_path_check( crediti.id_mastro_destinazione, mastri.id ) = 1
  LEFT JOIN documenti_articoli ON documenti_articoli.id = crediti.id_documenti_articolo
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  WHERE crediti.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			' ',
			articoli.nome
  ) AS articolo,
  articoli.id AS id_articolo,
  crediti.data,
  documenti.id_tipologia,
  tipologie_documenti.sigla AS tipologia,
  documenti.nome AS documento,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  documenti_articoli.id AS id_riga,
  crediti.id AS id_crediti,
  0 AS carico,
  coalesce( crediti.quantita, 0 ) AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_provenienza = mastri.id OR mastri_path_check( crediti.id_mastro_provenienza, mastri.id ) = 1
  LEFT JOIN documenti_articoli ON documenti_articoli.id = crediti.id_documenti_articolo
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  WHERE crediti.quantita IS NOT NULL
) AS movimenti;

--| 202208223030
CREATE OR REPLACE VIEW `crediti_view` AS
    SELECT
		crediti.id,
		crediti.id_documenti_articolo,
        concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' ',
			documenti_articoli.id_articolo
		) AS riga_documento,
		crediti.data,
		crediti.id_account_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS account_emittente,
		crediti.id_account_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS account_destinatario,
		crediti.id_mastro_provenienza,
		mastri_path( m1.id ) AS mastro_provenienza,
		crediti.id_mastro_destinazione,
		mastri_path( m2.id ) AS mastro_destinazione,
		crediti.quantita,
		crediti.id_pianificazione,
		crediti.nome,
		crediti.id_account_inserimento,
		crediti.id_account_aggiornamento,
		concat(
			crediti.data,
			' / ',
			tipologie_documenti.sigla,
			' / ',
			crediti.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			crediti.nome
		) AS __label__
	FROM
		crediti
		LEFT JOIN documenti_articoli ON documenti_articoli.id = crediti.id_documenti_articolo
        LEFT JOIN mastri AS m1 ON m1.id = crediti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = crediti.id_mastro_destinazione
		LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
        LEFT JOIN account AS acc1 ON acc1.id = m1.id_account
		LEFT JOIN anagrafica AS a1 ON a1.id = acc1.id_anagrafica
		LEFT JOIN account AS acc2 ON acc2.id = m2.id_account
		LEFT JOIN anagrafica AS a2 ON a2.id = acc2.id_anagrafica
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
;

--| 202208223040
CREATE OR REPLACE VIEW `__report_giacenza_crediti__` AS
SELECT
  concat_ws( '|', movimenti.id, movimenti.id_articolo ) AS id,
  movimenti.id_mastro,
  movimenti.id_account,
  movimenti.nome,
  movimenti.id_articolo,
  movimenti.articolo,
  movimenti.id_prodotto,
  movimenti.prodotto,
  group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ) AS categorie,
  sum( movimenti.carico ) AS carico,
  sum( movimenti.scarico ) AS scarico,
  FORMAT(coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2,'es_ES') AS totale,
 concat_ws(
			' ',
      group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR ' | ' ),
			movimenti.articolo,
      'da',
      movimenti.nome,
      'giacenza',
      FORMAT(coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2,'es_ES'),
      'pz'
		) AS __label__
FROM (
SELECT
  mastri.id,
  mastri.id AS id_mastro,
  mastri.id_account,
  mastri_path( mastri.id ) AS nome,
  documenti_articoli.id AS id_articolo,
  concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			' ',
			articoli.nome
		) AS articolo,
articoli.id_prodotto AS id_prodotto,
prodotti.nome AS prodotto,
  crediti.data,
  documenti.id_tipologia,
  tipologie_documenti.nome AS tipologia,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  documenti_articoli.id AS id_riga,
  coalesce( crediti.quantita, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_destinazione = mastri.id OR mastri_path_check( crediti.id_mastro_destinazione, mastri.id ) = 1
  LEFT JOIN documenti_articoli ON documenti_articoli.id = crediti.id_documenti_articolo
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia

LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = articoli.id_prodotto
  WHERE crediti.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.id AS id_mastro,
  mastri.id_account,
  mastri_path( mastri.id ) AS nome,
  documenti_articoli.id AS id_articolo,
  concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			' ',
			articoli.nome
		) AS articolo,
articoli.id_prodotto AS id_prodotto,
prodotti.nome AS prodotto,
  crediti.data,
  documenti.id_tipologia,
  tipologie_documenti.nome AS tipologia,
  concat( documenti.numero, '/', documenti.sezionale ) AS numero,
  documenti_articoli.id AS id_riga,
  0 AS carico,
  coalesce( crediti.quantita, 0 ) AS scarico
FROM mastri
LEFT JOIN crediti ON crediti.id_mastro_provenienza = mastri.id OR mastri_path_check( crediti.id_mastro_provenienza, mastri.id ) = 1
  LEFT JOIN documenti_articoli ON documenti_articoli.id = crediti.id_documenti_articolo
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
  LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = articoli.id_prodotto
  WHERE crediti.quantita IS NOT NULL
) AS movimenti
LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = movimenti.id_prodotto
GROUP BY movimenti.id, movimenti.id_mastro, movimenti.id_account, movimenti.nome, movimenti.id_articolo, movimenti.articolo, movimenti.id_prodotto, movimenti.prodotto;

--| 202208223050
ALTER TABLE `carrelli`
DROP CONSTRAINT `carrelli_ibfk_08_nofollow`;

--| 202208223060
ALTER TABLE `carrelli`
DROP FOREIGN KEY  `carrelli_ibfk_08_nofollow`;

--| 202208223070
ALTER TABLE `carrelli`
    DROP KEY `id_documento`,
    DROP COLUMN `id_documento`,
    ADD `fatturazione_id_tipologia_documento` INT(11) NULL DEFAULT NULL AFTER `id_listino`,
    ADD `fatturazione_sezionale` CHAR(16) NULL DEFAULT NULL AFTER `fatturazione_id_tipologia_documento`,
    ADD `fatturazione_strategia` enum('SINGOLA','MULTIPLA') NULL DEFAULT NULL AFTER `fatturazione_sezionale`,
    ADD `destinatario_id_tipologia_anagrafica` INT(11) NULL DEFAULT NULL AFTER `destinatario_denominazione`,
    ADD `intestazione_id_tipologia_anagrafica` INT(11) NULL DEFAULT NULL AFTER `intestazione_denominazione`,
	ADD KEY `destinatario_id_tipologia_anagrafica` (`destinatario_id_tipologia_anagrafica`),
	ADD KEY `intestazione_id_tipologia_anagrafica` (`intestazione_id_tipologia_anagrafica`),
	ADD KEY `fatturazione_id_tipologia_documento` (`fatturazione_id_tipologia_documento`),
	ADD CONSTRAINT `carrelli_ibfk_15_nofollow` FOREIGN KEY (`destinatario_id_tipologia_anagrafica`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `carrelli_ibfk_14_nofollow` FOREIGN KEY (`intestazione_id_tipologia_anagrafica`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `carrelli_ibfk_13_nofollow` FOREIGN KEY (`fatturazione_id_tipologia_documento`) REFERENCES `tipologie_documenti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202208223080
CREATE OR REPLACE VIEW carrelli_view AS
	SELECT
	carrelli.id,
	carrelli.session,
	carrelli.destinatario_nome,
	carrelli.destinatario_cognome,
	carrelli.destinatario_denominazione,
    carrelli.destinatario_id_tipologia_anagrafica,
	carrelli.destinatario_id_anagrafica,
	carrelli.destinatario_id_account,
	carrelli.destinatario_indirizzo,
	carrelli.destinatario_cap,
	carrelli.destinatario_citta,
	carrelli.destinatario_id_provincia,
	carrelli.destinatario_id_stato,
	carrelli.destinatario_telefono,
	carrelli.destinatario_mail,
	carrelli.destinatario_codice_fiscale,
	carrelli.destinatario_partita_iva,
	carrelli.intestazione_nome,
	carrelli.intestazione_cognome,
	carrelli.intestazione_denominazione,
    carrelli.intestazione_id_tipologia_anagrafica,
	carrelli.intestazione_id_anagrafica,
	carrelli.intestazione_id_account,
	carrelli.intestazione_indirizzo,
	carrelli.intestazione_cap,
	carrelli.intestazione_citta,
	carrelli.intestazione_id_provincia,
	carrelli.intestazione_id_stato,
	carrelli.intestazione_telefono,
	carrelli.intestazione_mail,
	carrelli.intestazione_codice_fiscale,
	carrelli.intestazione_partita_iva,
	carrelli.intestazione_sdi,
	carrelli.intestazione_pec,
	carrelli.id_listino,
    carrelli.fatturazione_id_tipologia_documento,
    carrelli.fatturazione_sezionale,
    carrelli.fatturazione_strategia,
	carrelli.prezzo_netto_totale,
	carrelli.prezzo_lordo_totale,
	carrelli.sconto_percentuale,
	carrelli.sconto_valore,
	carrelli.prezzo_netto_finale,
	carrelli.prezzo_lordo_finale,
	carrelli.provider_checkout,
	carrelli.timestamp_checkout,
	carrelli.provider_pagamento,
	carrelli.timestamp_pagamento,
	carrelli.codice_pagamento,
    carrelli.ordine_pagamento,
	carrelli.status_pagamento,
	carrelli.importo_pagamento,
    carrelli.utm_id,
    carrelli.utm_source,
    carrelli.utm_medium,
    carrelli.utm_campaign,
    carrelli.utm_term,
    carrelli.utm_content,
    carrelli.id_reseller,
    carrelli.id_affiliato,
	carrelli.id_account_inserimento,
	carrelli.timestamp_inserimento,
	carrelli.id_account_aggiornamento,
	carrelli.timestamp_aggiornamento
FROM carrelli;


--| FINE