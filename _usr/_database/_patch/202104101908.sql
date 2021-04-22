ALTER TABLE `__report_attivita_assenze__`
	ADD UNIQUE KEY `unico` (`id_attivita`,`id_anagrafica`,`data_assenza`), 
	ADD KEY `id_attivita` (`id_attivita`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`);