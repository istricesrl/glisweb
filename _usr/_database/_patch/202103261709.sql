ALTER TABLE `caratteristiche_articoli`
    ADD PRIMARY KEY (`id`),
    ADD UNIQUE KEY `nome` (`nome`),
    ADD KEY `indice` (`id`,`nome`);