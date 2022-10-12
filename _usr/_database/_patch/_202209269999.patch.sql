--
-- PATCH
--

--| 202209260010
ALTER TABLE `tipologie_contratti` DROP KEY `indice`;

--| 202209260020
ALTER TABLE `tipologie_contratti`
    ADD COLUMN `se_affiliazione` int(1) DEFAULT NULL AFTER `se_scalare`, 
    ADD KEY `se_affiliazione` (`se_affiliazione`),
	ADD KEY `indice` (`id`,`ordine`,`nome`,`html_entity`,`font_awesome`, `se_iscrizione`, `se_tesseramento`, `se_abbonamento`, `se_immobili`, `se_acquisto`, `se_locazione`, `se_affiliazione`);

--| 202209260030
INSERT INTO `tipologie_contratti` (`id`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_tesseramento`, `se_abbonamento`, `se_iscrizione`, `se_affiliazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
	(6,	NULL,	'affiliazione',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

--| 202209260040
CREATE OR REPLACE VIEW `tipologie_contratti_view` AS
	SELECT
		tipologie_contratti.id,
		tipologie_contratti.id_genitore,
		tipologie_contratti.ordine,
		tipologie_contratti.nome,
		tipologie_contratti.html_entity,
		tipologie_contratti.font_awesome,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		tipologie_contratti.se_libero,
		tipologie_contratti.se_prenotazione,
		tipologie_contratti.se_scalare,
		tipologie_contratti.se_affiliazione,
		tipologie_contratti.id_account_inserimento,
		tipologie_contratti.id_account_aggiornamento,
		tipologie_contratti_path( tipologie_contratti.id ) AS __label__
	FROM tipologie_contratti
;

--| 202209260050
ALTER TABLE `contratti` DROP KEY `indice`;

--| 202209260060
ALTER TABLE `contratti`
    ADD COLUMN `codice_affiliazione` char(32) DEFAULT NULL AFTER `codice`, 
    ADD KEY  `codice_affiliazione` ( `codice_affiliazione` ),
	ADD KEY `indice` ( `id_tipologia`, `codice`, `codice_affiliazione`, `nome`, `id_progetto`, `id_immobile`);

--| 202209260070
CREATE OR REPLACE VIEW `contratti_view` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.id_immobile,
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
		) AS immobile,
		contratti.codice,
		contratti.codice_affiliazione,
		contratti.nome,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
        MIN(rinnovi.data_inizio) AS data_inizio,
        MAX(rinnovi.data_fine) AS data_fine,
		group_concat( DISTINCT coalesce( proponente.denominazione , concat( proponente.cognome, ' ', proponente.nome ), '' )  SEPARATOR ', ' ) AS proponenti,
		group_concat( DISTINCT coalesce( contraente.denominazione , concat( contraente.cognome, ' ', contraente.nome ), '' )  SEPARATOR ', ' ) AS contraenti,
		concat( contratti.nome , ' - ', tipologie_contratti.nome )AS __label__
	FROM contratti
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN immobili ON immobili.id = contratti.id_immobile
		LEFT JOIN tipologie_immobili ON tipologie_immobili.id = immobili.id_tipologia
		LEFT JOIN edifici ON edifici.id = immobili.id_edificio
		LEFT JOIN tipologie_edifici ON tipologie_edifici.id = edifici.id_tipologia
		LEFT JOIN indirizzi ON indirizzi.id = edifici.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN zone_indirizzi ON zone_indirizzi.id_indirizzo = indirizzi.id 
		LEFT JOIN zone ON zone.id = zone_indirizzi.id_zona
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 27
		LEFT JOIN anagrafica AS proponente ON proponente.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo = 28
		LEFT JOIN anagrafica AS contraente ON contraente.id = c_a.id_anagrafica
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
	GROUP BY contratti.id, contratti_anagrafica.id_contratto, tipologie_contratti.nome
;

--| 202209260080
ALTER TABLE `account` DROP KEY `indice`;

--| 202209260090
ALTER TABLE `account`
    ADD COLUMN `id_affiliazione` int(11) DEFAULT NULL AFTER `id_mail`, 
    ADD KEY `id_affiliazione` (`id_affiliazione`),
	ADD KEY `indice` (`id`, `id_anagrafica`, `username`, `id_mail`, `id_affiliazione`, `password`, `se_attivo`, `token`),
	ADD CONSTRAINT `account_ibfk_03_nofollow` FOREIGN KEY (`id_affiliazione`) REFERENCES `contratti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202209260100
CREATE OR REPLACE DEFINER = CURRENT_USER() VIEW account_view AS
	SELECT
		account.id,
		account.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), NULL ) AS anagrafica,
		account.id_mail,
		mail.indirizzo AS mail,
		account.id_affiliazione,
		contratti.codice_affiliazione,
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
		LEFT JOIN contratti ON contratti.id = account.id_affiliazione
		LEFT JOIN account_gruppi ON account_gruppi.id_account = account.id
		LEFT JOIN account_gruppi_attribuzione ON account_gruppi_attribuzione.id_account = account.id
		LEFT JOIN gruppi ON gruppi.id = account_gruppi.id_gruppo
	GROUP BY account.id
;

--| 202209260110
ALTER TABLE `carrelli`
    ADD COLUMN `id_affiliazione` int(11) DEFAULT NULL AFTER `id_affiliato`, 
    ADD KEY `id_affiliazione` (`id_affiliazione`),
	ADD CONSTRAINT `carrelli_ibfk_16_nofollow` FOREIGN KEY (`id_affiliazione`) REFERENCES `contratti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202209260130
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
	carrelli.id_affiliazione,
	carrelli.id_account_inserimento,
	carrelli.timestamp_inserimento,
	carrelli.id_account_aggiornamento,
	carrelli.timestamp_aggiornamento
FROM carrelli;
--| 202209260140
--| 202209260150
--| 202209260160



--| FINE