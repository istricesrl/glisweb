ALTER TABLE `cartellini`
 ADD PRIMARY KEY (`id`), 
 ADD UNIQUE KEY `unica` (`id_anagrafica`,`data_attivita`,`id_tipologia_inps`), 
 ADD KEY `id_anagrafica` (`id_anagrafica`), 
 ADD KEY `data_attivita` (`data_attivita`), 
 ADD KEY `id_tipologia_inps` (`id_tipologia_inps`);
