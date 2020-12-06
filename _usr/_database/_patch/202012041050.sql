ALTER TABLE `anagrafica_provenienze`
    ADD PRIMARY KEY (`id`), 
    ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_provenienza`), 
    ADD KEY `id_provenienza` (`id_provenienza`), 
    ADD KEY `id_anagrafica` (`id_anagrafica`);