--
-- PATCH
--

--| 202207120010
CREATE TABLE `carrelli` (
  `id` int(11) NOT NULL,
  `session` char(32) DEFAULT NULL,
  `destinatario_nome` char(255) DEFAULT NULL,
  `destinatario_cognome` char(255) DEFAULT NULL,
  `destinatario_denominazione` char(255) DEFAULT NULL,
  `destinatario_id_anagrafica` int(11) DEFAULT NULL,
  `destinatario_indirizzo` char(255) DEFAULT NULL,
  `destinatario_cap` char(16) DEFAULT NULL,
  `destinatario_citta` char(255) DEFAULT NULL,
  `destinatario_id_provincia` int(11) DEFAULT NULL,
  `destinatario_id_stato` int(11) DEFAULT NULL,
  `destinatario_telefono` char(255) DEFAULT NULL,
  `destinatario_mail` char(255) DEFAULT NULL,
  `destinatario_codice_fiscale` char(255) DEFAULT NULL,
  `destinatario_partita_iva` char(255) DEFAULT NULL,
  `intestazione_nome` char(255) DEFAULT NULL,
  `intestazione_cognome` char(255) DEFAULT NULL,
  `intestazione_denominazione` char(255) DEFAULT NULL,
  `intestazione_id_anagrafica` int(11) DEFAULT NULL,
  `intestazione_indirizzo` char(255) DEFAULT NULL,
  `intestazione_cap` char(16) DEFAULT NULL,
  `intestazione_citta` char(255) DEFAULT NULL,
  `intestazione_id_provincia` int(11) DEFAULT NULL,
  `intestazione_id_stato` int(11) DEFAULT NULL,
  `intestazione_telefono` char(255) DEFAULT NULL,
  `intestazione_mail` char(255) DEFAULT NULL,
  `intestazione_codice_fiscale` char(255) DEFAULT NULL,
  `intestazione_partita_iva` char(255) DEFAULT NULL,
  `intestazione_sdi` char(32) DEFAULT NULL,
  `intestazione_pec` char(255) DEFAULT NULL,
  `id_listino` int(11) DEFAULT NULL,
  `prezzo_netto_totale` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_totale` decimal(16,5) DEFAULT NULL,
  `sconto_percentuale` decimal(16,5) DEFAULT NULL,
  `sconto_valore` decimal(16,5) DEFAULT NULL,
  `prezzo_netto_finale` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_finale` decimal(16,5) DEFAULT NULL,
  `provider_checkout` char(128) DEFAULT NULL,
  `timestamp_checkout` int(11) DEFAULT NULL,
  `provider_pagamento` char(64) DEFAULT NULL,
  `timestamp_pagamento` int(11) DEFAULT NULL,
  `codice_pagamento` char(128) DEFAULT NULL,
  `status_pagamento` char(128) DEFAULT NULL,
  `importo_pagamento` decimal(16,5) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202207120020
ALTER TABLE `carrelli`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `session` (`session`), 
	ADD KEY `id_listino` (`id_listino`), 
	ADD KEY `intestazione_id_provincia` (`intestazione_id_provincia`), 
	ADD KEY `intestazione_id_anagrafica` (`intestazione_id_anagrafica`),
	ADD KEY `intestazione_id_stato` (`intestazione_id_stato`), 
	ADD KEY `destinatario_id_provincia` (`destinatario_id_provincia`), 
	ADD KEY `destinatario_id_stato` (`destinatario_id_stato`), 
	ADD KEY `destinatario_id_anagrafica` (`destinatario_id_anagrafica`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_listino`,`prezzo_netto_totale`,`prezzo_lordo_totale`,`sconto_percentuale`,`sconto_valore`,`prezzo_netto_finale`,`prezzo_lordo_finale`,`provider_checkout`,`timestamp_checkout`,`provider_pagamento`,`timestamp_pagamento`,`codice_pagamento`,`status_pagamento`,`importo_pagamento`,`intestazione_id_anagrafica`);
	
--| 202207120030
ALTER TABLE `carrelli`   MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202207120040
ALTER TABLE `carrelli`
ADD CONSTRAINT `carrelli_ibfk_01` FOREIGN KEY (`destinatario_id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `carrelli_ibfk_02_nofollow` FOREIGN KEY (`destinatario_id_provincia`) REFERENCES `provincie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `carrelli_ibfk_03_nofollow` FOREIGN KEY (`destinatario_id_stato`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `carrelli_ibfk_04` FOREIGN KEY (`intestazione_id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `carrelli_ibfk_05_nofollow` FOREIGN KEY (`intestazione_id_provincia`) REFERENCES `provincie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `carrelli_ibfk_06_nofollow` FOREIGN KEY (`intestazione_id_stato`) REFERENCES `stati` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `carrelli_ibfk_07_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `carrelli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `carrelli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202207120051
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
	carrelli.status_pagamento,
	carrelli.importo_pagamento,
	carrelli.id_account_inserimento,
	carrelli.timestamp_inserimento,
	carrelli.id_account_aggiornamento,
	carrelli.timestamp_aggiornamento
FROM carrelli;

--| 202207120061
CREATE TABLE `carrelli_articoli` (
  `id` int(11) NOT NULL,
  `id_carrello` int(11) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_iva` int(11) DEFAULT NULL,
  `prezzo_netto_unitario` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_unitario` decimal(16,5) DEFAULT NULL,
  `quantita` int(11) DEFAULT NULL,
  `note` text,
  `prezzo_netto_totale` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_totale` decimal(16,5) DEFAULT NULL,
  `sconto_percentuale` decimal(16,5) DEFAULT NULL,
  `sconto_valore` decimal(16,5) DEFAULT NULL,
  `prezzo_netto_finale` decimal(16,5) DEFAULT NULL,
  `prezzo_lordo_finale` decimal(16,5) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--| 202207120071
ALTER TABLE `carrelli_articoli`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_carrello` (`id_carrello`),  
  ADD KEY `id_articolo` (`id_articolo`),  
  	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	  ADD UNIQUE KEY `id_carrello_id_articolo` (`id_carrello`,`id_articolo`),
  ADD KEY `indice` (`id`, `id_carrello`, `id_articolo`, `id_iva`, `prezzo_netto_unitario`, `prezzo_lordo_unitario`,`quantita`, `prezzo_netto_totale`,  `prezzo_lordo_totale`, `sconto_percentuale`, `sconto_valore`, `prezzo_netto_finale`,  `prezzo_lordo_finale`)
  ;

--| 202207120081
ALTER TABLE `carrelli_articoli`  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202207120091
ALTER TABLE `carrelli_articoli`
    ADD CONSTRAINT `carrelli_articoli_ibfk_01`             FOREIGN KEY (`id_carrello`) REFERENCES `carrelli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `carrelli_articoli_ibfk_02_nofollow`    FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `carrelli_articoli_ibfk_03_nofollow`    FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `carrelli_articoli_ibfk_98_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `carrelli_articoli_ibfk_99_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202207120100
CREATE OR REPLACE VIEW carrelli_articoli_view AS
	SELECT
		carrelli_articoli.id,
		carrelli_articoli.id_carrello,
		carrelli_articoli.id_articolo,
		carrelli_articoli.id_iva,
		carrelli_articoli.prezzo_netto_unitario,
		carrelli_articoli.prezzo_lordo_unitario,
		carrelli_articoli.quantita,
		carrelli_articoli.prezzo_netto_totale,
		carrelli_articoli.prezzo_lordo_totale,
		carrelli_articoli.sconto_percentuale,
		carrelli_articoli.sconto_valore,
		carrelli_articoli.prezzo_netto_finale,
		carrelli_articoli.prezzo_lordo_finale,
		carrelli_articoli.id_account_inserimento,
		carrelli_articoli.id_account_aggiornamento
	FROM carrelli_articoli;
    
--| FINE