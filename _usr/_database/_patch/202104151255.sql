ALTER TABLE `obiettivi_prodotti` ADD UNIQUE KEY `unico` (`id_obiettivo`,`id_prodotto`), ADD KEY `id_obiettivo` (`id_obiettivo`), ADD KEY `id_prodotto` (`id_prodotto`);
