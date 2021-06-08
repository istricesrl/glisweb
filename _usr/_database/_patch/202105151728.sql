ALTER TABLE `progetti_categorie`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_progetto`,`id_categoria`), 
	ADD KEY `id_categoria` (`id_categoria`), 
	ADD KEY `indice` (`id`,`id_progetto`,`id_categoria`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `id_progetto` (`id_progetto`);
