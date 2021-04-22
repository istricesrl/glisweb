ALTER TABLE `sostituzioni_attivita`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `unico` (`id_attivita`,`id_anagrafica`), ADD KEY `id_anagrafica` (`id_anagrafica`), ADD KEY `id_attivita` (`id_attivita`);