--
-- INDICI
-- questo file contiene le query per la creazione degli indici delle tabelle
--
-- NOTE
--
--

--| 000003000001

-- account
-- tipologia: tabella gestita
ALTER TABLE `account`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`username`),
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `id_mail` (`id_mail`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `se_attivo` (`se_attivo`),
	ADD KEY `token` (`token`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`username`,`password`,`se_attivo`,`token`);
ALTER TABLE `account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000002

-- account_gruppi
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`id_account`,`id_gruppo`),
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_gruppo` (`id_gruppo`),
	ADD KEY `indice` (`id`,`id_account`,`id_gruppo`);
ALTER TABLE `account_gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000003

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi_attribuzione`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_account`,`id_gruppo`,`entita`), 
	ADD KEY `id_account` (`id_account`), 
	ADD KEY `id_gruppo` (`id_gruppo`);
ALTER TABLE `account_gruppi_attribuzione` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000004

-- anagrafica
-- tipologia: tabella gestita
ALTER TABLE `anagrafica`	
	ADD PRIMARY KEY (`id`), 	
	ADD UNIQUE KEY `unica` (`codice`), 	
	ADD UNIQUE KEY `unica_persone` (`nome`,`cognome`,`codice_fiscale`), 	
	ADD UNIQUE KEY `unica_aziende` (`denominazione`,`partita_iva`,`codice_fiscale`), 	
	ADD KEY `id_tipologia` (`id_tipologia`),
	ADD KEY `id_tipologia_crm` (`id_tipologia_crm`), 	
	ADD KEY `id_agente` (`id_agente`), 	
	ADD KEY `id_pec_sdi` (`id_pec_sdi`), 	
	ADD KEY `id_regime_fiscale` (`id_regime_fiscale`), 	
	ADD KEY `id_orientamento_sessuale` (`id_orientamento_sessuale`), 	
	ADD KEY `id_stato_nascita` (`id_stato_nascita`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 	
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `se_importata` (`se_importata`),
	ADD KEY `se_stampa_privacy` (`se_stampa_privacy`),
	ADD KEY `riferimento` (`riferimento`),
	ADD KEY `indice` (`id`,`nome`,`cognome`,`denominazione`);
ALTER TABLE `anagrafica` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;	

--| 000003000005

-- anagrafica_categorie
-- tipologia: tabella gestita
ALTER TABLE `anagrafica_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_anagrafica`,`id_categoria`), 
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_anagrafica`,`id_categoria`);
ALTER TABLE `anagrafica_categorie` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| FINE FILE
