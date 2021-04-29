--
-- INDICI
-- questo file contiene le query per la creazione degli indici delle tabelle
--

--| 000003000001

-- account
-- tipologia: tabella gestita
ALTER TABLE `account`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `username` (`username`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `se_attivo` (`se_attivo`), 
	ADD KEY `indice` (`id`,`id_anagrafica`,`username`,`password`,`se_attivo`,`token`), 
	ADD KEY `id_mail` (`id_mail`);
ALTER TABLE `account` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 000003000002

-- account_gruppi
-- tipologia: tabella gestita
ALTER TABLE `account_gruppi`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `indice` (`id_account`,`id_gruppo`),
	ADD KEY `id_account` (`id_account`),
	ADD KEY `id_gruppo` (`id_gruppo`);
ALTER TABLE `account_gruppi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| FINE FILE
