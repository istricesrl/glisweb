-- 2026-11-11 — carrelli: la forma canonica, la parte che non tocca dati ne' FK
--
-- Schema canonico, punto 6, riga 243, decisione di Fabio del 11/11/2026 ( opzione A, nome a char(255) ): carrelli resta
-- con tutte le colonne, compresi reseller, affiliato e affiliazione ( servono ad attribuire le commissioni ).
--
-- Cosa fa: nome a char(255), giorno e mese di nascita a int(2) e anno a int(4) ( come carrelli_articoli ), le KEY delle
-- chiavi geografiche che mancavano, la KEY indice rifatta, la vista con tutte le colonne.
--
-- Cosa NON fa ( punto 12 ): il riordino delle colonne, il DROP di id_documento con carrelli_ibfk_16_nofollow, il
-- DROP / ADD delle FK rinumerate e delle FK geografiche nuove, le colonne fuori canone di gimbe e polmasi.
--
-- IDEMPOTENTE.

-- | 202611111800

-- carrelli: tipi
ALTER TABLE `carrelli`
	MODIFY `nome` char(255) DEFAULT NULL,
	MODIFY `destinatario_giorno_nascita` int(2) DEFAULT NULL,
	MODIFY `destinatario_mese_nascita` int(2) DEFAULT NULL,
	MODIFY `destinatario_anno_nascita` int(4) DEFAULT NULL,
	MODIFY `intestazione_giorno_nascita` int(2) DEFAULT NULL,
	MODIFY `intestazione_mese_nascita` int(2) DEFAULT NULL,
	MODIFY `intestazione_anno_nascita` int(4) DEFAULT NULL;

-- | 202611111801

-- carrelli: indici
ALTER TABLE `carrelli`
	DROP INDEX IF EXISTS `destinatario_id_comune`,
	DROP INDEX IF EXISTS `destinatario_id_comune_nascita`,
	DROP INDEX IF EXISTS `destinatario_id_provincia_nascita`,
	DROP INDEX IF EXISTS `destinatario_id_stato_nascita`,
	DROP INDEX IF EXISTS `intestazione_id_comune_nascita`,
	DROP INDEX IF EXISTS `intestazione_id_provincia_nascita`,
	DROP INDEX IF EXISTS `intestazione_id_stato_nascita`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `destinatario_id_comune` (`destinatario_id_comune`),
	ADD KEY `destinatario_id_comune_nascita` (`destinatario_id_comune_nascita`),
	ADD KEY `destinatario_id_provincia_nascita` (`destinatario_id_provincia_nascita`),
	ADD KEY `destinatario_id_stato_nascita` (`destinatario_id_stato_nascita`),
	ADD KEY `intestazione_id_comune_nascita` (`intestazione_id_comune_nascita`),
	ADD KEY `intestazione_id_provincia_nascita` (`intestazione_id_provincia_nascita`),
	ADD KEY `intestazione_id_stato_nascita` (`intestazione_id_stato_nascita`),
	ADD KEY `indice` (`id`,`codice`,`id_sito`,`id_listino`,`intestazione_id_anagrafica`,`destinatario_id_anagrafica`,`prezzo_lordo_finale`,`provider_checkout`,`timestamp_checkout`,`provider_pagamento`,`timestamp_pagamento`,`status_pagamento`,`timestamp_evasione`);

-- | 202611111802

