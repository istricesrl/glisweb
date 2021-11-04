ALTER TABLE `fasi_strategie` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `unico` (`ordine`,`nome`,`id_strategia`), ADD KEY `id_strategia` (`id_strategia`), ADD KEY `nome` (`nome`);
