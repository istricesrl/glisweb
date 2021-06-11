ALTER TABLE `tipologie_todo`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `se_ordinaria` (`se_ordinaria`),
	ADD KEY `se_chiamata` (`se_chiamata`),
	ADD KEY `indice` (`id`,`nome`,`se_pianificata`,`se_richiesta`,`se_imprevista`, `se_ordinaria`, `se_chiamata`);