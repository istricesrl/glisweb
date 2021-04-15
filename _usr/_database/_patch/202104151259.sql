ALTER TABLE `obiettivi_articoli` ADD UNIQUE KEY `unico` (`id_obiettivo`,`id_articolo`), ADD KEY `id_obiettivo` (`id_obiettivo`), ADD KEY `id_articolo` (`id_articolo`);
