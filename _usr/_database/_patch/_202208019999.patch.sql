--
-- PATCH
--

--| 202208010010
ALTER TABLE `carrelli` 
ADD `ordine_pagamento` CHAR(128) NULL DEFAULT NULL AFTER `codice_pagamento`,
ADD `utm_id` CHAR(128) NULL DEFAULT NULL AFTER `importo_pagamento`,
ADD `utm_source` CHAR(128) NULL DEFAULT NULL AFTER `utm_id`,
ADD `utm_medium` CHAR(128) NULL DEFAULT NULL AFTER `utm_source`,
ADD `utm_campaign` CHAR(128) NULL DEFAULT NULL AFTER `utm_medium`,
ADD `utm_term` CHAR(128) NULL DEFAULT NULL AFTER `utm_campaign`,
ADD `utm_content` CHAR(128) NULL DEFAULT NULL AFTER `utm_term`,
ADD `id_reseller` int(11) NULL DEFAULT NULL AFTER `utm_content`,
ADD `id_affiliato` int(11) NULL DEFAULT NULL AFTER `id_reseller`,
ADD `id_documento` int(11) NULL DEFAULT NULL AFTER `id_listino`,
ADD KEY `ordine_pagamento` ( `ordine_pagamento` ),
ADD KEY `utm_id` ( `utm_id` ),
ADD KEY `utm_source` ( `utm_source` ),
ADD KEY `utm_medium` ( `utm_medium` ),
ADD KEY `utm_campaign` ( `utm_campaign` ),
ADD KEY `utm_term` ( `utm_term` ),
ADD KEY `utm_content` ( `utm_content` ),
ADD KEY `id_documento` ( `id_documento` ),
ADD KEY `id_reseller` ( `id_reseller` ),
ADD KEY `id_affiliato` ( `id_affiliato` ),
ADD CONSTRAINT `carrelli_ibfk_08_nofollow`          FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `carrelli_ibfk_09_nofollow`          FOREIGN KEY (`id_reseller`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `carrelli_ibfk_10_nofollow`          FOREIGN KEY (`id_affiliato`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202208010020
ALTER TABLE `contatti` 
ADD `utm_id` CHAR(128) NULL DEFAULT NULL AFTER `id_ranking`,
ADD `utm_source` CHAR(128) NULL DEFAULT NULL AFTER `utm_id`,
ADD `utm_medium` CHAR(128) NULL DEFAULT NULL AFTER `utm_source`,
ADD `utm_campaign` CHAR(128) NULL DEFAULT NULL AFTER `utm_medium`,
ADD `utm_term` CHAR(128) NULL DEFAULT NULL AFTER `utm_campaign`,
ADD `utm_content` CHAR(128) NULL DEFAULT NULL AFTER `utm_term`,
ADD KEY `utm_id` ( `utm_id` ),
ADD KEY `utm_source` ( `utm_source` ),
ADD KEY `utm_medium` ( `utm_medium` ),
ADD KEY `utm_campaign` ( `utm_campaign` ),
ADD KEY `utm_term` ( `utm_term` ),
ADD KEY `utm_content` ( `utm_content` );

--| 202208010030
CREATE OR REPLACE VIEW contatti_view AS
	SELECT
		contatti.id,
		contatti.id_tipologia,
		tipologie_contatti.nome AS tipologia,
		contatti.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		contatti.id_inviante,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS inviante,
		contatti.id_ranking,
		ranking.nome AS ranking,
        contatti.utm_id,
        contatti.utm_source,
        contatti.utm_medium,
        contatti.utm_campaign,
        contatti.utm_term,
        contatti.utm_content,
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
		LEFT JOIN ranking ON ranking.id = contatti.id_ranking
;

--| 202208010040
CREATE OR REPLACE VIEW carrelli_view AS
	SELECT
	carrelli.id,
	carrelli.session,
	carrelli.destinatario_nome,
	carrelli.destinatario_cognome,
	carrelli.destinatario_denominazione,
	carrelli.destinatario_id_anagrafica,
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
	carrelli.intestazione_id_anagrafica,
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
    carrelli.id_documento,
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