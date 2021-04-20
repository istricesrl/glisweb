ALTER TABLE `pause_progetti`
	ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `unico` (`id_progetto`,`data_inizio`,`data_fine`), ADD KEY `id_progetto` (`id_progetto`);