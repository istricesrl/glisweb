ALTER TABLE `__report_progetti_assenze__`
	ADD UNIQUE KEY `unico` (`id_progetto`,`id_anagrafica`,`data_assenza`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`);