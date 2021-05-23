ALTER TABLE `todo_view_static`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_cliente` (`id_cliente`),
	ADD KEY `id_tipologia` (`id_tipologia`), 
	ADD KEY `id_progetto` (`id_progetto`),	
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_responsabile` (`id_responsabile`), 
	ADD KEY `id_pianificazione` (`id_pianificazione`),
	ADD KEY `data_programmazione` (`data_programmazione`),
	ADD KEY `id_mastro_attivita_default` (`id_mastro_attivita_default`);