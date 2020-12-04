ALTER TABLE `anagrafica_servizi_contatto`
    ADD PRIMARY KEY (`id`), 
    ADD UNIQUE KEY `unico` (`id_anagrafica`,`id_servizio_contatto`), 
    ADD KEY `id_servizio_contatto` (`id_servizio_contatto`), 
    ADD KEY `id_anagrafica` (`id_anagrafica`);