-- 2026-10-03 — carrelli.id_sito entra nel canone ( decisione di Fabio ): il framework lo legge gia' ( _carrelli.view.php,
-- filtro id_sito di carrelli.view.filters.html ) ma la colonna c'era solo su gimbe, e la carrelli_view canonica della 3600
-- l'aveva persa rompendo l'elenco carrelli del CMS. Qui: colonna se manca, indice se manca, vista con id_sito.
-- id_sito sono gli id dei config.siti.*.json, non una tabella: niente chiave esterna. Un'istruzione per blocco. IDEMPOTENTE.

-- | 202610033940

SET @carrelli_sito = IF(
    EXISTS ( SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'carrelli' AND COLUMN_NAME = 'id_sito' ),
    'SELECT 1',
    'ALTER TABLE `carrelli` ADD COLUMN `id_sito` bigint(20) DEFAULT NULL AFTER `timestamp_aggiornamento`'
);

-- | 202610033941

PREPARE carrelli_sito FROM @carrelli_sito;

-- | 202610033942

EXECUTE carrelli_sito;

-- | 202610033943

DEALLOCATE PREPARE carrelli_sito;

-- | 202610033944

SET @carrelli_sito = IF(
    EXISTS ( SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'carrelli' AND COLUMN_NAME = 'id_sito' AND SEQ_IN_INDEX = 1 ),
    'SELECT 1',
    'ALTER TABLE `carrelli` ADD KEY `id_sito` (`id_sito`)'
);

-- | 202610033945

PREPARE carrelli_sito FROM @carrelli_sito;

-- | 202610033946

EXECUTE carrelli_sito;

-- | 202610033947

DEALLOCATE PREPARE carrelli_sito;

-- | 202610033948

CREATE OR REPLACE VIEW `carrelli_view` AS
	SELECT
	carrelli.id,
	carrelli.session,
	carrelli.id_sito,
	coalesce( carrelli.intestazione_nome, carrelli.destinatario_nome ) AS cliente_nome,
	coalesce( carrelli.intestazione_cognome, carrelli.destinatario_cognome ) AS cliente_cognome,
	coalesce( carrelli.intestazione_denominazione, carrelli.destinatario_denominazione ) AS cliente_denominazione,
    coalesce( carrelli.intestazione_mail, carrelli.destinatario_mail ) AS cliente_mail,
    coalesce( carrelli.intestazione_mobile, carrelli.destinatario_mobile ) AS cliente_mobile,
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
	carrelli.destinatario_id_comune_nascita,
	carrelli.destinatario_giorno_nascita,
	carrelli.destinatario_mese_nascita,
	carrelli.destinatario_anno_nascita,
	carrelli.destinatario_id_provincia_nascita,
	carrelli.destinatario_id_stato_nascita,
	carrelli.destinatario_telefono,
	carrelli.destinatario_mobile,
	carrelli.destinatario_fax,
	carrelli.destinatario_mail,
	carrelli.destinatario_codice_fiscale,
	carrelli.destinatario_partita_iva,
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
	carrelli.intestazione_id_provincia,
	carrelli.intestazione_id_stato,
	carrelli.intestazione_id_comune_nascita,
	carrelli.intestazione_giorno_nascita,
	carrelli.intestazione_mese_nascita,
	carrelli.intestazione_anno_nascita,
	carrelli.intestazione_id_provincia_nascita,
	carrelli.intestazione_id_stato_nascita,
	carrelli.intestazione_telefono,
	carrelli.intestazione_mobile,
	carrelli.intestazione_fax,
	carrelli.intestazione_mail,
	carrelli.intestazione_codice_fiscale,
	carrelli.intestazione_partita_iva,
	carrelli.intestazione_sdi,
	carrelli.intestazione_pec,
	coalesce( concat( carrelli.intestazione_nome, ' ', carrelli.intestazione_cognome ), carrelli.intestazione_denominazione ) AS intestazione,
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
	from_unixtime( carrelli.timestamp_inserimento, '%Y-%m-%d %H:%i' ) AS data_ora_inserimento,
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
	from_unixtime( carrelli.timestamp_evasione, '%Y-%m-%d %H:%i' ) AS data_ora_evasione,
    carrelli.utm_id,
    carrelli.utm_source,
    carrelli.utm_medium,
    carrelli.utm_campaign,
    carrelli.utm_term,
    carrelli.utm_content,
	carrelli.id_campagna,
	carrelli.spam_score,
	carrelli.spam_check,
    carrelli.id_reseller,
    carrelli.id_affiliato,
	carrelli.id_affiliazione,
	carrelli.id_account_evasione,
	carrelli.timestamp_evasione,
	carrelli.id_account_inserimento,
	carrelli.timestamp_inserimento,
	carrelli.id_account_aggiornamento,
	carrelli.timestamp_aggiornamento,
	carrelli.id AS __label__
FROM carrelli;

-- | FINE
