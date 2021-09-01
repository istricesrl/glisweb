ALTER TABLE `progetti_certificazioni`
 ADD PRIMARY KEY (`id`), 
 ADD KEY `id_progetto` (`id_progetto`), 
 ADD KEY `id_certificazione` (`id_certificazione`);
ALTER TABLE `progetti_certificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
