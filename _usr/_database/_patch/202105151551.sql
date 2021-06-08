ALTER TABLE `__report_sostituzioni_attivita__`
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unico` (`id_attivita`,`id_anagrafica`), 
	ADD KEY `id_attivita` (`id_attivita`), 
	ADD KEY `id_anagrafica` (`id_anagrafica`),
	ADD KEY `punteggio` (`punteggio`),
	ADD KEY `punti_sostituto` (`punti_sostituto`), 
	ADD KEY `punti_progetto` (`punti_progetto`),
	ADD KEY `punti_disponibilita` (`punti_disponibilita`),
	ADD KEY `punti_distanza` (`punti_distanza`); 