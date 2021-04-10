ALTER TABLE `ruoli_progetti`
	ADD KEY `se_responsabile_qualita` (`se_responsabile_qualita`), 
	ADD KEY `se_coordinatore` (`se_coordinatore`), 
	ADD KEY `se_responsabile_amministrativo` (`se_responsabile_amministrativo`), 
	ADD KEY `se_responsabile_servizi` (`se_responsabile_servizi`), 
	ADD KEY `se_operativo` (`se_operativo`);