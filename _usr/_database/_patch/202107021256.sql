ALTER TABLE `fasce_orari_contratti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_contratto` (`id_contratto`),
	ADD KEY `turno` (`turno`),
	ADD KEY `id_giorno` (`id_giorno`),
	ADD KEY `ora_inizio` (`ora_inizio`),
	ADD KEY `ora_fine` (`ora_fine`),	
	ADD KEY `id_tipologia_inps` (`id_tipologia_inps`);
