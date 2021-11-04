ALTER TABLE `attivita_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_attivita`,`id_categoria`), 
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `indice` (`id`,`id_attivita`,`id_categoria`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_attivita` (`id_attivita`);
