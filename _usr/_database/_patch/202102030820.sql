ALTER TABLE `ruoli_progetti`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_genitore` (`id_genitore`), 
	ADD UNIQUE KEY `nome` (`nome`);
