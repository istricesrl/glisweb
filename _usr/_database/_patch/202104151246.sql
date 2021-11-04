ALTER TABLE `obiettivi_tracking`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `unico` (`id_obiettivo`,`id_tracking`), ADD KEY `id_obiettivo` (`id_obiettivo`), ADD KEY `id_tracking` (`id_tracking`);

