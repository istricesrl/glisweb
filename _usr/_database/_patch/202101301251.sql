ALTER TABLE `progetti_anagrafica`
 ADD PRIMARY KEY (`id`), 
 ADD KEY `id_progetto` (`id_progetto`), 
 ADD KEY `id_anagrafica` (`id_anagrafica`), 
 ADD KEY `id_ruolo` (`id_ruolo`);