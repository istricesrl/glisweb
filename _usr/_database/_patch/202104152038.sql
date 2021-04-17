ALTER TABLE `orari_contratti`
 ADD UNIQUE KEY `unico_lavoro` (`id_contratto`,`turno`,`id_giorno`,`ora_inizio`,`ora_fine`,`se_lavoro`), 
 ADD UNIQUE KEY `unico_disponibile` (`id_contratto`,`turno`,`id_giorno`,`ora_inizio`,`ora_fine`,`se_disponibile`);