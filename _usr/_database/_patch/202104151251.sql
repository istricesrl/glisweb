ALTER TABLE `obiettivi_anagrafica` ADD UNIQUE KEY `unico` (`id_obiettivo`,`id_anagrafica`), ADD KEY `id_obiettivo` (`id_obiettivo`), ADD KEY `id_anagrafica` (`id_anagrafica`);
