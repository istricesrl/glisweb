ALTER TABLE `categorie_attivita`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD KEY `indice` (`id`,`id_genitore`,`nome`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);
