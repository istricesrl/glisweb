ALTER TABLE `articoli_caratteristiche`
    ADD PRIMARY KEY (`id`), 
    ADD UNIQUE KEY `id_articolo` (`id_articolo`,`id_caratteristica`), 
    ADD KEY `ordine` (`ordine`), 
    ADD KEY `indice` (`id`,`id_articolo`,`id_caratteristica`,`ordine`), 
    ADD KEY `id_caratteristica` (`id_caratteristica`);