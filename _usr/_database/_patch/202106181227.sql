ALTER TABLE `certificazioni`
 ADD PRIMARY KEY (`id`), ADD KEY `nome` (`nome`), ADD KEY `id_anagrafica` (`id_anagrafica`), ADD KEY `id_emittente` (`id_emittente`), ADD KEY `data_scadenza` (`data_scadenza`), ADD KEY `id_tipologia` (`id_tipologia`);
 