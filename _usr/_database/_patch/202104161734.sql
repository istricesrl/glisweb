ALTER TABLE `obiettivi_tipologie_progetti`   ADD UNIQUE KEY `unico` (`id_obiettivo`,`nome_colonna`, `valore_colonna`), ADD KEY `id_obiettivo` (`id_obiettivo`);
