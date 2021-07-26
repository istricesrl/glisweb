ALTER TABLE `anagrafica_certificazioni`
 ADD PRIMARY KEY (`id`), 
 ADD KEY `id_anagrafica` (`id_anagrafica`), 
 ADD KEY `id_certificazione` (`id_certificazione`), 
 ADD KEY `id_emittente` (`id_emittente`),
 ADD KEY `data_scadenza` (`data_scadenza`);
ALTER TABLE `anagrafica_certificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