-- carrelli_view
-- tipologia: tabella gestita
-- verifica: 2026-11-11 punto 6, riga 243
CREATE OR REPLACE VIEW `carrelli_view` AS
	SELECT
		carrelli.id,
		carrelli.codice,
		carrelli.nome,
		carrelli.id_sito,
		coalesce( carrelli.intestazione_nome, carrelli.destinatario_nome ) AS cliente_nome,
		coalesce( carrelli.intestazione_cognome, carrelli.destinatario_cognome ) AS cliente_cognome,
		coalesce( carrelli.intestazione_denominazione, carrelli.destinatario_denominazione ) AS cliente_denominazione,
		coalesce( carrelli.intestazione_mail, carrelli.destinatario_mail ) AS cliente_mail,
		coalesce( carrelli.intestazione_mobile, carrelli.destinatario_mobile ) AS cliente_mobile,
		carrelli.id_listino,
		carrelli.id_zona,
		carrelli.id_campagna,
		carrelli.id_reseller,
		carrelli.id_affiliato,
		carrelli.id_affiliazione,
		carrelli.session,
		carrelli.fatturazione_id_tipologia_documento,
		carrelli.fatturazione_sezionale,
		carrelli.fatturazione_strategia,
		carrelli.prezzo_netto_totale,
		carrelli.prezzo_lordo_totale,
		carrelli.costo_spedizione_netto,
		carrelli.costo_spedizione_lordo,
		carrelli.sconto_percentuale,
		carrelli.sconto_valore,
		carrelli.id_coupon,
		carrelli.codice_coupon,
		carrelli.sconto_percentuale_coupon,
		carrelli.sconto_valore_coupon,
		carrelli.prezzo_netto_finale,
		carrelli.prezzo_lordo_finale,
		carrelli.provider_checkout,
		carrelli.timestamp_checkout,
		from_unixtime( carrelli.timestamp_checkout, '%Y-%m-%d %H:%i' ) AS data_ora_checkout,
		carrelli.provider_pagamento,
		carrelli.timestamp_pagamento,
		from_unixtime( carrelli.timestamp_pagamento, '%Y-%m-%d %H:%i' ) AS data_ora_pagamento,
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
		carrelli.spam_score,
		carrelli.spam_check,
		carrelli.destinatario_nome,
		carrelli.destinatario_cognome,
		carrelli.destinatario_denominazione,
		carrelli.destinatario_id_tipologia_anagrafica,
		carrelli.destinatario_id_anagrafica,
		carrelli.destinatario_id_account,
		carrelli.destinatario_indirizzo,
		carrelli.destinatario_cap,
		carrelli.destinatario_citta,
		carrelli.destinatario_id_comune,
		carrelli.destinatario_id_provincia,
		carrelli.destinatario_id_stato,
		carrelli.destinatario_telefono,
		carrelli.destinatario_mobile,
		carrelli.destinatario_fax,
		carrelli.destinatario_mail,
		carrelli.destinatario_codice_fiscale,
		carrelli.destinatario_partita_iva,
		carrelli.destinatario_id_comune_nascita,
		carrelli.destinatario_id_provincia_nascita,
		carrelli.destinatario_id_stato_nascita,
		carrelli.destinatario_giorno_nascita,
		carrelli.destinatario_mese_nascita,
		carrelli.destinatario_anno_nascita,
		coalesce( concat( carrelli.destinatario_nome, ' ', carrelli.destinatario_cognome ), carrelli.destinatario_denominazione ) AS destinatario,
		carrelli.intestazione_nome,
		carrelli.intestazione_cognome,
		carrelli.intestazione_denominazione,
		carrelli.intestazione_id_tipologia_anagrafica,
		carrelli.intestazione_id_anagrafica,
		carrelli.intestazione_id_account,
		carrelli.intestazione_indirizzo,
		carrelli.intestazione_cap,
		carrelli.intestazione_citta,
		carrelli.intestazione_id_comune,
		carrelli.intestazione_id_provincia,
		carrelli.intestazione_id_stato,
		carrelli.intestazione_telefono,
		carrelli.intestazione_mobile,
		carrelli.intestazione_fax,
		carrelli.intestazione_mail,
		carrelli.intestazione_codice_fiscale,
		carrelli.intestazione_partita_iva,
		carrelli.intestazione_sdi,
		carrelli.intestazione_pec,
		carrelli.intestazione_id_comune_nascita,
		carrelli.intestazione_id_provincia_nascita,
		carrelli.intestazione_id_stato_nascita,
		carrelli.intestazione_giorno_nascita,
		carrelli.intestazione_mese_nascita,
		carrelli.intestazione_anno_nascita,
		coalesce( concat( carrelli.intestazione_nome, ' ', carrelli.intestazione_cognome ), carrelli.intestazione_denominazione ) AS intestazione,
		carrelli.id_account_evasione,
		carrelli.timestamp_evasione,
		from_unixtime( carrelli.timestamp_evasione, '%Y-%m-%d %H:%i' ) AS data_ora_evasione,
		carrelli.note_evasione,
		carrelli.id_account_inserimento,
		carrelli.timestamp_inserimento,
		from_unixtime( carrelli.timestamp_inserimento, '%Y-%m-%d %H:%i' ) AS data_ora_inserimento,
		carrelli.id_account_aggiornamento,
		carrelli.timestamp_aggiornamento,
		from_unixtime( carrelli.timestamp_aggiornamento, '%Y-%m-%d %H:%i' ) AS data_ora_aggiornamento,
		carrelli.id AS __label__
	FROM carrelli;

-- | FINE
