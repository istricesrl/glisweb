ALTER TABLE `obiettivi_anagrafica`   ADD UNIQUE KEY `unico` (`id_obiettivo`,`nome_colonna`, `valore_colonna`), ADD KEY `id_obiettivo` (`id_obiettivo`);
