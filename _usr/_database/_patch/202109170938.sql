ALTER TABLE `sostituzioni_attivita`
 DROP INDEX `unico`,
 ADD UNIQUE KEY `unico` (`id_attivita`,`id_anagrafica`,`data_richiesta`);
