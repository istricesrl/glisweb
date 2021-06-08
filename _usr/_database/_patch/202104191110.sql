ALTER TABLE `sostituzioni_progetti`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unico` (`id_progetto`,`id_anagrafica`,`data_scopertura`),
  ADD KEY `id_progetto` (`id_progetto`),
  ADD KEY `id_anagrafica` (`id_anagrafica`);