ALTER TABLE `documenti`
 ADD PRIMARY KEY (`id`), ADD KEY `id_tipologia` (`id_tipologia`), ADD KEY `id_destinatario` (`id_destinatario`), ADD KEY `id_sede_destinatario` (`id_sede_destinatario`), ADD KEY `id_emittente` (`id_emittente`), ADD KEY `id_sede_emittente` (`id_sede_emittente`), ADD KEY `id_account_inserimento` (`id_account_inserimento`), ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`);